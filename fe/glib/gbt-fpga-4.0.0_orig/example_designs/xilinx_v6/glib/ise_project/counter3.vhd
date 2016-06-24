
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity counter3 is
   port( 
		CLK                        : in std_logic;
		COUNT_O                    : out std_logic_vector(1 downto 0)
	);
	
end counter3;	
	 
 
 
architecture Behavioral of counter3 is
	signal count                  : std_logic_vector (1 downto 0);
	
	begin process(CLK)
		begin
			if(rising_edge(CLK)) then
				count                <= count + '1';
				
				if count = "11" then
					count             <= "00";
				end if;
			end if;		
	end process;
	
	COUNT_O                       <= count;		
	
end Behavioral;
