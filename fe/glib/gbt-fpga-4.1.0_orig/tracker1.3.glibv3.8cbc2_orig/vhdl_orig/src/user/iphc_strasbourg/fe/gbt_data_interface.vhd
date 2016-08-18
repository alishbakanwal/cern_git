----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:41:55 10/17/2013 
-- Design Name: 
-- Module Name:    gbt_data_interface - Behavioral 
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
-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--! system packages
use work.system_flash_sram_package.all;


--! user packages
use work.user_package.all;

entity gbt_data_interface is
--   generic (    
--      COMMON_STATIC_PATTERN_I                   : std_logic_vector(83 downto 0) := x"0000BABEAC1DACDCFFFFF";
--		WIDEBUS_STATIC_PATTERN_I						: std_logic_vector(31 downto 0) := x"BEEFCAFE"	
--				);    
   port (	common_frame_clk_i						: in std_logic;
				reset_from_user_i							: in std_logic;
				from_gbtRx_data_i							: in 	std_logic_vector(83 downto 0);	
				to_gbtTx_data_o							: out std_logic_vector(83 downto 0);
				--system_flash_sram_package.vhd
				gbt_sram_control_o						: out userSramControlR_array(1 to 2); 
				gbt_sram_addr_o							: out array_2x21bit;							
				gbt_sram_rdata_i							: in array_2x36bit;		
				gbt_sram_wdata_o							: out array_2x36bit;
				--
				REG_CTRL_o									: out array_REG_CTRL_WORD_DEPTHx32; --! user_package
				REG_STATUS_i								: in array_REG_STATUS_WORD_DEPTHx32
			);	
end gbt_data_interface;

architecture Behavioral of gbt_data_interface is

	constant sram1											: natural 	:= 1; --already declared into system_package
	constant sram2											: natural 	:= 2;	

	constant FIRST_ADDR_SRAM1_12b						: std_logic_vector(11 downto 0) 	:= x"FFC";
	constant LAST_ADDR_SRAM1_12b						: std_logic_vector(11 downto 0) 	:= x"FFD";
	constant FIRST_ADDR_SRAM2_12b						: std_logic_vector(11 downto 0) 	:= x"FFE";
	constant LAST_ADDR_SRAM2_12b						: std_logic_vector(11 downto 0) 	:= x"FFF";

	constant HEADER_ADDR_SRAM1_11b					: std_logic_vector(10 downto 0) 	:= x"FF" & "110";
	constant HEADER_ADDR_SRAM2_11b					: std_logic_vector(10 downto 0) 	:= x"FF"	& "111";

