library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.system_package.all;
--! user packages
use work.user_package.all;
use work.user_addr_decode.all;
use work.wb_package.all;


entity wb_user_regs is
	generic(addr_width : natural := 6);
port
(
	wb_mosi			: in  wb_mosi_bus;
	wb_miso			: out	wb_miso_bus;
	---------------
	regs_o			: out	array_32x32bit;
	regs_i			: in	array_32x32bit
	 );
end wb_user_regs;

architecture rtl of wb_user_regs is

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

	
	--=============================--
	-- read-only registers
	--=============================--
	regs(0) 		<= regs_i(0);	
	regs(1) 		<= regs_i(1);	
	regs(2) 		<= regs_i(2);	
	regs(3) 		<= regs_i(3);	
	regs(4) 		<= regs_i(4);
	regs(5) 		<= regs_i(5);
	regs(6) 		<= regs_i(6);
	regs(7)		<= regs_i(7);
	regs(8) 		<= regs_i(8);	
	regs(9) 		<= regs_i(9);	
	regs(10)		<= regs_i(10);	
	regs(11)		<= regs_i(11);	
	regs(12)		<= regs_i(12);
	regs(13)		<= regs_i(13);
	regs(14)		<= regs_i(14);
	regs(15)		<= regs_i(15);
	--=============================--

	
	
	
	
	
	--=============================--
	sel <= to_integer(unsigned(wb_mosi.wb_adr(addr_width downto 0))) when addr_width>0 else 0;
	--=============================--
	
	
	--=============================--
	process(wb_mosi.wb_rst, wb_mosi.wb_clk)
	--=============================--
	begin
	if wb_mosi.wb_rst='1' then
	
		regs(16) <= x"00000000";
		regs(17) <= x"00000000";
		regs(18) <= x"00000000";
		regs(19) <= x"00000006"; -- gtx_conf default diff_ctrl -> "0110"
		regs(20) <= x"00000000";
		regs(21) <= x"00000000";
		regs(22) <= x"00000000";
		regs(23) <= x"00000000";
		
		regs(24) <= x"00000000";
		regs(25) <= x"00000000";
		regs(26) <= x"00000000";
		regs(27) <= x"00000006"; -- gtx_conf default diff_ctrl -> "0110"
		regs(28) <= x"00000000";
		regs(29) <= x"00000000";
		regs(30) <= x"00000000";
		regs(31) <= x"00000000";
		
		ack 		<= '0';
	
	elsif rising_edge(wb_mosi.wb_clk) then
	
		if wb_mosi.wb_stb='1' and wb_mosi.wb_we='1' then
			case sel is
				--when 	4|5|6|9|10|11|13|14|16|17 	=> regs(sel) <= wb_mosi.wb_dat;
				--when 16 to 31 							=> regs(sel) <= wb_mosi.wb_dat;
				when 16 	=> regs(16) <= wb_mosi.wb_dat;
				when 17 	=> regs(17) <= wb_mosi.wb_dat;
				when 18 	=> regs(18) <= wb_mosi.wb_dat;
				when 19 	=> regs(19) <= wb_mosi.wb_dat;
				when 20 	=> regs(20) <= wb_mosi.wb_dat;
				when 21 	=> regs(21) <= wb_mosi.wb_dat;
				when 22 	=> regs(22) <= wb_mosi.wb_dat;
				when 23 	=> regs(23) <= wb_mosi.wb_dat;
				when 24 	=> regs(24) <= wb_mosi.wb_dat;
				when 25 	=> regs(25) <= wb_mosi.wb_dat;
				when 26 	=> regs(26) <= wb_mosi.wb_dat;
				when 27 	=> regs(27) <= wb_mosi.wb_dat;
				when 28 	=> regs(28) <= wb_mosi.wb_dat;
				when 29 	=> regs(29) <= wb_mosi.wb_dat;
				when 30 	=> regs(30) <= wb_mosi.wb_dat;
				when 31 	=> regs(31) <= wb_mosi.wb_dat;					
				when others 	=> 
			end case;	
		end if;

		wb_miso.wb_dat <= regs(sel);
		ack <= wb_mosi.wb_stb and (not ack);
	
	end if;
	end process;
		
	wb_miso.wb_ack  <= ack;
	wb_miso.wb_err  <= '0';

end rtl;