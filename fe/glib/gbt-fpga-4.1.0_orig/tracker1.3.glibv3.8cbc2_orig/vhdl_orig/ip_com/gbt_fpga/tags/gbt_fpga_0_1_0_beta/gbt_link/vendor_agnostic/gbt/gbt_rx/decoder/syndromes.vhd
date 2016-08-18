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
--					syndromes						--
--													--
-- Manually translated from verilog					--
-- This logic computes the syndromes on the received--
-- data	for the RS decoder in the GBT				--
-- A. Marchioro	2006								--
--													--													--
-- Author: Frédéric Marin							--
-- Date: October 7th, 2008							--
------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY syndromes IS
	PORT(
		polycoeffs	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
		s1			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s2			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s3			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s4			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END syndromes;


ARCHITECTURE a OF syndromes IS

--
-- Powers of the GF(16) field primitive
--		
CONSTANT alphapowers1 : STD_LOGIC_VECTOR(59 DOWNTO 0):= X"9DFE7A5BC638421";
CONSTANT alphapowers2 : STD_LOGIC_VECTOR(59 DOWNTO 0):= X"DEAB6829F75C341";
CONSTANT alphapowers3 : STD_LOGIC_VECTOR(59 DOWNTO 0):= X"FAC81FAC81FAC81";
CONSTANT alphapowers4 : STD_LOGIC_VECTOR(59 DOWNTO 0):= X"EB897C4DA62F531";


COMPONENT syndrome_evaluator IS
	PORT(
		alphapowers	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
		polycoeffs	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
		syndrome	: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

	BEGIN
	
	syndrome_evaluator_inst1 : syndrome_evaluator
	PORT MAP(
			alphapowers	=> alphapowers1,
			polycoeffs	=> polycoeffs,
			syndrome	=> s1
			);
			
	syndrome_evaluator_inst2 : syndrome_evaluator
	PORT MAP(
			alphapowers	=> alphapowers2,
			polycoeffs	=> polycoeffs,
			syndrome	=> s2
			);
			
	syndrome_evaluator_inst3 : syndrome_evaluator
	PORT MAP(
			alphapowers	=> alphapowers3,
			polycoeffs	=> polycoeffs,
			syndrome	=> s3
			);
			
	syndrome_evaluator_inst4 : syndrome_evaluator
	PORT MAP(
			alphapowers	=> alphapowers4,
			polycoeffs	=> polycoeffs,
			syndrome	=> s4
			);
			
END a;



LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY syndrome_evaluator IS
	PORT(
		alphapowers	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
		polycoeffs	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
		syndrome	: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END syndrome_evaluator;


ARCHITECTURE a OF syndrome_evaluator IS

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
TYPE ARRAY_7_4 IS ARRAY(0 TO 6) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
TYPE ARRAY_4_4 IS ARRAY(0 TO 3) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
TYPE ARRAY_2_4 IS ARRAY(0 TO 1) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL net : ARRAY_15_4;
SIGNAL net2 : ARRAY_7_4;
SIGNAL net3 : ARRAY_4_4;
SIGNAL net4 : ARRAY_2_4;

	BEGIN
	
	gf16mult_inst_gen:
	FOR i IN 0 TO 14 GENERATE
		gf16mult_inst : gf16mult
		PORT MAP(
				input1 => polycoeffs(59-(4*i) DOWNTO 56-(4*i)),
				input2 => alphapowers(59-(4*i) DOWNTO 56-(4*i)),
				output => net(i)
				);
	END GENERATE;
	
	gf16add_inst_gen:
	FOR i IN 0 TO 6 GENERATE
		gf16add_inst : gf16add
		PORT MAP(
				input1 => net((2*i)+1),
				input2 => net(2*i),
				output => net2(i)
				);
	END GENERATE;
	
	gf16add_inst_gen2:
	FOR i IN 0 TO 2 GENERATE
		gf16add_inst2 : gf16add
		PORT MAP(
				input1 => net2((2*i)+1),
				input2 => net2(2*i),
				output => net3(i)
				);
	END GENERATE;
	
	gf16add_inst3 : gf16add
		PORT MAP(
				input1 => net(14),
				input2 => net2(6),
				output => net3(3)
				);
				
	gf16add_inst_gen4:
	FOR i IN 0 TO 1 GENERATE
		gf16add_inst4 : gf16add
		PORT MAP(
				input1 => net3((2*i)+1),
				input2 => net3(2*i),
				output => net4(i)
				);
	END GENERATE;
	
	gf16add_inst5 : gf16add
		PORT MAP(
				input1 => net4(1),
				input2 => net4(0),
				output => syndrome
				);
	
			
END a;