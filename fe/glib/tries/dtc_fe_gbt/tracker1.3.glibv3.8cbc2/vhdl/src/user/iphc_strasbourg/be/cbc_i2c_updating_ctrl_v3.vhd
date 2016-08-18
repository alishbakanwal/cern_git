----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:05 09/24/2013 
-- Design Name: 
-- Module Name:    cbc_i2c_updating_ctrl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
--use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--! system packages
use work.system_flash_sram_package.all;

----iphc_strasbourg
--use work.pkg_generic.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity cbc_i2c_updating_ctrl_v3 is
--	generic (	FE_NB 										: positive := 2; --1 or 2	
--					CBC_NB 										: positive := 2;
--				)
	port ( 		--===============--
					-- GENERAL --
					--===============--	
					clk 											: in std_logic;
					sclr_i 										: in std_logic;
					
					--===========--
					-- CBC RESET --
					--===========--						
					cbc_hard_reset_i 							: in std_logic;
					cbc_fast_reset_i							: in std_logic;				
					
					--===============--
					-- SW INTERFCACE --
					--===============--					
					--Cmd Rq
					cbc_i2c_cmd_rq_i							: in std_logic_vector(1 downto 0); 	--"00" or "10": NO / "01": RD / "11": WR 
					--Cmd Ack
					cbc_i2c_cmd_ack_o							: out std_logic_vector(1 downto 0); --"00": idle or wait / "01": ACK GOOD / "10": ACK KO
					
					--==============--
					-- I2C_PHY_CTRL --
					--==============--
					--From I2C Controller		
					cbc_ctrl_i2c_reply_i						: in std_logic_vector(31 downto 0);				
					cbc_ctrl_i2c_done_i						: in std_logic;
					--Towards I2C Controller
					cbc_ctrl_i2c_settings_o					: out std_logic_vector(31 downto 0);
					cbc_ctrl_i2c_command_o					: out std_logic_vector(31 downto 0);
					cbc_i2c_phy_ctrl_reset_o				: out std_logic;
							
					--================--
					-- SRAM INTERFACE --
					--================--
					--sram_package.vhd:
					-------------------
					cbc_i2c_user_sram_control_o			: out userSramControlR; 
					cbc_i2c_user_sram_addr_o				: out std_logic_vector(20 downto 0); --array_2x21bit							
					cbc_i2c_user_sram_rdata_i				: in std_logic_vector(35 downto 0); --array_2x36bit		
					cbc_i2c_user_sram_wdata_o				: out std_logic_vector(35 downto 0); --array_2x36bit					

					--CTRL
					sram_read_latency_i						: in std_logic_vector(4 downto 0);
					--STATUS
					cbc_i2c_access_busy_o					: out std_logic;
					cbc_i2c_param_word_fePart_o			: out std_logic_vector(2 downto 0);						
					
					--Parameter Word for Test
					cbc_i2c_param_word_o						: out std_logic_vector(31 downto 0)
				
				
		  );
end cbc_i2c_updating_ctrl_v3;

architecture Behavioral of cbc_i2c_updating_ctrl_v3 is

	--attribute
	attribute init: string;
	
	
	
	--Constants declaration
