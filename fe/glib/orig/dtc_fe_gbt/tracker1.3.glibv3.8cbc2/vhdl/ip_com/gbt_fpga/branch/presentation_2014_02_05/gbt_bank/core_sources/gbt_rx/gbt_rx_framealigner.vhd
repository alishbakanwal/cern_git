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
--  ENTITY            :    MANUAL_FRAME_ALIGNMENT.VHD      
--  VERSION            :   0.2                  
--  VENDOR SPECIFIC?   :   NO
--  FPGA SPECIFIC?       :   NO
--  SOFTWARE RELEASE   :   QII 9.0 SP2
--  CREATION DATE      :   10/05/2009
--  LAST UPDATE        :   08/07/2009  
--  AUTHORs            :   Frederic MARIN (CPPM)
--  LANGAGE          :   VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--   DESCRIPTION         :   ensures the alignement of the 3 words of 40bits together with the pattern searcher
--                  
--                  
---------------------------------------------------------------------------------------------------------------------------------
--   VERSIONS HISTORY   :
--                      DATE               VERSION              AUTHOR      DESCRIPTION
--                      10/05/2009         0.1                   MARIN      first .BDF entity definition           
--                  08/07/2009         0.2               BARON      conversion into vhdl
---------------------------------------------------------------------------------------------------------------------------------


-- MBM (04/07/2013)
-- new name
--port names
--one version for 40 and 20 bits
--merged with the bitslip counter
--merged with pattern search

library ieee;
use ieee.std_logic_1164.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;

entity gbt_rx_framealigner is
  port (
    
      RX_RESET_I                                     : in  std_logic;
      RX_WORDCLK_I                                   : in  std_logic;
      RX_MGT_RDY_I                                   : in  std_logic;
      RX_HEADER_LOCKED_O                             : out std_logic;
      RX_HEADER_FLAG_O                               : out std_logic;       
      RX_BITSLIP_NBR_O                               : out std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      RX_WRITE_ADDRESS_O                             : out std_logic_vector(WORD_ADDR_MSB downto 0);            
      RX_WORD_I                                      : in  std_logic_vector(WORD_WIDTH-1 downto 0);
      ALIGNED_RX_WORD_O                              : out std_logic_vector(WORD_WIDTH-1 downto 0)      
      
   );
end gbt_rx_framealigner;

architecture structural of gbt_rx_framealigner is

   signal rxPsWriteAddress_from_writeAddressCtrl     : std_logic_vector(WORD_ADDR_MSB downto 0);   

   signal rxBitSlipCmd_from_patternSearch            : std_logic;
   signal rxGbWriteAddressRst_from_patternSearch     : std_logic;
   
   signal rxBitslipOverflowCmd_from_rxBitSlipCounter : std_logic;
   signal rxBitSlipCount_from_rxBitSlipCounter       : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);  

   signal ready_from_rightShifter                    : std_logic;
   signal shiftedRxWord_from_rightShifter            : std_logic_vector(WORD_WIDTH-1 downto 0);

begin    
   
   writeAddressCtrl: entity work.gbt_rx_framealigner_wraddr
      port map (
         RX_RESET_I                                  => RX_RESET_I,
         RX_WORDCLK_I                                => RX_WORDCLK_I,
         RX_BITSLIP_OVERFLOW_CMD_I                   => rxBitslipOverflowCmd_from_rxBitSlipCounter,
         RX_PS_WRITE_ADDRESS_O                       => rxPsWriteAddress_from_writeAddressCtrl,
         RX_GB_WRITE_ADDRESS_RST_I                   => rxGbWriteAddressRst_from_patternSearch,
         RX_GB_WRITE_ADDRESS_O                       => RX_WRITE_ADDRESS_O  
      );  
   
   patternSearch: entity work.gbt_rx_framealigner_pattsearch
      port map (
         RX_RESET_I                                  => RX_RESET_I,
         RX_WORDCLK_I                                => RX_WORDCLK_I,
         ---------------------------------------     
         RIGHTSHIFTER_READY_I                        => ready_from_rightShifter,
         RX_WRITE_ADDRESS_I                          => rxPsWriteAddress_from_writeAddressCtrl,
         RX_BITSLIP_CMD_O                            => rxBitSlipCmd_from_patternSearch,
         RX_HEADER_LOCKED_O                          => RX_HEADER_LOCKED_O,
         RX_HEADER_FLAG_O                            => RX_HEADER_FLAG_O,
         RX_GB_WRITE_ADDRESS_RST_O                   => rxGbWriteAddressRst_from_patternSearch,
         ---------------------------------------     
         RX_WORD_I                                   => shiftedRxWord_from_rightShifter,
         RX_WORD_O                                   => ALIGNED_RX_WORD_O
      );  
   
   rxBitSlipCounter: entity work.gbt_rx_framealigner_counter
      port map (
         RX_RESET_I                                  => RX_RESET_I,
         RX_WORDCLK_I                                => RX_WORDCLK_I,
         RX_BITSLIP_CMD_I                            => rxBitSlipCmd_from_patternSearch,
         RX_BITSLIP_OVERFLOW_CMD_O                   => rxBitslipOverflowCmd_from_rxBitSlipCounter,
         RX_BITSLIP_NBR_O                            => rxBitSlipCount_from_rxBitSlipCounter
      );      
     
   RX_BITSLIP_NBR_O                                  <= rxBitSlipCount_from_rxBitSlipCounter; 
   
   rightShifter: entity work.gbt_rx_framealigner_rightshift
      port map (
         RX_RESET_I                                  => RX_RESET_I,
         RX_WORDCLK_I                                => RX_WORDCLK_I,
         RX_MGT_RDY_I                                => RX_MGT_RDY_I,
         READY_O                                     => ready_from_rightShifter,
         RX_BITSLIP_COUNT_I                          => rxBitSlipCount_from_rxBitSlipCounter,
         RX_WORD_I                                   => RX_WORD_I,
         SHIFTED_RX_WORD_O                           => shiftedRxWord_from_rightShifter
      );  

end structural;