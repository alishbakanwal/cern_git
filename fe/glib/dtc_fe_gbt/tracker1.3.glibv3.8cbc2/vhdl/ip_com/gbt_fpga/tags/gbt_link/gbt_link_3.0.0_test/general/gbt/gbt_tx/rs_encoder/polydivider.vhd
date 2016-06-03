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
--					polydivider						--
--													--
-- Manually translated from automatic generated		--
-- verilog											--
-- This circuit computes the lambda determinant		--
-- needed for correcting errors						--
-- for Reed Solomon codec for GBT					--
-- A. Marchioro	2006								--
--													--
-- Input: ia, ib		divider and divisor			--
-- Output: oquot, orem	quotient and remainder		--
--													--
-- Author: Frédéric Marin							--
-- Date: October 3rd, 2008							--
------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY polydivider IS
	PORT(
			ia			: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
			ib			: IN	STD_LOGIC_VECTOR(19 DOWNTO 0);
			oquot		: OUT	STD_LOGIC_VECTOR(43 DOWNTO 0);
			orem		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
END polydivider;


ARCHITECTURE a OF polydivider IS

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


TYPE ARRAY_15_4 IS ARRAY(0 TO 14) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
TYPE ARRAY_5_4 IS ARRAY(0 TO 4) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
TYPE ARRAY_11_4 IS ARRAY(0 TO 10) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
TYPE ARRAY_4_4 IS ARRAY(0 TO 3) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
TYPE ARRAY_89_4 IS ARRAY(0 TO 88) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL a	: ARRAY_15_4;
SIGNAL b	: ARRAY_5_4;
SIGNAL quot	: ARRAY_11_4;
SIGNAL s_rem: ARRAY_4_4;
SIGNAL net	: ARRAY_89_4;

	
	BEGIN
	
	a_assign_gen:
	FOR i IN 0 TO 14 GENERATE
		a(i)	<= ia((4*i)+3 DOWNTO 4*i);
	END GENERATE;
	
	b_assign_gen:
	FOR i IN 0 TO 4 GENERATE
		b(i)	<= ib((4*i)+3 DOWNTO 4*i);
	END GENERATE;
	
	oquot_assign_gen:
	FOR i IN 0 TO 10 GENERATE
		oquot((4*i)+3 DOWNTO 4*i)	<= quot(i);
	END GENERATE;
	
	orem_assign_gen:
	FOR i IN 0 TO 3 GENERATE
		orem((4*i)+3 DOWNTO 4*i)	<= s_rem(i);
	END GENERATE;
	
	-- Stage 1
	quot(10)	<= a(14);
	
	stage1_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> a(14),
			output	=> net(1+(2*i))
				);
	END GENERATE;
	
	stage1_gf16add_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(1+(2*i)),
			input2	=> a(13-i),
			output	=> net(2+(2*i))
				);
	END GENERATE;
	
	-- Stage 2
	quot(9)	<= net(2);
	
	stage2_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> net(2),
			output	=> net(9+(2*i))
				);
	END GENERATE;
	
	stage2_gf16add_gen:
	FOR i IN 0 TO 2 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(9+(2*i)),
			input2	=> net(4+(2*i)),
			output	=> net(10+(2*i))
				);
	END GENERATE;
	
	stage2_gf16add_man_inst : gf16add
		PORT MAP(
			input1	=> net(15),
			input2	=> a(9),
			output	=> net(16)
				);
		
	-- Stage 3
	quot(8)	<= net(10);
	
	stage3_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> net(10),
			output	=> net(17+(2*i))
				);
	END GENERATE;
	
	stage3_gf16add_gen:
	FOR i IN 0 TO 2 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(17+(2*i)),
			input2	=> net(12+(2*i)),
			output	=> net(18+(2*i))
				);
	END GENERATE;
	
	stage3_gf16add_man_inst : gf16add
		PORT MAP(
			input1	=> net(23),
			input2	=> a(8),
			output	=> net(24)
				);
				
	-- Stage 4
	quot(7)	<= net(18);
	
	stage4_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> net(18),
			output	=> net(25+(2*i))
				);
	END GENERATE;
	
	stage4_gf16add_gen:
	FOR i IN 0 TO 2 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(25+(2*i)),
			input2	=> net(20+(2*i)),
			output	=> net(26+(2*i))
				);
	END GENERATE;
	
	stage4_gf16add_man_inst : gf16add
		PORT MAP(
			input1	=> net(31),
			input2	=> a(7),
			output	=> net(32)
				);
				
	-- Stage 5
	quot(6)	<= net(26);
	
	stage5_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> net(26),
			output	=> net(33+(2*i))
				);
	END GENERATE;
	
	stage5_gf16add_gen:
	FOR i IN 0 TO 2 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(33+(2*i)),
			input2	=> net(28+(2*i)),
			output	=> net(34+(2*i))
				);
	END GENERATE;
	
	stage5_gf16add_man_inst : gf16add
		PORT MAP(
			input1	=> net(39),
			input2	=> a(6),
			output	=> net(40)
				);
				
	-- Stage 6
	quot(5)	<= net(34);
	
	stage6_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> net(34),
			output	=> net(41+(2*i))
				);
	END GENERATE;
	
	stage6_gf16add_gen:
	FOR i IN 0 TO 2 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(41+(2*i)),
			input2	=> net(36+(2*i)),
			output	=> net(42+(2*i))
				);
	END GENERATE;
	
	stage6_gf16add_man_inst : gf16add
		PORT MAP(
			input1	=> net(47),
			input2	=> a(5),
			output	=> net(48)
				);
				
	-- Stage 7
	quot(4)	<= net(42);
	
	stage7_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> net(42),
			output	=> net(49+(2*i))
				);
	END GENERATE;
	
	stage7_gf16add_gen:
	FOR i IN 0 TO 2 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(49+(2*i)),
			input2	=> net(44+(2*i)),
			output	=> net(50+(2*i))
				);
	END GENERATE;
	
	stage7_gf16add_man_inst : gf16add
		PORT MAP(
			input1	=> net(55),
			input2	=> a(4),
			output	=> net(56)
				);
				
	-- Stage 8
	quot(3)	<= net(50);
	
	stage8_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> net(50),
			output	=> net(57+(2*i))
				);
	END GENERATE;
	
	stage8_gf16add_gen:
	FOR i IN 0 TO 2 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(57+(2*i)),
			input2	=> net(52+(2*i)),
			output	=> net(58+(2*i))
				);
	END GENERATE;
	
	stage8_gf16add_man_inst : gf16add
		PORT MAP(
			input1	=> net(63),
			input2	=> a(3),
			output	=> net(64)
				);
				
	-- Stage 9
	quot(2)	<= net(58);
	
	stage9_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> net(58),
			output	=> net(65+(2*i))
				);
	END GENERATE;
	
	stage9_gf16add_gen:
	FOR i IN 0 TO 2 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(65+(2*i)),
			input2	=> net(60+(2*i)),
			output	=> net(66+(2*i))
				);
	END GENERATE;
	
	stage9_gf16add_man_inst : gf16add
		PORT MAP(
			input1	=> net(71),
			input2	=> a(2),
			output	=> net(72)
				);
				
	-- Stage 10
	quot(1)	<= net(66);
	
	stage10_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> net(66),
			output	=> net(73+(2*i))
				);
	END GENERATE;
	
	stage10_gf16add_gen:
	FOR i IN 0 TO 2 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(73+(2*i)),
			input2	=> net(68+(2*i)),
			output	=> net(74+(2*i))
				);
	END GENERATE;
	
	stage10_gf16add_man_inst : gf16add
		PORT MAP(
			input1	=> net(79),
			input2	=> a(1),
			output	=> net(80)
				);
				
	-- Stage 11
	quot(0)	<= net(74);
	
	stage11_gf16mult_gen:
	FOR i IN 0 TO 3 GENERATE	
		gf16mult_inst : gf16mult
		PORT MAP(
			input1	=> b(3-i),
			input2	=> net(74),
			output	=> net(81+(2*i))
				);
	END GENERATE;
	
	stage11_gf16add_gen:
	FOR i IN 0 TO 2 GENERATE	
		gf16add_inst : gf16add
		PORT MAP(
			input1	=> net(81+(2*i)),
			input2	=> net(76+(2*i)),
			output	=> net(82+(2*i))
				);
	END GENERATE;
	
	stage11_gf16add_man_inst : gf16add
		PORT MAP(
			input1	=> net(87),
			input2	=> a(0),
			output	=> net(88)
				);
				
	s_rem_assign_gen:
	FOR i IN 0 TO 3 GENERATE
		s_rem(i)	<= net(88-(2*i));
	END GENERATE;
	
		
END a;