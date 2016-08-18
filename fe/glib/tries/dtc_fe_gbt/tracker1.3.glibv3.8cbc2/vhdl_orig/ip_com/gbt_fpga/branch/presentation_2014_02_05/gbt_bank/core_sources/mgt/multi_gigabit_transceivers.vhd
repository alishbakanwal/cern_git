--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Multi Gigabit Transceivers
--                                                                                                 
-- Language:              VHDL'93                                                                 
--                                                                                                   
-- Target Device:         Vendor agnostic                                                        
--                                                                                                   
-- Revision:              1.0                                                                      
--
-- Description:           
--
-- Versions history:      DATE         VERSION   AUTHOR              DESCRIPTION
--
--                        04/11/2013   1.0       M. Barros Marin     - First .vhd module definition           
--
-- Additional Comments:                                                                               
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
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity multi_gigabit_transceivers is
   generic (
      GBT_BANK_ID                               : integer := 1
   );
   port (
   
      --===============--
      -- Clocks scheme --
      --===============--
      
      MGT_CLKS_I                                : in  gbtBankMgtClks_i_R;
      MGT_CLKS_O                                : out gbtBankMgtClks_o_R;        
        
      --=========--
      -- MGT I/O --
      --=========--
      
      MGT_I                                     : in  mgt_i_R_A           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
      MGT_O                                     : out mgt_o_R_A           (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
      
      --=============--
      -- GBT control --
      --=============--

      GBT_RX_MGT_RDY_O                          : out std_logic_vector    (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
      ------------------------------------------
      GBT_RX_HEADER_LOCKED_I                    : in  std_logic_vector    (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
      GBT_RX_BITSLIP_NBR_I                      : in  gbtRxSlideNbr_nbit_A(1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);
     
      --=======--
      -- Words --
      --=======--
      
      GBT_TX_WORD_I                             : in  word_nbit_A         (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS);     
      GBT_RX_WORD_O                             : out word_nbit_A         (1 to GBT_BANKS_USER_SETUP(GBT_BANK_ID).NUM_LINKS)     

   );
end multi_gigabit_transceivers;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of multi_gigabit_transceivers is      

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
  
   --==================================== User Logic =====================================--   
   
   --============================--
   -- Multi-Gigabit Transceivers --
   --============================--
   
   -- Standard optimization:
   -------------------------
   
   mgtStd_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).OPTIMIZATION /= "LAT" generate   -- Comment: "STD"
   
      mgtStd: entity work.mgt_std
         generic map (
            GBT_BANK_ID                         => GBT_BANK_ID)
         port map (
            -- Clocks:         
            MGT_CLKS_I                          => MGT_CLKS_I,
            MGT_CLKS_O                          => MGT_CLKS_O,
            -- MGT I/O:                   
            MGT_I                               => MGT_I,
            MGT_O                               => MGT_O,
            -- GBT control: 
            GBT_RX_MGT_RDY_O                    => GBT_RX_MGT_RDY_O,
            -- Words:         
            GBT_TX_WORD_I                       => GBT_TX_WORD_I,   
            GBT_RX_WORD_O                       => GBT_RX_WORD_O
         );
         
   end generate;   
      
   -- Latency optimization:
   ------------------------
   
   mgtLatOpt_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).OPTIMIZATION = "LAT" generate 

      mgtLatOpt: entity work.mgt_latopt
         generic map (
            GBT_BANK_ID                         => GBT_BANK_ID)
         port map (
            -- Clocks:         
            MGT_CLKS_I                          => MGT_CLKS_I,
            MGT_CLKS_O                          => MGT_CLKS_O,
            -- MGT I/O:                   
            MGT_I                               => MGT_I,
            MGT_O                               => MGT_O,
            -- GBT control: 
            GBT_RX_MGT_RDY_O                    => GBT_RX_MGT_RDY_O,
            GBT_RX_HEADER_LOCKED_I              => GBT_RX_HEADER_LOCKED_I,
            GBT_RX_BITSLIP_NBR_I                => GBT_RX_BITSLIP_NBR_I,  
            -- Words:         
            GBT_TX_WORD_I                       => GBT_TX_WORD_I,   
            GBT_RX_WORD_O                       => GBT_RX_WORD_O
         );
   
   end generate;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--