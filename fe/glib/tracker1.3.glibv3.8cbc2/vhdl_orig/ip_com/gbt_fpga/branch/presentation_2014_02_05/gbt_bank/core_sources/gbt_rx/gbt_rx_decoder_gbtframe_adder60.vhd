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

-- MBM - New module name (18/11/2013)
--     - gf16add is functions instead of modules

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;

ENTITY gbt_rx_decoder_gbtframe_adder60 IS
	PORT(
			input1	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
			input2	: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
			output	: OUT 	STD_LOGIC_VECTOR(59 DOWNTO 0)
		);
END gbt_rx_decoder_gbtframe_adder60;


ARCHITECTURE a OF gbt_rx_decoder_gbtframe_adder60 IS

	BEGIN
	
	gf16add_loop:
	for i in 0 to 14 generate
		output((4*i)+3 downto 4*i) <= gf16add(input1((4*i)+3 downto 4*i), input2((4*i)+3 downto 4*i));
	end generate;
		
END a;