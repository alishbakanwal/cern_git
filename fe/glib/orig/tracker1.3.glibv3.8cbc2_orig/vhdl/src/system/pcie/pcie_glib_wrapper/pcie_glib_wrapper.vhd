--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	31/07/2012		 																			--
-- Project Name:				pcie_glib																					--
-- Module Name:   		 	pcie_glib_wrapper						 													--
-- 																																--
-- Language:					VHDL'93																						--
--																																	--
-- Target Devices: 			GLIB (Virtex 6)																			--
-- Tool versions: 			13.2																							--
--																																	--
-- Revision:		 			1.1 																							--
--																																	--
-- Additional Comments: 																									--
--	                                                                                                --
-- * PCIe x4                                                                                       --
-- * gen2                                                                                          -- 
-- * 5Gbps (per lane)                                                                              --
-- * 64 bit interface                                                                              --
-- * 250 MHz clock to user logic                                                                   -- 
--	   																															--
--=================================================================================================--
--=================================================================================================--
-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;
-- Custom libraries and packages:
use work.ipbus.all;
use work.system_pcie_package.all;
use work.user_sys_pcie_constants_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity pcie_glib_wrapper is
	generic (
		PL_FAST_TRAIN	        					: boolean := false
   );
	port (		
		-- Reset:
		RESET_I 						 				: in  std_logic;
		
		--======--
		-- PCIe --
		--======--
		
		-- MGT Reference Clock:
		PCIE_MGT_REFCLK_I            			: in  std_logic; 
		-- Serial lanes:
		PCIE_TX_P_O                   		: out std_logic_vector(0 to 3);
		PCIE_TX_N_O                   		: out std_logic_vector(0 to 3);
		PCIE_RX_P_I                   		: in  std_logic_vector(0 to 3);
		PCIE_RX_N_I                   		: in  std_logic_vector(0 to 3);	
		
		--=======--
		-- IPbus --
		--=======--
		
		-- IPbus Clock:
		IPBUS_CLK_I           					: in  std_logic;		
		-- IPbus:
		IPBUS_I 										: in  ipb_rbus;
		IPBUS_O										: out ipb_wbus;	
		
		--============--
		-- User ports --
		--============--		
	
		-- Clock:
		PCIE_CLK_O           		 			: out std_logic; 				
		-- PCIe Slave interface:
		PCIE_SLV_I									: in  R_slv_to_ezdma2;		
		PCIE_SLV_O									: out R_slv_from_ezdma2;						
		-- PCIe DMA:	
		PCIE_DMA_I	  								: in  R_userDma_to_ezdma2_array  (1 to 7); 		
		PCIE_DMA_O 	  								: out R_userDma_from_ezdma2_array(1 to 7);		
		-- PCIe Interruptions:
		PCIE_INTERRUPT_I							: in  R_int_to_ezdma2;		
		PCIE_INTERRUPT_O							: out R_int_from_ezdma2;
	
		--=================--
		-- Status and Test --
		--=================--
		
		-- PCIe Configuration status:
		PCIE_CFG_O     							: out R_cfg_from_ezdma2;		
		-- PCIe Link status:
		RETRAINING_CNT_O							: out std_logic_vector(  7 downto 0);		
		LINK_RDY_O									: out std_logic;		
		-- EZDMA2/IPbus Fabric Interface status:	
		IPBUS_BUSY_O								: out std_logic;		
--		IPBUS_ERROR_O								: out std_logic;
--		IPBUS_TIMEOUT_O							: out std_logic;				
		-- EZDMA2 Test Mode:		
		TEST_MODE_I									: in  std_logic_vector( 15 downto 0)
	);		
