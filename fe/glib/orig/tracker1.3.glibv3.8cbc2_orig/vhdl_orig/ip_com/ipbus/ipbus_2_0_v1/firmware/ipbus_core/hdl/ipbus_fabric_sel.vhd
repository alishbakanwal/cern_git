-- The ipbus bus fabric, address select logic, data multiplexers
--
-- This version selects the addressed slave depending on the state
-- of incoming control lines
--
-- Dave Newbold, February 2011

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.ipbus.ALL;
use work.ipbus_reg_types.all;

entity ipbus_fabric_sel is
  generic(
    NSLV: positive;
    STROBE_GAP: boolean := false;
    SEL_WIDTH: positive
   );
  port(
  	sel: in std_logic_vector(SEL_WIDTH - 1 downto 0);
    ipb_in: in ipb_wbus;
    ipb_out: out ipb_rbus;
    ipb_to_slaves: out ipb_wbus_array(NSLV - 1 downto 0);
    ipb_from_slaves: in ipb_rbus_array(NSLV - 1 downto 0)
   );

end ipbus_fabric_sel;

architecture rtl of ipbus_fabric_sel is

	signal sel_i: integer := 0;
	signal ored_ack, ored_err: std_logic_vector(NSLV downto 0);
	signal qstrobe: std_logic;

begin

	sel_i <= to_integer(unsigned(sel));

	ored_ack(NSLV) <= '0';
	ored_err(NSLV) <= '0';
	
	qstrobe <= ipb_in.ipb_strobe when STROBE_GAP = false else
	 ipb_in.ipb_strobe and not (ored_ack(0) or ored_err(0));

	busgen: for i in NSLV-1 downto 0 generate
	begin

		ipb_to_slaves(i).ipb_addr <= ipb_in.ipb_addr;
		ipb_to_slaves(i).ipb_wdata <= ipb_in.ipb_wdata;
		ipb_to_slaves(i).ipb_strobe <= qstrobe when sel_i = i else '0';
		ipb_to_slaves(i).ipb_write <= ipb_in.ipb_write;
		ored_ack(i) <= ored_ack(i+1) or ipb_from_slaves(i).ipb_ack;
		ored_err(i) <= ored_err(i+1) or ipb_from_slaves(i).ipb_err;		

	end generate;

  ipb_out.ipb_rdata <= ipb_from_slaves(sel_i).ipb_rdata;
  ipb_out.ipb_ack <= ored_ack(0);
  ipb_out.ipb_err <= ored_err(0);
  
end rtl;

