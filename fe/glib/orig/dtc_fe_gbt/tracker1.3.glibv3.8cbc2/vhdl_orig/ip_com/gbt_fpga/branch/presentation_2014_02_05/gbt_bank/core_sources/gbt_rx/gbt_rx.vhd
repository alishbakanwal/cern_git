--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:                CERN (PH-ESE-BE)                                                         
-- Engineer:               Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                            
--                                                                                                 
-- Project Name:           GBT-FPGA                                                                
-- Module Name:            GBT RX                                      
--                                                                                                 
-- Language:               VHDL'93                                                                  
--                                                                                                   
-- Target Device:          Device agnostic                                                         
-- Tool version:                                                                       
--                                                                                                   
-- Current version:        1.0                                                                      
--
-- Description:             
--
-- Versions history:       DATE         VERSION   AUTHOR              DESCRIPTION
--
--                         04/07/2013   1.0       M. Barros Marin     - First .vhd module definition
--
--- Additional Comments:                                                                               
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_link_package.vhd").                                !!  
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<hardware_platform>_gbt_link_user_setup.vhd".   !!
-- !!                                                                                           !!
-- !!   (Note!! These parameters are vendor specific).                                          !!                    
-- !!                                                                                           !! 
-- !! * The "<hardware_platform>_gbt_link_user_setup.vhd" is the only file of the GBT Bank that !!
-- !!   may be modified by the user. The rest of the files MUST be used as is.                  !!
-- !!                                                                                           !!  
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                                                                                                   
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_rx is
   generic (   
      GBT_BANK_ID                               : integer := 1   
   );
   port (
   
      --================--
      -- Reset & Clocks --
      --================--       
   
      RX_RESET_I                                : in  std_logic;
      RX_WORDCLK_I                              : in  std_logic;
      RX_FRAMECLK_I                             : in  std_logic;
                     
      --=========--                                
      -- Control --                                
      --=========-- 
      
      -- Encoding selector:
      ---------------------
      
      -- Comment: ('01' -> Wide-bus | '10' -> 8b10b | 'others' -> GBT frame)
      
      -- Comment: Note!! 8b10b not implemented yet.
      
      RX_ENCODING_SEL_I                         : in  std_logic_vector(1 downto 0);
      
      -- MGT RX ready:
      ----------------   
      
      RX_MGT_RDY_I                              : in  std_logic;
      
      --========--
      -- Status --
      --========--
      
      DESCR_RDY_O                               : out std_logic;
      RX_BITSLIP_NBR_O                          : out std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      RX_HEADER_FLAG_O                          : out std_logic;
      RX_HEADER_LOCKED_O                        : out std_logic;
      RX_ISDATA_FLAG_O                          : out std_logic;
      
      --=============--                                
      -- Word & Data --                                
      --=============--                                
      
      -- Common:
      ----------
      
      RX_WORD_I                                 : in  std_logic_vector(WORD_WIDTH-1 downto 0);
      RX_DATA_O                                 : out std_logic_vector(83 downto 0);

      -- Wide-bus:
      ------------

      RX_WIDEBUS_EXTRA_DATA_O                   : out std_logic_vector(31 downto 0) 
      
   );  
