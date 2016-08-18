--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   08/12/2011																					
-- Project Name:			glib_sram_interface																		
-- Module Name:   		glib_sram_interface_bist							 									
-- 																															
-- Language:				VHDL'93																						
--																																
-- Target Devices: 		GLIB (Virtex 6)																			
-- Tool versions: 		ISE 13.2																						
--																																
-- Revision:		 		2.6 																							
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
-- User libraries and packages:
use work.system_flash_sram_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity glib_sram_interface_bist is
	generic (
		MAXADDRESSWRITE									: natural := 2*(2**20) - 1;	-- 2M positions of the memory
		INITIALDELAY										: natural := 160;	
		READDATADELAY     								: natural := 20;
		PRBSENABLEDELAY  									: natural := 4;					-- 4 (These are the correct values)					
		COMPAREDATADELAY  								: natural := 3						-- 3 
	);
	port (
		SEED_I												: in 	std_logic_vector(6 downto 0);
		RESET_I												: in 	std_logic;			
		CLK_I													: in 	std_logic;		
		ENABLE_I												: in 	std_logic;		 
		CS_O													: out	std_logic; 
		WRITE_O												: out std_logic; 
		ADDR_O												: out std_logic_vector(20 downto 0);
		DATA_O												: out std_logic_vector(35 downto 0);		
		DATA_I												: in 	std_logic_vector(35 downto 0);
		ERRINJECT_I											: in 	std_logic;	-- Note!! The writing flag asserts one cycle 		
		STARTERRINJ_O										: out std_logic;  -- before to start the writing to be able to 		
		TESTDONE_O	    									: out std_logic;	-- inject errors in the first position of the
		TESTRESULT_O         							: out std_logic;  -- memory(It only asserts for one clock cycle)
		ERRORCOUNTER_O										: out std_logic_vector(20 downto 0)			 		
	);	
	end glib_sram_interface_bist;
