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
--					lambdadeterminant				--
--													--
-- Manually translated from verilog					--
-- This circuit computes the lambda determinant		--
-- needed for correcting errors						--
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


ENTITY lambdadeterminant IS
	PORT(
		s1			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s2			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s3			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		detiszero	: OUT 	STD_LOGIC
		);
END lambdadeterminant;


ARCHITECTURE a OF lambdadeterminant IS

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

SIGNAL Mult1_Out	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL Mult2_Out	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL Add_Out		: STD_LOGIC_VECTOR(3 DOWNTO 0);

	
	BEGIN
	
	gf16mult1_inst : gf16mult
	PORT MAP(
		input1	=> s2,
		input2	=> s3,
		output	=> Mult1_Out
			);
			
	gf16mult2_inst : gf16mult
	PORT MAP(
		input1	=> s1,
		input2	=> s2,
		output	=> Mult2_Out
			);
		
	gf16add_inst : gf16add
	PORT MAP(
		input1	=> Mult1_Out,
		input2	=> Mult2_Out,
		output	=> Add_Out
			);
	
	detiszero <= '1' WHEN Add_Out = "0000" ELSE '0';
	
		
END a;