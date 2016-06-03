library ieee;
use ieee.std_logic_1164.all;
use work.ipbus.all;
use work.wb_package.all;
use work.user_addr_decode.all;
use work.user_package.all;

entity ipbus_to_wb_bridge is
port
(
	 ipb_clk			: in 	std_logic;
	 rst				: in 	std_logic;
	 ipb_in			: in 	ipb_wbus;
	 ipb_out			: out ipb_rbus;
	 wb_to_slaves	: out wb_mosi_bus_array(0 to number_of_wb_slaves-1);
	 wb_from_slaves: in 	wb_miso_bus_array(0 to number_of_wb_slaves-1)
);
end ipbus_to_wb_bridge;

architecture rtl of ipbus_to_wb_bridge is

	attribute keep: boolean;
	signal 	 sel_wb_slave: integer;
	attribute keep of sel_wb_slave: signal is true;
	
	signal previous_ack 		: std_logic;
	signal previous_ack2		: std_logic;
	signal previous_stb 		: std_logic;
	signal stb					: std_logic;	

begin

	--====
	process(ipb_in.ipb_addr)
	--====
	begin
		sel_wb_slave <= user_wb_addr_sel(ipb_in.ipb_addr); -- function in "user_addr_decode.vhd" package
	end process;
	--====

	--====--
	edge_detect:process(ipb_clk, rst)
	--====
		variable ack_falling_edge	: std_logic;
		variable stb_rising_edge	: std_logic;

	begin
	if rst='1' then
		previous_ack 		<= '0'; ack_falling_edge	:= '0';		
		previous_stb 		<= '0'; stb_rising_edge		:= '0';	
					
				
	elsif rising_edge(ipb_clk) then
		
		previous_stb <= ipb_in.ipb_strobe;
		previous_ack2<= previous_ack;
		previous_ack <= wb_from_slaves(sel_wb_slave).wb_ack;

		stb_rising_edge	:= '0';
		if 	previous_stb='0' 	and ipb_in.ipb_strobe = '1' 						then 	stb_rising_edge	:= '1';	
		end if;

		ack_falling_edge	:= '0';
		if previous_ack='1' 		and wb_from_slaves(sel_wb_slave).wb_ack = '0' then	ack_falling_edge	:= '1';	
		end if;

--		if 	stb_rising_edge ='1' 							then stb <= '1'; 
--		elsif ack_falling_edge='1' 							then stb <= '0'; 
--		elsif wb_from_slaves(sel_wb_slave).wb_ack = '1' then stb <= '0';
--		elsif previous_ack = '1'								then stb <= '0';
--		elsif previous_ack = '1'								then stb <= '0';
--		end if;

		if 	wb_from_slaves(sel_wb_slave).wb_ack = '1'		then stb <= '0';
		elsif	previous_ack 		= '1'								then stb <= '0';
		elsif previous_ack2 		= '1'								then stb <= '0';
		elsif ipb_in.ipb_strobe = '1'								then stb <= '1';
		end if;
		
	end if;
	end process;
	--==== 

	--==== master -> all slaves =====--
	busgen: for i in number_of_wb_slaves-1 downto 0 generate
	--====
	begin
		wb_to_slaves(i).wb_clk 		<= ipb_clk;
		wb_to_slaves(i).wb_rst 		<= rst;
		wb_to_slaves(i).wb_adr 		<= ipb_in.ipb_addr;
		wb_to_slaves(i).wb_dat 		<= ipb_in.ipb_wdata;
		wb_to_slaves(i).wb_we 		<= ipb_in.ipb_write;
		wb_to_slaves(i).wb_sel		<= "1111";
		wb_to_slaves(i).wb_cyc		<= '1';
		wb_to_slaves(i).wb_stb 		<= '0' when sel_wb_slave/=i 	else 	stb;
	
	end generate;
	--====


	--==== selected slave -> master =====--
	ipb_out.ipb_rdata 	<= wb_from_slaves(sel_wb_slave).wb_dat;
	ipb_out.ipb_ack 		<= wb_from_slaves(sel_wb_slave).wb_ack;
	ipb_out.ipb_err 		<= wb_from_slaves(sel_wb_slave).wb_err;
	--====
	
end rtl;

