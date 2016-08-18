-- mac_arbiter_decl
--
-- Defines the array types for the ports of the mac_arbiter entity
--
-- Dave Newbold, March 2011
--
-- $Id: mac_arbiter_decl.vhd 326 2011-04-25 20:00:14Z phdmn $

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package bus_arb_decl is
  
  -- The signals going from memory to transactor
    type trans_moti is
      record
        ready: std_logic;
        addr_rst: std_logic;
        rdata : std_logic_vector(31 downto 0);
      end record;
  
    type trans_moti_array is array(natural range <>) of trans_moti;
     
  -- The signals going from transactor to memory	 
     type trans_tomi is
      record
        done: std_logic;
        wdata: std_logic_vector(31 downto 0);
        raddr: std_logic_vector(9 downto 0);
        waddr: std_logic_vector(9 downto 0);
        we: std_logic;
      end record;
  
    type trans_tomi_array is array(natural range <>) of trans_tomi;

end bus_arb_decl;
