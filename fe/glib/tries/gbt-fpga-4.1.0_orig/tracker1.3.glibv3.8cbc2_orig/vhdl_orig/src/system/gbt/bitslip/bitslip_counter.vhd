library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity bitslip_counter is
port 
(	
	rxwordclk_i									: in  std_logic;		
	reset_i										: in  std_logic;
	bitslip_i	 								: in  std_logic; 
	steps_o	 									: out std_logic_vector(4 downto 0) 		
);
end bitslip_counter;

architecture behavioral of bitslip_counter is
begin

	process(reset_i, rxwordclk_i)			
		variable counter_modulo_20 : std_logic_vector(4 downto 0);
	begin
		if reset_i = '1' then
			counter_modulo_20			:= "00000"; 
			steps_o						<= "00000"; 
		elsif rising_edge(rxwordclk_i) then					
			if bitslip_i = '1' then			
				if counter_modulo_20 = 19 then
					counter_modulo_20	:= "00000";
				else
					counter_modulo_20	:= counter_modulo_20 + 1;						
				end if;
			end if;	
			steps_o	<= counter_modulo_20;
		end if;
	end process;	
end behavioral;