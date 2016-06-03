--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          GLIB - GBT Link user setup                                        
--                                                                                                 
-- Language:              VHDL'93                                                            
--                                                                                                   
-- Target Device:         GLIB - Xilinx Virtex 6                                                          
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Revision:              1.1                                                                      
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
   
   -- GBT frame:
   -------------
   
   constant TX_GBT_FRAME                        : boolean := true;   
   constant RX_GBT_FRAME                        : boolean := true;

   -- WIDE-BUS:
   ------------
   
   constant TX_WIDE_BUS                         : boolean := true;
   constant RX_WIDE_BUS                         : boolean := true;
   
   -- 8B10B:
   ---------
   
   constant TX_8B10B                            : boolean := false;  -- Comment: Note!! Not implemented yet.
   constant RX_8B10B                            : boolean := false;  -- Comment: Note!! Not implemented yet.

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
   
   -- Comment: * Default setup for GLIB: (TX_OUTCLK_BUFFER_TYPE = "BUFG") and (RX_RECCLK_BUFFER_TYPE = "BUFG")
   --
   --          * When using "BUFG" as value for the constants:
   --            - TX_USRCLK2 and/or RX_USRCLK2 are generated internally by the GBT link.
   --            - TX_OUTCLK from GTX1 is used to generate TX_USRCLK2 for all GTXs of the quad.
   --   
   --          * When using "BYPASS" as value for the constants:
   --            - TX_OUTCLK/TX_USRCLK2 and RX_RECCLK/RX_USRCLK2 of all GTX are forwarded out from the GBT Link.
   --            - The user MUST forward TX_OUTCLK to TX_USRCLK2 and/or RX_RECCLK to RX_USRCLK2 using the clocking
   --              resources of the FPGA (clock buffers, PLLs, etc.) as desired.
   --
   --          * Note!! TX_OUTCLK_BUFFER_TYPE = "BUFG" is recommended when TX_FRAMECLK is NOT generated from
   --                   TX_OUTCLK (In the case of the GLIB, TX_FRAMECLK is generated by the CDCE62005)
   
   constant TX_OUTCLK_BUFFER_TYPE               : string  := "BUFG";   -- Comment: ("BUFG" or "BYPASS")
   constant RX_RECCLK_BUFFER_TYPE               : string  := "BUFG";   -- Comment: ("BUFG" or "BYPASS") 
            
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