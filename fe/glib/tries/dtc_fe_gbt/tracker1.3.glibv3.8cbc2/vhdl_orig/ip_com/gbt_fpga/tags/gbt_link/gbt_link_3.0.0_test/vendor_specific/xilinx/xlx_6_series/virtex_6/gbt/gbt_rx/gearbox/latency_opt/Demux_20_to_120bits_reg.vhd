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
--  ENTITY              :       DEMUX_40_TO_120BITS         
--  VERSION             :       0.3                                             
--  VENDOR SPECIFIC?    :       N0
--  FPGA SPECIFIC?      :       NO
--  CREATION DATE       :       10/05/2009
--  LAST UPDATE         :       02/11/2009  
--  AUTHORs             :       Steffen MUSCHTER (Stockholm University), Frederic MARIN (CPPM), Sophie BARON (CERN)
--  LANGAGE             :       VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--      DESCRIPTION     :       converts input: 3 successive words of 40bits@120MHz
--                              into output: 120bits@40MHz. Inverts the bits order to match the encoder.
--                                      
---------------------------------------------------------------------------------------------------------------------------------
--      VERSIONS HISTORY        :
--      DATE                    VERSION                 AUTHOR          DESCRIPTION
--      10/05/2009              0.1                     MARIN           first .BDF entity definition           
--      08/07/2009              0.2                     BARON           conversion to vhdl
--      02/11/2010              0.3                     MUSCHTER        optimization for low latency
---------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;

entity Demux_20_to_120bits_reg is
  port
    (
      Reset         : in  std_logic;
      Rx_word_clk   : in  std_logic;
      Rx_frame_clk  : in  std_logic;
      Locked        : in  std_logic;
      Input         : in  std_logic_vector(19 downto 0);
      Write_Address : in  std_logic_vector(5 downto 0);
      DV            : out std_logic;
      Output        : out std_logic_vector(119 downto 0)
      );
end Demux_20_to_120bits_reg;

architecture rtl of Demux_20_to_120bits_reg is

  signal reg1 : std_logic_vector (99 downto 0)  := (others => '0');
  signal reg2 : std_logic_vector (119 downto 0) := (others => '0');

begin

  write_data : process (Reset, Rx_word_clk)
  begin
    if (Reset = '1') then
      reg1 <= (others => '0');
      reg2 <= (others => '0');
    elsif (rising_edge(Rx_word_clk)) then
      case Write_Address (2 downto 0) is
        when "000"   => reg1 (19 downto 0)  <= Input;
        when "001"   => reg1 (39 downto 20) <= Input;
        when "010"   => reg1 (59 downto 40) <= Input;
        when "011"   => reg1 (79 downto 60) <= Input;
        when "100"   => reg1 (99 downto 80) <= Input;
        when "101"   => reg2                <= Input & reg1;
        
        when others => null;
      end case;
    end if;
  end process write_data;

  DV_intern: process (Rx_frame_clk)
  begin
    if (rising_edge(Rx_frame_clk)) then
      DV <= Locked;
    end if;
  end process DV_intern;

  invert_signal : for i in 119 downto 0 generate
    Output(i) <= reg2(119-i);
  end generate invert_signal;
  
end rtl;
