--=================================================================================================--
--=================================== Package Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	08/12/2011		 																			--
-- Module Name:				platformFlash_interface																	--
-- Package Name:   		 	sram_package																				--
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
--=================================================================================================--
--====================================== Package Body =============================================-- 
--=================================================================================================--
package sram_package is   	
	--======================== Type Declarations ==========================--
	-- Arrays:
	type array_2x6bit  			is array (1 to 2) of std_logic_vector(5 downto 0);	
	type array_2x21bit 			is array (1 to 2) of std_logic_vector(20 downto 0);	
	type array_2x25bit 			is array (1 to 2) of std_logic_vector(24 downto 0);
	type array_2x29bit  			is array (1 to 2) of std_logic_vector(28 downto 0);
	type array_2x36bit 			is array (1 to 2) of std_logic_vector(35 downto 0);	
	-- SRAM interface FSMs:
	type testControlStateT		is (e0_userMode, e1_bistMode);
	type idleStateT 	 			is (e0_startIdle, e1_stopIdle);
	type writeStateT 	 			is (e0_idle, e1_write, e2_writeEnd);
	type readStateT 	 			is (e0_idle, e1_read, e2_readEnd); 
	type dataFromSramStateT 	is (e0_idle, e1a_userData, e1b_ipbusData, e2_disableData);	
	-- Buil In Self Test (BIST) FSM:
	type bistStateT				is (e0_idle, e1_initialDelay, e2_writeData, e3_readDataDelay, e4_readData, 
											 e5_compareDataDelay, e6_compareData, e7_testResult);
	-- Error injector FSM:
	type errorInjectStateT		is (e0_idle, e1_errorInjec);	
	-- PRBS:
	type tap_array 				is array (0 to 3) of integer;	
	type seedT 						is array (0 to 2) of std_logic_vector(6 downto 0);	
	--=====================================================================--	
	--======================= Record Declarations =========================--	
	type userSramControlR is
		record		
			reset	   									: std_logic;		
			clk											: std_logic;
			cs												: std_logic;
			writeEnable   								: std_logic;							
		end record;		
	type rBistTestR is
		record	
			startErrInj									: std_logic;
			testDone										: std_logic;
			testResult									: std_logic;	
			errCounter									: std_logic_vector(20 downto 0);
		end record;
	type wBistTestR is
		record	
			test											: std_logic;
			errInject									: std_logic;		
		end record;				
	type rSramR is
		record	
			data											: std_logic_vector(35 downto 0);
     end record;	
	type wSramR is
		record			
			clk											: std_logic;
			ce1_b											: std_logic;	-- Chip Enable		
			cen_b											: std_logic;	-- Clock Enable		
			oe_b											: std_logic;
			we_b											: std_logic;
			tristateCtrl								: std_logic;
			mode											: std_logic;
			adv_ld										: std_logic;
			addr											: std_logic_vector(24 downto 0);
			data											: std_logic_vector(35 downto 0);
		end record;	

	type userSramControlR_array is array(natural range <>) of userSramControlR;
	
	type rSramR_array is array(natural range <>) of rSramR;
	type wSramR_array is array(natural range <>) of wSramR;		
	--=====================================================================--
	--======================= Constant Declarations =======================--
	-- IPBus adapter:
	constant LATENCY									: natural  := 4;
	constant SR_SIZE									: positive := 8;
	-- PRBS:
	constant SEED_CONSTANTS 						: seedT := ("0000000", "0000001", "0000010");		
	--=====================================================================--	
end sram_package;
--=================================================================================================--
package body sram_package is
end sram_package;
--=================================================================================================--
--=================================================================================================--