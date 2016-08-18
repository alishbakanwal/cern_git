----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:57:25 10/18/2013 
-- Design Name: 
-- Module Name:    gbt_data_interface_be - Behavioral 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
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


entity gbt_data_interface is
   port (	--===============--
				-- Clocks scheme --
				--===============--
				common_frame_clk_i						: in std_logic;
				
				--===============--
				-- Resets scheme --
				--===============-- 				
				reset_from_user_i							: in std_logic;
				
				--=====================--
				-- Request CMD from SW --
				--=====================-- 				
				rq_cmd_from_sw								: in std_logic_vector(7 downto 0);	
				
				-- Parameters:
				--------------
				gbt_sram_wordNb							: in std_logic_vector(20 downto 0); --0 <=> 1 / 2**21-1  <=> 2**21
				SRAM_RdLatency 							: in std_logic_vector(2 downto 0);								
				
				--=================--
				-- Request from SW --
				--=================-- 
				rq_ack_from_be								: out std_logic_vector(1 downto 0);	

				
				--===============--
				-- GBT Link data -- 
				--===============--
				from_gbtRx_data_i							: in 	std_logic_vector(83 downto 0);	
				to_gbtTx_data_o							: out std_logic_vector(83 downto 0);
				
				--=================--
				-- SRAM interfaces -- 
				--=================--				
				--comment: from system_flash_sram_package.vhd
				gbt_sram_control_o						: out userSramControlR_array(1 to 2); 
				gbt_sram_addr_o							: out array_2x21bit;							
				gbt_sram_rdata_i							: in array_2x36bit;		
				gbt_sram_wdata_o							: out array_2x36bit	
				
			);	
end gbt_data_interface;

