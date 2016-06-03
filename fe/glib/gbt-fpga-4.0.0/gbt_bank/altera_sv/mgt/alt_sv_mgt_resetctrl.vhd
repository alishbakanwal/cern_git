--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Stratix V - MGT reset controller
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Altera Stratix V                                                   
-- Tool version:          Quartus II 14.0                                                                  
--                                                                                                   
-- Version:               3.1                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--                                                                  
--                        18/03/2014   3.0       M. Barros Marin   First .vhd module definition.
--
--                        09/02/2014   3.1       M. Barros Marin   Minor modifications.
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
library alt_sv_gx_reset_tx;
library alt_sv_gx_reset_rx;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity alt_sv_mgt_resetctrl is
   port ( 

      --=======--   
      -- Clock --                     
      --=======--            

      CLK_I                                     : in  std_logic;
      
      --===============--
      -- Resets scheme --
      --===============--
      
      -- TX reset control:
      --------------------
      
      TX_RESET_I                                : in  std_logic;
      ------------------------------------------   
      TX_ANALOGRESET_O                          : out std_logic;
      TX_DIGITALRESET_O                         : out std_logic;
      TX_READY_O                                : out std_logic;
      PLL_LOCKED_I                              : in  std_logic;  
      TX_CAL_BUSY_I                             : in  std_logic;   
      
      -- RX reset control:
      --------------------

      RX_RESET_I                                : in  std_logic;      
      ------------------------------------------   
      RX_ANALOGRESET_O                          : out std_logic;
      RX_DIGITALRESET_O                         : out std_logic;
      RX_READY_O                                : out std_logic;
      RX_IS_LOCKEDTODATA_I                      : in  std_logic; 
      RX_CAL_BUSY_I                             : in  std_logic      
  
   );
end alt_sv_mgt_resetctrl;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of alt_sv_mgt_resetctrl is
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--
   
   --======================--
   -- GX reset controllers --
   --======================--      

   -- TX reset:
   ------------
   
   gxResetTx: entity alt_sv_gx_reset_tx.alt_sv_gx_reset_tx
      port map (        
         CLOCK                                  => CLK_I,            
         RESET                                  => TX_RESET_I,                  
         TX_ANALOGRESET(0)                      => TX_ANALOGRESET_O,                    
         TX_DIGITALRESET(0)                     => TX_DIGITALRESET_O,                    
         TX_READY(0)                            => TX_READY_O,                           
         PLL_LOCKED(0)                          => PLL_LOCKED_I,                    
         PLL_SELECT(0)                          => '0',                     
         TX_CAL_BUSY(0)                         => TX_CAL_BUSY_I                    
      );

   -- RX reset:
   ------------
  
   gxResetRx: entity alt_sv_gx_reset_rx.alt_sv_gx_reset_rx
      port map (
         CLOCK                                  => CLK_I, 
         RESET                                  => RX_RESET_I,     
         RX_ANALOGRESET(0)                      => RX_ANALOGRESET_O,        
         RX_DIGITALRESET(0)                     => RX_DIGITALRESET_O,       
         RX_READY(0)                            => RX_READY_O,              
         RX_IS_LOCKEDTODATA(0)                  => RX_IS_LOCKEDTODATA_I,  
         RX_CAL_BUSY(0)                         => RX_CAL_BUSY_I           
      );                                           

   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--