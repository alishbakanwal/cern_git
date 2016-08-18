library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.ipbus.all;
use work.system_package.all;

entity ipb_user_regs is
generic(addr_width : natural := 6);
port
(
	clk					: in 	STD_LOGIC;
	reset					: in 	STD_LOGIC;
	ipbus_in				: in 	ipb_wbus;
	ipbus_out			: out ipb_rbus;
	------------------
	regs_o				: out	array_32x32bit;
	regs_i				: in	array_32x32bit
);
	
end ipb_user_regs;

architecture rtl of ipb_user_regs is

signal regs: array_32x32bit;		

	signal sel: integer range 0 to 31;
	signal ack: std_logic;

	attribute keep: boolean;
	attribute keep of ack: signal is true;
	attribute keep of sel: signal is true;


begin

	--=============================--
	-- IO mapping
	--=============================--
	regs_o 		<= regs;

	regs( 0) 		<= x"acafe00a";	
	regs( 1) 		<= regs_i( 1);	
	regs( 2) 		<= regs_i( 2);	
	regs( 3) 		<= regs_i( 3);
	regs(15) 		<= regs_i(15);
	--=============================--

	
	
	
	
	
	--=============================--
	sel <= to_integer(unsigned(ipbus_in.ipb_addr(addr_width downto 0))) when addr_width>0 else 0;
	--=============================--
	
	
	
	
	
	--=============================--
	process(reset, clk)
	--=============================--
		variable ack_ctrl : std_logic_vector(1 downto 0);
	begin
	if reset='1' then
		regs(4 ) <= x"00000000";	
		regs(5 ) <= x"00000000";	
		regs(6 ) <= x"00000000";	
		regs(7 ) <= x"00000000";	
		regs(8 ) <= x"00000000";	
		regs(9 ) <= x"00000000";	
		regs(10) <= x"00000000";
		regs(11) <= x"00000000";
		regs(12) <= x"00000000";	
		regs(13) <= x"00000000";	
		regs(14) <= x"00000000";	
	
		regs(16) <= x"00000000";	
		regs(17) <= x"00000000";	
		regs(18) <= x"00000000";	
		regs(19) <= x"00000000";	
		regs(20) <= x"00000000";	
		regs(21) <= x"00000000";	
		regs(22) <= x"00000000";	
		regs(23) <= x"00000000";	
		regs(24) <= x"00000000";	
		regs(25) <= x"00000000";	
		regs(26) <= x"00000000";	
		regs(27) <= x"00000000";	
		regs(28) <= x"00000000";	
		regs(29) <= x"00000000";	
		regs(30) <= x"00000000";	
		regs(31) <= x"00000000";	
		ack 	 <= '0';
		ack_ctrl	:= "00";

	elsif rising_edge(clk) then
	
		if ipbus_in.ipb_strobe='1' and ipbus_in.ipb_write='1' then
			case sel is
				--when 	4|5|6|9|10|11|13|14|16|17 	=> regs(sel) <= ipbus_in.ipb_wdata;
				--when 	19 to 31 						=> regs(sel) <= ipbus_in.ipb_wdata;
				when	4 		=> regs(4 )	<= ipbus_in.ipb_wdata;
				when	5 		=> regs(5 )	<= ipbus_in.ipb_wdata;
				when	6 		=> regs(6 )	<= ipbus_in.ipb_wdata;
				when	7 		=> regs(7 )	<= ipbus_in.ipb_wdata;
				when	8 		=> regs(8 )	<= ipbus_in.ipb_wdata;
				when	9 		=> regs(9 )	<= ipbus_in.ipb_wdata;
				when	10		=> regs(10) <= ipbus_in.ipb_wdata;
				when	11		=> regs(11) <= ipbus_in.ipb_wdata;
				when	12		=> regs(12) <= ipbus_in.ipb_wdata;
				when	13		=> regs(13) <= ipbus_in.ipb_wdata;
				when	14		=> regs(14) <= ipbus_in.ipb_wdata;
		
				when	16		=> regs(16) <= ipbus_in.ipb_wdata;
				when	17		=> regs(17) <= ipbus_in.ipb_wdata;
				when	18		=> regs(18) <= ipbus_in.ipb_wdata;
				when	19		=> regs(19) <= ipbus_in.ipb_wdata;
				when	20		=> regs(20) <= ipbus_in.ipb_wdata;
				when	21		=> regs(21) <= ipbus_in.ipb_wdata;
				when	22		=> regs(22) <= ipbus_in.ipb_wdata;
				when	23		=> regs(23) <= ipbus_in.ipb_wdata;
				when	24		=> regs(24) <= ipbus_in.ipb_wdata;
				when	25		=> regs(25) <= ipbus_in.ipb_wdata;
				when	26		=> regs(26) <= ipbus_in.ipb_wdata;
				when	27		=> regs(27) <= ipbus_in.ipb_wdata;
				when	28		=> regs(28) <= ipbus_in.ipb_wdata;
				when	29		=> regs(29) <= ipbus_in.ipb_wdata;
				when	30		=> regs(30) <= ipbus_in.ipb_wdata;
				when	31		=> regs(31) <= ipbus_in.ipb_wdata;
				when others => 
			end case;	
		end if;

		-- read out ------
		ipbus_out.ipb_rdata <= regs(sel);
		
		-- ack control ---
		if ipbus_in.ipb_strobe='1' and ipbus_in.ipb_write='1' then
			ack <= ipbus_in.ipb_strobe;
		else
			case ack_ctrl is
				when "00" => 
									ack <= '0'; if ipbus_in.ipb_strobe='1' then 
									ack <= '1'; ack_ctrl := "01"; end if;
				when "01" => 	ack <= '0'; ack_ctrl := "10";
				when "10" => 	ack <= '0';	ack_ctrl := "11";
				when "11" => 	ack <= '0';	ack_ctrl := "00";
				when others =>
			end case;
		end if;
		-- autoclear -----
		if ipbus_in.ipb_strobe='0' then
			regs(11)(31 downto 28) <= x"0"; --autoclear
			regs(14)(31 downto 28) <= x"0"; --autoclear
		end if;
		------------------
	end if;
	end process;
	
	ipbus_out.ipb_ack <= ack;
	ipbus_out.ipb_err <= '0';

end rtl;