--	constant FMC1 												: integer := 0;
--	constant FMC2 												: integer := 1;
--	constant CBC_A 											: integer := 0;
--	constant CBC_B 											: integer := 1;	
	
	
	constant FE_NB 											: positive := 1;--2; --1 or 2	
	constant CBC_NB 											: positive := 8;--2;
	type array_FE_NBxCBC_NBx1bit 							is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic;
	type array_FE_NBxCBC_NBx7bit 							is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(6 downto 0);	
	type array_FE_NBxCBC_NBx8bit 							is array(FE_NB-1 downto 0,CBC_NB-1 downto 0) 				of std_logic_vector(7 downto 0);
	

	--CONSTANTS
	--Paging ctrl
	constant cbc_i2c_page1 									: std_logic := '0';
	constant cbc_i2c_page2 									: std_logic := '1';
	--reg0 ctrl
	constant cbc_i2c_reg0_addr 							: std_logic_vector(7 downto 0) := x"00";
	constant cbc_i2c_reg0_defVal 							: std_logic_vector(7 downto 0) := x"3c";

	--SIGNALS

	--Paging ctrl
	signal cbc_i2c_currentPage 							: array_FE_NBxCBC_NBx1bit;
	signal cbc_i2c_reg0_lastVal 							: array_FE_NBxCBC_NBx8bit;	
	signal cbc_i2c_reg0_lastValMaskPage1 				: array_FE_NBxCBC_NBx8bit;
	signal cbc_i2c_reg0_lastValMaskPage2 				: array_FE_NBxCBC_NBx8bit;

	--I2C @	
	signal CBC_I2C_ADDR 										: array_FE_NBxCBC_NBx7bit;

	--32-bit data word from SRAM
	signal cbc_i2c_user_sram_rdata_latched				: std_logic_vector(35 downto 0) 	:= (others => '0');
	alias cbc_i2c_param_word_dataPart 					: std_logic_vector(7 downto 0) 	is cbc_i2c_user_sram_rdata_latched(7 downto 0);
	alias cbc_i2c_param_word_addrPart 					: std_logic_vector(7 downto 0) 	is cbc_i2c_user_sram_rdata_latched(15 downto 8);	
	alias cbc_i2c_param_word_pagePart 					: std_logic 							is cbc_i2c_user_sram_rdata_latched(16);
	alias cbc_i2c_param_word_cbcPart 					: std_logic_vector					is cbc_i2c_user_sram_rdata_latched(20 downto 17);
	--alias cbc_i2c_param_word_fmcPart 					: std_logic 							is cbc_i2c_user_sram_rdata_latched(21);
	alias cbc_i2c_param_word_fePart 						: std_logic_vector(2 downto 0)	is cbc_i2c_user_sram_rdata_latched(23 downto 21);	
	

   --==============--
   -- I2C_PHY_CTRL --
   --==============--
	
	--CONSTANTS:
	------------
	--I2C settings	
	-->DIS
	constant CBC_I2C_CTRL_DIS 								: std_logic_vector(31 downto 0) := x"00000000";
	-->EN
		--i2c_en = 1 => b11
		--i2c_sel = 0 (line 0) => b10
		--i2c_presc = 500 ([0:1023]) => b9:b0
		--> f(scl) = 62.5M/i2c_presc = 125kHz	
	constant CBC_I2C_CTRL_EN 								: std_logic_vector(31 downto 0) := x"000009F4"; 
	--> I2C cmd
	constant CBC_I2C_CTRL_STROBE 							: std_logic := '1'; --'1' => strobe en
	constant CBC_I2C_CTRL_16b_MODE 						: std_logic := '0'; --'0' => 8b 
	constant CBC_I2C_CTRL_RAL_MODE 						: std_logic := '1'; --
	constant CBC_I2C_DUMMY_BYTE 							: std_logic_vector(7 downto 0) := x"00";
	constant CBC_I2C_CTRL_RD_MODE 						: std_logic := '0';
	constant CBC_I2C_CTRL_WR_MODE 						: std_logic := '1'; 
	
	--SIGNALS:
	----------
	signal 	CBC_I2C_CTRL_ACCESS_MODE 					: std_logic := '0'; --'0' : RD / '1' : WR		
	signal 	CBC_I2C_CTRL_regAddr 						: std_logic_vector(7 downto 0):= (others => '0');
	signal 	CBC_I2C_CTRL_regData 						: std_logic_vector(7 downto 0):= (others => '0');
	--signal CBC_I2C_CTRL_WR_DATA 						: std_logic_vector(7 downto 0):= (others => '0');



	--FSM
	type states_type is (		
										idle_state, 
										enable_i2c_ctrl_state,
										latch_dataWord_state,								
										test_reg0AndPage_state, 
										i2c_ctrl_transmitCmd_state,
										i2c_ctrl_ACK_test_state,
										latency_ctrl_state,
										raz_writeEnable_state,
										sram_addr_set_state,
										read_latency_ctrl_state,
										modifyPage_state,
										restoring_reg0_state,
										end_test1_state,
										end_test2_state,
										i2c_ctrl_transmitCmdReg0_state,		
										i2c_ctrl_ACK_test_CmdReg0_state,
										wait_state
								); 						
	signal states : states_type;	

	--OTHERS
	signal cbc_i2c_access_busy 							: std_logic := '0';
	signal counter_timeout 									: integer range 0 to 2**31-1;	
	signal cbc_i2c_user_sram_addr_tmp 					: unsigned(20 downto 0); --array_2x21bit
	signal latency_counter 									: unsigned(4 downto 0):="01111"; --15 by def
	
	
