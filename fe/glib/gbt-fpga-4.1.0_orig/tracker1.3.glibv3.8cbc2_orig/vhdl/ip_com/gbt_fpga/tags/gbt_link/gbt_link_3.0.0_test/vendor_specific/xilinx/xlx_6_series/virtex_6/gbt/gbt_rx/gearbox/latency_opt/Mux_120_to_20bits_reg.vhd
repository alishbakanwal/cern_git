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


library ieee;
use ieee.std_logic_1164.all;

library work;

entity Mux_120_to_20bits_reg is
  port
    (
      Reset        	: in  std_logic;
      Tx_word_clk 	: in  std_logic;
      Tx_frame_clk  	: in  std_logic;
      Input        	: in  std_logic_vector(119 downto 0);
      Output       	: out std_logic_vector(19 downto 0);
		TxHeader			: out std_logic
      );
end Mux_120_to_20bits_reg;

architecture rtl of Mux_120_to_20bits_reg is

  signal data          : std_logic_vector (119 downto 0);
  signal counter       : std_logic_vector (2 downto 0)   := "000";
  signal reset_counter : std_logic                       := '0';

begin

  data_generation : for i in 119 downto 0 generate
    data(i) <= Input(119-i);  --the bits are inverted to transmit the MSB first on the GX
  end generate data_generation;

  write_data : process (Tx_frame_clk, Reset)
  begin  -- process multiplex_data
    if (Reset = '1') then
      reset_counter <= '1';
    else
      if (rising_edge(Tx_frame_clk)) then
        reset_counter <= '0';
      end if;
    end if;
  end process write_data;

  read_data : process (reset_counter, Tx_word_clk)
  begin  -- process read_data
    if (reset_counter = '1') then
      counter <= "000";
    elsif (rising_edge(Tx_word_clk)) then
      TxHeader <= '0';
		case counter is
        when "000" => output <= data (19  downto  0);
                      counter <= "001";
							 TxHeader <= '1';
        when "001" => output <= data (39  downto 20);
                      counter <= "010";
        when "010" => output <= data (59  downto 40);
                      counter <= "011";
        when "011" => output <= data (79  downto 60);
                      counter <= "100";
        when "100" => output <= data (99  downto 80);
                      counter <= "101";
        when "101" => output <= data (119 downto 100);
                      counter <= "000";
        when others => null;
      end case;
    end if;
  end process read_data;

end rtl;
