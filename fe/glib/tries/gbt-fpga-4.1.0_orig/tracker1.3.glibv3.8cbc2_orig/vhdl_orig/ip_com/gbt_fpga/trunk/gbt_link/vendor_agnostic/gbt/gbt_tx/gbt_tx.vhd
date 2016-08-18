--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:                CERN (PH-ESE-BE)                                                         
-- Engineer:               Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                            
--                                                                                                 
-- Project Name:           GBT-FPGA                                                                
-- Module Name:            GBT TX                                       
--                                                                                                 
-- Language:               VHDL'93                                                                  
--                                                                                                   
-- Target Device:          Device agnostic                                                         
-- Tool version:                                                                       
--                                                                                                   
-- Version:                1.0                                                                      
--
-- Description:             
--
-- Versions history:       DATE         VERSION   AUTHOR              DESCRIPTION
--
--                         04/07/2013   1.0       M. BARROS MARIN     - First .vhd module definition
--
--- Additional Comments:                                                                               
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Link are set through:                               !!  
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Link module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_link_package.vhd").                                !!  
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<hardware_platform>_gbt_link_user_setup.vhd".   !!
-- !!                                                                                           !!
-- !!   (Note!! These parameters are vendor specific).                                          !!                    
-- !!                                                                                           !! 
-- !! * The "<hardware_platform>_gbt_link_user_setup.vhd" is the only file of the GBT Link that !!
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
use work.gbt_link_user_setup.all;
use work.vendor_specific_gbt_link_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_tx is
   port (
   
      --================--
      -- Reset & Clocks --
      --================--    
   
      TX_RESET_I                                : in  std_logic;
      TX_WORDCLK_I                              : in  std_logic;
      TX_FRAMECLK_I                             : in  std_logic;
                  
      --=========--                                
      -- Control --                                
      --=========--                                
      
      -- Encoding selector:
      ---------------------
      
      -- Comment: ('01' -> Wide-bus | '10' -> 8b10b | 'others' -> GBT frame)
      
      -- Comment: Note!! 8b10b not implemented yet.
      
      TX_ENCODING_SEL_I                         : in  std_logic_vector(1 downto 0);
      
      -- TX is data selector:
      -----------------------      
      
      TX_ISDATA_SEL_I                           : in  std_logic;     
      
      --======--           
      -- Data --           
      --======--              
      
      -- Common:
      ----------
      
      TX_DATA_I                                 : in  std_logic_vector(83 downto 0);
      TX_WORD_O                                 : out std_logic_vector(WORD_WIDTH-1 downto 0); 
      
      -- Wide-bus:
      ------------
      
      TX_WIDEBUS_EXTRA_DATA_I                   : in  std_logic_vector(31 downto 0)    
    
   );  
end gbt_tx;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_tx is

   --================================ Signal Declarations ================================--
   
   --===========--
   -- Scrambler --
   --===========--   
   
   signal txHeader_from_scrambler               : std_logic_vector( 3 downto 0);
   signal txFrame_from_scrambler                : std_logic_vector(83 downto 0);      
   signal txWidebusExtraFrame_from_scrambler    : std_logic_vector(31 downto 0);   
   
   --=========--
   -- Encoder --
   --=========--    
   
   signal txFrame_from_encoder                  : std_logic_vector(119 downto 0);   
  
   --=====================================================================================--   
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

  
   --==================================== User Logic =====================================--
   
   --===========--
   -- Scrambler --
   --===========--   
   
   scrambler: entity work.gbt_tx_scrambler
      port map (                                
         TX_RESET_I                             => TX_RESET_I,
         TX_FRAMECLK_I                          => TX_FRAMECLK_I,
         ---------------------------------------  
         TX_ISDATA_SEL_I                        => TX_ISDATA_SEL_I,
         TX_HEADER_O                            => txHeader_from_scrambler,
         ---------------------------------------  
         TX_DATA_I                              => TX_DATA_I,
         TX_FRAME_O                             => txFrame_from_scrambler,
         ---------------------------------------
         TX_WIDEBUS_EXTRA_DATA_I                => TX_WIDEBUS_EXTRA_DATA_I,
         TX_WIDEBUS_EXTRA_FRAME_O               => txWidebusExtraFrame_from_scrambler
      );    

   --=========--
   -- Encoder --
   --=========--  
   
   encoder: entity work.gbt_tx_encoder
      port map (
         TX_RESET_I                             => TX_RESET_I,
         TX_FRAMECLK_I                          => TX_FRAMECLK_I,
         ---------------------------------------
         TX_ENCODING_SEL_I                      => TX_ENCODING_SEL_I,
         ---------------------------------------
         TX_HEADER_I                            => txHeader_from_scrambler,
         ---------------------------------------
         TX_FRAME_I                             => txFrame_from_scrambler,
         TX_FRAME_O                             => txFrame_from_encoder,
         ---------------------------------------
         TX_WIDEBUS_EXTRA_FRAME_I               => txWidebusExtraFrame_from_scrambler
      ); 

   --=========--
   -- Gearbox --
   --=========--
    
   txGearbox: entity work.gbt_tx_latop_gearbox    
      port map (
         TX_RESET_I                             => TX_RESET_I,
         TX_WORDCLK_I                           => TX_WORDCLK_I,
         TX_FRAMECLK_I                          => TX_FRAMECLK_I,
         ---------------------------------------
         TX_FRAME_I                             => txFrame_from_encoder,
         TX_WORD_O                              => TX_WORD_O
      );

   --=====================================================================================--  
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--