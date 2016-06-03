LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE work.Constant_Declaration.all;


ENTITY Scrambling_Constants IS
	PORT(
		Reset_Pattern1			: OUT	STD_LOGIC_VECTOR(20 DOWNTO 0);
		Reset_Pattern2			: OUT	STD_LOGIC_VECTOR(20 DOWNTO 0);
		Reset_Pattern3			: OUT	STD_LOGIC_VECTOR(20 DOWNTO 0);
		Reset_Pattern4			: OUT	STD_LOGIC_VECTOR(20 DOWNTO 0);
		Header					: OUT	STD_LOGIC_VECTOR(3 DOWNTO 0)
    );	

END Scrambling_Constants;


ARCHITECTURE a OF Scrambling_Constants IS
       
	BEGIN

	Reset_Pattern1	<= Scrambler_Reset_Pattern1;
    Reset_Pattern2	<= Scrambler_Reset_Pattern2;
    Reset_Pattern3	<= Scrambler_Reset_Pattern3;
    Reset_Pattern4	<= Scrambler_Reset_Pattern4;
	Header			<= Data_Header_Pattern;
    
END a;