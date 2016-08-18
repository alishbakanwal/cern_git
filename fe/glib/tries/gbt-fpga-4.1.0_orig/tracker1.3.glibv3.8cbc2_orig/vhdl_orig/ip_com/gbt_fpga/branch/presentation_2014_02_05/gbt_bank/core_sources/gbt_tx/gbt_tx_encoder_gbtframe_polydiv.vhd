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


-- MBM - New module name (18/11/2013)
--     - gf16mult and gf16add are functions instead of modules

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;

ENTITY gbt_tx_encoder_gbtframe_polydiv IS
	PORT(
			ia			: IN	STD_LOGIC_VECTOR(59 DOWNTO 0);
			ib			: IN	STD_LOGIC_VECTOR(19 DOWNTO 0);
			oquot		: OUT	STD_LOGIC_VECTOR(43 DOWNTO 0);
			orem		: OUT	STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
END gbt_tx_encoder_gbtframe_polydiv;


ARCHITECTURE a OF gbt_tx_encoder_gbtframe_polydiv IS

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
	
   process(ia, ib, quot, s_rem, a, b, net)
   begin      
      
      -- a_assign_loop:
      for i in 0 to 14 loop
         a(i)	<= ia((4*i)+3 downto 4*i);
      end loop;
      
      -- b_assign_lloop:
      for i in 0 to 4 loop
         b(i)	<= ib((4*i)+3 downto 4*i);
      end loop;
      
      -- oquot_assign_loop:
      for i in 0 to 10 loop
         oquot((4*i)+3 downto 4*i)	<= quot(i);
      end loop;
      
      -- orem_assign_loop:
      for i in 0 to 3 loop
         orem((4*i)+3 downto 4*i)	<= s_rem(i);
      end loop;
      
      -- Stage 1
      quot(10)	<= a(14);
      
      -- stage1_gf16mult_loop:
      for i in 0 to 3 loop	
         net(1+(2*i)) <= gf16mult(b(3-i),a(14));       
      end loop;
      
      -- stage1_gf16add_loop:
      for i in 0 to 3 loop	
         net(2+(2*i)) <= gf16add(net(1+(2*i)),a(13-i));        
      end loop;
	
      -- Stage 2
      quot(9)	<= net(2);
      
      -- stage2_gf16mult_loop:
      for i in 0 to 3 loop	
         net(9+(2*i)) <= gf16mult(b(3-i),net(2));        
      end loop;
	
      -- stage2_gf16add_loop:
      for i in 0 to 2 loop	
         net(10+(2*i)) <= gf16add(net(9+(2*i)),net(4+(2*i)));		
      end loop;
	
      net(16) <= gf16add(net(15),a(9));		
		
      -- Stage 3
      quot(8)	<= net(10);
      
      -- stage3_gf16mult_loop:
      for i in 0 to 3 loop	
         net(17+(2*i)) <= gf16mult(b(3-i),net(10));         
      end loop;
      
      -- stage3_gf16add_loop:
      for i in 0 to 2 loop	
         net(18+(2*i)) <= gf16add(net(17+(2*i)),net(12+(2*i)));         
      end loop;
      
      net(24)  <= gf16add(net(23),a(8));
      
      -- Stage 4
      quot(7)	<= net(18);
      
      -- stage4_gf16mult_loop:
      for i in 0 to 3 loop	
         net(25+(2*i)) <= gf16mult(b(3-i),net(18));         
      end loop;
      
      -- stage4_gf16add_loop:
      for i in 0 to 2 loop	
         net(26+(2*i)) <= gf16add(net(25+(2*i)),net(20+(2*i)));        
      end loop;
      
      net(32) <= gf16add(net(31),a(7));
        
      -- Stage 5
      quot(6)	<= net(26);
      
      -- stage5_gf16mult_loop:
      for i in 0 to 3 loop	
         net(33+(2*i)) <= gf16mult(b(3-i),net(26));         
      end loop;
      
      -- stage5_gf16add_loop:
      for i in 0 to 2 loop	
         net(34+(2*i)) <= gf16add(net(33+(2*i)),net(28+(2*i)));         
      end loop;
      
      net(40) <= gf16add(net(39),a(6));        
   
      -- Stage 6
      quot(5)	<= net(34);
      
      -- stage6_gf16mult_loop:
      for i in 0 to 3 loop	
         net(41+(2*i)) <= gf16mult(b(3-i),net(34));         
      end loop;
      
      -- stage6_gf16add_loop:
      for i in 0 to 2 loop	
         net(42+(2*i)) <= gf16add(net(41+(2*i)),net(36+(2*i)));         
      end loop;
      
      net(48) <= gf16add(net(47),a(5));
        
      -- Stage 7
      quot(4)	<= net(42);
      
      -- stage7_gf16mult_loop:
      for i in 0 to 3 loop	
         net(49+(2*i)) <= gf16mult(b(3-i),net(42));         
      end loop;
      
      -- stage7_gf16add_loop:
      for i in 0 to 2 loop	
         net(50+(2*i)) <= gf16add(net(49+(2*i)),net(44+(2*i)));        
      end loop;
      
      net(56) <= gf16add(net(55),a(4));
         
      -- stage 8
      quot(3)	<= net(50);
      
      -- stage8_gf16mult_loop:
      for i in 0 to 3 loop	
         net(57+(2*i)) <= gf16mult(b(3-i),net(50));         
      end loop;
      
      -- stage8_gf16add_loop:
      for i in 0 to 2 loop	
         net(58+(2*i)) <= gf16add(net(57+(2*i)),net(52+(2*i)));        
      end loop;
      
      net(64) <= gf16add(net(63),a(3));         
      
      -- Stage 9
      quot(2)	<= net(58);
      
      -- stage9_gf16mult_loop:
      for i in 0 to 3 loop	
         net(65+(2*i)) <= gf16mult(b(3-i),net(58));        
      end loop;
      
      -- stage9_gf16add_loop:
      for i in 0 to 2 loop	
         net(66+(2*i)) <= gf16add(net(65+(2*i)),net(60+(2*i)));         
      end loop;
      
      net(72) <= gf16add(net(71),a(2));
         
      -- Stage 10
      quot(1)	<= net(66);
      
      -- stage10_gf16mult_loop:
      for i in 0 to 3 loop	
         net(73+(2*i)) <= gf16mult(b(3-i),net(66));        
      end loop;
      
      -- stage10_gf16add_loop
      for i in 0 to 2 loop	
         net(74+(2*i)) <= gf16add(net(73+(2*i)),net(68+(2*i)));         
      end loop;
      
      net(80) <= gf16add(net(79),a(1));
      
      -- Stage 11
      quot(0)	<= net(74);
      
      -- stage11_gf16mult_loop:
      for i in 0 to 3 loop	
         net(81+(2*i)) <= gf16mult(b(3-i),net(74));
      end loop;
      
      -- stage11_gf16add_loop:
      for i in 0 to 2 loop	
         net(82+(2*i)) <= gf16add(net(81+(2*i)),net(76+(2*i)));         
      end loop;
      
      net(88) <= gf16add(net(87),a(0));         
               
      -- s_rem_assign_loop:
      for i in 0 to 3 loop
         s_rem(i)	<= net(88-(2*i));
      end loop;
   
   end process;	
		
END a;