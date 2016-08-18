--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by F. MARIN)   
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Patter generator                                        
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Device agnostic                                                         
-- Tool version:                                                                            
--                                                                                                   
-- Version:               1.1                                                                      
--
-- Description:             
--
-- Versions history:      DATE         VERSION   AUTHOR              DESCRIPTION
--
--                        10/05/2009   0.1       F. Marin            - First .BDF entity definition           
--
--                        07/07/2009   0.2       S. Baron            - VHDL entity
--
--                        15/01/2010   0.3       S. Baron            - Use of agnostic counters
--
--                        23/06/2013   1.0       M. Barros Marin     - Cosmetic modifications
--                                                                   - Added patter selector multiplexor
--                                                                   - Added static pattern
--                                                                   - Merged with "agnostic_21bits_counter"
--
--                        06/08/2013   1.1       M. Barros Marin     - Added Wide-bus extra data generation
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

entity pattern_generator is  
   port (   

      --===============--
      -- Reset & Clock --
      --===============-- 
      
      -- Reset:
      ---------   
      
      RESET_I                                   : in  std_logic; 
      
      -- Clock:                                           
      ---------                           
      
      CLK_I                                     : in  std_logic; 
   
      --========--                                         
      -- Inputs --                                         
      --========--                           
      
      ENCODING_SEL_I                            : in  std_logic_vector( 1 downto 0);
      
      PATTERN_SEL_I                             : in  std_logic_vector( 1 downto 0);
      COMMON_STATIC_PATTERN_I                   : in  std_logic_vector(83 downto 0);
      WIDEBUS_STATIC_PATTERN_I                  : in  std_logic_vector(31 downto 0);

      --=========--                                         
      -- Outputs --                                        
      --=========--                       
      
      -- Common data:           
      ---------------           
                  
      COMMON_DATA_O                             : out std_logic_vector(83 downto 0);      
                  
      -- Wide-bus extra data:          
      ----------------------- 
      
      WIDEBUS_EXTRA_DATA_O                      : out std_logic_vector(31 downto 0)
      
   );
end pattern_generator;
architecture behavioral of pattern_generator is

--========================================================================--
-----     --===================================================--
begin   --================== Architecture Body ==================-- 
-----     --===================================================--
--========================================================================--

--============================= User Logic ===============================--   
   
   main: process(RESET_I, CLK_I) 
      constant COMMONWORDCOUNTER_OVERFLOW       : integer := (2**21);
      constant WIDEBUSWORDCOUNTER_OVERFLOW      : integer := (2**16);
      variable commonWordCounter                : unsigned(20 downto 0);
      variable widebusWordCounter               : unsigned(15 downto 0);
   begin                 
      if RESET_I = '1' then                   
         commonWordCounter                      := (others => '0');      
         widebusWordCounter                     := (others => '0');      
         COMMON_DATA_O                          <= (others => '0');
         WIDEBUS_EXTRA_DATA_O                   <= (others => '0');  
      elsif rising_edge(CLK_I) then 
         case PATTERN_SEL_I is 
            when "01" => 
             
               --=========--
               -- Counter --
               --=========--
            
               -- Common counter pattern generation:
               -------------------------------------
               for i in 0 to 3 loop
                  COMMON_DATA_O((21*(i+1))-1 downto (21*i))  <= std_logic_vector(commonWordCounter);   
               end loop;              
               if commonWordCounter = COMMONWORDCOUNTER_OVERFLOW-1 then 
                  commonWordCounter             := (others => '0');
               else           
                  commonWordCounter             := commonWordCounter + 1;
               end if;                              
               -- Wide-bus extra data counter pattern error generation:
               --------------------------------------------------------
               if ENCODING_SEL_I = "01" then
                  for i in 0 to 1 loop
                     WIDEBUS_EXTRA_DATA_O((16*(i+1))-1 downto (16*i))   <= std_logic_vector(widebusWordCounter);   
                  end loop;              
                  if widebusWordCounter = WIDEBUSWORDCOUNTER_OVERFLOW-1 then 
                     widebusWordCounter         := (others => '0');
                  else           
                     widebusWordCounter         := widebusWordCounter + 1;
                  end if; 
               else
                  WIDEBUS_EXTRA_DATA_O          <= (others => '0');  
               end if;
               
            when "10" =>
                  
               --========--
               -- Static --
               --========--
               
               -- Common static pattern generation:
               ------------------------------------               
               COMMON_DATA_O                    <= COMMON_STATIC_PATTERN_I;               
               -- Wide-bus extra data counter pattern error generation:
               --------------------------------------------------------               
               if ENCODING_SEL_I = "01" then
                  WIDEBUS_EXTRA_DATA_O          <= WIDEBUS_STATIC_PATTERN_I;
               else
                  WIDEBUS_EXTRA_DATA_O          <= (others => '0'); 
               end if;               
               
            when others =>
            
               COMMON_DATA_O                    <= (others => '0');               
               WIDEBUS_EXTRA_DATA_O             <= (others => '0'); 
               
         end case;
      end if;
   end process;

--========================================================================--   

end behavioral;
--=================================================================================================--
--=================================================================================================--