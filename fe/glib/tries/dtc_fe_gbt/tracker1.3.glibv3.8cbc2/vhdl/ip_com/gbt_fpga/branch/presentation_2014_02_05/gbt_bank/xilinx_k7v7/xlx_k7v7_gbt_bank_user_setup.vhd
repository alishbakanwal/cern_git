--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          Xilinx Kintex 7 & Virtex 7 - GBT Bank user setup                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         Xilinx Kintex 7 & Virtex 7                                                          
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Revision:              1.0                                                                      
--
-- Description:           The user can setup the different parameters of the GBT Banks by modifying
--                        this file.
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        23/10/2013   1.0       M. Barros Marin   - First .vhd definition           
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
use work.vendor_specific_gbt_bank_package.all;

--=================================================================================================--
--##################################   Package Declaration   ######################################--
--=================================================================================================--

package gbt_banks_user_setup is
   
   --================================= GBT Banks parameters ==============================--   
   
   --=====================--
   -- Number of GBT Banks --
   --=====================--
   
   -- Comment:   * On Kintex 7 & Virtex 7 it is possible to implement up to FOUR links per GBT Bank
   --
   --            * If more links than allowed per GBT Bank are needed, then it is 
   --              necessary to instantiate more GBT Banks        
   
   constant NUM_GBT_BANKS                       : integer := 1;
   
   --=================--
   -- GBT Banks setup --
   --=================--
   
   -- Comment: For more information about the record "GBT_BANKS_USER_SETUP" see the file:
   --          "../gbt_bank/<vendor>_<device>/<vendor>_<device>_gbt_link_package.vhd"             
   
   constant GBT_BANKS_USER_SETUP : gbt_bank_user_setup_R_A(1 to NUM_GBT_BANKS) := (
      
      -- GBT Bank 1:
      --------------     
      
      1 => (NUM_LINKS                           => 1,             -- Comment: * 1 to 4                
            OPTIMIZATION                        => "LAT",         --          * ("STD" -> standard | "LAT" -> latency)                  
            TX_GBT_FRAME                        => true,          
            RX_GBT_FRAME                        => false,          
            TX_WIDE_BUS                         => false,          
            RX_WIDE_BUS                         => true,          
            TX_8B10B                            => false,         
            RX_8B10B                            => false,         
            STD_MGT_REFCLK_FREQ                 => FREQ_120MHz,   
            RX_GTX_BUFFBYPASS_MANUAL            => false,         -- Comment: Default (false) (See UG476 page 239-244).         
            SIMULATION                          => false,         
            SIM_GTRESET_SPEEDUP                 => false)--,            

      -- GBT Bank 2:
      -------------- 
      
--    2 => (NUM_LINKS                           => 4,             -- Comment: * 1 to 4                     
--          OPTIMIZATION                        => "STD",         --          * ("STD" -> standard | "LAT" -> latency)                         
--          TX_GBT_FRAME                        => true,                      
--          RX_GBT_FRAME                        => true,                                 
--          TX_WIDE_BUS                         => true,                                 
--          RX_WIDE_BUS                         => true,                                 
--          TX_8B10B                            => true,                                 
--          RX_8B10B                            => true,                             
--          STD_MGT_REFCLK_FREQ                 => FREQ_120MHz,   
--          RX_GTX_BUFFBYPASS_MANUAL            => false,         -- Comment: Default (false) (See UG476 page 239-244).                           
--          SIMULATION                          => false                
--          SIM_GTRESET_SPEEDUP                 => false)               
   
   );

   --=====================================================================================--      
end gbt_banks_user_setup;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--