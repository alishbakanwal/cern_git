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
--						gf16shifter					--
--													--
-- Manually translated from verilog					--
-- Shifter using GF(2^4) arithmetic					--
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


ENTITY gf16shifter IS
	PORT(
			input	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
			Shift	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			output	: OUT 	STD_LOGIC_VECTOR(59 DOWNTO 0)
		);
END gf16shifter;


ARCHITECTURE a OF gf16shifter IS

TYPE ARRAY_4_15 IS ARRAY(0 TO 3) OF BIT_VECTOR(14 DOWNTO 0);
SIGNAL ing	: ARRAY_4_15;
SIGNAL outg	: ARRAY_4_15;
SIGNAL input_s : BIT_VECTOR(59 DOWNTO 0);
SIGNAL output_s: BIT_VECTOR(59 DOWNTO 0);


	BEGIN
		
	input_s	<= To_bitvector(input);
	
	ing_gen1:
	FOR i IN 0 TO 3 GENERATE
		ing_gen2:
		FOR j IN 0 TO 14 GENERATE
			ing(i)(j) <= input_s(i + j*4);
		END GENERATE ing_gen2;
	END GENERATE ing_gen1;

	outg_gen:
	FOR i in 0 TO 3 GENERATE
		outg(i) <= ing(i) sll CONV_INTEGER(Shift);
	END GENERATE outg_gen;
		
	output_gen:
	FOR i IN 0 TO 14 GENERATE
		output_s((i*4)+3 DOWNTO i*4) <= outg(3)(i) & outg(2)(i) & outg(1)(i) & outg(0)(i);
	END GENERATE output_gen;
	
	output	<= To_StdLogicVector(output_s);
		
END a;