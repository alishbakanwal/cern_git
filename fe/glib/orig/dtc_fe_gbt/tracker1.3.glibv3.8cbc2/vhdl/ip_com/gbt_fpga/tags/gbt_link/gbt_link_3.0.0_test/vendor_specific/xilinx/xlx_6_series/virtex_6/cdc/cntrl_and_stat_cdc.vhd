--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	12/06/2013     																			--
-- Project Name:				cntrl_and_stat_cdc              														--
-- Module Name:   		 	cntrl_and_stat_cdc 	   			 													--
-- 																																--
-- Language:					VHDL'93                                      									--
--																																	--
-- Target Devices: 			GLIB (Virtex 6)   																		--
-- Tool versions: 			13.2                 																	--
--																																	--
-- Revision:		 			1.0 																							--
--																																	--
-- Additional Comments: 																									--
--																																	--
--=================================================================================================--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

-- Custom libraries and packages:
use work.gbt_link_package.all;

--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--

entity cntrl_and_stat_cdc_bridge is
	port (   
   
      RX_WORDCLK_I             	   : in	std_logic;              
      INTERFACE_CLK_I           	   : in	std_logic;         
      
      INT_GTX_RX_SLIDE_ENABLE_I 	   : in	std_logic;
      INT_GTX_RX_SLIDE_CTRL_I	  	   : in	std_logic;
      INT_GTX_RX_SLIDE_RUN_I    	   : in	std_logic;
      INT_GTX_RX_SLIDE_NBR_I    	   : in	std_logic_vector(4 downto 0);
      -------------------------- 
      GTX_RX_SLIDE_ENABLE_O     	   : out	std_logic;
      GTX_RX_SLIDE_CTRL_O       	   : out	std_logic;
      GTX_RX_SLIDE_RUN_O        	   : out	std_logic;
      GTX_RX_SLIDE_NBR_O        	   : out	std_logic_vector(4 downto 0);
      
      
      GBT_RX_ALIGNED_I           	: in	std_logic;
      GBT_RX_BIT_SLIP_NBR_I      	: in	std_logic_vector(4 downto 0);
      --------------------------
      INT_GBT_RX_ALIGNED_O       	: out	std_logic;
      INT_GBT_RX_BIT_SLIP_NBR_O  	: out	std_logic_vector(4 downto 0)   
     
	);
end cntrl_and_stat_cdc_bridge;
architecture structural of cntrl_and_stat_cdc_bridge is

begin

   -- Control:
   cntrlCdcBridge: entity work.clk_domain_bridge
      generic map (
         N                       => 8)
      port map (
         WRCLK_I						=> INTERFACE_CLK_I,
         WDATA_I(7)					=> INT_GTX_RX_SLIDE_ENABLE_I,        
         WDATA_I(6)					=> INT_GTX_RX_SLIDE_CTRL_I,	 
         WDATA_I(5)					=> INT_GTX_RX_SLIDE_RUN_I,   
         WDATA_I(4 downto 0)		=> INT_GTX_RX_SLIDE_NBR_I,               
         ------------------------
         RDCLK_I						=> RX_WORDCLK_I,
         RDATA_O(7)					=> GTX_RX_SLIDE_ENABLE_O,
         RDATA_O(6)					=> GTX_RX_SLIDE_CTRL_O,  
         RDATA_O(5)					=> GTX_RX_SLIDE_RUN_O,   
         RDATA_O(4 downto 0)		=> GTX_RX_SLIDE_NBR_O   
         );   
   
   -- Status:
   statCdcBridge: entity work.clk_domain_bridge
      generic map(
         N                       => 6)
      port map(
         WRCLK_I						=> RX_WORDCLK_I,
         WDATA_I(5)					=> GBT_RX_ALIGNED_I,     
         WDATA_I(4 downto 0)		=> GBT_RX_BIT_SLIP_NBR_I,
         ------------------------
         RDCLK_I						=> INTERFACE_CLK_I,
         RDATA_O(5)					=> INT_GBT_RX_ALIGNED_O,     
         RDATA_O(4 downto 0)		=> INT_GBT_RX_BIT_SLIP_NBR_O
      );
         
--=====================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--         