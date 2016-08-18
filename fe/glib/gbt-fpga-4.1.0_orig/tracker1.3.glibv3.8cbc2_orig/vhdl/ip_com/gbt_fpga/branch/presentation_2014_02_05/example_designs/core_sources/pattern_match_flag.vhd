--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                         
-- Company:                 CERN (PH-ESE-BE)                                                         
-- Engineer:                Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:            GBT-FPGA                                                                
-- Module Name:             Pattern match flag                                        
--                                                                                                 
-- Language:                VHDL'93                                                              
--                                                                                                   
-- Target Device:           Device agnostic                                                     
-- Tool version:                                                                        
--                                                                                                   
-- Version:                 1.0                                                                      
--
-- Description:             
--
--   Versions history:      DATE         VERSION   AUTHOR              DESCRIPTION
--
--                          27/06/2013   1.0       M. BARROS MARIN     - First .vhd module definition           
--
-- Additional Comments:                                                                               
--                                                                                                   
--=================================================================================================--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--

entity pattern_match_flag is
   generic (    
      PATTERN                                   : std_logic_vector(7 downto 0) := x"FF" -- 255d@40MHz == 6.375us               
   );                
   port (               
                  
      RESET_I                                   : in  std_logic;
      CLK_I                                     : in  std_logic;
      DATA_I                                    : in  std_logic_vector(83 downto 0);
      MATCHFLAG_O                               : out std_logic
      
   );
end pattern_match_flag;
architecture structural of pattern_match_flag is   

--========================================================================--
-----        --===================================================--
begin      --================== Architecture Body ==================-- 
-----        --===================================================--
--========================================================================--

   --============================ User Logic =============================--
 
   main: process(RESET_I, CLK_I)
   begin
      if RESET_I = '1' then
         MATCHFLAG_O                            <= '0';      
      elsif rising_edge(CLK_I) then    
         MATCHFLAG_O                            <= '0';
         if DATA_I(7 downto 0) = PATTERN then
            MATCHFLAG_O                         <= '1';         
         end if;   
      end if;   
   end process;  
   
   --=====================================================================--   
end structural;
--=================================================================================================--
--=================================================================================================--