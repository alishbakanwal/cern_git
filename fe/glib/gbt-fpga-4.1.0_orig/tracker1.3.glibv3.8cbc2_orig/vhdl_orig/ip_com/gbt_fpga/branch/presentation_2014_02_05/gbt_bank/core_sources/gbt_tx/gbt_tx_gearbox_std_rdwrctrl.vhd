------------------------------------------------------
--               RW_TX_DP_RAM               --
--                                        --
-- Manages the read and write counters for the dual --
-- port RAM used as multiplexor for the emssion path--
--                                       --
-- Author: Frédéric Marin                     --
-- Date: Septembre 25th, 2008                  --
------------------------------------------------------


-- MBM -new port names (09/08/2013)
-- modified to use 20 or 40 bit words
-- used case instead of logic arirmetic functions

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;

entity gbt_tx_gearbox_std_rdwrctrl is
   port (
      
      TX_RESET_I                                : in  std_logic;
      TX_FRAMECLK_I                             : in  std_logic;                        
      TX_WORDCLK_I                              : in  std_logic;
      WRITE_ADDRESS_O                           : out std_logic_vector(2 downto 0);
      READ_ADDRESS_O                            : out std_logic_vector(WORD_ADDR_MSB downto 0)
      
   );   
end gbt_tx_gearbox_std_rdwrctrl;

architecture behabioral of gbt_tx_gearbox_std_rdwrctrl is

   signal writeAddress                          : integer range 0 to  7;
   signal readAddress                           : integer range 0 to 63;
   
begin
   
   --===============--
   -- Write Address --
   --===============--   
   
   WRITE_ADDRESS_O                              <= std_logic_vector(to_unsigned(writeAddress,3));
   
   writeAddrCtrl: process(TX_RESET_I, TX_FRAMECLK_I)
   begin      
      if TX_RESET_I = '1' then
         writeAddress                           <= 6;
      elsif rising_edge(TX_FRAMECLK_I) then
         if writeAddress = 7 then
            writeAddress                        <= 0;
         else   
            writeAddress                        <= writeAddress + 1;
         end if;
      end if;
   end process;   
   
   --==============--
   -- Read Address --
   --==============--
   
   READ_ADDRESS_O                               <= std_logic_vector(to_unsigned(readAddress,(WORD_ADDR_MSB+1)));
   
   -- Comment: The TX DPRAM is 160-bits wide but only 120-bits are used (the words of the last 40bit are not read).         
   
   -- Word width (20 Bit):
   -----------------------
   
   readAddrCtrl20b_gen: if WORD_WIDTH = 20 generate
 
      readAddrCtrl20b: process(TX_RESET_I, TX_WORDCLK_I)
      begin    
         if TX_RESET_I = '1' then
            readAddress                         <= 0; 
         elsif rising_edge(TX_WORDCLK_I) then
            case readAddress is
               when  5                          => readAddress <=  8;          
               when 13                          => readAddress <= 16;   
               when 21                          => readAddress <= 24;
               when 29                          => readAddress <= 32;
               when 37                          => readAddress <= 40;
               when 45                          => readAddress <= 48;
               when 53                          => readAddress <= 56;
               when 61                          => readAddress <=  0;
               when others                      => readAddress <= readAddress + 1;
            end case;           
         end if;
      end process;

   end generate;
   
   -- Word width (40 Bit):
   -----------------------
   
   readAddrCtrl40b_gen: if WORD_WIDTH = 40 generate

      readAddrCtrl40b: process(TX_RESET_I, TX_WORDCLK_I)
      begin    
         if TX_RESET_I = '1' then
            readAddress                         <= 0; 
         elsif rising_edge(TX_WORDCLK_I) then   
            case readAddress is  
               when  2                          => readAddress <=  4;          
               when  6                          => readAddress <=  8;   
               when 10                          => readAddress <= 12;
               when 14                          => readAddress <= 16;
               when 18                          => readAddress <= 20;
               when 22                          => readAddress <= 24;
               when 26                          => readAddress <= 28;
               when 30                          => readAddress <=  0;
               when others                      => readAddress <= readAddress + 1;
            end case;            
         end if;
      end process;
      
   end generate;

end behabioral;