------------------------------------------------------
--                              Modulo_40_Counter                                       --
--                                                                                                      --
-- Counts modulo 40 and sends a command when counter--
-- value equal 0 modulo 40                                                      --
-- Counting enabled through "Bit_Slip_Cmd" input.       --
--                                                                                                      --
-- Author: Frédéric Marin                                                       --
-- Date: September 25th, 2008                                           --
------------------------------------------------------




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity Modulo_20_Counter is
  port(
    Reset        : in std_logic;
    Clock        : in std_logic;
    Bit_Slip_Cmd : in std_logic;

    Counter_Output : out std_logic_vector(4 downto 0);
    Shift_20b_Cmd  : out std_logic
    );  

end Modulo_20_Counter;


architecture a of Modulo_20_Counter is
  
  signal Counter_Temp : std_logic_vector(4 downto 0);
  
begin

  Counter_Output <= Counter_Temp;

  process (Reset, Clock)

  begin
    
    if Reset = '1' then
      Counter_Temp  <= (others => '0');
      Shift_20b_Cmd <= '0';
    elsif RISING_EDGE(Clock) then
      if Bit_Slip_Cmd = '1' then
        if Counter_Temp = "10011" then  -- 19
          Counter_Temp  <= "00000";
          Shift_20b_Cmd <= '1';
        else
          Counter_Temp  <= Counter_Temp + 1;
          Shift_20b_Cmd <= '0';
        end if;
      else
        Shift_20b_Cmd <= '0';
      end if;
    end if;
  end process;

end a;
