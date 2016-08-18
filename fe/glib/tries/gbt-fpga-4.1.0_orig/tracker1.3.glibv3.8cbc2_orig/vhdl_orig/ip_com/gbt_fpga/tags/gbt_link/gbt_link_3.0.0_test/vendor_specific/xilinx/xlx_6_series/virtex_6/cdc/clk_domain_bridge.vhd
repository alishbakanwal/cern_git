library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--! specific packages
library unisim;
use unisim.vcomponents.all;


entity clk_domain_bridge is
generic (n : integer range 0 to 128:=128);
port
(
	wrclk_i							: in		std_logic;
	rdclk_i							: in		std_logic;
	wdata_i							: in		std_logic_vector(n-1 downto 0);
	rdata_o							: out		std_logic_vector(n-1 downto 0)
);                    	
end clk_domain_bridge;

                    	
architecture clk_domain_bridge_arch of clk_domain_bridge is                    	


begin

	--================================--
	dpram: entity work.dist_mem_gen_v5_1
	--================================--
	port map
	(
		clk						=> wrclk_i,
		a						=> "0000",
		d(n-1 downto 0)	=> wdata_i,
		d(127 downto n)	=> (others=>'0'),
		we						=> '1',
		---------------------
		dpra					=> "0000",
		qdpo_clk				=> rdclk_i,
		qdpo(n-1 downto 0)=> rdata_o,
		qdpo(127 downto n)=> open
	);
   
end clk_domain_bridge_arch;