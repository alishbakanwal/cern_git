
--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   19/12/2012     																			
-- Project Name:			cdce_phase_monitoring_v2      														
-- Module Name:   		cdce_phase_mon_v2_wrapper     	 													
-- 																															
-- Language:				VHDL'93                                          								
--																																
-- Target Devices: 		GLIB (Virtex 6)																			
-- Tool versions: 		13.2              																		
--																																
-- Revision:		 		1.0 																							
--																																
-- Additional Comments: 																								
--																																
--=================================================================================================--
--=================================================================================================--
-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity cdce_phase_mon_v2_wrapper is	
	port (	
      -- Reset:
      RESET_I                       : in  std_logic;
      -- COMMON CLOCKS: 
      IPBUS_CLK_I                   : in  std_logic;
      TTCLK_I	                     : in  std_logic;
      UNRELATED_CLK_I               : in  std_logic;
      -- SFP:  
      SFP_TTCLK_X6_CDCE_I           : in  std_logic;      
      SFP_THRESHOLD_UPPER_I         : in  std_logic_vector( 7 downto 0);
      SFP_THRESHOLD_LOWER_I         : in  std_logic_vector( 7 downto 0);
      SFP_MONITORING_STATS_O        : out std_logic_vector(15 downto 0);     
      SFP_DONE_O                    : out std_logic;   
      SFP_PHASE_OK_O                : out std_logic;    
      -- FMC1:       
      FMC1_TTCLK_X6_CDCE_I          : in  std_logic;     
      FMC1_THRESHOLD_UPPER_I        : in  std_logic_vector( 7 downto 0);
      FMC1_THRESHOLD_LOWER_I        : in  std_logic_vector( 7 downto 0);
      FMC1_MONITORING_STATS_O       : out std_logic_vector(15 downto 0);
      FMC1_DONE_O                   : out std_logic;      
      FMC1_PHASE_OK_O               : out std_logic        
	);
end cdce_phase_mon_v2_wrapper;
architecture structural of cdce_phase_mon_v2_wrapper is	
	--======================== Signal Declarations ========================--	
	signal ttclk_x6					   : std_logic; 	
	signal sfp_ttclk_x6_cdce			: std_logic; 
   signal fmc1_ttclk_x6_cdce			: std_logic; 
   --=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--===================== Component Instantiations ======================--
   -- BUFGs:   
	sfp_ttclk_x6_cdce_bufg: bufg 
      port map (
         I                          => SFP_TTCLK_X6_CDCE_I,
         O                          => sfp_ttclk_x6_cdce
      );
 	fmc1_ttclk_x6_cdce_bufg: bufg 
      port map (
         I                          => FMC1_TTCLK_X6_CDCE_I,
         O                          => fmc1_ttclk_x6_cdce
      );   
   -- TTCLK PLL:
   ttclk_pll: entity work.ttclk_mmcm
      port map (
         CLK_IN1                    => TTCLK_I,
         CLK_OUT1                   => ttclk_x6,
         RESET                      => '0',
         LOCKED                     => open
      );   
   -- SFP:
   sfp_cdce_pm: entity work.cdce_phase_mon_v2
      port map (
         RST_I                       => RESET_I,
         ---------------------------      
         IPBUS_CLK_I                 => IPBUS_CLK_I,
         TTCLK_X6_I                  => ttclk_x6,	
         TTCLK_X6_CDCE_I             => sfp_ttclk_x6_cdce,
         UNRELATED_CLK_I             => UNRELATED_CLK_I,
         ---------------------------      
         THRESHOLD_UPPER_I           => SFP_THRESHOLD_UPPER_I,
         THRESHOLD_LOWER_I           => SFP_THRESHOLD_LOWER_I,
         ---------------------------      
         DEBUG_TEST_D_CLK_O          => open,
         DEBUG_TEST_D_CLK_CDCE_O     => open,
         DEBUG_TEST_XOR_O            => open,
         DEBUG_TEST_XOR_MCLK_O       => open,
         DEBUG_MONITORING_STATS_O    => open,
         ---------------------------      
         MONITORING_STATS_O          => SFP_MONITORING_STATS_O,
         DONE_O                      => SFP_DONE_O,            
         PHASE_OK_O                  => SFP_PHASE_OK_O               
      );
   -- FMC1:
   fmc1_cdce_pm: entity work.cdce_phase_mon_v2
      port map (
         RST_I                       => RESET_I,
         ---------------------------      
         IPBUS_CLK_I                 => IPBUS_CLK_I,
         TTCLK_X6_I                  => ttclk_x6,	
         TTCLK_X6_CDCE_I             => fmc1_ttclk_x6_cdce,
         UNRELATED_CLK_I             => UNRELATED_CLK_I,
         ---------------------------      
         THRESHOLD_UPPER_I           => FMC1_THRESHOLD_UPPER_I,
         THRESHOLD_LOWER_I           => FMC1_THRESHOLD_LOWER_I,
         ---------------------------    
         DEBUG_TEST_D_CLK_O          => open,
         DEBUG_TEST_D_CLK_CDCE_O     => open,
         DEBUG_TEST_XOR_O            => open,
         DEBUG_TEST_XOR_MCLK_O       => open,
         DEBUG_MONITORING_STATS_O    => open,
         ---------------------------      
         MONITORING_STATS_O          => FMC1_MONITORING_STATS_O,
         DONE_O                      => FMC1_DONE_O,            
         PHASE_OK_O                  => FMC1_PHASE_OK_O            
      );
   --=====================================================================--   
end structural;
--=================================================================================================--
--=================================================================================================--