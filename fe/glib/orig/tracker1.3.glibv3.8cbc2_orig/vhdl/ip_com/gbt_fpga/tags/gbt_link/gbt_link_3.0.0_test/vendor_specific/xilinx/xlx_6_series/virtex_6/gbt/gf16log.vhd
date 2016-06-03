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
--						gf16log						--
--													--
-- Manually translated from verilog					--
-- Logarithm using GF(2^4) arithmetic				--
-- for Reed Solomon codec for GBT					--
-- Actually just a lookup table.					--
-- A. Marchioro	2006								--
--													--
-- Author: Frédéric Marin							--
-- Date: October 3rd, 2008							--
------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY gf16log IS
	PORT(
			input	: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
			output	: OUT 	STD_LOGIC_VECTOR(3 DOWNTO 0)
		);
END gf16log;


ARCHITECTURE a OF gf16log IS


	BEGIN
	
--	output<=	"0000" WHEN input = "0000" ELSE
--				"0000" WHEN input = "0001" ELSE
--				"0001" WHEN input = "0010" ELSE
--				"0100" WHEN input = "0011" ELSE
--				"0010" WHEN input = "0100" ELSE
--				"1000" WHEN input = "0101" ELSE
--				"0101" WHEN input = "0110" ELSE
--				"1010" WHEN input = "0111" ELSE
--				"0011" WHEN input = "1000" ELSE
--				"1110" WHEN input = "1001" ELSE
--				"1001" WHEN input = "1010" ELSE
--				"0111" WHEN input = "1011" ELSE
--				"0110" WHEN input = "1100" ELSE
--				"1101" WHEN input = "1101" ELSE
--				"1011" WHEN input = "1110" ELSE
--				"1100" WHEN input = "1111";
--------------

process(input)
begin
case input is
   when "0000" => output <= "0000";	
   when "0001" => output <= "0000";	
   when "0010" => output <= "0001";	
   when "0011" => output <= "0100";	
   when "0100" => output <= "0010";	
   when "0101" => output <= "1000";	
   when "0110" => output <= "0101";	
   when "0111" => output <= "1010";	
   when "1000" => output <= "0011";	
   when "1001" => output <= "1110";	
   when "1010" => output <= "1001";	
   when "1011" => output <= "0111";	
   when "1100" => output <= "0110";	
   when "1101" => output <= "1101";	
   when "1110" => output <= "1011";	
   when "1111" => output <= "1100";	
   when others => output <= "0000"; -- value selected randomly	
end case;
end process;

		
END a;