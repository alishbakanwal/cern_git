----------------------------------------------------------------------
----                                                              ----
---- GBT-FPGA SERDES Project                                      ----
----                                                              ----
---- This file is part of the GBT-FPGA Project                    ----
---- https://espace.cern.ch/GBT-Project/default.aspx              ----
---- https://svn.cern.ch/reps/gbt_fpga                            ----
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
--  ENTITY              :       Scrambler           
--  VENDOR SPECIFIC?    :       No
--  FPGA SPECIFIC?      :       No
--  CREATION DATE       :       06/10/2008
--  LAST UPDATE         :       02/11/2010  
--  AUTHORs             :       Steffen MUSCHTER (Stockholm University), Frederic MARIN (CPPM)
--  LANGAGE             :       VHDL'93
---------------------------------------------------------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity Scrambler is
  port(
    din          : in  std_logic_vector(21 downto 1);
    resetb       : in  std_logic;
    clk          : in  std_logic;
    resetpattern : in  std_logic_vector(21 downto 1);
    dout         : out std_logic_vector(21 downto 1)
    );
end Scrambler;

architecture a of Scrambler is

  signal FREG : std_logic_vector(20 downto 0);

begin

  dout <= FREG;

  process(clk)
    variable DREG   : std_logic_vector (21 downto 1);
    variable dout_s : std_logic_vector (21 downto 1);
  begin
    
    if RISING_EDGE(clk) then
      DREG := din;

      dout_s(1)  := DREG(1) xor FREG(0) xor FREG(2);
      dout_s(2)  := DREG(2) xor FREG(1) xor FREG(3);
      dout_s(3)  := DREG(3) xor FREG(2) xor FREG(4);
      dout_s(4)  := DREG(4) xor FREG(3) xor FREG(5);
      dout_s(5)  := DREG(5) xor FREG(4) xor FREG(6);
      dout_s(6)  := DREG(6) xor FREG(5) xor FREG(7);
      dout_s(7)  := DREG(7) xor FREG(6) xor FREG(8);
      dout_s(8)  := DREG(8) xor FREG(7) xor FREG(9);
      dout_s(9)  := DREG(9) xor FREG(8) xor FREG(10);
      dout_s(10) := DREG(10) xor FREG(9) xor FREG(11);
      dout_s(11) := DREG(11) xor FREG(10) xor FREG(12);
      dout_s(12) := DREG(12) xor FREG(11) xor FREG(13);
      dout_s(13) := DREG(13) xor FREG(12) xor FREG(14);
      dout_s(14) := DREG(14) xor FREG(13) xor FREG(15);
      dout_s(15) := DREG(15) xor FREG(14) xor FREG(16);
      dout_s(16) := DREG(16) xor FREG(15) xor FREG(17);
      dout_s(17) := DREG(17) xor FREG(16) xor FREG(18);
      dout_s(18) := DREG(18) xor FREG(17) xor FREG(19);
      dout_s(19) := DREG(19) xor FREG(18) xor FREG(20);
      dout_s(20) := DREG(20) xor FREG(19) xor DREG(1) xor FREG(0) xor FREG(2);
      dout_s(21) := DREG(21) xor FREG(20) xor DREG(2) xor FREG(1) xor FREG(3);

      if resetb = '1' then
        FREG <= dout_s;
      else
        FREG <= resetpattern;
      end if;
    end if;
  end process;
  
  
end a;
