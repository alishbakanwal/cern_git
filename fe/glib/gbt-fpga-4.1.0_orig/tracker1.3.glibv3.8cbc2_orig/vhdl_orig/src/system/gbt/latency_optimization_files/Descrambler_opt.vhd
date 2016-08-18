----------------------------------------------------------------------
----                                                              ----
---- GBT-FPGA SERDES Project                                              ----
----                                                              ----
---- This file is part of the GBT-FPGA Project                    ----
---- https://espace.cern.ch/GBT-Project/default.aspx              ----
---- https://svn.cern.ch/reps/gbt_fpga                                                    ----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
----                                                              ----
---- This source file may be used and distributed without         ----
---- restriction provided that this copyright statement is not    ----
---- removed from the file and that any derivative work contains  ----
---- the original copyright notice and the associated disclaimer. ----
----                                                              ----
---- This source file is free software; you can redistribute it   ----
---- and/or modify it under the terms of the GNU General          ----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.0 of the License, or (at your option) any   ----
---- later version.                                               ----
----                                                              ----
---- This source is distributed in the hope that it will be       ----
---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
---- PURPOSE. See the GNU General Public License for more details.----
----                                                              ----
---- You should have received a copy of the GNU General           ----
---- Public License along with this source; if not, download it   ----
---- from http://www.gnu.org/licenses/gpl.txt                     ----
----                                                              ----
---------------------------------------------------------------------- 
---------------------------------------------------------------------------------------------------------------------------------
--  ENTITY              :       DESCRAMBLER         
--  VENDOR SPECIFIC?    :       N0
--  FPGA SPECIFIC?      :       NO
--  CREATION DATE       :       06/10/2008
--  LAST UPDATE         :       02/11/2009  
--  AUTHORs             :       Steffen MUSCHTER (Stockholm University), Frederic MARIN (CPPM)
--  LANGAGE             :       VHDL'93
---------------------------------------------------------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;



entity Descrambler is
  port(
    din    : in  std_logic_vector(21 downto 1);
    resetb : in  std_logic;
    clk    : in  std_logic;
    dout   : out std_logic_vector(21 downto 1)
    );
end Descrambler;

architecture a of Descrambler is

  signal FREG : std_logic_vector(20 downto 0);

begin
  
  process(clk)
    variable DREG : std_logic_vector(21 downto 1);
  begin
    
    if RISING_EDGE(clk) then
      DREG := din;

      dout(1)  <= DREG(1) xor FREG(0) xor FREG(2);
      dout(2)  <= DREG(2) xor FREG(1) xor FREG(3);
      dout(3)  <= DREG(3) xor FREG(2) xor FREG(4);
      dout(4)  <= DREG(4) xor FREG(3) xor FREG(5);
      dout(5)  <= DREG(5) xor FREG(4) xor FREG(6);
      dout(6)  <= DREG(6) xor FREG(5) xor FREG(7);
      dout(7)  <= DREG(7) xor FREG(6) xor FREG(8);
      dout(8)  <= DREG(8) xor FREG(7) xor FREG(9);
      dout(9)  <= DREG(9) xor FREG(8) xor FREG(10);
      dout(10) <= DREG(10) xor FREG(9) xor FREG(11);
      dout(11) <= DREG(11) xor FREG(10) xor FREG(12);
      dout(12) <= DREG(12) xor FREG(11) xor FREG(13);
      dout(13) <= DREG(13) xor FREG(12) xor FREG(14);
      dout(14) <= DREG(14) xor FREG(13) xor FREG(15);
      dout(15) <= DREG(15) xor FREG(14) xor FREG(16);
      dout(16) <= DREG(16) xor FREG(15) xor FREG(17);
      dout(17) <= DREG(17) xor FREG(16) xor FREG(18);
      dout(18) <= DREG(18) xor FREG(17) xor FREG(19);
      dout(19) <= DREG(19) xor FREG(18) xor FREG(20);
      dout(20) <= DREG(20) xor FREG(19) xor DREG(1);
      dout(21) <= DREG(21) xor FREG(20) xor DREG(2);

      if resetb = '1' then
        FREG <= DREG;
      else
        FREG <= (others => '0');
      end if;
    end if;
  end process;
  


end a;
