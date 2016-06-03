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
--						RSEncoder					--
--													--
-- Manually translated from  verilog				--							--
-- Reed Solomon codec for GBT						--
-- A. Marchioro	2006								--
--													--
-- Author: Frédéric Marin							--
-- Date: October 6rd, 2008							--
------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY RSEncoder IS
	PORT(
			msgin		: IN	STD_LOGIC_VECTOR(43 DOWNTO 0);
			codeout		: OUT	STD_LOGIC_VECTOR(59 DOWNTO 0)
		);
END RSEncoder;


ARCHITECTURE a OF RSEncoder IS

COMPONENT polydivider IS
	PORT(
		ia			: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
		ib			: IN	STD_LOGIC_VECTOR(19 DOWNTO 0);
		oquot		: OUT	STD_LOGIC_VECTOR(43 DOWNTO 0);
		orem		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
END COMPONENT;


SIGNAL ia			: STD_LOGIC_VECTOR(59 DOWNTO 0);
SIGNAL cycgenpoly	: STD_LOGIC_VECTOR(19 DOWNTO 0);
SIGNAL orem			: STD_LOGIC_VECTOR(15 DOWNTO 0);
-- SIGNAL oquot		: STD_LOGIC_VECTOR(43 DOWNTO 0);

	
	BEGIN
	
	cycgenpoly	<= X"1DC87";
	
	ia			<= msgin & X"0000";
	
	polydivider_inst : polydivider
	PORT MAP(
		ia		=> ia,
		ib		=> cycgenpoly,
		oquot	=> open, -- oquot,
		orem	=> orem
			);
	
	codeout		<= msgin & orem;
	
			
END a;