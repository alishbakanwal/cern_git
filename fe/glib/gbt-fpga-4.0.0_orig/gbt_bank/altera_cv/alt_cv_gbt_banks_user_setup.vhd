--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          Altera Cyclone V GT - GBT Banks user setup                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         Altera Cyclone V GT                                                          
-- Tool version:          Quartus II 13.1                                                                
--                                                                                                   
-- Revision:              3.0                                                                      
--
-- Description:           The user can setup the different parameters of the GBT Banks by modifying
--                        this file.
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        09/03/2014   3.0       M. Barros Marin   - First .vhd package definition           
--
-- Additional Comments:                                                                               
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!   (Note!! These parameters are vendor specific)                                           !!                    
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_bank_package.vhd").                                !! 
-- !!     (e.g. xlx_v6_gbt_bank_package.vhd)                                                    !!
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<hardware_platform>_gbt_banks_user_setup.vhd".  !!
-- !!     (e.g. xlx_v6_gbt_banks_user_setup.vhd)                                                !! 
-- !!                                                                                           !! 
-- !! * The "<hardware_platform>_gbt_banks_user_setup.vhd" is the only file of the GBT Bank     !!
-- !!   that may be modified by the user. The rest of the files MUST be used as is.             !!
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
   
   -- Comment:   * On Cyclone V it is possible to implement up to THREE links per GBT Bank.
   --
   --            * If more links than allowed per GBT Bank are needed, then it is 
   --              necessary to instantiate more GBT Banks.        
   
   constant NUM_GBT_BANKS                       : integer := 1;
   
   --=================--
   -- GBT Banks setup --
   --=================--
   
   -- Comment: For more information about the record "GBT_BANKS_USER_SETUP" see the file:
   --          "../gbt_bank/altera_cv/alt_cv_gbt_link_package.vhd"   
   
   constant GBT_BANKS_USER_SETUP : gbt_bank_user_setup_R_A(1 to NUM_GBT_BANKS) := (
      
      -- GBT Bank 1:
      --------------     
      
      1 => (NUM_LINKS                           => 1,                   -- Comment: * 1 to 3                
            ------------------------------------
            TX_OPTIMIZATION                     => STANDARD,   			--          * (STANDARD) Warning: Latency optimized not supported by                 
            RX_OPTIMIZATION                     => STANDARD,            --          * (STANDARD)          this device.        
            ------------------------------------
            TX_ENCODING                         => GBT_FRAME,           --          * (GBT_FRAME or WIDE_BUS or GBT_8B10B)          
            RX_ENCODING                         => GBT_FRAME)--,        --          * (GBT_FRAME or WIDE_BUS or GBT_8B10B)

      -- GBT Bank 2:
      -------------- 
      
--    2 => (NUM_LINKS                           => 3,                   -- Comment: * 1 to 3                
--          ------------------------------------                        
--          TX_OPTIMIZATION                     => STANDARD,            --          * (STANDARD or LATENCY_OPTIMIZED)                  
--          RX_OPTIMIZATION                     => STANDARD,            --          * (STANDARD or LATENCY_OPTIMIZED)                  
--          ------------------------------------                        
--          TX_ENCODING                         => GBT_FRAME,           --          * (GBT_FRAME or WIDE_BUS or GBT_8B10B)          
--          RX_ENCODING                         => WIDE_BUS,            --          * (GBT_FRAME or WIDE_BUS or GBT_8B10B) 
   
   );

   --=====================================================================================--      
end gbt_banks_user_setup;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--