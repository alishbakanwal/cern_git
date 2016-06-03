--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Cyclone V GT - GBT RX_FRAMECLK phase aligner control    
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Altera Cyclone V GT                                                   
-- Tool version:          Quartus II 13.1                                                                  
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--                                                                  
--                        11/01/2014   3.0       M. Barros Marin   First .vhd module definition.
--
-- Additional Comments:  
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!   (Note!! These parameters are vendor specific)                                           !!                    
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_bank_package.vhd").                                !! 
-- !!     (e.g. xlx_v6_gbt_bank_package.vhd)                                                    !!
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<vendor>_<device>_gbt_bank_user_setup.vhd".     !!
-- !!     (e.g. xlx_v6_gbt_bank_user_setup.vhd)                                                 !! 
-- !!                                                                                           !! 
-- !! * The "<vendor>_<device>_gbt_bank_user_setup.vhd" is the only file of the GBT Bank that   !!
-- !!   may be modified by the user. The rest of the files MUST be used as is.                  !!
-- !!                                                                                           !!  
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                                                                                                   
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Altera devices library:
library altera; 
library altera_mf;
library lpm;
use altera.altera_primitives_components.all;   
use altera_mf.altera_mf_components.all;
use lpm.lpm_components.all;

-- Libraries for direct instantiation:
library alt_cv_gbt_rx_frameclk_phalgnr_pll;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_rx_frameclk_phalgnr_ctrl is   
   port (  
   
      --=======--
      -- Reset --
      --=======--     
   
      RESET_I                                   : in std_logic;
      
      --===============--
      -- Clocks scheme --
      --===============--                
      
      RX_WORDCLK_I                              : in std_logic;         
      RX_FRAMECLK_O                             : out std_logic;   -- Comment: Phase aligned 40MHz output. 
      
      --=========--
      -- Control --
      --=========--                        
      
      NUMBERSTEPS_I                             : in std_logic_vector(1 downto 0);
      SETNUMSTEPS_I                             : in std_logic;
      INCDEC_PHASE_I                            : in std_logic;
      DOPHASESHIFT_I                            : in std_logic;      
      ------------------------------------------
      PLLLOCKED_O                               : out std_logic;
      PHASESHIFTDONE_O                          : out std_logic 
      
   );
end gbt_rx_frameclk_phalgnr_ctrl;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_rx_frameclk_phalgnr_ctrl is 
  
   --================================ Signal Declarations ================================--
   
   signal doPhaseShift_from_fsm                 : std_logic;      
   ---------------------------------------------
   signal pllLocked_from_pll                    : std_logic;
   signal oneStepDone_from_pll_r2               : std_logic;
   signal oneStepDone_from_pll_r                : std_logic;
   signal oneStepDone_from_pll                  : std_logic;
   
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--

   --=========--
   -- Control --
   --=========--

   main: process(RESET_I, RX_WORDCLK_I)   
      type stateT is (e0_setNumSteps, e1_waitDoPhaseShift, e2_countCheck, e3_assertDoPhaseShift, 
                      e4_waitOneStepDone, e5_waitDoneHigh, e6_phaseShiftDone);
      variable state                            : stateT;                
      variable counter                          : integer range 0 to 2*48;   -- Comment: Max. number of shifts
   begin                                                                     --          (Each 8.333ns step needs 48 shifts (tVCO/8=1.388ns/8=173.611ps per shift))    
      if RESET_I = '1' then
         state                                  := e0_setNumSteps;
         counter                                := 0;
         doPhaseShift_from_fsm                  <= '0';   
         oneStepDone_from_pll_r2                <= '1';   
         oneStepDone_from_pll_r                 <= '1';   
         PHASESHIFTDONE_O                       <= '0';
      elsif rising_edge(RX_WORDCLK_I) then

         -- Synchronizer:
         ----------------
         
         oneStepDone_from_pll_r2 <= oneStepDone_from_pll_r; oneStepDone_from_pll_r <= oneStepDone_from_pll;

         -- Finite State Machine (FSM):
         ------------------------------
         
         case state is 
            when e0_setNumSteps =>               
               if SETNUMSTEPS_I   = '1' then
                  PHASESHIFTDONE_O              <= '0';
                  counter                       := to_integer(unsigned(NUMBERSTEPS_I)) * 48;                  
                  state                         := e1_waitDoPhaseShift; 
               end if;               
            when e1_waitDoPhaseShift =>
               if DOPHASESHIFT_I = '1' then
                  state                         := e2_countCheck;   
               end if;   
            when e2_countCheck =>                 
               if counter = 0 then
                  PHASESHIFTDONE_O              <= '1';
                  state                         := e6_phaseShiftDone;   
               else       
                  counter                       := counter - 1;
                  state                         := e3_assertDoPhaseShift;                
               end if;
            when e3_assertDoPhaseShift =>   
                  doPhaseShift_from_fsm         <= '1';
                  state                         := e4_waitOneStepDone;               
            when e4_waitOneStepDone =>   
               if (oneStepDone_from_pll_r2 = '1') and (oneStepDone_from_pll_r = '0') then
                  doPhaseShift_from_fsm         <= '0';
                  state                         := e5_waitDoneHigh; 
               end if;
            when e5_waitDoneHigh =>
               if (oneStepDone_from_pll_r2 = '0') and (oneStepDone_from_pll_r = '1') then
                  state                         := e2_countCheck;
               end if;            
            when e6_phaseShiftDone =>
               null;           
         end case;

         PLLLOCKED_O                            <= pllLocked_from_pll;   

         end if;   
   end process; 
   
   --=====--
   -- PLL --                                                         
   --=====--
   
   pll: entity alt_cv_gbt_rx_frameclk_phalgnr_pll.alt_cv_gbt_rx_frameclk_phalgnr_pll                                               
      port map (                                                                                      -- Comment: -- PLL Configuration: -- 
         REFCLK                                 => RX_WORDCLK_I,                                      --          -- N = 1              -- 
         RST                                    => RESET_I,                                           --          -- M = 6              --
         OUTCLK_0                               => RX_FRAMECLK_O,  -- Comment: Phase aligned output   --          -- C = 18             -- 
         LOCKED                                 => pllLocked_from_pll,                                --          -- VCO = 720MHz       --         
         PHASE_EN                               => doPhaseShift_from_fsm,                             --          -- Shift = 173.6ps    --  
         SCANCLK                                => RX_WORDCLK_I,                                      --          ------------------------
         UPDN                                   => INCDEC_PHASE_I,                 
         CNTSEL                                 => "00000",
         PHASE_DONE                             => oneStepDone_from_pll
      );
      
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--