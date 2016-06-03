--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Cyclone V GT - GBT TX gearbox standard DPRAM  
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Altera Cyclone V GT                                                   
-- Tool version:          Quartus II 13.1                                                                  
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--                                                                  
--                        09/03/2014   3.0       M. Barros Marin   First .vhd module definition.
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

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_tx_gearbox_std_dpram is
   port (
      
      --=================--
      -- Write interface --
      --=================--
      
      WR_CLK_I                                  : in  std_logic;
      WR_ADDRESS_I                              : in  std_logic_vector(  2 downto 0);
      WR_DATA_I                                 : in  std_logic_vector(119 downto 0);
      
      --================--
      -- Read interface --
      --================--
      
      RD_CLK_I                                  : in  std_logic;
      RD_ADDRESS_I                              : in  std_logic_vector(  4 downto 0);
      RD_DATA_O                                 : out std_logic_vector( 39 downto 0)
      
   );
end gbt_tx_gearbox_std_dpram;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_tx_gearbox_std_dpram is
  
   --================================ Signal Declarations ================================--
  
   signal writeData                             : std_logic_vector(159 downto 0);
   
   --=====================================================================================--
  
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--  
   
   --==================================== User Logic =====================================--

   writeData                                    <= x"0000000000" & WR_DATA_I;

   -- Comment: The "Q" output port of "dpram" is registered internally.
   
   dpram: entity work.alt_cv_tx_dpram
      port map (
         WREN                                   => '1',
         WRCLOCK                                => WR_CLK_I,
         RDCLOCK                                => RD_CLK_I,
         DATA                                   => writeData,
         RDADDRESS                              => RD_ADDRESS_I,
         WRADDRESS                              => WR_ADDRESS_I,
         Q                                      => RD_DATA_O
      );

   --=====================================================================================--         
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--