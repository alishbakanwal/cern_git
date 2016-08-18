--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                         
-- Company:                 CERN (PH-ESE-BE)                                                         
-- Engineer:                Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                          (Original design by Paschalis Vichoudis)      
--                                                                                                 
-- Project Name:            GBT-FPGA                                                                
-- Module Name:             Xilinx Virtex 6 reset                                       
--                                                                                                 
-- Language:                VHDL'93                                                                  
--                                                                                                   
-- Target Device:           Xilinx Virtex 6                                                       
-- Tool version:            ISE 14.5                                                                
--                                                                                                   
-- Version:                 1.0                                                                      
--
-- Description:             
--
-- Versions history:        DATE         VERSION   AUTHOR              DESCRIPTION
--
--                          22/06/2013   1.0       M. BARROS MARIN     - First .vhd module definition           
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

entity xlx_v6_reset is
   generic (
   
      CLK_FREQ                                  : integer := 125e6 -- Comment: (Default: 125MHz)
                  
   );                      
   port(             
               
      CLK_I                                     : in  std_logic;
      RESET1_B_I                                : in  std_logic;                        
      RESET2_B_I                                : in  std_logic;                        
      RESET_O                                   : out std_logic
      
   );
end xlx_v6_reset;
architecture behavioral of xlx_v6_reset is

   --======================== Signals Declarations ==========================-- 
   
   signal rst_powerup_b                         : std_logic;
   signal rst_from_or_gate                      : std_logic;
   
   --========================================================================--

--===========================================================================--
-----         --===================================================--
begin       --================== Architecture Body ==================-- 
-----         --===================================================--
--===========================================================================--
   
   --============================= User Logic ===============================--
   
   --================--
   -- Power up reset --
   --================--
   
   -- Comment: * This reset is used internally for reseting the dly_rst_ctrl process to a known state.
   --
   --          * Note!! The SRL16 is a vendor specific primitive.

   rst_gen_slr: srl16
      generic map (
         INIT                                   => x"0000")   -- Comment: * 00000000000000001111111... (active low pulse)
      port map (                                              --          * See Fig.3-10. page 92, ug366      
         A0                                     => '1',
         A1                                     => '1',
         A2                                     => '1',
         A3                                     => '1',
         CLK                                    => CLK_I,
         D                                      => '1',
         Q                                      => rst_powerup_b
      );

   --===============--
   -- Delayed reset --
   --===============--
      
   -- Comment: Reset OR gate for the dly_rst_ctrl process:
   rst_from_or_gate <= (not rst_powerup_b) or (not RESET1_B_I) or (not RESET2_B_I);
   
   -- Comment: Delayed reset control process:
   dly_rst_ctrl: process(CLK_I, rst_from_or_gate)
      variable timer                            : integer range 0 to CLK_FREQ;
   begin       
      if rst_from_or_gate = '1' then         
         timer                                  := CLK_FREQ; -- Comment: Delay = 1s
         RESET_O                                <= '1';
      elsif rising_edge(CLK_I) then       
         if timer > 0 then       
           timer                                := timer - 1;
           RESET_O                              <= '1';
         else        
           RESET_O                              <= '0';
         end if;
    end if;
  end process;

--========================================================================--
end behavioral;
--=================================================================================================--
--=================================================================================================--