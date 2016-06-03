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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity cbc_i2c_updating_ctrl_2 is
	Port ( 	clk 							: in std_logic;
				sclr 							: in std_logic;
				--
				cbc_hard_reset 			: in std_logic;
				cbc_fast_reset				: in std_logic;
				--Cmd Request
--				cbc_i2c_updating_rq 		: in std_logic;
--				cbc_i2c_reading_rq		: in std_logic;
				cbc_i2c_cmd_rq				: in std_logic_vector(1 downto 0); --"R/W" & "Rq"
				--new
				cbc_i2c_cmd_ack			: out std_logic_vector(1 downto 0);
				--Parameter Word for Test
				cbc_i2c_param_word_i		: in std_logic_vector(31 downto 0);
				cbc_i2c_param_word_o		: out std_logic_vector(31 downto 0);
				--From I2C Controller		
				cbc_ctrl_i2c_reply		: in std_logic_vector(31 downto 0);				
				cbc_ctrl_i2c_done			: in std_logic;
				--Towards I2C Controller
				cbc_ctrl_i2c_settings	: out std_logic_vector(31 downto 0);
				cbc_ctrl_i2c_command		: out std_logic_vector(31 downto 0);

				--sram_package.vhd
				cbc_i2c_user_sram_control		: out userSramControlR; 
				cbc_i2c_user_sram_addr			: out std_logic_vector(20 downto 0); --array_2x21bit							
				cbc_i2c_user_sram_rdata			: in std_logic_vector(35 downto 0); --array_2x36bit		
				cbc_i2c_user_sram_wdata			: out std_logic_vector(35 downto 0) --array_2x36bit
				


		  );
end cbc_i2c_updating_ctrl_2;

architecture Behavioral of cbc_i2c_updating_ctrl_2 is

	--attribute
	attribute init: string;
	
	--Constantes declaration
	constant FMC_NB			: integer := 2;
	constant FMC_CBC_NB		: integer := 1;	
	constant CBC_NB_BY_FMC 	: integer := 2;
	constant FMC1 				: integer := 0;
	constant FMC2 				: integer := 1;
	constant CBC_A 			: integer := 0;
	constant CBC_B 			: integer := 1;	
	
	--array type
	type array_CBC_NB_BY_FMCx1b is array(CBC_NB_BY_FMC-1 downto 0) of std_logic;
	type array_CBC_NB_BY_FMCx8b is array(CBC_NB_BY_FMC-1 downto 0) of std_logic_vector(7 downto 0);


	--Paging ctrl
	constant cbc_i2c_page1 		: std_logic := '0';
	constant cbc_i2c_page2 		: std_logic := '1';
	--signal cbc_i2c_currentPage 	: std_logic := cbc_i2c_page1;
	signal cbc_i2c_currentPage 	: array_CBC_NB_BY_FMCx1b;

	--reg0 ctrl
	constant cbc_i2c_reg0_addr : std_logic_vector(7 downto 0) := x"00";
	constant cbc_i2c_reg0_defVal : std_logic_vector(7 downto 0) := x"3c";
	--
--	signal cbc_i2c_reg0_lastVal : std_logic_vector(7 downto 0) := cbc_i2c_reg0_defVal;
--	--attribute init of cbc_i2c_reg0_lastVal : signal is cbc_i2c_reg0_defVal;
--	signal cbc_i2c_reg0_lastValMaskPage1 : std_logic_vector(7 downto 0);
--	signal cbc_i2c_reg0_lastValMaskPage2 : std_logic_vector(7 downto 0);
	--
	signal cbc_i2c_reg0_lastVal : array_CBC_NB_BY_FMCx8b;	
	signal cbc_i2c_reg0_lastValMaskPage1 : array_CBC_NB_BY_FMCx8b;
	signal cbc_i2c_reg0_lastValMaskPage2 : array_CBC_NB_BY_FMCx8b;


	--from sram
	signal cbc_i2c_user_sram_rdata_latched		: std_logic_vector(35 downto 0) := (others => '0');
	alias cbc_i2c_param_word_dataPart 	: std_logic_vector(7 downto 0) 	is cbc_i2c_user_sram_rdata_latched(7 downto 0);
	alias cbc_i2c_param_word_addrPart 	: std_logic_vector(7 downto 0) 	is cbc_i2c_user_sram_rdata_latched(15 downto 8);	
	alias cbc_i2c_param_word_pagePart 	: std_logic 							is cbc_i2c_user_sram_rdata_latched(16);
	alias cbc_i2c_param_word_cbcPart 	: std_logic_vector					is cbc_i2c_user_sram_rdata_latched(20 downto 17);
	alias cbc_i2c_param_word_fmcPart 	: std_logic 							is cbc_i2c_user_sram_rdata_latched(21);
