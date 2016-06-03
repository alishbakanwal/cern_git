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
--  ENTITY				: 	WORD_GENERATOR.VHD		
--  VERSION				:	0.2						
--  VENDOR SPECIFIC?	:	YES (ALTERA) - calls an Altera counter
--  FPGA SPECIFIC? 		:   NO
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE		:	10/05/2009
--  LAST UPDATE     	:   07/07/2009  
--  AUTHORs				:	Frederic MARIN (CPPM)
--  LANGAGE 			:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION			:	generation of 4 words of 21 bits using counters @ 40MHz
--					
--					
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--                      DATE            	VERSION           	AUTHOR		DESCRIPTION
--                      10/05/2009   		0.1                	MARIN   	first .BDF entity definition           
--						07/07/2009			0.2					BARON		vhdl entity
--						15/01/2010			0.3					BARON		use of agnostic counters
---------------------------------------------------------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ENTITY Word_Generator IS 
	PORT
	(
		Clock_40MHz :  IN  STD_LOGIC;
		Generated_Word :  OUT  STD_LOGIC_VECTOR(83 DOWNTO 0)
	);
END Word_Generator;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE rtl OF Word_Generator IS 

COMPONENT Agnostic_21bits_Counter
	PORT(clock : IN STD_LOGIC;
		 q : OUT STD_LOGIC_VECTOR(20 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	Temp_Generated_Word :  STD_LOGIC_VECTOR(83 DOWNTO 0);
---------------------------------------------------------------------------------------------------------------------------------

BEGIN 

Counter_20_0 : agnostic_21bits_counter --was counter_21bits
PORT MAP(clock => Clock_40MHz,
		 q => Temp_Generated_Word(20 DOWNTO 0));

Counter_41_21 : agnostic_21bits_counter --was counter_21bits
PORT MAP(clock => Clock_40MHz,
		 q => Temp_Generated_Word(41 DOWNTO 21));

Counter_62_42 : agnostic_21bits_counter --was counter_21bits
PORT MAP(clock => Clock_40MHz,
		 q => Temp_Generated_Word(62 DOWNTO 42));

Counter_83_63 : agnostic_21bits_counter --was counter_21bits
PORT MAP(clock => Clock_40MHz,
		 q => Temp_Generated_Word(83 DOWNTO 63));

Generated_Word <= Temp_Generated_Word;

END rtl;