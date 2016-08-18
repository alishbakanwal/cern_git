--=================================================================================================--
--=================================== Package Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   14/11/2012      																			
-- Module Name:			pcie_bert            																	
-- Package Name:   		pcie_bert_package																			
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
--=================================================================================================--
--================================== Package Declaration ==========================================-- 
--=================================================================================================--
package user_pcie_bert_package is

	--====================== Constant Declarations ========================--  
	constant	DMA_RDCHANNEL_BIT 			       : integer := 2;		
	constant	DMA_WRCHANNEL_BIT	   		       : integer := 1;   
   --=====================================================================--
   --======================== Type Declarations ==========================--
  	-- Pattern Generator control FSM:
   type T_pgState is (e0_idle, e1_start, e2_resetPrbs, e3_enablePchk, e4_stop); 
	-- Pattern Checker FSM:
	type T_pchkState is (e0_idle, e1_fillPrbsFifo, e2_waitTranssaction, e3_startDly, e4_start,
                        e6_reset, e7_stop);
	-- PRBS:
	type tap_array is array (0 to 3) of integer;	
	type seedT is array (0 to 2) of std_logic_vector(6 downto 0);   
	--=====================================================================--
 	--======================= Record Declarations =========================--
	type R_pcieBert_from_bert is		
		record					
			doubleDWcntr					         : std_logic_vector(28 downto 0);
         error_cntr         						: std_logic_vector(31 downto 0);
			error_flag         						: std_logic;
			noerr_flag      							: std_logic;
	end record;				
	type R_pcieBert_to_bert is		
		record		
			reset										   : std_logic;	
			cntrReset								   : std_logic;	
	end record;		
	--=====================================================================--
end user_pcie_bert_package;
--=================================================================================================--
--=================================================================================================--