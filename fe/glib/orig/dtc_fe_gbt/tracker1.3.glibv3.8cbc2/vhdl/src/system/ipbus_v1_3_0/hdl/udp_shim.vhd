-- Shim between old-style UDP packet buffer and new transactor
--
-- Dave Newbold, July 2011
--
-- $Id$

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bus_arb_decl.all;

entity udp_shim is
  port(
    clk: in std_logic; 
    reset: in std_logic;
    moti: out trans_moti;
    tomi: in trans_tomi;
    packet_data_i: in std_logic_vector(31 downto 0);
    packet_len_i: in std_logic_vector(8 downto 0);
    packet_addr_i: out std_logic_vector(8 downto 0);
    packet_data_o: out std_logic_vector(31 downto 0);
    packet_addr_o: out std_logic_vector(8 downto 0);
    packet_len_o: out std_logic_vector(8 downto 0);
    packet_we_o: out std_logic;
    new_packet: in std_logic;
    done: out std_logic
  );

end udp_shim;

architecture rtl of udp_shim is
  
  signal loc0: std_logic_vector(31 downto 0);
  signal lenw, new_d, ready, tdone_d, done_i: std_logic;

begin

  moti.addr_rst <= '1';
  loc0 <= X"00000" & "000" & packet_len_i;
  moti.rdata <= packet_data_i when tomi.raddr /= (9 downto 0 => '0') else loc0;
  packet_addr_i <= std_logic_vector(unsigned(tomi.raddr(8 downto 0)) - 1);
  
  packet_addr_o <= std_logic_vector(unsigned(tomi.waddr(8 downto 0)) - 1);
  packet_data_o <= tomi.wdata;
  lenw <= '1' when tomi.waddr = (9 downto 0 => '0') else '0';
  packet_we_o <= tomi.we and not lenw;
  
  process(clk)
  begin
    if rising_edge(clk) then
      if lenw = '1' then
        packet_len_o <= tomi.wdata(8 downto 0);
      end if;
      new_d <= new_packet;
      ready <= ((ready and not done_i) or (new_packet and not new_d)) and not reset;
      tdone_d <= tomi.done;
    end if;
  end process;
        
  done_i <= tomi.done and not tdone_d;
  done <= done_i;
  moti.ready <= ready;
  
end rtl;
