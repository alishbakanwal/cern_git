--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Stratix V - Multi Gigabit Transceivers TX PLL
--                                                                                                 
-- Language:              VHDL'93                                                                 
--                                                                                                   
-- Target Device:         Altera Stratix V                                                      
-- Tool version:          Quartus II 14.0                                                              
--                                                                                                   
-- Revision:              3.6                                                                      
--
-- Description:           
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        30/03/2014   3.0       M. Barros Marin   First .vhd module definition.           
--
--                        14/08/2014   3.5       M. Barros Marin   - Added port "PLLRSTCTRL_CLK_I".
--                                                                 - Minor modifications.
--
--                        09/02/2015   3.6       M. Barros Marin   Minor modifications.
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

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

-- Libraries for direct instantiation:
library mgt_atxpll;
library mgt_atxpll_rst;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity alt_ax_mgt_txpll is
   port (      
      
      --=======--  
      -- Reset --  
      --=======--  
      RESET_I                                   : in  std_logic;
      
      --===============--  
      -- Clocks scheme --  
      --===============--        
      MGT_REFCLK_I                              : in  std_logic;
      TX_BONDING_CLK_O									: out std_logic_vector(5 downto 0);
		      
      --=========--
      -- Control --
      --=========--      
      LOCKED_O                                  : out std_logic

   );
end alt_ax_mgt_txpll;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of alt_ax_mgt_txpll is 

   --================================ Signal Declarations ================================--
   signal atxpll_powerdown:	std_logic;
	
	component mgt_pll is
		port (
			mcgb_rst          : in  std_logic                    := 'X'; -- mcgb_rst
			--mcgb_serial_clk   : out std_logic;                           -- clk
			pll_cal_busy      : out std_logic;                           -- pll_cal_busy
			pll_locked        : out std_logic;                           -- pll_locked
			pll_powerdown     : in  std_logic                    := 'X'; -- pll_powerdown
			pll_refclk0       : in  std_logic                    := 'X'; -- clk
			tx_bonding_clocks : out std_logic_vector(5 downto 0);        -- clk
			tx_serial_clk     : out std_logic                            -- clk
		);
	end component mgt_pll;

   --=====================================================================================--   
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================-- 
   
	--=============--
	-- GTX PLL Rst --
	--=============--
	transceiver_atxpll_rst: entity mgt_atxpll_rst.mgt_atxpll_rst
		port map (
			clock         		=> MGT_REFCLK_I,
			pll_powerdown(0)	=> atxpll_powerdown,
			reset         		=> RESET_I
		);
		
   --===========--
   -- GX TX PLL --
   --===========--
	
   fpll_gen: if XCVR_TX_PLL = FPLL generate
	   transceiver_atxpll: mgt_pll--entity mgt_atxpll.mgt_atxpll
			port map(
				mcgb_rst          	=> atxpll_powerdown,			--          mcgb_rst.mcgb_rst
				--mcgb_serial_clk   	=> open,                   -- clk
				--pll_cal_busy      	=> open,                   --      pll_cal_busy.pll_cal_busy
				pll_locked        	=> LOCKED_O,					--        pll_locked.pll_locked
				pll_powerdown     	=> atxpll_powerdown,			--     pll_powerdown.pll_powerdown
				pll_refclk0       	=> MGT_REFCLK_I,				--       pll_refclk0.clk
				tx_bonding_clocks 	=> TX_BONDING_CLK_O,       -- tx_bonding_clocks.clk
				tx_serial_clk     	=> open 							--     tx_serial_clk.clk
			);
   end generate;
	
   ATXpll_gen: if XCVR_TX_PLL = ATXPLL generate
	   transceiver_atxpll: entity mgt_atxpll.mgt_atxpll
			port map(
				mcgb_rst          	=> atxpll_powerdown,			--          mcgb_rst.mcgb_rst
				--mcgb_serial_clk   	=> open,                   -- clk
				--pll_cal_busy      	=> open,                   --      pll_cal_busy.pll_cal_busy
				pll_locked        	=> LOCKED_O,					--        pll_locked.pll_locked
				pll_powerdown     	=> atxpll_powerdown,			--     pll_powerdown.pll_powerdown
				pll_refclk0       	=> MGT_REFCLK_I,				--       pll_refclk0.clk
				tx_bonding_clocks 	=> TX_BONDING_CLK_O,       -- tx_bonding_clocks.clk
				tx_serial_clk     	=> open 							--     tx_serial_clk.clk
			);
   end generate;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--