--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Paschalis Vichoudis (Original design)												
--								Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--																															
-- Create Date:		   21/07/2011		 																			
-- Project Name:			glibDemoLinkArchitecture																
-- Module Name:   		glibLink_rst_ctrl		 										
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
entity glibLink_rst_ctrl is	
	generic(
		INITIAL_DELAY	  								: natural := 1 * 40000000; -- 1s     @ 41.6667MHz 	
		TIME_N		  									: natural := 		  40000; -- 1ms    @ 41.6667MHz
	   TIME_A   		  								: natural :=		4000000; -- 100ms  @ 41.6667MHz
		GTXDEASSERT_DELAY								: natural :=          400; -- 10us   @ 41.6667MHz 
		GAP_DELAY										: natural := 3 * 40000000  -- 3s     @ 41.6667MHz
	);
	port(	
		-- Clock:
		CLK_I												: in  std_logic;
		-- Reset:				
		RESET_I											: in  std_logic;	
		-- Reset outputs:
		GTX_TXRESET_O									: out std_logic;	 	
		GTX_RXRESET_O									: out std_logic;	 
		GBT_TXRESET_O									: out std_logic;	
		GBT_RXRESET_O									: out std_logic;	
		-- Control:
		BUSY_O											: out std_logic;	
		DONE_O											: out std_logic		
	);
