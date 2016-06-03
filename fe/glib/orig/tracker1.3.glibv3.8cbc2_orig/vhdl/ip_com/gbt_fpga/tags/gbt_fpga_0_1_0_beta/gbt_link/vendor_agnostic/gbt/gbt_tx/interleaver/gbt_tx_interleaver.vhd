---------------------------------------------------------------------------------------------------------------------------------
--  ENTITY				: 	INTERLEAVING.VHD		
--  VERSION				:	0.2						
--  VENDOR SPECIFIC?	:	NO
--  FPGA SPECIFIC? 		:   NO
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE		:	24/09/2008
--  LAST UPDATE     	:   06/04/2009  
--  AUTHORs				:	Frederic MARIN (CPPM), Sophie BARON (CERN)
--  LANGAGE 			:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION			:	Interleaves two buses of 60 bits. TX_FRAME_O is then on 120 bits.
--						It's a 4-bits (=word) interleaving (nibble-based). No clock cycle.
--					
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--                      DATE            	VERSION           	AUTHOR		DESCRIPTION
--                      24/09/2008   		0.1                	MARIN   	first vhd entity definition (bit based)          
--						06/04/2009			0.2					MARIN		modif to make it nibble based
---------
------------------------------------------------------------------------------------------------------------------------


-- MBM (04/07/2013)
-- port names

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY gbt_tx_interleaver IS
	PORT(
		TX_FRAME_I	: IN	STD_LOGIC_VECTOR(119 DOWNTO 0);
		TX_FRAME_O	: OUT	STD_LOGIC_VECTOR(119 DOWNTO 0)
    );	

END gbt_tx_interleaver;


ARCHITECTURE a OF gbt_tx_interleaver IS

   
BEGIN


gbtFrameInterleaving_gen:
	FOR i IN 0 TO 14 GENERATE
		TX_FRAME_O(119-(8*i) DOWNTO 116-(8*i))	<= TX_FRAME_I(119-(4*i) DOWNTO 116-(4*i));
		TX_FRAME_O(115-(8*i) DOWNTO 112-(8*i))	<= TX_FRAME_I(59-(4*i) DOWNTO 56-(4*i));
	END GENERATE;

END a;