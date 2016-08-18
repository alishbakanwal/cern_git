--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																														  	
-- Company:  			CERN (PH-ESE-BE)																			
-- Engineer: 			Paschalis Vichoudis (Paschalis.Vichoudis@cern.ch)								
-- 						Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)	
-- 																														
-- Create Date:		20/10/2011		 																			
-- Project Name:		cdce_synchronizer																			
-- Module Name:   	cdce_synchronizer							 												
-- 																														
-- Language:			VHDL'93																						
--																															
-- Target Devices: 	GLIB (Virtex 6)																			
-- Tool versions: 	ISE 13.2																						
--																															
-- Revision:		 	1.0 																							
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
entity cdce_synchronizer is
	generic 
	(	
		PWRDOWN_DELAY 			: natural := 1000;
	   SYNC_DELAY 				: natural := 1000000	
	);	
	port 
	(	
		RESET_I					: in  std_logic;
		--------------------
		IPBUS_CTRL_I			: in  std_logic;
		IPBUS_SEL_I				: in  std_logic;
		IPBUS_PWRDOWN_I		: in  std_logic;
		IPBUS_SYNC_I			: in  std_logic;
		--------------------
		USER_SEL_I				: in  std_logic;
		USER_SYNC_I				: in  std_logic;
		USER_PWRDOWN_I			: in  std_logic;
		--------------------
		PRI_CLK_I				: in  std_logic;
		SEC_CLK_I				: in  std_logic;
		PWRDOWN_O				: out std_logic;
		SYNC_O					: out std_logic;
		REF_SEL_O				: out std_logic;
		--------------------		
		SYNC_CLK_O				: out std_logic;
		SYNC_CMD_O				: out std_logic;
		SYNC_BUSY_O				: out std_logic;
		SYNC_DONE_O				: out std_logic
	);
end cdce_synchronizer;

architecture structural of cdce_synchronizer is	

signal clk_from_bufg_mux	: std_logic;	
signal reset					: std_logic;
signal sel						: std_logic;
signal pwrdown, fsm_pwrdown: std_logic;
signal fsm_sync				: std_logic;
signal sync_cmd				: std_logic;

signal reset_dpr				: std_logic;
signal pwrdown_dpr			: std_logic;


begin		


	--==========================--
	reset <= 	'1' 	when RESET_I	='1' 										else
					'1'	when sync_cmd  ='1'										else
					'0'; 	-- default
	--==========================--
	
	--==========================--
	sync_cmd <=	'1'	when (IPBUS_CTRL_I='1' and IPBUS_SYNC_I='0') 	else
					'1'	when (IPBUS_CTRL_I='0' and USER_SYNC_I='0' )		else
					'0'; 	-- default
	--==========================--

	--==========================--
	sel	<=		'0'	when (IPBUS_CTRL_I='1' and IPBUS_SEL_I='1' ) 	else
					'1'	when (IPBUS_CTRL_I='1' and IPBUS_SEL_I='0' ) 	else
					'0'	when (IPBUS_CTRL_I='0' and USER_SEL_I='1'  ) 	else
					'1'	when (IPBUS_CTRL_I='0' and USER_SEL_I='0'  ) 	else
					'0';  -- default 
	--==========================--			
	
	--==========================--
	pwrdown	<=	'0'	when (IPBUS_CTRL_I='1' and IPBUS_PWRDOWN_I='0' ) else
					'1'	when (IPBUS_CTRL_I='1' and IPBUS_PWRDOWN_I='1' ) else
					'0'	when (IPBUS_CTRL_I='0' and USER_PWRDOWN_I='0'  ) else
					'1'	when (IPBUS_CTRL_I='0' and USER_PWRDOWN_I='1'  ) else
					'1';  -- default 
	--==========================--				

	
	
	--==========================--
	REF_SEL_O	<= not sel;	-- PRI_CLK_SEL -> 1
	SYNC_CMD_O	<= sync_cmd;
	SYNC_O		<= fsm_sync;
	PWRDOWN_O	<= pwrdown and fsm_pwrdown;
	--==========================--
	



	
	
	--==========================--
	cdce_control:process(reset, clk_from_bufg_mux)
	--==========================--
		variable state					: std_logic_vector(1 downto 0);	
		variable timer 				: natural range 0 to SYNC_DELAY; 			
	begin
		if reset = '1' then
			timer							:= PWRDOWN_DELAY;
			state							:= "00";
			fsm_pwrdown					<= '1';
			fsm_sync						<= '1';
			SYNC_DONE_O					<= '0';
			SYNC_BUSY_O					<= '0';
			--
		elsif rising_edge(clk_from_bufg_mux) then

			case state is
				--========--
				when "00" =>	
				--========--
					fsm_pwrdown	<= '0'; -- assert pwr_down
					fsm_sync		<= '0'; -- assert sync
					SYNC_BUSY_O	<= '1';
					SYNC_DONE_O	<= '0';
					if timer=0 then 
						state:="01"; 
						timer:= SYNC_DELAY; 
					else 
						timer:=timer-1; 
					end if; 
								
				--========--
				when "01" =>
				--========--
					fsm_pwrdown	<= '1'; -- deassert pwr_down
					fsm_sync		<= '0'; -- assert sync
					if timer=0 then 
						state:="10"; 
					else 
						timer:=timer-1; 
					end if; 
				
				--========--
				when "10" =>
				--========--
					fsm_pwrdown	<= '1'; -- deassert pwr_down
					fsm_sync		<= '1'; -- deassert sync					
					state:="11";
				--========--
				when "11" =>
				--========--					
					SYNC_BUSY_O	<= '0';
					SYNC_DONE_O <= '1';				
				--========--
				when others =>
				--========--
				
			end case;		
		end if;
	end process;		



--==========================--
clko_bufg: BUFG 		port map ( I => clk_from_bufg_mux, O => SYNC_CLK_O);
--clko_bufh: BUFH 	port map ( I => clk_from_bufg_mux, O => SYNC_CLK_O);
--==========================--
bufg_mux	: BUFGMUX 	port map ( O => clk_from_bufg_mux, I0 	=> PRI_CLK_I, I1 => SEC_CLK_I, S	=> sel);
--==========================--


end structural;
