library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.system_package.all;
--! user packages
use work.user_package.all;
use work.user_version_package.all;
use work.user_addr_decode.all;
use work.wb_package.all;


entity wb_ttc_fmc_regs is
	generic(addr_width : natural := 6);
port
(
	wb_mosi			: in  wb_mosi_bus;
	wb_miso			: out wb_miso_bus;
	---------------
	regs_o			: out array_32x32bit;
	regs_i			: in  array_32x32bit
	 );
end wb_ttc_fmc_regs;

architecture rtl of wb_ttc_fmc_regs is

signal regs: array_32x32bit;		

	signal sel: integer range 0 to 31;
	signal ack: std_logic;

	attribute keep: boolean;
	attribute keep of ack: signal is true;
	attribute keep of sel: signal is true;

	-- constant usr_ver_major: integer:=0;
	-- constant usr_ver_minor: integer:=1;
	-- constant usr_ver_build: integer:=1;
	-- constant usr_ver_year : integer:=12;
	-- constant usr_ver_month: integer:=6;
	-- constant usr_ver_day  : integer:=8;
	
	begin

	--=============================--
	-- IO mapping
	--=============================--
	regs_o 	<= 	regs;

	regs(0) 	<= 	x"75736552";	    -- user_board_id    = 'u' 's' 'e' 'r'
	regs(1) 	<= 	x"74746320";	    -- sys_id			= 't' 't' 'c' 
	regs(2) 	<=  	std_logic_vector(to_unsigned(usr_ver_major,4)) &
						std_logic_vector(to_unsigned(usr_ver_minor,4)) &
						std_logic_vector(to_unsigned(usr_ver_build,8)) &
						std_logic_vector(to_unsigned(usr_ver_year ,7)) &
						std_logic_vector(to_unsigned(usr_ver_month,4)) &
						std_logic_vector(to_unsigned(usr_ver_day  ,5)) ;
	
	--=============================--
	-- read only registers
	--=============================--
	regs(6) 		<= regs_i(6);		-- reg status
	regs(7) 		<= regs_i(7);		
	regs(9) 		<= regs_i(9);		
	regs(12) 	<= regs_i(12);		
	regs(15)		<= regs_i(15);		--	reg i2c reply		
	--acq flags
	regs(17) 	<= regs_i(17);		-- flag status
	regs(18) 	<= regs_i(18);		-- flag status	
	--BC0_counter
	regs(20) 	<= regs_i(20);		-- flag status	
	--CMD_START_counter
	regs(21) 	<= regs_i(21);		-- flag status	
	--L1A_counter
	regs(22) 	<= regs_i(22);		-- flag status	
	--CBC_counter
	regs(23) 	<= regs_i(23);		-- flag status	
	--cbc_v1 on FMC2
	regs(26)		<= regs_i(26);		--	cbc reg i2c reply	
	
	--=============================--
	sel <= to_integer(unsigned(wb_mosi.wb_adr(addr_width downto 0))) when addr_width>0 else 0;
	--=============================--
	
	
	--=============================--
	process(wb_mosi.wb_rst, wb_mosi.wb_clk)
	--=============================--
	begin
	if wb_mosi.wb_rst='1' then
	
		--ttc_fmc
		regs(3 ) <= x"00000000";	
		regs(4 ) <= x"00ba0070";	-- reg ctrl
		regs(5 ) <= x"00000000";	
		regs(8 ) <= x"00000000";	
		regs(10) <= x"00000000";	
		regs(11) <= x"00000000";	
		regs(13) <= x"00000000";	-- reg i2c settings
		regs(14) <= x"00000000";	-- reg i2c command, [31:28] auto-clear
		--acq
		regs(16) <= x"00000000";	-- PC commands
		regs(19) <= x"00000030";	-- PC commands		
		--cbc_v1 on FMC2				
		regs(24) <= x"00000000";	-- cbc reg i2c settings		
		regs(25) <= x"00000000"; 	-- cbc reg i2c command, [31:28] auto-clear	
		regs(27) <= x"00000000";	-- cbc ctrl
		--not used					
		regs(28) <= x"80000000";	
		regs(29) <= x"00000001";	
		regs(30) <= x"00000000";			
		regs(31) <= x"00000000";	
	
		ack 		<= '0';
	
	elsif rising_edge(wb_mosi.wb_clk) then
	
		if wb_mosi.wb_stb='1' and wb_mosi.wb_we='1' then
			case sel is
				when	3 	=> regs(3 )	<= wb_mosi.wb_dat;	
				when	4 	=> regs(4 )	<= wb_mosi.wb_dat;	
				when	5 	=> regs(5 )	<= wb_mosi.wb_dat;	
				when	8 	=> regs(8 )	<= wb_mosi.wb_dat;	
				when	10	=> regs(10) <= wb_mosi.wb_dat;	
				when	11	=> regs(11) <= wb_mosi.wb_dat;	
				when	13	=> regs(13) <= wb_mosi.wb_dat;	
				when	14	=> regs(14) <= wb_mosi.wb_dat;
				--CBC test
				when	16	=> regs(16) <= wb_mosi.wb_dat;
				when	19	=> regs(19) <= wb_mosi.wb_dat;
				--cbc_v1 on FMC2						
				when	24	=> regs(24) <= wb_mosi.wb_dat;	
				when	25	=> regs(25) <= wb_mosi.wb_dat;
				when	27	=> regs(27) <= wb_mosi.wb_dat;				
				--not used	
				when	28	=> regs(28) <= wb_mosi.wb_dat;	
				when	29	=> regs(29) <= wb_mosi.wb_dat;	
				when	30	=> regs(30) <= wb_mosi.wb_dat;	
				when	31	=> regs(31) <= wb_mosi.wb_dat;	
				when others 	=> 
			end case;	
		--add
--		else
--			regs(24)		<= regs_i(24);--rdy
		end if;

		wb_miso.wb_dat <= regs(sel);
		ack <= wb_mosi.wb_stb and (not ack);
	
		-- autoclear -----
		if wb_mosi.wb_stb='0' then
			regs(11)(31 downto 28) <= x"0"; --autoclear
			regs(14)(31 downto 28) <= x"0"; --autoclear
			--cbc_v1 on FMC2
			regs(25)(31 downto 28) <= x"0"; --autoclear
		end if;

	
	
	end if;
	end process;
		
	wb_miso.wb_ack  <= ack;
	wb_miso.wb_err  <= '0';

end rtl;