architecture Behavioral of gbt_data_interface is

	--attribute
	attribute init: string;

	constant sram1										: natural 	:= 1; --already declared into system_package
	constant sram2										: natural 	:= 2;	
	
	
	signal SRAM_ACTIVE								: natural range 1 to 2;


	constant HEADER_ADDR_SRAM1_11b							: std_logic_vector(10 downto 0) 	:= x"FF" & "110";
	constant HEADER_ADDR_SRAM2_11b							: std_logic_vector(10 downto 0) 	:= x"FF"	& "111";

	signal HEADER_ADDR_SRAM_SEL								: std_logic_vector(10 downto 0) 	:= (others=>'0');	 


	--FE REG CTRL
	constant	REG_CTRL_WORD_DEPTH							: natural := 5;
	constant	REG_CTRL_WORD_NB								: natural := 2**REG_CTRL_WORD_DEPTH;
	constant HEADER_ADDR_REG_CTRL							: std_logic_vector(31 downto 0+REG_CTRL_WORD_DEPTH) 	:= std_logic_vector(to_unsigned(0,32-REG_CTRL_WORD_DEPTH)); --x"000000";
	
	--FE REG STATUS
	--comment: REG_STATUS_WORD_DEPTH >or= REG_CTRL_WORD_DEPTH
	constant	REG_STATUS_WORD_DEPTH							: natural := 5;
	constant	REG_STATUS_WORD_NB								: natural := 2**REG_STATUS_WORD_DEPTH;
	constant HEADER_ADDR_REG_STATUS							: std_logic_vector(31 downto 0+REG_STATUS_WORD_DEPTH) := std_logic_vector(to_unsigned(1,32-REG_STATUS_WORD_DEPTH));



	constant RdMode										: std_logic_vector := "01"; 
	constant WrMode										: std_logic_vector := "10";


	constant SW_IDLE : std_logic_vector := std_logic_vector(to_unsigned(0,8)); 
	constant SW_CMD1 : std_logic_vector := std_logic_vector(to_unsigned(1,8)); 
	constant SW_CMD2 : std_logic_vector := std_logic_vector(to_unsigned(2,8));
	constant SW_CMD3 : std_logic_vector := std_logic_vector(to_unsigned(3,8)); 
	constant SW_CMD4 : std_logic_vector := std_logic_vector(to_unsigned(4,8));
	constant SW_CMD5 : std_logic_vector := std_logic_vector(to_unsigned(5,8)); 
	constant SW_CMD6 : std_logic_vector := std_logic_vector(to_unsigned(6,8));
	constant SW_CMD7 : std_logic_vector := std_logic_vector(to_unsigned(7,8)); 
	constant SW_CMD8 : std_logic_vector := std_logic_vector(to_unsigned(8,8));
	constant SW_CMD9 : std_logic_vector := std_logic_vector(to_unsigned(9,8)); 
	constant SW_CMD10 : std_logic_vector := std_logic_vector(to_unsigned(10,8));
	

	constant ACK_IDLE	: std_logic_vector(1 downto 0) := "00"; 	
	constant ACK_GOOD	: std_logic_vector(1 downto 0) := "01"; 	
	constant ACK_FAIL	: std_logic_vector(1 downto 0) := "10"; 		




	signal gbt_sram_control_tmp		: userSramControlR_array(1 to 2); 
	signal gbt_sram_addr_tmp			: array_2x21bit;							
	signal gbt_sram_rdata_tmp			: array_2x36bit;		
	signal gbt_sram_wdata_tmp			: array_2x36bit;	


	signal to_fe_addr_sram_tmp : unsigned(20 downto 0) := (others=>'0');	

	signal counter_gbt_sram_wordNb : integer range 0 to 2**21-1:=0;
	
	signal SRAM_RdLatencyCounter 	: integer range 0 to 7:=0;
	
	
	
	signal to_gbtTx_data_tmp : std_logic_vector(to_gbtTx_data_o'range) := (others=>'0');


	alias D32 				: std_logic_vector(31 downto 0) 	is from_gbtRx_data_i(31 downto 0)		;--:=(others=>'0');
	alias A32 				: std_logic_vector(31 downto 0) 	is from_gbtRx_data_i(63 downto 32)		;--:=(others=>'0');
	alias A32_First21b	: std_logic_vector(20 downto 0) 	is from_gbtRx_data_i(32+20 downto 32)	;--:=(others=>'0');	
	alias A32_Last12b		: std_logic_vector(11 downto 0) 	is from_gbtRx_data_i(63 downto 63-11)	;--:=(others=>'0');
	alias A32_Last11b		: std_logic_vector(10 downto 0) 	is from_gbtRx_data_i(63 downto 63-10)	;--:=(others=>'0');	
	alias AccessMode 		: std_logic_vector(1 downto 0)	is from_gbtRx_data_i(65 downto 64)		;--:=(others=>'0');


	

	--FSM
	type states_type is (	st_idle, 
									st_del1,
									st_RdSramLatency,
									st_RdSramToGbt,
									st_FromGbtToSramLatency,
									st_endReceiving,								
									st_ack
								); 						
	signal state : states_type;		
	
begin


	--out
	--to_gbtTx_data_o 			<= to_gbtTx_data_tmp;
	

	
	
	gbt_sram_control_o 		<= gbt_sram_control_tmp; 
	gbt_sram_addr_o 			<= gbt_sram_addr_tmp;							
	gbt_sram_wdata_o			<= gbt_sram_wdata_tmp;	


	gbt_sram_control_tmp(sram1).clk <= common_frame_clk_i;
	gbt_sram_control_tmp(sram2).clk <= common_frame_clk_i;

	process	
				(	reset_from_user_i, 
					common_frame_clk_i
				)
	begin
		--
		if reset_from_user_i = '1' then
			state													<= st_idle;	
			--sram1
			gbt_sram_control_tmp(sram1).cs				<= '0'; --DIS
			gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
			gbt_sram_control_tmp(sram1).reset			<= '1'; --EN
			--sram2
			gbt_sram_control_tmp(sram2).cs				<= '0'; --DIS
			gbt_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD
			gbt_sram_control_tmp(sram2).reset			<= '1'; --EN			
			--
			
		--
		elsif rising_edge(common_frame_clk_i) then
	
			case state is 
				--
				when st_idle =>
					--CMD Decoding
					--
					if 	rq_cmd_from_sw = SW_CMD1 then --from SRAM1(be) to SRAM1(fe)
						state 												<= st_del1;--st_RdSramLatency;	
						HEADER_ADDR_SRAM_SEL								<= HEADER_ADDR_SRAM1_11b;
						SRAM_ACTIVE											<= sram1;
						gbt_sram_control_tmp(sram1).cs 				<= '1'; --EN
						gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
					--
					elsif rq_cmd_from_sw = SW_CMD2 then --from SRAM2(be) to SRAM2(fe)
						state 												<= st_del1;--st_RdSramLatency;
						HEADER_ADDR_SRAM_SEL								<= HEADER_ADDR_SRAM2_11b;
						SRAM_ACTIVE											<= sram2;
						gbt_sram_control_tmp(sram2).cs 				<= '1'; --EN
						gbt_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD
					--
					elsif	rq_cmd_from_sw = SW_CMD3 then --from SRAM1(fe) to SRAM1(be)
						state 												<= st_FromGbtToSramLatency;
						HEADER_ADDR_SRAM_SEL								<= HEADER_ADDR_SRAM1_11b;
						SRAM_ACTIVE											<= sram1;
						gbt_sram_addr_tmp(sram1) 						<= (others=>'1'); --init
					--
					elsif	rq_cmd_from_sw = SW_CMD4 then --from SRAM2(fe) to SRAM2(be)
						state 												<= st_FromGbtToSramLatency;
						HEADER_ADDR_SRAM_SEL								<= HEADER_ADDR_SRAM2_11b;
						SRAM_ACTIVE											<= sram2;
						gbt_sram_addr_tmp(sram2) 						<= (others=>'1'); --init
					--
					elsif	rq_cmd_from_sw = SW_CMD5 then --from SRAM1(be) to REG_CTRL(fe)
						state 												<= st_del1;--st_RdSramLatency;	
						SRAM_ACTIVE											<= sram1;
						gbt_sram_control_tmp(sram1).cs 				<= '1'; --EN
						gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
					--
					elsif	rq_cmd_from_sw = SW_CMD6 then --from SRAM2(be) to REG_CTRL(fe)
						state 												<= st_del1;--st_RdSramLatency;
						SRAM_ACTIVE											<= sram2;						
						gbt_sram_control_tmp(sram2).cs 				<= '1'; --EN
						gbt_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD
					--
					elsif rq_cmd_from_sw = SW_CMD7 then --from REG_CTRL(fe) to SRAM1(be)
						state 												<= st_FromGbtToSramLatency;
						SRAM_ACTIVE											<= sram1;
						gbt_sram_addr_tmp(sram1) 						<= (others=>'1'); --init						
					--
					elsif rq_cmd_from_sw = SW_CMD8 then --from REG_CTRL(fe) to SRAM2(be)
						state 												<= st_FromGbtToSramLatency;
						SRAM_ACTIVE											<= sram2;
						gbt_sram_addr_tmp(sram2) 						<= (others=>'1'); --init
					--
					elsif rq_cmd_from_sw = SW_CMD9 then --from REG_STATUS(fe) to SRAM1(be)
						state 												<= st_FromGbtToSramLatency;
						SRAM_ACTIVE											<= sram1;
						gbt_sram_addr_tmp(sram1) 						<= (others=>'1'); --init					
					--
					elsif rq_cmd_from_sw = SW_CMD10 then --from REG_STATUS(fe) to SRAM2(be)	
						state 												<= st_FromGbtToSramLatency;
						SRAM_ACTIVE											<= sram2;
						gbt_sram_addr_tmp(sram2) 						<= (others=>'1'); --init
--					--
--					elsif rq_cmd_from_sw = SW_CMD11 then
--						state													<= st_
						
					--
					else
						--by def
						--sram1
						gbt_sram_control_tmp(sram1).cs				<= '0'; --DIS
						gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
						gbt_sram_control_tmp(sram1).reset			<= '0'; --DIS
						gbt_sram_addr_tmp(sram1)						<= (others=>'0');
						gbt_sram_wdata_tmp(sram1)						<= (others=>'0');						
						--sram2
						gbt_sram_control_tmp(sram2).cs				<= '0'; --DIS
						gbt_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD
						gbt_sram_control_tmp(sram2).reset			<= '0'; --DIS
						gbt_sram_addr_tmp(sram2)						<= (others=>'0');
						gbt_sram_wdata_tmp(sram2)						<= (others=>'0');						
						--
						SRAM_RdLatencyCounter 							<= to_integer(unsigned(SRAM_RdLatency));
						to_gbtTx_data_tmp 								<= (others=>'0');
						to_fe_addr_sram_tmp								<= (others=>'0');
						counter_gbt_sram_wordNb							<= to_integer(unsigned(gbt_sram_wordNb)); 
						rq_ack_from_be 									<= ACK_IDLE;	
					end if;
	
				--CS & @=0 + long to access first data !!!
				when st_del1 =>
					state <= st_RdSramLatency;
				
				
				--	latency
				when st_RdSramLatency =>
					--
					if SRAM_RdLatencyCounter = 0 then
						state 						<= st_RdSramToGbt;
					else
						to_gbtTx_data_tmp 		<= (others=>'0');
						SRAM_RdLatencyCounter 	<= SRAM_RdLatencyCounter - 1;
					end if;
					--
					
					gbt_sram_addr_tmp(SRAM_ACTIVE) <= std_logic_vector(unsigned(gbt_sram_addr_tmp(SRAM_ACTIVE)) + "01");
					
				--
				when st_RdSramToGbt =>
--					
--					--0 <=> 1 write
--					to_gbtTx_data_tmp	<= (	std_logic_vector(to_unsigned(0,84-2-11-21-32)) 
--													& WrMode 												
--													& HEADER_ADDR_SRAM_SEL 									
--													& std_logic_vector(to_fe_addr_sram_tmp) 
--													& gbt_sram_rdata_i(SRAM_ACTIVE)(31 downto 0)
--					
--							);

					if		rq_cmd_from_sw = SW_CMD1 or rq_cmd_from_sw = SW_CMD2 then
						to_gbtTx_data_tmp	<= (	std_logic_vector(to_unsigned(0,84-2-11-21-32)) 
														& WrMode 												
														& HEADER_ADDR_SRAM_SEL 									
														& std_logic_vector(to_fe_addr_sram_tmp) 
														& gbt_sram_rdata_i(SRAM_ACTIVE)(31 downto 0)
						
								);	
					elsif	rq_cmd_from_sw = SW_CMD5 or rq_cmd_from_sw = SW_CMD6 then
						to_gbtTx_data_tmp	<= (	std_logic_vector(to_unsigned(0,84-2-11-21-32)) 
														& WrMode 												
														& HEADER_ADDR_REG_CTRL 									
														& std_logic_vector(to_fe_addr_sram_tmp(REG_CTRL_WORD_DEPTH-1 downto 0)) 
														& gbt_sram_rdata_i(SRAM_ACTIVE)(31 downto 0)
						
								);	
					else
						null;
					end if;
					


					--
					if counter_gbt_sram_wordNb = 0 then
						state 									<= st_ack;
					else 
						counter_gbt_sram_wordNb 			<= counter_gbt_sram_wordNb - 1;
					end if;		
					--
					
					gbt_sram_addr_tmp(SRAM_ACTIVE) 		<= std_logic_vector(unsigned(gbt_sram_addr_tmp(SRAM_ACTIVE)) + "01");
					
					--
					to_fe_addr_sram_tmp						<= to_fe_addr_sram_tmp + "01";
				

				--
				when st_FromGbtToSramLatency =>
					--waits & receives data from gbt & storage in continue (add read_counter ???)
					if A32_Last11b = HEADER_ADDR_SRAM_SEL and AccessMode = WrMode then 
						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '1'; --EN						
						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '1'; --WR
						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= x"0" & D32;
						gbt_sram_addr_tmp(SRAM_ACTIVE) 						<= std_logic_vector(unsigned(gbt_sram_addr_tmp(SRAM_ACTIVE)) + "01"); 
					--
					elsif A32(HEADER_ADDR_REG_CTRL'range) = HEADER_ADDR_REG_CTRL and AccessMode = WrMode then
						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '1'; --EN						
						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '1'; --WR
						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= x"0" & D32;
						gbt_sram_addr_tmp(SRAM_ACTIVE) 						<= std_logic_vector(unsigned(gbt_sram_addr_tmp(SRAM_ACTIVE)) + "01");
					--
					elsif A32(HEADER_ADDR_REG_STATUS'range) = HEADER_ADDR_REG_STATUS and AccessMode = WrMode then
						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '1'; --EN						
						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '1'; --WR
						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= x"0" & D32;
						gbt_sram_addr_tmp(SRAM_ACTIVE) 						<= std_logic_vector(unsigned(gbt_sram_addr_tmp(SRAM_ACTIVE)) + "01");						
					--
					else
						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '0'; --DIS						
						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '0'; --RD
						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= (others=>'0');						
					end if;

					--transmits @ + Mode towards gbt
					if 	rq_cmd_from_sw = SW_CMD3 or rq_cmd_from_sw = SW_CMD4 then
						to_gbtTx_data_tmp	<= (	std_logic_vector(to_unsigned(0,84-2-11-21-32)) 
														& RdMode 												
														& HEADER_ADDR_SRAM_SEL 									
														& std_logic_vector(to_fe_addr_sram_tmp) 
														& std_logic_vector(to_unsigned(0,32)) --wdata = 0
													);
					--
					elsif	rq_cmd_from_sw = SW_CMD7 or rq_cmd_from_sw = SW_CMD8 then
						to_gbtTx_data_tmp	<= (	std_logic_vector(to_unsigned(0,84-2-11-21-32)) 
														& RdMode 												
														& HEADER_ADDR_REG_CTRL 									
														& std_logic_vector(to_fe_addr_sram_tmp(REG_CTRL_WORD_DEPTH-1 downto 0)) 
														& std_logic_vector(to_unsigned(0,32)) --wdata = 0
													);
					--
					elsif	rq_cmd_from_sw = SW_CMD9 or rq_cmd_from_sw = SW_CMD10 then
						to_gbtTx_data_tmp	<= (	std_logic_vector(to_unsigned(0,84-2-11-21-32)) 
														& RdMode 												
														& HEADER_ADDR_REG_STATUS 									
														& std_logic_vector(to_fe_addr_sram_tmp(REG_STATUS_WORD_DEPTH-1 downto 0)) 
														& std_logic_vector(to_unsigned(0,32)) --wdata = 0
													);
					--
					else
						to_gbtTx_data_tmp	<= (  std_logic_vector(to_unsigned(0,84)));							
					end if;
					--
					
					--
					to_fe_addr_sram_tmp						<= to_fe_addr_sram_tmp + "01"; --from 0
					
					--					
					if counter_gbt_sram_wordNb = 0 then
						state 									<= st_endReceiving;
					else 
						counter_gbt_sram_wordNb 			<= counter_gbt_sram_wordNb - 1;
					end if;		
					--



--					--waits & receives data from gbt & storage in continue (add read_counter ???)
--					if A32_Last11b = HEADER_ADDR_SRAM_SEL and AccessMode = WrMode then 
--						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '1'; --EN						
--						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '1'; --WR
--						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= x"0" & D32;
--						gbt_sram_addr_tmp(SRAM_ACTIVE) 						<= std_logic_vector(unsigned(gbt_sram_addr_tmp(SRAM_ACTIVE)) + "01"); 
--					else
--						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '0'; --DIS						
--						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '0'; --RD
--						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= (others=>'0');						
--					end if;
--
--					--transmits @ + Mode towards gbt
--					to_gbtTx_data_tmp	<= (	std_logic_vector(to_unsigned(0,84-2-11-21-32)) 
--													& RdMode 												
--													& HEADER_ADDR_SRAM_SEL 									
--													& std_logic_vector(to_fe_addr_sram_tmp) 
--													& std_logic_vector(to_unsigned(0,32)) --wdata = 0
--												);
--					
--					--
--					to_fe_addr_sram_tmp						<= to_fe_addr_sram_tmp + "01"; --from 0
--					
--					--					
--					if counter_gbt_sram_wordNb = 0 then
--						state 									<= st_endReceiving;
--					else 
--						counter_gbt_sram_wordNb 			<= counter_gbt_sram_wordNb - 1;
--					end if;		
--					--
					
						
				--
				when st_endReceiving => --continues receiving

					--receives data from gbt
					if A32_Last11b = HEADER_ADDR_SRAM_SEL and AccessMode = WrMode then 
						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '1'; --EN						
						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '1'; --WR
						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= x"0" & D32; 
						gbt_sram_addr_tmp(SRAM_ACTIVE) 						<= std_logic_vector(unsigned(gbt_sram_addr_tmp(SRAM_ACTIVE)) + "01");
					--
					elsif A32(HEADER_ADDR_REG_CTRL'range) = HEADER_ADDR_REG_CTRL and AccessMode = WrMode then
						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '1'; --EN						
						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '1'; --WR
						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= x"0" & D32;
						gbt_sram_addr_tmp(SRAM_ACTIVE) 						<= std_logic_vector(unsigned(gbt_sram_addr_tmp(SRAM_ACTIVE)) + "01");
					--
					elsif A32(HEADER_ADDR_REG_STATUS'range) = HEADER_ADDR_REG_STATUS and AccessMode = WrMode then
						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '1'; --EN						
						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '1'; --WR
						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= x"0" & D32;
						gbt_sram_addr_tmp(SRAM_ACTIVE) 						<= std_logic_vector(unsigned(gbt_sram_addr_tmp(SRAM_ACTIVE)) + "01");						
					--
					else
						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '0'; --DIS						
						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '0'; --RD
						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= (others=>'0');
						gbt_sram_addr_tmp(SRAM_ACTIVE)						<= (others=>'0');	
						state 														<= st_ack;
					end if;					
					
					--
					to_gbtTx_data_tmp	<= std_logic_vector(to_unsigned(0,84));
					--


--					--receives data from gbt
--					if A32_Last11b = HEADER_ADDR_SRAM_SEL and AccessMode = WrMode then 
--						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '1'; --EN						
--						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '1'; --WR
--						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= x"0" & D32; 
--						gbt_sram_addr_tmp(SRAM_ACTIVE) 						<= std_logic_vector(unsigned(gbt_sram_addr_tmp(SRAM_ACTIVE)) + "01");
--					else
--						gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '0'; --DIS						
--						gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '0'; --RD
--						gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= (others=>'0');
--						gbt_sram_addr_tmp(SRAM_ACTIVE)						<= (others=>'0');	
--						state 														<= st_ack;
--					end if;					
--					
--					--
--					to_gbtTx_data_tmp	<= std_logic_vector(to_unsigned(0,84));
--					--

				--				
				when st_ack =>
					--
					gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '0'; --DIS
					gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '0'; --RD
					gbt_sram_wdata_tmp(SRAM_ACTIVE)				 		<= (others=>'0');
					gbt_sram_addr_tmp(SRAM_ACTIVE)						<= (others=>'0');					
					--
					rq_ack_from_be <= ACK_GOOD;
					--
					to_gbtTx_data_tmp	<= std_logic_vector(to_unsigned(0,84));
					--
					if rq_cmd_from_sw = SW_IDLE then 
						state <= st_idle;
						rq_ack_from_be <= ACK_IDLE;
					end if;
					--
			end case;
		end if;
	end process;
						
					
				
--	--ctrl sram
--	process	
--				(	reset_from_user_i, 
--					common_frame_clk_i
--				)
--	begin
--		--
--		if reset_from_user_i = '1' then
--			state													<= st_idle;	
--			--sram1
--			gbt_sram_control_tmp(sram1).cs				<= '0'; --DIS
--			gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
--			gbt_sram_control_tmp(sram1).reset			<= '1'; --EN
--			--sram2
--			gbt_sram_control_tmp(sram2).cs				<= '0'; --DIS
--			gbt_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD
--			gbt_sram_control_tmp(sram2).reset			<= '1'; --EN			
--		--
--		elsif rising_edge(common_frame_clk_i) then
--	
--			case state is 
--				--
--				when st_idle =>
--					--CMD Decoding
--					--
--					if 	rq_cmd_from_sw = SW_CMD1 then --from SRAM1(be) to SRAM1(fe)
--						state 												<= st_WordCounter;	
--						SRAM_ACTIVE											<= sram1;
--						gbt_sram_control_tmp(sram1).cs 				<= '1'; --EN
--						gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
--					--
--					elsif rq_cmd_from_sw = SW_CMD2 then --from SRAM2(be) to SRAM2(fe)
--						state 												<= st_WordCounter;
--						SRAM_ACTIVE											<= sram2;
--						gbt_sram_control_tmp(sram2).cs 				<= '1'; --EN
--						gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
--					--
--					elsif	rq_cmd_from_sw = SW_CMD3 then --from SRAM1(fe) to SRAM1(be)
--						state 												<= st_WordCounter;
--						SRAM_ACTIVE											<= sram1;
----						gbt_sram_control_tmp(sram1).cs 				<= '1'; --EN						
----						gbt_sram_control_tmp(sram1).writeEnable 	<= '1'; --WR
--					--
--					else
--						--by def
--						--sram1
--						gbt_sram_control_tmp(sram1).cs				<= '0'; --DIS
--						gbt_sram_control_tmp(sram1).writeEnable 	<= '0'; --RD
--						gbt_sram_control_tmp(sram1).reset			<= '0'; --DIS					
--						--sram2
--						gbt_sram_control_tmp(sram2).cs				<= '0'; --DIS
--						gbt_sram_control_tmp(sram2).writeEnable 	<= '0'; --RD
--						gbt_sram_control_tmp(sram2).reset			<= '0'; --DIS					
--						--	
--						gbt_sram_addr_tmp(sram1)						<= (others=>'0');					
--						gbt_sram_addr_tmp(sram2)						<= (others=>'0');
--					end if;
--	
--					
--				--
--				when st_WordCounter =>
--					--					
--					if counter_gbt_sram_wordNb = 0 then
--						state 									<= st_ack;
--					else 
--						counter_gbt_sram_wordNb 			<= counter_gbt_sram_wordNb - 1;
--					end if;		
--					--
--
--				--				
--				when st_ack =>
--					--
--					gbt_sram_control_tmp(SRAM_ACTIVE).cs 				<= '0'; --DIS
--					gbt_sram_control_tmp(SRAM_ACTIVE).writeEnable 	<= '0'; --RD					
--					--
--					rq_ack_from_be <= ACK_GOOD;
--					--
--					to_gbtTx_data_tmp	<= std_logic_vector(to_unsigned(0,84));
--					--
--					if rq_cmd_from_sw = SW_IDLE then 
--						state <= st_idle;
--						rq_ack_from_be <= ACK_IDLE;
--					end if;
--					--
--			end case;
--		end if;
--	end process;			






end Behavioral;

