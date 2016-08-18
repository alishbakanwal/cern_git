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

-- MBM (26/11/2013) - new name
-- modified to be used with 20 or 40 bits
-- using cases instead of logic operations
-- writes pattern search and gearbox addresses

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;

entity gbt_rx_framealigner_wraddr is
   port (  
  
      RX_RESET_I                                : in  std_logic;
      RX_WORDCLK_I                              : in  std_logic;
      RX_BITSLIP_OVERFLOW_CMD_I                 : in  std_logic; 
      RX_PS_WRITE_ADDRESS_O                     : out std_logic_vector(WORD_ADDR_MSB downto 0);      
      RX_GB_WRITE_ADDRESS_RST_I                 : in  std_logic;
      RX_GB_WRITE_ADDRESS_O                     : out std_logic_vector(WORD_ADDR_MSB downto 0)
      
   );  
end gbt_rx_framealigner_wraddr;

architecture behavioral of gbt_rx_framealigner_wraddr is

  signal psWriteAddress                         : integer range 0 to 63;
  signal gbWriteAddress                         : integer range 0 to 63;
  
begin

   --==============--
   -- Common logic --
   --==============--
   
   RX_PS_WRITE_ADDRESS_O                        <= std_logic_vector(to_unsigned(psWriteAddress,(WORD_ADDR_MSB+1)));
   RX_GB_WRITE_ADDRESS_O                        <= std_logic_vector(to_unsigned(gbWriteAddress,(WORD_ADDR_MSB+1)));   
   
   --=====================--
   -- Word width (20 Bit) --
   --=====================--
   
   writeAddr20b_gen: if WORD_WIDTH = 20 generate
      
      process (RX_RESET_I, RX_WORDCLK_I)
      begin    
         if RX_RESET_I = '1' then
            psWriteAddress                      <= 0; 
            gbWriteAddress                      <= 2; 
         elsif rising_edge(RX_WORDCLK_I) then
            
            -- Patter Search write address:
            -------------------------------
            
            if RX_BITSLIP_OVERFLOW_CMD_I = '0' then
               case psWriteAddress is
                  when  5                       => psWriteAddress <=  8;          
                  when 13                       => psWriteAddress <= 16;   
                  when 21                       => psWriteAddress <= 24;
                  when 29                       => psWriteAddress <= 32;
                  when 37                       => psWriteAddress <= 40;
                  when 45                       => psWriteAddress <= 48;
                  when 53                       => psWriteAddress <= 56;
                  when 61                       => psWriteAddress <=  0;
                  when others                   => psWriteAddress <= psWriteAddress+1;
               end case;
            else                             
               null;  -- Comment: psWriteAddress is not incremented when right shifting of 20b
            end if;
            
            -- Gearbox write address:
            -------------------------
            
            if RX_GB_WRITE_ADDRESS_RST_I = '1' then
               gbWriteAddress                   <= 2;   -- Comment: gbWriteAddress is reset to write the word with the header on the 
            else                                        --          position 0 of the gearbox (gbWriteAddress = 2 is due to two clk cycles
               case gbWriteAddress is                   --          of reset delay).
                  when 5                        => gbWriteAddress <=  8;          
                  when 13                       => gbWriteAddress <= 16;   
                  when 21                       => gbWriteAddress <= 24;
                  when 29                       => gbWriteAddress <= 32;
                  when 37                       => gbWriteAddress <= 40;
                  when 45                       => gbWriteAddress <= 48;
                  when 53                       => gbWriteAddress <= 56;
                  when 61                       => gbWriteAddress <=  0;
                  when others                   => gbWriteAddress <= gbWriteAddress + 1;
               end case;        
            end if;
            
         end if;
      end process;

   end generate;

   --=====================--
   -- Word width (40 Bit) --
   --=====================--
   
   writeAddr40b_gen: if WORD_WIDTH = 40 generate
   
      process (RX_RESET_I, RX_WORDCLK_I)
      begin    
         if RX_RESET_I = '1' then
            psWriteAddress                      <= 0; 
            gbWriteAddress                      <= 2;
         elsif rising_edge(RX_WORDCLK_I) then
            
            -- Patter Search write address:
            -------------------------------
            
            if RX_BITSLIP_OVERFLOW_CMD_I = '0' then
               case psWriteAddress is
                  when  2                       => psWriteAddress <=  4;          
                  when  6                       => psWriteAddress <=  8;   
                  when 10                       => psWriteAddress <= 12;
                  when 14                       => psWriteAddress <= 16;
                  when 18                       => psWriteAddress <= 20;
                  when 22                       => psWriteAddress <= 24;
                  when 26                       => psWriteAddress <= 28;
                  when 30                       => psWriteAddress <=  0;
                  when others                   => psWriteAddress <= psWriteAddress+1;
               end case;
            else                             
               null;  -- Comment: psWriteAddress is not incremented when right shifting of 40b
            end if;
            
            -- Gearbox write address:
            -------------------------
            
            if RX_GB_WRITE_ADDRESS_RST_I = '1' then
               gbWriteAddress                   <= 2;   -- Comment: gbWriteAddress is reset to write the word with the header on the  
            else                                        --          position 0 of the gearbox (gbWriteAddress = 2 is due to two clk cycles
               case gbWriteAddress is                   --          of reset delay).
                  when  2                       => gbWriteAddress <=  4;          
                  when  6                       => gbWriteAddress <=  8;   
                  when 10                       => gbWriteAddress <= 12;
                  when 14                       => gbWriteAddress <= 16;
                  when 18                       => gbWriteAddress <= 20;
                  when 22                       => gbWriteAddress <= 24;
                  when 26                       => gbWriteAddress <= 28;
                  when 30                       => gbWriteAddress <=  0;
                  when others                   => gbWriteAddress <= gbWriteAddress + 1;
               end case;
            end if;           
            
         end if;
      end process;   
   
   end generate; 

end behavioral;