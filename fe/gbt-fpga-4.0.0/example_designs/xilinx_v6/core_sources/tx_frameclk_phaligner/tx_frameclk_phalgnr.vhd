----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2016 10:53:52
-- Design Name: 
-- Module Name: gbt_rx_frameclk_phalgnr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

-- Custom libraries and packages:
    use work.gbt_bank_package.all;
    use work.vendor_specific_gbt_bank_package.all;
    use work.gbt_banks_user_setup.all;
 
entity gbt_tx_frameclk_phalgnr is
   Generic (
		SHIFT_CNTER											: integer
   );
   port ( 
      
      --=======--
      -- Reset --
      --=======-- 
      RESET_I                                   : in  std_logic;
      
      --===============--
      -- Clocks scheme --
      --===============--
      MGT_REFCLK                                : in  std_logic;     
      TX_FRAMECLK_O                             : out std_logic;   -- Comment: Phase aligned 40MHz output. 
      
		--===========--
		-- Control   --
		--===========--
		
		PHASE_SHIFT_I										: in std_logic;
		
      --=========--
      -- Status  --
      --=========--
      PLL_LOCKED_O                              : out std_logic
      
   );
end gbt_tx_frameclk_phalgnr;

architecture Behavioral of gbt_tx_frameclk_phalgnr is

    signal reset_phaseshift_fsm: std_logic := '0';  
	 signal phaseShift: std_logic := '0';
	 signal shiftDone: std_logic := '0';  
            
    signal frameclock_from_pll: std_logic := '0';
    signal pllLocked_from_pll: std_logic := '0';  
    signal phaseShift_to_pll: std_logic := '0';
    signal shiftDone_from_pll: std_logic := '0';  
     
    signal cnter : integer;
	 
    type phalgnr_FSM_T is (s0_waitForWrongPhase, s1_doPhaseShift, s2_waitForDone, s3_delay);
    signal phalgnr_FSM: phalgnr_FSM_T;
	 
begin

	mmc_ctrl_inst: entity work.phaligner_mmcm_controller
		Generic map (
			 SHIFT_CNTER           => SHIFT_CNTER
		)
		Port map ( 
			 RX_WORDCLK_I          => MGT_REFCLK,
			 RESET_I               => reset_phaseshift_fsm,
			 
			 PHASE_SHIFT_TO_MMCM   => phaseShift_to_pll,
			 SHIFT_DONE_FROM_MMCM  => shiftDone_from_pll,
			 
			 PHASE_SHIFT           => PHASE_SHIFT_I,
			 SHIFT_DONE            => shiftDone
		);

	 
	 mmcm_inst: entity work.tx_std_pll
		  Port map(
			  MGT_REFCLK         => MGT_REFCLK,
			  TX_FRAMECLK_O      => frameclock_from_pll,
			  
			  RESET_I            => RESET_I,
			  
			  PHASE_SHIFT        => phaseShift_to_pll,
			  SHIFT_DONE         => shiftDone_from_pll,
			  
			  LOCKED             => pllLocked_from_pll
			);
	  
	 PLL_LOCKED_O <= pllLocked_from_pll;    
	 TX_FRAMECLK_O <= frameclock_from_pll; 
        
end Behavioral;
