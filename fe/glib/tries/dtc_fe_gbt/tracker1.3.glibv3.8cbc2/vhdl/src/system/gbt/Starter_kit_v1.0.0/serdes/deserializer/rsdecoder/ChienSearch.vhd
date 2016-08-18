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
--					ChienSearch						--
--													--
-- Manually translated from  verilog				--
-- This circuit performs an unrolled Chien search 	--
-- for computing the error location in the Reed 	--
-- Solomon codec for GBT							--
-- A. Marchioro	2006								--
--													--
-- Author: Frédéric Marin							--
-- Date: October 6rd, 2008							--
------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY ChienSearch IS
	PORT(
		L1			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		L2			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		detiszero	: IN	STD_LOGIC;
		xx0			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
		xx1			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END ChienSearch;


ARCHITECTURE a OF ChienSearch IS

COMPONENT elpeval IS
	PORT(
		alphai		: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		elp			: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
		y			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
		zero		: OUT	STD_LOGIC
		);
END COMPONENT;

COMPONENT pri_encoderR IS
	PORT(
		encoder_in	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		binary_out	: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT pri_encoderL IS
	PORT(
		encoder_in	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		binary_out	: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT gf16inverse IS
	PORT(
		input	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		output	: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;


-- TYPE ARRAY_15_4 IS ARRAY(1 TO 15) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL alphas	: STD_LOGIC_VECTOR(59 DOWNTO 0);
SIGNAL elp		: STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL zero		: STD_LOGIC_VECTOR(15 DOWNTO 1);
SIGNAL z		: STD_LOGIC_VECTOR(15 DOWNTO 0);
-- SIGNAL y		: ARRAY_15_4;
SIGNAL posR,posL: STD_LOGIC_VECTOR(3 DOWNTO 0);

	
	BEGIN
	
	alphas	<=	X"FEDCBA987654321";
	
	elp		<=	(L2 & L1 & X"1") WHEN detiszero = '0' ELSE
				(X"0" & L1 & X"1");
	
	elpeval_inst_gen:
	FOR i IN 0 TO 14 GENERATE
		elpeval_inst : elpeval
		PORT MAP(
				alphai		=> alphas((4*i)+3 DOWNTO 4*i),
				elp			=> elp,
				y			=> open, -- y(i+1),
				zero		=> zero(i+1)
				);
	END GENERATE;
	
	z		<= '0' & zero;
	
	pri_encoderR_inst : pri_encoderR	
	PORT MAP(
			encoder_in	=> z,--('0' & z),
			binary_out	=> posR
			);
			
	pri_encoderL_inst : pri_encoderL
	PORT MAP(
			encoder_in	=> z,--'0' & z,
			binary_out	=> posL
			);
	
	gf16inverse_inst1 : gf16inverse
	PORT MAP(
			input	=> posR,
			output	=> xx0
			);
			
	gf16inverse_inst2 : gf16inverse
	PORT MAP(
			input	=> posL,
			output	=> xx1
			);
			
END a;




LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY elpeval IS
	PORT(
			alphai		: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			elp			: IN	STD_LOGIC_VECTOR(11 DOWNTO 0);
			y			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
			zero		: OUT	STD_LOGIC
		);
END elpeval;


ARCHITECTURE a OF elpeval IS

COMPONENT gf16mult IS
	PORT(
		input1 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		input2 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		output : OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT gf16add IS
	PORT(
		input1 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		input2 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		output : OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

SIGNAL net1,net2,net3,net4,net5	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL a2,a3					: STD_LOGIC_VECTOR(3 DOWNTO 0);

	
	BEGIN
	
	gf16mult_inst1 : gf16mult
	PORT MAP(
			input1	=> alphai,
			input2	=> alphai,
			output	=> a2
			);
	gf16mult_inst2 : gf16mult
	PORT MAP(
			input1	=> a2,
			input2	=> alphai,
			output	=> a3
			);
	gf16mult_inst3 : gf16mult
	PORT MAP(
			input1	=> elp(11 DOWNTO 8),
			input2	=> a3,
			output	=> net1
			);
	gf16mult_inst4 : gf16mult
	PORT MAP(
			input1	=> elp(7 DOWNTO 4),
			input2	=> a2,
			output	=> net2
			);
	gf16mult_inst5 : gf16mult
	PORT MAP(
			input1	=> elp(3 DOWNTO 0),
			input2	=> alphai,
			output	=> net3
			);
			
	gf16add_inst1 : gf16add
	PORT MAP(
			input1	=> net1,
			input2	=> net2,
			output	=> net4
			);
	gf16add_inst2 : gf16add
	PORT MAP(
			input1	=> net3,
			input2	=> net4,
			output	=> net5
			);
			
			zero	<= '1' WHEN net5 = X"0" ELSE '0';
			y		<= alphai;	
			
END a;



LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY pri_encoderR IS
	PORT(
			encoder_in	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			binary_out	: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END pri_encoderR;


ARCHITECTURE a OF pri_encoderR IS

	BEGIN
			
	binary_out	<=	"0001" WHEN (encoder_in(0) = '1') ELSE
					"0010" WHEN (encoder_in(1 DOWNTO 0) = "10") ELSE
					"0011" WHEN (encoder_in(2 DOWNTO 0) = "100") ELSE
					"0100" WHEN (encoder_in(3 DOWNTO 0) = "1000") ELSE
					"0101" WHEN (encoder_in(4 DOWNTO 0) = "10000") ELSE
					"0110" WHEN (encoder_in(5 DOWNTO 0) = "100000") ELSE
					"0111" WHEN (encoder_in(6 DOWNTO 0) = "1000000") ELSE
					"1000" WHEN (encoder_in(7 DOWNTO 0) = "10000000") ELSE
					"1001" WHEN (encoder_in(8 DOWNTO 0) = "100000000") ELSE
					"1010" WHEN (encoder_in(9 DOWNTO 0) = "1000000000") ELSE
					"1011" WHEN (encoder_in(10 DOWNTO 0) = "10000000000") ELSE
					"1100" WHEN (encoder_in(11 DOWNTO 0) = "100000000000") ELSE
					"1101" WHEN (encoder_in(12 DOWNTO 0) = "1000000000000") ELSE
					"1110" WHEN (encoder_in(13 DOWNTO 0) = "10000000000000") ELSE
					"1111" WHEN (encoder_in(14 DOWNTO 0) = "100000000000000") ELSE
					"0000" WHEN (encoder_in = "1000000000000000") ELSE
					"0000";					
			
END a;



LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY pri_encoderL IS
	PORT(
			encoder_in	: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
			binary_out	: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END pri_encoderL;


ARCHITECTURE a OF pri_encoderL IS

	BEGIN
			
	binary_out	<=	"0000" WHEN (encoder_in(15) = '1') ELSE
					"1111" WHEN (encoder_in(15 DOWNTO 14) = "01") ELSE
					"1110" WHEN (encoder_in(15 DOWNTO 13) = "001") ELSE
					"1101" WHEN (encoder_in(15 DOWNTO 12) = "0001") ELSE
					"1100" WHEN (encoder_in(15 DOWNTO 11) = "00001") ELSE
					"1011" WHEN (encoder_in(15 DOWNTO 10) = "000001") ELSE
					"1010" WHEN (encoder_in(15 DOWNTO 9) = "0000001") ELSE
					"1001" WHEN (encoder_in(15 DOWNTO 8) = "00000001") ELSE
					"1000" WHEN (encoder_in(15 DOWNTO 7) = "000000001") ELSE
					"0111" WHEN (encoder_in(15 DOWNTO 6) = "0000000001") ELSE
					"0110" WHEN (encoder_in(15 DOWNTO 5) = "00000000001") ELSE
					"0101" WHEN (encoder_in(15 DOWNTO 4) = "000000000001") ELSE
					"0100" WHEN (encoder_in(15 DOWNTO 3) = "0000000000001") ELSE
					"0011" WHEN (encoder_in(15 DOWNTO 2) = "00000000000001") ELSE
					"0010" WHEN (encoder_in(15 DOWNTO 1) = "000000000000001") ELSE
					"0001" WHEN (encoder_in = "0000000000000001") ELSE
					"0000";					
			
END a;