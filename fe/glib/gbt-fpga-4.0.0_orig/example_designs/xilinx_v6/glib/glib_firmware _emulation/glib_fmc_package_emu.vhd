--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                       
-- Company:               CERN (PH-ESE-BE)                                                        
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          GLIB - GLIB FMC package emulation                                      
--                                                                                                 
-- Language:              VHDL'93                                                           
--                                                                                                 
-- Target Device:         GLIB (Xilinx Virtex 6)                                                        
-- Tool version:          ISE 14.5                                                                              
--                                                                                                 
-- Revision:              1.0                                                                     
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/08/2013   1.0       M. Barros Marin   - First .vhd package definition 
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

--=================================================================================================--
--##################################   Package Declaration   ######################################--
--=================================================================================================--

package glib_fmc_package_emu is  
  
   --================================ Record Declarations ================================--
   
	type fmc_io_pin_type is
	record
		la_p				: std_logic_vector(0 to 33);
		la_n				: std_logic_vector(0 to 33);
		ha_p				: std_logic_vector(0 to 23);
		ha_n				: std_logic_vector(0 to 23);
		hb_p				: std_logic_vector(0 to 21);
		hb_n				: std_logic_vector(0 to 21);
   end record;
   
   --=====================================================================================--     
end glib_fmc_package_emu;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--