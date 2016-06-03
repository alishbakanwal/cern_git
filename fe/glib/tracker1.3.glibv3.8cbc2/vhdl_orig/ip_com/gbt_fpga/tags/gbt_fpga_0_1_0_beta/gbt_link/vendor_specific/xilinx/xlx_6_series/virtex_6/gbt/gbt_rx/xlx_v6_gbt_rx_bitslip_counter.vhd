

-- created by
-- MBM
--new name (04/07/2013)
-- port names


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity gbt_rx_bitslip_counter is
port 
(	
	RX_WORDCLK_I									: in  std_logic;		
	RX_RESET_I										: in  std_logic;
	RX_BITSLIP_CMD_I	 							: in  std_logic; 
	RX_BITSLIP_NBR_O	 							: out std_logic_vector(4 downto 0) 		
);
end gbt_rx_bitslip_counter;

architecture behavioral of gbt_rx_bitslip_counter is
begin

	process(RX_RESET_I, RX_WORDCLK_I)			
		variable counter_modulo_20 : std_logic_vector(4 downto 0);
	begin
		if RX_RESET_I = '1' then
			counter_modulo_20			:= "00000"; 
			RX_BITSLIP_NBR_O						<= "00000"; 
		elsif rising_edge(RX_WORDCLK_I) then					
			if RX_BITSLIP_CMD_I = '1' then			
				if counter_modulo_20 = 19 then
					counter_modulo_20	:= "00000";
				else
					counter_modulo_20	:= counter_modulo_20 + 1;						
				end if;
			end if;	
			RX_BITSLIP_NBR_O	<= counter_modulo_20;
		end if;
	end process;	
end behavioral;