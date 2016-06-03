--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GLIB - GLIB system core emulation                                      
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         GLIB (Xilinx Virtex 6)                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Version:               1.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/08/2013   1.0       M. Barros Marin   - First .vhd module definition           
--
-- Additional Comments:         
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Link are set through:                               !!  
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Link module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_link_package.vhd").                                !!  
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<hardware_platform>_gbt_link_user_setup.vhd".   !!
-- !!                                                                                           !!
-- !!   (Note!! These parameters are vendor specific).                                          !!                    
-- !!                                                                                           !! 
-- !! * The "<hardware_platform>_gbt_link_user_setup.vhd" is the only file of the GBT Link that !!
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

entity glib_system_core_emu is   
   port (   
      
      --===============--
      -- General reset --
      --===============--      
     
      FPGA_POWER_ON_RESET_B                     : in  std_logic;
      
      USER_RESET_O                              : out std_logic;
            
      --=======================--      
      -- GLIB control & status --      
      --=======================--      
            
      -- Crosspoint Switch 1 control:     
      -------------------------------           
      
      XPOINT1_S10                               : out std_logic;
      XPOINT1_S11                               : out std_logic;
      XPOINT1_S30                               : out std_logic;
      XPOINT1_S31                               : out std_logic;
            
      -- CDCE62005 control & status:      
      ------------------------------      
            
      CDCE_PWR_DOWN                             : out std_logic;   
      CDCE_REF_SEL                              : out std_logic;   
      CDCE_SYNC                                 : out std_logic;   
      CDCE_PLL_LOCK                             : in  std_logic;
     
      --=============================--
      -- System fabric clock (40MHz) --
      --=============================--
            
      PRI_CLK_P                                 : in  std_logic;
      PRI_CLK_N                                 : in  std_logic
      
   );
end glib_system_core_emu;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of glib_system_core_emu is
   
   --================================ Signal Declarations ================================--
   
   --===============--
   -- General reset --
   --===============--
   
   signal reset_from_rst                        : std_logic;    
   
   --=============================--
   -- System fabric clock (40MHz) --
   --=============================--
 
   signal pri_clk                               : std_logic;
  
   --=====================================================================================--   

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   
   --===============--
   -- Clock buffers -- 
   --===============--   

   -- Fabric clock (40MHz):
   ------------------------       
   
   pri_clk_ibufgds: IBUFGDS
      generic map (
         IBUF_LOW_PWR                           => FALSE,
         IOSTANDARD                             => "LVDS_25")
      port map (                 
         O                                      => pri_clk,
         I                                      => PRI_CLK_P,
         IB                                     => PRI_CLK_N
      );
      
   --===============--
   -- General reset -- 
   --===============-- 
   
   rst: entity work.xlx_v6_reset
      port map (
         CLK_I                                  => pri_clk,
         RESET1_B_I                             => FPGA_POWER_ON_RESET_B, 
         RESET2_B_I                             => '1',
         RESET_O                                => reset_from_rst 
      );

   USER_RESET_O                                 <= reset_from_rst;
   
   --==============--
   -- GLIB control --
   --==============--
   
   -- XPOINT1 control:
   -------------------
   
   -- Comment: The clock signal from the 40MHz crystal oscillator QZ2 is forwarded to the FPGA through
   --          XPOINT1_CLK1 (pri_clk) (system) and XPOINT1_CLK3 (usr). 
   
   XPOINT1_S10                                  <= '0'; -- Comment: XPOINT_4X4 OUT_1 is driven by IN_2.
   XPOINT1_S11                                  <= '1'; --               
   
   XPOINT1_S30                                  <= '0'; -- Comment: XPOINT_4X4 OUT_3 is driven by IN_2.
   XPOINT1_S31                                  <= '1'; --            
   
   -- CDCE62005 synchronizer:
   --------------------------

   -- Comment: The clock synthesizer CDCE62005 is reset and synchronized with PRI_CLK after power up.
   
   cdceSync: entity work.cdce_synchronizer
      port map (
         RESET_I                                => reset_from_rst, 
         ---------------------------------------                     
         IPBUS_CTRL_I                           => '0',              -- Comment: * Control by USER
         IPBUS_SEL_I                            => '1',              --          * CDCE62005 PRI_REF *NOT USED*
         IPBUS_PWRDOWN_I                        => '1',              --          * Active low        *NOT USED*
         IPBUS_SYNC_I                           => '1',              --          * Active low        *NOT USED*
         ---------------------------------------                     --       
         USER_SEL_I                             => '1',              --          * CDCE62005 PRI_REF
         USER_SYNC_I                            => '1',              --          * Active low    
         USER_PWRDOWN_I                         => '1',              --          * Active low    
         ---------------------------------------                     --          
         PRI_CLK_I                              => pri_clk,          --          * 40MHz
         SEC_CLK_I                              => '0',              --          * *NOT USED*
         ---------------------------------------      
         PWRDOWN_O                              => CDCE_PWR_DOWN,
         SYNC_O                                 => CDCE_SYNC,
         REF_SEL_O                              => CDCE_REF_SEL,
         PLL_LOCK_I                             => CDCE_PLL_LOCK,
         ---------------------------------------      
         SYNC_CLK_O                             => open,
         SYNC_CMD_O                             => open,
         SYNC_BUSY_O                            => open,
         SYNC_LOCK_O                            => open,
         SYNC_DONE_O                            => open
      );   
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--