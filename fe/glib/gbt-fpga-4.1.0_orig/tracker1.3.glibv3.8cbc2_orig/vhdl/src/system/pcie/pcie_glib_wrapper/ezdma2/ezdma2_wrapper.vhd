--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	15/09/2012 																					--
-- Project Name:				pcie_glib                      														--
-- Module Name:   		 	ezdma2_wrapper							 													--
-- 																																--
-- Language:					VHDL'93                                           								--
--																																	--
-- Target Devices: 			GLIB (Virtex 6)   																		--
-- Tool versions: 			ISE 13.2           																		--
--																																	--
-- Revision:		 			1.0 																							--
--																																	--
-- Additional Comments: 																									--
--																																	--
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
use work.system_pcie_package.all;
use work.user_sys_pcie_constants_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity ezdma2_wrapper is
	port (		
	   CLK                     : in  std_logic;
		RSTN                    : in  std_logic;
		TEST_MODE_I             : in  std_logic_vector(15 downto 0);
		-- PCIe interface:
		TRN_LNK_UP_N            : in  std_logic;
		TRN_TD                  : out std_logic_vector(63 downto 0);
		TRN_TREM_N              : out std_logic_vector(0 downto 0);
		TRN_TSOF_N              : out std_logic;
		TRN_TEOF_N              : out std_logic;
		TRN_TSRC_DSC_N          : out std_logic;
		TRN_TSRC_RDY_N          : out std_logic;
		TRN_TDST_RDY_N          : in  std_logic;
		TRN_TERR_DROP_N         : in  std_logic;
		TRN_TERRFWD_N           : out std_logic;
		TRN_TSTR_N              : out std_logic;
		TRN_TBUF_AV             : in  std_logic_vector( 5 downto 0);
		TRN_RD                  : in  std_logic_vector(63 downto 0);
		TRN_RSOF_N              : in  std_logic;
		TRN_REOF_N              : in  std_logic;
		TRN_RSRC_DSC_N          : in  std_logic;
		TRN_RSRC_RDY_N          : in  std_logic;
		TRN_RBAR_HIT_N          : in  std_logic_vector( 6 downto 0);
		TRN_RDST_RDY_N          : out std_logic;
		TRN_RERRFWD_N           : in  std_logic;
		TRN_RNP_OK_N            : out std_logic;
		CFG_ERR_COR_N           : out std_logic;
		CFG_ERR_CPL_ABORT_N     : out std_logic;
		CFG_ERR_CPL_TIMEOUT_N   : out std_logic;
		CFG_ERR_CPL_UNEXPECT_N  : out std_logic;
		CFG_ERR_ECRC_N          : out std_logic;
		CFG_ERR_POSTED_N        : out std_logic;
		CFG_ERR_TLP_CPL_HEADER  : out std_logic_vector(47 downto 0);
		CFG_ERR_UR_N            : out std_logic;
		CFG_ERR_CPL_RDY_N       : in  std_logic;
		CFG_ERR_LOCKED_N        : out std_logic;
		CFG_INTERRUPT_N         : out std_logic;
		CFG_INTERRUPT_RDY_N     : in  std_logic;
		CFG_PCIE_LINK_STATE_N   : in  std_logic_vector( 2 downto 0);
		CFG_INTERRUPT_ASSERT_N  : out std_logic;
		CFG_INTERRUPT_DI        : out std_logic_vector( 7 downto 0);
		CFG_INTERRUPT_DO        : in  std_logic_vector( 7 downto 0);
		CFG_INTERRUPT_MMENABLE  : in  std_logic_vector( 2 downto 0);
		CFG_INTERRUPT_MSIENABLE : in  std_logic;
		CFG_TRN_PENDING_N       : out std_logic;
		CFG_BUS_NUMBER          : in  std_logic_vector( 7 downto 0);
		CFG_DEVICE_NUMBER       : in  std_logic_vector( 4 downto 0);
		CFG_FUNCTION_NUMBER     : in  std_logic_vector( 2 downto 0);
		CFG_STATUS              : in  std_logic_vector(15 downto 0);
		CFG_COMMAND             : in  std_logic_vector(15 downto 0);
		CFG_DSTATUS             : in  std_logic_vector(15 downto 0);
		CFG_DCOMMAND            : in  std_logic_vector(15 downto 0);
		CFG_LSTATUS             : in  std_logic_vector(15 downto 0);
		CFG_LCOMMAND            : in  std_logic_vector(15 downto 0);
		CFG_prmcsr 					: out std_logic_vector(31 downto 0);
		CFG_devcsr 					: out std_logic_vector(31 downto 0);
		CFG_linkcsr 				: out std_logic_vector(31 downto 0);
		CFG_msicsr 					: out std_logic_vector(15 downto 0);	
		CFG_ltssm 					: out std_logic_vector( 4 downto 0);			
		-- Slave interface:								
		SLV_I							: in  R_slv_to_ezdma2;	
		SLV_O							: out R_slv_from_ezdma2;
		-- General DMA ports:	
		GDMA_I						: in  R_gDma_to_ezdma2;	                       		                             
		GDMA_O						: out R_gDma_from_ezdma2;				
		-- EZDMA2 - IPbus fabric interface DMA ports:	
		DMA0_I						: in  R_dma_to_ezdma2; 	
		DMA0_O						: out R_dma_from_ezdma2;	
		-- User DMA ports:
		USER_DMA_REGIN_I			: in  T_dma_regin;	
	   USER_DMA_REGOUT_O	      : out T_dma_regout;	
	   USER_DMA_PARAM_I 	      : in  T_dma_param; 	
	   USER_DMA_CONTROL_I	   : in  T_dma_control;
	   USER_DMA_STATUS_O	      : out T_dma_status;	
	   USER_DMA_FIFOCNT_I	   : in  T_dma_fifocnt;	
		-- PCIe Interruptions:
		PCIE_INTERRUPT_I			: in  R_int_to_ezdma2;		
		PCIE_INTERRUPT_O 			: out R_int_from_ezdma2
	);
