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
--  ENTITY		: 	SCRAMBLING.VHD
--  VERSION		:	0.4
--  VENDOR SPECIFIC?	:       NO
--  FPGA SPECIFIC? 	:       NO
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE	:	10/05/2009
--  LAST UPDATE     	:       02/10/2010
--  AUTHORs		:	Steffen MUSCHTER (Stockholm University), (Frederic MARIN (CPPM)
--  LANGAGE 		:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION		:	gather the 4 21bits-scramblers and latches the TX_FRAME_O
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--      DATE            	VERSION           	AUTHOR		DESCRIPTION
--      10/05/2009   		0.1                	MARIN   	first .BDF entity definition           
--	07/07/2009		0.2			BARON		vhdl entity
--	30/07/2009		0.3			BARON		add a generic parameter to allow having different initialisation
--									constants in case of multiple instanciations of 'scrambling'.
--									This modification is back-compatible with the previous scrambling entity.
--      02/10/2010              0.4                     MUSCHTER        Remove the event statement to save latency and logic
---------------------------------------------------------------------------------------------------------------------------------

--13/06/2013
-- mod by MBM
-- generate instantiation
--direct instantiation
-- now is the standard (we only use this one)
-- new name
-- port names

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  --to allow conversion of the integer into std_logic_vector

use work.gbt_link_package.all;
use work.gbt_link_user_setup.all;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

entity gbt_tx_scrambler is
  generic (N : integer := 0);  --when the scrambling entity is instanciated several times, N is incremented to avoid having the same initialisation
  port
    (
      TX_RESET_I           : in  std_logic;
      TX_FRAMECLK_I     : in  std_logic;
      TX_ISDATA_SEL_I      : in  std_logic;
      TX_DATA_I         : in  std_logic_vector(83 downto 0);
      TX_WIDEBUS_EXTRA_DATA_I    : in std_logic_vector(31 downto 0);
      TX_FRAME_O        : out std_logic_vector(83 downto 0);
      TX_WIDEBUS_EXTRA_FRAME_O    : out std_logic_vector(31 downto 0);
      TX_HEADER_O          : out std_logic_vector(3 downto 0)
     );
end gbt_tx_scrambler;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

architecture rtl of gbt_tx_scrambler is

  signal First_RESET_Pattern, Temp_First_RESET_Pattern   : std_logic_vector(20 downto 0);
  signal Second_RESET_Pattern, Temp_Second_RESET_Pattern : std_logic_vector(20 downto 0);
  signal Third_RESET_Pattern, Temp_Third_RESET_Pattern   : std_logic_vector(20 downto 0);
  signal Fourth_RESET_Pattern, Temp_Fourth_RESET_Pattern : std_logic_vector(20 downto 0);
  signal TX_RESET_I_N                                         : std_logic;
  signal Scrambled_Word, Temp_TX_FRAME_O                     : std_logic_vector(83 downto 0);

---------------------------------------------------------------------------------------------------------------------------------

begin

  tx_reset_i_n <= not(TX_RESET_I);
--  TX_FRAME_O  <= Temp_TX_FRAME_O;

--  scramblerInit: entity work.gbt_tx_21bit_scrambler_constants
--    port map(           TX_HEADER_O                    => TX_HEADER_O,
--                        RESET_Pattern1 => Temp_First_Reset_Pattern,
--                        RESET_Pattern2 => Temp_Second_Reset_Pattern,
--                        RESET_Pattern3 => Temp_Third_Reset_Pattern,
--                        RESET_Pattern4 => Temp_Fourth_Reset_Pattern);

--  First_RESET_Pattern  <= Temp_First_RESET_Pattern or std_logic_vector(To_unsigned(N, 21));
--  Second_RESET_Pattern <= Temp_Second_RESET_Pattern or std_logic_vector(To_unsigned(N, 21));
--  Third_RESET_Pattern  <= Temp_Third_RESET_Pattern or std_logic_vector(To_unsigned(N, 21));
--  Fourth_RESET_Pattern <= Temp_Fourth_RESET_Pattern or std_logic_vector(To_unsigned(N, 21));

   
   process(TX_RESET_I, TX_FRAMECLK_I)
   begin
      if TX_RESET_I = '1' then
         TX_HEADER_O <= (others => '0');
      elsif rising_edge(TX_FRAMECLK_I) then      
         if TX_ISDATA_SEL_I = '1' then
            TX_HEADER_O             <= DATA_HEADER_PATTERN;
         else
            TX_HEADER_O             <= IDLE_HEADER_PATTERN;      
         end if; 
      end if;
   end process;
   
   -- 84 bit scrambler (GBT frame):
   --------------------------------
   
   gbtTx84bitScrambler_gen: for i in 0 to 3 generate
     
     -- [83:63] & [62:42] & [41:21] & [20:0]
     
     gbtTx21bitScrambler: entity work.gbt_tx_21bit_scrambler
       port map(
         RESETB       => tx_reset_i_n,
         CLK          => TX_FRAMECLK_I,
         DIN          => TX_DATA_I(((21*i)+20) downto (21*i)),
         RESETPATTERN => SCRAMBLER_21BIT_RESET_PATTERNS(i),
         DOUT         => TX_FRAME_O(((21*i)+20) downto (21*i))
      );
   
   end generate;
   
   -- 32 bit scrambler (Widebus):
   ------------------------------
   
   widebusScrambler_gen: if TX_WIDE_BUS = true generate
   
      gbtTx32bitScrambler_gen: for i in 0 to 1 generate
         
         -- [31:16] & [15:0]
        
        gbtTx16bitScrambler: entity work.gbt_tx_16bit_scrambler
          port map(
            RESETB       => tx_reset_i_n,
            CLK          => TX_FRAMECLK_I,
            DIN          => TX_WIDEBUS_EXTRA_DATA_I(((16*i)+15) downto (16*i)),
            RESETPATTERN => SCRAMBLER_16BIT_RESET_PATTERNS(i),
            DOUT         => TX_WIDEBUS_EXTRA_FRAME_O(((16*i)+15) downto (16*i))
         );

      end generate;
   
   end generate;
   
   widebusScrambler_no_gen: if TX_WIDE_BUS = false generate
   
      TX_WIDEBUS_EXTRA_FRAME_O    <= (others => '0');
   
   end generate;
   

--  Temp_TX_FRAME_O <= Scrambled_Word;
  
  
end rtl;

