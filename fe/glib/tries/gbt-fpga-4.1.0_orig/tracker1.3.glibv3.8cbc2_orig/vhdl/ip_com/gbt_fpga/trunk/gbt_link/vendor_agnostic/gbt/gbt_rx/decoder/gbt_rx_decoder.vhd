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

-- MBM (04/07/2013)
-- new name
-- no component declaration
--port names
-- added widebus

-- data is valid after 1 clock cycle after the change
-- error is asserted 1 clk cycle when from widebus to rs encoding


library ieee;
use ieee.std_logic_1164.all;

use work.gbt_link_package.all;
use work.gbt_link_user_setup.all;

entity gbt_rx_decoder is
  port
    (
      RX_RESET_I         : IN  STD_LOGIC;
      RX_FRAMECLK_I  : IN  STD_LOGIC;
      RX_ENCODING_SEL_I      : IN  STD_LOGIC_VECTOR(1 downto 0);         
      DV_I       : in  std_logic;
      RX_FRAME_I       : in  std_logic_vector(119 downto 0);
      RS_ERRORDETECT_O : out std_logic;      -- signal added for debugging
      RX_ISDATA_FLAG_O     : out  std_logic;  
      RX_FRAME_O        : out std_logic_vector(83 downto 0);
      RX_WIDEBUS_EXTRA_FRAME_O    : out std_logic_vector(31 downto 0); 
      DV_O              : out std_logic
     );
end gbt_rx_decoder;


architecture rtl of gbt_rx_decoder is 

  signal Corrected_Message    : std_logic_vector(87 downto 0);
  signal Temp_RX_FRAME_O          : std_logic_vector(83 downto 0);
  signal Reset_N, Temp_DV_O : std_logic;

  signal sel_decodingSelector : std_logic_vector(1 downto 0);

   
   signal rxFrame_from_deinterleaver            : std_logic_vector (119 downto 0);
   
  
  
  
  -- signals added for debugging --
  signal errordetect_1 : std_logic;
  signal errordetect_2 : std_logic;


---------------------------------------------------------------------------------------------------------------------------------

begin

   --==============--
   -- Frame header --
   --==============--

   -- Comment: ('0' -> IDLE (0110) | '1' -> DATA (0101)) 
   
   RX_ISDATA_FLAG_O   <= '1' when (RX_FRAME_I(119 downto 116) = DATA_HEADER_PATTERN) and (DV_I = '1') else
                                '0'; 
   
   --=========--
   -- Decoder --
   --=========--   
   
  -- GBT frame:
  -------------  
   
   deinterleaver: entity work.gbt_rx_deinterleaver
      port map (        
         RX_FRAME_I                             => RX_FRAME_I,
         RX_FRAME_O                             => rxFrame_from_deinterleaver
      );   
      
      reedSolomonDecoder_119_60: entity work.gbt_rx_gbtframe_decoder
    port map(receivedcode => rxFrame_from_deinterleaver(119 downto 60),
             correctedmsg => Corrected_Message(87 downto 44),
             errordetect  => errordetect_1  -- signal added for debugging
             );

    reedSolomonDecoder_59_0: entity work.gbt_rx_gbtframe_decoder
    port map(receivedcode => rxFrame_from_deinterleaver(59 downto 0),
             correctedmsg => Corrected_Message(43 downto 0),
             errordetect  => errordetect_2  -- signal added for debugging
             );
   
   -- Wide-bus: 
   ------------
   
    widebus_gen: if RX_WIDE_BUS = true generate
   
      RX_WIDEBUS_EXTRA_FRAME_O  <= RX_FRAME_I(31 downto 0)   when sel_decodingSelector = "01" else  -- wide-bus
                                 (others => '0');

   end generate;

   widebus_no_gen: if RX_WIDE_BUS = false generate
   
      RX_WIDEBUS_EXTRA_FRAME_O  <= (others => '0');
   
   end generate;
 
   -- Encoding selector:
   ---------------------
   
   main:process(RX_RESET_I, RX_FRAMECLK_I)
   begin
      if RX_RESET_I = '1' then   
         RS_ERRORDETECT_O                <= '0';
         --
         sel_decodingSelector            <= "00";
      elsif rising_edge(RX_FRAMECLK_I) then      
        case RX_ENCODING_SEL_I is
            when "01" =>     
               sel_decodingSelector      <= "01";
                RS_ERRORDETECT_O         <= '0';
            when "10" =>
               --8b10b
            when others =>
              sel_decodingSelector       <= "00"; 
              RS_ERRORDETECT_O           <= errordetect_1 or errordetect_2;  -- signal added for debugging    
         end case;
      end if;
   end process;

   RX_FRAME_O      <= RX_FRAME_I(115 downto 32) when sel_decodingSelector = "01" else  -- widebus
--                    8b10b                     when sel_decodingSelector = "10" else
                      Corrected_Message(83 downto 0);
   
   --============--
   -- Data valid --
   --============--
   
   DV_O             <= DV_I;                           -- Temp_DV_O;

  
end rtl;