--	--se user_package
--	--REG CTRL
--	constant	REG_CTRL_WORD_DEPTH						: natural := 5;
--	constant	REG_CTRL_WORD_NB							: natural := 2**REG_CTRL_WORD_DEPTH;
--	
--	constant HEADER_ADDR_REG_CTRL						: std_logic_vector(31 downto 0+REG_CTRL_WORD_DEPTH) 	:= std_logic_vector(to_unsigned(0,32-REG_CTRL_WORD_DEPTH)); --x"000000";
--	
--	type array_REG_CTRL_WORD_DEPTHx32 				is array (REG_CTRL_WORD_NB-1 downto 0) of std_logic_vector(31 downto 0);
--	signal REG_CTRL										: array_REG_CTRL_WORD_DEPTHx32;
--
--	--REG STATUS
--	--comment: REG_STATUS_WORD_DEPTH >or= REG_CTRL_WORD_DEPTH
--	constant	REG_STATUS_WORD_DEPTH					: natural := 5;
--	constant	REG_STATUS_WORD_NB						: natural := 2**REG_STATUS_WORD_DEPTH;
--	
--	constant HEADER_ADDR_REG_STATUS					: std_logic_vector(31 downto 0+REG_STATUS_WORD_DEPTH) := std_logic_vector(to_unsigned(1,32-REG_STATUS_WORD_DEPTH));
--
--	type array_REG_STATUS_WORD_DEPTHx32 			is array (REG_STATUS_WORD_NB-1 downto 0) of std_logic_vector(31 downto 0);
--	signal REG_STATUS										: array_REG_STATUS_WORD_DEPTHx32;	
--	-------------



	--
	constant RdMode										: std_logic_vector := "01"; 
	constant WrMode										: std_logic_vector := "10";	

	-- Arrays:
	type array_2x2bit  									is array (1 to 2) of std_logic_vector(1 downto 0);	
	--signal LastAccessMode : array_2x2bit;
	signal LastAccessMode 								: std_logic_vector(1 downto 0):=(others=>'0');

	alias D32 					: std_logic_vector(31 downto 0) 	is from_gbtRx_data_i(31 downto 0)		;--:=(others=>'0');
	alias A32 					: std_logic_vector(31 downto 0) 	is from_gbtRx_data_i(63 downto 32)		;--:=(others=>'0');
	alias A32_First21b		: std_logic_vector(20 downto 0) 	is from_gbtRx_data_i(32+20 downto 32)	;--:=(others=>'0');	
	alias A32_Last12b			: std_logic_vector(11 downto 0) 	is from_gbtRx_data_i(63 downto 63-11)	;--:=(others=>'0');
	alias A32_Last11b			: std_logic_vector(10 downto 0) 	is from_gbtRx_data_i(63 downto 63-10)	;--:=(others=>'0');	
	alias AccessMode 			: std_logic_vector(1 downto 0)	is from_gbtRx_data_i(65 downto 64)		;--:=(others=>'0');



	--type userSramControlR_array_2xuserSramControlR is array(1 downto 0) of userSramControlR;
	signal gbt_sram_control_tmp		: userSramControlR_array(1 to 2); 
	--signal gbt_sram_control_tmp		: userSramControlR_array_2xuserSramControlR;--userSramControlR_array;

	signal gbt_sram_addr_tmp			: array_2x21bit;							
	signal gbt_sram_rdata_tmp			: array_2x36bit;		
	signal gbt_sram_wdata_tmp			: array_2x36bit;



	--param
	signal SRAM_RdLatency 						: std_logic_vector(2 downto 0):=std_logic_vector(to_unsigned(3,3));	
	signal counter1 								: unsigned(SRAM_RdLatency'range):=(others=>'0');
	signal counter2 								: unsigned(SRAM_RdLatency'range):=(others=>'0');	


	signal from_gbtRx_data_i_del 				: std_logic_vector(83 downto 0) :=(others=>'0');
	alias D32_del 									: std_logic_vector(31 downto 0) 	is from_gbtRx_data_i_del(31 downto 0)		;--:=(others=>'0');
	alias A32_del 									: std_logic_vector(31 downto 0) 	is from_gbtRx_data_i_del(63 downto 32)		;--:=(others=>'0');	
	alias A32_del_First21b						: std_logic_vector(20 downto 0) 	is from_gbtRx_data_i_del(32+20 downto 32)	;--:=(others=>'0');	
	alias A32_del_Last12b						: std_logic_vector(11 downto 0) 	is from_gbtRx_data_i_del(63 downto 63-11)	;--:=(others=>'0');
	alias A32_del_Last11b						: std_logic_vector(10 downto 0) 	is from_gbtRx_data_i_del(63 downto 63-10)	;--:=(others=>'0');	
	alias AccessMode_del 						: std_logic_vector(1 downto 0)	is from_gbtRx_data_i_del(65 downto 64)		;--:=(others=>'0');	

	signal to_gbtTx_data_tmp					: std_logic_vector(83 downto 0):=(others=>'0');

	signal AccessSel 								: std_logic_vector(2 downto 0) :=(others=>'0');
	constant SRAM1_SEL 							: std_logic_vector(2 downto 0) := "001";
	constant SRAM2_SEL 							: std_logic_vector(2 downto 0) := "010";	
	
	--new
	signal gbt_sram_addr_tmp_del1 			: std_logic_vector(20 downto 0) := (others=>'0');
	signal gbt_sram_control_tmp_cs_del1 	: std_logic := '0';
	
	
	type array_7x84 								is array (7 downto 0) of std_logic_vector(83 downto 0);
	signal from_gbtRx_data_i_delay 			: array_7x84;	
	
begin


	--
	REG_STATUS 	<= REG_STATUS_i;
	REG_CTRL_o	<= REG_CTRL;
	--


	--PARAM
	--BE_SYNC_DONE_O <= REG_CTRL(0)(0);
	SRAM_RdLatency <= REG_CTRL(0)(2 downto 0);
	

---- init step
--gbt_sram_addrStart(sram1)
--gbt_sram_addrStart (sram2)
--
--gbt_sram_wordNb(sram1)
--gbt_sram_wordNb(sram2)
	
--	type array_8x84bit  			is array (8 downto 0) of std_logic_vector(1 downto 0);	
-- 
--	from_gbtRx_data_i_del


	--out
	to_gbtTx_data_o 			<= to_gbtTx_data_tmp;
	gbt_sram_control_o 		<= gbt_sram_control_tmp; 
	gbt_sram_addr_o 			<= gbt_sram_addr_tmp;							
	gbt_sram_wdata_o			<= gbt_sram_wdata_tmp;
	
	
	gbt_sram_control_o(sram1).reset 			<= '0'; --DIS
	gbt_sram_control_o(sram2).reset 			<= '0'; --DIS

	gbt_sram_control_tmp(sram1).clk <= common_frame_clk_i;
	gbt_sram_control_tmp(sram2).clk <= common_frame_clk_i;
	
	
	--LATENCY CTRL
	
	--===============================================================================================--
	SHIFT_A32_inst: entity work.SHIFT_A32 
	--===============================================================================================--
		port map (	   clka  		=> common_frame_clk_i,
							wea 			=> (0 => '1'),
							addra 		=> std_logic_vector(counter2),
							dina 			=> from_gbtRx_data_i,
							clkb 			=> common_frame_clk_i,
							addrb 		=> std_logic_vector(counter1),
							doutb 		=> from_gbtRx_data_i_del
					);
	--===============================================================================================--	


	--===============================================================================================--
	process
	--===============================================================================================--	
	begin
	wait until rising_edge(common_frame_clk_i);
		--
		if reset_from_user_i = '1' then
			counter1 <= (others=>'0');
			counter2 <= (others=>'0');
		--
		else
			--
			if counter1 = unsigned(SRAM_RdLatency) then 
				counter1 <= (others=>'0');
			else 
				counter1 <= counter1 + "01";
			end if;
			--
		end if;
		counter2 <= counter1;
	end process;
	--===============================================================================================--


--	--new
--	--
--	from_gbtRx_data_i_delay(0) 		<= from_gbtRx_data_i;
--	--
--	--===============================================================================================--
--	process
--	--===============================================================================================--
--	begin
--	wait until rising_edge(common_frame_clk_i);
----		--
----		from_gbtRx_data_i_delay(0) 		<= from_gbtRx_data_i;
----		--
--		from_gbtRx_data_i_delay_loop : for i in 0 to 6 loop
--			from_gbtRx_data_i_delay(i+1) 	<= from_gbtRx_data_i_delay(i);
--		end loop;
--	end process;
--	--===============================================================================================--
--
--	--===============================================================================================--
--	process
--	--===============================================================================================--
--	begin
--	wait until rising_edge(common_frame_clk_i);
--		from_gbtRx_data_i_del <= from_gbtRx_data_i_delay(to_integer(unsigned(SRAM_RdLatency)));
----		case to_integer(unsigned(SRAM_RdLatency)) is
----			when 0 =>
--	end process;		
--	--===============================================================================================--



	--===============================================================================================--
	process --to_gbtTx_data_tmp
	--===============================================================================================--	
	begin
	wait until rising_edge(common_frame_clk_i);
		--
		if reset_from_user_i = '1' then
			to_gbtTx_data_tmp 			<= (others=>'0');
			REG_CTRL(0)(2 downto 0) 	<= std_logic_vector(to_unsigned(5,3));  --SRAM_RdLatency by def --2 la première fois : ecart de 2
		
		--SRAM1
		--elsif 	AccessMode_del = RdMode and AccessSel = SRAM1_SEL then
		--elsif 	A32_del_Last12b >= FIRST_ADDR_SRAM1_12b and A32_del_Last12b <= LAST_ADDR_SRAM1_12b and AccessMode_del = RdMode then 	
		elsif		A32_del_Last11b = HEADER_ADDR_SRAM1_11b and AccessMode_del = RdMode then
			to_gbtTx_data_tmp	<= std_logic_vector(to_unsigned(0,84-32-32-2)) & WrMode & A32_del & gbt_sram_rdata_i(sram1)(31 downto 0);
		

		--SRAM2
		--elsif 	AccessMode_del = RdMode and AccessSel = SRAM2_SEL then
		--elsif 	A32_del_Last12b >= FIRST_ADDR_SRAM2_12b and A32_del_Last12b <= LAST_ADDR_SRAM2_12b and AccessMode_del = RdMode then
		elsif		A32_del_Last11b = HEADER_ADDR_SRAM2_11b and AccessMode_del = RdMode then 		
			to_gbtTx_data_tmp	<= std_logic_vector(to_unsigned(0,84-32-32-2)) & WrMode & A32_del & gbt_sram_rdata_i(sram2)(31 downto 0);


		--REG CTRL
		elsif A32(HEADER_ADDR_REG_CTRL'range) = HEADER_ADDR_REG_CTRL then
			--AccessSel <= CTRL_REG_SEL;
			--WR MODE
			if 	AccessMode = WrMode then
				--REG_CTRL(to_integer(unsigned(A32_First8b))) <= D32; --256
				REG_CTRL(to_integer(unsigned(A32(REG_CTRL_WORD_DEPTH-1 downto 0)))) <= D32;
			--RD MODE
			elsif AccessMode = RdMode then
				to_gbtTx_data_tmp			<= std_logic_vector(to_unsigned(0,84-32-32-2)) & WrMode & A32 & REG_CTRL(to_integer(unsigned(A32(REG_CTRL_WORD_DEPTH-1 downto 0))));
			else 
				to_gbtTx_data_tmp			<= (others=>'0');
			end if;


		--STATUS CTRL
		elsif A32(HEADER_ADDR_REG_STATUS'range) = HEADER_ADDR_REG_STATUS then
			--AccessSel <= CTRL_REG_SEL;
			--WR MODE
			if 	AccessMode = WrMode then
				--null;
				to_gbtTx_data_tmp			<= (others=>'0');
			elsif AccessMode = RdMode then
				to_gbtTx_data_tmp			<= std_logic_vector(to_unsigned(0,84-32-32-2)) & WrMode & A32 & REG_STATUS(to_integer(unsigned(A32(REG_STATUS_WORD_DEPTH-1 downto 0)))); 
			else 
				to_gbtTx_data_tmp			<= (others=>'0');
			end if;
			
		
		--by def
		else 
			to_gbtTx_data_tmp	<= (others=>'0');
		end if;
		
	end process;
	--===============================================================================================--	



	--===============================================================================================--
	process	(	reset_from_user_i, 
					common_frame_clk_i
				)
	--===============================================================================================--
	begin
		--
		if reset_from_user_i = '1' then
			LastAccessMode 									<= "00";--IDLE			
			gbt_sram_control_tmp(sram1).cs				<= '0'; --DIS
			gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
			gbt_sram_control_tmp(sram2).cs				<= '0'; --DIS
			gbt_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD			
			AccessSel											<= (others=>'0');--IDLE					
		--
		elsif rising_edge(common_frame_clk_i) then		
		
			--sram1
			--if A32_Last12b >= FIRST_ADDR_SRAM1_12b and A32_Last12b <= LAST_ADDR_SRAM1_12b then --in continue
			if A32_Last11b = HEADER_ADDR_SRAM1_11b then			
				AccessSel <= SRAM1_SEL;
				--WR MODE - Addressing by GBT_DIN
				if AccessMode = WrMode then
					LastAccessMode 									<= WrMode;
					--sram1 addr
					gbt_sram_addr_tmp(sram1) 						<= A32_First21b; -- gbt_sram_addr_tmp(sram1) + 1 (put all F si 0)
					--sram1 data
					gbt_sram_wdata_tmp(sram1) 						<= x"0" & D32;
					--sram1 ctrl
					gbt_sram_control_tmp(sram1).cs	 			<= '1'; --EN
					gbt_sram_control_tmp(sram1).writeEnable 	<= '1'; --WR

					--Return GBT_din => GBT_dout ?
				--RD MODE
				elsif AccessMode = RdMode then
					LastAccessMode 									<= RdMode;
					--sram1 addr
					--gbt_sram_addr_tmp(sram1) 					  <= A32_First21b; --from gbt
					gbt_sram_addr_tmp_del1							<= A32_First21b; --from gbt
					gbt_sram_addr_tmp(sram1)						<= gbt_sram_addr_tmp_del1;
					--sram1 ctrl
					gbt_sram_control_tmp(sram1).cs				<= '1'; --EN
					gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
					--
					gbt_sram_control_tmp_cs_del1					<= '1';					
				else
					null;		--RAZ CS ???
				end if;

			
			--sram2
			--if A32_Last12b >= FIRST_ADDR_SRAM2_12b and A32_Last12b <= LAST_ADDR_SRAM2_12b then --in continue
			elsif A32_Last11b = HEADER_ADDR_SRAM2_11b then			
				AccessSel <= SRAM2_SEL;
				--WR MODE - Addressing by GBT_DIN
				if AccessMode = WrMode then
					LastAccessMode 									<= WrMode;
					--sram2 addr
					gbt_sram_addr_tmp(sram2) 						<= A32_First21b; -- gbt_sram_addr_tmp(sram2) + 1 (put all F si 0)				
					--sram2 data
					gbt_sram_wdata_tmp(sram2) 						<= x"0" & D32;
					--sram2 ctrl
					gbt_sram_control_tmp(sram2).cs	 			<= '1'; --EN
					gbt_sram_control_tmp(sram2).writeEnable 	<= '1'; --WR			
				--RD MODE
				elsif AccessMode = RdMode then 
					LastAccessMode			 							<= RdMode;		
					--sram2 addr
					--gbt_sram_addr_tmp(sram2) 						<= A32_First21b; -- gbt_sram_addr_tmp(sram2) + 1 (put all F si 0)
					gbt_sram_addr_tmp_del1							<= A32_First21b; --from gbt
					gbt_sram_addr_tmp(sram2)						<= gbt_sram_addr_tmp_del1;	
					--sram2 ctrl
					gbt_sram_control_tmp(sram2).cs				<= '1'; --EN
					gbt_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD
					--
					gbt_sram_control_tmp_cs_del1					<= '1';
				else
					null;		 --RAZ CS ???		
				end if;
			
			--
			else
			
				--new
				gbt_sram_control_tmp_cs_del1					<= '0';				
			
				gbt_sram_control_tmp(sram1).cs 				<= gbt_sram_control_tmp_cs_del1;--'0'; --DIS
				gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
				--
				gbt_sram_addr_tmp_del1							<= (others=>'0');
				--
				gbt_sram_addr_tmp(sram1)						<= gbt_sram_addr_tmp_del1;--(others=>'0');
				gbt_sram_wdata_tmp(sram1)						<= (others=>'0');
				gbt_sram_control_tmp(sram2).cs 				<= gbt_sram_control_tmp_cs_del1;--'0'; --DIS
				gbt_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD
				gbt_sram_addr_tmp(sram2)						<= gbt_sram_addr_tmp_del1;--(others=>'0');
				gbt_sram_wdata_tmp(sram2)						<= (others=>'0');				
								
			end if;			
		
				
		end if;
	end process;
	--===============================================================================================--			
			
				
				
					
				
			



end Behavioral;

