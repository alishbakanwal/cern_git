--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by Paschalis Vichoudis (CERN))      
--                                                                                            
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Xilinx Kintex 7 & Virtex 7 - Reset                                       
--                                                                                            
-- Language:              VHDL'93                                                                  
--                                                                                              
-- Target Device:         Xilinx Kintex 7 & Virtex 7                                                      
-- Tool version:          ISE 14.5                                                                
--                                                                                              
-- Version:               3.0                                                                      
--
-- Description:        
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        22/06/2013   3.0       M. Barros Marin   First .vhd module definition           
--
-- Additional Comments:                                                                          
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

entity xlx_k7v7_reset is
   generic (   
      CLK_FREQ                                  : integer := 125e6      
   );          
   port(  
      
      --=======--
      -- Clock --
      --=======-- 
      
      CLK_I                                     : in  std_logic;
      
      --==============--     
      -- Reset scheme --     
      --==============--  
      
      RESET1_B_I                                : in  std_logic;                        
      RESET2_B_I                                : in  std_logic; 
      ------------------------------------------
      RESET_O                                   : out std_logic
      
   );
end xlx_k7v7_reset;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of xlx_k7v7_reset is

   --================================ Signal Declarations ================================--          
   
   signal rst_powerup_b                         : std_logic;
   signal rst_from_orGate                       : std_logic;
   
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   
   --================--
   -- Power up reset --
   --================--
   
   -- Comment: * This reset is used internally for resetting the dlyRstCtrl process to a known state.
   --
   --          * Note!! The SRL16 is a vendor specific primitive.
   
   rstGenSlr: srl16e
      generic map (
         INIT                                   => X"0000")   -- Comment: * 00000000000000001111111... (active low pulse)
      port map (                                              --          * See Fig.3-10. page 92, ug366      
         Q                                      => rst_powerup_b,    
         A0                                     => '1',   
         A1                                     => '1',   
         A2                                     => '1',   
         A3                                     => '1',   
         CE                                     => '1',   
         CLK                                    => CLK_I,  
         D                                      => '1'     
      );      

   --===============--
   -- Delayed reset --
   --===============--

   -- Comment: Reset OR gate for the dly_rst_ctrl process:
   rst_from_orGate                              <= (not rst_powerup_b) or (not RESET1_B_I) or (not RESET2_B_I);
   
   -- Comment: Delayed reset control process:
   dlyRstCtrl: process(rst_from_orGate, CLK_I)
      variable timer                            : integer range 0 to CLK_FREQ;
   begin       
      if rst_from_orGate = '1' then         
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

   --=====================================================================================--   
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--