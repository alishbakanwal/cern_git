-- Interface to the input packet buffer
--
-- Dave Newbold, April 2011 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity transactor_rx is
  port(
    clk: in std_logic; 
    reset: in std_logic;
    pkt_ready: in std_logic;
    pkt_addr_rst: in std_logic;
    pkt_raddr: out std_logic_vector(9 downto 0);
    pkt_rdata: in std_logic_vector(31 downto 0);
    rx_ready: out std_logic;
    rx_next: in std_logic;
    start: out std_logic
 );
end transactor_rx;

architecture rtl of transactor_rx is
  
  signal ready_d, start_i, hdr, done: std_logic;
  signal addr, addr_end: unsigned(9 downto 0);
  
begin

  start_i <= pkt_ready and not ready_d;

  process(clk)
  begin
    if rising_edge(clk) then

      ready_d <= pkt_ready;
      hdr <= start_i;

      if reset = '1' then
        done <= '1';
      elsif hdr = '1' then
        done <= '0';        
      elsif addr = addr_end then
        done <= '1';
      end if;
      
    end if; 
  end process;
  
  process(clk)
  begin
    if falling_edge(clk) then

      if reset = '1' or (start_i = '1' and pkt_addr_rst = '1') then
        addr <= (others => '0');
      elsif hdr = '1' then
        addr <= unsigned(pkt_rdata(25 downto 16)) + 1;
        addr_end <= unsigned(pkt_rdata(9 downto 0)) + 1;
      elsif rx_next = '1' then
        addr <= addr + 1;
      end if;
      
    end if; 
  end process;

  pkt_raddr <= std_logic_vector(addr);
  rx_ready <= pkt_ready and not done;
--  rx_ready <= not done;
  start <= start_i;
  
end rtl;
