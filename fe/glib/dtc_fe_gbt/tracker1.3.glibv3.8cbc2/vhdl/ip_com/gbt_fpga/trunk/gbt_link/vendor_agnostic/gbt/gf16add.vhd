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
--						gf16add						--
--													--
-- Manually translated from verilog					--
-- Adder using GF(2^4) arithmetic					--
-- for Reed Solomon codec for GBT					--
-- A. Marchioro	2006								--
--													--
-- Author: Frédéric Marin							--
-- Date: October 3rd, 2008							--
------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY gf16add IS
	PORT(
			input1 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			input2 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			output : OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END gf16add;


ARCHITECTURE a OF gf16add IS

	BEGIN
		
	output(0)	<= input1(0) XOR input2(0);
	output(1)	<= input1(1) XOR input2(1);
	output(2)	<= input1(2) XOR input2(2);
	output(3)	<= input1(3) XOR input2(3);
	
END a;
			