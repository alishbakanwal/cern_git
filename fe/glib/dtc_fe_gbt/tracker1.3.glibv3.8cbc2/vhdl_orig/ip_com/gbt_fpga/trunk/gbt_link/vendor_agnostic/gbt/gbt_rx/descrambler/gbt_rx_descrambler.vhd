----------------------------------------------------------------------
----                                                              ----
---- GBT-FPGA SERDES Project                               		  ----
----                                                              ----
---- This file is part of the GBT-FPGA Project              	  ----
---- https://espace.cern.ch/GBT-Project/default.aspx              ----
---- https://svn.cern.ch/reps/gbt_fpga 							  ----
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
--  ENTITY				: 	DESCRAMBLING.VHD		
--  VERSION				:	0.2						
--  VENDOR SPECIFIC?	:	NO
--  FPGA SPECIFIC? 		:   NO
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE		:	10/05/2009
--  LAST UPDATE     	:   08/07/2009  
--  AUTHORs				:	Frederic MARIN (CPPM), Sophie BARON (CERN)
--  LANGAGE 			:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION			:	last step of the decoding process: 84 bits RX_FRAME_I -> 84 descrambled bits RX_DATA_O
--						the descrambler is made of 4 blocks of 21-bits descrambler blocks
--					
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--                      DATE            	VERSION           	AUTHOR		DESCRIPTION
--                      10/05/2009   		0.1                	MARIN   	first .BDF entity definition           
--						08/07/2009			0.2					BARON		conversion to vhdl file
---------------------------------------------------------------------------------------------------------------------------------

--13/06/2013
-- Mod by MBM

-- generate for instantiation
-- lat or std
-- new style
-- direct instantiation
-- new name

LIBRARY ieee;
USE ieee.std_logic_1164.all; 



use work.gbt_link_user_setup.all;


---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ENTITY gbt_rx_descrambler IS 
	PORT
	(
		RX_RESET_I 		            : IN  STD_LOGIC;
		RX_FRAMECLK_I             : IN  STD_LOGIC;
		DV_I 		                  : IN  STD_LOGIC;        
      DV_O 		                  : OUT  STD_LOGIC;
      RX_ISDATA_FLAG_I           : IN  STD_LOGIC;
      RX_ISDATA_FLAG_O           : OUT  STD_LOGIC;
      RX_FRAME_I 		            : IN  STD_LOGIC_VECTOR(83 DOWNTO 0);
		RX_DATA_O 		            : OUT  STD_LOGIC_VECTOR(83 DOWNTO 0);
		RX_WIDEBUS_EXTRA_DATA_O    : out std_logic_vector(31 downto 0); 
      RX_WIDEBUS_EXTRA_FRAME_I   : in std_logic_vector(31 downto 0)
	);
END gbt_rx_descrambler;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ARCHITECTURE rtl OF gbt_rx_descrambler IS 



SIGNAL	Temp_RX_DATA_O :  STD_LOGIC_VECTOR(83 DOWNTO 0);
SIGNAL	RX_RESET_I_N :  STD_LOGIC;
SIGNAL	Temp_DV_O :  STD_LOGIC;
---------------------------------------------------------------------------------------------------------------------------------

BEGIN 

   -- 84 bit scrambler (GBT frame):
   --------------------------------

   gbtRx84bitDescrambler_gen: for i in 0 to 3 generate
      
      -- [83:63] & [62:42] & [41:21] & [20:0]
      
      gbtRx21bitDescrambler: entity work.gbt_rx_21bit_descrambler
         port map(
            RESETB   => RX_RESET_I_N,
            CLK      => RX_FRAMECLK_I,
            DIN      => RX_FRAME_I(((21*i)+20) downto (21*i)), 
            DOUT     => RX_DATA_O(((21*i)+20) downto (21*i))
         );
         
   end generate;
   
   -- 32 bit scrambler (Widebus):
   ------------------------------
   
   widebusScrambler_gen: if RX_WIDE_BUS = true generate
      
      gbtRx32bitDescrambler_gen: for i in 0 to 1 generate
      
      -- [41:21] & [20:0]
      
         gbtRx16bitDescrambler: entity work.gbt_rx_16bit_descrambler
            port map(
               RESETB   => RX_RESET_I_N,
               CLK      => RX_FRAMECLK_I,
               DIN      => RX_WIDEBUS_EXTRA_FRAME_I(((16*i)+15) downto (16*i)),
               DOUT     => RX_WIDEBUS_EXTRA_DATA_O(((16*i)+15) downto (16*i))
            );
         
      end generate; 
     
   end generate;     
      
      
   widebusScrambler_no_gen: if RX_WIDE_BUS = false generate
   
      RX_WIDEBUS_EXTRA_DATA_O    <= (others => '0');
   
   end generate; 
      
      
      
      
   process (RX_FRAMECLK_I, RX_RESET_I_N)
      --variable headerIsData_r : std_logic;
   begin
      if (RX_RESET_I_N = '0') then
            ------------------------------
            --headerIsData_r             := '0';     
            RX_ISDATA_FLAG_O    <= '0';
            ------------------------------      
            Temp_DV_O <= '0';
      elsif (rising_edge(RX_FRAMECLK_I)) then
            ------------------------------
            -- RX_ISDATA_FLAG_O    <= headerIsData_r;             
            -- headerIsData_r             := RX_ISDATA_FLAG_I;
            RX_ISDATA_FLAG_O       <= RX_ISDATA_FLAG_I;
            ------------------------------     
            Temp_DV_O <= DV_I;
      end if;
   end process;


   RX_RESET_I_N <= NOT(RX_RESET_I);

   DV_O <= Temp_DV_O;
--   RX_DATA_O <= Temp_RX_DATA_O;

END rtl;