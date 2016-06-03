--------------------------------------------------
--					Descrambler					--
--												--
-- Copy of the verilog version of the 			--
-- descrambler									--
--												--
-- Author: Frédéric Marin						--
-- Date: October 6th, 2008						--
--------------------------------------------------



LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


							
ENTITY Descrambler IS
	PORT(
			din			: IN	STD_LOGIC_VECTOR(21 DOWNTO 1);
			resetb		: IN	STD_LOGIC;
			clk			: IN	STD_LOGIC;
			dout		: OUT	STD_LOGIC_VECTOR(21 DOWNTO 1)
		);
END Descrambler;

ARCHITECTURE a OF Descrambler IS

SIGNAL FREG	: STD_LOGIC_VECTOR(20 DOWNTO 0);
SIGNAL DREG	: STD_LOGIC_VECTOR(21 DOWNTO 1);

	BEGIN
	
	PROCESS(clk)
		BEGIN
		
		IF RISING_EDGE(clk) THEN
			DREG <= din;
			IF resetb = '1' THEN
				FREG	<= DREG;
			ELSE
				FREG	<= (OTHERS => '0');
			END IF;
		END IF;
	END PROCESS;
	
	dout(1) <= DREG(1)  XOR FREG(0) XOR FREG(2);
	dout(2) <= DREG(2)  XOR FREG(1) XOR FREG(3);
	dout(3) <= DREG(3)  XOR FREG(2) XOR FREG(4);
	dout(4) <= DREG(4)  XOR FREG(3) XOR FREG(5);
	dout(5) <= DREG(5)  XOR FREG(4) XOR FREG(6);
	dout(6) <= DREG(6)  XOR FREG(5) XOR FREG(7);
	dout(7) <= DREG(7)  XOR FREG(6) XOR FREG(8);
	dout(8) <= DREG(8)  XOR FREG(7) XOR FREG(9);
	dout(9) <= DREG(9)  XOR FREG(8) XOR FREG(10);
	dout(10) <= DREG(10)  XOR FREG(9) XOR FREG(11);
	dout(11) <= DREG(11)  XOR FREG(10) XOR FREG(12);
	dout(12) <= DREG(12)  XOR FREG(11) XOR FREG(13);
	dout(13) <= DREG(13)  XOR FREG(12) XOR FREG(14);
	dout(14) <= DREG(14)  XOR FREG(13) XOR FREG(15);
	dout(15) <= DREG(15)  XOR FREG(14) XOR FREG(16);
	dout(16) <= DREG(16)  XOR FREG(15) XOR FREG(17);
	dout(17) <= DREG(17)  XOR FREG(16) XOR FREG(18);
	dout(18) <= DREG(18)  XOR FREG(17) XOR FREG(19);
	dout(19) <= DREG(19)  XOR FREG(18) XOR FREG(20);
	dout(20) <= DREG(20)  XOR FREG(19) XOR DREG(1);
	dout(21) <= DREG(21)  XOR FREG(20) XOR DREG(2);

END a;