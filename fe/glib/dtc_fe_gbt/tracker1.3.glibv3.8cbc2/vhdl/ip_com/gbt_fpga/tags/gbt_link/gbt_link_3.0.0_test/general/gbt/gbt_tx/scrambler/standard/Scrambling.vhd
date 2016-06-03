----------------------------------------------------------------------
----                                                              ----
---- GBT-FPGA SERDES Project                               		  ----
----                                                              ----
---- This file is part of the GBT-FPGA Project              	  ----
---- https://espace.cern.ch/GBT-Project/default.aspx              ----
---- https://svn.cern.ch/reps/gbt_fpga 							  ----
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
--  ENTITY				: 	SCRAMBLING.VHD		
--  VERSION				:	0.2						
--  VENDOR SPECIFIC?	:	NO
--  FPGA SPECIFIC? 		:   NO
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE		:	10/05/2009
--  LAST UPDATE     	:   07/07/2009  
--  AUTHORs				:	Frederic MARIN (CPPM)
--  LANGAGE 			:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION			:	gather the 4 21bits-scramblers and latches the output
--					
--					
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--                      DATE            	VERSION           	AUTHOR		DESCRIPTION
--                      10/05/2009   		0.1                	MARIN   	first .BDF entity definition           
--						07/07/2009			0.2					BARON		vhdl entity
--						30/07/2009			0.3					BARON		add a generic parameter to allow having different initialisation 
--																			constants in case of multiple instanciations of 'scrambling'. 
--																			This modification is back-compatible with the previous scrambling entity.
---------------------------------------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all; 
USE ieee.numeric_std.all;--to allow conversion of the integer into std_logic_vector

LIBRARY work;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ENTITY Scrambling IS 
	GENERIC (N: integer :=0); --when the scrambling entity is instanciated several times, N is incremented to avoid having the same initialisation
	PORT
	(
		Reset :  IN  STD_LOGIC;
		Clock :  IN  STD_LOGIC;
		Input :  IN  STD_LOGIC_VECTOR(83 DOWNTO 0);
		Header :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
		Output :  OUT  STD_LOGIC_VECTOR(83 DOWNTO 0)
	);
END Scrambling;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE rtl OF Scrambling IS 

COMPONENT scrambling_constants
	PORT(		 Header : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 Reset_Pattern1 : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
		 Reset_Pattern2 : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
		 Reset_Pattern3 : OUT STD_LOGIC_VECTOR(20 DOWNTO 0);
		 Reset_Pattern4 : OUT STD_LOGIC_VECTOR(20 DOWNTO 0)
	);
END COMPONENT;

COMPONENT scrambler
	PORT(resetb : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 din : IN STD_LOGIC_VECTOR(21 DOWNTO 1);
		 resetpattern : IN STD_LOGIC_VECTOR(21 DOWNTO 1);
		 dout : OUT STD_LOGIC_VECTOR(21 DOWNTO 1)
	);
END COMPONENT;

SIGNAL	First_Reset_Pattern, Temp_First_Reset_Pattern :  STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL	Second_Reset_Pattern, Temp_Second_Reset_Pattern:  STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL	Third_Reset_Pattern, Temp_Third_Reset_Pattern:  STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL	Fourth_Reset_Pattern, Temp_Fourth_Reset_Pattern:  STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL	Reset_N :  STD_LOGIC;
SIGNAL	Scrambled_Word, Temp_Output :  STD_LOGIC_VECTOR(83 DOWNTO 0);

---------------------------------------------------------------------------------------------------------------------------------

BEGIN 

Reset_N <= NOT(Reset);
Output <= Temp_Output;

Scrambler_init : scrambling_constants
PORT MAP(		Header => Header,
				Reset_Pattern1 => Temp_First_Reset_Pattern,
				Reset_Pattern2 => Temp_Second_Reset_Pattern,
				Reset_Pattern3 => Temp_Third_Reset_Pattern,
				Reset_Pattern4 => Temp_Fourth_Reset_Pattern);

First_Reset_Pattern <= Temp_First_Reset_Pattern or std_logic_vector(To_unsigned(N,21));
Second_Reset_Pattern <= Temp_Second_Reset_Pattern or std_logic_vector(To_unsigned(N,21));
Third_Reset_Pattern <= Temp_Third_Reset_Pattern or std_logic_vector(To_unsigned(N,21));
Fourth_Reset_Pattern <= Temp_Fourth_Reset_Pattern or std_logic_vector(To_unsigned(N,21));

Scrambler_20_0 : scrambler
PORT MAP(resetb => Reset_N,
		 clk => Clock,
		 din => Input(20 DOWNTO 0),
		 resetpattern => Fourth_Reset_Pattern,
		 dout => Scrambled_Word(20 DOWNTO 0));


Scrambler_41_21 : scrambler
PORT MAP(resetb => Reset_N,
		 clk => Clock,
		 din => Input(41 DOWNTO 21),
		 resetpattern => Third_Reset_Pattern,
		 dout => Scrambled_Word(41 DOWNTO 21));


Scrambler_62_42 : scrambler
PORT MAP(resetb => Reset_N,
		 clk => Clock,
		 din => Input(62 DOWNTO 42),
		 resetpattern => Second_Reset_Pattern,
		 dout => Scrambled_Word(62 DOWNTO 42));


Scrambler_83_63 : scrambler
PORT MAP(resetb => Reset_N,
		 clk => Clock,
		 din => Input(83 DOWNTO 63),
		 resetpattern => First_Reset_Pattern,
		 dout => Scrambled_Word(83 DOWNTO 63));

process (Clock, Reset_N)
begin
	if (Reset_N = '0') then
		Temp_Output <= (others => '0');
	elsif (rising_edge(Clock)) then
			Temp_Output <= Scrambled_Word;
	end if;
end process;

END rtl;