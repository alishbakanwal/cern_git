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
------------------------------------------------------
--						adder60						--
--													--
-- Manually translated from verilog					--
-- 60 bit Adder using GF arithmetic					--
-- for Reed Solomon codec for GBT					--
-- A. Marchioro	2006								--
--													--
-- Author: Frédéric Marin							--
-- Date: October 3rd, 2008							--
------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY adder60 IS
	PORT(
			input1	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
			input2	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
			output	: OUT 	STD_LOGIC_VECTOR(59 DOWNTO 0)
		);
END adder60;


ARCHITECTURE a OF adder60 IS

COMPONENT gf16add
	PORT(
		input1 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		input2 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		output : OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);

END COMPONENT;

	BEGIN
	
	gf16add_gen:
	FOR i IN 0 TO 14 GENERATE
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> input1((4*i)+3 DOWNTO 4*i),
			input2	=> input2((4*i)+3 DOWNTO 4*i),
			output	=> output((4*i)+3 DOWNTO 4*i)
				);
	END GENERATE;
		
END a;