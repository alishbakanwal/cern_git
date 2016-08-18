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
--  ENTITY				: 	Constant_Declaration.VHD		
--  VERSION				:	0.2						
--  VENDOR SPECIFIC?	:	NO
--  FPGA SPECIFIC? 		:   NO
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE		:	01/10/2008
--  LAST UPDATE     	:   01/09/2009  
--  AUTHORs				:	Frederic Marin (CPPM), Sophie BARON (CERN)
--  LANGAGE 			:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION			:	top of a generic file in charge of the test of code and ressources optimization of the GBT decoding process
--					
--					
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--                      DATE            	VERSION           	AUTHOR		DESCRIPTION
--                      01/10/2008   		0.1                	MARIN   	first .vhd entity definition           
--						01/09/2009			0.2					BARON		added a x3 optimisation scheme
---------------------------------------------------------------------------------------------------------------------------------


-- PROGRAM		"Quartus II"
-- VERSION		"Version 9.0 Build 235 06/17/2009 Service Pack 2 SJ Full Version"
-- CREATED ON		"Tue Jul 07 12:28:11 2009"


LIBRARY ieee;
USE ieee.std_logic_1164.all; 

PACKAGE Constant_Declaration IS

CONSTANT Data_Header_Pattern			: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101"; -- Frame header for data
CONSTANT Data_Header_Pattern_Reversed	: STD_LOGIC_VECTOR(3 DOWNTO 0) :=	Data_Header_Pattern(0) &
																			Data_Header_Pattern(1) &
																			Data_Header_Pattern(2) &
																			Data_Header_Pattern(3); -- Frame header (for data) bit-reversed
CONSTANT Idle_Header_Pattern			: STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110"; -- Frame header for idle
CONSTANT Idle_Header_Pattern_Reversed	: STD_LOGIC_VECTOR(3 DOWNTO 0) :=	Idle_Header_Pattern(0) &
																			Idle_Header_Pattern(1) &
																			Idle_Header_Pattern(2) &
																			Idle_Header_Pattern(3); -- Frame header (for idle) bit-reversed


CONSTANT Desired_Consec_Correct_Headers	: INTEGER := 23; -- Number of correct headers found after which we declared to have found the correct boundary
CONSTANT Nb_Accepted_False_Header		: INTEGER := 4;  -- Number of false header we accept to find within "Nb_Checked_Header" checked headers without declaring to have lost the boundary
CONSTANT Nb_Checked_Header				: INTEGER := 64;

--************************************************************************************
--below are the constant and type definitions for the generic top file with ressource optimization / S baron.
constant NUMBER_OF_LINKS : integer := 1; --can be from 1 up to the max number of links authorized for the chip. optimization is implemented for 2 and 4
constant OPTIMIZE : integer := 0; -- 0= no optimization, 2=optimization for 2 links, 3= optimization for 3 links, 4=optimization for 4 links
constant TDM_MUX_DELAY : integer := 1; -- delay, from 1 to 4, to adjust the mux_ctrl to the frame


CONSTANT Scrambler_Reset_Pattern1		: STD_LOGIC_VECTOR(20 DOWNTO 0) := '1' & X"A23E0"; -- Value chosen arbitrarily except the last byte (=0 because it is OR-ed with i during multiple instanciations)
CONSTANT Scrambler_Reset_Pattern2		: STD_LOGIC_VECTOR(20 DOWNTO 0) := '0' & X"F4350"; -- Value chosen arbitrarily except the last byte (=0 because it is OR-ed with i during multiple instanciations)
CONSTANT Scrambler_Reset_Pattern3		: STD_LOGIC_VECTOR(20 DOWNTO 0) := '1' & X"3EDC0"; -- Value chosen arbitrarily except the last byte (=0 because it is OR-ed with i during multiple instanciations)
CONSTANT Scrambler_Reset_Pattern4		: STD_LOGIC_VECTOR(20 DOWNTO 0) := '0' & X"78E20"; -- Value chosen arbitrarily except the last byte (=0 because it is OR-ed with i during multiple instanciations)


TYPE	Word84_array is array(NUMBER_OF_LINKS-1 DOWNTO 0) of std_logic_vector(83 downto 0);
TYPE	Header4_array is array(NUMBER_OF_LINKS-1 DOWNTO 0) of std_logic_vector(3 downto 0);
TYPE	Frame120_array is array(NUMBER_OF_LINKS-1 DOWNTO 0) of std_logic_vector(119 downto 0);
TYPE	Word40_array is array(NUMBER_OF_LINKS-1 DOWNTO 0) of std_logic_vector(39 downto 0);
TYPE	Word5_array is array(NUMBER_OF_LINKS-1 DOWNTO 0) of std_logic_vector(4 downto 0);
TYPE	Word4_array is array(NUMBER_OF_LINKS-1 DOWNTO 0) of std_logic_vector(3 downto 0);
TYPE	Word3_array is array(NUMBER_OF_LINKS-1 DOWNTO 0) of std_logic_vector(2 downto 0);
TYPE	Word2_array is array(NUMBER_OF_LINKS-1 DOWNTO 0) of std_logic_vector(1 downto 0);
TYPE	Frame120_TDMx2 is array(1 DOWNTO 0) of std_logic_vector(119 downto 0);
TYPE	Frame120_TDMx3 is array(2 DOWNTO 0) of std_logic_vector(119 downto 0);
TYPE	Frame120_TDMx4 is array(3 DOWNTO 0) of std_logic_vector(119 downto 0);
TYPE	Frame84_TDDx2 is array(1 DOWNTO 0) of std_logic_vector(83 downto 0);
TYPE	Frame84_TDDx3 is array(2 DOWNTO 0) of std_logic_vector(83 downto 0);
TYPE	Frame84_TDDx4 is array(3 DOWNTO 0) of std_logic_vector(83 downto 0);
TYPE	array5x2 is array(4 downto 0) of std_logic_vector(1 downto 0);
TYPE	arrayofFrame120_TDMx2 is array(NUMBER_OF_LINKS-1 DOWNTO 0) of Frame120_TDMx2;
TYPE	arrayofFrame120_TDMx3 is array(NUMBER_OF_LINKS-1 DOWNTO 0) of Frame120_TDMx3;
TYPE	arrayofFrame120_TDMx4 is array(NUMBER_OF_LINKS-1 DOWNTO 0) of Frame120_TDMx4;
TYPE	arrayofFrame84_TDDx2 is array(NUMBER_OF_LINKS-1 DOWNTO 0) of Frame84_TDDx2;
TYPE	arrayofFrame84_TDDx3 is array(NUMBER_OF_LINKS-1 DOWNTO 0) of Frame84_TDDx3;
TYPE	arrayofFrame84_TDDx4 is array(NUMBER_OF_LINKS-1 DOWNTO 0) of Frame84_TDDx4;


SUBTYPE INTEGER2BITS is INTEGER range 0 to 3;
END Constant_Declaration;