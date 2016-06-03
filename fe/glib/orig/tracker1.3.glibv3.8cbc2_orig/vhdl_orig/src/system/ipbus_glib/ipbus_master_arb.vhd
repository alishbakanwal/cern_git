library ieee;
use ieee.std_logic_1164.all;
use work.ipbus.all;
use work.ipbus_addr_decode.all;

entity ipbus_master_arb is
port
(
	ipb_clk				: in 	std_logic;
	rst					: in 	std_logic;
	BUS_BUSY_O			: out	std_logic;
	ipb_from_masters	: in 	ipb_wbus_array(3 downto 0);
	ipb_to_masters		: out	ipb_rbus_array(3 downto 0);
	ipb_from_fabric	: in 	ipb_rbus;
	ipb_to_fabric		: out	ipb_wbus
);
end ipbus_master_arb;

architecture rtl of ipbus_master_arb is

	signal master				: std_logic_vector(3 downto 0);
	signal bus_busy			: std_logic;
	
	signal ack_to_masters	: std_logic_vector( 3 downto 0);
	signal err_to_masters	: std_logic_vector( 3 downto 0);
	signal rdata_to_masters	: std_logic_vector(31 downto 0);
	
	signal strobe_to_slave	: std_logic;
	signal write_to_slave	: std_logic;
	signal wdata_to_slave	: std_logic_vector(31 downto 0);
	signal addr_to_slave		: std_logic_vector(31 downto 0);
	
	
	
begin

	BUS_BUSY_O				<= bus_busy;


	process(ipb_clk, rst)
		variable master		: std_logic_vector(3 downto 0);
		
	begin
	if rst='1' then
		
		master				:= "0000";
		bus_busy				<= '0';
		strobe_to_slave 	<= '0';
		ack_to_masters		<= "0000";
		err_to_masters		<= "0000";			

	elsif ipb_clk'event and ipb_clk='1' then
		
		if bus_busy='0' then
			if 		ipb_from_masters(0).ipb_strobe='1' 	then bus_busy <= '1'; master := "0001";
			elsif 	ipb_from_masters(1).ipb_strobe='1' 	then bus_busy <= '1'; master := "0010";
			elsif 	ipb_from_masters(2).ipb_strobe='1'	then bus_busy <= '1'; master := "0100";
			elsif 	ipb_from_masters(3).ipb_strobe='1'	then bus_busy <= '1'; master := "1000";
			end if;
		elsif bus_busy='1' then
			if 		master="0001" and ipb_from_masters(0).ipb_strobe='0'	then bus_busy <= '0';
			elsif 	master="0010" and ipb_from_masters(1).ipb_strobe='0'	then bus_busy <= '0';
			elsif 	master="0100" and ipb_from_masters(2).ipb_strobe='0'	then bus_busy <= '0';
			elsif 	master="1000" and ipb_from_masters(3).ipb_strobe='0'	then bus_busy <= '0';
			end if;
		end if;
		
		--====== master -> slave ======--
		if 		master(0)='1' 	then 	strobe_to_slave 	<= 	ipb_from_masters(0).ipb_strobe;
	 	elsif 	master(1)='1' 	then 	strobe_to_slave 	<= 	ipb_from_masters(1).ipb_strobe;
	 	elsif 	master(2)='1' 	then 	strobe_to_slave 	<= 	ipb_from_masters(2).ipb_strobe;
		elsif 	master(3)='1' 	then 	strobe_to_slave 	<= 	ipb_from_masters(3).ipb_strobe;
		else									strobe_to_slave 	<= 	'0';
		end if;
		
		if 		master(0)='1' 	then 	write_to_slave 	<= 	ipb_from_masters(0).ipb_write;
	 	elsif 	master(1)='1' 	then 	write_to_slave 	<= 	ipb_from_masters(1).ipb_write;
	 	elsif 	master(2)='1' 	then 	write_to_slave 	<= 	ipb_from_masters(2).ipb_write;
		elsif 	master(3)='1' 	then 	write_to_slave 	<= 	ipb_from_masters(3).ipb_write;
		else									write_to_slave 	<= 	'0';
		end if;
		
		if 		master(0)='1' 	then 	addr_to_slave 		<= 	ipb_from_masters(0).ipb_addr;
	 	elsif 	master(1)='1' 	then 	addr_to_slave 		<= 	ipb_from_masters(1).ipb_addr;
	 	elsif 	master(2)='1' 	then 	addr_to_slave 		<= 	ipb_from_masters(2).ipb_addr;
		elsif 	master(3)='1' 	then 	addr_to_slave 		<= 	ipb_from_masters(3).ipb_addr;
		else									addr_to_slave 		<= 	(others => '0');
		end if;
		
		if 		master(0)='1' 	then 	wdata_to_slave 	<= 	ipb_from_masters(0).ipb_wdata;
	 	elsif 	master(1)='1' 	then 	wdata_to_slave 	<= 	ipb_from_masters(1).ipb_wdata;
	 	elsif 	master(2)='1' 	then 	wdata_to_slave 	<= 	ipb_from_masters(2).ipb_wdata;
		elsif 	master(3)='1' 	then 	wdata_to_slave 	<= 	ipb_from_masters(3).ipb_wdata;
		else									wdata_to_slave 	<= 	(others => '0');
		end if;

		--====== slave -> master ======--
		for i in 0 to 3 loop
			if 		master			 (i)='1' 				then 	ack_to_masters(i)	<= ipb_from_fabric.ipb_ack; else 
																				ack_to_masters(i)	<= '0'; 							 end if;
			
			if 		master			 (i)='1' 				then 	err_to_masters(i)	<=	ipb_from_fabric.ipb_err;	-- if 	master is #0 -> forward the err
			elsif 	ipb_from_masters(i).ipb_strobe='1'																			-- else  if bus is busy and strobe from #0 then err->1
						and bus_busy='1'							then 	err_to_masters(i)	<=	'1';								
			else																err_to_masters(i)	<=	'0';	
			end if;
		end loop;
		rdata_to_masters		<= ipb_from_fabric.ipb_rdata;

	end if;
	end process;

	
	--====== master -> slave ======--
	ipb_to_fabric.ipb_strobe	<= strobe_to_slave;
	ipb_to_fabric.ipb_write		<= write_to_slave;
	ipb_to_fabric.ipb_wdata		<= wdata_to_slave;
	ipb_to_fabric.ipb_addr		<= addr_to_slave;
	
	
	
	--====== slave -> master ======--
	miso: for i in 0 to 3 generate
	ipb_to_masters(i).ipb_ack 	<= ack_to_masters(i);
	ipb_to_masters(i).ipb_err	<= err_to_masters(i);
	ipb_to_masters(i).ipb_rdata<= rdata_to_masters;
	end generate;
	
end rtl;

