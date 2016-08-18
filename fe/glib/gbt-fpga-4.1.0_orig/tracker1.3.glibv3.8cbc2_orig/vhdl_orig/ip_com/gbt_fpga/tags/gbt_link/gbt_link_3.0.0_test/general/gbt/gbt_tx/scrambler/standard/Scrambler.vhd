--------------------------------------------------
--					Scrambler					--
--												--
-- Copy of the verilog version of the scrambler	--
--												--
-- Author: Frédéric Marin						--
-- Date: October 6th, 2008						--
--------------------------------------------------



LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


							
ENTITY Scrambler IS
	PORT(
			din			: IN	STD_LOGIC_VECTOR(21 DOWNTO 1);
			resetb		: IN	STD_LOGIC;
			clk			: IN	STD_LOGIC;
			resetpattern: IN	STD_LOGIC_VECTOR(21 DOWNTO 1);
			dout		: OUT	STD_LOGIC_VECTOR(21 DOWNTO 1)
		);
END Scrambler;

ARCHITECTURE a OF Scrambler IS

SIGNAL FREG	: STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL DREG	: STD_LOGIC_VECTOR(21 DOWNTO 1);
SIGNAL dout_s: STD_LOGIC_VECTOR(21 DOWNTO 1);

	BEGIN

	dout	<= dout_s;
	
	PROCESS(clk)
		BEGIN
		
		IF RISING_EDGE(clk) THEN
			DREG <= din;
			IF resetb = '1' THEN
				FREG	<= dout_s;
			ELSE
				FREG	<= resetpattern;
			END IF;
		END IF;
	END PROCESS;
	
	
	dout_s(1) <= DREG(1)  XOR FREG(0) XOR FREG(2);
	dout_s(2) <= DREG(2)  XOR FREG(1) XOR FREG(3);
	dout_s(3) <= DREG(3)  XOR FREG(2) XOR FREG(4);
	dout_s(4) <= DREG(4)  XOR FREG(3) XOR FREG(5);
	dout_s(5) <= DREG(5)  XOR FREG(4) XOR FREG(6);
	dout_s(6) <= DREG(6)  XOR FREG(5) XOR FREG(7);
	dout_s(7) <= DREG(7)  XOR FREG(6) XOR FREG(8);
	dout_s(8) <= DREG(8)  XOR FREG(7) XOR FREG(9);
	dout_s(9) <= DREG(9)  XOR FREG(8) XOR FREG(10);
	dout_s(10) <= DREG(10)  XOR FREG(9) XOR FREG(11);
	dout_s(11) <= DREG(11)  XOR FREG(10) XOR FREG(12);
	dout_s(12) <= DREG(12)  XOR FREG(11) XOR FREG(13);
	dout_s(13) <= DREG(13)  XOR FREG(12) XOR FREG(14);
	dout_s(14) <= DREG(14)  XOR FREG(13) XOR FREG(15);
	dout_s(15) <= DREG(15)  XOR FREG(14) XOR FREG(16);
	dout_s(16) <= DREG(16)  XOR FREG(15) XOR FREG(17);
	dout_s(17) <= DREG(17)  XOR FREG(16) XOR FREG(18);
	dout_s(18) <= DREG(18)  XOR FREG(17) XOR FREG(19);
	dout_s(19) <= DREG(19)  XOR FREG(18) XOR FREG(20);
	dout_s(20) <= DREG(20)  XOR FREG(19) XOR DREG(1) XOR FREG(0) XOR FREG(2);
	dout_s(21) <= DREG(21)  XOR FREG(20) XOR DREG(2) XOR FREG(1) XOR FREG(3);
	
	
	

END a;