end ezdma2_wrapper;
architecture structural of ezdma2_wrapper is	
	--============================ Declarations ===========================--
	--Signals:
	signal dma_regout						: T_dma_regout;
	signal dma_status						: T_dma_status;
	--=====================================================================--	
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--
	--===================== Component Instantiations ======================--
	
	ezdma2_1dma_gen: if NUM_USER_SYS_PCIE_DMA = 0 generate
		ezdma2_core_inst: entity work.ezdma2_core_1dma_250mhz
			port map (
				clk										=> CLK,
				rstn										=> RSTN,
				test_mode	    						=> TEST_MODE_I,
				-- PCIe interface:
				trn_lnk_up_n							=> trn_lnk_up_n,
				trn_td									=> trn_td,
				trn_trem_n(0)							=> trn_trem_n(0),
				trn_trem_n(1)							=> open,	
				trn_tsof_n								=> trn_tsof_n,
				trn_teof_n								=> trn_teof_n,
				trn_tsrc_rdy_n							=> trn_tsrc_rdy_n,
				trn_tdst_rdy_n							=> trn_tdst_rdy_n,
				trn_terr_drop_n						=> trn_terr_drop_n,
				trn_tsrc_dsc_n							=> trn_tsrc_dsc_n,
				trn_terrfwd_n							=> trn_terrfwd_n,
				trn_tbuf_av								=> trn_tbuf_av,
				trn_tstr_n								=> trn_tstr_n,
				trn_rd									=> trn_rd,
	--			trn_rrem_n								=> trn_rrem_n,
				trn_rsof_n								=> trn_rsof_n,
				trn_reof_n								=> trn_reof_n,
				trn_rsrc_rdy_n							=> trn_rsrc_rdy_n,
				trn_rsrc_dsc_n							=> trn_rsrc_dsc_n,
				trn_rdst_rdy_n							=> trn_rdst_rdy_n,
				trn_rerrfwd_n							=> trn_rerrfwd_n,
				trn_rnp_ok_n							=> trn_rnp_ok_n,
				trn_rbar_hit_n							=> trn_rbar_hit_n,
				cfg_err_cor_n							=> cfg_err_cor_n,
				cfg_err_ur_n							=> cfg_err_ur_n,
				cfg_err_ecrc_n							=> cfg_err_ecrc_n,
				cfg_err_cpl_timeout_n				=> cfg_err_cpl_timeout_n,
				cfg_err_cpl_abort_n					=> cfg_err_cpl_abort_n,
				cfg_err_cpl_unexpect_n				=> cfg_err_cpl_unexpect_n,
				cfg_err_posted_n						=> cfg_err_posted_n,
				cfg_err_locked_n						=> cfg_err_locked_n,
				cfg_err_tlp_cpl_header				=> cfg_err_tlp_cpl_header,
				cfg_err_cpl_rdy_n						=> cfg_err_cpl_rdy_n,
				cfg_interrupt_n						=> cfg_interrupt_n,
				cfg_interrupt_rdy_n					=> cfg_interrupt_rdy_n,
				cfg_interrupt_assert_n				=> cfg_interrupt_assert_n,
				cfg_interrupt_di						=> cfg_interrupt_di,
				cfg_interrupt_do						=> cfg_interrupt_do,
				cfg_interrupt_mmenable				=> cfg_interrupt_mmenable,
				cfg_interrupt_msienable				=> cfg_interrupt_msienable,
				cfg_pcie_link_state_n				=> cfg_pcie_link_state_n,
				cfg_trn_pending_n						=> cfg_trn_pending_n,
				cfg_bus_number							=> cfg_bus_number,
				cfg_device_number						=> cfg_device_number,
				cfg_function_number					=> cfg_function_number,
				cfg_status								=> cfg_status,
				cfg_command								=> cfg_command,
				cfg_dstatus			   				=> cfg_dstatus,
				cfg_dcommand							=> cfg_dcommand,
				cfg_lstatus								=> cfg_lstatus,
				cfg_lcommand							=> cfg_lcommand,		
				cfg_prmcsr 								=> cfg_prmcsr,
				cfg_devcsr 								=> cfg_devcsr,
				cfg_linkcsr 							=> cfg_linkcsr,
				cfg_msicsr 								=> cfg_msicsr,
				cfg_ltssm 								=> cfg_ltssm,	
				-- Slave interface:								
				slv_dataout								=> SLV_O.dataout,					
				slv_bytevalid							=> SLV_O.bytevalid,            
				slv_bytecount							=> SLV_O.bytecount,            
				slv_dwcount								=> SLV_O.dwcount,                            
				slv_addr									=> SLV_O.addr,                    
				slv_bar									=> SLV_O.bar,                  
				slv_readreq								=> SLV_O.readreq,              
				slv_cpladdr								=> SLV_O.cpladdr,              
				slv_cplparam							=> SLV_O.cplparam,             
				slv_writereq							=> SLV_O.writereq,             
				slv_write								=> SLV_O.wr,                
				slv_lastwrite							=> SLV_O.lastwrite,                            
				slv_io         						=> SLV_O.io,     		                       
				slv_accept								=> SLV_I.accept,                
				slv_abort								=> SLV_I.abort,                 
				slv_ur         						=> SLV_I.ur,	-- NOTE!!! Tie to '0' when not used	
				-- General DMA ports:							
				dma_rd									=> GDMA_O.rd,							
				dma_rdaddr								=> GDMA_O.rdaddr, 		                       
				dma_rdchannel							=> GDMA_O.rdchannel,                   
				dma_rddata								=> GDMA_I.rddata,           
				dma_wr									=> GDMA_O.wr,                          
				dma_wraddr								=> GDMA_O.wraddr, 	                                    
				dma_wrchannel							=> GDMA_O.wrchannel,                   
				dma_wrdata								=> GDMA_O.wrdata,                      
				dma_wrbytevalid						=> GDMA_O.wrbytevalid,                                       
				-- EZDMA2 - IPbus fabric interface DMA ports:	
				dma0_regin								=> DMA0_I.regin,		
				dma0_regout								=> DMA0_O.regout,   
				dma0_param								=> DMA0_I.param,    
				dma0_control							=> DMA0_I.control,  
				dma0_status								=> DMA0_O.status,   
				dma0_fifocnt							=> DMA0_I.fifocnt,  		
				-- User DMA ports:
	
				-- PCIe Interruptions:
				int_request 							=> PCIE_INTERRUPT_I.request,
				int_msgnum 								=> PCIE_INTERRUPT_I.msgnum,			
				int_ack									=> PCIE_INTERRUPT_O.ack
			);
	end generate;
	
	ezdma2_2dma_gen: if NUM_USER_SYS_PCIE_DMA = 1 generate
		ezdma2_core_inst: entity work.ezdma2_core_2dma_250mhz
			port map (
				clk										=> CLK,
				rstn										=> RSTN,
				test_mode	    						=> TEST_MODE_I,
				-- PCIe interface:
				trn_lnk_up_n							=> trn_lnk_up_n,
				trn_td									=> trn_td,
				trn_trem_n(0)							=> trn_trem_n(0),
				trn_trem_n(1)							=> open,	
				trn_tsof_n								=> trn_tsof_n,
				trn_teof_n								=> trn_teof_n,
				trn_tsrc_rdy_n							=> trn_tsrc_rdy_n,
				trn_tdst_rdy_n							=> trn_tdst_rdy_n,
				trn_terr_drop_n						=> trn_terr_drop_n,
				trn_tsrc_dsc_n							=> trn_tsrc_dsc_n,
				trn_terrfwd_n							=> trn_terrfwd_n,
				trn_tbuf_av								=> trn_tbuf_av,
				trn_tstr_n								=> trn_tstr_n,
				trn_rd									=> trn_rd,
	--			trn_rrem_n								=> trn_rrem_n,
				trn_rsof_n								=> trn_rsof_n,
				trn_reof_n								=> trn_reof_n,
				trn_rsrc_rdy_n							=> trn_rsrc_rdy_n,
				trn_rsrc_dsc_n							=> trn_rsrc_dsc_n,
				trn_rdst_rdy_n							=> trn_rdst_rdy_n,
				trn_rerrfwd_n							=> trn_rerrfwd_n,
				trn_rnp_ok_n							=> trn_rnp_ok_n,
				trn_rbar_hit_n							=> trn_rbar_hit_n,
				cfg_err_cor_n							=> cfg_err_cor_n,
				cfg_err_ur_n							=> cfg_err_ur_n,
				cfg_err_ecrc_n							=> cfg_err_ecrc_n,
				cfg_err_cpl_timeout_n				=> cfg_err_cpl_timeout_n,
				cfg_err_cpl_abort_n					=> cfg_err_cpl_abort_n,
				cfg_err_cpl_unexpect_n				=> cfg_err_cpl_unexpect_n,
				cfg_err_posted_n						=> cfg_err_posted_n,
				cfg_err_locked_n						=> cfg_err_locked_n,
				cfg_err_tlp_cpl_header				=> cfg_err_tlp_cpl_header,
				cfg_err_cpl_rdy_n						=> cfg_err_cpl_rdy_n,
				cfg_interrupt_n						=> cfg_interrupt_n,
				cfg_interrupt_rdy_n					=> cfg_interrupt_rdy_n,
				cfg_interrupt_assert_n				=> cfg_interrupt_assert_n,
				cfg_interrupt_di						=> cfg_interrupt_di,
				cfg_interrupt_do						=> cfg_interrupt_do,
				cfg_interrupt_mmenable				=> cfg_interrupt_mmenable,
				cfg_interrupt_msienable				=> cfg_interrupt_msienable,
				cfg_pcie_link_state_n				=> cfg_pcie_link_state_n,
				cfg_trn_pending_n						=> cfg_trn_pending_n,
				cfg_bus_number							=> cfg_bus_number,
				cfg_device_number						=> cfg_device_number,
				cfg_function_number					=> cfg_function_number,
				cfg_status								=> cfg_status,
				cfg_command								=> cfg_command,
				cfg_dstatus			   				=> cfg_dstatus,
				cfg_dcommand							=> cfg_dcommand,
				cfg_lstatus								=> cfg_lstatus,
				cfg_lcommand							=> cfg_lcommand,		
				cfg_prmcsr 								=> cfg_prmcsr,
				cfg_devcsr 								=> cfg_devcsr,
				cfg_linkcsr 							=> cfg_linkcsr,
				cfg_msicsr 								=> cfg_msicsr,
				cfg_ltssm 								=> cfg_ltssm,	
				-- Slave interface:								
				slv_dataout								=> SLV_O.dataout,					
				slv_bytevalid							=> SLV_O.bytevalid,            
				slv_bytecount							=> SLV_O.bytecount,            
				slv_dwcount								=> SLV_O.dwcount,                            
				slv_addr									=> SLV_O.addr,                    
				slv_bar									=> SLV_O.bar,                  
				slv_readreq								=> SLV_O.readreq,              
				slv_cpladdr								=> SLV_O.cpladdr,              
				slv_cplparam							=> SLV_O.cplparam,             
				slv_writereq							=> SLV_O.writereq,            
				slv_write								=> SLV_O.wr,                
				slv_lastwrite							=> SLV_O.lastwrite,                            
				slv_io         						=> SLV_O.io,     		                       
				slv_accept								=> SLV_I.accept,                
				slv_abort								=> SLV_I.abort,                 
				slv_ur         						=> SLV_I.ur,	-- NOTE!!! Tie to '0' when not used	
				-- General DMA ports:							
				dma_rd									=> GDMA_O.rd,							
				dma_rdaddr								=> GDMA_O.rdaddr, 		                       
				dma_rdchannel							=> GDMA_O.rdchannel,                   
				dma_rddata								=> GDMA_I.rddata,           
				dma_wr									=> GDMA_O.wr,                          
				dma_wraddr								=> GDMA_O.wraddr, 	                                    
				dma_wrchannel							=> GDMA_O.wrchannel,                   
				dma_wrdata								=> GDMA_O.wrdata,                      
				dma_wrbytevalid						=> GDMA_O.wrbytevalid,                                       
				-- EZDMA2 - IPbus fabric interface DMA ports:	
				dma0_regin								=> DMA0_I.regin,		
				dma0_regout								=> DMA0_O.regout,   
				dma0_param								=> DMA0_I.param,    
				dma0_control							=> DMA0_I.control,  
				dma0_status								=> DMA0_O.status,   
				dma0_fifocnt							=> DMA0_I.fifocnt,  		
				-- User DMA ports:
				dma1_regin								=> USER_DMA_REGIN_I  (1),
				dma1_regout								=> dma_regout			(1),
				dma1_param								=> USER_DMA_PARAM_I  (1),
				dma1_control							=> USER_DMA_CONTROL_I(1),
				dma1_status								=> dma_status        (1),
				dma1_fifocnt							=> USER_DMA_FIFOCNT_I(1),				
				-- PCIe Interruptions:
				int_request 							=> PCIE_INTERRUPT_I.request,
				int_msgnum 								=> PCIE_INTERRUPT_I.msgnum,			
				int_ack									=> PCIE_INTERRUPT_O.ack
			);
	end generate;
	
	ezdma2_3dma_gen: if NUM_USER_SYS_PCIE_DMA = 2 generate
		ezdma2_core_inst: entity work.ezdma2_core_3dma_250mhz
			port map (
				clk										=> CLK,
				rstn										=> RSTN,
				test_mode	    						=> TEST_MODE_I,
				-- PCIe interface:
				trn_lnk_up_n							=> trn_lnk_up_n,
				trn_td									=> trn_td,
				trn_trem_n(0)							=> trn_trem_n(0),
				trn_trem_n(1)							=> open,	
				trn_tsof_n								=> trn_tsof_n,
				trn_teof_n								=> trn_teof_n,
				trn_tsrc_rdy_n							=> trn_tsrc_rdy_n,
				trn_tdst_rdy_n							=> trn_tdst_rdy_n,
				trn_terr_drop_n						=> trn_terr_drop_n,
				trn_tsrc_dsc_n							=> trn_tsrc_dsc_n,
				trn_terrfwd_n							=> trn_terrfwd_n,
				trn_tbuf_av								=> trn_tbuf_av,
				trn_tstr_n								=> trn_tstr_n,
				trn_rd									=> trn_rd,
	--			trn_rrem_n								=> trn_rrem_n,
				trn_rsof_n								=> trn_rsof_n,
				trn_reof_n								=> trn_reof_n,
				trn_rsrc_rdy_n							=> trn_rsrc_rdy_n,
				trn_rsrc_dsc_n							=> trn_rsrc_dsc_n,
				trn_rdst_rdy_n							=> trn_rdst_rdy_n,
				trn_rerrfwd_n							=> trn_rerrfwd_n,
				trn_rnp_ok_n							=> trn_rnp_ok_n,
				trn_rbar_hit_n							=> trn_rbar_hit_n,
				cfg_err_cor_n							=> cfg_err_cor_n,
				cfg_err_ur_n							=> cfg_err_ur_n,
				cfg_err_ecrc_n							=> cfg_err_ecrc_n,
				cfg_err_cpl_timeout_n				=> cfg_err_cpl_timeout_n,
				cfg_err_cpl_abort_n					=> cfg_err_cpl_abort_n,
				cfg_err_cpl_unexpect_n				=> cfg_err_cpl_unexpect_n,
				cfg_err_posted_n						=> cfg_err_posted_n,
				cfg_err_locked_n						=> cfg_err_locked_n,
				cfg_err_tlp_cpl_header				=> cfg_err_tlp_cpl_header,
				cfg_err_cpl_rdy_n						=> cfg_err_cpl_rdy_n,
				cfg_interrupt_n						=> cfg_interrupt_n,
				cfg_interrupt_rdy_n					=> cfg_interrupt_rdy_n,
				cfg_interrupt_assert_n				=> cfg_interrupt_assert_n,
				cfg_interrupt_di						=> cfg_interrupt_di,
				cfg_interrupt_do						=> cfg_interrupt_do,
				cfg_interrupt_mmenable				=> cfg_interrupt_mmenable,
				cfg_interrupt_msienable				=> cfg_interrupt_msienable,
				cfg_pcie_link_state_n				=> cfg_pcie_link_state_n,
				cfg_trn_pending_n						=> cfg_trn_pending_n,
				cfg_bus_number							=> cfg_bus_number,
				cfg_device_number						=> cfg_device_number,
				cfg_function_number					=> cfg_function_number,
				cfg_status								=> cfg_status,
				cfg_command								=> cfg_command,
				cfg_dstatus			   				=> cfg_dstatus,
				cfg_dcommand							=> cfg_dcommand,
				cfg_lstatus								=> cfg_lstatus,
				cfg_lcommand							=> cfg_lcommand,		
				cfg_prmcsr 								=> cfg_prmcsr,
				cfg_devcsr 								=> cfg_devcsr,
				cfg_linkcsr 							=> cfg_linkcsr,
				cfg_msicsr 								=> cfg_msicsr,
				cfg_ltssm 								=> cfg_ltssm,	
				-- Slave interface:								
				slv_dataout								=> SLV_O.dataout,					
				slv_bytevalid							=> SLV_O.bytevalid,            
				slv_bytecount							=> SLV_O.bytecount,            
				slv_dwcount								=> SLV_O.dwcount,                            
				slv_addr									=> SLV_O.addr,                    
				slv_bar									=> SLV_O.bar,                  
				slv_readreq								=> SLV_O.readreq,              
				slv_cpladdr								=> SLV_O.cpladdr,              
				slv_cplparam							=> SLV_O.cplparam,             
				slv_writereq							=> SLV_O.writereq,             
				slv_write								=> SLV_O.wr,                
				slv_lastwrite							=> SLV_O.lastwrite,                            
				slv_io         						=> SLV_O.io,     		                       
				slv_accept								=> SLV_I.accept,                
				slv_abort								=> SLV_I.abort,                 
				slv_ur         						=> SLV_I.ur,	-- NOTE!!! Tie to '0' when not used	
				-- General DMA ports:							
				dma_rd									=> GDMA_O.rd,							
				dma_rdaddr								=> GDMA_O.rdaddr, 		                       
				dma_rdchannel							=> GDMA_O.rdchannel,                   
				dma_rddata								=> GDMA_I.rddata,           
				dma_wr									=> GDMA_O.wr,                          
				dma_wraddr								=> GDMA_O.wraddr, 	                                    
				dma_wrchannel							=> GDMA_O.wrchannel,                   
				dma_wrdata								=> GDMA_O.wrdata,                      
				dma_wrbytevalid						=> GDMA_O.wrbytevalid,                                       
				-- EZDMA2 - IPbus fabric interface DMA ports:	
				dma0_regin								=> DMA0_I.regin,		
				dma0_regout								=> DMA0_O.regout,   
				dma0_param								=> DMA0_I.param,    
				dma0_control							=> DMA0_I.control,  
				dma0_status								=> DMA0_O.status,   
				dma0_fifocnt							=> DMA0_I.fifocnt,  		
				-- User DMA ports:
				dma1_regin								=> USER_DMA_REGIN_I  (1),
				dma1_regout								=> dma_regout			(1),
				dma1_param								=> USER_DMA_PARAM_I  (1),
				dma1_control							=> USER_DMA_CONTROL_I(1),
				dma1_status								=> dma_status        (1),
				dma1_fifocnt							=> USER_DMA_FIFOCNT_I(1),
				-----------------						   
				dma2_regin								=>	USER_DMA_REGIN_I  (2),
				dma2_regout								=> dma_regout        (2), 
				dma2_param								=> USER_DMA_PARAM_I  (2),  
				dma2_control							=> USER_DMA_CONTROL_I(2),
				dma2_status								=> dma_status        (2), 
				dma2_fifocnt							=>	USER_DMA_FIFOCNT_I(2),	
				-- PCIe Interruptions:
				int_request 							=> PCIE_INTERRUPT_I.request,
				int_msgnum 								=> PCIE_INTERRUPT_I.msgnum,			
				int_ack									=> PCIE_INTERRUPT_O.ack
			);
	end generate;
	
	ezdma2_4dma_gen: if NUM_USER_SYS_PCIE_DMA = 3 generate
		ezdma2_core_inst: entity work.ezdma2_core_4dma_250mhz
			port map (
				clk										=> CLK,
				rstn										=> RSTN,
				test_mode	    						=> TEST_MODE_I,
				-- PCIe interface:
				trn_lnk_up_n							=> trn_lnk_up_n,
				trn_td									=> trn_td,
				trn_trem_n(0)							=> trn_trem_n(0),
				trn_trem_n(1)							=> open,	
				trn_tsof_n								=> trn_tsof_n,
				trn_teof_n								=> trn_teof_n,
				trn_tsrc_rdy_n							=> trn_tsrc_rdy_n,
				trn_tdst_rdy_n							=> trn_tdst_rdy_n,
				trn_terr_drop_n						=> trn_terr_drop_n,
				trn_tsrc_dsc_n							=> trn_tsrc_dsc_n,
				trn_terrfwd_n							=> trn_terrfwd_n,
				trn_tbuf_av								=> trn_tbuf_av,
				trn_tstr_n								=> trn_tstr_n,
				trn_rd									=> trn_rd,
	--			trn_rrem_n								=> trn_rrem_n,
				trn_rsof_n								=> trn_rsof_n,
				trn_reof_n								=> trn_reof_n,
				trn_rsrc_rdy_n							=> trn_rsrc_rdy_n,
				trn_rsrc_dsc_n							=> trn_rsrc_dsc_n,
				trn_rdst_rdy_n							=> trn_rdst_rdy_n,
				trn_rerrfwd_n							=> trn_rerrfwd_n,
				trn_rnp_ok_n							=> trn_rnp_ok_n,
				trn_rbar_hit_n							=> trn_rbar_hit_n,
				cfg_err_cor_n							=> cfg_err_cor_n,
				cfg_err_ur_n							=> cfg_err_ur_n,
				cfg_err_ecrc_n							=> cfg_err_ecrc_n,
				cfg_err_cpl_timeout_n				=> cfg_err_cpl_timeout_n,
				cfg_err_cpl_abort_n					=> cfg_err_cpl_abort_n,
				cfg_err_cpl_unexpect_n				=> cfg_err_cpl_unexpect_n,
				cfg_err_posted_n						=> cfg_err_posted_n,
				cfg_err_locked_n						=> cfg_err_locked_n,
				cfg_err_tlp_cpl_header				=> cfg_err_tlp_cpl_header,
				cfg_err_cpl_rdy_n						=> cfg_err_cpl_rdy_n,
				cfg_interrupt_n						=> cfg_interrupt_n,
				cfg_interrupt_rdy_n					=> cfg_interrupt_rdy_n,
				cfg_interrupt_assert_n				=> cfg_interrupt_assert_n,
				cfg_interrupt_di						=> cfg_interrupt_di,
				cfg_interrupt_do						=> cfg_interrupt_do,
				cfg_interrupt_mmenable				=> cfg_interrupt_mmenable,
				cfg_interrupt_msienable				=> cfg_interrupt_msienable,
				cfg_pcie_link_state_n				=> cfg_pcie_link_state_n,
				cfg_trn_pending_n						=> cfg_trn_pending_n,
				cfg_bus_number							=> cfg_bus_number,
				cfg_device_number						=> cfg_device_number,
				cfg_function_number					=> cfg_function_number,
				cfg_status								=> cfg_status,
				cfg_command								=> cfg_command,
				cfg_dstatus			   				=> cfg_dstatus,
				cfg_dcommand							=> cfg_dcommand,
				cfg_lstatus								=> cfg_lstatus,
				cfg_lcommand							=> cfg_lcommand,		
				cfg_prmcsr 								=> cfg_prmcsr,
				cfg_devcsr 								=> cfg_devcsr,
				cfg_linkcsr 							=> cfg_linkcsr,
				cfg_msicsr 								=> cfg_msicsr,
				cfg_ltssm 								=> cfg_ltssm,	
				-- Slave interface:								
				slv_dataout								=> SLV_O.dataout,					
				slv_bytevalid							=> SLV_O.bytevalid,            
				slv_bytecount							=> SLV_O.bytecount,            
				slv_dwcount								=> SLV_O.dwcount,                            
				slv_addr									=> SLV_O.addr,                    
				slv_bar									=> SLV_O.bar,                  
				slv_readreq								=> SLV_O.readreq,              
				slv_cpladdr								=> SLV_O.cpladdr,              
				slv_cplparam							=> SLV_O.cplparam,             
				slv_writereq							=> SLV_O.writereq,             
				slv_write								=> SLV_O.wr,                
				slv_lastwrite							=> SLV_O.lastwrite,                            
				slv_io         						=> SLV_O.io,     		                       
				slv_accept								=> SLV_I.accept,                
				slv_abort								=> SLV_I.abort,                 
				slv_ur         						=> SLV_I.ur,	-- NOTE!!! Tie to '0' when not used	
				-- General DMA ports:							
				dma_rd									=> GDMA_O.rd,							
				dma_rdaddr								=> GDMA_O.rdaddr, 		                       
				dma_rdchannel							=> GDMA_O.rdchannel,                   
				dma_rddata								=> GDMA_I.rddata,           
				dma_wr									=> GDMA_O.wr,                          
				dma_wraddr								=> GDMA_O.wraddr, 	                                    
				dma_wrchannel							=> GDMA_O.wrchannel,                   
				dma_wrdata								=> GDMA_O.wrdata,                      
				dma_wrbytevalid						=> GDMA_O.wrbytevalid,                                       
				-- EZDMA2 - IPbus fabric interface DMA ports:	
				dma0_regin								=> DMA0_I.regin,		
				dma0_regout								=> DMA0_O.regout,   
				dma0_param								=> DMA0_I.param,    
				dma0_control							=> DMA0_I.control,  
				dma0_status								=> DMA0_O.status,   
				dma0_fifocnt							=> DMA0_I.fifocnt,  		
				-- User DMA ports:
				dma1_regin								=> USER_DMA_REGIN_I  (1),
				dma1_regout								=> dma_regout			(1),
				dma1_param								=> USER_DMA_PARAM_I  (1),
				dma1_control							=> USER_DMA_CONTROL_I(1),
				dma1_status								=> dma_status        (1),
				dma1_fifocnt							=> USER_DMA_FIFOCNT_I(1),
				-----------------						   
				dma2_regin								=>	USER_DMA_REGIN_I  (2),
				dma2_regout								=> dma_regout        (2), 
				dma2_param								=> USER_DMA_PARAM_I  (2),  
				dma2_control							=> USER_DMA_CONTROL_I(2),
				dma2_status								=> dma_status        (2), 
				dma2_fifocnt							=>	USER_DMA_FIFOCNT_I(2),
				-----------------			            
				dma3_regin								=>	USER_DMA_REGIN_I  (3),
				dma3_regout								=> dma_regout        (3),
				dma3_param								=> USER_DMA_PARAM_I  (3), 
				dma3_control							=> USER_DMA_CONTROL_I(3),
				dma3_status								=> dma_status        (3),
				dma3_fifocnt							=> USER_DMA_FIFOCNT_I(3),		
				-- PCIe Interruptions:
				int_request 							=> PCIE_INTERRUPT_I.request,
				int_msgnum 								=> PCIE_INTERRUPT_I.msgnum,			
				int_ack									=> PCIE_INTERRUPT_O.ack
			);
	end generate;
	
	ezdma2_5dma_gen: if NUM_USER_SYS_PCIE_DMA = 4 generate
		ezdma2_core_inst: entity work.ezdma2_core_5dma_250mhz
			port map (
				clk										=> CLK,
				rstn										=> RSTN,
				test_mode	    						=> TEST_MODE_I,
				-- PCIe interface:
				trn_lnk_up_n							=> trn_lnk_up_n,
				trn_td									=> trn_td,
				trn_trem_n(0)							=> trn_trem_n(0),
				trn_trem_n(1)							=> open,	
				trn_tsof_n								=> trn_tsof_n,
				trn_teof_n								=> trn_teof_n,
				trn_tsrc_rdy_n							=> trn_tsrc_rdy_n,
				trn_tdst_rdy_n							=> trn_tdst_rdy_n,
				trn_terr_drop_n						=> trn_terr_drop_n,
				trn_tsrc_dsc_n							=> trn_tsrc_dsc_n,
				trn_terrfwd_n							=> trn_terrfwd_n,
				trn_tbuf_av								=> trn_tbuf_av,
				trn_tstr_n								=> trn_tstr_n,
				trn_rd									=> trn_rd,
	--			trn_rrem_n								=> trn_rrem_n,
				trn_rsof_n								=> trn_rsof_n,
				trn_reof_n								=> trn_reof_n,
				trn_rsrc_rdy_n							=> trn_rsrc_rdy_n,
				trn_rsrc_dsc_n							=> trn_rsrc_dsc_n,
				trn_rdst_rdy_n							=> trn_rdst_rdy_n,
				trn_rerrfwd_n							=> trn_rerrfwd_n,
				trn_rnp_ok_n							=> trn_rnp_ok_n,
				trn_rbar_hit_n							=> trn_rbar_hit_n,
				cfg_err_cor_n							=> cfg_err_cor_n,
				cfg_err_ur_n							=> cfg_err_ur_n,
				cfg_err_ecrc_n							=> cfg_err_ecrc_n,
				cfg_err_cpl_timeout_n				=> cfg_err_cpl_timeout_n,
				cfg_err_cpl_abort_n					=> cfg_err_cpl_abort_n,
				cfg_err_cpl_unexpect_n				=> cfg_err_cpl_unexpect_n,
				cfg_err_posted_n						=> cfg_err_posted_n,
				cfg_err_locked_n						=> cfg_err_locked_n,
				cfg_err_tlp_cpl_header				=> cfg_err_tlp_cpl_header,
				cfg_err_cpl_rdy_n						=> cfg_err_cpl_rdy_n,
				cfg_interrupt_n						=> cfg_interrupt_n,
				cfg_interrupt_rdy_n					=> cfg_interrupt_rdy_n,
				cfg_interrupt_assert_n				=> cfg_interrupt_assert_n,
				cfg_interrupt_di						=> cfg_interrupt_di,
				cfg_interrupt_do						=> cfg_interrupt_do,
				cfg_interrupt_mmenable				=> cfg_interrupt_mmenable,
				cfg_interrupt_msienable				=> cfg_interrupt_msienable,
				cfg_pcie_link_state_n				=> cfg_pcie_link_state_n,
				cfg_trn_pending_n						=> cfg_trn_pending_n,
				cfg_bus_number							=> cfg_bus_number,
				cfg_device_number						=> cfg_device_number,
				cfg_function_number					=> cfg_function_number,
				cfg_status								=> cfg_status,
				cfg_command								=> cfg_command,
				cfg_dstatus			   				=> cfg_dstatus,
				cfg_dcommand							=> cfg_dcommand,
				cfg_lstatus								=> cfg_lstatus,
				cfg_lcommand							=> cfg_lcommand,		
				cfg_prmcsr 								=> cfg_prmcsr,
				cfg_devcsr 								=> cfg_devcsr,
				cfg_linkcsr 							=> cfg_linkcsr,
				cfg_msicsr 								=> cfg_msicsr,
				cfg_ltssm 								=> cfg_ltssm,	
				-- Slave interface:								
				slv_dataout								=> SLV_O.dataout,					
				slv_bytevalid							=> SLV_O.bytevalid,            
				slv_bytecount							=> SLV_O.bytecount,            
				slv_dwcount								=> SLV_O.dwcount,                            
				slv_addr									=> SLV_O.addr,                    
				slv_bar									=> SLV_O.bar,                  
				slv_readreq								=> SLV_O.readreq,              
				slv_cpladdr								=> SLV_O.cpladdr,              
				slv_cplparam							=> SLV_O.cplparam,             
				slv_writereq							=> SLV_O.writereq,             
				slv_write								=> SLV_O.wr,                
				slv_lastwrite							=> SLV_O.lastwrite,                            
				slv_io         						=> SLV_O.io,     		                       
				slv_accept								=> SLV_I.accept,                
				slv_abort								=> SLV_I.abort,                 
				slv_ur         						=> SLV_I.ur,	-- NOTE!!! Tie to '0' when not used	
				-- General DMA ports:							
				dma_rd									=> GDMA_O.rd,							
				dma_rdaddr								=> GDMA_O.rdaddr, 		                       
				dma_rdchannel							=> GDMA_O.rdchannel,                   
				dma_rddata								=> GDMA_I.rddata,           
				dma_wr									=> GDMA_O.wr,                          
				dma_wraddr								=> GDMA_O.wraddr, 	                                    
				dma_wrchannel							=> GDMA_O.wrchannel,                   
				dma_wrdata								=> GDMA_O.wrdata,                      
				dma_wrbytevalid						=> GDMA_O.wrbytevalid,                                       
				-- EZDMA2 - IPbus fabric interface DMA ports:	
				dma0_regin								=> DMA0_I.regin,		
				dma0_regout								=> DMA0_O.regout,   
				dma0_param								=> DMA0_I.param,    
				dma0_control							=> DMA0_I.control,  
				dma0_status								=> DMA0_O.status,   
				dma0_fifocnt							=> DMA0_I.fifocnt,  		
				-- User DMA ports:
				dma1_regin								=> USER_DMA_REGIN_I  (1),
				dma1_regout								=> dma_regout			(1),
				dma1_param								=> USER_DMA_PARAM_I  (1),
				dma1_control							=> USER_DMA_CONTROL_I(1),
				dma1_status								=> dma_status        (1),
				dma1_fifocnt							=> USER_DMA_FIFOCNT_I(1),
				-----------------						   
				dma2_regin								=> USER_DMA_REGIN_I  (2),
				dma2_regout								=> dma_regout        (2),
				dma2_param								=> USER_DMA_PARAM_I  (2),
				dma2_control							=> USER_DMA_CONTROL_I(2),
				dma2_status								=> dma_status        (2),
				dma2_fifocnt							=> USER_DMA_FIFOCNT_I(2),
				-----------------			            
				dma3_regin								=> USER_DMA_REGIN_I  (3),
				dma3_regout								=> dma_regout        (3),
				dma3_param								=> USER_DMA_PARAM_I  (3),
				dma3_control							=> USER_DMA_CONTROL_I(3),
				dma3_status								=> dma_status        (3),
				dma3_fifocnt							=> USER_DMA_FIFOCNT_I(3),
				-----------------			            
				dma4_regin								=> USER_DMA_REGIN_I  (4),
				dma4_regout								=> dma_regout        (4),
				dma4_param								=> USER_DMA_PARAM_I  (4),
				dma4_control							=> USER_DMA_CONTROL_I(4),
				dma4_status								=> dma_status        (4),
				dma4_fifocnt							=> USER_DMA_FIFOCNT_I(4),			
				-- PCIe Interruptions:
				int_request 							=> PCIE_INTERRUPT_I.request,
				int_msgnum 								=> PCIE_INTERRUPT_I.msgnum,			
				int_ack									=> PCIE_INTERRUPT_O.ack
			);
	end generate;
	
	ezdma2_6dma_gen: if NUM_USER_SYS_PCIE_DMA = 5 generate
		ezdma2_core_inst: entity work.ezdma2_core_6dma_250mhz
			port map (
				clk										=> CLK,
				rstn										=> RSTN,
				test_mode	    						=> TEST_MODE_I,
				-- PCIe interface:
				trn_lnk_up_n							=> trn_lnk_up_n,
				trn_td									=> trn_td,
				trn_trem_n(0)							=> trn_trem_n(0),
				trn_trem_n(1)							=> open,	
				trn_tsof_n								=> trn_tsof_n,
				trn_teof_n								=> trn_teof_n,
				trn_tsrc_rdy_n							=> trn_tsrc_rdy_n,
				trn_tdst_rdy_n							=> trn_tdst_rdy_n,
				trn_terr_drop_n						=> trn_terr_drop_n,
				trn_tsrc_dsc_n							=> trn_tsrc_dsc_n,
				trn_terrfwd_n							=> trn_terrfwd_n,
				trn_tbuf_av								=> trn_tbuf_av,
				trn_tstr_n								=> trn_tstr_n,
				trn_rd									=> trn_rd,
	--			trn_rrem_n								=> trn_rrem_n,
				trn_rsof_n								=> trn_rsof_n,
				trn_reof_n								=> trn_reof_n,
				trn_rsrc_rdy_n							=> trn_rsrc_rdy_n,
				trn_rsrc_dsc_n							=> trn_rsrc_dsc_n,
				trn_rdst_rdy_n							=> trn_rdst_rdy_n,
				trn_rerrfwd_n							=> trn_rerrfwd_n,
				trn_rnp_ok_n							=> trn_rnp_ok_n,
				trn_rbar_hit_n							=> trn_rbar_hit_n,
				cfg_err_cor_n							=> cfg_err_cor_n,
				cfg_err_ur_n							=> cfg_err_ur_n,
				cfg_err_ecrc_n							=> cfg_err_ecrc_n,
				cfg_err_cpl_timeout_n				=> cfg_err_cpl_timeout_n,
				cfg_err_cpl_abort_n					=> cfg_err_cpl_abort_n,
				cfg_err_cpl_unexpect_n				=> cfg_err_cpl_unexpect_n,
				cfg_err_posted_n						=> cfg_err_posted_n,
				cfg_err_locked_n						=> cfg_err_locked_n,
				cfg_err_tlp_cpl_header				=> cfg_err_tlp_cpl_header,
				cfg_err_cpl_rdy_n						=> cfg_err_cpl_rdy_n,
				cfg_interrupt_n						=> cfg_interrupt_n,
				cfg_interrupt_rdy_n					=> cfg_interrupt_rdy_n,
				cfg_interrupt_assert_n				=> cfg_interrupt_assert_n,
				cfg_interrupt_di						=> cfg_interrupt_di,
				cfg_interrupt_do						=> cfg_interrupt_do,
				cfg_interrupt_mmenable				=> cfg_interrupt_mmenable,
				cfg_interrupt_msienable				=> cfg_interrupt_msienable,
				cfg_pcie_link_state_n				=> cfg_pcie_link_state_n,
				cfg_trn_pending_n						=> cfg_trn_pending_n,
				cfg_bus_number							=> cfg_bus_number,
				cfg_device_number						=> cfg_device_number,
				cfg_function_number					=> cfg_function_number,
				cfg_status								=> cfg_status,
				cfg_command								=> cfg_command,
				cfg_dstatus			   				=> cfg_dstatus,
				cfg_dcommand							=> cfg_dcommand,
				cfg_lstatus								=> cfg_lstatus,
				cfg_lcommand							=> cfg_lcommand,		
				cfg_prmcsr 								=> cfg_prmcsr,
				cfg_devcsr 								=> cfg_devcsr,
				cfg_linkcsr 							=> cfg_linkcsr,
				cfg_msicsr 								=> cfg_msicsr,
				cfg_ltssm 								=> cfg_ltssm,	
				-- Slave interface:								
				slv_dataout								=> SLV_O.dataout,					
				slv_bytevalid							=> SLV_O.bytevalid,            
				slv_bytecount							=> SLV_O.bytecount,            
				slv_dwcount								=> SLV_O.dwcount,                            
				slv_addr									=> SLV_O.addr,                    
				slv_bar									=> SLV_O.bar,                  
				slv_readreq								=> SLV_O.readreq,              
				slv_cpladdr								=> SLV_O.cpladdr,              
				slv_cplparam							=> SLV_O.cplparam,             
				slv_writereq							=> SLV_O.writereq,             
				slv_write								=> SLV_O.wr,                
				slv_lastwrite							=> SLV_O.lastwrite,                            
				slv_io         						=> SLV_O.io,     		                       
				slv_accept								=> SLV_I.accept,                
				slv_abort								=> SLV_I.abort,                 
				slv_ur         						=> SLV_I.ur,	-- NOTE!!! Tie to '0' when not used	
				-- General DMA ports:							
				dma_rd									=> GDMA_O.rd,							
				dma_rdaddr								=> GDMA_O.rdaddr, 		                       
				dma_rdchannel							=> GDMA_O.rdchannel,                   
				dma_rddata								=> GDMA_I.rddata,           
				dma_wr									=> GDMA_O.wr,                          
				dma_wraddr								=> GDMA_O.wraddr, 	                                    
				dma_wrchannel							=> GDMA_O.wrchannel,                   
				dma_wrdata								=> GDMA_O.wrdata,                      
				dma_wrbytevalid						=> GDMA_O.wrbytevalid,                                       
				-- EZDMA2 - IPbus fabric interface DMA ports:	
				dma0_regin								=> DMA0_I.regin,		
				dma0_regout								=> DMA0_O.regout,   
				dma0_param								=> DMA0_I.param,    
				dma0_control							=> DMA0_I.control,  
				dma0_status								=> DMA0_O.status,   
				dma0_fifocnt							=> DMA0_I.fifocnt,  		
				-- User DMA ports:
				dma1_regin								=> USER_DMA_REGIN_I  (1),
				dma1_regout								=> dma_regout			(1),
				dma1_param								=> USER_DMA_PARAM_I  (1),
				dma1_control							=> USER_DMA_CONTROL_I(1),
				dma1_status								=> dma_status        (1),
				dma1_fifocnt							=> USER_DMA_FIFOCNT_I(1),
				-----------------						   
				dma2_regin								=> USER_DMA_REGIN_I  (2),	
				dma2_regout								=> dma_regout        (2), 
				dma2_param								=> USER_DMA_PARAM_I  (2),  
				dma2_control							=> USER_DMA_CONTROL_I(2),
				dma2_status								=> dma_status        (2), 
				dma2_fifocnt							=> USER_DMA_FIFOCNT_I(2),	
				-----------------			            
				dma3_regin								=> USER_DMA_REGIN_I  (3),	
				dma3_regout								=> dma_regout        (3),
				dma3_param								=> USER_DMA_PARAM_I  (3), 
				dma3_control							=> USER_DMA_CONTROL_I(3),
				dma3_status								=> dma_status        (3),
				dma3_fifocnt							=> USER_DMA_FIFOCNT_I(3),
				-----------------			            
				dma4_regin								=> USER_DMA_REGIN_I  (4),
				dma4_regout								=> dma_regout        (4),
				dma4_param								=> USER_DMA_PARAM_I  (4),
				dma4_control							=> USER_DMA_CONTROL_I(4),
				dma4_status								=> dma_status        (4),
				dma4_fifocnt							=> USER_DMA_FIFOCNT_I(4),
				-----------------			            
				dma5_regin								=> USER_DMA_REGIN_I  (5),
				dma5_regout								=> dma_regout        (5),
				dma5_param								=> USER_DMA_PARAM_I  (5),
				dma5_control							=> USER_DMA_CONTROL_I(5),
				dma5_status								=> dma_status        (5),
				dma5_fifocnt							=> USER_DMA_FIFOCNT_I(5),		
				-- PCIe Interruptions:
				int_request 							=> PCIE_INTERRUPT_I.request,
				int_msgnum 								=> PCIE_INTERRUPT_I.msgnum,			
				int_ack									=> PCIE_INTERRUPT_O.ack
			);
	end generate;
	
	ezdma2_7dma_gen: if NUM_USER_SYS_PCIE_DMA = 6 generate
		ezdma2_core_inst: entity work.ezdma2_core_7dma_250mhz
			port map (
				clk										=> CLK,
				rstn										=> RSTN,
				test_mode	    						=> TEST_MODE_I,
				-- PCIe interface:
				trn_lnk_up_n							=> trn_lnk_up_n,
				trn_td									=> trn_td,
				trn_trem_n(0)							=> trn_trem_n(0),
				trn_trem_n(1)							=> open,	
				trn_tsof_n								=> trn_tsof_n,
				trn_teof_n								=> trn_teof_n,
				trn_tsrc_rdy_n							=> trn_tsrc_rdy_n,
				trn_tdst_rdy_n							=> trn_tdst_rdy_n,
				trn_terr_drop_n						=> trn_terr_drop_n,
				trn_tsrc_dsc_n							=> trn_tsrc_dsc_n,
				trn_terrfwd_n							=> trn_terrfwd_n,
				trn_tbuf_av								=> trn_tbuf_av,
				trn_tstr_n								=> trn_tstr_n,
				trn_rd									=> trn_rd,
	--			trn_rrem_n								=> trn_rrem_n,
				trn_rsof_n								=> trn_rsof_n,
				trn_reof_n								=> trn_reof_n,
				trn_rsrc_rdy_n							=> trn_rsrc_rdy_n,
				trn_rsrc_dsc_n							=> trn_rsrc_dsc_n,
				trn_rdst_rdy_n							=> trn_rdst_rdy_n,
				trn_rerrfwd_n							=> trn_rerrfwd_n,
				trn_rnp_ok_n							=> trn_rnp_ok_n,
				trn_rbar_hit_n							=> trn_rbar_hit_n,
				cfg_err_cor_n							=> cfg_err_cor_n,
				cfg_err_ur_n							=> cfg_err_ur_n,
				cfg_err_ecrc_n							=> cfg_err_ecrc_n,
				cfg_err_cpl_timeout_n				=> cfg_err_cpl_timeout_n,
				cfg_err_cpl_abort_n					=> cfg_err_cpl_abort_n,
				cfg_err_cpl_unexpect_n				=> cfg_err_cpl_unexpect_n,
				cfg_err_posted_n						=> cfg_err_posted_n,
				cfg_err_locked_n						=> cfg_err_locked_n,
				cfg_err_tlp_cpl_header				=> cfg_err_tlp_cpl_header,
				cfg_err_cpl_rdy_n						=> cfg_err_cpl_rdy_n,
				cfg_interrupt_n						=> cfg_interrupt_n,
				cfg_interrupt_rdy_n					=> cfg_interrupt_rdy_n,
				cfg_interrupt_assert_n				=> cfg_interrupt_assert_n,
				cfg_interrupt_di						=> cfg_interrupt_di,
				cfg_interrupt_do						=> cfg_interrupt_do,
				cfg_interrupt_mmenable				=> cfg_interrupt_mmenable,
				cfg_interrupt_msienable				=> cfg_interrupt_msienable,
				cfg_pcie_link_state_n				=> cfg_pcie_link_state_n,
				cfg_trn_pending_n						=> cfg_trn_pending_n,
				cfg_bus_number							=> cfg_bus_number,
				cfg_device_number						=> cfg_device_number,
				cfg_function_number					=> cfg_function_number,
				cfg_status								=> cfg_status,
				cfg_command								=> cfg_command,
				cfg_dstatus			   				=> cfg_dstatus,
				cfg_dcommand							=> cfg_dcommand,
				cfg_lstatus								=> cfg_lstatus,
				cfg_lcommand							=> cfg_lcommand,		
				cfg_prmcsr 								=> cfg_prmcsr,
				cfg_devcsr 								=> cfg_devcsr,
				cfg_linkcsr 							=> cfg_linkcsr,
				cfg_msicsr 								=> cfg_msicsr,
				cfg_ltssm 								=> cfg_ltssm,	
				-- Slave interface:								
				slv_dataout								=> SLV_O.dataout,					
				slv_bytevalid							=> SLV_O.bytevalid,            
				slv_bytecount							=> SLV_O.bytecount,            
				slv_dwcount								=> SLV_O.dwcount,                            
				slv_addr									=> SLV_O.addr,                    
				slv_bar									=> SLV_O.bar,                  
				slv_readreq								=> SLV_O.readreq,              
				slv_cpladdr								=> SLV_O.cpladdr,              
				slv_cplparam							=> SLV_O.cplparam,             
				slv_writereq							=> SLV_O.writereq,             
				slv_write								=> SLV_O.wr,                
				slv_lastwrite							=> SLV_O.lastwrite,                            
				slv_io         						=> SLV_O.io,     		                       
				slv_accept								=> SLV_I.accept,                
				slv_abort								=> SLV_I.abort,                 
				slv_ur         						=> SLV_I.ur,	-- NOTE!!! Tie to '0' when not used	
				-- General DMA ports:							
				dma_rd									=> GDMA_O.rd,							
				dma_rdaddr								=> GDMA_O.rdaddr, 		                       
				dma_rdchannel							=> GDMA_O.rdchannel,                   
				dma_rddata								=> GDMA_I.rddata,           
				dma_wr									=> GDMA_O.wr,                          
				dma_wraddr								=> GDMA_O.wraddr, 	                                    
				dma_wrchannel							=> GDMA_O.wrchannel,                   
				dma_wrdata								=> GDMA_O.wrdata,                      
				dma_wrbytevalid						=> GDMA_O.wrbytevalid,                                       
				-- EZDMA2 - IPbus fabric interface DMA ports:	
				dma0_regin								=> DMA0_I.regin,		
				dma0_regout								=> DMA0_O.regout,   
				dma0_param								=> DMA0_I.param,    
				dma0_control							=> DMA0_I.control,  
				dma0_status								=> DMA0_O.status,   
				dma0_fifocnt							=> DMA0_I.fifocnt,  		
				-- User DMA ports:
				dma1_regin								=> USER_DMA_REGIN_I  (1),
				dma1_regout								=> dma_regout			(1),
				dma1_param								=> USER_DMA_PARAM_I  (1),
				dma1_control							=> USER_DMA_CONTROL_I(1),
				dma1_status								=> dma_status        (1),
				dma1_fifocnt							=> USER_DMA_FIFOCNT_I(1),
				-----------------						   
				dma2_regin								=> USER_DMA_REGIN_I  (2),	
				dma2_regout								=> dma_regout        (2),
				dma2_param								=> USER_DMA_PARAM_I  (2), 
				dma2_control							=> USER_DMA_CONTROL_I(2),
				dma2_status								=> dma_status        (2),
				dma2_fifocnt							=> USER_DMA_FIFOCNT_I(2),	
				-----------------			            
				dma3_regin								=> USER_DMA_REGIN_I  (3),	
				dma3_regout								=> dma_regout        (3),
				dma3_param								=> USER_DMA_PARAM_I  (3),
				dma3_control							=> USER_DMA_CONTROL_I(3),
				dma3_status								=> dma_status        (3),
				dma3_fifocnt							=> USER_DMA_FIFOCNT_I(3),
				-----------------			            
				dma4_regin								=> USER_DMA_REGIN_I  (4),
				dma4_regout								=> dma_regout        (4),
				dma4_param								=> USER_DMA_PARAM_I  (4),
				dma4_control							=> USER_DMA_CONTROL_I(4),
				dma4_status								=> dma_status        (4),
				dma4_fifocnt							=> USER_DMA_FIFOCNT_I(4),
				-----------------			            
				dma5_regin								=> USER_DMA_REGIN_I  (5),
				dma5_regout								=> dma_regout        (5),
				dma5_param								=> USER_DMA_PARAM_I  (5),
				dma5_control							=> USER_DMA_CONTROL_I(5),
				dma5_status								=> dma_status        (5),
				dma5_fifocnt							=> USER_DMA_FIFOCNT_I(5),
				-----------------			            
				dma6_regin								=> USER_DMA_REGIN_I  (6),	
				dma6_regout								=> dma_regout        (6),
				dma6_param								=> USER_DMA_PARAM_I  (6),
				dma6_control							=> USER_DMA_CONTROL_I(6),
				dma6_status								=> dma_status        (6),
				dma6_fifocnt							=> USER_DMA_FIFOCNT_I(6),	
				-- PCIe Interruptions:
				int_request 							=> PCIE_INTERRUPT_I.request,
				int_msgnum 								=> PCIE_INTERRUPT_I.msgnum,			
				int_ack									=> PCIE_INTERRUPT_O.ack
			);
	end generate;
	
	ezdma2_8dma_gen: if NUM_USER_SYS_PCIE_DMA = 7 generate
		ezdma2_core_inst: entity work.ezdma2_core_8dma_250mhz
			port map (
				clk										=> CLK,
				rstn										=> RSTN,
				test_mode	    						=> TEST_MODE_I,
				-- PCIe interface:
				trn_lnk_up_n							=> trn_lnk_up_n,
				trn_td									=> trn_td,
				trn_trem_n(0)							=> trn_trem_n(0),
				trn_trem_n(1)							=> open,	
				trn_tsof_n								=> trn_tsof_n,
				trn_teof_n								=> trn_teof_n,
				trn_tsrc_rdy_n							=> trn_tsrc_rdy_n,
				trn_tdst_rdy_n							=> trn_tdst_rdy_n,
				trn_terr_drop_n						=> trn_terr_drop_n,
				trn_tsrc_dsc_n							=> trn_tsrc_dsc_n,
				trn_terrfwd_n							=> trn_terrfwd_n,
				trn_tbuf_av								=> trn_tbuf_av,
				trn_tstr_n								=> trn_tstr_n,
				trn_rd									=> trn_rd,
	--			trn_rrem_n								=> trn_rrem_n,
				trn_rsof_n								=> trn_rsof_n,
				trn_reof_n								=> trn_reof_n,
				trn_rsrc_rdy_n							=> trn_rsrc_rdy_n,
				trn_rsrc_dsc_n							=> trn_rsrc_dsc_n,
				trn_rdst_rdy_n							=> trn_rdst_rdy_n,
				trn_rerrfwd_n							=> trn_rerrfwd_n,
				trn_rnp_ok_n							=> trn_rnp_ok_n,
				trn_rbar_hit_n							=> trn_rbar_hit_n,
				cfg_err_cor_n							=> cfg_err_cor_n,
				cfg_err_ur_n							=> cfg_err_ur_n,
				cfg_err_ecrc_n							=> cfg_err_ecrc_n,
				cfg_err_cpl_timeout_n				=> cfg_err_cpl_timeout_n,
				cfg_err_cpl_abort_n					=> cfg_err_cpl_abort_n,
				cfg_err_cpl_unexpect_n				=> cfg_err_cpl_unexpect_n,
				cfg_err_posted_n						=> cfg_err_posted_n,
				cfg_err_locked_n						=> cfg_err_locked_n,
				cfg_err_tlp_cpl_header				=> cfg_err_tlp_cpl_header,
				cfg_err_cpl_rdy_n						=> cfg_err_cpl_rdy_n,
				cfg_interrupt_n						=> cfg_interrupt_n,
				cfg_interrupt_rdy_n					=> cfg_interrupt_rdy_n,
				cfg_interrupt_assert_n				=> cfg_interrupt_assert_n,
				cfg_interrupt_di						=> cfg_interrupt_di,
				cfg_interrupt_do						=> cfg_interrupt_do,
				cfg_interrupt_mmenable				=> cfg_interrupt_mmenable,
				cfg_interrupt_msienable				=> cfg_interrupt_msienable,
				cfg_pcie_link_state_n				=> cfg_pcie_link_state_n,
				cfg_trn_pending_n						=> cfg_trn_pending_n,
				cfg_bus_number							=> cfg_bus_number,
				cfg_device_number						=> cfg_device_number,
				cfg_function_number					=> cfg_function_number,
				cfg_status								=> cfg_status,
				cfg_command								=> cfg_command,
				cfg_dstatus			   				=> cfg_dstatus,
				cfg_dcommand							=> cfg_dcommand,
				cfg_lstatus								=> cfg_lstatus,
				cfg_lcommand							=> cfg_lcommand,		
				cfg_prmcsr 								=> cfg_prmcsr,
				cfg_devcsr 								=> cfg_devcsr,
				cfg_linkcsr 							=> cfg_linkcsr,
				cfg_msicsr 								=> cfg_msicsr,
				cfg_ltssm 								=> cfg_ltssm,	
				-- Slave interface:								
				slv_dataout								=> SLV_O.dataout,					
				slv_bytevalid							=> SLV_O.bytevalid,            
				slv_bytecount							=> SLV_O.bytecount,            
				slv_dwcount								=> SLV_O.dwcount,                            
				slv_addr									=> SLV_O.addr,                    
				slv_bar									=> SLV_O.bar,                  
				slv_readreq								=> SLV_O.readreq,              
				slv_cpladdr								=> SLV_O.cpladdr,              
				slv_cplparam							=> SLV_O.cplparam,             
				slv_writereq							=> SLV_O.writereq,             
				slv_write								=> SLV_O.wr,                
				slv_lastwrite							=> SLV_O.lastwrite,                            
				slv_io         						=> SLV_O.io,     		                       
				slv_accept								=> SLV_I.accept,                
				slv_abort								=> SLV_I.abort,                 
				slv_ur         						=> SLV_I.ur,	-- NOTE!!! Tie to '0' when not used	
				-- General DMA ports:							
				dma_rd									=> GDMA_O.rd,							
				dma_rdaddr								=> GDMA_O.rdaddr, 		                       
				dma_rdchannel							=> GDMA_O.rdchannel,                   
				dma_rddata								=> GDMA_I.rddata,           
				dma_wr									=> GDMA_O.wr,                          
				dma_wraddr								=> GDMA_O.wraddr, 	                                    
				dma_wrchannel							=> GDMA_O.wrchannel,                   
				dma_wrdata								=> GDMA_O.wrdata,                      
				dma_wrbytevalid						=> GDMA_O.wrbytevalid,                                       
				-- EZDMA2 - IPbus fabric interface DMA ports:	
				dma0_regin								=> DMA0_I.regin,		
				dma0_regout								=> DMA0_O.regout,   
				dma0_param								=> DMA0_I.param,    
				dma0_control							=> DMA0_I.control,  
				dma0_status								=> DMA0_O.status,   
				dma0_fifocnt							=> DMA0_I.fifocnt,  		
				-- User DMA ports:
				dma1_regin								=> USER_DMA_REGIN_I  (1),
				dma1_regout								=> dma_regout			(1),
				dma1_param								=> USER_DMA_PARAM_I  (1),
				dma1_control							=> USER_DMA_CONTROL_I(1),
				dma1_status								=> dma_status        (1),
				dma1_fifocnt							=> USER_DMA_FIFOCNT_I(1),
				-----------------						   
				dma2_regin								=> USER_DMA_REGIN_I  (2),	
				dma2_regout								=> dma_regout        (2),
				dma2_param								=> USER_DMA_PARAM_I  (2), 
				dma2_control							=> USER_DMA_CONTROL_I(2),
				dma2_status								=> dma_status        (2),
				dma2_fifocnt							=> USER_DMA_FIFOCNT_I(2),	
				-----------------			            
				dma3_regin								=> USER_DMA_REGIN_I  (3),	
				dma3_regout								=> dma_regout        (3),
				dma3_param								=> USER_DMA_PARAM_I  (3),
				dma3_control							=> USER_DMA_CONTROL_I(3),
				dma3_status								=> dma_status        (3),
				dma3_fifocnt							=> USER_DMA_FIFOCNT_I(3),
				-----------------			            
				dma4_regin								=> USER_DMA_REGIN_I  (4),
				dma4_regout								=> dma_regout        (4),
				dma4_param								=> USER_DMA_PARAM_I  (4),
				dma4_control							=> USER_DMA_CONTROL_I(4),
				dma4_status								=> dma_status        (4),
				dma4_fifocnt							=> USER_DMA_FIFOCNT_I(4),
				-----------------			            
				dma5_regin								=> USER_DMA_REGIN_I  (5),
				dma5_regout								=> dma_regout        (5),
				dma5_param								=> USER_DMA_PARAM_I  (5),
				dma5_control							=> USER_DMA_CONTROL_I(5),
				dma5_status								=> dma_status        (5),
				dma5_fifocnt							=> USER_DMA_FIFOCNT_I(5),
				-----------------			            
				dma6_regin								=> USER_DMA_REGIN_I  (6),	
				dma6_regout								=> dma_regout        (6),
				dma6_param								=> USER_DMA_PARAM_I  (6),
				dma6_control							=> USER_DMA_CONTROL_I(6),
				dma6_status								=> dma_status        (6),
				dma6_fifocnt							=> USER_DMA_FIFOCNT_I(6),	
				-----------------						   
				dma7_regin								=> USER_DMA_REGIN_I  (7),
				dma7_regout								=> dma_regout        (7),
				dma7_param								=> USER_DMA_PARAM_I  (7),
				dma7_control							=> USER_DMA_CONTROL_I(7),
				dma7_status								=> dma_status        (7),
				dma7_fifocnt							=> USER_DMA_FIFOCNT_I(7),
				-- PCIe Interruptions:
				int_request 							=> PCIE_INTERRUPT_I.request,
				int_msgnum 								=> PCIE_INTERRUPT_I.msgnum,
				int_ack									=> PCIE_INTERRUPT_O.ack
			);
	end generate;
	
	user_dma_o_conf_gen: for i in 1 to 7 generate
		user_dmaX_o_enable_gen: if i < NUM_USER_SYS_PCIE_DMA+1 generate
			USER_DMA_REGOUT_O(i)             <= dma_regout(i);
			USER_DMA_STATUS_O(i)	            <= dma_status(i);
		end generate;		
		user_dmaX_o_disable_gen: if i >= NUM_USER_SYS_PCIE_DMA+1 generate 
			USER_DMA_REGOUT_O(i)		         <= (others => '0');
			USER_DMA_STATUS_O(i)            	<= (others => '0');
		end generate;		
	end generate;
	
	--=====================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--