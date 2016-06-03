--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GLIB - GLIB GBT example design                                     
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         GLIB (Xilinx Virtex 6)                                                         
-- Tool version:          ISE 14.5                                                                
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        04/08/2013   3.0       M. Barros Marin   - First .vhd module definition           
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

entity glib_gbt_example_design is   
   port (   

      --===============--
      -- General reset --
      --===============--      
     
      FPGA_POWER_ON_RESET_B                     : in  std_logic;

      --==============--      
      -- GLIB control --      
      --==============--      

      -- Crosspoint Switch 1:     
      -----------------------           
      
      XPOINT1_S10                               : out std_logic;
      XPOINT1_S11                               : out std_logic;
      XPOINT1_S30                               : out std_logic;
      XPOINT1_S31                               : out std_logic;

      -- CDCE62005:      
      -------------      

      CDCE_PWR_DOWN                             : out std_logic;   
      CDCE_REF_SEL                              : out std_logic;   
      CDCE_SYNC                                 : out std_logic;   
      CDCE_PLL_LOCK                             : in  std_logic;      

      -- On-board LEDs:    
      -----------------    

      V6_LED                                    : out std_logic_vector(1 to 3);       

      --====================--
      -- GLIB clocks scheme --
      --====================--
      
      -- Fabric clocks (40MHz):
      -------------------------
      
      -- System core:
      XPOINT1_CLK1_P                            : in  std_logic;
      XPOINT1_CLK1_N                            : in  std_logic;       

      -- User logic:
      XPOINT1_CLK3_P                            : in  std_logic;
      XPOINT1_CLK3_N                            : in  std_logic;     
      
      -- MGT(GTX) reference clock:
      ----------------------------      
      
      CDCE_OUT0_P                               : in  std_logic;
      CDCE_OUT0_N                               : in  std_logic;      

      --=====================--
      -- MGT(GTX) (SFP Quad) --
      --=====================--
      
      -- Comment: Note!! Only SFP1 is used in this reference design.
      
      -- MGT(GTX) serial links:
      -------------------------
      
      SFP_TX_P                                  : out std_logic_vector(1 to 4);
      SFP_TX_N                                  : out std_logic_vector(1 to 4);
      SFP_RX_P                                  : in  std_logic_vector(1 to 4);
      SFP_RX_N                                  : in  std_logic_vector(1 to 4);

      -- SFP status:    
      --------------    

      SFP_MOD_ABS                               : in  std_logic_vector(1 to 4);      
      SFP_RXLOS                                 : in  std_logic_vector(1 to 4);      
      SFP_TXFAULT                               : in  std_logic_vector(1 to 4);      

      --====================--
      -- Signals forwarding --
      --====================--

      -- SMA output:
      --------------
 
      -- Comment: FPGA_CLKOUT is connected to a multiplexor within user logic that switches between TX_FRAMECLK and TX_WORDCLK.
      
      FPGA_CLKOUT                               : out std_logic;        
      
      -- Pattern match flags:
      -----------------------
      
      -- Comment: * AMC_PORT TX_P(14:15) are used for forwarding the pattern match flags.    
      
      AMC_PORT_TX_P                             : out std_logic_vector(1 to 15);        
     
      -- Clocks forwarding:
      ---------------------  
      
      -- Comment: * FMC1_LA_P(0:1) are used for forwarding TX_FRAMECLK and TX_WORDCLK respectively.
      --      
      --          * FMC1_LA_P(2:3) are used for forwarding RX_FRAMECLK and RX_WORDCLK respectively.
      
      FMC1_LA_P                                 : inout std_logic_vector(0 to 33 )     

   );
end glib_gbt_example_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of glib_gbt_example_design is

   --================================ Signal Declarations ================================--

   signal user_reset                            : std_logic;         
   
   --=====================================================================================--

--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
   
   --=============--
   -- System core --
   --=============--

   system: entity work.glib_system_core_emu
      port map (
         -- General reset:
         FPGA_POWER_ON_RESET_B                  => FPGA_POWER_ON_RESET_B,               
         USER_RESET_O                           => user_reset,
         -- GLIB control:
         XPOINT1_S10                            => XPOINT1_S10,                  
         XPOINT1_S11                            => XPOINT1_S11,         
         XPOINT1_S30                            => XPOINT1_S30,                  
         XPOINT1_S31                            => XPOINT1_S31,                  
         ---------------------------------------
         CDCE_PWR_DOWN                          => CDCE_PWR_DOWN,                  
         CDCE_REF_SEL                           => CDCE_REF_SEL,                   
         CDCE_SYNC                              => CDCE_SYNC,                   
         CDCE_PLL_LOCK                          => CDCE_PLL_LOCK,
         -- System fabric clock (40MHz):
         PRI_CLK_P                              => XPOINT1_CLK1_P,                              
         PRI_CLK_N                              => XPOINT1_CLK1_N         
      );

   --===========--
   -- User core --
   --===========--
   
   usr: entity work.glib_user_logic_emu
      port map (
         -- General reset:
         RESET_I                                => user_reset,
         -- GLIB control:
         USER_CDCE_LOCKED_I                     => CDCE_PLL_LOCK,
         ---------------------------------------
         USER_V6_LED_O                          => V6_LED(1 TO 2),
         -- GLIB clocks scheme:
         XPOINT1_CLK3_P                         => XPOINT1_CLK3_P,                   
         XPOINT1_CLK3_N                         => XPOINT1_CLK3_N,     
         --------------------------------------- 
         CDCE_OUT0_P                            => CDCE_OUT0_P,  
         CDCE_OUT0_N                            => CDCE_OUT0_N,
         -- MGT(GTX) (SFP Quad):
         SFP_TX_P                               => SFP_TX_P,
         SFP_TX_N                               => SFP_TX_N,
         SFP_RX_P                               => SFP_RX_P,
         SFP_RX_N                               => SFP_RX_N,
         ---------------------------------------
         SFP_MOD_ABS                            => SFP_MOD_ABS, 
         SFP_RXLOS                              => SFP_RXLOS,
         SFP_TXFAULT                            => SFP_TXFAULT,
         -- Signals forwarding:
         FPGA_CLKOUT_O                          => FPGA_CLKOUT,  
         ---------------------------------------      
         AMC_PORT_TX_P                          => AMC_PORT_TX_P,
         ---------------------------------------
         fmc1_io_pin.la_p                       => FMC1_LA_P,
         fmc1_io_pin.la_n                       => open,
         fmc1_io_pin.ha_p                       => open,
         fmc1_io_pin.ha_n                       => open,
         fmc1_io_pin.hb_p                       => open,
         fmc1_io_pin.hb_n                       => open
      );  
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--