library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use work.system_package.all;

-------------------------------------------------------------------------------
-- Entity declaration for the example design
-------------------------------------------------------------------------------

----============--
entity ip_mac_select is
----============--
   port(
		clk_i					   : in  std_logic;
		reset_i					: in  std_logic;								
		--#
		user_mac_addr_i		: in 	std_logic_vector(47 downto 0);	
		user_ip_addr_i			: in 	std_logic_vector(31 downto 0);	
		--#
		regs_eeprom_i			: in 	array_16x8bit;	
		regs_slave_i			: in 	array_16x8bit;
		regs_enable				: in 	std_logic;	
		--#
		ext_postfix				: in 	std_logic_vector( 7 downto 0);
		ext_postfix_enable	: in 	std_logic;
		ext_rarp_select		: in 	std_logic;
		--#
		rarp_select				: out	std_logic;
		--#
		mac_addr_o				: out	std_logic_vector(47 downto 0);
		ip_addr_o				: out	std_logic_vector(31 downto 0);
		mac_from_eep_o			: out	std_logic;
		mac_from_slv_o			: out	std_logic;
		mac_from_usr_o			: out	std_logic;
		ip_from_eep_o			: out	std_logic;
		ip_from_slv_o			: out	std_logic;
		ip_from_usr_o			: out	std_logic
   );
end ip_mac_select;
----============--

architecture rtl of ip_mac_select is

constant header_id 	: std_logic_vector(7 downto 0):=x"F5";

signal eep_header 	: std_logic_vector(7 downto 0); 
signal eep_checksum 	: std_logic_vector(7 downto 0); -- unused
signal eep_mac_str 	: std_logic;
signal eep_ip_str		: std_logic;
signal eep_mac_addr	: std_logic_vector(47 downto 0);
signal eep_ip_addr	: std_logic_vector(31 downto 0);		

signal slv_header 	: std_logic_vector(7 downto 0); -- unused
signal slv_checksum 	: std_logic_vector(7 downto 0); -- unused
signal slv_mac_str 	: std_logic;
signal slv_ip_str		: std_logic;
signal slv_mac_addr	: std_logic_vector(47 downto 0);
signal slv_ip_addr	: std_logic_vector(31 downto 0);		

signal mac_addr		: std_logic_vector(47 downto 0);		
signal mac_from_eep	: std_logic;
signal mac_from_slv	: std_logic;
signal mac_from_usr	: std_logic;

signal ip_addr			: std_logic_vector(31 downto 0);		
signal ip_from_eep	: std_logic;
signal ip_from_slv	: std_logic;
signal ip_from_usr	: std_logic;
 

begin

process (clk_i, reset_i)

	variable slv_mac_str_prev : std_logic;
	variable slv_mac_str_curr : std_logic;
	variable slv_ip_str_prev  : std_logic;
	variable slv_ip_str_curr  : std_logic;
	
	variable eep_mac_str_prev : std_logic;
	variable eep_mac_str_curr : std_logic;
	variable eep_ip_str_prev  : std_logic;
	variable eep_ip_str_curr  : std_logic;

begin
if reset_i = '1' then
	
	rarp_select 		<= '0'; 	
	
	mac_addr 			<= user_mac_addr_i;
	mac_from_eep		<= '0';
	mac_from_slv		<= '0';
	mac_from_usr		<= '1';

	ip_addr 				<= user_ip_addr_i;
	ip_from_eep			<= '0';
	ip_from_slv			<= '0';
	ip_from_usr			<= '1';
	
	slv_mac_str_prev 	:= '0';
	slv_mac_str_curr 	:= '0';
	slv_ip_str_prev 	:= '0';
	slv_ip_str_curr 	:= '0';
	
	eep_mac_str_prev 	:= '0';
	eep_mac_str_curr 	:= '0';
	eep_ip_str_prev 	:= '0';
	eep_ip_str_curr 	:= '0';
	
