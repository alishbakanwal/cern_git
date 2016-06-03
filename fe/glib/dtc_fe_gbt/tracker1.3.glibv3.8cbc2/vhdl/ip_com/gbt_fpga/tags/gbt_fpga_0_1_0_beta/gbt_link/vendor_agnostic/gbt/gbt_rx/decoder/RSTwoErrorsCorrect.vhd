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
--				RSTwoErrorsCorrect					--
--													--
-- Manually translated from  verilog				--							--
--	This logic block in the RS decoder performs the	--
-- correction of two errors	based on the computed	--
-- syndromes										--
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


ENTITY RSTwoErrorsCorrect IS
	PORT(
		s1			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s2			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		xx0			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		xx1			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		reccoeffs	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
		detiszero	: IN	STD_LOGIC;
		corcoeffs	: OUT	STD_LOGIC_VECTOR(59 DOWNTO 0)
		);
END RSTwoErrorsCorrect;


ARCHITECTURE a OF RSTwoErrorsCorrect IS

COMPONENT gf16mult IS
	PORT(
			input1 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			input2 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
			output : OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT gf16add
	PORT(
		input1 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		input2 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		output : OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT gf16inverse
	PORT(
			input	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			output	: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT gf16log
	PORT(
			input	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			output	: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT gf16shifter IS
	PORT(
			input	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
			Shift	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			output	: OUT 	STD_LOGIC_VECTOR(59 DOWNTO 0)
		);
END COMPONENT;

COMPONENT adder60 IS
	PORT(
			input1	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
			input2	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
			output	: OUT 	STD_LOGIC_VECTOR(59 DOWNTO 0)
		);
END COMPONENT;


TYPE ARRAY_6_60 IS ARRAY(1 TO 6) OF STD_LOGIC_VECTOR(59 DOWNTO 0);
TYPE ARRAY_11_4 IS ARRAY(1 TO 11) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL temp	: ARRAY_6_60;
SIGNAL net	: ARRAY_11_4;
SIGNAL net20,net21,Y1,Y2,Y1B: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL ermag1,ermag2,ermag3	: STD_LOGIC_VECTOR(59 DOWNTO 0);

	
	BEGIN
	
	gf16mult_inst1 : gf16mult
	PORT MAP(
		input1	=> s1,
		input2	=> xx0,
		output	=> net(1)
			);
			
	gf16mult_inst2 : gf16mult
	PORT MAP(
		input1	=> xx1,
		input2	=> xx1,
		output	=> net(3)
			);
			
	gf16mult_inst3 : gf16mult
	PORT MAP(
		input1	=> xx0,
		input2	=> xx1,
		output	=> net(4)
			);
			
	gf16mult_inst4 : gf16mult
	PORT MAP(
		input1	=> net(2),
		input2	=> net(6),
		output	=> Y2
			);
			
	gf16mult_inst5 : gf16mult
	PORT MAP(
		input1	=> Y2,
		input2	=> xx1,
		output	=> net(8)
			);
			
	gf16mult_inst6 : gf16mult
	PORT MAP(
		input1	=> net(9),
		input2	=> net(10),
		output	=> Y1
			);
			
	gf16inverse_inst1 : gf16inverse
	PORT MAP(
		input	=> xx0,
		output	=> net(10)
			);
			
	gf16inverse_inst2 : gf16inverse
	PORT MAP(
		input	=> net(5),
		output	=> net(6)
			);
			
	gf16add_inst1 : gf16add
	PORT MAP(
		input1	=> net(3),
		input2	=> net(4),
		output	=> net(5)
			);
			
	gf16add_inst2 : gf16add
	PORT MAP(
		input1	=> net(8),
		input2	=> s1,
		output	=> net(9)
			);
			
	gf16add_inst3 : gf16add
	PORT MAP(
		input1	=> s2,
		input2	=> net(1),
		output	=> net(2)
			);
			
	gf16mult_inst7 : gf16mult
	PORT MAP(
		input1	=> s1,
		input2	=> net(10),
		output	=> Y1B
			);
			
	gf16log_inst1 : gf16log
	PORT MAP(
		input	=> xx0,
		output	=> net20
			);
			
	gf16log_inst2 : gf16log
	PORT MAP(
		input	=> xx1,
		output	=> net21
			);
			
	ermag1	<= X"00000000000000" & Y1;
	
	gf16shifter_inst1 : gf16shifter
	PORT MAP(
		input	=> ermag1,
		Shift	=> net20,
		output	=> temp(1)
			);
	
	ermag2	<= X"00000000000000" & Y2;
	
	gf16shifter_inst2 : gf16shifter
	PORT MAP(
		input	=> ermag2,
		Shift	=> net21,
		output	=> temp(2)
			);
			
	ermag3	<= X"00000000000000" & Y1B;
	
	gf16shifter_inst3 : gf16shifter
	PORT MAP(
		input	=> ermag3,
		Shift	=> net20,
		output	=> temp(4)
			);
			
	adder60_inst1 : adder60
	PORT MAP(
		input1	=> temp(1),
		input2	=> reccoeffs,
		output	=> temp(3)
			);
			
	adder60_inst2 : adder60
	PORT MAP(
		input1	=> temp(3),
		input2	=> temp(2),
		output	=> temp(6)
			);
			
	adder60_inst3 : adder60
	PORT MAP(
		input1	=> temp(4),
		input2	=> reccoeffs,
		output	=> temp(5)
			);
			
	corcoeffs	<= temp(6) WHEN detiszero = '0' ELSE temp(5);
			
END a;