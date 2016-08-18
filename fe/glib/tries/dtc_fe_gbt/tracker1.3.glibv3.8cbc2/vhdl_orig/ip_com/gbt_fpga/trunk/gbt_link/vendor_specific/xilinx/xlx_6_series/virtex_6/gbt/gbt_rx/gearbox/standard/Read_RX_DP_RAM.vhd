------------------------------------------------------
--                                      Read_RX_DP_RAM                                  --
--                                                                                                      --
-- Detects the write address value where the first      --
-- valid data were written and then start to            --
-- generate read address                                                        --
--                                                                                                      --
-- Author: Frdric Marin                                                       --
-- Date: October 1st, 2008                                                      --
-- Modified on April 8th, 2009                                          --
------------------------------------------------------




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  -- necessary to understand addition of std_logic_vectors to integers


entity Read_RX_DP_RAM is
port
(
	Reset            	: in std_logic;
	word_clk_i         	: in std_logic;
	frame_clk_i      	: in std_logic;
	Locked_On_Header 	: in std_logic;
	Read_Address 		: out std_logic_vector(2 downto 0);
	DV           		: out std_logic
);  

end Read_RX_DP_RAM;


architecture a of Read_RX_DP_RAM is

  signal Ready_For_Reading : std_logic;
  signal Counter           : integer range 0 to 11;

  signal Read_Address_i : std_logic_vector(2 downto 0);
  signal s_DV           : std_logic_vector(2 downto 0);
  signal Flag           : std_logic;
  
begin

  Read_Address <= Read_Address_i;
  -- Process catching the moment when the first valid data were written
  process(Reset, word_clk_i)
  begin
    
    if Reset = '1' then
      Ready_For_Reading <= '0';
      Counter           <= 0;
    elsif RISING_EDGE(word_clk_i) then
      if Locked_On_Header = '1' then
        if Counter <= 10 then            -- modified from 10 to 3
          Counter <= Counter + 1;
        else
          Ready_For_Reading <= '1';
        end if;
      else
        Ready_For_Reading <= '0';
        Counter           <= 0;
      end if;
    end if;
  end process;

  -- Process generating the read address
  process (Reset, frame_clk_i)

  begin
    
    if Reset = '1' then
      Read_Address_i <= (others => '0');
      DV             <= '0';
      s_DV           <= "000";
      Flag           <= '0';
    elsif RISING_EDGE(frame_clk_i) then
      -- To compensate the 2 registers of the DP RAM
      s_DV(1) <= s_DV(0);
      s_DV(2) <= s_DV(1);
      DV      <= s_DV(2);

      if Ready_For_Reading = '0' then
        Flag <= '1';
      end if;

      if Ready_For_Reading = '1' and Flag = '1' then
        s_DV(0)        <= '1';
        Read_Address_i <= (others => '0');
        Flag           <= '0';
      elsif Ready_For_Reading = '1' then
        s_DV(0)        <= '1';
        Read_Address_i <= Read_Address_i +1;
      else
        s_DV(0)        <= '0';
        Read_Address_i <= Read_Address_i +1;
      end if;
    end if;
  end process;

end a;
