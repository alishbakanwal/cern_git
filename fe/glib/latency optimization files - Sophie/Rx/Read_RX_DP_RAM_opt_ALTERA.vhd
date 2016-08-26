----------------------------------------------------------------------
----                                                              ----
---- GBT-FPGA SERDES Project                               	  ----
----                                                              ----
---- This file is part of the GBT-FPGA Project              	  ----
---- https://espace.cern.ch/GBT-Project/default.aspx              ----
---- https://svn.cern.ch/reps/gbt_fpga 				  ----
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
--  ENTITY		: 	Read_RX_DP_RAM		
--  VENDOR SPECIFIC?	:	NO
--  FPGA SPECIFIC?	:       NO
--  CREATION DATE	:	01/10/2008
--  LAST UPDATE     	:       02/11/2010  
--  AUTHORs	      	:	Steffen MUSCHTER (Stockholm University), Frederic MARIN (CPPM), Sophie BARON (CERN)
--  LANGAGE 		:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------
--                      Read_RX_DP_RAM                            ----
--                                                                ----
-- Detects the write address value where the first                ----
-- valid data were written and then start to                      ----
-- generate read address                                          ----
--                                                                ----
----------------------------------------------------------------------




library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;  -- necessary to understand addition of std_logic_vectors to integers


entity Read_RX_DP_RAM is
  port(
    Reset            : in std_logic;
    RX_Clock         : in std_logic;
    Clock_40MHz      : in std_logic;
    Write_Address    : in std_logic_vector(4 downto 0);
    Locked_On_Header : in std_logic;

    Read_Address : out std_logic_vector(2 downto 0);
    DV           : out std_logic
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
  process(Reset, RX_Clock)
  begin
    
    if Reset = '1' then
      Ready_For_Reading <= '0';
      Counter           <= 0;
    elsif RISING_EDGE(RX_Clock) then
      if Locked_On_Header = '1' then
          Ready_For_Reading <= '1';
      else
        Ready_For_Reading <= '0';
      end if;
    end if;
  end process;

  -- Process generating the read address
  process (Reset, Clock_40MHz)

  begin
    
    if Reset = '1' then
      Read_Address_i <= "001";
      DV             <= '0';
      s_DV           <= "000";
      Flag           <= '0';
    elsif RISING_EDGE(Clock_40MHz) then
      -- To compensate the 2 registers of the DP RAM
      s_DV(1) <= s_DV(0);
      s_DV(2) <= s_DV(1);
      DV      <= s_DV(2);

      if Ready_For_Reading = '0' then
        Flag <= '1';
      end if;

      if Ready_For_Reading = '1' and Flag = '1' then
        s_DV(0)        <= '1';
        Read_Address_i <= "001";
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