--	--from Parameter word
--	signal cbc_i2c_param_word 				: std_logic_vector(31 downto 0) := (others=>'0');
--	alias cbc_i2c_param_word_dataPart 	: std_logic_vector(7 downto 0) 	is cbc_i2c_param_word(7 downto 0);
--	alias cbc_i2c_param_word_addrPart 	: std_logic_vector(7 downto 0) 	is cbc_i2c_param_word(15 downto 8);	
--	alias cbc_i2c_param_word_pagePart 	: std_logic 							is cbc_i2c_param_word(16);
--	alias cbc_i2c_param_word_cbcPart 	: std_logic_vector					is cbc_i2c_param_word(20 downto 17);
--	alias cbc_i2c_param_word_fmcPart 	: std_logic 							is cbc_i2c_param_word(21);



	--I2C @	
	-->Type
	type CBC_I2C_ADDR_TYPE is array(CBC_NB_BY_FMC-1 downto 0) of std_logic_vector(6 downto 0);
	signal CBC_I2C_ADDR : CBC_I2C_ADDR_TYPE;

	--I2C settings	
	-->DIS
	constant CBC_I2C_CTRL_DIS 	: std_logic_vector(31 downto 0) := x"00000000";
	-->EN
		--i2c_en = 1 => b11
		--i2c_sel = 0 (line 0) => b10
		--i2c_presc = 500 ([0:1023]) => b9:b0
		--> f(scl) = 62.5M/i2c_presc = 125kHz	
	constant CBC_I2C_CTRL_EN 	: std_logic_vector(31 downto 0) := x"000009F4"; 
	
	--> I2C cmd
	constant CBC_I2C_CTRL_STROBE 			: std_logic := '1'; --'1' => strobe en
	constant CBC_I2C_CTRL_16b_MODE 		: std_logic := '0'; --'0' => 8b 
	constant CBC_I2C_CTRL_RAL_MODE 		: std_logic := '1'; --
	constant CBC_I2C_DUMMY_BYTE 			: std_logic_vector(7 downto 0) := x"00";
	signal 	CBC_I2C_CTRL_ACCESS_MODE 	: std_logic := '0'; --'0' : RD / '1' : WR	
	constant CBC_I2C_CTRL_RD_MODE 		: std_logic := '0';
	constant CBC_I2C_CTRL_WR_MODE 		: std_logic := '1'; 
	signal CBC_I2C_CTRL_regAddr 			: std_logic_vector(7 downto 0):= (others => '0');
	signal CBC_I2C_CTRL_regData 			: std_logic_vector(7 downto 0):= (others => '0');
	--signal CBC_I2C_CTRL_WR_DATA : std_logic_vector(7 downto 0):= (others => '0');



	--FSM
	type states_type is (	idle_state, 
									enable_i2c_ctrl_state,
									latch_dataWord_state,								
									test_reg0AndPage_state, 
									i2c_ctrl_transmitCmd_state,
									i2c_ctrl_ACK_test_state,
									latency_ctrl_state,
									write_latency_ctrl_state,
									raz_writeEnable_state,
									sram_addr_set_state,
									read_latency_ctrl_state,
									modifyPage_state,
									restoring_reg0_state,
									end_test_state,
									end_test_state2,
									i2c_ctrl_transmitCmdReg0_state,		
									i2c_ctrl_ACK_test_CmdReg0_state,
									wait_state
								); 						
	signal states : states_type;	

	--
	signal cbc_i2c_updating_busy : std_logic := '0';


	signal counter_timeout : integer range 0 to 2**31-1;	

	signal regNbToAccess : integer range 0 to 2**31-1;	
	
	signal cbc_i2c_user_sram_addr_tmp : unsigned(20 downto 0); --array_2x21bit
	
	signal latency_counter : unsigned(4 downto 0):="01111"; --(others=>'0');--new	
	
	
