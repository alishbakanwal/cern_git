----------------------------------------------------------------------
----                                                              ----
---- GBT-FPGA SERDES Project                                              ----
----                                                              ----
---- This file is part of the GBT-FPGA Project                    ----
---- https://espace.cern.ch/GBT-Project/default.aspx              ----
---- https://svn.cern.ch/reps/gbt_fpga                                                    ----
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
--  ENTITY              :       DEMUX_40_TO_120BITS         
--  VERSION             :       0.3                                             
--  VENDOR SPECIFIC?    :       N0
--  FPGA SPECIFIC?      :       NO
--  CREATION DATE       :       10/05/2009
--  LAST UPDATE         :       02/11/2009  
--  AUTHORs             :       Steffen MUSCHTER (Stockholm University), Frederic MARIN (CPPM), Sophie BARON (CERN)
--  LANGAGE             :       VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--      DESCRIPTION     :       converts input: 3 successive words of 40bits@120MHz
--                              into output: 120bits@40MHz. Inverts the bits order to match the encoder.
--                                      
---------------------------------------------------------------------------------------------------------------------------------
--      VERSIONS HISTORY        :
--      DATE                    VERSION                 AUTHOR          DESCRIPTION
--      10/05/2009              0.1                     MARIN           first .BDF entity definition           
--      08/07/2009              0.2                     BARON           conversion to vhdl
--      02/11/2010              0.3                     MUSCHTER        optimization for low latency
---------------------------------------------------------------------------------------------------------------------------------

--MBM (04/07/2013)
-- new name

-- modified to use 20 or 40 bit interface

library ieee;
use ieee.std_logic_1164.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;

entity gbt_rx_gearbox_latopt is
   port (    
      RX_RESET_I                                : in  std_logic;
      RX_WORDCLK_I                              : in  std_logic;
      RX_FRAMECLK_I                             : in  std_logic;
      RX_HEADER_LOCKED_I                        : in  std_logic;
      RX_WRITE_ADDRESS_I                        : in  std_logic_vector(WORD_ADDR_MSB downto 0);
      RX_WORD_I                                 : in  std_logic_vector(WORD_WIDTH-1 downto 0);
      RX_FRAME_O                                : out std_logic_vector(119 downto 0);
      DV_O                                      : out std_logic
   );
end gbt_rx_gearbox_latopt;

architecture behavioral of gbt_rx_gearbox_latopt is

   signal reg2                                  : std_logic_vector (119 downto 0);

begin  

   --=====================--
   -- Word width (20 Bit) --
   --=====================--
   
   gbLatOpt20b_gen: if WORD_WIDTH = 20 generate

      gbLatOpt20b: process(RX_RESET_I, RX_WORDCLK_I)
         variable reg1                          : std_logic_vector (99 downto 0);
      begin
         if RX_RESET_I = '1' then
            reg1                                := (others => '0');
            reg2                                <= (others => '0');
         elsif rising_edge(RX_WORDCLK_I) then
            case RX_WRITE_ADDRESS_I (2 downto 0) is
               when "000"                       => reg1 (19 downto  0) := RX_WORD_I;
               when "001"                       => reg1 (39 downto 20) := RX_WORD_I;
               when "010"                       => reg1 (59 downto 40) := RX_WORD_I;
               when "011"                       => reg1 (79 downto 60) := RX_WORD_I;
               when "100"                       => reg1 (99 downto 80) := RX_WORD_I; 
               when "101"                       => reg2                <= RX_WORD_I & reg1;            
               when others                      => null;
            end case;
         end if;
      end process;     
   
   end generate;   

   --=====================--
   -- Word width (40 Bit) --
   --=====================--
   
   gbLatOpt40b_gen: if WORD_WIDTH = 40 generate

      gbLatOpt40b: process(RX_RESET_I, RX_WORDCLK_I)
         variable reg1                          : std_logic_vector (79 downto 0);
      begin
         if RX_RESET_I = '1' then
            reg1                                := (others => '0');
            reg2                                <= (others => '0');
         elsif rising_edge(RX_WORDCLK_I) then
            case RX_WRITE_ADDRESS_I(1 downto 0) is
              when "00"                         => reg1 (39 downto  0)  := RX_WORD_I;
              when "01"                         => reg1 (79 downto 40)  := RX_WORD_I;
              when "10"                         => reg2                 <= RX_WORD_I & reg1;        
              when others                       => null;
            end case;
         end if;
      end process; 
   
   end generate;
   
   --==============--
   -- Common logic --
   --==============--
   
   invertDataOut: for i in 119 downto 0 generate
      RX_FRAME_O(i)                             <= reg2(119-i);
   end generate;
      
   dvSync: process(RX_RESET_I, RX_FRAMECLK_I)
   begin
      if RX_RESET_I = '1' then
         DV_O                                   <= '0';
      elsif rising_edge(RX_FRAMECLK_I) then     
         DV_O                                   <= RX_HEADER_LOCKED_I;      
      end if;
   end process;   
      
end behavioral;
