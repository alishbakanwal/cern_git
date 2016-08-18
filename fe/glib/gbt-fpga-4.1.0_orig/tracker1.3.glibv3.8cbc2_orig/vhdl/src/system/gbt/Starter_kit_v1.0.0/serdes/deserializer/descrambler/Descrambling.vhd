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
--  ENTITY				: 	DESCRAMBLING.VHD		
--  VERSION				:	0.2						
--  VENDOR SPECIFIC?	:	NO
--  FPGA SPECIFIC? 		:   NO
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE		:	10/05/2009
--  LAST UPDATE     	:   08/07/2009  
--  AUTHORs				:	Frederic MARIN (CPPM), Sophie BARON (CERN)
--  LANGAGE 			:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION			:	last step of the decoding process: 84 bits input -> 84 descrambled bits output
--						the descrambler is made of 4 blocks of 21-bits descrambler blocks
--					
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--                      DATE            	VERSION           	AUTHOR		DESCRIPTION
--                      10/05/2009   		0.1                	MARIN   	first .BDF entity definition           
--						08/07/2009			0.2					BARON		conversion to vhdl file
---------------------------------------------------------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ENTITY Descrambling IS 
	PORT
	(
		Reset 		:  IN  STD_LOGIC;
		frame_clk_i :  IN  STD_LOGIC;
		DV_In 		:  IN  STD_LOGIC;
		Input 		:  IN  STD_LOGIC_VECTOR(83 DOWNTO 0);
		DV_Out 		:  OUT  STD_LOGIC;
		Output 		:  OUT  STD_LOGIC_VECTOR(83 DOWNTO 0)
	);
END Descrambling;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE rtl OF Descrambling IS 

COMPONENT descrambler
	PORT(resetb : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 din : IN STD_LOGIC_VECTOR(21 DOWNTO 1);
		 dout : OUT STD_LOGIC_VECTOR(21 DOWNTO 1)
	);
END COMPONENT;

SIGNAL	Temp_Output :  STD_LOGIC_VECTOR(83 DOWNTO 0);
SIGNAL	Reset_N :  STD_LOGIC;
SIGNAL	Temp_DV_out :  STD_LOGIC;
---------------------------------------------------------------------------------------------------------------------------------

BEGIN 

Descrambler_20_0 : descrambler
PORT MAP(resetb => Reset_N,
		 clk => frame_clk_i,
		 din => Input(20 DOWNTO 0),
		 dout => Temp_Output(20 DOWNTO 0));


Descrambler_41_21 : descrambler
PORT MAP(resetb => Reset_N,
		 clk => frame_clk_i,
		 din => Input(41 DOWNTO 21),
		 dout => Temp_Output(41 DOWNTO 21));


Descrambler_62_42 : descrambler
PORT MAP(resetb => Reset_N,
		 clk => frame_clk_i,
		 din => Input(62 DOWNTO 42),
		 dout => Temp_Output(62 DOWNTO 42));


Descrambler_83_63 : descrambler
PORT MAP(resetb => Reset_N,
		 clk => frame_clk_i,
		 din => Input(83 DOWNTO 63),
		 dout => Temp_Output(83 DOWNTO 63));


process (frame_clk_i, Reset_N)
begin
	if (Reset_N = '0') then
			Temp_DV_Out <= '0';
	elsif (rising_edge(frame_clk_i)) then
			Temp_DV_Out <= DV_In;
	end if;
end process;


Reset_N <= NOT(Reset);

DV_Out <= Temp_DV_Out;
Output <= Temp_Output;

END rtl;