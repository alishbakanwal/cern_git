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
--  ENTITY              :       RW_TX_DP_RAM           
--  VENDOR SPECIFIC?    :       No
--  FPGA SPECIFIC?      :       No
--  CREATION DATE       :       25/09/2008
--  LAST UPDATE         :       02/11/2010  
--  AUTHORs             :       Steffen MUSCHTER (Stockholm University), Frederic MARIN (CPPM)
--  LANGAGE             :       VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--      DESCRIPTION             :       Manages the read and write counters for the dual
--                                      port RAM used as multiplexor for the emssion path
---------------------------------------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity RW_TX_DP_RAM is
  port(
    Reset        : in std_logic;
    Clock_120MHz : in std_logic;
    Clock_40MHz  : in std_logic;

    Write_Address : out std_logic_vector(2 downto 0);
    Read_Address  : out std_logic_vector(4 downto 0)
    );  

end RW_TX_DP_RAM;


architecture a of RW_TX_DP_RAM is

  signal Reset_int       : std_logic := '0';
  signal Write_Address_i : std_logic_vector(2 downto 0);
  signal Read_Address_i  : std_logic_vector(4 downto 0);
  
begin

  Write_Address <= Write_Address_i;
  Read_Address  <= Read_Address_i;

  reset_intern : process (Reset, Clock_40MHz)
  begin  -- process reset_intern
    if (Reset = '1') then
      Reset_int <= '1';
    elsif RISING_EDGE(Clock_40MHz) then
      Reset_int <= '0';
    end if;
  end process reset_intern;

  Writing :
  process (Reset_int, Clock_40MHz)

  begin
    
    if RISING_EDGE(Clock_40MHz) then
      if (Reset_int = '0') then
        Write_Address_i <= Write_Address_i + 1;
      else
        Write_Address_i <= "001"; -- modified for Altera from previous "001" for Xilinx
      end if;
    end if;
  end process;


  Reading :
  process (Reset_int, Clock_120MHz)

  begin
    
    if RISING_EDGE(Clock_120MHz) then
      if (Reset_int = '0') then
        if (CONV_INTEGER(Read_Address_i + 2)) rem 4 = 0 then  -- The RAM is 160-bits wide but we only use 120-bits
          Read_Address_i <= Read_Address_i + 2;  -- So the last read address, corresponding the 40 MSB
        else                            -- 159 downto 120, is not read.
          Read_Address_i <= Read_Address_i + 1;
        end if;
      else
        Read_Address_i <= "11110"; -- modified for Altera from previous "00000" for Xilinx
      end if;
    end if;
  end process;

end a;
