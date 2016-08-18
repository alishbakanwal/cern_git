library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;
use work.system_package.all;

entity ipb_user_control_regs is
generic(addr_width : natural := 6);
port
(
	clk					: in 	std_logic;
	reset					: in 	std_logic;
	ipb_mosi_i			: in 	ipb_wbus;
	ipb_miso_o			: out ipb_rbus;
	------------------
	regs_o				: out	array_32x32bit
);
	
end ipb_user_control_regs;

architecture rtl of ipb_user_control_regs is

signal regs: array_32x32bit;		

	signal sel: integer range 0 to 31;
	signal ack: std_logic;

	attribute keep: boolean;
	attribute keep of ack: signal is true;
	attribute keep of sel: signal is true;


begin

	--=============================--
	-- io mapping
	--=============================--
	regs_o 		<= regs;


	--=============================--
	sel <= to_integer(unsigned(ipb_mosi_i.ipb_addr(addr_width downto 0))) when addr_width>0 else 0;
	--=============================--
	

	--=============================--
	process(reset, clk)
	--=============================--
	begin
	if reset='1' then
		regs 	 <= (others=> (others=>'0'));
		ack 	 <= '0';
	elsif rising_edge(clk) then
		-- write
		if ipb_mosi_i.ipb_strobe='1' and ipb_mosi_i.ipb_write='1' then
				regs(sel) <= ipb_mosi_i.ipb_wdata;
		end if;
		-- read 
		ipb_miso_o.ipb_rdata <= regs(sel);
		-- ack
		ack <= ipb_mosi_i.ipb_strobe and not ack;

	end if;
	end process;
	
	ipb_miso_o.ipb_ack <= ack;
	ipb_miso_o.ipb_err <= '0';

end rtl;