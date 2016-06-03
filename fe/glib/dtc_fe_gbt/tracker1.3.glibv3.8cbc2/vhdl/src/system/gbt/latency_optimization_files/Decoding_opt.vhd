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
--  ENTITY              :       DECODING                
--  VENDOR SPECIFIC?    :       NO
--  FPGA SPECIFIC?      :       NO
--  LAST UPDATE         :       02/11/2010  
--  AUTHORs             :       Steffen MUSCHTER (Stockholm University), Sophie BARON (CERN)
--  LANGAGE             :       VHDL'93
---------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;

entity Decoding is
  port
    (
      Clock_40MHz : in  std_logic;
      DV_In       : in  std_logic;
      Input       : in  std_logic_vector(119 downto 0);
      errordetect : out std_logic;      -- signal added for debugging
      DV_Out      : out std_logic;
      Output      : out std_logic_vector(83 downto 0)
      );
end Decoding;


architecture rtl of Decoding is

  component rsdecoder
    port(receivedcode : in  std_logic_vector(59 downto 0);
         correctedmsg : out std_logic_vector(43 downto 0);
         errordetect  : out std_logic
         );
  end component;

  signal Corrected_Message    : std_logic_vector(87 downto 0);
  signal Temp_Output          : std_logic_vector(83 downto 0);
  signal Reset_N, Temp_DV_Out : std_logic;

  -- signals added for debugging --
  signal errordetect_1 : std_logic;
  signal errordetect_2 : std_logic;


---------------------------------------------------------------------------------------------------------------------------------

begin

  DV_Out <= DV_In;                           -- Temp_DV_Out;
  Output <= Corrected_Message(83 downto 0);  -- Temp_Output;


  Decoder_119_60 : rsdecoder
    port map(receivedcode => Input(119 downto 60),
             correctedmsg => Corrected_Message(87 downto 44),
             errordetect  => errordetect_1  -- signal added for debugging
             );

  Decoder_59_0 : rsdecoder
    port map(receivedcode => Input(59 downto 0),
             correctedmsg => Corrected_Message(43 downto 0),
             errordetect  => errordetect_2  -- signal added for debugging
             );

  Error_o : process (Clock_40MHz)
  begin
    if (rising_edge(Clock_40MHz)) then
      errordetect <= errordetect_1 or errordetect_2;  -- signal added for debugging    
    end if;
  end process Error_o;
  
end rtl;
