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

-- MBM (04/07/2013)
-- New name
--port names


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;	-- necessary to understand addition
                	                -- of std_logic_vectors to integers
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ENTITY gbt_rx_decoder_gbtframe_deintlver IS
	PORT(     
		RX_FRAME_I					: IN	STD_LOGIC_VECTOR(119 DOWNTO 0);
		RX_FRAME_O					: OUT	STD_LOGIC_VECTOR(119 DOWNTO 0)
    );	

END gbt_rx_decoder_gbtframe_deintlver;
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE a OF gbt_rx_decoder_gbtframe_deintlver IS
  
BEGIN
   
gbtFrameDeinterleaving_gen:
	FOR i IN 0 TO 14 GENERATE
		RX_FRAME_O(119-(4*i) DOWNTO 116-(4*i))	<= RX_FRAME_I(119-(8*i) DOWNTO 116-(8*i));
		RX_FRAME_O(59-(4*i) DOWNTO 56-(4*i))	   <= RX_FRAME_I(115-(8*i) DOWNTO 112-(8*i));
	END GENERATE;

END a;