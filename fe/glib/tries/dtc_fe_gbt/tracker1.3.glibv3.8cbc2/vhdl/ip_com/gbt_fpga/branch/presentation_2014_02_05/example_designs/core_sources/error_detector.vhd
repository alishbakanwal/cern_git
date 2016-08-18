--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                         
-- Company:                 CERN (PH-ESE-BE)                                                         
-- Engineer:                Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                          (Original design by Frederic MARIN (CPPM))   
--                                                                                                  
-- Project Name:            GBT-FPGA                                                                
-- Module Name:             Error detector                                        
--                                                                                                  
-- Language:                VHDL'93                                                                  
--                                                                                                    
-- Target Device:           Device agnostic                                                         
-- Tool version:                                                                         
--                                                                                                    
-- Version:                 1.1                                                                      
--
-- Description:             * This error detector checks whether there are errors in the data received as well as the ready 
--                            flag of the GBT RX does not go low after asserted for the first time during data transmission.
--                
--                          * If GBT RX ready flag equals '1', asserts DATA_ERROR_SEEN_O when an error is seen in the data.
--                
--                          * If the RX GBT ready flag goes low at some point, GBT_RX_READY_LOST_FLAG_O is also asserted until reset.
--                         
--                          * The error flags remain asserted until reset. 
--                
--                          * Note!! DATA_ERROR_SEEN_O must be reset after selecting a new pattern.
-- 
-- Versions history:        DATE         VERSION   AUTHOR             DESCRIPTION
--
--                          10/10/2008   0.1       F. Marin           - First .vhd entity definition           
--
--                          07/07/2009   0.2       S. Baron           - Cosmetic modifications
--
--                          17/06/2013   1.0       M. Barros Marin    - Only error checking when GBT RX ready                                                                    
--                                                                    - Added pattern selector multiplexor
--                                                                    - Added static pattern    
--                                                                    - Cosmetic modifications
--
--                          06/08/2013   1.1       M. Barros Marin    - Added Wide-bus extra data checking.                                                                    
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

entity error_detector is
   port(
      
      --==================--
      -- Resets and Clock --
      --==================--
      
      RESET_I                                                    : in  std_logic;
      CLK_I                                                      : in  std_logic;                
                       
      --===============--                
      -- GBT RX status --                
      --===============--                
                       
      GBT_RX_READY                                               : in std_logic;      
                    
      --===============--                
      -- RX data input --                
      --===============--                
                       
      -- Common:                
      ----------                
                       
      COMMON_DATA_I                                              : in  std_logic_vector(83 downto 0);      
                       
      -- Wide-bus extra data:               
      -----------------------               
      WIDEBUS_EXTRA_DATA_I                                       : in  std_logic_vector(31 downto 0);   
                       
      --========================--                
      -- Error detector control --                
      --========================--                
                       
      RX_ENCODING_SEL_I                                          : in  std_logic_vector( 1 downto 0);
                       
      PATTERN_SEL_I                                              : in  std_logic_vector( 1 downto 0);
      COMMON_STATIC_PATTERN_I                                    : in  std_logic_vector(83 downto 0);
      WIDEBUS_STATIC_PATTERN_I                                   : in  std_logic_vector(31 downto 0);
                       
      RESET_DATA_ERROR_SEEN_FLAG_I                               : in  std_logic;
      RESET_GBT_RX_READY_LOST_FLAG_I                             : in  std_logic;
                       
      --=======================--                 
      -- Error detector status --                 
      --=======================--                       
                       
      GBT_RX_READY_LOST_FLAG_O                                   : out std_logic;
                       
      COMMONDATA_ERROR_SEEN_FLAG_O                               : out std_logic;
      WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O                         : out std_logic
           
   );
end error_detector;
architecture behavioral of error_detector is

   --========================= Signal Declarations ==========================--  
  
   signal previousCommonWord                                     : unsigned(20 downto 0);
   signal previousWidebusWord                                    : unsigned(15 downto 0);
   
   --========================================================================--   
 