end glibLink_rst_ctrl;
architecture structural of glibLink_rst_ctrl is	
	--======================== Signal Declarations ========================--	
	signal clk	 			  							: std_logic;			
	signal reset 										: std_logic;
	--=====================================================================--
	--======================= Constant Declarations =======================--
	-- Calculations to be able to get the correct timings automatically (only the values of the "generics" are needed):
	constant c_timeIsDeassertGtxTxReset  : natural := GTXDEASSERT_DELAY - 1;
	constant c_timeIsN 						 : natural := (TIME_N - GTXDEASSERT_DELAY) - 1;
	constant c_timeIs3Nplus3A 			 	 : natural := ((2*TIME_N + 3*TIME_A) + GAP_DELAY) - 1;
	constant c_timeIsDeassertGtxRxReset  : natural := GTXDEASSERT_DELAY - 1;
	constant c_timeIs4Nplus3A 			 	 : natural := (TIME_N - GTXDEASSERT_DELAY) - 1;
	constant c_timeIs4Nplus4A				 : natural := TIME_A - 1;
	--=====================================================================--		
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--
-- TIMING DIAGRAM:
--
-- Control ports: 
--                                                                                                                                  
--	         +-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
--  BUSY_O  |                                                                                                                                                                                                                                                     |  
-- ---------+                                                                                                                                                                                                                                                     +------
--	                                                                                                                                                                                                                                                               +------
--  DONE_O                                                                                                                                                                                                                                                        |
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
--
--
-- Link: "TYPE_1A", "TYPE_1B", "TYPE_2A", "TYPE_2B" 
--
--	                                     +-+
--  GTX_TXRESET_O                       | |                                                                                              |                   |                      
-- -------------------------------------+ +----------------------------------------------------------------------------------------------+                   +----------------------------------------------------------------------------------------------------------
--				                                                                                                                             |                   |                      
--	                                     +------------------------------+				                                                     |                   |                      
--  GBT_TXRESET_O                       |                              |  	    	                                                        |                   |                      
-- -------------------------------------+                              +-----------------------------------------------------------------+                   +----------------------------------------------------------------------------------------------------------
--          time = -(INITIAL_DELAY)     time = 0                       time = n         time = n + a                   time = 2n + a     |  <=====/  /====>  | time = 2n + 2a                time = 3n + 2a   time = 3n + 3a                  time = 4n + 3a   time = 4n + 4a
--  TIME    +---------------------------+------------------------------+----------------+------------------------------+-----------------+                   +-+-----------------------------+----------------+-------------------------------+----------------+-+------
--				                                                                                                                             |                   |                      
--	                                                                                                                                      |     GAP_DELAY     |                                                +-+
--  GTX_RXRESET_O                                                                                                                        |                   |                                                | |  
-- --------------------------------------------------------------------------------------------------------------------------------------+                   +------------------------------------------------+ +-------------------------------------------------------
--				                                                                                                                             |                   |                      
--	                                                                                                                                      |                   |                                                +-------------------------------+
--  GBT_RXRESET_O                                                                                                                        |                   |                                                |                               |  
-- --------------------------------------------------------------------------------------------------------------------------------------+                   +------------------------------------------------+                               +-------------------------
--          time = -(INITIAL_DELAY)     time = 0                       time = n         time = n + a                   time = 2n + a     |  <=====/ /====>   | time = 2n + 2a                time = 3n + 2a   time = 3n + 3a                  time = 4n + 3a   time = 4n + 4a
--  TIME    +---------------------------+------------------------------+----------------+------------------------------+-----------------+                   +-+-----------------------------+----------------+-------------------------------+----------------+-+------
--                          
--====================================================================================================================================================================================================================================================================--	

	--========================= Port Assignments ==========================--	
	reset														<= RESET_I;
	clk														<= CLK_I;
	--=====================================================================--		
	--============================ User Logic =============================--
	-- Reset control finite state machine (FSM):
	type1or2resetControl_fsm: process(clk, reset)	
		type stateT is (e0_iddle, e1_assertAllTxReset, e2_deassertGtxTxReset, e3_deassertGbtTxReset,
					       e4_assertAllRxReset, e5_deassertGtxRxReset, e6_deassertGbtRxReset, e7_done);
		variable state 									: stateT;		
		variable timer										: natural range 0 to (INITIAL_DELAY + GAP_DELAY); -- This value is not used but ensures a good constraint if GAP_DELAY = 0	
	begin
		if reset = '1' then
			state												:= e0_iddle;
			timer												:= INITIAL_DELAY - 1; -- Delay to be able to press the reset in both boards			
			GTX_TXRESET_O									<= '0';			
			GBT_TXRESET_O									<= '0';	
			GTX_RXRESET_O									<= '0';			
			GBT_RXRESET_O									<= '0';	
			BUSY_O											<= '0';
			DONE_O											<= '0';
		elsif rising_edge(clk) then		
			case state is
				when e0_iddle =>		-- time = (-initial delay)
					BUSY_O									<= '1';
					DONE_O									<= '0';					
					if timer = 0 then	-- time = 0	
						state									:= e1_assertAllTxReset;
						timer									:= c_timeIsDeassertGtxTxReset; 
						GTX_TXRESET_O						<= '1';						
						GBT_TXRESET_O						<= '1';
						GTX_RXRESET_O						<= '1';	
						GBT_RXRESET_O						<= '1';	
					else		
						timer									:= timer - 1;
					end if;	
				when e1_assertAllTxReset =>			
					if timer = 0 then	-- deassert GTX_TXRESET_O		
						state									:= e2_deassertGtxTxReset;
						timer									:= c_timeIsN; 							
						GTX_TXRESET_O						<= '0';							
						GBT_TXRESET_O						<= '1';	
						GTX_RXRESET_O						<= '1';							
						GBT_RXRESET_O						<= '1';								
					else
						timer									:= timer - 1;
					end if;				
				when e2_deassertGtxTxReset =>		
					if timer = 0 then -- time = n		
						state									:= e3_deassertGbtTxReset;
						timer									:= c_timeIs3Nplus3A; 					
						GTX_TXRESET_O						<= '0';							
						GBT_TXRESET_O						<= '0';	
						GTX_RXRESET_O						<= '1';					
						GBT_RXRESET_O						<= '1';							
					else		
						timer									:= timer - 1;
					end if;						
				when e3_deassertGbtTxReset =>
					if timer = 0 then	-- time = 3n + 3a			   	
				   	state									:= e4_assertAllRxReset;			---xxxxxXXXXXXXXx MOd xXXXXXXX
				   	timer									:= c_timeIsDeassertGtxRxReset; 
				   	GTX_TXRESET_O						<= '0';					   	
				   	GBT_TXRESET_O						<= '0';	
				   	GTX_RXRESET_O						<= '1';				   	
				   	GBT_RXRESET_O						<= '1';					   	
					else
						timer									:= timer - 1;
					end if;			
				when e4_assertAllRxReset =>					
					if timer = 0 then	-- deassert GTX_RXRESET_O				
						state									:= e5_deassertGtxRxReset;
						timer									:= c_timeIs4Nplus3A; 	
						GTX_TXRESET_O						<= '0';						
						GBT_TXRESET_O						<= '0';	
						GTX_RXRESET_O						<= '0';						
						GBT_RXRESET_O						<= '1';					
					else
						timer									:= timer - 1;
				end if;
				when e5_deassertGtxRxReset =>	
					if timer = 0 then	-- time = 4n + 3a					
						state									:= e6_deassertGbtRxReset; 
						timer									:= c_timeIs4Nplus4A;										
						GTX_TXRESET_O						<= '0';							
						GBT_TXRESET_O						<= '0';	
						GTX_RXRESET_O						<= '0';						
						GBT_RXRESET_O						<= '0';							
					else
						timer									:= timer - 1;
					end if;
				when e6_deassertGbtRxReset =>			
					if timer = 0 then -- time = 4n + 4a
						state									:= e7_done; 												
					else
						timer									:= timer - 1;
					end if;	
				when e7_done =>			
						BUSY_O	 							<= '0';
						DONE_O								<= '1';	
				when others =>
					null;									
			end case;
		end if;
	end process;		
	--=====================================================================--
end structural;
--=================================================================================================--
--=================================================================================================--