begin

	cbc_i2c_user_sram_addr <= std_logic_vector(cbc_i2c_user_sram_addr_tmp);

--		gene1 : for i_fmc in 1 to FMC_CBC_NB generate
--		begin
--			gene2 : for i_cbc in 1 to CBC_NB_BY_FMC generate
--			begin
--		end generate;
--	end generate;

--		gene1 : for i_fmc in 1 to FMC_CBC_NB loop
--			gene2 : for i_cbc in 1 to CBC_NB_BY_FMC loop
--		end generate;
--	end generate;


   --===================--
   --Param Word for Test--
   --===================--
	--cbc_i2c_param_word <= cbc_i2c_param_word_i;
	--cbc_i2c_param_word_o	<= 
	
   --===========================--
   --Reg0 Mask for paging system--
   --===========================--	
--	cbc_i2c_reg0_lastValMaskPage1 <= cbc_i2c_reg0_lastVal or  x"80";
--	cbc_i2c_reg0_lastValMaskPage2 <= cbc_i2c_reg0_lastVal and x"7f";

--	cbc_i2c_reg0_lastValMaskPage1(FMC2,CBC_A) <= cbc_i2c_reg0_lastVal(FMC2,CBC_A) or  x"80";
--	cbc_i2c_reg0_lastValMaskPage2(FMC2,CBC_A) <= cbc_i2c_reg0_lastVal(FMC2,CBC_A) and x"7f";	


	CBC_NB_BY_FMC_gene2 : for i_cbc in CBC_NB_BY_FMC-1 downto 0 generate
	begin
		cbc_i2c_reg0_lastValMaskPage2(i_cbc) <= cbc_i2c_reg0_lastVal(i_cbc) or  x"80"; --page2 => b7=1
		cbc_i2c_reg0_lastValMaskPage1(i_cbc) <= cbc_i2c_reg0_lastVal(i_cbc) and x"7f"; --page1 => b7=0
	end generate;




   --=================--
   --I2C @ Declaration--
   --=================--
	--The I2C addresses of the two chips are binary 1000001 and 1000010. 
	CBC_I2C_ADDR(CBC_A) <= "1000001"; --x"41"
	CBC_I2C_ADDR(CBC_B) <= "1000010"; --x"42"
	--> faire une boucle avec resultat d'un scan






	--===============================================================================================--
	process --Page updating / Reg0 LastVal 
	--===============================================================================================--
	begin
		wait until clk'event and clk = '1';
			--if cbc_hard_reset = '1' then -- or cbc_fast_reset = '1' then
			if cbc_hard_reset = '1' or sclr = '1' then			
				--init loop 
				Reg0Updating_loop1 : for i_cbc in CBC_NB_BY_FMC-1 downto 0 loop 
					cbc_i2c_reg0_lastVal(i_cbc) 	<= cbc_i2c_reg0_defVal;
					--cbc_i2c_currentPage(i_cbc) 		<= cbc_i2c_page1;
				end loop;
				--
			--elsif cbc_i2c_updating_busy = '1' and cbc_i2c_param_word_addrPart = cbc_i2c_reg0_addr then
			elsif cbc_i2c_cmd_rq = "11" and cbc_i2c_param_word_addrPart = cbc_i2c_reg0_addr and states = test_reg0AndPage_state then			
				cbc_i2c_reg0_lastVal	(to_integer(unsigned(cbc_i2c_param_word_cbcPart))) <= cbc_i2c_param_word_dataPart;						
				--cbc_i2c_currentPage	(to_integer(unsigned(cbc_i2c_param_word_cbcPart))) <= cbc_i2c_param_word_pagePart;			
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
--		if sclr = '1' or cbc_hard_reset = '1' then -- gbt_aligned, locked, PC_config_ok...
--			states <= idle_state;
--			cbc_ctrl_i2c_settings <= CBC_I2C_CTRL_DIS;	
--			cbc_i2c_updating_busy <= '0';
--			cbc_i2c_param_word_o <= x"00001111"; --wait		
--			cbc_ctrl_i2c_command <= (others => '0'); --RAZ			
		
		--if cbc_hard_reset = '1' then 
		if cbc_hard_reset = '1' or sclr = '1' then 
			states <= idle_state;
			cbc_ctrl_i2c_settings <= CBC_I2C_CTRL_DIS;	
			cbc_i2c_updating_busy <= '0';
			cbc_i2c_param_word_o <= x"00001111"; --wait		
			cbc_ctrl_i2c_command <= (others => '0'); --RAZ
			--init loop 
			CurrentPageLoop1 : for i_cbc in CBC_NB_BY_FMC-1 downto 0 loop 
				cbc_i2c_currentPage(i_cbc) <= cbc_i2c_page1;--just only here
			end loop;
			--
			cbc_i2c_user_sram_control.reset 			<= '1'; --'1' : en 
			cbc_i2c_user_sram_control.cs 				<= '0'; --'0' : DIS	
			cbc_i2c_user_sram_control.writeEnable 	<= '0'; --'1' : wr / '0' : rd		
			cbc_i2c_user_sram_addr_tmp					<= (others => '0');	
			cbc_i2c_user_sram_rdata_latched			<= (others => '0');	
			latency_counter 								<= (others => '0');	
			--
			cbc_i2c_cmd_ack								<= "00"; --idle
			
