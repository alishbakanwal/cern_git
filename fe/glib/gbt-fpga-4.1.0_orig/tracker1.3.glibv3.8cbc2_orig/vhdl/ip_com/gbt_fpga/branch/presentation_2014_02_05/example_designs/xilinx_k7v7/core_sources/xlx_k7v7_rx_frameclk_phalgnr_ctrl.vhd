--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                                   
-- Company:                 CERN (PH-ESE-BE)                                                         
-- Engineer:                Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org) 
--                                                                                         
-- Create Date:             05/12/2011                                                      
-- Project Name:            phase_aligner_120to40MHz_3steps                                
-- Module Name:             phase_aligner_120to40MHz_3steps                                
--                                                                                         
-- Language:                VHDL'93                                                         
--                                                                                         
-- Target Devices:          7 series                                                       
-- Tool versions:           ISE 14.5                                                        
--                                                                                         
-- Revision:                1.0                                                            
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
entity xlx_k7v7_rx_frameclk_phalgnr_ctrl is   
   port (            
      -- Reset:      
      RESET_I                                   : in std_logic;
      -- Clock Input:                  
      CLK120_I                                  : in std_logic;         
      -- Phase Shift Control:                        
      NUMBERSTEPS_I                             : in std_logic_vector(1 downto 0);
      SETNUMSTEPS_I                             : in std_logic;
      INCDEC_PHASE_I                            : in std_logic;
      DOPHASESHIFT_I                            : in std_logic;      
      -- Clock Outputs:               
      CLK40_O                                   : out std_logic;   -- Phase aligned output1   
      -- PLL Status:                     
      PLLLOCKED_O                               : out std_logic;
      PHASESHIFTDONE_O                          : out std_logic                  
   );
end xlx_k7v7_rx_frameclk_phalgnr_ctrl;
architecture structural of xlx_k7v7_rx_frameclk_phalgnr_ctrl is   
   --======================== Signal Declarations ========================--
   -- Phase shift control:         
   signal numberSteps_unsigned                  : unsigned(1 downto 0);         
   signal doPhaseShift_from_fsm                 : std_logic;      
   -- Pll status:            
   signal pllLocked_from_pll                    : std_logic;
   signal oneStepDone_from_pll                  : std_logic;
   --=====================================================================--   
--========================================================================--
-----        --===================================================--
begin      --================== Architecture Body ==================-- 
-----        --===================================================--
--========================================================================--
   --========================= Port Assignments ==========================--
   -- Control signals:      
   numberSteps_unsigned                         <= unsigned(NUMBERSTEPS_I);   
   --=====================================================================--   
   --============================ User Logic =============================--
   phaseShift_process: process(RESET_I, CLK120_I)   
      type stateT is (e0_setNumSteps, e1_waitDoPhaseShift, e2_assertDoPhaseShift, e3_waitOneStepDone, 
                      e4_phaseShiftDone);
      variable state   : stateT;                
      variable counter : integer range 0 to 840;   -- 2e2 - 1 * 280 = 840
   begin                                           -- (Each 8.333ns step needs 280 shifts (tVCO/56=29,762ps per shift))    
      if RESET_I = '1' then
         state                                  := e0_setNumSteps;
         counter                                := 0;
         doPhaseShift_from_fsm                  <= '0';   
         PHASESHIFTDONE_O                       <= '0';
      elsif rising_edge(CLK120_I) then
         -- Finite State Machine(FSM):
         case state is 
            when e0_setNumSteps =>               
               if SETNUMSTEPS_I   = '1' then
                  PHASESHIFTDONE_O              <= '0';
                  counter                       := to_integer(numberSteps_unsigned) * 280;                  
                  state                         := e1_waitDoPhaseShift;                  
               end if;               
            when e1_waitDoPhaseShift =>
               if DOPHASESHIFT_I = '1' then
                  state                         := e2_assertDoPhaseShift;   
               end if;               
            when e2_assertDoPhaseShift =>   
               doPhaseShift_from_fsm            <= '1';
               state                            := e3_waitOneStepDone;               
            when e3_waitOneStepDone =>   
               doPhaseShift_from_fsm            <= '0';
               if oneStepDone_from_pll = '1' then
                  if counter = 0 then
                     state                      := e4_phaseShiftDone;   
                  else   
                     counter                    := counter - 1;
                     state                      := e2_assertDoPhaseShift;
                  end if;
               end if;               
            when e4_phaseShiftDone =>
               PHASESHIFTDONE_O                 <= '1';
               state                            := e0_setNumSteps;                        
         end case;
         -- Registered outputs:   
         PLLLOCKED_O                            <= pllLocked_from_pll;   
      end if;   
   end process;   
   --=====================================================================--      
   --===================== Component Instantiations ======================--
   -- MMCM:                                                       -------------------------
   pll: entity work.xlx_k7v7_rx_frameclk_phalgnr_mmcm             -- MMCM Configuration: -- 
      port map (                                                  -- M = 5               -- 
         -- Reset:                                                -- D = 1               --
         RESET                                  => RESET_I,       -- OD = 15             -- 
         -- Clock Input:                                          -- VCO = 600MHz        --
         CLK_IN1                                => CLK120_I,      -- Shift = 29.762ps    --                 
         -- Phase Shift Control:                                  -------------------------
         PSCLK                                  => CLK120_I,
         PSEN                                   => doPhaseShift_from_fsm,
         PSINCDEC                               => INCDEC_PHASE_I,
         PSDONE                                 => oneStepDone_from_pll,         
         -- Pll Status:                         
         LOCKED                                 => pllLocked_from_pll,
         -- Clock Outputs:                      
         CLK_OUT1                               => CLK40_O   -- Comment: Phase aligned output1                              
      );
   --=====================================================================--   
end structural;
--=================================================================================================--
--=================================================================================================--