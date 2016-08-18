--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Xilinx Virtex 6 - GBT RX_FRAMECLK phase aligner control      
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Xilinx Virtex 6                                                   
-- Tool version:          ISE 14.5                                                                   
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--                                                                  
--                        21/06/2013   3.0       M. Barros Marin   First .vhd module definition.
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

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

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
      
      NUMBERSTEPS_I                             : in std_logic_vector(2 downto 0);
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
      constant NUM_SHIFTS                       : integer := 224;
      constant PHASESHIFT_DONE_DLY              : integer := 300;   -- Comment: Delay to ensure that the PLL output is stable after phase shift.
      ------------------------------------------
      type stateT                               is (e0_setNumSteps, e1_waitDoPhaseShift, e2_assertDoPhaseShift, e3_waitOneStepDone, 
                                                    e4_phaseShiftDoneDly, e5_phaseShiftDone);
      variable state                            : stateT;                
      ------------------------------------------
      variable counter                          : integer range 0 to 1568;  -- Comment: (2e3 - 1) * 224 = 840
      begin                                                                 --          (Each 4.167ns step needs 224 shifts (Tvco/56 = 18,601ps per shift))    
      if RESET_I = '1' then
         state                                  := e0_setNumSteps;
         counter                                := 0;
         doPhaseShift_from_fsm                  <= '0';   
         PHASESHIFTDONE_O                       <= '0';
      elsif rising_edge(RX_WORDCLK_I) then

         -- Finite State Machine (FSM):
         ------------------------------      
      
         case state is 
            when e0_setNumSteps =>               
               if SETNUMSTEPS_I   = '1' then
                  PHASESHIFTDONE_O              <= '0';
                  counter                       := to_integer(unsigned(NUMBERSTEPS_I)) * NUM_SHIFTS;                  
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
                     state                      := e4_phaseShiftDoneDly; 
                     counter                    := PHASESHIFT_DONE_DLY;
                  else   
                     counter                    := counter - 1;
                     state                      := e2_assertDoPhaseShift;
                  end if;
               end if;    
            when e4_phaseShiftDoneDly =>
               if counter = 0 then
                  state                         := e5_phaseShiftDone;   
               else   
                  counter                       := counter - 1;
               end if;
            when e5_phaseShiftDone =>
               PHASESHIFTDONE_O                 <= '1';
               state                            := e0_setNumSteps;                        
         end case;
         
         PLLLOCKED_O                            <= pllLocked_from_pll;  
         
      end if;   
   end process;  

   --=====--
   -- PLL --
   --=====--
   
   pll: entity work.xlx_v6_gbt_rx_frameclk_phalgnr_mmcm               -- Comment: -- MMCM Configuration: -- 
      port map (                                                  --          -- M = 8               -- 
         -- Reset:                                                --          -- D = 2               --
         RESET                                  => RESET_I,       --          -- OD = 24             -- 
         -- Clock Input:                                          --          -- VCO = 960MHz        --
         CLK_IN1                                => RX_WORDCLK_I,  --          -- Shift = 18.601ps    --                 
         -- Phase Shift Control:                                  --          -------------------------
         PSCLK                                  => RX_WORDCLK_I,
         PSEN                                   => doPhaseShift_from_fsm,
         PSINCDEC                               => INCDEC_PHASE_I,
         PSDONE                                 => oneStepDone_from_pll,         
         -- Pll Status:                         
         LOCKED                                 => pllLocked_from_pll,
         -- Clock Outputs:                      
         CLK_OUT1                               => RX_FRAMECLK_O   -- Comment: Phase aligned 40MHz output.                          
      );
      
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--