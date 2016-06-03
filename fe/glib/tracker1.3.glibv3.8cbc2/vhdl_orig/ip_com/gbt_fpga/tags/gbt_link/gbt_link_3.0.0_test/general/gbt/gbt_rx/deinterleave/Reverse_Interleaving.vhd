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

---------------------------------------------------------------------------------------------------------------------------------
--  ENTITY				: 	REVERSE_INTERLEAVING.VHD		
--  VERSION				:	0.2						
--  VENDOR SPECIFIC?	:	NO
--  FPGA SPECIFIC? 		:   NO
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE		:	30/09/2008
--  LAST UPDATE     	:   06/04/2009  
--  AUTHORs				:	Frederic MARIN (CPPM) 
--  LANGAGE 			:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION			:	Does the inverse interleaving done at the emission side. No clock cycle.
--					
--					
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--                      DATE            	VERSION           	AUTHOR		DESCRIPTION
--                      10/05/2009   		0.1                	MARIN   	first .BDF entity definition           
--						06/04/2009			0.2					MARIN		nibble base de-interleaving (was bit based before)
---------------------------------------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;	-- necessary to understand addition
                	                -- of std_logic_vectors to integers
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ENTITY Reverse_Interleaving IS
	PORT(
		Input					: IN	STD_LOGIC_VECTOR(119 DOWNTO 0);
		
		Output					: OUT	STD_LOGIC_VECTOR(119 DOWNTO 0)
    );	

END Reverse_Interleaving;
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE a OF Reverse_Interleaving IS

BEGIN

Reverse_Interleaving_Gen:
	FOR i IN 0 TO 14 GENERATE
		Output(119-(4*i) DOWNTO 116-(4*i))	<= Input(119-(8*i) DOWNTO 116-(8*i));
		Output(59-(4*i) DOWNTO 56-(4*i))	<= Input(115-(8*i) DOWNTO 112-(8*i));
	END GENERATE Reverse_Interleaving_Gen;

END a;