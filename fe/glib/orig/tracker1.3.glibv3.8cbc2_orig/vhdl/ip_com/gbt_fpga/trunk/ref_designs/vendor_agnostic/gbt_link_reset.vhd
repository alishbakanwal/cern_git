--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                         
-- Company:                CERN (PH-ESE-BE)                                                         
-- Engineer:               Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                         (Original design by Paschalis Vichoudis)   
--                                                                                                 
-- Project Name:           GBT-FPGA                                                                
-- Module Name:            GBT Link reset                                       
--                                                                                                 
-- Language:               VHDL'93                                                                  
--                                                                                                   
-- Target Device:          Device agnostic                                                         
-- Tool version:                                                                             
--                                                                                                   
-- Version:                  1.1                                                                      
--
-- Description:            
--
-- Versions history:       DATE         VERSION   AUTHOR            DESCRIPTION
--
--                         17/06/2013   1.0       M. BARROS MARIN   - First .vhd module definition           
--
--                         23/06/2013   1.1       M. BARROS MARIN   - Cosmetic modifications
--
-- Additional Comments:                                                                               
--                                                                                                   
--=================================================================================================--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--

entity gbt_link_reset is   
   generic( 
      
      RX_INIT_FIRST                             : boolean := false;
      INITIAL_DELAY                             : natural := 1   * 40e6; -- 1s    @ 40MHz    
      TIME_N                                    : natural := 1   * 40e5; -- 100ms @ 40MHz
      GAP_DELAY                                 : natural := 3   * 40e6  -- 3s    @ 40MHz
         
   ); 
   port(    
      
      -- Clock:   
      CLK_I                                     : in  std_logic;
      -- Reset:               
      RESET_I                                   : in  std_logic;   
      -- Reset outputs: 
      MGT_TXRESET_O                             : out std_logic;       
      MGT_RXRESET_O                             : out std_logic;    
      GBT_TXRESET_O                             : out std_logic;   
      GBT_RXRESET_O                             : out std_logic;   
      -- Control: 
      BUSY_O                                    : out std_logic;   
      DONE_O                                    : out std_logic 
      
   );
end gbt_link_reset;
architecture behavioral of gbt_link_reset is      

--========================================================================--
-----        --===================================================--
begin      --================== Architecture Body ==================-- 
-----        --===================================================--
--========================================================================--