--		elsif sclr = '1' then
--			states <= idle_state;
--			cbc_ctrl_i2c_settings <= CBC_I2C_CTRL_DIS;	
--			cbc_i2c_updating_busy <= '0';
--			cbc_i2c_param_word_o <= x"00001111"; --wait		
--			cbc_ctrl_i2c_command <= (others => '0'); --RAZ	
--			--
--			cbc_i2c_user_sram_control.reset 			<= '1'; --'1' : en 
--			cbc_i2c_user_sram_control.cs 				<= '0'; --'0' : DIS	
--			cbc_i2c_user_sram_control.writeEnable 	<= '0'; --'1' : wr / '0' : rd				
--			cbc_i2c_user_sram_addr_tmp					<= (others => '0');
--			cbc_i2c_user_sram_rdata_latched			<= (others => '0');
--			cbc_i2c_user_sram_wdata						<= (others => '0');	
--			--latency_counter 								<= (others => '0');	
--			--new
--			latency_counter 								<= unsigned(cbc_i2c_param_word_i(4 downto 0)); --updated	
--			--
--			cbc_i2c_cmd_ack								<= "00"; --idle			
		--	
		else
			case states is
				--
				when idle_state =>
					--if cbc_i2c_updating_rq = '1' then --one pulse
					if cbc_i2c_cmd_rq(0) = '1' then 
						cbc_i2c_updating_busy 						<= '1';
						--states 											<= enable_i2c_ctrl_state;
						--new
						states 											<= read_latency_ctrl_state;
						
						
						cbc_i2c_param_word_o 						<= x"00002222"; --busy
						cbc_i2c_user_sram_addr_tmp 				<= (others => '0'); --RAZ
						cbc_i2c_user_sram_control.cs 				<= '1'; -- EN
					--
					else
						cbc_ctrl_i2c_settings 						<= CBC_I2C_CTRL_DIS;
						cbc_i2c_updating_busy 						<= '0';
						cbc_i2c_param_word_o 						<= x"00001111"; --wait
						cbc_ctrl_i2c_command 						<= (others => '0'); --RAZ
						--
						cbc_i2c_user_sram_control.reset 			<= '0'; -- DIS 
						cbc_i2c_user_sram_control.cs 				<= '0'; -- DIS	
						cbc_i2c_user_sram_control.writeEnable 	<= '0'; -- RD	
						cbc_i2c_user_sram_addr_tmp					<= (others => '0');
						--cbc_i2c_user_sram_rdata_latched			<= (others => '0');
						cbc_i2c_user_sram_wdata						<= (others => '0');
						--new
						latency_counter 								<= unsigned(cbc_i2c_param_word_i(4 downto 0)); --updated
						--
						cbc_i2c_cmd_ack								<= "00"; --idle						
					end if;
				
				--
				when enable_i2c_ctrl_state =>
					cbc_ctrl_i2c_settings 							<= CBC_I2C_CTRL_EN;
					states 												<= latch_dataWord_state; --test_reg0AndPage_state;
						

					
				--
				when latch_dataWord_state => 				
					
					--read sram word
					cbc_i2c_user_sram_control.writeEnable 		<= '0'; -- RD
					cbc_i2c_user_sram_rdata_latched 				<= cbc_i2c_user_sram_rdata;	
					states 												<= test_reg0AndPage_state;
					--
					cbc_i2c_user_sram_control.cs 					<= '0'; --'0' : DIS
					
					
