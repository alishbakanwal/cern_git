
-- MBM: (08/07/2013)
--      new module 

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity gbt_tx_scrambler_16bit is
  port(
    din          : in  std_logic_vector(16 downto 1);
    resetb       : in  std_logic;
    clk          : in  std_logic;
    resetpattern : in  std_logic_vector(16 downto 1);
    dout         : out std_logic_vector(16 downto 1)
    );
end gbt_tx_scrambler_16bit;

architecture a of gbt_tx_scrambler_16bit is

  signal FREG : std_logic_vector(15 downto 0);

begin

  dout <= FREG;

  process(clk)
    variable DREG   : std_logic_vector (16 downto 1);
    variable dout_s : std_logic_vector (16 downto 1);
  begin
    
    if RISING_EDGE(clk) then
      
      DREG := din;

      dout_s( 1) := DREG( 1) xor FREG( 0) xor FREG( 2) xor FREG( 3) xor FREG( 5);
      dout_s( 2) := DREG( 2) xor FREG( 1) xor FREG( 3) xor FREG( 4) xor FREG( 6);
      dout_s( 3) := DREG( 3) xor FREG( 2) xor FREG( 4) xor FREG( 5) xor FREG( 7);
      dout_s( 4) := DREG( 4) xor FREG( 3) xor FREG( 5) xor FREG( 6) xor FREG( 8);
      dout_s( 5) := DREG( 5) xor FREG( 4) xor FREG( 6) xor FREG( 7) xor FREG( 9);
      dout_s( 6) := DREG( 6) xor FREG( 5) xor FREG( 7) xor FREG( 8) xor FREG(10);
      dout_s( 7) := DREG( 7) xor FREG( 6) xor FREG( 8) xor FREG( 9) xor FREG(11);
      dout_s( 8) := DREG( 8) xor FREG( 7) xor FREG( 9) xor FREG(10) xor FREG(12);
      dout_s( 9) := DREG( 9) xor FREG( 8) xor FREG(10) xor FREG(11) xor FREG(13);
      dout_s(10) := DREG(10) xor FREG( 9) xor FREG(11) xor FREG(12) xor FREG(14);
      dout_s(11) := DREG(11) xor FREG(10) xor FREG(12) xor FREG(13) xor FREG(15);
      dout_s(12) := DREG(12) xor FREG(11) xor FREG(13) xor FREG(14) xor DREG( 1) xor FREG(0) xor FREG(2) xor FREG(3) xor FREG(5);
      dout_s(13) := DREG(13) xor FREG(12) xor FREG(14) xor FREG(15) xor DREG( 2) xor FREG(1) xor FREG(3) xor FREG(4) xor FREG(6);
      dout_s(14) := DREG(14) xor FREG(13) xor FREG(15) xor DREG( 1) xor FREG( 0) xor FREG(2) xor FREG(3) xor FREG(5) xor DREG(3) xor FREG(2) xor FREG(4) xor FREG(5) xor FREG(7);
      dout_s(15) := DREG(15) xor FREG(14) xor DREG( 1) xor FREG( 0) xor FREG( 2) xor FREG(3) xor FREG(5) xor DREG(2) xor FREG(1) xor FREG(3) xor FREG(4) xor FREG(6) xor DREG(4) xor FREG(3) xor FREG(5) xor FREG(6) xor FREG(8);
      dout_s(16) := DREG(16) xor FREG(15) xor DREG( 2) xor FREG( 1) xor FREG( 3) xor FREG(4) xor FREG(6) xor DREG(3) xor FREG(2) xor FREG(4) xor FREG(5) xor FREG(7) xor DREG(5) xor FREG(4) xor FREG(6) xor FREG(7) xor FREG(9);      
                                                                                                                                          
      if resetb = '1' then                                                                                                                
        FREG <= dout_s;
      else
        FREG <= resetpattern;
      end if;
    end if;
  end process;
  
  
end a;
