------------------------------------------------------
--                                      Read_RX_DP_RAM 
--                                                     
-- Detects the write address value where the first     
-- valid data were written and then start to           
-- generate read address                               
--                                                     
-- Author: Frdric Marin                                
-- Date: October 1st, 2008                             
-- Modified on April 8th, 2009                         
------------------------------------------------------

-- MBM - new name (12-11-2013)
-- cosmetic modifications

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gbt_rx_gearbox_std_rdctrl is
port (
  
   RX_RESET_I                                   : in std_logic;
   RX_WORDCLK_I                                 : in std_logic;
   RX_FRAMECLK_I                                : in std_logic;
   RX_HEADER_LOCKED_I                           : in std_logic;
   READ_ADDRESS_O                               : out std_logic_vector(2 downto 0);
   DV_O                                         : out std_logic
   
); 
end gbt_rx_gearbox_std_rdctrl;

architecture behavioral of gbt_rx_gearbox_std_rdctrl is

   signal dv_r                                  : std_logic_vector(2 downto 0);
   signal readEnable                            : std_logic;
  
begin
  
   -- Comment: DPRAM read delay after header locked.
   
   process(RX_RESET_I, RX_WORDCLK_I)
      variable counter                          : integer range 0 to 10;
   begin    
      if RX_RESET_I = '1' then
         counter                                :=  0 ;
         readEnable                             <= '0';
      elsif rising_edge(RX_WORDCLK_I) then
         if RX_HEADER_LOCKED_I = '1' then
            if counter < 10 then          
               counter                          := counter + 1;
            else
               readEnable                       <= '1';
            end if;
         else
            counter                             :=  0 ;
            readEnable                          <= '0';
         end if;
      end if;
   end process;

   -- Comment: DPRAM read address generation.
   
   process (RX_RESET_I, RX_FRAMECLK_I)
      variable resetReadAddress                 : std_logic;
      variable readAddress                      : unsigned(2 downto 0);
   begin    
      if RX_RESET_I = '1' then
         dv_r                                   <= (others => '0');
         DV_O                                   <= '0';
         resetReadAddress                       := '0';
         readAddress                            := (others => '0');
      elsif rising_edge(RX_FRAMECLK_I) then
         -- Comment: Registers to compensate the 2 cycles of delay of the DPRAM.
         DV_O                                   <= dv_r(2);
         dv_r(2)                                <= dv_r(1);
         dv_r(1)                                <= dv_r(0);             
         if readEnable = '0' then
            resetReadAddress                    := '1';
         end if;
         if (readEnable = '1') and (resetReadAddress = '1') then
            dv_r(0)                             <= '1';
            readAddress                         := (others => '0');
            resetReadAddress                    := '0';
         elsif readEnable = '1' then
            if readAddress = "111" then 
               readAddress                      := (others => '0');
            else
               readAddress                      := readAddress + 1;
            end if;
         else                       
            dv_r(0)                             <= '0';
         end if;
         READ_ADDRESS_O                         <= std_logic_vector(readAddress);         
      end if;
  end process;

end behavioral;