--===========================================================================--
-----        --===================================================--
begin      --================== Architecture Body ==================-- 
-----        --===================================================--
--===========================================================================--
   
   --============================= User Logic ===============================--
 
   main: process(RESET_I, RESET_DATA_ERROR_SEEN_FLAG_I, RESET_GBT_RX_READY_LOST_FLAG_I, CLK_I)   
      -- Comment: * LATENCY_DLY is a delay until the data from the pattern generator passes through the GBT Bank.     
      --          * The value of LATENCY_DLY is a random number higher that the latency of the GBT Bank. 
      constant LATENCY_DLY                                       : integer := 50;                              
      type state_T                                               is (s0_idle, s1_delay, s2_test);
      variable state                                             : state_T;   
      variable timer                                             : integer range 0 to LATENCY_DLY;
   begin                                                      
      if RESET_I = '1' then                                                   
         state                                                   := s0_idle;
         timer                                                   := 0;
         GBT_RX_READY_LOST_FLAG_O                                <= '0';   
         COMMONDATA_ERROR_SEEN_FLAG_O                            <= '0';
         WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O                      <= '0';
         previousCommonWord                                      <= (others => '0');
         previousWidebusWord                                     <= (others => '0');   
      -- Comment: DATA_ERROR_SEEN asynchronous reset:   
      elsif RESET_DATA_ERROR_SEEN_FLAG_I = '1' then     
         COMMONDATA_ERROR_SEEN_FLAG_O                            <= '0';
         WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O                      <= '0';
         state                                                   := s1_delay;
         previousCommonWord                                      <= (others => '0');   
         previousWidebusWord                                     <= (others => '0');   
      -- Comment: GBT_RX_READY_LOST_FLAG asynchronous reset:     
      elsif RESET_GBT_RX_READY_LOST_FLAG_I = '1' then   
         GBT_RX_READY_LOST_FLAG_O                                <= '0';  
         state                                                   := s1_delay;              
      elsif rising_edge(CLK_I) then
      
         -- Comment: Registers one 21bit word of the common data. This registered word        
         --          will be compared with the received data on the next clock cycle in
         --          the counter pattern error detector.
         previousCommonWord                                      <= unsigned(COMMON_DATA_I(83 downto 63));                
         previousWidebusWord                                     <= unsigned(WIDEBUS_EXTRA_DATA_I(31 downto 16));                
         
         --====================--
         -- Error detector FSM --
         --====================--
         
         case state is                 
            when s0_idle =>
               -- Comment: Waits until GBT RX ready to start after power up or general reset.                                                      
               if GBT_RX_READY = '1' then   
                  state                                          := s1_delay;               
               end if;                
            when s1_delay =>                                                                                                  
               if timer = LATENCY_DLY then                 
                  state                                          := s2_test;
                  timer                                          := 0;
               else                   
                  timer                                          := timer + 1;
               end if;               
            when s2_test => 
            
               --===========================--
               -- Checking of received data --                  
               --===========================--

               case PATTERN_SEL_I is 
                  when "01" =>
                     -- Common counter pattern error detection:
                     ------------------------------------------
                     if std_logic_vector(previousCommonWord + 1) /= COMMON_DATA_I(83 downto 63)
                        or COMMON_DATA_I(83 downto 63)           /= COMMON_DATA_I(62 downto 42)
                        or COMMON_DATA_I(83 downto 63)           /= COMMON_DATA_I(41 downto 21)
                        or COMMON_DATA_I(83 downto 63)           /= COMMON_DATA_I(20 downto 0) 
                     then               
                        COMMONDATA_ERROR_SEEN_FLAG_O             <= '1';
                     end if;
                     -- Wide-bus extra data counter pattern error detection:
                     -------------------------------------------------------
                     if RX_ENCODING_SEL_I = "01" then
                        if std_logic_vector(previousWidebusWord + 1) /= WIDEBUS_EXTRA_DATA_I(31 downto 16)
                           or WIDEBUS_EXTRA_DATA_I(31 downto 16)     /= WIDEBUS_EXTRA_DATA_I(15 downto  0)
                        then               
                           WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O    <= '1';
                        end if;
                     else
                        WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O       <= '0';
                     end if;   
                  when "10" =>
                     -- Common static patter error detection:
                     ----------------------------------------
                     if COMMON_DATA_I /= COMMON_STATIC_PATTERN_I then
                        COMMONDATA_ERROR_SEEN_FLAG_O             <= '1';
                     end if;                                          
                     -- Wide-bus static patter error detection:
                     ------------------------------------------
                     if RX_ENCODING_SEL_I = "01" then
                        if WIDEBUS_EXTRA_DATA_I /= WIDEBUS_STATIC_PATTERN_I then
                           WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O    <= '1';
                        end if;
                     else
                        WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O       <= '0';
                     end if;     
                  when others =>                      
                     -- Data error detection disabled:
                     ---------------------------------
                     COMMONDATA_ERROR_SEEN_FLAG_O                <= '0';                     
                     WIDEBUSEXTRADATA_ERROR_SEEN_FLAG_O          <= '0';
               end case;   
               
               --===============================--
               -- Checking of GBT RX ready flag --
               --===============================--               
               
               if GBT_RX_READY = '0' then   
                  GBT_RX_READY_LOST_FLAG_O                       <= '1';
               end if;               
               
         end case;        
      end if;
   end process;

--========================================================================--
end behavioral;
--=================================================================================================--
--=================================================================================================--