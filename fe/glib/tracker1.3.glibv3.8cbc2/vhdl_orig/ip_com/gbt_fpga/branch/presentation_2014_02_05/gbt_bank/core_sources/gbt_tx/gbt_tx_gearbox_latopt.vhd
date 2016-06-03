----------------------------------------------------------------------
----                                                              ----
---- GBT-FPGA SERDES Project                                      ----
----                                                              ----
---- This file is part of the GBT-FPGA Project                    ----
---- https://espace.cern.ch/GBT-Project/default.aspx              ----
---- https://svn.cern.ch/reps/gbt_fpga                            ----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
----                                                              ----
---- This source file may be used and distributed without         ----
---- restriction provided that this copyright statement is not    ----
---- removed from the file and that any derivative work contains  ----
---- the original copyright notice and the associated disclaimer. ----
----                                                              ----
---- This source file is free software; you can redistribute it   ----
---- and/or modify it under the terms of the GNU General          ----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.0 of the License, or (at your option) any   ----
---- later version.                                               ----
----                                                              ----
---- This source is distributed in the hope that it will be       ----
---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
---- PURPOSE. See the GNU General Public License for more details.----
----                                                              ----
---- You should have received a copy of the GNU General           ----
---- Public License along with this source; if not, download it   ----
---- from http://www.gnu.org/licenses/gpl.txt                     ----
----                                                              ----
---------------------------------------------------------------------- 
---------------------------------------------------------------------------------------------------------------------------------
--  ENTITY              :       MUX_120_TO_40BITS
--  VERSION             :       0.3                                            
--  VENDOR SPECIFIC?    :       No
--  FPGA SPECIFIC?      :       No
--  CREATION DATE       :       02/11/2010
--  LAST UPDATE         :       02/11/2010  
--  AUTHORs             :       Steffen MUSCHTER (Stockholm University), Frederic MARIN (CPPM), Sophie BARON (CERN)
--  LANGAGE             :       VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--      DESCRIPTION             :       ensures the conversion of one encoded word +header (=120 bits@40MHz) 
--                                      into 3 words of 40 bits@120MHz. The first word being transmitted has to be the 40MSB of 
--                                      the 120bits (containing header)
---------------------------------------------------------------------------------------------------------------------------------
--      VERSIONS HISTORY        :
--      DATE                    VERSION                 AUTHOR          DESCRIPTION
--      10/05/2009              0.1                     MARIN           first .BDF entity definition           
--      08/07/2009              0.2                     BARON           conversion to vhdl
--      02/11/2010              0.3                     MUSCHTER        optimization to low latency
---------------------------------------------------------------------------------------------------------------------------------

--MBM 04/07/2013
--20bit (paschalis)
--new name
-- MBM - REMOVED HEADER FLAG (01/08/2013)
-- modified to use 20 and 40 bits words

library ieee;
use ieee.std_logic_1164.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;

entity gbt_tx_gearbox_latopt is
  port (
  
      TX_RESET_I                                : in  std_logic;
      TX_WORDCLK_I                              : in  std_logic;
      TX_FRAMECLK_I                             : in  std_logic;
      TX_FRAME_I                                : in  std_logic_vector(119 downto 0);
      TX_WORD_O                                 : out std_logic_vector(WORD_WIDTH-1 downto 0)
   
   );
end gbt_tx_gearbox_latopt;

architecture behavioral of gbt_tx_gearbox_latopt is

  signal txFrame_from_invertDataIn              : std_logic_vector (119 downto 0);
  signal gearboxSyncReset                       : std_logic;  

begin
   
   --==============--
   -- Common logic --
   --==============--
   
   -- Comment: Bits are inverted to transmit the MSB first on the MGT.
   
   invertDataIn: for i in 119 downto 0 generate
      txFrame_from_invertDataIn(i)              <= TX_FRAME_I(119-i);
   end generate;
   
   -- Comment: Note!! The reset of the gearbox is synchronous to TX_FRAMECLK in order to align the address 0 
   --                 of the gearbox with the rising edge of TX_FRAMECLK after reset.
   
   syncReset: process(TX_RESET_I, TX_FRAMECLK_I)
   begin
      if TX_RESET_I = '1' then
         gearboxSyncReset                       <= '1';
      elsif rising_edge(TX_FRAMECLK_I) then
         gearboxSyncReset                       <= '0';
      end if;
   end process;
   
   --=====================--
   -- Word width (20 Bit) --
   --=====================--
   
   gbLatOpt20b_gen: if WORD_WIDTH = 20 generate   

      gbLatOpt20b: process (gearboxSyncReset, TX_WORDCLK_I)
         variable address                       : integer range 0 to 5;
      begin
         if gearboxSyncReset = '1' then
            TX_WORD_O                           <= (others => '0');
            address                             := 0;
         elsif rising_edge(TX_WORDCLK_I) then
            case address is
               when 0 =>
                  TX_WORD_O                     <= txFrame_from_invertDataIn( 19 downto   0);
                  address                       := 1;
               when 1 => 
                  TX_WORD_O                     <= txFrame_from_invertDataIn( 39 downto  20);
                  address                       := 2;
               when 2 =>                 
                  TX_WORD_O                     <= txFrame_from_invertDataIn( 59 downto  40);
                  address                       := 3;
               when 3 =>                 
                  TX_WORD_O                     <= txFrame_from_invertDataIn( 79 downto  60);
                  address                       := 4;
               when 4 =>                 
                  TX_WORD_O                     <= txFrame_from_invertDataIn( 99 downto  80);
                  address                       := 5;
               when 5 =>                 
                  TX_WORD_O                     <= txFrame_from_invertDataIn(119 downto 100);
                  address                       := 0;
               when others =>
                  null;
            end case;
         end if;
      end process;

   end generate;  
  
   --=====================--
   -- Word width (40 Bit) --
   --=====================--
   
   gbLatOpt40b_gen: if WORD_WIDTH = 40 generate   

      gbLatOpt40b: process (gearboxSyncReset, TX_WORDCLK_I)
         variable address                       : integer range 0 to 2;
      begin
         if gearboxSyncReset = '1' then
            TX_WORD_O                           <= (others => '0');
            address                             := 0;
         elsif rising_edge(TX_WORDCLK_I) then
            case address is
               when 0 =>
                  TX_WORD_O                     <= txFrame_from_invertDataIn( 39 downto   0);
                  address                       := 1;
               when 1 => 
                  TX_WORD_O                     <= txFrame_from_invertDataIn( 79 downto  40);
                  address                       :=2;
               when 2 =>                 
                  TX_WORD_O                     <= txFrame_from_invertDataIn(119 downto  80);
                  address                       := 0;              
               when others =>
                  null;
            end case;
         end if;
      end process;

   end generate;  
  
end behavioral;