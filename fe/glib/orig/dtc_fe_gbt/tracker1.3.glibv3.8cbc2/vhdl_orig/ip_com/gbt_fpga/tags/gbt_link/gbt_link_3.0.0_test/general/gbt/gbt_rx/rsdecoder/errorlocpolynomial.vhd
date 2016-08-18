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
--				errorlocpolynomial					--
--													--
-- Manually translated from  verilog				--
-- Computation of the error locator polynomials for	--
-- the decoder in the GBT							--
-- Needs the syndromes s1-s4 in input				--
-- A. Marchioro	2006								--
--													--
-- Author: Frédéric Marin							--
-- Date: October 6rd, 2008							--
------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY errorlocpolynomial IS
	PORT(
		s1			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s2			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s3			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s4			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		detiszero	: IN	STD_LOGIC;
		L1			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
		L2			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END errorlocpolynomial;


ARCHITECTURE a OF errorlocpolynomial IS

COMPONENT error1locpolynomial IS
	PORT(
		s1			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s2			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		L1B			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT error2locpolynomial IS
	PORT(
		s1			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s2			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s3			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s4			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		L1A			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
		L2A			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

SIGNAL L1A,L1B,L2A	: STD_LOGIC_VECTOR(3 DOWNTO 0);

	
	BEGIN
	
	error1locpolynomial_inst : error1locpolynomial
	PORT MAP(
			s1			=> s1,
			s2			=> s2,
			L1B			=> L1B
			);
			
	error2locpolynomial_inst : error2locpolynomial
	PORT MAP(
			s1			=> s1,
			s2			=> s2,
			s3			=> s3,
			s4			=> s4,
			L1A			=> L1A,
			L2A			=> L2A
			);
			
	L1	<= L1B	WHEN detiszero = '1' ELSE L1A;
	L2	<= X"0"	WHEN detiszero = '1' ELSE L2A;	
			
END a;



LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY error1locpolynomial IS
	PORT(
			s1			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			s2			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			L1B			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END error1locpolynomial;


ARCHITECTURE a OF error1locpolynomial IS

COMPONENT gf16inverse IS
	PORT(
		input	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		output	: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

COMPONENT gf16mult IS
	PORT(
		input1 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		input2 : IN		STD_LOGIC_VECTOR(3 DOWNTO 0);
		output : OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

SIGNAL net1	: STD_LOGIC_VECTOR(3 DOWNTO 0);

	
	BEGIN
	
	gf16inverse_inst : gf16inverse
	PORT MAP(
		input	=> s1,
		output	=>net1
			);
			
	gf16mult_inst : gf16mult
	PORT MAP(
		input1	=> net1,
		input2	=> s2,
		output	=> L1B
			);
			
END a;



LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY error2locpolynomial IS
	PORT(
			s1			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			s2			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			s3			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			s4			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			L1A			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0);
			L2A			: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END error2locpolynomial;


ARCHITECTURE a OF error2locpolynomial IS

COMPONENT gf16inverse IS
	PORT(
		input	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		output	: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END COMPONENT;

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

TYPE ARRAY_18_4 IS ARRAY(1 TO 18) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL net	: ARRAY_18_4;

	
	BEGIN
	
	gf16inverse_inst1 : gf16inverse
	PORT MAP(
		input	=> s2,
		output	=>net(2)
			);
	gf16inverse_inst2 : gf16inverse
	PORT MAP(
		input	=> s3,
		output	=>net(4)
			);
	gf16inverse_inst3 : gf16inverse
	PORT MAP(
		input	=> s1,
		output	=>net(5)
			);
	gf16inverse_inst4 : gf16inverse
	PORT MAP(
		input	=> net(14),
		output	=>net(15)
			);
			
	gf16mult_inst0 : gf16mult
	PORT MAP(
		input1	=> s3,
		input2	=> s3,
		output	=> net(1)
			);
	gf16mult_inst1 : gf16mult
	PORT MAP(
		input1	=> s1,
		input2	=> s3,
		output	=> net(3)
			);
	gf16mult_inst2 : gf16mult
	PORT MAP(
		input1	=> net(1),
		input2	=> net(2),
		output	=> net(6)
			);
	gf16mult_inst3 : gf16mult
	PORT MAP(
		input1	=> net(2),
		input2	=> net(3),
		output	=> net(7)
			);
	gf16mult_inst4 : gf16mult
	PORT MAP(
		input1	=> s3,
		input2	=> net(2),
		output	=> net(9)
			);
	gf16mult_inst5 : gf16mult
	PORT MAP(
		input1	=> net(2),
		input2	=> s1,
		output	=> net(10)
			);
	gf16mult_inst6 : gf16mult
	PORT MAP(
		input1	=> net(4),
		input2	=> s4,
		output	=> net(11)
			);
	gf16mult_inst7 : gf16mult
	PORT MAP(
		input1	=> s3,
		input2	=> net(5),
		output	=> net(12)
			);
	gf16mult_inst8 : gf16mult
	PORT MAP(
		input1	=> net(13),
		input2	=> net(15),
		output	=> net(17)
			);
	gf16mult_inst9 : gf16mult
	PORT MAP(
		input1	=> net(17),
		input2	=> net(10),
		output	=> net(16)
			);
			
	gf16add_inst1 : gf16add
	PORT MAP(
		input1	=> net(9),
		input2	=> net(16),
		output	=> net(18)
			);
	gf16add_inst2 : gf16add
	PORT MAP(
		input1	=> s4,
		input2	=> net(6),
		output	=> net(13)
			);
	gf16add_inst3 : gf16add
	PORT MAP(
		input1	=> net(7),
		input2	=> s2,
		output	=> net(14)
			);
			
	L2A	<= net(12) WHEN s2 = X"0" ELSE net(17);
	L1A	<= net(11) WHEN s2 = X"0" ELSE net(18);
			
END a;