architecture structural of glib_sram_interface_bist is		
	--======================== Signal Declarations ========================--
	-- Delay Registers:	(All control signals go out from the control at the same time)
		-- Address delay:					
		signal addr_r										: std_logic_vector(20 downto 0);			
		signal addr_rr										: std_logic_vector(20 downto 0);	
		signal addr_rrr									: std_logic_vector(20 downto 0);	
		-- Control delay:		
		signal cs_r											: std_logic;
		signal cs_rr										: std_logic;
		signal cs_rrr										: std_logic;
		signal write_r										: std_logic;
		signal write_rr									: std_logic;
		signal write_rrr									: std_logic;
		signal startErrInj_r								: std_logic;
		signal startErrInj_rr							: std_logic;
	-- FSM signals:
	signal prbsReset_from_fsm  						: std_logic;
	signal prbsEnable_from_fsm 						: std_logic;
	-- PRBS generator signals:		
	signal data_from_prbsPatterGenerator			: std_logic_vector(35 downto 0);		
	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--============================ User Logic =============================--	
	-- Error injection multiplexor:			
	DATA_O													<= x"F000F000F" when ERRINJECT_I = '1'
																	else data_from_prbsPatterGenerator;	
	-- Secuential logic:	
	main_process: process(RESET_I, CLK_I)			 
		variable state				 						: bistStateT;		
		variable counter			 						: natural;
		variable addressEnable							: boolean;
		variable addressCounter	 						: unsigned(20 downto 0);
		variable compareData								: boolean;
		variable errorCounter 							: unsigned(20 downto 0);
	begin		
		if RESET_I = '1' then	
			state												:=	e0_idle;
			counter		   								:=	0;
			addressEnable									:= false;
			addressCounter									:= (others => '0');
			compareData										:= false;
			errorCounter									:=	(others => '0');
			ADDR_O											<= (others => '0');			 
		   addr_r											<= (others => '0'); 
		   addr_rr											<= (others => '0'); 
			addr_rrr											<= (others => '0');	
			CS_O       										<= '0';	
		   cs_r   											<= '0';	
			cs_rr      										<=	'0';
			cs_rrr      									<=	'0';
			WRITE_O											<= '0';	
		   write_r             							<= '0';	
			write_rr            							<= '0';	
			write_rrr           							<= '0';			
			prbsReset_from_fsm       					<= '1';	
			prbsEnable_from_fsm     					<= '0';
			TESTDONE_O	     								<= '0';	
			TESTRESULT_O    								<= '0';			
			ERRORCOUNTER_O									<= (others => '0');
			STARTERRINJ_O									<= '0';
			startErrInj_r									<= '0';
			startErrInj_rr 								<= '0';			
		elsif rising_edge(CLK_I) then			
			-- Delay Registers:	
				-- Address delay:	
				ADDR_O										<= addr_r;
				addr_r										<= addr_rr;
				addr_rr										<= addr_rrr;		
				-- Control delay:				
				CS_O											<=	cs_r;
				cs_r											<=	cs_rr;
				cs_rr											<=	cs_rrr;				
				WRITE_O										<=	write_r;
				write_r										<=	write_rr;
				write_rr										<=	write_rrr;
				STARTERRINJ_O								<= startErrInj_r;
				startErrInj_r								<= startErrInj_rr;						
			-- Finite State Machine(FSM):
			case state is
				-- Write:
				when e0_idle =>
					if ENABLE_I = '1' then
						state 								:= e1_initialDelay;
					end if;					
				when e1_initialDelay =>					
						if counter = INITIALDELAY - 1 then					
							state 							:= e2_writeData;
							counter							:= 0;	
							addressEnable					:= true;	
							write_rrr						<= '1';
							cs_rrr							<= '1';
							prbsReset_from_fsm			<= '0';	
							prbsEnable_from_fsm			<= '1';	
							startErrInj_rr					<= '1';  
						else												
							counter 							:= counter + 1;
						end if;					
				when e2_writeData =>
					startErrInj_rr								<= '0';	
					if counter = MAXADDRESSWRITE - 1 then
						state									:= e3_readDataDelay;
						counter								:= 0;	
						addressEnable						:= false;	
						write_rrr							<= '0';	
						cs_rrr								<= '0';																			
						prbsEnable_from_fsm				<= '0';											
					else	
						counter								:= counter + 1;													
					end if;
				-- Read and Compare: 	
				when e3_readDataDelay =>					
					if counter = 3 - 1 then				-- The PRBS generator has 3 cycles of latency						
						prbsReset_from_fsm				<= '1';
					end if;				
					if counter = READDATADELAY - 1 then					
						state 								:= e4_readData;
						counter								:= 0;	
						addressEnable						:= true;	
                  cs_rrr								<= '1';
						write_rrr							<= '0';                                						
					else	
						counter 								:= counter + 1;
					end if;	
				when e4_readData =>	
					if counter = PRBSENABLEDELAY - 1 then
						state 								:= e5_compareDataDelay;
						counter								:= 0;
						prbsReset_from_fsm				<= '0';
						prbsEnable_from_fsm				<= '1';
					else
						counter								:= counter + 1;																		
					end if;					
				when e5_compareDataDelay =>
					if counter = COMPAREDATADELAY - 1 then
						state									:= e6_compareData;
						counter								:= 0;		
					else
						counter								:= counter + 1;																		
					end if;				
				when e6_compareData =>					
					compareData								:= true;					
					if addressCounter > MAXADDRESSWRITE - 1 then
						addressEnable						:= false;
						cs_rrr								<= '0';
						write_rrr           				<= '0';
					end if;				
					if counter = MAXADDRESSWRITE - 1 then
						state									:= e7_testResult;	
						counter								:= 0;	
						compareData							:= false;			
						prbsReset_from_fsm				<= '1';	
						prbsEnable_from_fsm				<= '0';			
					else	
						counter								:= counter + 1;								
					end if;	
				when e7_testResult =>
					TESTDONE_O	     						<= '1';
					if errorCounter = 0 then	
						TESTRESULT_O    					<= '1'; 
					end if;
					state										:= e0_idle;				
			end case;				
			-- Address assignment:
			if addressEnable = true then
				addr_rrr										<= std_logic_vector(addressCounter);
				addressCounter								:=	addressCounter + 1;
			else 
				addr_rrr										<= (others => '0');
				addressCounter								:= (others => '0');
			end if;			
			-- Data comparator:	
			if compareData = true then
				if DATA_I /= data_from_prbsPatterGenerator then
					errorCounter							:= errorCounter + 1;	
					ERRORCOUNTER_O							<= std_logic_vector(errorCounter);		
				end if;	
			end if;	
		end if;
	end process;	
	--=====================================================================--		
	--===================== Component Instantiations ======================--
	-- PRBS pattern generator:
	prbsPatterGenerator: entity work.PRBS
		generic map (
			W													=> 36)		
		port map (				
			clock 											=> CLK_I,
			areset 											=> prbsReset_from_fsm,
			enable 											=> prbsEnable_from_fsm,
			seed 												=> SEED_I,
			sdv 												=> open,
			sdata 											=> open,
			pdv 												=> open,
			pdata												=> data_from_prbsPatterGenerator			
		);		
	--=====================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--