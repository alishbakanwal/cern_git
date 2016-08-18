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
--  ENTITY              :       PATTERN_SEARCH.VHD              
--  VERSION             :       0.3                                             
--  VENDOR SPECIFIC?    :       NO
--  FPGA SPECIFIC?      :       NO
--  CREATION DATE       :       01/10/2008
--  LAST UPDATE         :       02/11/2010  
--  AUTHORs             :       Steffen MUSCHTER (Stockholm University), Frederic MARIN (CPPM)
--  LANGAGE             :       VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--      DESCRIPTION     :       Searches 4-bits header pattern in the 4 LSB of a 120-bits word. The MSB of the header being the
--                              bit 0 and its LSB the bit 3. The header pattern can be the idle or data header pattern.
--                              If more than "Nb_Accepted_False_Header" are found in "Nb_Checked_Header" checked header, a bit slip
--                              command is sent and the locked state is set low.        If more than "Desired_Consec_Correct_Headers"
--                              correct consecutive headers are found, the locked state is proclaimed.
---------------------------------------------------------------------------------------------------------------------------------
--      VERSIONS HISTORY        :
--      DATE                    VERSION                 AUTHOR          DESCRIPTION
--      01/10/2008              0.1                     MARIN           first .vhd entity definition           
--      07/04/2009              0.2                     MARIN           modif
--      02/11/2010              0.3                     MUSCHTER        the dataflow and counters were optimized for low latency
---------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.Constant_Declaration.all;  -- For the use of the following constants:
-- Nb_Checked_Header
-- Data_Header_Pattern_Reversed
-- Idle_Header_Pattern_Reversed
-- Nb_Accepted_False_Header
-- Desired_Consec_Correct_Headers

---------------------------------------------------------------------- 
---------------------------------------------------------------------- 

entity Pattern_Search is
  port(
    Reset               : in std_logic;
    Clock               : in std_logic;
    Word_In             : in std_logic_vector(19 downto 0);
    GX_Alignment_Status : in std_logic;
    Write_Address_In    : in std_logic_vector(5 downto 0);
	 
	 Header_Flag       : out std_logic;
    Bit_Slip_Cmd      : out std_logic;
    Word_Out          : out std_logic_vector(19 downto 0);
    Write_Address_Out : out std_logic_vector(5 downto 0);
    Locked            : out std_logic
    );  

end Pattern_Search;

---------------------------------------------------------------------- 
---------------------------------------------------------------------- 


architecture a of Pattern_Search is
  
  signal Consec_Correct_Headers : integer range 0 to Desired_Consec_Correct_Headers;
  signal False_Header           : integer range 0 to Nb_Accepted_False_Header+1;
  signal Checked_Header         : integer range 0 to Nb_Checked_Header;
  signal s_Locked               : std_logic;
  signal s_Write_Address        : integer range 0 to 63;

---------------------------------------------------------------------- 
  
begin

  Locked            	<= s_Locked;
  Write_Address_Out 	<= conv_std_logic_vector(s_Write_Address,6);
  Word_Out          	<= Word_In;

  process (Reset, Clock, GX_Alignment_Status)
		variable acceptheader :	std_logic;
  begin
    
   if Reset = '1' or GX_Alignment_Status = '0' then
      Bit_Slip_Cmd           <= '0';
      Consec_Correct_Headers <= 0;
      False_Header           <= 0;
      Checked_Header         <= 0;
      s_Locked               <= '0';
      s_Write_Address        <= 1;
      acceptheader			  := '0';
   elsif RISING_EDGE(Clock) then
      
		case s_Write_Address is
			when 5  => 			s_Write_Address <=  8;	 		
			when 13 => 			s_Write_Address <= 16;	
			when 21 => 			s_Write_Address <= 24;
			when 29 => 	   	s_Write_Address <= 32;
			when 37 => 	   	s_Write_Address <= 40;
			when 45 => 	   	s_Write_Address <= 48;
			when 53 => 	   	s_Write_Address <= 56;
			when 61 => 	   	s_Write_Address <=  0;
			when others => 	s_Write_Address <= s_Write_Address+1;
		end case;
		---- for 20b: addr -> 0,1,2,3,4,5 - 8,9,10,11,12,13 - 16,17,18,19,20,21 - 24,25,26,27,28,29 ... 56,57,58,59,60,61
		
		Header_Flag		<= '0';
		
		if write_address_in(2 downto 0)= "000" then  -- Corresponds to MSB part (first word of 40bits)
																	-- True every 6 clock cycles (because we don't write address 4)
																	-- done to read every 120 bits
																	-- This runs in fact @240MHz/6 = 40MHz
		
		   -- Counter of false headers among a certain number of checked headers
		   if Checked_Header <= Nb_Checked_Header-1 then
				Checked_Header <= Checked_Header + 1;
				if (Word_In(3 downto 0) /= Data_Header_Pattern_Reversed and Word_In(3 downto 0) /= Idle_Header_Pattern_Reversed) then
					if False_Header <= Nb_Accepted_False_Header then
						False_Header <= False_Header + 1;
--					else
--						acceptheader	:= '0';
					end if;
				end if;
			else
				Checked_Header <= 0;
				False_Header   <= 0;
		   end if;			

		   -- Counters of consecutive correct headers
			if (Word_In(3 downto 0) = Data_Header_Pattern_Reversed or Word_In(3 downto 0) = Idle_Header_Pattern_Reversed) then
--				if acceptheader = '1' then
--					Header_Flag	<= '1';
--				end if;	
				if s_Locked = '1' then
					Header_Flag	<= '1';
				end if;	
				if Consec_Correct_Headers < Desired_Consec_Correct_Headers then
				   Consec_Correct_Headers <= Consec_Correct_Headers + 1;
				else	
					acceptheader	:= '1';			
--					null;  -- Consec_Correct_Headers stays to Desired_Consec_Correct_Headers
				end if;
		   else
--				headerFound	<= '0';			
				Consec_Correct_Headers <= 0;
		   end if;			

		   -- Out Of Lock or In Lock state decision
		   if s_Locked = '0' and Consec_Correct_Headers = Desired_Consec_Correct_Headers then  -- Goes from OOL to IL
			   s_Locked        <= '1';
			   s_Write_Address <=  1;  			-- To write the first correct data @ address "00000"
															-- This assignment crushes the one done line 76
			elsif s_Locked = '1' and False_Header >= Nb_Accepted_False_Header then  -- Return from IL to OOL
				s_Locked <= '0';
															-- nothing done on the write address there since the locked signal is de-asserted
		   end if;
		  
		end if;

		-- Sending slip cmd
		if False_Header = Nb_Accepted_False_Header+1 then
		  Bit_Slip_Cmd   <= '1';
		  False_Header   <= 0;
		  Checked_Header <= 0;
		else
		  Bit_Slip_Cmd <= '0';
		end if;
      
   end if;
   end process;

end a;
