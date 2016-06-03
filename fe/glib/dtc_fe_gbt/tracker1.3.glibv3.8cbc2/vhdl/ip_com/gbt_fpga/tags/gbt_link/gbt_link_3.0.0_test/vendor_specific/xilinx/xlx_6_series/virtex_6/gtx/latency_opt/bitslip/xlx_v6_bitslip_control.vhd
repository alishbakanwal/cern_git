--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	26/10/2011 																					--
-- Project Name:				bitslip_control																			--
-- Module Name:   		 	bitslip_control							 												--
-- 																																--
-- Language:					VHDL'93																						--
--																																	--
-- Target Devices: 			GLIB (Virtex 6)																			--
-- Tool versions: 			ISE 13.2																						--
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
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity bitslip_control is
	generic (	
		DELAYBETWEENBITSLIPS						: natural := 20 -- Note!!! DELAYBETWEENBITSLIPS >= 16 RXUSRCLK2 cycles
	);	
	port (	
		RESET_I										: in std_logic;
		RXWORDCLK_I									: in std_logic;
		NUMBITSLIPS_I								: in std_logic_vector(4 downto 0);
		ENABLE_I									: in std_logic;
		BITSLIP_O									: out std_logic		
	);
end bitslip_control;
architecture structural of bitslip_control is
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--============================ User Logic =============================--
	-- Main process of the module:
	main_process: process(RESET_I, RXWORDCLK_I)
		type stateT is (e0_idle, e1_bitslipOrFinish, e2_doBitslip, e3_wait16cycles);
		variable state								: stateT;
		variable bitslips							: unsigned(4 downto 0);
		variable	counter							: natural range 0 to DELAYBETWEENBITSLIPS - 1;	
	begin 
		if RESET_I = '1' then
			state										:= e0_idle;
			bitslips									:= (others => '0');
			counter									:= 0;
			BITSLIP_O								<= '0';
		elsif rising_edge(RXWORDCLK_I) then
			-- Finite State Machine(FSM):
			case state is 
				when e0_idle => 
					if ENABLE_I = '1' then
						state							:= e1_bitslipOrFinish;
						bitslips						:= unsigned(NUMBITSLIPS_I);						
					end if;
				when e1_bitslipOrFinish =>					
					if bitslips = 0 then
						if ENABLE_I = '0' then 
							state							:= e0_idle;
						end if;	
					else
						state							:= e2_doBitslip;
						bitslips						:= bitslips - 1;
					end if;					
				when e2_doBitslip =>					
					state								:= e3_wait16cycles;
					BITSLIP_O						<= '1';				
				when e3_wait16cycles =>
					BITSLIP_O						<= '0';
					if counter = DELAYBETWEENBITSLIPS - 1 then
						state							:= e1_bitslipOrFinish;
						counter 						:= 0;
					else
						counter 						:= counter + 1;
					end if;
			end case;
		end if;
	end process;
	--=====================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--