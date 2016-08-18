
-- MBM from lat opt to std (we only use this one) 09/07/2013
--      new name

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;



entity gbt_rx_descrambler_16bit is
  port(
    din    : in  std_logic_vector(16 downto 1);
    resetb : in  std_logic;
    clk    : in  std_logic;
    dout   : out std_logic_vector(16 downto 1)
    );
end gbt_rx_descrambler_16bit;

architecture a of gbt_rx_descrambler_16bit is

  signal FREG : std_logic_vector(15 downto 0);

begin
  
  process(clk)
    variable DREG : std_logic_vector(16 downto 1);
  begin
    
    if RISING_EDGE(clk) then
      DREG := din;     

      dout( 1) <= DREG( 1)  xor FREG( 0) xor FREG( 2) xor FREG( 3) xor FREG( 5);
      dout( 2) <= DREG( 2)  xor FREG( 1) xor FREG( 3) xor FREG( 4) xor FREG( 6);
      dout( 3) <= DREG( 3)  xor FREG( 2) xor FREG( 4) xor FREG( 5) xor FREG( 7);
      dout( 4) <= DREG( 4)  xor FREG( 3) xor FREG( 5) xor FREG( 6) xor FREG( 8);
      dout( 5) <= DREG( 5)  xor FREG( 4) xor FREG( 6) xor FREG( 7) xor FREG( 9);
      dout( 6) <= DREG( 6)  xor FREG( 5) xor FREG( 7) xor FREG( 8) xor FREG(10);
      dout( 7) <= DREG( 7)  xor FREG( 6) xor FREG( 8) xor FREG( 9) xor FREG(11);
      dout( 8) <= DREG( 8)  xor FREG( 7) xor FREG( 9) xor FREG(10) xor FREG(12);
      dout( 9) <= DREG( 9)  xor FREG( 8) xor FREG(10) xor FREG(11) xor FREG(13);
      dout(10) <= DREG(10)  xor FREG( 9) xor FREG(11) xor FREG(12) xor FREG(14);
      dout(11) <= DREG(11)  xor FREG(10) xor FREG(12) xor FREG(13) xor FREG(15);
      dout(12) <= DREG(12)  xor FREG(11) xor FREG(13) xor FREG(14) xor DREG( 1);
      dout(13) <= DREG(13)  xor FREG(12) xor FREG(14) xor FREG(15) xor DREG( 2);
      dout(14) <= DREG(14)  xor FREG(13) xor FREG(15) xor DREG( 1) xor DREG( 3);
      dout(15) <= DREG(15)  xor FREG(14) xor DREG( 1) xor DREG( 2) xor DREG( 4);
      dout(16) <= DREG(16)  xor FREG(15) xor DREG( 2) xor DREG( 3) xor DREG( 5);

      if resetb = '1' then
        FREG <= DREG;
      else
        FREG <= (others => '0');
      end if;
    end if;
  end process;  


end a;
