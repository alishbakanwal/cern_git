--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   05/12/2011     																			
-- Project Name:			phase_aligner_240to40MHz_6steps	      									      
-- Module Name:   		phase_aligner_240to40MHz_6steps							 					      
-- 																															
-- Language:				VHDL'93                                       									
--																																
-- Target Devices: 		GLIB (Virtex 6)																			
-- Tool versions: 		ISE 13.2          																		
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
entity phase_aligner_240to40MHz_6steps is	
	port (				
		-- Reset:		
		RESET_I											: in std_logic;
		-- Clock Input:						
		CLK240_I											: in std_logic;			
		-- Phase Shift Control:								
		NUMBERSTEPS_I									: in std_logic_vector(2 downto 0);
		SETNUMSTEPS_I									: in std_logic;
		INCDEC_PHASE_I									: in std_logic;
		DOPHASESHIFT_I									: in std_logic;		
		-- Clock Outputs:					
		CLK40_O											: out std_logic;	-- Phase aligned output1		
		CLK80_O											: out std_logic;	-- Phase aligned output2		
		CLK120A_O										: out std_logic;	-- Phase aligned output3		
		CLK120B_O										: out std_logic;	-- Phase aligned output4		
		CLK160A_O										: out std_logic;	-- Phase aligned output5		
		CLK160B_O										: out std_logic;	-- Phase aligned output6		
		CLK240_O											: out std_logic;	-- Phase aligned output7		
		-- PLL Status:							
		PLLLOCKED_O										: out std_logic;
		PHASESHIFTDONE_O								: out std_logic						
	);
end phase_aligner_240to40MHz_6steps;
architecture structural of phase_aligner_240to40MHz_6steps is	
	--======================== Signal Declarations ========================--
	-- Phase shift control:			
	signal numberSteps_unsigned					: unsigned(2 downto 0);			
	signal doPhaseShift_from_fsm					: std_logic;		
	-- pll status:				
	signal pllLocked_from_pll						: std_logic;
	signal oneStepDone_from_pll					: std_logic;
	--=====================================================================--	
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--
	--========================= Port Assignments ==========================--
	-- Control signals:		
	numberSteps_unsigned								<= unsigned(NUMBERSTEPS_I);	
	--=====================================================================--	
	--============================ User Logic =============================--
	phaseShift_process: process(RESET_I, CLK240_I)	
		type stateT is (e0_setNumSteps, e1_waitDoPhaseShift, e2_assertDoPhaseShift, e3_waitOneStepDone, 
							 e4_phaseShiftDone);
		variable state   : stateT;					 
		variable counter : integer range 0 to 1568; -- 2e3 - 1 * 224 = 1568
	begin														  -- (Each 4.16667ns step needs 224 shifts (tVCO/56=18,601ps per shift))    
		if RESET_I = '1' then
			state											:= e0_setNumSteps;
			counter										:= 0;
			doPhaseShift_from_fsm					<= '0';	
			PHASESHIFTDONE_O							<= '0';
		elsif rising_edge(CLK240_I) then
			-- Finite State Machine(FSM):
			case state is 
				when e0_setNumSteps =>					
					if SETNUMSTEPS_I	= '1' then
						PHASESHIFTDONE_O				<= '0';
						counter							:= to_integer(numberSteps_unsigned) * 224;						
						state	  							:= e1_waitDoPhaseShift;						
					end if;					
				when e1_waitDoPhaseShift =>
					if DOPHASESHIFT_I = '1' then
						state	  							:= e2_assertDoPhaseShift;	
					end if;					
				when e2_assertDoPhaseShift =>	
					doPhaseShift_from_fsm			<= '1';
					state 								:= e3_waitOneStepDone;					
				when e3_waitOneStepDone =>	
					doPhaseShift_from_fsm			<= '0';
					if oneStepDone_from_pll = '1' then
						if counter = 0 then
							state 						:= e4_phaseShiftDone;	
						else	
							counter						:= counter - 1;
							state 						:= e2_assertDoPhaseShift;
						end if;
					end if;					
				when e4_phaseShiftDone =>
					PHASESHIFTDONE_O					<= '1';
					state 								:= e0_setNumSteps;								
			end case;
			-- Registered outputs:	
			PLLLOCKED_O									<= pllLocked_from_pll;	
		end if;	
	end process;	
	--=====================================================================--		
	--===================== Component Instantiations ======================--
	-- MMCM:	                                                    -------------------------
	pll: entity work.phase_aligner_240to40MHz_6steps_mmcm	       -- MMCM Configuration: -- 
		port map (		                                           -- M = 8               -- 
			-- Reset:                                              -- D = 2               --
			RESET              						=> RESET_I,        -- OD = 24,12,8,8,6,6,4-- 
			-- Clock Input:						                      -- VCO = 960MHz        --
			CLK_IN1            						=> CLK240_I,       -- Shift = 18,601ps    --		 	       
			-- Phase Shift Control:			                         -------------------------
			PSCLK              						=> CLK240_I,
			PSEN               						=> doPhaseShift_from_fsm,
			PSINCDEC           						=> INCDEC_PHASE_I,
			PSDONE             						=> oneStepDone_from_pll,			
			-- Pll Status:						
			LOCKED             						=> pllLocked_from_pll,
			-- Clock Outputs:						
			CLK_OUT1           						=> CLK40_O,		-- Phase aligned output1				
			CLK_OUT2           						=> CLK80_O,		-- Phase aligned output2				
			CLK_OUT3           						=> CLK120A_O,	-- Phase aligned output3				
			CLK_OUT4           						=> CLK120B_O,	-- Phase aligned output4				
			CLK_OUT5           						=> CLK160A_O,	-- Phase aligned output5				
			CLK_OUT6           						=> CLK160B_O,	-- Phase aligned output6				
			CLK_OUT7           						=> CLK240_O		-- Phase aligned output7				
		);
	--=====================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--