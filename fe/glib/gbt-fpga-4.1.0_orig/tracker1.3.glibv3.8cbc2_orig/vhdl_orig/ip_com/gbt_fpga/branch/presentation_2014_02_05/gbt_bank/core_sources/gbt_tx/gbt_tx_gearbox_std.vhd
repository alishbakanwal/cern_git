----------------------------------------------------------------------
----                                                              ----
---- GBT-FPGA SERDES Project                                       ----
----                                                              ----
---- This file is part of the GBT-FPGA Project                   ----
---- https://espace.cern.ch/GBT-Project/default.aspx              ----
---- https://svn.cern.ch/reps/gbt_fpga                        ----
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
--  ENTITY            :    MUX_120_TO_40BITS.VHD      
--  VERSION            :   0.2                  
--  VENDOR SPECIFIC?   :   YES (Altera)
--  FPGA SPECIFIC?       :   NO 
--  SOFTWARE RELEASE   :   QII 9.0 SP2
--  CREATION DATE      :   10/05/2009
--  LAST UPDATE        :   08/07/2009  
--  AUTHORs            :   Frederic MARIN (CPPM), Sophie BARON (CERN)
--  LANGAGE          :   VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--   DESCRIPTION      :   ensures the conversion of one encoded word +header (=120 bits@40MHz) 
--               into 3 words of 40 bits@120MHz. The first word being transmitted has to be the 40MSB of 
--               the 120bits (containing header)
---------------------------------------------------------------------------------------------------------------------------------
--   VERSIONS HISTORY   :
--                      DATE               VERSION              AUTHOR      DESCRIPTION
--                      10/05/2009         0.1                   MARIN      first .BDF entity definition           
--                  08/07/2009         0.2               BARON      conversion to vhdl
---------------------------------------------------------------------------------------------------------------------------------

-- MBM - new name and ports (09/08/2013)
--     - new dpram module (07/11/2013)
--     - modified to use 20 and 40 bit words      

library ieee;
use ieee.std_logic_1164.all; 

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

entity gbt_tx_gearbox_std is 
   port (
   
      TX_RESET_I                                : in  std_logic;
      TX_FRAMECLK_I                             : in  std_logic;
      TX_WORDCLK_I                              : in  std_logic;
      TX_FRAME_I                                : in  std_logic_vector(119 downto 0);
      TX_WORD_O                                 : out std_logic_vector(WORD_WIDTH-1 downto 0)
      
   );
end gbt_tx_gearbox_std;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

architecture structural of gbt_tx_gearbox_std is 

   signal txFrame_from_invertDataIn             : std_logic_vector(119 downto 0);   
   
   signal writeAddress_from_readWriteControl    : std_logic_vector(2 downto 0);
   signal readAddress_from_readWriteControl     : std_logic_vector(WORD_ADDR_MSB downto 0);
   

---------------------------------------------------------------------------------------------------------------------------------

begin   

   readWriteControl: entity work.gbt_tx_gearbox_std_rdwrctrl
      port map (
         TX_RESET_I                             => TX_RESET_I,          
         TX_FRAMECLK_I                          => TX_FRAMECLK_I,
         TX_WORDCLK_I                           => TX_WORDCLK_I,          
         WRITE_ADDRESS_O                        => writeAddress_from_readWriteControl,
         READ_ADDRESS_O                         => readAddress_from_readWriteControl
      );

   -- Comment: Bits are inverted to transmit the MSB first on the MGT.
   
   invertDataIn: for i in 119 downto 0 generate
      txFrame_from_invertDataIn(i)              <= TX_FRAME_I(119-i);      
   end generate;
      
   dpram: entity work.gbt_tx_gearbox_std_dpram
      port map (
         WR_CLK_I                               => TX_FRAMECLK_I,
         WR_ADDRESS_I                           => writeAddress_from_readWriteControl,   
         WR_DATA_I                              => txFrame_from_invertDataIn,
         RD_CLK_I                               => TX_WORDCLK_I,
         RD_ADDRESS_I                           => readAddress_from_readWriteControl,
         RD_DATA_O                              => TX_WORD_O
      );   

end structural;