end gbt_rx;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_rx is

   --================================ Signal Declarations ================================--
   
   --===============--
   -- Frame aligner --
   --===============--
   
   signal rxHeaderLocked_from_frameAligner      : std_logic;
   signal rxWriteAddress_from_frameAligner  	   : std_logic_vector(WORD_ADDR_MSB downto 0);
   signal alignedRxWord_from_frameAligner       : std_logic_vector(WORD_WIDTH-1 downto 0);  
   
   --=========--
   -- Gearbox --
   --=========--
   
   signal dv_from_rxGearbox                     : std_logic;
   signal rxFrame_from_rxGearbox                : std_logic_vector(119 downto 0);
  
   --=========--
   -- Decoder --
   --=========-- 
   
   signal rxIsDataFlag_from_decoder             : std_logic;
   signal dv_from_decoder                       : std_logic;
   signal rxFrame_from_decoder                  : std_logic_vector(83 downto 0);
   signal rxWidebusExtraFrame_from_decoder      : std_logic_vector(31 downto 0);   
  
   --=====================================================================================-- 
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
  
   --==================================== User Logic =====================================--
   
   --===============--
   -- Frame aligner --
   --===============--
   
   frameAligner: entity work.gbt_rx_framealigner   
      port map (
         RX_RESET_I                             => RX_RESET_I,
         RX_WORDCLK_I                           => RX_WORDCLK_I,
         ---------------------------------------
         RX_MGT_RDY_I                           => RX_MGT_RDY_I,
         ---------------------------------------
         RX_HEADER_LOCKED_O                     => rxHeaderLocked_from_frameAligner,
         RX_HEADER_FLAG_O                       => RX_HEADER_FLAG_O,
         ---------------------------------------
         RX_BITSLIP_NBR_O                       => RX_BITSLIP_NBR_O,
         ---------------------------------------         
         RX_WRITE_ADDRESS_O                     => rxWriteAddress_from_frameAligner,
         ---------------------------------------
         RX_WORD_I                              => RX_WORD_I,
         ALIGNED_RX_WORD_O                      => alignedRxWord_from_frameAligner
      );
      
   RX_HEADER_LOCKED_O                           <= rxHeaderLocked_from_frameAligner;  

   --=========--
   -- Gearbox --
   --=========--
   
   rxGearbox: entity work.gbt_rx_gearbox
      generic map (
         GBT_BANK_ID                            => GBT_BANK_ID)
      port map (              
         RX_RESET_I                             => RX_RESET_I, 
         RX_WORDCLK_I                           => RX_WORDCLK_I, 
         RX_FRAMECLK_I                          => RX_FRAMECLK_I, 
         ---------------------------------------
         RX_HEADER_LOCKED_I                     => rxHeaderLocked_from_frameAligner,
         RX_WRITE_ADDRESS_I                     => rxWriteAddress_from_frameAligner,
         DV_O                                   => dv_from_rxGearbox,
         ---------------------------------------
         RX_WORD_I                              => alignedRxWord_from_frameAligner,
         RX_FRAME_O                             => rxFrame_from_rxGearbox
   );  
  
   --=========--
   -- Decoder --
   --=========--       
  
   decoder: entity work.gbt_rx_decoder 
      generic map (
         GBT_BANK_ID                            => GBT_BANK_ID)
      port map (
         RX_RESET_I                             => RX_RESET_I,
         RX_FRAMECLK_I                          => RX_FRAMECLK_I, 
         ---------------------------------------
         RX_ENCODING_SEL_I                      => RX_ENCODING_SEL_I,
         ---------------------------------------
         DV_I                                   => dv_from_rxGearbox,
         DV_O                                   => dv_from_decoder,         
         RX_ISDATA_FLAG_O                       => rxIsDataFlag_from_decoder,
         ---------------------------------------
         RX_FRAME_I                             => rxFrame_from_rxGearbox,
         RX_FRAME_O                             => rxFrame_from_decoder,
         ---------------------------------------
         RX_WIDEBUS_EXTRA_FRAME_O               => rxWidebusExtraFrame_from_decoder
      ); 
      
   --=============--
   -- Descrambler --
   --=============--   
   
   descrambler: entity work.gbt_rx_descrambler
      port map (
         RX_RESET_I                             => RX_RESET_I, 
         RX_FRAMECLK_I                          => RX_FRAMECLK_I, 
         ---------------------------------------
         DV_I                                   => dv_from_decoder,
         DV_O                                   => DESCR_RDY_O,
         RX_ISDATA_FLAG_I                       => rxIsDataFlag_from_decoder,
         RX_ISDATA_FLAG_O                       => RX_ISDATA_FLAG_O,
         ---------------------------------------
         RX_FRAME_I                             => rxFrame_from_decoder,
         RX_DATA_O                              => RX_DATA_O,
         ---------------------------------------
         RX_WIDEBUS_EXTRA_FRAME_I               => rxWidebusExtraFrame_from_decoder,
         RX_WIDEBUS_EXTRA_DATA_O                => RX_WIDEBUS_EXTRA_DATA_O
      );   
   
   --=====================================================================================--  
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--