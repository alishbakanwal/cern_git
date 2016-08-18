--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          Xilinx Virtex 6 - GBT Link user setup                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         Xilinx Virtex 6                                                          
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Revision:              1.0                                                                      
--
-- Description:           The user can setup the different parameters of the GBT Link by modifying
--                        this file.
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        24/06/2013   1.0       M. Barros Marin   - First .vhd definition           
--
-- Additional Comments:                                                                               
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Link are set through:                               !!  
-- !!                                                                                           !!
-- !!    - The different MGT control ports of the GBT Link module (these ports are listed in    !!
-- !!      the records of the file "<vendor>_<device>_gbt_link_package.vhd").                   !!  
-- !!                                                                                           !!  
-- !!    - By modifying the content of the file "<vendor>_<device>_gbt_link_user_setup.vhd".    !!
-- !!                                                                                           !!
-- !!      (Note!! These parameters are vendor specific).                                       !!                    
-- !!                                                                                           !! 
-- !! * The "<vendor>_<device>_gbt_link_user_setup.vhd" is the only file of the GBT Link that   !!
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
use work.vendor_specific_gbt_link_package.all;

--=================================================================================================--
--##################################   Package Declaration   ######################################--
--=================================================================================================--

package gbt_link_user_setup is
   
   --================================ GBT Link parameters ================================--     
   
   --=====================--
   -- Number of GBT Links --
   --=====================--
   
   -- Comment: The number of GBT Links is device dependant.
   
   constant NUM_GBT_LINK                        : integer := 1; 
   
   --=======================--
   -- GBT Link optimization --
   --=======================--
   
   -- Type of optimization:
   ------------------------
   
   -- Comment: "STANDARD" or "LATENCY" 
   
   constant OPTIMIZATION                        : string  := "LATENCY";   
   
   -- Latency-optimized GTX RX bitslip mode: 
   -----------------------------------------
   
   -- Comment: * Note!! Clock phase shift MUST be set to YES for deterministic latency operation.
   --
   --          * Clock phase shift: "PMA" -> YES | "PCS"      -> NO 
   --            Clock phase shift: false -> YES | true/false -> NO    
   
   constant RX_SLIDE_MODE                       : string  := "PMA";   
   constant SHOW_REALIGN_COMMA                  : boolean := false;   
   
   --===============--
   -- GBT encodings --
   --===============--
   
   constant GBTFRAME                            : boolean := true;
   constant WIDEBUS                             : boolean := true;
   constant ENC8B10B                            : boolean := false;  -- Comment: Note!! Not implemented yet.
   
   --=====================--
   -- GTX Clocking scheme --
   --=====================--

   -- GTX reference clock:
   -----------------------
   
   -- Comment: Allowed STANDARD GTX frequencies: 96MHz, 120MHz, 150MHz, 192MHz, 240MHz, 300MHz, 480MHz and 600MHz   

   constant STD_MGT_REFCLK_FREQ                 : integer := FREQ_240MHz;      
   
   -- Comment: * Note!! The reference clock frequency of the LATENCY-OPTIMIZED MGT can not be set by 
   --                   the user. For the Virtex 6 GTX, it is fixed to 240MHz.         
   
   -- GTX fabric clocks:
   ----------------------   
   
   -- Comment: * Default setup: BUFG
   --
   --          * When using BUFG, TXOUTCLK from GTX1 is used to generate TXUSRCLK2 for all GTXs of the quad.
   --   
   --          * When bypassing the buffers, TXOUTCLK/TXUSRCLK2 and RXRECCLK/RXUSRCLK2 of all GTX are forwarded  
   --            out from the GBT Link so the user can connect the buffers as desired. 

   constant TXOUTCLK_BUFFER_TYPE                : string  := "BUFG";   -- Comment: ("BUFG" or "BYPASS")
   constant RXRECCLK_BUFFER_TYPE                : string  := "BUFG";   -- Comment: ("BUFG" or "BYPASS") 
            
   --============--        
   -- Simulation --        
   --============--           
   
   -- Comment: (0 -> Normal | 1 -> Speedup)
   
   constant SPEEDUP_FOR_SIMULATION              : integer := 0;                      
   
   --=====================================================================================--      
end gbt_link_user_setup;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--