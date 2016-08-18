------------------------------------------------------
--                                      Write_RX_DP_RAM                                 --
--                                                                                                      --
-- Generates write address for the RX dual port ram --
-- It is incremented every clock cycle except when      --
-- a right shift of 40 bits is required                         --
--                                                                                                      --
-- Author: Frédéric Marin                                                       --
-- Date: September 25th, 2008                                           --
------------------------------------------------------




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity rx_gearbox_wr_addr is
  port(
    Reset         : in std_logic;
    Clock         : in std_logic;
    Shift_20b_Cmd : in std_logic;

    Write_Address : out std_logic_vector(5 downto 0)
    );  

end rx_gearbox_wr_addr;


architecture a of rx_gearbox_wr_addr is

  signal Write_Address_i : integer range 0 to 63;
  
begin

  Write_Address <= conv_std_logic_vector(Write_Address_i,6);

  process (Reset, Clock)

  begin
    
    if Reset = '1' then
      Write_Address_i <= 0; 
    elsif RISING_EDGE(Clock) then
      if Shift_20b_Cmd = '0' then
		case Write_Address_i is
			when 5  => 		Write_Address_i <=  8;	 		
			when 13 => 		Write_Address_i <= 16;	
			when 21 => 		Write_Address_i <= 24;
			when 29 => 	   	Write_Address_i <= 32;
			when 37 => 	   	Write_Address_i <= 40;
			when 45 => 	   	Write_Address_i <= 48;
			when 53 => 	   	Write_Address_i <= 56;
			when 61 => 	   	Write_Address_i <=  0;
			when others => 	Write_Address_i <= Write_Address_i+1;
		end case;
			else                              -- Shift_20b_Cmd = '1'
        null;  -- We don't increment the write address to shift right of 40b
      end if;
    end if;
  end process;

-- for 40b: addr -> 0,1,2 - 4,5,6 - 8,9,10 - 12,13,14 ... 28,29,30
-- for 20b: addr -> 0,1,2,3,4,5 - 8,9,10,11,12,13 - 16,17,18,19,20,21 - 24,25,26,27,28,29 ... 56,57,58,59,60,61


end a;
