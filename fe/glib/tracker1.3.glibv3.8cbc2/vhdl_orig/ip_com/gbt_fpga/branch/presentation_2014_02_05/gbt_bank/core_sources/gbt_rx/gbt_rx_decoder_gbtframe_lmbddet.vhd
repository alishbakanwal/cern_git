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

-- MBM - New module name (18/11/2013)
--     - gf16mult and gf16add are functions instead of modules

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

use work.gbt_bank_package.all;

ENTITY gbt_rx_decoder_gbtframe_lmbddet IS
	PORT(
		s1			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s2			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		s3			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		detiszero	: OUT 	STD_LOGIC
		);
END gbt_rx_decoder_gbtframe_lmbddet;


ARCHITECTURE a OF gbt_rx_decoder_gbtframe_lmbddet IS

SIGNAL Mult1_Out	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL Mult2_Out	: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL Add_Out		: STD_LOGIC_VECTOR(3 DOWNTO 0);

	
	BEGIN   
   
   Mult1_Out <= gf16mult(s2,s3);
         
   Mult2_Out <= gf16mult(s1,s2);      
      
   Add_Out   <= gf16add(Mult1_Out, Mult2_Out);
    
   detiszero <= '1' WHEN Add_Out = "0000" ELSE '0';      
		
END a;