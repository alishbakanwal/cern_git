----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.01.2016 09:00:47
-- Design Name: 
-- Module Name: xlx_k7v7_phalgnr_std_mmcm - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity phaligner_std_pll is
  Port (
     RX_WORDCLK_I       : in std_logic;
     RX_FRAMECLK_O      : out std_logic;
     
     RESET_I            : in std_logic;
     
     PHASE_SHIFT        : in std_logic;
     SHIFT_DONE         : out std_logic;
     
     LOCKED             : out std_logic
   );
end phaligner_std_pll;

architecture Behavioral of phaligner_std_pll is

begin

   --=====--
   -- PLL --
   --=====--
   
   pll: entity work.xlx_v6_gbt_rx_frameclk_phalgnr_mmcm           -- Comment: -- MMCM Configuration: -- 
      port map (                                                  --          -- M = 24              -- 
         -- Reset:                                                --          -- D = 6               --
         RESET                                  => RESET_I,       --          -- OD = 24             -- 
         -- Clock Input:                                          --          -- VCO = 1000MHz       --
         CLK_IN1                                => RX_WORDCLK_I,  --          -- Shift = 18.601ps    --                 
         -- Phase Shift Control:                                  --          -------------------------
         PSCLK                                  => RX_WORDCLK_I,
         PSEN                                   => PHASE_SHIFT,
         PSINCDEC                               => '0',
         PSDONE                                 => SHIFT_DONE,         
         -- Pll Status:                         
         LOCKED                                 => LOCKED,
         -- Clock Outputs:                      
         CLK_OUT1                               => RX_FRAMECLK_O   -- Comment: Phase aligned 40MHz output.                          
      );
end Behavioral;
