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
--  ENTITY				: 	ERROR_DETECTION_MODULE.VHD		
--  VERSION				:	0.2						
--  VENDOR SPECIFIC?	:	NO
--  FPGA SPECIFIC? 		:   NO
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE		:	10/10/2008
--  LAST UPDATE     	:   07/07/2009  
--  AUTHORs				:	Frederic MARIN (CPPM)
--  LANGAGE 			:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION			:	Indicates two kind of error:
--						* Error_Seen_When_DV indicates that an error has been seen in the data while the data_valid	indicates a valid data.	--
--						* Error_Seen indicates an a error in the data but doesn't look at the data_valid. So it needs to be
--							independently reset after the reception is well locked on the header and gives a valid data
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--                      DATE            	VERSION           	AUTHOR		DESCRIPTION
--                      10/10/2008   		0.1                	MARIN   	first .vhd entity definition           
--						07/07/2009			0.2					BARON		cosmetic modifications
---------------------------------------------------------------------------------------------------------------------------------

-- 13/06/2013
-- Mod by MBM
-- add an initial delay to avoid having to reset manually the first time

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;	-- necessary to understand addition
                	                -- of std_logic_vectors to integers
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ENTITY Error_Detection_Module IS
	PORT(
		Clock					: IN	STD_LOGIC;
		Reset_Error_Seen_When_DV: IN	STD_LOGIC;
		Reset_Error_Seen		: IN	STD_LOGIC;
		Received_Data			: IN	STD_LOGIC_VECTOR(83 DOWNTO 0);
		DV						: IN	STD_LOGIC;
		
		Error_Seen_When_DV		: OUT	STD_LOGIC;
		Error_Seen				: OUT	STD_LOGIC
    );	

END Error_Detection_Module;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE rtl OF Error_Detection_Module IS

SIGNAL Seen_Low					: BOOLEAN;
SIGNAL In_Test					: BOOLEAN;
SIGNAL Previous_Word			: STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL Previous_Word_bis		: STD_LOGIC_VECTOR(20 DOWNTO 0);
       
	BEGIN
	
	PROCESS(Reset_Error_Seen_When_DV, Reset_Error_Seen, Clock)
		BEGIN
		
		IF Reset_Error_Seen_When_DV = '1' THEN
			Error_Seen_When_DV 		<= '0';
			Seen_Low		<= FALSE;
			In_Test			<= FALSE;
			Previous_Word	<= (OTHERS => '0');
		ELSIF RISING_EDGE(Clock) THEN
			IF Seen_Low = FALSE AND DV = '0' THEN
				Seen_Low	<= TRUE;
				Error_Seen_When_DV	<= '0';
				In_Test		<= FALSE;
			END IF;
			IF Seen_Low = TRUE AND DV = '1' THEN
				Seen_Low		<= FALSE;
				Previous_Word	<= Received_Data(83 DOWNTO 63);
				In_Test			<= TRUE;
			END IF;
			IF In_Test = TRUE THEN
				Previous_Word	<= Received_Data(83 DOWNTO 63);
				IF Previous_Word + 1 /= Received_Data(83 DOWNTO 63) 
					OR Received_Data(83 DOWNTO 63) /= Received_Data(62 DOWNTO 42)
					OR Received_Data(83 DOWNTO 63) /= Received_Data(41 DOWNTO 21)
					OR Received_Data(83 DOWNTO 63) /= Received_Data(20 DOWNTO 0) THEN
					
					Error_Seen_When_DV <= '1';
				END IF;				
			END IF;
		END IF;
	END PROCESS;

	PROCESS (Reset_Error_Seen, Clock)
		BEGIN
		
		IF RISING_EDGE(Clock) THEN
			IF Reset_Error_Seen = '1' THEN
				Error_Seen			<= '0';
				Previous_Word_bis	<= Received_Data(83 DOWNTO 63);
			ELSE
				Previous_Word_bis	<= Received_Data(83 DOWNTO 63);
				IF Previous_Word_bis + 1 /= Received_Data(83 DOWNTO 63) 
					OR Received_Data(83 DOWNTO 63) /= Received_Data(62 DOWNTO 42)
					OR Received_Data(83 DOWNTO 63) /= Received_Data(41 DOWNTO 21)
					OR Received_Data(83 DOWNTO 63) /= Received_Data(20 DOWNTO 0) THEN
				
					Error_Seen <= '1';
				END IF;	
			END IF;
		END IF;
	END PROCESS;

END rtl;