----------------------------------------------------------------------
----                                                              ----
---- GBT-FPGA SERDES Project                               	  ----
----                                                              ----
---- This file is part of the GBT-FPGA Project              	  ----
---- https://espace.cern.ch/GBT-Project/default.aspx              ----
---- https://svn.cern.ch/reps/gbt_fpga 				  ----
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
--  ENTITY		: 	SCRAMBLING.VHD
--  VERSION		:	0.4
--  VENDOR SPECIFIC?	:       NO
--  FPGA SPECIFIC? 	:       NO
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE	:	10/05/2009
--  LAST UPDATE     	:       02/10/2010
--  AUTHORs		:	Steffen MUSCHTER (Stockholm University), (Frederic MARIN (CPPM)
--  LANGAGE 		:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION		:	gather the 4 21bits-scramblers and latches the output
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--      DATE            	VERSION           	AUTHOR		DESCRIPTION
--      10/05/2009   		0.1                	MARIN   	first .BDF entity definition           
--	07/07/2009		0.2			BARON		vhdl entity
--	30/07/2009		0.3			BARON		add a generic parameter to allow having different initialisation
--									constants in case of multiple instanciations of 'scrambling'.
--									This modification is back-compatible with the previous scrambling entity.
--      02/10/2010              0.4                     MUSCHTER        Remove the event statement to save latency and logic
---------------------------------------------------------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  --to allow conversion of the integer into std_logic_vector

library work;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

entity Scrambling is
  generic (N : integer := 0);  --when the scrambling entity is instanciated several times, N is incremented to avoid having the same initialisation
  port
    (
      Reset  : in  std_logic;
      Clock  : in  std_logic;
      Input  : in  std_logic_vector(83 downto 0);
      Header : out std_logic_vector(3 downto 0);
      Output : out std_logic_vector(83 downto 0)
      );
end Scrambling;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

architecture rtl of Scrambling is

  component scrambling_constants
    port(Header                         : out std_logic_vector(3 downto 0);
                         Reset_Pattern1 : out std_logic_vector(20 downto 0);
                         Reset_Pattern2 : out std_logic_vector(20 downto 0);
                         Reset_Pattern3 : out std_logic_vector(20 downto 0);
                         Reset_Pattern4 : out std_logic_vector(20 downto 0)
                         );
  end component;

  component scrambler
    port(resetb       : in  std_logic;
         clk          : in  std_logic;
         din          : in  std_logic_vector(21 downto 1);
         resetpattern : in  std_logic_vector(21 downto 1);
         dout         : out std_logic_vector(21 downto 1)
         );
  end component;

  signal First_Reset_Pattern, Temp_First_Reset_Pattern   : std_logic_vector(20 downto 0);
  signal Second_Reset_Pattern, Temp_Second_Reset_Pattern : std_logic_vector(20 downto 0);
  signal Third_Reset_Pattern, Temp_Third_Reset_Pattern   : std_logic_vector(20 downto 0);
  signal Fourth_Reset_Pattern, Temp_Fourth_Reset_Pattern : std_logic_vector(20 downto 0);
  signal Reset_N                                         : std_logic;
  signal Scrambled_Word, Temp_Output                     : std_logic_vector(83 downto 0);

---------------------------------------------------------------------------------------------------------------------------------

begin

  Reset_N <= not(Reset);
  Output  <= Temp_Output;

  Scrambler_init : scrambling_constants
    port map(Header                    => Header,
                        Reset_Pattern1 => Temp_First_Reset_Pattern,
                        Reset_Pattern2 => Temp_Second_Reset_Pattern,
                        Reset_Pattern3 => Temp_Third_Reset_Pattern,
                        Reset_Pattern4 => Temp_Fourth_Reset_Pattern);

  First_Reset_Pattern  <= Temp_First_Reset_Pattern or std_logic_vector(To_unsigned(N, 21));
  Second_Reset_Pattern <= Temp_Second_Reset_Pattern or std_logic_vector(To_unsigned(N, 21));
  Third_Reset_Pattern  <= Temp_Third_Reset_Pattern or std_logic_vector(To_unsigned(N, 21));
  Fourth_Reset_Pattern <= Temp_Fourth_Reset_Pattern or std_logic_vector(To_unsigned(N, 21));

  Scrambler_20_0 : scrambler
    port map(resetb       => Reset_N,
             clk          => Clock,
             din          => Input(20 downto 0),
             resetpattern => Fourth_Reset_Pattern,
             dout         => Scrambled_Word(20 downto 0));


  Scrambler_41_21 : scrambler
    port map(resetb       => Reset_N,
             clk          => Clock,
             din          => Input(41 downto 21),
             resetpattern => Third_Reset_Pattern,
             dout         => Scrambled_Word(41 downto 21));


  Scrambler_62_42 : scrambler
    port map(resetb       => Reset_N,
             clk          => Clock,
             din          => Input(62 downto 42),
             resetpattern => Second_Reset_Pattern,
             dout         => Scrambled_Word(62 downto 42));


  Scrambler_83_63 : scrambler
    port map(resetb       => Reset_N,
             clk          => Clock,
             din          => Input(83 downto 63),
             resetpattern => First_Reset_Pattern,
             dout         => Scrambled_Word(83 downto 63));

  Temp_Output <= Scrambled_Word;
  
  
end rtl;