elsif rising_edge(clk_i) then



		
	rarp_select <= '0'; 	if ip_addr = x"00_00_00_00" or ext_rarp_select='1' then rarp_select <= '1'; end if;

	--

	if regs_enable = '1' then

		if eep_mac_str_prev = '0'    and eep_mac_str_curr = '1' and eep_header = header_id then --mac_addr(23 downto 0) <= eep_mac_addr (23 downto 0); 
																															 mac_addr 		<= eep_mac_addr; 
																															 mac_from_eep	<= '1';
																															 mac_from_slv	<= '0';
																															 mac_from_usr	<= '0';
																															 
		elsif slv_mac_str_prev = '0' and slv_mac_str_curr = '1' and slv_header = header_id then mac_addr		<= slv_mac_addr;
																															 mac_from_eep	<= '0';
																															 mac_from_slv	<= '1';
																															 mac_from_usr	<= '0';
		end if;	
	
		if eep_ip_str_prev = '0'    and eep_ip_str_curr = '1' and eep_header = header_id then	ip_addr 			<= eep_ip_addr;
																															ip_from_eep		<= '1';
																															ip_from_slv		<= '0';
																															ip_from_usr		<= '0';

		elsif slv_ip_str_prev = '0' and slv_ip_str_curr = '1' and slv_header = header_id then 	ip_addr 			<= slv_ip_addr;
																															ip_from_eep		<= '0';
																															ip_from_slv		<= '1';
																															ip_from_usr		<= '0';
		end if;	
	
	end if;	
	
	slv_mac_str_prev := slv_mac_str_curr; slv_mac_str_curr:= slv_mac_str; 
	eep_mac_str_prev := eep_mac_str_curr; eep_mac_str_curr:= eep_mac_str; 
	slv_ip_str_prev  := slv_ip_str_curr;  slv_ip_str_curr := slv_ip_str; 
	eep_ip_str_prev  := eep_ip_str_curr;  eep_ip_str_curr := eep_ip_str; 


end if;
end process;




process (reset_i, clk_i)
begin
if reset_i = '1' then
	mac_addr_o			<= (others => '0');
	mac_from_eep_o		<= '0';
	mac_from_slv_o		<= '0';
	mac_from_usr_o		<= '0';
                        
	ip_addr_o			<= (others => '0');
	ip_from_eep_o		<= '0';
	ip_from_slv_o		<= '0';
	ip_from_usr_o		<= '0';

elsif rising_edge(clk_i) then

	mac_from_eep_o		<= mac_from_eep ;
	mac_from_slv_o		<= mac_from_slv ;
	mac_from_usr_o		<= mac_from_usr ;
	mac_addr_o			<= mac_addr		 ;
--	if ext_posfix_enable = '1' then mac_addr_o(7 downto 0) <= ext_postfix; end if;
                        
	ip_from_eep_o		<= ip_from_eep	 ;
	ip_from_slv_o		<= ip_from_slv	 ;
	ip_from_usr_o		<= ip_from_usr	 ;
	ip_addr_o			<= ip_addr		 ;
	if ext_postfix_enable = '1' then ip_addr_o(7 downto 0) <= ext_postfix; end if;
	--
end if;
end process;



eep_header						<= regs_eeprom_i(0);		
eep_mac_addr(47 downto 40) <= regs_eeprom_i(1);
eep_mac_addr(39 downto 32) <= regs_eeprom_i(2);
eep_mac_addr(31 downto 24) <= regs_eeprom_i(3);
eep_mac_addr(23 downto 16) <= regs_eeprom_i(4);
eep_mac_addr(15 downto  8) <= regs_eeprom_i(5);
eep_mac_addr( 7 downto  0) <= regs_eeprom_i(6);
eep_ip_addr (31 downto 24) <= regs_eeprom_i(7);
eep_ip_addr (23 downto 16) <= regs_eeprom_i(8);
eep_ip_addr (15 downto  8) <= regs_eeprom_i(9);
eep_ip_addr ( 7 downto  0) <= regs_eeprom_i(10);
eep_mac_str						<= regs_eeprom_i(11)(0);
eep_ip_str 						<= regs_eeprom_i(11)(1);
eep_checksum					<= regs_eeprom_i(12);


slv_header						<= regs_slave_i(0);	
slv_mac_addr(47 downto 40) <= regs_slave_i(1);
slv_mac_addr(39 downto 32) <= regs_slave_i(2);
slv_mac_addr(31 downto 24) <= regs_slave_i(3);
slv_mac_addr(23 downto 16) <= regs_slave_i(4);
slv_mac_addr(15 downto  8) <= regs_slave_i(5);
slv_mac_addr( 7 downto  0) <= regs_slave_i(6);
slv_ip_addr (31 downto 24) <= regs_slave_i(7);
slv_ip_addr (23 downto 16) <= regs_slave_i(8);
slv_ip_addr (15 downto  8) <= regs_slave_i(9);
slv_ip_addr ( 7 downto  0) <= regs_slave_i(10);
slv_mac_str						<= regs_slave_i(11)(0);
slv_ip_str 						<= regs_slave_i(11)(1);
slv_checksum					<= regs_slave_i(12);

end rtl;