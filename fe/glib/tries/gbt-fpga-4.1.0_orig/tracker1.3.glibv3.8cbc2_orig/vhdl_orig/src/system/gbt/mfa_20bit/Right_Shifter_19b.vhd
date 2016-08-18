------------------------------------------------------
--					Right_Shifter_39b				--
-- 													--
-- Shifts data from the left to right				--
--													--
-- Author: Frédéric Marin							--
-- Date: September 25th, 2008						--
------------------------------------------------------




LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
                	                


ENTITY Right_Shifter_19b IS
	PORT(
		Reset					: IN	STD_LOGIC;
		Clock					: IN	STD_LOGIC;
		Input_Word				: IN	STD_LOGIC_VECTOR(19 DOWNTO 0);
		GX_Alignment_Done_In	: IN	STD_LOGIC;
		Shift_Cmd				: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		Output_Word				: OUT	STD_LOGIC_VECTOR(19 DOWNTO 0);
		GX_Alignment_Done_Out	: OUT	STD_LOGIC
    );	

END Right_Shifter_19b;


ARCHITECTURE a OF Right_Shifter_19b IS

SIGNAL Previous_Word : STD_LOGIC_VECTOR(19 DOWNTO 0);
SIGNAL GX_Alignment_Done_temp : STD_LOGIC;

	BEGIN
	
	PROCESS (Reset, Clock)
	
		BEGIN
		
		IF 	Reset = '1' THEN
			Output_Word				<= (OTHERS => '0');
			Previous_Word			<= (OTHERS => '0');
			GX_Alignment_Done_temp	<= '0';
			GX_Alignment_Done_Out	<= '0';
		ELSIF RISING_EDGE(Clock) THEN
			Previous_Word				<= Input_Word;
			GX_Alignment_Done_temp		<= GX_Alignment_Done_In;
			GX_Alignment_Done_Out		<= GX_Alignment_Done_temp;
			CASE Shift_Cmd IS
				WHEN "00000" => -- 0
					Output_Word <= Previous_Word;
				WHEN "00001" => -- 1
					Output_Word <= Input_Word(0 DOWNTO 0) & Previous_Word(19 DOWNTO 1);
				WHEN "00010" => -- 2
					Output_Word <= Input_Word(1 DOWNTO 0) & Previous_Word(19 DOWNTO 2);
				WHEN "00011" => -- 3
					Output_Word <= Input_Word(2 DOWNTO 0) & Previous_Word(19 DOWNTO 3);
				WHEN "00100" => -- 4
					Output_Word <= Input_Word(3 DOWNTO 0) & Previous_Word(19 DOWNTO 4);
				WHEN "00101" => -- 5
					Output_Word <= Input_Word(4 DOWNTO 0) & Previous_Word(19 DOWNTO 5);
				WHEN "00110" => -- 6
					Output_Word <= Input_Word(5 DOWNTO 0) & Previous_Word(19 DOWNTO 6);
				WHEN "00111" => -- 7
					Output_Word <= Input_Word(6 DOWNTO 0) & Previous_Word(19 DOWNTO 7);
				WHEN "01000" => -- 8
					Output_Word <= Input_Word(7 DOWNTO 0) & Previous_Word(19 DOWNTO 8);
				WHEN "01001" => -- 9
					Output_Word <= Input_Word(8 DOWNTO 0) & Previous_Word(19 DOWNTO 9);
				WHEN "01010" => -- 10
					Output_Word <= Input_Word(9 DOWNTO 0) & Previous_Word(19 DOWNTO 10);
				WHEN "01011" => -- 11
					Output_Word <= Input_Word(10 DOWNTO 0) & Previous_Word(19 DOWNTO 11);
				WHEN "01100" => -- 12
					Output_Word <= Input_Word(11 DOWNTO 0) & Previous_Word(19 DOWNTO 12);
				WHEN "01101" => -- 13
					Output_Word <= Input_Word(12 DOWNTO 0) & Previous_Word(19 DOWNTO 13);
				WHEN "01110" => -- 14
					Output_Word <= Input_Word(13 DOWNTO 0) & Previous_Word(19 DOWNTO 14);
				WHEN "01111" => -- 15
					Output_Word <= Input_Word(14 DOWNTO 0) & Previous_Word(19 DOWNTO 15);
				WHEN "10000" => -- 16
					Output_Word <= Input_Word(15 DOWNTO 0) & Previous_Word(19 DOWNTO 16);
				WHEN "10001" => -- 17
					Output_Word <= Input_Word(16 DOWNTO 0) & Previous_Word(19 DOWNTO 17);
				WHEN "10010" => -- 18
					Output_Word <= Input_Word(17 DOWNTO 0) & Previous_Word(19 DOWNTO 18);
				WHEN others  => -- 19
					Output_Word <= Input_Word(18 DOWNTO 0) & Previous_Word(19 DOWNTO 19);
				
			END CASE;
		END IF;
	END PROCESS;

END a;