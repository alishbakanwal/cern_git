--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   09/12/2011 																					
-- Project Name:			glib_sram_interface																		
-- Module Name:   		glib_sram_interface_ioControl															
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
-- The ipbubs ack adapter was done by Paschalis Vichoudis                                       
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
entity glib_sram_interface_ioControl is
	port (
		-- Control:
		USER_SELECT_I										: in  std_logic;		
		-- IPbus:
      IPBUS_RESET_I										: in  std_logic;      						
      IPBUS_CLK_I   										: in  std_logic;		
		IPBUS_STROBE_I		   							: in 	std_logic;							
      IPBUS_WRITE_I		   							: in  std_logic;							
      IPBUS_ADDR_I   									: in  std_logic_vector(31 downto 0);				
      IPBUS_WDATA_I										: in  std_logic_vector(31 downto 0);			
      IPBUS_RDATA_O										: out std_logic_vector(31 downto 0);			
      IPBUS_TEST_I 										: in  std_logic;							
      IPBUS_BIST_ERRINJECT_I 							: in  std_logic;							
		IPBUS_ACK_O											: out std_logic;
	   IPBUS_ERR_O											: out std_logic;
		-- User:	     	
		USER_RESET_I										: in  std_logic;      								
		USER_CLK_I     									: in  std_logic;
      USER_CS_I											: in  std_logic;									
      USER_WRITE_I										: in  std_logic;									
      USER_ADDR_I											: in  std_logic_vector(20 downto 0);						
      USER_DATA_I											: in  std_logic_vector(35 downto 0);								
      USER_DATA_O	   									: out std_logic_vector(35 downto 0);							
      USER_TEST_I 										: in  std_logic;								
      USER_BIST_ERRINJECT_I 							: in  std_logic;								
      -- Built In Self Test:		
      BIST_RESET_O 										: out std_logic;							
      BIST_CLK_O											: out std_logic;	
		BIST_ENABLE_O										: out std_logic;	
		BIST_ERRINJECT_O									: out std_logic;	
		BIST_CS_I 											: in  std_logic;							
      BIST_WRITE_I 										: in  std_logic;								
      BIST_ADDR_I		 									: in  std_logic_vector(20 downto 0);								
      BIST_DATA_I 										: in  std_logic_vector(35 downto 0);								
      BIST_DATA_O 										: out std_logic_vector(35 downto 0);							
      BIST_TESTDONE_I 									: in  std_logic;				
		-- SRAM interface:		
      SRAMINT_RESET_O									: out std_logic;						
      SRAMINT_CLK_O 										: out std_logic;
		SRAMINT_CS_O 										: out std_logic;						
      SRAMINT_WRITE_O 									: out std_logic;							
      SRAMINT_ADDR_O 									: out std_logic_vector(20 downto 0);								
      SRAMINT_DATA_I 									: in  std_logic_vector(35 downto 0);								
      SRAMINT_DATA_O 									: out std_logic_vector(35 downto 0)      
	);