begin

   --======--
   --OUTPUT--
   --======--	
	cbc_i2c_user_sram_addr_o 								<= std_logic_vector(cbc_i2c_user_sram_addr_tmp);
	cbc_i2c_access_busy_o									<= cbc_i2c_access_busy;
	cbc_i2c_param_word_fePart_o							<= cbc_i2c_param_word_fePart;

	
   --===========================--
   --Reg0 Mask for paging system--
   --===========================--	
	i_fe_gen : for i_fe in 0 to FE_NB-1 generate
		--
		i_cbc_gen : for i_cbc in 0 to CBC_NB-1 generate
			--
			cbc_i2c_reg0_lastValMaskPage2(i_fe,i_cbc) <= cbc_i2c_reg0_lastVal(i_fe,i_cbc) or  x"80"; --page2 => b7=1			
			cbc_i2c_reg0_lastValMaskPage1(i_fe,i_cbc) <= cbc_i2c_reg0_lastVal(i_fe,i_cbc) and x"7f"; --page1 => b7=0
		end generate;
	end generate;


   --=================--
   --I2C @ Declaration--
   --=================--
	--The I2C addresses of the two chips are binary 1000001 and 1000010. 
	CBC_I2C_ADDR(0,0) <= "1000001"; --x"41"
	CBC_I2C_ADDR(0,1) <= "1000010"; --x"42"
	CBC_I2C_ADDR(0,2) <= "1000011"; --x"43"
	CBC_I2C_ADDR(0,3) <= "1000100"; --x"44"	
	CBC_I2C_ADDR(0,4) <= "1000101"; --x"45"
	CBC_I2C_ADDR(0,5) <= "1000110"; --x"46"	
	CBC_I2C_ADDR(0,6) <= "1000111"; --x"47"
	CBC_I2C_ADDR(0,7) <= "1001000"; --x"48"

	
