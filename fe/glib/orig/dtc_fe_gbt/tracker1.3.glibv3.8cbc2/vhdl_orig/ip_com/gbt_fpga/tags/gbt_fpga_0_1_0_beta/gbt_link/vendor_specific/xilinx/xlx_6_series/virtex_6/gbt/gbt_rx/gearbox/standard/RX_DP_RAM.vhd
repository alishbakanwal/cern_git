library ieee;
use ieee.std_logic_1164.all;
library work;

entity rx_dp_ram is
	port
	(
		data		: in std_logic_vector (19 downto 0);
		rdaddress	: in std_logic_vector (2 downto 0);
		rdclock		: in std_logic ;
		wraddress	: in std_logic_vector (5 downto 0);
		wrclock		: in std_logic ;
		wren		: in std_logic  := '1';
		q			: out std_logic_vector (159 downto 0)
	);
end rx_dp_ram;


architecture wrap of rx_dp_ram is



component RXtDPRAM
	port (
	clka: in std_logic;
	wea: in std_logic_vector(0 downto 0);
	addra: in std_logic_vector(5 downto 0);
	dina: in std_logic_vector(19 downto 0);
	douta: out std_logic_vector(19 downto 0);
	clkb: in std_logic;
	web: in std_logic_vector(0 downto 0);
	addrb: in std_logic_vector(2 downto 0);
	dinb: in std_logic_vector(159 downto 0);
	doutb: out std_logic_vector(159 downto 0));
end component;

--COMPONENT RXeccDPRAM
--  PORT (
--    clka : IN STD_LOGIC;
--    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
--    addra : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
--    dina : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
--    clkb : IN STD_LOGIC;
--    addrb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
--    doutb : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
--    sbiterr : OUT STD_LOGIC;
--    dbiterr : OUT STD_LOGIC;
--    rdaddrecc : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
--  );
--END COMPONENT;

signal 	wren_based_on_wraddress: std_logic_vector(5 downto 0);

begin

rx : RXtDPRAM
		port map (
			clka => wrclock,
			wea(0) => wren,
			addra => wraddress,
			dina => data,
			douta => open,
			clkb => rdclock,
			web(0) => '0',
			addrb => rdaddress,
			dinb => (others => '0'),
			doutb => q
	);
	
--	wren_based_on_wraddress(0) <= '1' when wraddress(2 downto 0)="000" else '0';
--	wren_based_on_wraddress(1) <= '1' when wraddress(2 downto 0)="001" else '0';
--	wren_based_on_wraddress(2) <= '1' when wraddress(2 downto 0)="010" else '0';
--	wren_based_on_wraddress(3) <= '1' when wraddress(2 downto 0)="011" else '0';
--	wren_based_on_wraddress(4) <= '1' when wraddress(2 downto 0)="100" else '0';
--	wren_based_on_wraddress(5) <= '1' when wraddress(2 downto 0)="101" else '0';
--
--	rx_ram: for i in 0 to 5 generate
--	
--		
--		rx: RXeccDPRAM
--		PORT MAP 
--		(
--			 clka 				=> wrclock,
--			 wea(0)				=> wren_based_on_wraddress(i),
--			 addra 				=> wraddress(5 downto 3),
--			 dina 				=> data,
--			 clkb 				=> rdclock,
--			 addrb 				=> rdaddress,
--			 doutb 				=> q(20*(i+1)-1 downto 20*i),
--			 sbiterr 			=> open,
--			 dbiterr 			=> open,
--			 rdaddrecc 			=> open
--		);
--	end generate;





end wrap;