--					--new / latency ctrl
--					if cbc_i2c_user_sram_rdata /= std_logic_vector(to_unsigned(0,36)) then
--						--read sram word
--						cbc_i2c_user_sram_control.writeEnable 		<= '0'; -- RD
--						cbc_i2c_user_sram_rdata_latched 				<= cbc_i2c_user_sram_rdata;	
--						states 												<= test_reg0AndPage_state;
--						--
--						cbc_i2c_user_sram_control.cs 					<= '0'; --'0' : DIS
--					end if;
				
				--
				when test_reg0AndPage_state =>
					--
					if cbc_i2c_user_sram_rdata_latched(31 downto 0) = x"ffffffff" then --FLAG END
						states 											<= end_test_state;
					elsif cbc_i2c_param_word_addrPart = cbc_i2c_reg0_addr then --reg0 ?
						--direct
						states 											<= i2c_ctrl_transmitCmd_state;
						CBC_I2C_CTRL_regAddr 						<= cbc_i2c_param_word_addrPart;
						CBC_I2C_CTRL_regData 						<= cbc_i2c_param_word_dataPart;	
						CBC_I2C_CTRL_ACCESS_MODE 					<= cbc_i2c_cmd_rq(1); --'0' : Rd / '1' : Wr
--						if cbc_i2c_updating_rq = '1' then
--							CBC_I2C_CTRL_ACCESS_MODE <= CBC_I2C_CTRL_WR_MODE;
--						else
--							CBC_I2C_CTRL_ACCESS_MODE <= CBC_I2C_CTRL_RD_MODE;
--						end if;
						--
					elsif cbc_i2c_param_word_pagePart /= cbc_i2c_currentPage(to_integer(unsigned(cbc_i2c_param_word_cbcPart))) then 
						--modify reg0
						states 											<= modifyPage_state;
					--
					else
						--direct
						states 											<= i2c_ctrl_transmitCmd_state;
						CBC_I2C_CTRL_regAddr 						<= cbc_i2c_param_word_addrPart;
						CBC_I2C_CTRL_regData 						<= cbc_i2c_param_word_dataPart;	
						CBC_I2C_CTRL_ACCESS_MODE 					<= cbc_i2c_cmd_rq(1); --'0' : Rd / '1' : Wr
					end if;

				--
				when i2c_ctrl_transmitCmd_state =>
					cbc_ctrl_i2c_command <= 	CBC_I2C_CTRL_STROBE   		&
														"00000"					 		&
														CBC_I2C_CTRL_16b_MODE 		&
														CBC_I2C_CTRL_RAL_MODE 		&
														--CBC_I2C_CTRL_WR_MODE	 		&
														CBC_I2C_CTRL_ACCESS_MODE 	&
														CBC_I2C_ADDR(to_integer(unsigned(cbc_i2c_param_word_cbcPart)))	&
														CBC_I2C_CTRL_regAddr			&
														CBC_I2C_CTRL_regData				;
					
					states 					<= i2c_ctrl_ACK_test_state;
				--
				when i2c_ctrl_ACK_test_state =>
					cbc_ctrl_i2c_command(31 downto 28) <= (others => '0'); --RAZ strobe
					if cbc_ctrl_i2c_done = '1' then
						if cbc_i2c_cmd_rq(1) = '0' then  --RD ?
							--cbc_i2c_param_word_o <= cbc_ctrl_i2c_reply; --OK
							--WR in  MEMORY							
							cbc_i2c_user_sram_control.writeEnable 	<= '1'; -- WR
							--cbc_i2c_user_sram_wdata	<= x"0" & x"ffffffff"; 
							cbc_i2c_user_sram_wdata	<= x"0" & cbc_i2c_user_sram_rdata_latched(31 downto 8) & cbc_ctrl_i2c_reply(7 downto 0);
							--cbc_i2c_user_sram_wdata	<= x"0" & cbc_i2c_user_sram_rdata_latched(31 downto 0);
							states <= raz_writeEnable_state;--write_latency_ctrl_state;--sram_addr_set_state;--end_test_state;
							--add
							cbc_i2c_user_sram_control.cs 	<= '1'; -- EN
						--	
						else --WR in CBC ?
							states <= raz_writeEnable_state;--write_latency_ctrl_state;--sram_addr_set_state;--end_test_state;							
						end if;
					--
					else
						cbc_i2c_param_word_o <= cbc_i2c_user_sram_rdata_latched(31 downto 0); --x"00003333"; --wait done
					end if;
					latency_counter <= unsigned(cbc_i2c_param_word_i(4 downto 0));					
					
				--
				when write_latency_ctrl_state =>
					if latency_counter = 0 then
						states <= raz_writeEnable_state;
						latency_counter <= unsigned(cbc_i2c_param_word_i(4 downto 0)); --updated
					else
						latency_counter <= latency_counter - to_unsigned(1,5);
					end if;					
					--WR in  MEMORY
					cbc_i2c_user_sram_control.writeEnable 	<= '1'; -- WR
					--cbc_i2c_user_sram_wdata	<= x"0" & x"ffffffff"; --x"0" & cbc_i2c_user_sram_rdata_latched(31 downto 8) & cbc_ctrl_i2c_reply(7 downto 0);
					cbc_i2c_user_sram_wdata	<= x"0" & cbc_i2c_user_sram_rdata_latched(31 downto 8) & cbc_ctrl_i2c_reply(7 downto 0);
				--
				when raz_writeEnable_state => 
					cbc_i2c_user_sram_control.writeEnable 	<= '0'; -- RD
					--add
					cbc_i2c_user_sram_control.cs 	<= '0'; -- DIS
					states <= sram_addr_set_state;
				--
				when sram_addr_set_state => 
					--incrementation of @
					cbc_i2c_user_sram_addr_tmp <= cbc_i2c_user_sram_addr_tmp + to_unsigned(1,21);	
					--Raz Wr_en
					cbc_i2c_user_sram_control.writeEnable 	<= '0'; -- RD					
					states <= read_latency_ctrl_state;
					--add
					cbc_i2c_user_sram_control.cs 	<= '1'; -- EN					
			
				--
				when read_latency_ctrl_state => 
					if latency_counter = 0 then
						states <= enable_i2c_ctrl_state;
						latency_counter <= unsigned(cbc_i2c_param_word_i(4 downto 0)); --updated
					else
						latency_counter <= latency_counter - to_unsigned(1,5);
					end if;
					

				--
				when end_test_state =>
					--
					if cbc_i2c_cmd_rq = "00" then
						states 				<= end_test_state2;--idle_state;
						cbc_i2c_cmd_ack	<= "00"; --idle
						cbc_i2c_param_word_o <= x"00004444"; --end
					else
						cbc_i2c_cmd_ack	<= "01"; --good
						cbc_i2c_param_word_o <= x"AAAAAAAA"; --OK
					end if;
					--
					cbc_ctrl_i2c_settings <= CBC_I2C_CTRL_DIS;


				--
				when end_test_state2 =>				
					if cbc_i2c_cmd_rq = "00" then
						states 	<= idle_state;
					end if;

