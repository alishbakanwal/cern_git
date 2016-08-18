--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by F. Marin (CPPM) & S.Baron (CERN))   
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT pattern generator                                        
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Device agnostic                                                         
-- Tool version:                                                                            
--                                                                                                   
-- Version:               3.5                                                                      
--
-- Description:             
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--                                                                 
--                        10/05/2009   0.1       F. Marin          First .bdf entity definition           
--                                                                 
--                        07/07/2009   0.2       S. Baron          Translate from .bdf to .vhd
--                                                                 
--                        15/01/2010   0.3       S. Baron          Use of agnostic counters
--                                                                 
--                        23/06/2013   1.0       M. Barros Marin   - Cosmetic modifications
--                                                                 - Added pattern selector multiplexor
--                                                                 - Added static pattern
--                                                                 - Merged with "agnostic_21bits_counter"
--                                                                 
--                        06/08/2013   1.1       M. Barros Marin   - Added Wide-Bus extra data generation
--                                                                 
--                        12/02/2014   3.0       M. Barros Marin   - Added GBT-8b10b extra data generation
--                                                                 - Removed dynamic encoding selection
--
--                        05/10/2014   3.5       M. Barros Marin   - Added SC-IC (constant "11") & SC-EC patterns
--
--                        05/10/2014   3.6       J. Mendez         - Removed 8b10b extra data generation
--                                                                 
-- Additional Comments:                                                                               
--                                                                                                   
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_pattern_generator is  
   port (   

      --===============--
      -- Reset & Clock --
      --===============-- 
      
      -- Reset:
      ---------   
      
      RESET_I                                        : in  std_logic; 
      
      -- Clock:                                 
      ---------                           
      
      TX_FRAMECLK_I                                  : in  std_logic; 
   
      --========--                              
      -- Inputs --                              
      --========--
      
      -- Encoding:
      ------------
      
      TX_ENCODING_SEL_I                              : in  std_logic_vector( 1 downto 0);
      
      -- Test pattern:
      ----------------
      
      TEST_PATTERN_SEL_I                             : in  std_logic_vector( 1 downto 0);
      -----------------------------------------------
      STATIC_PATTERN_SCEC_I                          : in  std_logic_vector( 1 downto 0);
      STATIC_PATTERN_DATA_I                          : in  std_logic_vector(79 downto 0);
      STATIC_PATTERN_EXTRADATA_WIDEBUS_I             : in  std_logic_vector(31 downto 0);

      --=========--                             
      -- Outputs --                             
      --=========--                       
      
      -- Common data:           
      ---------------           
      
      TX_DATA_O                                     : out std_logic_vector(83 downto 0);      
       
      -- Wide-Bus extra data:          
      ----------------------- 
      
      TX_EXTRA_DATA_WIDEBUS_O                        : out std_logic_vector(31 downto 0)
      
   );
end gbt_pattern_generator;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_pattern_generator is

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--
   
   main: process(RESET_I, TX_FRAMECLK_I) 
      constant SCECCOUNTER_OVERFLOW                  : integer := 2**2;
      constant COMMONWORDCOUNTER_OVERFLOW            : integer := 2**20;
      constant WIDEBUSWORDCOUNTER_OVERFLOW           : integer := 2**16;
      variable scEcWordCounter                       : unsigned( 1 downto 0);
      variable commonWordCounter                     : unsigned(19 downto 0);
      variable widebusWordCounter                    : unsigned(15 downto 0);
   begin                                      
      if RESET_I = '1' then                          
         scEcWordCounter                             := (others => '0');
         commonWordCounter                           := (others => '0');      
         widebusWordCounter                          := (others => '0');      
         TX_DATA_O                                   <= (others => '0');
         TX_EXTRA_DATA_WIDEBUS_O                     <= (others => '0');     
      elsif rising_edge(TX_FRAMECLK_I) then 
                  
         --==========================--
         -- Internal Control (SC-IC) --
         --==========================--
         
         -- Comment: The patter is constant "11" in order to reset the SC FSM of the GBTx ASIC.
         
         TX_DATA_O(83 downto 82)                     <= "11";
         
         --=========--
         -- Counter --
         --=========--
               
         case TEST_PATTERN_SEL_I is 
         
            when "01" =>    
               -- External Control (SC-EC) counter pattern generation:
               -------------------------------------------------------               
               TX_DATA_O(81 downto 80)               <= std_logic_vector(scEcWordCounter);
               if commonWordCounter = SCECCOUNTER_OVERFLOW-1 then 
                  scEcWordCounter                    := (others => '0');
               else 
                  scEcWordCounter                    := scEcWordCounter + 1;
               end if;
               -- Common data counter pattern generation:
               ------------------------------------------
               for i in 0 to 3 loop
                  TX_DATA_O((20*i)+19 downto (20*i)) <= std_logic_vector(commonWordCounter);   
               end loop;              
               if commonWordCounter = COMMONWORDCOUNTER_OVERFLOW-1 then 
                  commonWordCounter                  := (others => '0');
               else                             
                  commonWordCounter                  := commonWordCounter + 1;
               end if;                              
               -- Wide-Bus extra data counter pattern generation:
               --------------------------------------------------
               if TX_ENCODING_SEL_I = "01" then
                  for i in 0 to 1 loop
                     TX_EXTRA_DATA_WIDEBUS_O((16*i)+15 downto (16*i)) <= std_logic_vector(widebusWordCounter);   
                  end loop;              
                  if widebusWordCounter = WIDEBUSWORDCOUNTER_OVERFLOW-1 then 
                     widebusWordCounter              := (others => '0');
                  else                          
                     widebusWordCounter              := widebusWordCounter + 1;
                  end if; 
               else
                  TX_EXTRA_DATA_WIDEBUS_O            <= (others => '0');
               end if;

            --========--
            -- Static --
            --========--      
            
            when "10" =>
               -- External Control (SC-EC) static pattern generation:
               ------------------------------------------------------
               TX_DATA_O(81 downto 80)               <= STATIC_PATTERN_SCEC_I;               
               -- Common data static pattern generation:
               -----------------------------------------               
               TX_DATA_O(79 downto 0)                <= STATIC_PATTERN_DATA_I;               
               -- Wide-Bus extra data static pattern generation:
               --------------------------------------------------               
               if TX_ENCODING_SEL_I = "01" then
                  TX_EXTRA_DATA_WIDEBUS_O            <= STATIC_PATTERN_EXTRADATA_WIDEBUS_I;  
                else
                  TX_EXTRA_DATA_WIDEBUS_O            <= (others => '0');
               end if;
            
            --==========--
            -- Disabled --
            --==========-- 
            
            when others => 
               
--               TX_DATA_O(81 downto 0)           <= (others => '0');

					TX_DATA_O(79 downto 0)                <= "101010101010" &
																  	  "101010101010" &
																	  "101010101010" &
																	  "101010101010" &
																	  "101010101010" &
																	  "101010101010" &
																	  "10101010";               
               TX_EXTRA_DATA_WIDEBUS_O          <= (others => '0'); 
               
         end case;
         
      end if;
   end process;

--=====================================================================================--
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--