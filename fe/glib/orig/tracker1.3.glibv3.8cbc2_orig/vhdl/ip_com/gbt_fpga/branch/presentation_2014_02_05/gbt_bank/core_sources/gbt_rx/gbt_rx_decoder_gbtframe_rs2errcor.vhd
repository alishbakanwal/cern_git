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
--				RSTwoErrorsCorrect					--
--													--
-- Manually translated from  verilog				--							--
--	This logic block in the RS decoder performs the	--
-- correction of two errors	based on the computed	--
-- syndromes										--
-- for Reed Solomon codec for GBT					--
-- A. Marchioro	2006								--
--													--
-- Author: Frédéric Marin							--
-- Date: October 3rd, 2008							--
------------------------------------------------------

-- MBM - New module name (18/11/2013)
--     - gf16mult and gf16add are functions instead of modules
-- no component declarations

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

use work.gbt_bank_package.all;

entity gbt_rx_decoder_gbtframe_rs2errcor is
	port(
		S1			   : in	std_logic_vector(3 downto 0);
		S2			   : in	std_logic_vector(3 downto 0);
		XX0			: in	std_logic_vector(3 downto 0);
		XX1			: in	std_logic_vector(3 downto 0);
		RECCOEFFS	: in	std_logic_vector(59 downto 0);
		DETISZERO	: in	std_logic;
		CORCOEFFS	: out	std_logic_vector(59 downto 0)
	);
end gbt_rx_decoder_gbtframe_rs2errcor;

architecture structural of gbt_rx_decoder_gbtframe_rs2errcor is


TYPE ARRAY_6_60 IS ARRAY(1 TO 6) OF STD_LOGIC_VECTOR(59 DOWNTO 0);
TYPE ARRAY_11_4 IS ARRAY(1 TO 11) OF STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL temp	: ARRAY_6_60;
SIGNAL net	: ARRAY_11_4;
SIGNAL net20,net21,Y1,Y2,Y1B: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL ermag1,ermag2,ermag3	: STD_LOGIC_VECTOR(59 DOWNTO 0);

	
	BEGIN
	
	net(1) <= gf16mult(s1,xx0);
				
	net(3) <= gf16mult(xx1,xx1);
	
	net(4) <= gf16mult(xx0,xx1);	
			
	Y2 <= gf16mult(net(2),net(6));	
			
	net(8) <= gf16mult(Y2,xx1);	
			
	Y1 <= gf16mult(net(9),net(10));
	
	gf16inverse1: entity work.gbt_rx_decoder_gbtframe_gf16invr
	PORT MAP(
		input	=> xx0,
		output	=> net(10)
			);
			
	gf16inverse2: entity work.gbt_rx_decoder_gbtframe_gf16invr
	PORT MAP(
		input	=> net(5),
		output	=> net(6)
			);
			
	net(5) <= gf16add(net(3),net(4));
	
	net(9) <= gf16add(net(8),s1);	
			
	net(2) <= gf16add(s2,net(1));	
			
	Y1B <= gf16mult(s1,net(10));	
			
	gf16log1: entity work.gbt_rx_decoder_gbtframe_gf16loga
	PORT MAP(
		input	=> xx0,
		output	=> net20
			);
			
	gf16log2: entity work.gbt_rx_decoder_gbtframe_gf16loga
	PORT MAP(
		input	=> xx1,
		output	=> net21
			);
			
	ermag1	<= X"00000000000000" & Y1;
	
	gf16shifter: entity work.gbt_rx_decoder_gbtframe_gf16shift
	PORT MAP(
		input	=> ermag1,
		Shift	=> net20,
		output	=> temp(1)
			);
	
	ermag2	<= X"00000000000000" & Y2;
	
	gf16shifter2: entity work.gbt_rx_decoder_gbtframe_gf16shift
	PORT MAP(
		input	=> ermag2,
		Shift	=> net21,
		output	=> temp(2)
			);
			
	ermag3	<= X"00000000000000" & Y1B;
	
	gf16shifter3 : entity work.gbt_rx_decoder_gbtframe_gf16shift
	PORT MAP(
		input	=> ermag3,
		Shift	=> net20,
		output	=> temp(4)
			);
			
	adder60_1 : entity work.gbt_rx_decoder_gbtframe_adder60
	PORT MAP(
		input1	=> temp(1),
		input2	=> reccoeffs,
		output	=> temp(3)
			);
			
	adder60_2: entity work.gbt_rx_decoder_gbtframe_adder60
	PORT MAP(
		input1	=> temp(3),
		input2	=> temp(2),
		output	=> temp(6)
			);
			
	adder60_3: entity work.gbt_rx_decoder_gbtframe_adder60
	PORT MAP(
		input1	=> temp(4),
		input2	=> reccoeffs,
		output	=> temp(5)
			);
			
	corcoeffs	<= temp(6) WHEN detiszero = '0' ELSE temp(5);
			
END structural;