end pcie_glib_wrapper;
architecture structural of pcie_glib_wrapper is  
	--============================ Declarations ===========================--
	-- Attributes:
	attribute S										: string; -- To avoid signal trimming for Chipscope

	-- Reset: 
	signal reset_b									: std_logic;  	

	--===========--
	-- PCIe Core --	
	--===========--		

	-- Tx:
	signal trn_tbuf_av 							: std_logic_vector(  5 downto 0);
	signal trn_tcfg_req_n 						: std_logic;
	signal trn_terr_drop_n 						: std_logic;
	signal trn_tdst_rdy_n 						: std_logic;
	signal trn_td 									: std_logic_vector( 63 downto 0);
	signal trn_trem_n 							: std_logic;
	signal trn_trem_n_dummy						: std_logic;
	attribute S	of trn_trem_n_dummy			: signal is "true";
	signal trn_tsof_n 							: std_logic;
	signal trn_tsof_n_dummy 					: std_logic;
	attribute S	of trn_tsof_n_dummy			: signal is "true";
	signal trn_teof_n 							: std_logic;
	signal trn_teof_n_dummy 					: std_logic;
	attribute S	of trn_teof_n_dummy			: signal is "true";
	signal trn_tsrc_rdy_n 						: std_logic;
	signal trn_tsrc_rdy_n_dummy 				: std_logic;
	attribute S	of trn_tsrc_rdy_n_dummy		: signal is "true";
	signal trn_tsrc_dsc_n 						: std_logic;
	signal trn_terrfwd_n 						: std_logic;
	signal trn_tcfg_gnt_n 						: std_logic;
	signal trn_tstr_n 							: std_logic;	
	-- Rx:	
	signal trn_rd 									: std_logic_vector( 63 downto 0);
	signal trn_rrem_n 							: std_logic;
	signal trn_rsof_n 							: std_logic;
	signal trn_reof_n 							: std_logic;
	signal trn_rsrc_rdy_n 						: std_logic;
	signal trn_rsrc_dsc_n 						: std_logic;
	signal trn_rerrfwd_n 						: std_logic;
	signal trn_rbar_hit_n 						: std_logic_vector(  6 downto 0);
	signal trn_rdst_rdy_n 						: std_logic;
	signal trn_rnp_ok_n 							: std_logic;	
	-- Flow Control:	
	signal trn_fc_cpld 							: std_logic_vector( 11 downto 0);
	signal trn_fc_cplh 							: std_logic_vector(  7 downto 0);
	signal trn_fc_npd 							: std_logic_vector( 11 downto 0);
	signal trn_fc_nph 							: std_logic_vector(  7 downto 0);
	signal trn_fc_pd 								: std_logic_vector( 11 downto 0);
	signal trn_fc_ph 								: std_logic_vector(  7 downto 0);
	signal trn_fc_sel 							: std_logic_vector(  2 downto 0);	
	signal trn_lnk_up_n 							: std_logic;
	signal trn_lnk_up_n_int1 					: std_logic;
	signal trn_clk 								: std_logic;
	signal trn_reset_n 							: std_logic;
	signal trn_reset_n_int1 					: std_logic;		
	-- Configuration (CFG) Interface:			
	signal cfg_do 									: std_logic_vector( 31 downto 0);
	signal cfg_rd_wr_done_n 					: std_logic;
	signal cfg_di 									: std_logic_vector( 31 downto 0);
	signal cfg_byte_en_n 						: std_logic_vector(  3 downto 0);
	signal cfg_dwaddr 							: std_logic_vector(  9 downto 0);
	signal cfg_wr_en_n 							: std_logic;
	signal cfg_rd_en_n 							: std_logic;	
	signal cfg_err_cor_n							: std_logic;
	signal cfg_err_ur_n 							: std_logic;
	signal cfg_err_ecrc_n 						: std_logic;
	signal cfg_err_cpl_timeout_n 				: std_logic;
	signal cfg_err_cpl_abort_n 				: std_logic;
	signal cfg_err_cpl_unexpect_n 			: std_logic;
	signal cfg_err_posted_n 					: std_logic;
	signal cfg_err_locked_n 					: std_logic;
	signal cfg_err_tlp_cpl_header 			: std_logic_vector( 47 downto 0);
	signal cfg_err_cpl_rdy_n 					: std_logic;
	signal cfg_interrupt_n 						: std_logic;
	signal cfg_interrupt_rdy_n 				: std_logic;
	signal cfg_interrupt_assert_n 			: std_logic;
	signal cfg_interrupt_di 					: std_logic_vector(  7 downto 0);
	signal cfg_interrupt_do 					: std_logic_vector(  7 downto 0);
	signal cfg_interrupt_mmenable 			: std_logic_vector(  2 downto 0);
	signal cfg_interrupt_msienable 			: std_logic;
	signal cfg_interrupt_msixenable 			: std_logic;
	signal cfg_interrupt_msixfm 				: std_logic;
	signal cfg_turnoff_ok_n 					: std_logic;
	signal cfg_to_turnoff_n 					: std_logic;
	signal cfg_trn_pending_n					: std_logic;
	signal cfg_pm_wake_n 						: std_logic;
	signal cfg_bus_number 						: std_logic_vector(  7 downto 0);
	signal cfg_device_number 					: std_logic_vector(  4 downto 0);
	signal cfg_function_number 				: std_logic_vector(  2 downto 0);
	signal cfg_status 							: std_logic_vector( 15 downto 0);
	signal cfg_command 							: std_logic_vector( 15 downto 0);
	signal cfg_dstatus 							: std_logic_vector( 15 downto 0);
	signal cfg_dcommand							: std_logic_vector( 15 downto 0);
	signal cfg_lstatus 							: std_logic_vector( 15 downto 0);
	signal cfg_lcommand 							: std_logic_vector( 15 downto 0);
	signal cfg_dcommand2 						: std_logic_vector( 15 downto 0);
	signal cfg_pcie_link_state_n 				: std_logic_vector(  2 downto 0);
	signal cfg_dsn 								: std_logic_vector( 63 downto 0);	
	signal cfg_ltssm								: std_logic_vector(  4 downto 0);
	signal cfg_linkcsr 							: std_logic_vector( 31 downto 0);		
	-- Physical Layer Control and Status (PL) Interface:			
	signal pl_initial_link_width 				: std_logic_vector(  2 downto 0);
	signal pl_lane_reversal_mode 				: std_logic_vector(  1 downto 0);
	signal pl_link_gen2_capable 				: std_logic;
	signal pl_link_partner_gen2_sup 			: std_logic;
	signal pl_link_upcfg_capable 				: std_logic;
	signal pl_ltssm_state 						: std_logic_vector(  5 downto 0);
	signal pl_received_hot_rst 				: std_logic;
	signal pl_sel_link_rate 					: std_logic;
	signal pl_sel_link_width 					: std_logic_vector(  1 downto 0);
	signal pl_directed_link_auton 			: std_logic;
	signal pl_directed_link_change 			: std_logic_vector(  1 downto 0);
	signal pl_directed_link_speed 			: std_logic;
	signal pl_directed_link_width 			: std_logic_vector(  1 downto 0);
	signal pl_upstream_prefer_deemph 		: std_logic;

	--========--	
	-- EZDMA2 --		
	--========--

	-- EZDMA2 - IPbus fabric interface DMA ports:	
	signal dma0_to_ezdma2						: R_dma_to_ezdma2;					
	signal dma0_from_ezdma2						: R_dma_from_ezdma2;

	-- User DMA ports:		
	signal dma_regin   							: T_dma_regin;	 
	signal dma_regout  							: T_dma_regout;
	signal dma_param   							: T_dma_param;
	signal dma_control 							: T_dma_control;
	signal dma_status  							: T_dma_status;
	signal dma_fifocnt 							: T_dma_fifocnt;
	
	--====================--
	-- Multiplexor module --
	--====================--

	-- Slave interface:
	signal slv_from_ezdma2						: R_slv_from_ezdma2;
	signal slv_to_ezdma2	      				: R_slv_to_ezdma2;
	signal slv_from_ipbus						: R_slv_to_ezdma2;
	signal slv_to_ipbus							: R_slv_from_ezdma2;
	-- General DMA:		
	signal gDma_from_ezdma2						: R_gDma_from_ezdma2;
	signal gDma_to_ezdma2						: R_gDma_to_ezdma2;			
	signal gDma_from_ipbus						: R_gDma_to_ezdma2;		
	signal gDma_to_ipbus							: R_gDma_from_ezdma2;
	-- User DMA:
	signal user_gDma_to_ezdma2_mux			: R_gDma_to_ezdma2_array(1 to 7);			
	signal user_gDma_from_ezdma2_mux    	: R_gDma_from_ezdma2_array(1 to 7);

	--=================================--
	-- EZDMA2 - IPbus fabric interface --
	--=================================--

	signal ipbus_from_int  						: ipb_wbus;
	signal ipbus_to_int							: ipb_rbus;		
	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--========================= Port Assignments ==========================--
	-- PCIe clock:
	PCIE_CLK_O										<= trn_clk;
	-- EZDMA2 configuration interface:
	PCIE_CFG_O.ltssm								<= cfg_ltssm;	
	PCIE_CFG_O.linkcsr							<= cfg_linkcsr;	
	--=====================================================================--		
	--=========================== User Logic ==============================--
	-- Not gate:
	reset_b											<= not RESET_I;	
	--=====================================================================--
	--===================== Component Instantiations ======================--

	--===========--
	-- Registers --	
	--===========--
	
	-- Dummy Registers:
	process(RESET_I, trn_clk)
	begin
		if RESET_I = '1' then
			trn_trem_n_dummy						<= '0';
			trn_tsof_n_dummy						<= '0';
			trn_teof_n_dummy						<= '0';
			trn_tsrc_rdy_n_dummy					<= '0';
		elsif rising_edge(trn_clk) then
			trn_trem_n_dummy						<= trn_trem_n;
			trn_tsof_n_dummy						<= trn_tsof_n;
			trn_teof_n_dummy						<= trn_teof_n;
			trn_tsrc_rdy_n_dummy					<= trn_tsrc_rdy_n;		
		end if;
	end process;

	-- PCIe Core Registers:			
	trn_lnk_up_n_int_i: FDCP
		generic map(
			INIT 										=> '1')
		port map(
			Q 											=> trn_lnk_up_n,
			D       									=> trn_lnk_up_n_int1,
			C       									=> trn_clk,
			CLR     									=> '0',
			PRE     									=> '0'
		);					
	trn_reset_n_i : FDCP 					
		generic map(
			INIT 										=> '1')
		port map(					
			Q      									=> trn_reset_n,
			D      									=> trn_reset_n_int1,
			C      									=> trn_clk,
			CLR    									=> '0',
			PRE    									=> '0'
		);
		
	--===========--
	-- PCIe Core --	
	--===========--	
	
	pcie: entity work.pcie_hip_x4_gen2_125ref
		generic map(
			PL_FAST_TRAIN 							=>  PL_FAST_TRAIN)
		port map(
			pci_exp_txp        					=>  pcie_tx_p_o,
			pci_exp_txn        					=>  pcie_tx_n_o,
			pci_exp_rxp        					=>  pcie_rx_p_i,
			pci_exp_rxn        					=>  pcie_rx_n_i,
			trn_clk            					=>  trn_clk ,
			trn_reset_n        					=>  trn_reset_n_int1,
			trn_lnk_up_n       					=>  trn_lnk_up_n_int1,
			trn_tbuf_av        					=>  trn_tbuf_av,
			trn_tcfg_req_n     					=>  trn_tcfg_req_n,
			trn_terr_drop_n    					=>  trn_terr_drop_n,
			trn_tdst_rdy_n     					=>  trn_tdst_rdy_n,
			trn_td             					=>  trn_td,
			trn_trem_n         					=>  trn_trem_n,
			trn_tsof_n         					=>  trn_tsof_n,
			trn_teof_n         					=>  trn_teof_n,
			trn_tsrc_rdy_n     					=>  trn_tsrc_rdy_n,
			trn_tsrc_dsc_n     					=>  trn_tsrc_dsc_n,
			trn_terrfwd_n      					=>  trn_terrfwd_n,
			trn_tcfg_gnt_n     					=>  trn_tcfg_gnt_n,
			trn_tstr_n         					=>  trn_tstr_n,
			trn_rd             					=>  trn_rd,
			trn_rrem_n         					=>  trn_rrem_n,
			trn_rsof_n         					=>  trn_rsof_n,
			trn_reof_n         					=>  trn_reof_n,
			trn_rsrc_rdy_n     					=>  trn_rsrc_rdy_n,
			trn_rsrc_dsc_n     					=>  trn_rsrc_dsc_n,
			trn_rerrfwd_n      					=>  trn_rerrfwd_n,
			trn_rbar_hit_n     					=>  trn_rbar_hit_n,
			trn_rdst_rdy_n     					=>  trn_rdst_rdy_n,
			trn_rnp_ok_n       					=>  trn_rnp_ok_n,
			trn_fc_cpld        					=>  trn_fc_cpld,
			trn_fc_cplh        					=>  trn_fc_cplh,
			trn_fc_npd         					=>  trn_fc_npd,
			trn_fc_nph         					=>  trn_fc_nph,
			trn_fc_pd          					=>  trn_fc_pd,
			trn_fc_ph          					=>  trn_fc_ph,
			trn_fc_sel         					=>  trn_fc_sel,
			cfg_do             					=>  cfg_do,
			cfg_rd_wr_done_n   					=>  cfg_rd_wr_done_n,
			cfg_di             					=>  cfg_di,
			cfg_byte_en_n      					=>  cfg_byte_en_n,
			cfg_dwaddr         					=>  cfg_dwaddr,
			cfg_wr_en_n        					=>  cfg_wr_en_n,
			cfg_rd_en_n        					=>  cfg_rd_en_n,		
			cfg_err_cor_n                   	=>  cfg_err_cor_n,
			cfg_err_ur_n                    	=>  cfg_err_ur_n,
			cfg_err_ecrc_n                  	=>  cfg_err_ecrc_n,
			cfg_err_cpl_timeout_n           	=>  cfg_err_cpl_timeout_n,
			cfg_err_cpl_abort_n             	=>  cfg_err_cpl_abort_n,
			cfg_err_cpl_unexpect_n          	=>  cfg_err_cpl_unexpect_n,
			cfg_err_posted_n                	=>  cfg_err_posted_n,
			cfg_err_locked_n                	=>  cfg_err_locked_n,
			cfg_err_tlp_cpl_header          	=>  cfg_err_tlp_cpl_header,
			cfg_err_cpl_rdy_n               	=>  cfg_err_cpl_rdy_n,
			cfg_interrupt_n                 	=>  cfg_interrupt_n,
			cfg_interrupt_rdy_n             	=>  cfg_interrupt_rdy_n,
			cfg_interrupt_assert_n          	=>  cfg_interrupt_assert_n,
			cfg_interrupt_di                	=>  cfg_interrupt_di,
			cfg_interrupt_do                	=>  cfg_interrupt_do,
			cfg_interrupt_mmenable          	=>  cfg_interrupt_mmenable,
			cfg_interrupt_msienable         	=>  cfg_interrupt_msienable,
			cfg_interrupt_msixenable        	=>  cfg_interrupt_msixenable,
			cfg_interrupt_msixfm            	=>  cfg_interrupt_msixfm,
			cfg_turnoff_ok_n                	=>  cfg_turnoff_ok_n,
			cfg_to_turnoff_n                	=>  cfg_to_turnoff_n,
			cfg_trn_pending_n               	=>  cfg_trn_pending_n,
			cfg_pm_wake_n                   	=>  cfg_pm_wake_n,
			cfg_bus_number                  	=>  cfg_bus_number,
			cfg_device_number               	=>  cfg_device_number,
			cfg_function_number             	=>  cfg_function_number,
			cfg_status                      	=>  cfg_status,
			cfg_command                     	=>  cfg_command,
			cfg_dstatus                     	=>  cfg_dstatus,
			cfg_dcommand                    	=>  cfg_dcommand,
			cfg_lstatus                     	=>  cfg_lstatus,
			cfg_lcommand                    	=>  cfg_lcommand,
			cfg_dcommand2                   	=>  cfg_dcommand2,
			cfg_pcie_link_state_n           	=>  cfg_pcie_link_state_n,
			cfg_dsn                         	=>  cfg_dsn,
			cfg_pmcsr_pme_en                	=>  open,
			cfg_pmcsr_pme_status            	=>  open,
			cfg_pmcsr_powerstate            	=>  open,
			pl_initial_link_width           	=>  pl_initial_link_width,
			pl_lane_reversal_mode           	=>  pl_lane_reversal_mode,
			pl_link_gen2_capable            	=>  pl_link_gen2_capable,
			pl_link_partner_gen2_supported  	=>  pl_link_partner_gen2_sup,
			pl_link_upcfg_capable           	=>  pl_link_upcfg_capable,
			pl_ltssm_state                  	=>  pl_ltssm_state,
			pl_received_hot_rst             	=>  pl_received_hot_rst,
			pl_sel_link_rate                	=>  pl_sel_link_rate,
			pl_sel_link_width               	=>  pl_sel_link_width,
			pl_directed_link_auton          	=>  pl_directed_link_auton,
			pl_directed_link_change         	=>  pl_directed_link_change,
			pl_directed_link_speed          	=>  pl_directed_link_speed,
			pl_directed_link_width          	=>  pl_directed_link_width,
			pl_upstream_prefer_deemph       	=>  pl_upstream_prefer_deemph,
			sys_clk                         	=>  PCIE_MGT_REFCLK_I,
			sys_reset_n                     	=>  reset_b
		);
		
	--========--	
	-- EZDMA2 --		
	--========--
	
	ezdma2: entity work.ezdma2_wrapper
		port map (
			CLK										=> trn_clk,
			RSTN										=> reset_b,
			TEST_MODE_I	    						=> TEST_MODE_I,
			-- PCIe interface:
			TRN_LNK_UP_N							=> trn_lnk_up_n,
			TRN_TD									=> trn_td,
			TRN_TREM_N(0)							=> trn_trem_n,
--			TRN_TREM_N(1)							=> open,	
			TRN_TSOF_N								=> trn_tsof_n,
			TRN_TEOF_N								=> trn_teof_n,
			TRN_TSRC_RDY_N							=> trn_tsrc_rdy_n,
			TRN_TDST_RDY_N							=> trn_tdst_rdy_n,
			TRN_TERR_DROP_N						=> trn_terr_drop_n,
			TRN_TSRC_DSC_N							=> trn_tsrc_dsc_n,
			TRN_TERRFWD_N							=> trn_terrfwd_n,
			TRN_TBUF_AV								=> trn_tbuf_av,
			TRN_TSTR_N								=> trn_tstr_n,
			TRN_RD									=> trn_rd,
--			TRN_RREM_N								=> trn_rrem_n,
			TRN_RSOF_N								=> trn_rsof_n,
			TRN_REOF_N								=> trn_reof_n,
			TRN_RSRC_RDY_N							=> trn_rsrc_rdy_n,
			TRN_RSRC_DSC_N							=> trn_rsrc_dsc_n,
			TRN_RDST_RDY_N							=> trn_rdst_rdy_n,
			TRN_RERRFWD_N							=> trn_rerrfwd_n,
			TRN_RNP_OK_N							=> trn_rnp_ok_n,
			TRN_RBAR_HIT_N							=> trn_rbar_hit_n,
			CFG_ERR_COR_N							=> cfg_err_cor_n,
			CFG_ERR_UR_N							=> cfg_err_ur_n,
			CFG_ERR_ECRC_N							=> cfg_err_ecrc_n,
			CFG_ERR_CPL_TIMEOUT_N				=> cfg_err_cpl_timeout_n,
			CFG_ERR_CPL_ABORT_N					=> cfg_err_cpl_abort_n,
			CFG_ERR_CPL_UNEXPECT_N				=> cfg_err_cpl_unexpect_n,
			CFG_ERR_POSTED_N						=> cfg_err_posted_n,
			CFG_ERR_LOCKED_N						=> cfg_err_locked_n,
			CFG_ERR_TLP_CPL_HEADER				=> cfg_err_tlp_cpl_header,
			CFG_ERR_CPL_RDY_N						=> cfg_err_cpl_rdy_n,
			CFG_INTERRUPT_N						=> cfg_interrupt_n,
			CFG_INTERRUPT_RDY_N					=> cfg_interrupt_rdy_n,
			CFG_INTERRUPT_ASSERT_N				=> cfg_interrupt_assert_n,
			CFG_INTERRUPT_DI						=> cfg_interrupt_di,
			CFG_INTERRUPT_DO						=> cfg_interrupt_do,
			CFG_INTERRUPT_MMENABLE				=> cfg_interrupt_mmenable,
			CFG_INTERRUPT_MSIENABLE				=> cfg_interrupt_msienable,
			CFG_PCIE_LINK_STATE_N				=> cfg_pcie_link_state_n,
			CFG_TRN_PENDING_N						=> cfg_trn_pending_n,
			CFG_BUS_NUMBER							=> cfg_bus_number,
			CFG_DEVICE_NUMBER						=> cfg_device_number,
			CFG_FUNCTION_NUMBER					=> cfg_function_number,
			CFG_STATUS								=> cfg_status,
			CFG_COMMAND								=> cfg_command,
			CFG_DSTATUS			   				=> cfg_dstatus,
			CFG_DCOMMAND							=> cfg_dcommand,
			CFG_LSTATUS								=> cfg_lstatus,
			CFG_LCOMMAND							=> cfg_lcommand,		
			CFG_PRMCSR 								=> PCIE_CFG_O.prmcsr,
			CFG_DEVCSR 								=> PCIE_CFG_O.devcsr,
			CFG_LINKCSR 							=> cfg_linkcsr,
			CFG_MSICSR 								=> PCIE_CFG_O.msicsr,
			CFG_LTSSM 								=> cfg_ltssm,	
			-- Slave interface:								
			SLV_I										=> slv_to_ezdma2,		
			SLV_O										=> slv_from_ezdma2,
			-- General DMA ports:							
			GDMA_I									=> gdma_to_ezdma2,		                       		                             
			GDMA_O									=> gdma_from_ezdma2,			
			-- EZDMA2 - IPbus fabric interface DMA ports:	
			DMA0_I									=> dma0_to_ezdma2,			
			DMA0_O									=> dma0_from_ezdma2,
			-- User DMA ports:
			USER_DMA_REGIN_I						=> dma_regin,
         USER_DMA_REGOUT_O						=> dma_regout,	
         USER_DMA_PARAM_I 						=> dma_param,
         USER_DMA_CONTROL_I					=> dma_control,	
			USER_DMA_STATUS_O						=> dma_status, 	
			USER_DMA_FIFOCNT_I					=> dma_fifocnt,	
			-- PCIe Interruptions:
			PCIE_INTERRUPT_I						=> PCIE_INTERRUPT_I,	
			PCIE_INTERRUPT_O 						=> PCIE_INTERRUPT_O
		);		
	
	user_dma_assignment_gen: for i in 1 to 7 generate		
		dma_regin(i)              				<= PCIE_DMA_I(i).regin;
		PCIE_DMA_O(i).regout             	<= dma_regout(i);
		dma_param(i)              				<= PCIE_DMA_I(i).param;
		dma_control(i)            				<= PCIE_DMA_I(i).control;
		PCIE_DMA_O(i).status             	<= dma_status(i);
		dma_fifocnt(i)								<= PCIE_DMA_I(i).fifocnt;			
	end generate;

	--====================--
	-- Multiplexor module --
	--====================--

	mux: entity work.ezdma2_mux
		port map (			
			-- Slave interface:
			SLV_I										=>	slv_from_ezdma2,
			SLV_O										=>	slv_to_ezdma2,			
			-----------------                   
			IPBUS_SLV_I								=>	slv_from_ipbus,					
			IPBUS_SLV_O								=>	slv_to_ipbus,						
			-----------------
			USER_SLV_I								=> PCIE_SLV_I,				
			USER_SLV_O								=>	PCIE_SLV_O,
			-- General DMA:							
			GDMA_I									=>	gDma_from_ezdma2,
			GDMA_O									=>	gDma_to_ezdma2,				
			-----------------
			IPBUS_GDMA_I							=>	gDma_from_ipbus,				
			IPBUS_GDMA_O							=>	gDma_to_ipbus,				
			-----------------
			USER_GDMA_I								=>	user_gDma_to_ezdma2_mux,		
			USER_GDMA_O								=>	user_gDma_from_ezdma2_mux
		);
		
	user_gDma_assignment_gen: for i in 1 to 7 generate
		user_gDma_to_ezdma2_mux(i).rddata	<= PCIE_DMA_I(i).rddata;	
		-----------------		
		PCIE_DMA_O(i).rd							<= user_gDma_from_ezdma2_mux(i).rd;
		PCIE_DMA_O(i).rdaddr    				<= user_gDma_from_ezdma2_mux(i).rdaddr;      
		PCIE_DMA_O(i).rdchannel 				<= user_gDma_from_ezdma2_mux(i).rdchannel;   
		PCIE_DMA_O(i).wr        				<= user_gDma_from_ezdma2_mux(i).wr;          
		PCIE_DMA_O(i).wraddr    				<= user_gDma_from_ezdma2_mux(i).wraddr;      
		PCIE_DMA_O(i).wrchannel 				<= user_gDma_from_ezdma2_mux(i).wrchannel;   
		PCIE_DMA_O(i).wrdata    				<= user_gDma_from_ezdma2_mux(i).wrdata;      
		PCIE_DMA_O(i).wrbytevalid				<= user_gDma_from_ezdma2_mux(i).wrbytevalid; 
	end generate;		

	--===============================--
	-- EZDMA2/IPbus fabric interface --
	--===============================--
	
	interface_inst: entity work.ezdma2_ipbus_int
		port map (
			-- General reset and clocks:
			RESET_I									=>	RESET_I,		
			PCIE_CLK_I								=>	trn_clk,			
			IPBUS_CLK_I								=>	IPBUS_CLK_I,						
			-- EZDMA2 Configuration interface:					
			CFG_LTSSM_I								=>	cfg_ltssm,			
			CFG_LINKCSR_I 							=>	cfg_linkcsr,		
			-- Slave interface:			
			SLV_I										=>	slv_to_ipbus,
			SLV_O										=>	slv_from_ipbus,			 
			-- General DMA:		   			                         
			GDMA_I									=>	gDma_to_ipbus,
			GDMA_O 									=>	gDma_from_ipbus,	     
			-- DMA0:                			                         
			DMA0_I									=>	dma0_from_ezdma2,	                   
			DMA0_O 									=>	dma0_to_ezdma2,	                         
			-- IPbus:               			                       
			IPBUS_I 									=>	IPBUS_I,	         
			IPBUS_O									=>	IPBUS_O,	              
			-- Status:			
			RETRAINING_CNT_O						=> RETRAINING_CNT_O,
			LINK_RDY_O								=> LINK_RDY_O,		
			BUSY_O									=>	IPBUS_BUSY_O				
--			IPBUS_ERROR_O							=>	IPBUS_ERROR_O,	
--			IPBUS_TIMEOUT_O						=>	IPBUS_TIMEOUT_O	
		);			
	
	--=====================================================================--
end structural;
--=================================================================================================--
--=================================================================================================--