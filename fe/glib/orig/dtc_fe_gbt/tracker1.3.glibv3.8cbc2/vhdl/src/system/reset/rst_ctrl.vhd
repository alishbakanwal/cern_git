-- clocks_v6_serdes
--
-- Generates a ~32MHz ipbus clock from 125MHz reference
-- Includes reset logic for ipbus
--
-- Dave Newbold, April 2011
--
-- $Id$

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.VComponents.all;

entity rst_ctrl is 
generic (nb_eth_blocks: positive:= 2);
port(
	clk125_fr_i		: in std_logic;
	clk_ipb_i		: in std_logic;
	pll_locked_i	: in std_logic;	
	clk125_eth_i	: in std_logic_vector(0 to nb_eth_blocks-1);
	eth_locked_i	: in std_logic_vector(0 to nb_eth_blocks-1);

	nuke				: in std_logic;

	rst_125_o		: out std_logic_vector(0 to nb_eth_blocks-1);
	rst_eth_o		: out std_logic;
	rst_ipb_o		: out std_logic;
	rst_fabric_o	: out std_logic;
	onehz				: out std_logic
);

end rst_ctrl;

architecture rtl of rst_ctrl is
	
	signal d25, d25_d: std_logic;
	signal nuke_i, nuke_d, nuke_d2: std_logic := '0';
	signal rst, rst_ipb, rst_eth: std_logic := '1';
	signal rst_125 :  std_logic_vector(0 to nb_eth_blocks-1):=(others=>'1');

--== keep attributes ====--
attribute keep					: boolean;

attribute keep of rst			      	: signal is true;
attribute keep of nuke_i		      	: signal is true;
attribute keep of rst_ipb_o	      	: signal is true;
attribute keep of rst_fabric_o			: signal is true; 





begin

--=================--
clkdiv: entity work.clock_div 
--=================--
port map
(
	clk => clk125_fr_i,
	d25 => d25,
	d28 => onehz
);
--=================--

	
--=================--
rst_proc: process(clk125_fr_i)
--=================--
begin
	if rising_edge(clk125_fr_i) then
		d25_d <= d25;
		if d25='1' and d25_d='0' then
			rst <= nuke_d2 or not pll_locked_i;
			nuke_d <= nuke_i; -- Time bomb (allows return packet to be sent)
			nuke_d2 <= nuke_d;
		end if;
	end if;
end process;
--rst_fabric_o <= rst;
--=================--


--=================--
rst_fabric: process(rst,clk125_fr_i)
--=================--
	variable timer: integer;
begin
	if rst='1' then
		timer := 16000000; -- 16M x 8ns = 128ms
		rst_fabric_o <= '1';
	elsif rising_edge(clk125_fr_i) then
		if timer=0 then
			rst_fabric_o <= '0';
		else
			timer:=timer-1;
		end if;

	end if;
end process;
--=================--




	

--=================--
rst_ipb_proc: process(clk_ipb_i)
--=================--
begin
	if rising_edge(clk_ipb_i) then
		rst_ipb 	<= rst;
		nuke_i 	<= nuke;
	end if;
end process;
rst_ipb_o 	<= rst_ipb;
--=================--



--=================--
rst_125_proc: for i in 0 to (nb_eth_blocks-1) generate 	
--=================--
	process(clk125_eth_i(i))
	begin
		if rising_edge(clk125_eth_i(i)) then
			rst_125(i) <= rst or not eth_locked_i(i);
		end if;
	end process;
	rst_125_o(i) <= rst_125(i);
end generate;
--=================--



--=================--
rst_eth_proc:process(clk125_fr_i)
--=================--
begin
	if rising_edge(clk125_fr_i) then
		rst_eth <= rst;
	end if;
end process;
rst_eth_o <= rst_eth;
--=================--
		

end rtl;