end glib_sram_interface_ioControl;
architecture structural of glib_sram_interface_ioControl is	
	--======================== Signal Declarations ========================--
	signal reset_from_mux								: std_logic;
	signal clk_from_mux									: std_logic;	
	signal ipbus_strobe_sr							   : std_logic_vector(SR_SIZE-1 downto 0);
	signal addr_from_ipBus	   						: std_logic_vector(20 downto 0);
	signal wData_from_ipBus	   						: std_logic_vector(35 downto 0);
	signal ipBus_rdata		   						: std_logic_vector(35 downto 0);
	signal sramint_cs_from_mux							: std_logic;											
	signal sramint_write_from_mux						: std_logic;											
	signal sramint_addr_from_mux						: std_logic_vector(20 downto 0);										
	signal sramint_data_from_mux						: std_logic_vector(35 downto 0);	
	signal testEnable_from_orGate						: std_logic;
	signal bistModeEnable_from_fsm					: std_logic;	
	--=====================================================================--		
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--========================= Port Assignments ==========================--
	-- Stam Interface:
	SRAMINT_RESET_O										<= reset_from_mux;	
	SRAMINT_CLK_O											<= clk_from_mux;	
	-- Buil In Self Test:
	BIST_RESET_O											<= reset_from_mux;
	BIST_CLK_O												<= clk_from_mux;	
	BIST_DATA_O												<= SRAMINT_DATA_I;
	--=====================================================================--
	--============================ User Logic =============================--
	-- IPBus adapter:
		-- Ack:
		ack_process:process(IPBUS_RESET_I,IPBUS_CLK_I)	
			variable ack_ctrl								: std_logic_vector(2 downto 0);
		begin
			if IPBUS_RESET_I = '1' then
				ack_ctrl										:="000";
			elsif rising_edge(IPBUS_CLK_I) then			
				if IPBUS_STROBE_I = '1' and IPBUS_WRITE_I = '1' then
					IPBUS_ACK_O 							<= IPBUS_STROBE_I;
				else
					case ack_ctrl is
					when "000" => 	IPBUS_ACK_O 		<= '0';
										if IPBUS_STROBE_I='1' then 
											IPBUS_ACK_O 	<= '0';  ack_ctrl := "001";
										end if;
					when "001" => 	IPBUS_ACK_O 		<= '0'; 	ack_ctrl := "010";
					when "010" => 	IPBUS_ACK_O 		<= '0';	ack_ctrl := "011";
					when "011" => 	IPBUS_ACK_O 		<= '1';	ack_ctrl := "100";
					when "100" => 	IPBUS_ACK_O 		<= '0';	ack_ctrl := "101";
					when "101" => 	IPBUS_ACK_O 		<= '0';	ack_ctrl := "000";
					when others =>
					end case;
				end if;
			end if;
		end process;		
		-- Err:
		IPBUS_ERR_O											<= '0';
		-- Addr:
		addr_from_ipBus									<= IPBUS_ADDR_I(20 downto 0);
		-- W Data:
		wData_from_ipBus									<= b"0000" & IPBUS_WDATA_I; 
		-- R Data:		
		IPBUS_RDATA_O										<= ipBus_rdata(31 downto 0);	
		
	-- I/O control Multiplexors:	
	reset_from_mux											<= USER_RESET_I				when USER_SELECT_I = '1'
																	else IPBUS_RESET_I;	
	clk_bufgmux : BUFGMUX
		port map (
			O 													=> clk_from_mux,  
			I0 												=> IPBUS_CLK_I, 
			I1 												=> USER_CLK_I, 
			S 													=> USER_SELECT_I
		);	
	ipBus_rdata												<=	(others => '0') 			when USER_SELECT_I = '1' or
																										  testEnable_from_orGate = '1' 
																	else SRAMINT_DATA_I;	
	USER_DATA_O												<=	SRAMINT_DATA_I				when USER_SELECT_I = '1' and 
																										  testEnable_from_orGate = '0' 
																	else (others => '0');	
	sramint_cs_from_mux									<= USER_CS_I					when USER_SELECT_I = '1'
																	else IPBUS_STROBE_I;
	sramint_write_from_mux								<= USER_WRITE_I				when USER_SELECT_I = '1'
																	else IPBUS_WRITE_I;
	sramint_addr_from_mux								<= USER_ADDR_I					when USER_SELECT_I = '1'			
																	else addr_from_ipBus;
	sramint_data_from_mux								<= USER_DATA_I					when USER_SELECT_I = '1'
																	else wData_from_ipBus;				
	-- Normal mode or Test mode:				
	testEnable_from_orGate								<= '1' when (IPBUS_TEST_I = '1' and USER_SELECT_I = '0') or
																				(USER_TEST_I  = '1' and USER_SELECT_I = '1')
																	else '0';						
	SRAMINT_CS_O											<= BIST_CS_I 					when bistModeEnable_from_fsm = '1'
																	else sramint_cs_from_mux;	
	SRAMINT_WRITE_O										<= BIST_WRITE_I 				when bistModeEnable_from_fsm = '1'															
																	else sramint_write_from_mux; 
	SRAMINT_ADDR_O											<= BIST_ADDR_I 			   when bistModeEnable_from_fsm = '1'													
																	else sramint_addr_from_mux;	 
	SRAMINT_DATA_O											<= BIST_DATA_I 				when bistModeEnable_from_fsm = '1' 
																	else sramint_data_from_mux; 	
	-- BIST error injection:
	BIST_ERRINJECT_O										<= USER_BIST_ERRINJECT_I  	when USER_SELECT_I = '1' 
																	else IPBUS_BIST_ERRINJECT_I; 	
	-- Test mode Finite State Machine(FSM):	
	testModeFsm_process: process(reset_from_mux, clk_from_mux)
		variable state										: testControlStateT;
	begin
		if reset_from_mux = '1' then
			state												:= e0_userMode;
			bistModeEnable_from_fsm						<= '0';	
			BIST_ENABLE_O									<= '0';
		elsif rising_edge(clk_from_mux) then	
			case state is 		
				when e0_userMode =>		
					if testEnable_from_orGate = '1' then		
						state									:= e1_bistMode;
						bistModeEnable_from_fsm			<= '1';
						BIST_ENABLE_O						<= '1'; 
					end if;		
				when e1_bistMode =>		
					BIST_ENABLE_O							<= '0'; 
					if BIST_TESTDONE_I = '1' then		
						state									:= e0_userMode;
						bistModeEnable_from_fsm			<= '0';						
					end if;		
			end case;					
		end if;		
	end process;
	--=====================================================================--
	end structural;
--=================================================================================================--
--=================================================================================================--