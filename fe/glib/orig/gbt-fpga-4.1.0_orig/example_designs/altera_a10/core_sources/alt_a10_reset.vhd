--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Arria 10 - Reset 
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Altera Arria 10                                                   
-- Tool version:          Quartus II 15.0                                                                  
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--                                                                  
--                        17/03/2013   3.0       M. Barros Marin   First .vhd module definition.
--                        26/05/2015   3.0       J. Mitra   	   Modified for Arria 10
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
library alt_a10_lpm_shiftreg;
use altera.altera_primitives_components.all;   
use altera_mf.altera_mf_components.all;
use lpm.lpm_components.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity alt_a10_reset is
   generic (   
      CLK_FREQ                                  : integer := 120e6 -- Comment: (Default: 120MHz)          
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
end alt_a10_reset;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of alt_a10_reset is

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
   
   -- Comment: * This reset is used internally for resetting the dly_rst_ctrl process to a known state.
   --
   --          * The 16bit of the alt_cv_lpm_shiftreg are initialized to zeroes by default during power up.
   --
   --          * Note!! The alt_cv_lpm_shiftreg is generated with MegaWizard.
   
   rst_gen_slr: entity alt_a10_lpm_shiftreg.alt_a10_lpm_shiftreg
      port map (
         clock                                  => CLK_I,
         shiftin                                => '1',
         shiftout                               => rst_powerup_b
      );

   --===============--
   -- Delayed reset --
   --===============--

   -- Comment: Reset OR gate for the dly_rst_ctrl process:
   rst_from_orGate                              <= (not rst_powerup_b) or (not RESET1_B_I) or (not RESET2_B_I);
   
   -- Comment: Delayed reset control process:
   dlyRstCtrl: process(rst_from_orGate, CLK_I)
      variable timer                            : integer range 0 to CLK_FREQ-1 := 0;
   begin       
      if rst_from_orGate = '1' then         
         timer                                  := 0;   -- Comment: Delay = 1s
         RESET_O                                <= '1';
      elsif rising_edge(CLK_I) then       
         if timer = CLK_FREQ-1 then 
            RESET_O                             <= '0';         
         else        
            RESET_O                             <= '1';
            timer                               := timer + 1; 
         end if;
    end if;
  end process;

   --=====================================================================================--   
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--