--				--
--				when end_test_state =>
--					--if cbc_i2c_updating_rq = '0' then
--					if cbc_i2c_cmd_rq(0) = '0' then 
--						states <= idle_state;
--						cbc_i2c_param_word_o <= x"00004444"; --end
--					end if;
--					cbc_i2c_param_word_o <= x"AAAAAAAA"; --OK
					
					
				--
				when modifyPage_state => 
					--
					if cbc_i2c_param_word_pagePart = cbc_i2c_page1 then --going page2 to page1
						CBC_I2C_CTRL_regAddr <= cbc_i2c_reg0_addr;
						CBC_I2C_CTRL_regData <= cbc_i2c_reg0_lastVal(to_integer(unsigned(cbc_i2c_param_word_cbcPart))) and x"7f"; 	--going to page1
						--CBC_I2C_CTRL_regData <= cbc_i2c_reg0_lastValMaskPage1(to_integer(unsigned(cbc_i2c_param_word_cbcPart))) 
					--
					else	--cbc_i2c_page2 ----> going page1 to page2 
						CBC_I2C_CTRL_regAddr <= cbc_i2c_reg0_addr;
						CBC_I2C_CTRL_regData <= cbc_i2c_reg0_lastVal(to_integer(unsigned(cbc_i2c_param_word_cbcPart))) or x"80"; 	--going to page2
						--CBC_I2C_CTRL_regData <= cbc_i2c_reg0_lastValMaskPage2(to_integer(unsigned(cbc_i2c_param_word_cbcPart))) 
					--
					--else --bad coding / flag???
					--
					end if;
					CBC_I2C_CTRL_ACCESS_MODE <= CBC_I2C_CTRL_WR_MODE;
					states <= i2c_ctrl_transmitCmdReg0_state;
				--
				when i2c_ctrl_transmitCmdReg0_state =>
					cbc_ctrl_i2c_command <= 	CBC_I2C_CTRL_STROBE   		&
														"00000"					 		&
														CBC_I2C_CTRL_16b_MODE 		&
														CBC_I2C_CTRL_RAL_MODE 		&
														--CBC_I2C_CTRL_WR_MODE	 		&
														CBC_I2C_CTRL_ACCESS_MODE 	&
														CBC_I2C_ADDR(to_integer(unsigned(cbc_i2c_param_word_cbcPart)))	&
														CBC_I2C_CTRL_regAddr			&
														CBC_I2C_CTRL_regData				;
					states <= i2c_ctrl_ACK_test_CmdReg0_state;	

				--
				when i2c_ctrl_ACK_test_CmdReg0_state =>
					cbc_ctrl_i2c_command(31 downto 28) <= (others => '0'); --RAZ strobe
					if cbc_ctrl_i2c_done = '1' then
						--cbc_i2c_param_word_o <= cbc_ctrl_i2c_reply; --OK
						states <= wait_state; --test_reg0AndPage_state;
						cbc_i2c_currentPage(to_integer(unsigned(cbc_i2c_param_word_cbcPart))) <= cbc_i2c_param_word_pagePart;
					--else
						--cbc_i2c_param_word_o <= x"00003333"; --wait done
					end if;					
				
				when wait_state =>
					if cbc_ctrl_i2c_done = '0' then
						states <= test_reg0AndPage_state;
					end if;
				
				when restoring_reg0_state =>
					CBC_I2C_CTRL_regAddr <= cbc_i2c_reg0_addr;
					CBC_I2C_CTRL_regData <= cbc_i2c_reg0_lastVal(to_integer(unsigned(cbc_i2c_param_word_cbcPart)));					
					states <= i2c_ctrl_transmitCmd_state;
				--
				when others =>
					null;
			end case;
		end if;
	end process;


	--===============================================================================================--
					





end Behavioral;