-- Comment:
--
-- TIMING DIAGRAM:
--                                                    .
--                                                    .                                 |                   |                        
--                        +-----------------------------------------------------------..+                   +..---------------------------------------+
--  BUSY_O                |                           .                                 |                   |                                         |                                                                                                                         |  
--                  ...---+                           .                                 |                   |                                         +------------------...                                                                                                                                                                                                                                                   +------
--                                                    .                                 |                   | 
--                                                    .                                 |                   |                                         +------------------...                                                                                                                           +------
--  DONE_O                                            .                                 |                   |                                         |                                                                                                                           |
--                  ...---------------------------------------------------------------..+                   +..---------------------------------------+
--                                                    .                                 |                   |      
--                  ...-------------------------------+                                 |                   | 
--  MGT_TXRESET_O                                     |                                 |                   |                      
--                                                    +-------------------------------..+                   +..----------------------------------------------------------...
--                                                    .                                 |                   |                      
--                  ...--------------------------------------------------------------+  |                   |                      
--  GBT_TXRESET_O                                     .                              |  |                   |                      
--                                                    .                              +..+                   +..----------------------------------------------------------...
--                                                    .                                 |                   |
--                                                    .                                 |                   |                      
--                  ...---------------------------------------------------------------..+                   +..+                                         
--  MGT_RXRESET_O                                     .                                 |                   |  |   
--                                                    .                                 |                   |  +---------------------------------------------------------...
--                                                    .                                 |                   |                      
--                  ...---------------------------------------------------------------..+                   +..--------------------------------+
--  GBT_RXRESET_O                                     .                                 |                   |                                  |  
--                                                    .                                 |                   |                                  +-------------------------...
--                                                    .                                 |                   |                                                    
--                                                    .                                 |     GAP_DELAY     | 
--                                                    .                                 |                   |
--  * TIME *                                          .                                 |  <=====/  /====>  |           
-- -----------------------+---------------------------+------------------------------+..+                   +..+-------------------------------+-------------------------...
--                        time = -(INITIAL_DELAY)     time = 0                       time = n                  time = n + GAP_DELAY            time = 2n + GAP_DELAY        
--
--                        
--========================================================================================================================================================================--   

   --============================ User Logic =============================--
   
   resetControlFsm: process(RESET_I, CLK_I)   
      type stateT is (s0_idle, s1_deassertGtxTxReset, s2_deassertGbtTxReset,
                      s3_deassertGtxRxReset, s4_deassertGbtRxReset, s5_done);
      variable state                            : stateT;      
      variable timer                            : integer range 0 to (INITIAL_DELAY + GAP_DELAY);   -- Comment: This value is not used but ensures a good constraint if GAP_DELAY = 0   
   begin
      if RESET_I = '1' then
         state                                  := s0_idle;
         timer                                  := 0;   
         MGT_TXRESET_O                          <= '1';         
         GBT_TXRESET_O                          <= '1';   
         MGT_RXRESET_O                          <= '1';         
         GBT_RXRESET_O                          <= '1';   
         BUSY_O                                 <= '0';
         DONE_O                                 <= '0';
      elsif rising_edge(CLK_I) then      
         case state is
            when s0_idle =>                                                  
               BUSY_O                           <= '1';                     -- Comment: time = (-initial delay)
               DONE_O                           <= '0';   
               if timer = INITIAL_DELAY-1 then                              -- Comment: time = 0   
                  state                         := s1_deassertGtxTxReset;
                  timer                         := 0; 
                  MGT_TXRESET_O                 <= '0';                  
                  GBT_TXRESET_O                 <= '1';
                  MGT_RXRESET_O                 <= '1';   
                  GBT_RXRESET_O                 <= '1';   
               else      
                  timer                         := timer + 1;
               end if;   
            when s1_deassertGtxTxReset =>         
               if timer = TIME_N then                                       -- Comment: time = n   
                  state                         := s2_deassertGbtTxReset;
                  timer                         := 0;                      
                  MGT_TXRESET_O                 <= '0';                     
                  GBT_TXRESET_O                 <= '0';   
                  MGT_RXRESET_O                 <= '1';                     
                  GBT_RXRESET_O                 <= '1';                      
               else
                  timer                         := timer + 1;
               end if;            
            when s2_deassertGbtTxReset =>                                      
               if timer = GAP_DELAY then                                    -- Comment: time = n + GAP_DELAY           
                  state                         := s3_deassertGtxRxReset;   
                  timer                         := 0;                
                  MGT_TXRESET_O                 <= '0';                     
                  GBT_TXRESET_O                 <= '0';   
                  MGT_RXRESET_O                 <= '0';               
                  GBT_RXRESET_O                 <= '1';                     
               else      
                  timer                         := timer + 1;
               end if;                             
            when s3_deassertGtxRxReset =>   
               if timer = TIME_N then                                         -- Comment: time = 2n + GAP_DELAY               
                  state                         := s4_deassertGbtRxReset; 
                  timer                         := 0;                              
                  MGT_TXRESET_O                 <= '0';                     
                  GBT_TXRESET_O                 <= '0';   
                  MGT_RXRESET_O                 <= '0';                  
                  GBT_RXRESET_O                 <= '0';                  
               else
                  timer                         := timer + 1;
               end if;
            when s4_deassertGbtRxReset =>         
                  state                         := s5_done; 
                  BUSY_O                        <= '0';
                  DONE_O                        <= '1';
            when s5_done =>         
               null;                                             
         end case;
      end if;
   end process;      
   
   --=====================================================================--
end behavioral;
--=================================================================================================--
--=================================================================================================--