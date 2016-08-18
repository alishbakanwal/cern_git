------------------------------------------------------
--				Agnostic_21bits_Counter					--
-- 													--
-- continuously increments a 21 bits output vector	--
-- no reset											--													--
-- Author: Sophie Baron								--
-- Date: September 25th, 2008						--
------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


ENTITY Agnostic_21bits_Counter IS
	PORT(
		Clock		: IN	STD_LOGIC;
		q			: OUT	STD_LOGIC_VECTOR(20 DOWNTO 0)
    );	
END Agnostic_21bits_Counter;


ARCHITECTURE a OF Agnostic_21bits_Counter IS
       
SIGNAL Counter_Temp : STD_LOGIC_VECTOR(20 DOWNTO 0);
       
	BEGIN

	q <= Counter_Temp;
	
	PROCESS (Clock)
	
		BEGIN
		
		IF RISING_EDGE(Clock) THEN
				IF Counter_Temp = "111111111111111111111" THEN 
					Counter_Temp <= (others => '0');
				ELSE
					Counter_Temp <= Counter_Temp + 1;
				END IF;
		END IF;
	END PROCESS;

END a;