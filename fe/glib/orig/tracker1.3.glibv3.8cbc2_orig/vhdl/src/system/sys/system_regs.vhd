library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--! system packages
use work.ipbus.all;
use work.system_package.all;
--! user packages
use work.system_version_package.all;

entity system_regs is
generic(addr_width : natural := 6);
port
(
	clk					: in 	std_logic;
	reset					: in 	std_logic;
	ipbus_in				: in 	ipb_wbus;
	ipbus_out			: out ipb_rbus;
	------------------
	regs_o				: out	array_32x32bit;
	regs_i				: in	array_32x32bit
);
	
end system_regs;

architecture rtl of system_regs is

signal regs: array_32x32bit;		

	signal sel: integer range 0 to 31;
	signal ack: std_logic;
	
	attribute keep: boolean;
	attribute keep of ack: signal is true;
	attribute keep of sel: signal is true;


begin

	--=============================--
	-- read only registers
	--=============================--
	regs_o 		<= regs;

	regs(0) 		<= x"474c4942";	-- board_id    	= 'g' 'l' 'i' 'b'
	regs(1) 		<= sys_id;			-- sys_id			= 'l' 'a' 'b' or 'u' 't' 'c' 'a'
	regs(2) 		<= std_logic_vector(to_unsigned(sys_ver_major,4)) &
						std_logic_vector(to_unsigned(sys_ver_minor,4)) &
						std_logic_vector(to_unsigned(sys_ver_build,8)) &
						std_logic_vector(to_unsigned(sys_ver_year ,7)) &
						std_logic_vector(to_unsigned(sys_ver_month,4)) &
						std_logic_vector(to_unsigned(sys_ver_day  ,5)) ;
	
	regs(6) 		<= regs_i(6);		-- reg status
	regs(7) 		<= regs_i(7);		-- reg status 2
	regs(9) 		<= regs_i(9);		
	regs(12) 	<= regs_i(12);		--	reg spi reply
	regs(15)		<= regs_i(15);		--	reg i2c reply

	--===CDCE Phase Monitoring ===--
   regs(17) 	<= regs_i(17);	   -- sfp_phase_mon_stats	
   regs(19) 	<= regs_i(19);	   -- fmc1_phase_mon_stats
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
		regs(3 )	<= x"00000000";	--	reg test
		regs(4 )	<= x"00aa3071";	--	reg ctrl                 (default: xxxx|x0xx|1010|1010|xx11|xx0x|0111|x001)
		regs(5 )	<= x"00000002";	--	reg ctrl 2
		regs(8 ) <= x"00000000";	-- reg ctrl sram
		regs(10) <= x"00000000";	-- reg spi txdata
		regs(11) <= x"00000000";	-- reg spi command          [31:28] auto-clear
		regs(13) <= x"00000000";	-- reg i2c settings
		regs(14) <= x"00000000";	-- reg i2c command          [31:28] auto-clear	
      regs(16) <= x"0000E2C2";	-- sfp_phase_mon_threshold  (90 deg -> mean 0xD2, upper 0xE2, lower 0xC2)
      regs(18) <= x"0000CBAB";	-- fmc1_phase_mon_threshold (90 deg -> mean 0xBB, upper 0xCB, lower 0xAB)
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
      
		ack 		<= '0';
		ack_ctrl	:= "00";
      
	elsif rising_edge(clk) then
	
		if ipbus_in.ipb_strobe='1' and ipbus_in.ipb_write='1' then
			case sel is
				--when 	3|4|5|8|10|11|13|14| 	=> regs(sel) <= ipbus_in.ipb_wdata;
				--when 	16 to 31 					=> regs(sel) <= ipbus_in.ipb_wdata;
				when	3 		=> regs(3 )	<= ipbus_in.ipb_wdata;
				when	4 		=> regs(4 )	<= ipbus_in.ipb_wdata;
				when	5 		=> regs(5 )	<= ipbus_in.ipb_wdata;
				when	8 		=> regs(8 )	<= ipbus_in.ipb_wdata;
				when	10		=> regs(10) <= ipbus_in.ipb_wdata;
				when	11		=> regs(11) <= ipbus_in.ipb_wdata;
				when	13		=> regs(13) <= ipbus_in.ipb_wdata;
				when	14		=> regs(14) <= ipbus_in.ipb_wdata;				
				when	16		=> regs(16) <= ipbus_in.ipb_wdata;				
            when	18		=> regs(18) <= ipbus_in.ipb_wdata;			
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