--	CBC_I2C_ADDR(1,0) <= "1000001"; --x"41"
--	CBC_I2C_ADDR(1,1) <= "1000010"; --x"42"
	--> faire une boucle avec resultat d'un scan



	--===============================================================================================--
	process --Page updating / Reg0 LastVal 
	--===============================================================================================--
	begin
		wait until clk'event and clk = '1';
			--if cbc_hard_reset_i = '1' then -- or cbc_fast_reset_i = '1' then
			if cbc_hard_reset_i = '1' or sclr_i = '1' then			
				--init loop 
				init_loop_fe : for i_fe in FE_NB-1 downto 0 loop 
					init_loop_cbc : for i_cbc in CBC_NB-1 downto 0 loop 
						cbc_i2c_reg0_lastVal(i_fe,i_cbc) 	<= cbc_i2c_reg0_defVal;
						--cbc_i2c_currentPage(i_fe,i_cbc)		<= cbc_i2c_page1;						
					end loop;
				end loop;
			--
			--elsif cbc_i2c_access_busy = '1' and cbc_i2c_param_word_addrPart = cbc_i2c_reg0_addr then
			elsif cbc_i2c_cmd_rq_i = "11" and cbc_i2c_param_word_addrPart = cbc_i2c_reg0_addr and states = test_reg0AndPage_state then			
				cbc_i2c_reg0_lastVal(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart))) <= cbc_i2c_param_word_dataPart;						
				--cbc_i2c_currentPage(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart))) <= cbc_i2c_param_word_pagePart;			
			else
				null;
			end if;
	end process;
	--===============================================================================================--




	--===============================================================================================--
	process --FSM
	--===============================================================================================--
	begin
	wait until clk'event and clk = '1';
		--
		if cbc_hard_reset_i = '1' or sclr_i = '1' then  --- gbt_aligned, locked, PC_config_ok...
			--I2C_PHY_CTRL			
			cbc_ctrl_i2c_settings_o 										<= CBC_I2C_CTRL_DIS;			
			cbc_ctrl_i2c_command_o 											<= (others => '0'); --RAZ
			cbc_i2c_phy_ctrl_reset_o										<= '1'; --'1': EN
			
			--SW LINK STATUS
			cbc_i2c_cmd_ack_o													<= "00"; --idle

			--STATUS
			cbc_i2c_access_busy 												<= '0';
			cbc_i2c_param_word_o 											<= x"00001111"; --wait				
			
			--Paging/init loop 
			init_loop_fe : for i_fe in FE_NB-1 downto 0 loop 
				init_loop_cbc : for i_cbc in CBC_NB-1 downto 0 loop 
					cbc_i2c_currentPage(i_fe,i_cbc)						<= cbc_i2c_page1;	--just only here					
				end loop;
			end loop;
			
			--SRAM CTRL : RESET EN
			cbc_i2c_user_sram_control_o.reset 							<= '1'; --'1' : EN / '0' : DIS
			cbc_i2c_user_sram_control_o.cs 								<= '0'; --'1' : EN / '0' : DIS	
			cbc_i2c_user_sram_control_o.writeEnable 					<= '0'; --'1' : WR / '0' : RD		
			cbc_i2c_user_sram_addr_tmp										<= (others => '0');	
			
			--OTHERS
			cbc_i2c_user_sram_rdata_latched								<= (others => '0');	
			latency_counter 													<= (others => '0');		
			--
			states 																<= idle_state;			
		--	
		else
			case states is
				--
				when idle_state =>
					--
					if cbc_i2c_cmd_rq_i(0) = '1' then 
						--STATUS
						cbc_i2c_access_busy 									<= '1';
						cbc_i2c_param_word_o 								<= x"00002222"; --busy						
						--SRAM CTRL : CS EN / RD EN
						cbc_i2c_user_sram_control_o.cs 					<= '1'; --'1' : EN / '0' : DIS
						cbc_i2c_user_sram_control_o.writeEnable 		<= '0'; --'1' : WR / '0' : RD						
						--
						states 													<= read_latency_ctrl_state;						
					--
					else
						--I2C_PHY_CTRL = DIS
						cbc_ctrl_i2c_settings_o 							<= CBC_I2C_CTRL_DIS;
						cbc_ctrl_i2c_command_o 								<= (others => '0'); --RAZ
						cbc_i2c_phy_ctrl_reset_o							<= '0'; --'1': EN	/ '0': DIS					
						cbc_i2c_access_busy 									<= '0';
						cbc_i2c_param_word_o 								<= x"00001111"; --wait

						--SRAM CTRL : RESET DIS
						cbc_i2c_user_sram_control_o.reset 				<= '0'; --'1' : EN / '0' : DIS
						cbc_i2c_user_sram_control_o.cs 					<= '0'; --'1' : EN / '0' : DIS	
						cbc_i2c_user_sram_control_o.writeEnable 		<= '0'; --'1' : WR / '0' : RD		
						cbc_i2c_user_sram_addr_tmp							<= (others => '0'); --@=0	
			
						--cbc_i2c_user_sram_rdata_latched				<= (others => '0');
						cbc_i2c_user_sram_wdata_o							<= (others => '0');
						--new
						latency_counter 										<= unsigned(sram_read_latency_i); --updated
						--
						cbc_i2c_cmd_ack_o										<= "00"; --idle						
					end if;
				
				--
				when enable_i2c_ctrl_state =>
					--I2C_PHY_CTRL = EN
					cbc_ctrl_i2c_settings_o 								<= CBC_I2C_CTRL_EN;
					--
					states 														<= latch_dataWord_state; --test_reg0AndPage_state;
					
				--
				when latch_dataWord_state => 				
					--SRAM CTRL : CS DIS
					cbc_i2c_user_sram_control_o.cs 						<= '0'; --'1' : EN / '0' : DIS					
					cbc_i2c_user_sram_control_o.writeEnable 			<= '0'; --'1' : WR / '0' : RD						
					--LATCH DATA FROM SRAM
					cbc_i2c_user_sram_rdata_latched 						<= cbc_i2c_user_sram_rdata_i;	
					--
					states 														<= test_reg0AndPage_state;
					--

						
				--
				when test_reg0AndPage_state =>
					--
					if cbc_i2c_user_sram_rdata_latched(31 downto 0) = x"ffffffff" then --SRAM_DATA_FLAG_END
						states 													<= end_test1_state;
					--
					elsif cbc_i2c_param_word_addrPart = cbc_i2c_reg0_addr then --reg0 ?
						--I2C_PHY_CTRL : COMMAND TMP  
						CBC_I2C_CTRL_regAddr 								<= cbc_i2c_param_word_addrPart;
						CBC_I2C_CTRL_regData 								<= cbc_i2c_param_word_dataPart;	
						CBC_I2C_CTRL_ACCESS_MODE 							<= cbc_i2c_cmd_rq_i(1); --'0' : Rd / '1' : Wr
						--
						states 													<= i2c_ctrl_transmitCmd_state;						
					--
					elsif cbc_i2c_param_word_pagePart /= cbc_i2c_currentPage(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart))) then 
						--modify reg0
						states 													<= modifyPage_state;
					--
					else
						--I2C_PHY_CTRL : COMMAND TMP 
						CBC_I2C_CTRL_regAddr 								<= cbc_i2c_param_word_addrPart;
						CBC_I2C_CTRL_regData 								<= cbc_i2c_param_word_dataPart;	
						CBC_I2C_CTRL_ACCESS_MODE 							<= cbc_i2c_cmd_rq_i(1); --'0' : Rd / '1' : Wr
						--
						states 													<= i2c_ctrl_transmitCmd_state;		
					end if;

				--
				when i2c_ctrl_transmitCmd_state =>
					--I2C_PHY_CTRL : COMMAND AFFECTATION
					cbc_ctrl_i2c_command_o 									<= 	CBC_I2C_CTRL_STROBE   		&
																							"00000"					 		&
																							CBC_I2C_CTRL_16b_MODE 		&
																							CBC_I2C_CTRL_RAL_MODE 		&
																							--CBC_I2C_CTRL_WR_MODE		&
																							CBC_I2C_CTRL_ACCESS_MODE 	&
																							CBC_I2C_ADDR(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart)))	&
																							CBC_I2C_CTRL_regAddr			&
																							CBC_I2C_CTRL_regData;
					--
					states 														<= i2c_ctrl_ACK_test_state;
				
				--
				when i2c_ctrl_ACK_test_state =>
					--I2C_PHY_CTRL : COMMAND / STROBE RAZ
					cbc_ctrl_i2c_command_o(31 downto 28) 				<= (others => '0'); 
					
					--WAITING REPLY FROM I2C_PHY_CTRL
					if cbc_ctrl_i2c_done_i = '1' then --one pulse from I2C_PHY_CTRL
						--
						if cbc_i2c_cmd_rq_i(1) = '0' then  --RD MODE?
							--SRAM CTRL : WR EN
							cbc_i2c_user_sram_control_o.cs 				<= '1'; --'1' : EN / '0' : DIS					
							cbc_i2c_user_sram_control_o.writeEnable 	<= '1'; --'1' : WR / '0' : RD							
							--SRAM WDATA
							cbc_i2c_user_sram_wdata_o						<= x"0" & cbc_i2c_user_sram_rdata_latched(31 downto 8) & cbc_ctrl_i2c_reply_i(7 downto 0);
							--cbc_i2c_user_sram_wdata_o					<= x"0" & x"ffffffff"; 							
							--cbc_i2c_user_sram_wdata_o					<= x"0" & cbc_i2c_user_sram_rdata_latched(31 downto 0);
							--
							states 												<= raz_writeEnable_state;
						--
						else --WR MODE?
							states 												<= raz_writeEnable_state;							
						end if;
						--
					--
					else
						cbc_i2c_param_word_o 								<= cbc_i2c_user_sram_rdata_latched(31 downto 0); --x"00003333"; --wait done
					end if;
					--
				
					
				--
				when raz_writeEnable_state => 
					--SRAM CTRL : WR DIS
					cbc_i2c_user_sram_control_o.cs 						<= '0'; --'1' : EN / '0' : DIS					
					cbc_i2c_user_sram_control_o.writeEnable 			<= '0'; --'1' : WR / '0' : RD	
					--
					states 														<= sram_addr_set_state;
				
				--
				when sram_addr_set_state => 
					--SRAM CTRL : RD EN + INCREMENTATION OF @
					cbc_i2c_user_sram_control_o.cs 						<= '1'; --'1' : EN / '0' : DIS					
					cbc_i2c_user_sram_control_o.writeEnable 			<= '0'; --'1' : WR / '0' : RD						
					cbc_i2c_user_sram_addr_tmp 							<= cbc_i2c_user_sram_addr_tmp + to_unsigned(1,21);	
					--
					states 														<= read_latency_ctrl_state;
			
				--
				when read_latency_ctrl_state => 
					if latency_counter = 0 then
						states 													<= enable_i2c_ctrl_state;
						latency_counter 										<= unsigned(sram_read_latency_i); --updated
					else
						latency_counter 										<= latency_counter - to_unsigned(1,5);
					end if;
					
				--
				when end_test1_state =>
					--
					if cbc_i2c_cmd_rq_i = "00" then
						states 													<= end_test2_state;--idle_state;
						cbc_i2c_cmd_ack_o										<= "00"; --idle
						cbc_i2c_param_word_o 								<= x"00004444"; --end
					else
						cbc_i2c_cmd_ack_o										<= "01"; --good
						cbc_i2c_param_word_o 								<= x"AAAAAAAA"; --OK
					end if;
					--
					cbc_ctrl_i2c_settings_o 								<= CBC_I2C_CTRL_DIS;


				--
				when end_test2_state =>				
					if cbc_i2c_cmd_rq_i = "00" then
						states 													<= idle_state;
					end if;

		

		
					
				--
				when modifyPage_state => 
					--
					if cbc_i2c_param_word_pagePart = cbc_i2c_page1 then --cbc_i2c_page1? 
					----> from page2 to page1
						--I2C_PHY_CTRL : COMMAND TMP
						CBC_I2C_CTRL_regAddr							 		<= cbc_i2c_reg0_addr;
						CBC_I2C_CTRL_regData 								<= cbc_i2c_reg0_lastVal(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart))) and x"7f"; 	--going to page1
						--CBC_I2C_CTRL_regData 								<= cbc_i2c_reg0_lastValMaskPage1(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart))) 
					--
					else --cbc_i2c_page2 ? 
					----> from page1 to page2 
						--I2C_PHY_CTRL : COMMAND TMP 
						CBC_I2C_CTRL_regAddr 								<= cbc_i2c_reg0_addr;
						CBC_I2C_CTRL_regData 								<= cbc_i2c_reg0_lastVal(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart))) or x"80"; 	--going to page2
						--CBC_I2C_CTRL_regData 								<= cbc_i2c_reg0_lastValMaskPage2(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart))) 
					--
					end if;
					--
					--I2C_PHY_CTRL : COMMAND TMP
					CBC_I2C_CTRL_ACCESS_MODE 								<= CBC_I2C_CTRL_WR_MODE;
					--
					states 														<= i2c_ctrl_transmitCmdReg0_state;
				
				--
				when i2c_ctrl_transmitCmdReg0_state =>
					--I2C_PHY_CTRL : COMMAND AFFECTATION
					cbc_ctrl_i2c_command_o 									<= 	CBC_I2C_CTRL_STROBE   		&
																							"00000"					 		&
																							CBC_I2C_CTRL_16b_MODE 		&
																							CBC_I2C_CTRL_RAL_MODE 		&
																							--CBC_I2C_CTRL_WR_MODE	 		&
																							CBC_I2C_CTRL_ACCESS_MODE 	&
																							CBC_I2C_ADDR(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart)))	&
																							CBC_I2C_CTRL_regAddr			&
																							CBC_I2C_CTRL_regData;
					--
					states 														<= i2c_ctrl_ACK_test_CmdReg0_state;	

				--
				when i2c_ctrl_ACK_test_CmdReg0_state =>
					--I2C_PHY_CTRL : COMMAND / STROBE RAZ
					cbc_ctrl_i2c_command_o(31 downto 28) 				<= (others => '0'); 
					--WAITING REPLY FROM I2C_PHY_CTRL
					if cbc_ctrl_i2c_done_i = '1' then --one pulse from I2C_PHY_CTRL
						states 													<= wait_state; --test_reg0AndPage_state;
						--UPDATE currentPage(i_fe,i_cbc)
						cbc_i2c_currentPage(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart))) <= cbc_i2c_param_word_pagePart;
					--
					else
						--cbc_i2c_param_word_o <= x"00003333"; --wait done
						null;
					end if;
					--
				
				--
				when wait_state => --not needed now if one pulse from I2C_PHY_CTRL
					if cbc_ctrl_i2c_done_i = '0' then
						states 													<= test_reg0AndPage_state;
					end if;
				
				--
				when restoring_reg0_state =>
					CBC_I2C_CTRL_regAddr 									<= cbc_i2c_reg0_addr;
					CBC_I2C_CTRL_regData 									<= cbc_i2c_reg0_lastVal(to_integer(unsigned(cbc_i2c_param_word_fePart)),to_integer(unsigned(cbc_i2c_param_word_cbcPart)));					
					states 														<= i2c_ctrl_transmitCmd_state;
				
				--
				when others =>
					null;
			end case;
		end if;
	end process;


	--===============================================================================================--
					





end Behavioral;

