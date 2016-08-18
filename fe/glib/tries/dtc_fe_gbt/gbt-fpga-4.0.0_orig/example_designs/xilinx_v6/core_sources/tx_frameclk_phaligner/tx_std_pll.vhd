library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tx_std_pll is
  Port (
     MGT_REFCLK		   : in std_logic;
     TX_FRAMECLK_O      : out std_logic;
     
     RESET_I            : in std_logic;
     
     PHASE_SHIFT        : in std_logic;
     SHIFT_DONE         : out std_logic;
     
     LOCKED             : out std_logic
   );
end tx_std_pll;

architecture Behavioral of tx_std_pll is

begin

   --=====--
   -- PLL --
   --=====--
		
   pll: entity work.xlx_v6_tx_mmcm               						-- Comment: -- MMCM Configuration: -- 
      port map (                                                  --          -- M = 25              -- 
         -- Reset:                                                --          -- D = 6               --
         RESET                                  => RESET_I,       --          -- OD = 25             -- 
         -- Clock Input:                                          --          -- VCO = 1000MHz       --
         CLK_IN1                                => MGT_REFCLK,  	--          -- Shift = 17.85 ps    --              
         -- Phase Shift Control:                                  --          -------------------------
         PSCLK                                  => MGT_REFCLK,
         PSEN                                   => PHASE_SHIFT,
         PSINCDEC                               => '0',
         PSDONE                                 => SHIFT_DONE,         
         -- Pll Status:                         
         LOCKED                                 => LOCKED,
         -- Clock Outputs:                      
         CLK_OUT1                               => TX_FRAMECLK_O   -- Comment: Phase aligned 40MHz output.                          
      );
end Behavioral;
