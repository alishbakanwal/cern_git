--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   08/12/2011																					
-- Project Name:			glib_sram_interface																		
-- Module Name:   		glib_sram_interface							 											
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
entity glib_sram_interface is	
	port (			
		-- Logic Fabric side:		
		RESET_I													: in 	std_logic;
		CLK_I														: in 	std_logic;
		CS_I														: in 	std_logic;
		WRITE_I													: in 	std_logic;
		ADDR_I													: in 	std_logic_vector(20 downto 0);
		DATA_I													: in 	std_logic_vector(35 downto 0);
		DATA_O													: out std_logic_vector(35 downto 0);
		-- SRAM side:			
		CLK_O														: out std_logic;
		CE1_B_O													: out std_logic;	-- Chip Enable
		CEN_B_O													: out std_logic;	-- Clock Enable		
		OE_B_O													: out std_logic;
		WE_B_O													: out std_logic;
		TRISTATECTRL_O											: out std_logic;
		MODE_O													: out std_logic;	-- Burst Mode
		ADV_LD_O													: out std_logic;		
		ADDR_O													: out std_logic_vector(20 downto 0);		
		SRAM_DATA_I												: in 	std_logic_vector(35 downto 0);
		SRAM_DATA_O												: out std_logic_vector(35 downto 0)	
	);
end glib_sram_interface;
architecture structural of glib_sram_interface is	
	--======================== Signal Declarations ========================--		
	-- Registers:
	signal data_i_rr											: std_logic_vector(35 downto 0);
	signal data_i_r											: std_logic_vector(35 downto 0);	
	--=====================================================================--	
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--
	--========================= Port Assignments ==========================--		
	CLK_O															<= CLK_I;
	MODE_O														<= '0'; -- Burst Mode('1'-> interleaved / '0'-> linear)
	ADV_LD_O														<= '0'; -- Burst Mode('1'-> adv address / '0'-> load address)						
	--=====================================================================--
	--============================ User Logic =============================--	
	-- Control process:
	control_process: process(RESET_I, CLK_I)		
		constant WRITEDELAY									: natural := 2;	-- 2 (These are the correct values)
		constant READDELAY									: natural := 3;	-- 3 	
		variable startWrite									: boolean;
		variable dataToSram									: boolean;
		variable startRead									: boolean;			
		variable dataFromSram								: boolean;
		variable done											: boolean;			
		variable idleState 									: idleStateT;		
		variable writeState 									: writeStateT;		
		variable readState 									: readStateT;	
		variable counter 										: natural range 0 to READDELAY; 	
		variable readCounter 								: natural range 0 to READDELAY; 
	begin		
		if RESET_I = '1' then
			-- Registers:	(When writing, the data has to be 2 clock cycles delayed than the address)
			data_i_rr											<= (others => '0');
		   data_i_r												<=	(others => '0');			
			-- Control:					
			startWrite											:= false;	
			dataToSram											:= false;	
			startRead											:= false;			
			dataFromSram										:= false;
			done													:= false;	
			idleState 											:= e0_startIdle;
			writeState  										:= e0_idle;
			readState   										:= e0_idle;
			counter												:= 0;			
			readCounter											:= 0;		
			CE1_B_O												<= '1';		
			CEN_B_O												<= '1';		
			WE_B_O												<= '1';		
			TRISTATECTRL_O										<= '1';	-- 'Z'			
			OE_B_O												<= '1';	-- 'Z'			
			ADDR_O												<= (others => '0');
			SRAM_DATA_O											<= (others => '0');			
		elsif rising_edge(CLK_I) then	
			-- Registered address out:	
			ADDR_O												<=	ADDR_I;					
			-- Read or Write control:
			case idleState is				-- The CS and the RW pins work as strobe signals
				when e0_startIdle =>		-- (just one pulse is needed)
					if CS_I = '1' then
						idleState							:= e1_stopIdle;							
						if WRITE_I = '1' then			
							startWrite						:= true;							
						elsif WRITE_I = '0' then
							startRead						:= true;										
						end if;
					end if;
				when e1_stopIdle =>								
					if done = true then
						idleState							:= e0_startIdle;
						startWrite							:= false;
						startRead							:= false;	
						done									:= false;														
					end if;
			end case;		
			-- Write:			
				-- Write control:
				case writeState is 
					when e0_idle => 								
						if startWrite = true then
							writeState						:= e1_write;
							dataToSram						:= true;		
							CE1_B_O							<= '0';
							CEN_B_O							<= '0';					
							WE_B_O							<= '0';	
							TRISTATECTRL_O					<= '0';								
						end if;		
					when e1_write => 						
						if CS_I = '0' then
							writeState						:= e2_writeEnd;							
							CE1_B_O							<= '1';	
							WE_B_O							<= '1';	
						end if;
					when e2_writeEnd =>								
						if counter = WRITEDELAY - 1 then
							writeState						:= e0_idle;
							dataToSram						:= false;
							done								:= true;
							counter							:= 0;				
							CEN_B_O							<= '1';										
							TRISTATECTRL_O					<= '1';	-- 'Z'								
						else
							counter 							:= counter + 1;
						end if;
				end case;
				-- Write data:
				if dataToSram = true then
					-- Registers:
					-- (When writing, the data has to be 2 clock cycles delayed than the address)		
					SRAM_DATA_O								<= data_i_rr;												
					data_i_rr								<= data_i_r;
					data_i_r									<=	DATA_I;						
				else
					SRAM_DATA_O								<= (others => '0');						
					data_i_rr								<= (others => '0');
					data_i_r									<=	(others => '0');						
				end if;				
			-- Read:
				-- Read control:
				case readState is 
					when e0_idle => 
						if startRead = true then
							readState						:= e1_read;
							dataFromSram					:= true; 
							CE1_B_O							<= '0';
							CEN_B_O							<= '0';												
							OE_B_O							<= '0';														
						end if;
					when e1_read =>
						if CS_I = '0' then
							readState						:= e2_readEnd;
							CE1_B_O							<= '1';							
						end if;							
					when e2_readEnd =>							
						if counter = READDELAY - 1 then
							readState						:= e0_idle;	
							counter							:= 0;	
							dataFromSram					:= false;	
							done								:= true;																	
							CEN_B_O							<= '1';															
							OE_B_O							<= '1';	-- 'Z'											
						else
							counter 							:= counter + 1;						
						end if;							
				end case;
				-- Read data:					
				if dataFromSram = true then								
					if readCounter > READDELAY - 1 then
						DATA_O								<= SRAM_DATA_I;	
					else
						readCounter 						:= readCounter + 1;						
					end if;	
				else	
					DATA_O									<= (others => '0');	
					readCounter 							:=	0;		
				end if;						
		end if;		
	end process;	
	--=====================================================================--					
end structural;
--=================================================================================================--
--=================================================================================================--