--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                         
-- Company:                 CERN (PH-ESE-BE)                                                         
-- Engineer:                Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                  
-- Project Name:            GBT-FPGA                                                                
-- Module Name:             GBT receiver status                                        
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
--                         
--
-- Versions history:        DATE         VERSION   AUTHOR             DESCRIPTION
--
--                          07/07/2013   1.0       M. BARROS MARIN    - First .vhd entity definition   
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

entity gbt_rx_status is
   port(
      
      --==================--
      -- Resets and Clock --
      --==================--
      
      RESET_I                                   : in  std_logic;
      CLK_I                                     : in  std_logic;                
      
      --========--
      -- Inputs --
      --========--      
      
      GBT_LINK_OPTIMIZATION_I                   : in  std_logic;  
      
      DESCR_RDY_I                               : in  std_logic;  
      RX_WORDCLK_ALIGNED_I                      : in  std_logic; 
      RX_FRAMECLK_ALIGNED_I                     : in  std_logic; 
      
      --=========--
      -- Outputs --
      --=========--
      
      GBT_RX_READY_O                            : out std_logic   
      
   );
end gbt_rx_status;
architecture behavioral of gbt_rx_status is

   --========================= Signal Declarations ==========================--
   
   --===========--
   -- Registers --
   --===========--
   
   -- Rising edge detector:
   ------------------------
   
   signal dataAligned_r2                        : std_logic;
   signal dataAligned_r                         : std_logic;
   
   -- Synchronizers:
   -----------------
   
   signal rxWordClkAligned_r2                   : std_logic;
   signal rxWordClkAligned_r                    : std_logic;
      
   signal rxFrameClkAligned_r2                  : std_logic;
   signal rxFrameClkAligned_r                   : std_logic;
   
   --========================================================================--   
 
--===========================================================================--
-----        --===================================================--
begin      --================== Architecture Body ==================-- 
-----        --===================================================--
--===========================================================================--
   
   --============================= User Logic ===============================--
 
   main: process(RESET_I, CLK_I)   
      constant MAX_DELAY                        : integer := 100;
      type state_T                              is (e0_idle, e1_rxWordClkCheck, e2_delay,
                                                    e3_rxFrameClkCheck, e4_gbtRxReadyMonitoring);
      variable state                            : state_T;
      variable timer                            : integer range 0 to MAX_DELAY;
   begin                                                   
      if RESET_I = '1' then
         state                                  := e0_idle;
         ---------------------------------------
         timer                                  := 0;
         ---------------------------------------
         dataAligned_r2                         <= '0';
         dataAligned_r                          <= '0';
         ---------------------------------------
         rxWordClkAligned_r2                    <= '0';
         rxWordClkAligned_r                     <= '0';
         rxFrameClkAligned_r2                   <= '0';
         rxFrameClkAligned_r                    <= '0';
         ---------------------------------------
         GBT_RX_READY_O                         <= '0';
      elsif rising_edge(CLK_I) then          
         
         --===========--
         -- Registers --
         --===========--   
         
         -- Rising edge detector:
         ------------------------     
         dataAligned_r2                         <= dataAligned_r;  
         dataAligned_r                          <= DESCR_RDY_I;         
         
         -- Synchronizers:
         -----------------         
         
         rxWordClkAligned_r2                    <= rxWordClkAligned_r;
         rxWordClkAligned_r                     <= RX_WORDCLK_ALIGNED_I;
         rxFrameClkAligned_r2                   <= rxFrameClkAligned_r;
         rxFrameClkAligned_r                    <= RX_FRAMECLK_ALIGNED_I;
         
         --===================--
         -- GBT RX status FSM --
         --===================--

         case state is 
            when e0_idle => 
               -- Comment: Rising edge detector.
               if dataAligned_r2 = '0' and dataAligned_r = '1' then 
                  if GBT_LINK_OPTIMIZATION_I = '1' then                   
                     state                      := e1_rxWordClkCheck;
                  else
                     state                      := e4_gbtRxReadyMonitoring;                    
                  end if;
               end if;
            when e1_rxWordClkCheck =>
               if rxWordClkAligned_r2 = '1' then
                  state                         := e2_delay;
               end if;
            when e2_delay =>
               if timer = MAX_DELAY then
                  state                         := e3_rxFrameClkCheck;
                  timer                         := 0;
               else        
                  timer                         := timer + 1;                  
               end if;
            when e3_rxFrameClkCheck =>
               if rxFrameClkAligned_r2 = '1' then
                  state                         := e4_gbtRxReadyMonitoring;
               end if;
            when e4_gbtRxReadyMonitoring =>
               if    (GBT_LINK_OPTIMIZATION_I = '1' and dataAligned_r2   = '1'
                                                    and rxWordClkAligned_r2  = '1'
                                                    and rxFrameClkAligned_r2 = '1') 
                     --------------------------------------------------------                             
                  or (GBT_LINK_OPTIMIZATION_I = '0' and dataAligned_r2   = '1')
                                                  
               then
                  GBT_RX_READY_O                <= '1';
               else        
                  state                         := e0_idle;
                  GBT_RX_READY_O                <= '0';              
               end if;       
         end case;

      end if;
   end process;

--========================================================================--
end behavioral;
--=================================================================================================--
--=================================================================================================--