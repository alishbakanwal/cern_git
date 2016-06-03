------------------------------------------------------
--                              Modulo_40_Counter                                       --
--                                                                                                      --
-- Counts modulo 40 and sends a command when counter--
-- value equal 0 modulo 40                                                      --
-- Counting enabled through "RX_BITSLIP_CMD_I" input.       --
--                                                                                                      --
-- Author: Frédéric Marin                                                       --
-- Date: September 25th, 2008                                           --
------------------------------------------------------


-- MBM (26/11/2013) - new name
-- mod to be used with 20 and 40 bit interface

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;

entity gbt_rx_framealigner_counter is
  port( 
  
    RX_RESET_I                   : in  std_logic;
    RX_WORDCLK_I                 : in  std_logic;
    RX_BITSLIP_CMD_I             : in  std_logic;
    RX_BITSLIP_OVERFLOW_CMD_O    : out std_logic;
    RX_BITSLIP_NBR_O             : out std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0)
  
  );  

end gbt_rx_framealigner_counter;

architecture behavioral of gbt_rx_framealigner_counter is 
  
begin

   process (RX_RESET_I, RX_WORDCLK_I)
      variable count                            : unsigned(GBTRX_BITSLIP_NBR_MSB downto 0);
   begin    
      if RX_RESET_I = '1' then
         count                                  := (others => '0');
         RX_BITSLIP_OVERFLOW_CMD_O              <= '0';
         RX_BITSLIP_NBR_O                       <= (others => '0');
      elsif rising_edge(RX_WORDCLK_I) then
         RX_BITSLIP_OVERFLOW_CMD_O              <= '0';
         if RX_BITSLIP_CMD_I = '1' then
           if count = GBTRX_BITSLIP_NBR_MAX then
             count                              := (others => '0');
             RX_BITSLIP_OVERFLOW_CMD_O          <= '1';
           else
             count                              := count + 1;
           end if;
         end if;
         RX_BITSLIP_NBR_O                       <= std_logic_vector(count);
      end if;
   end process;
  
end behavioral;
