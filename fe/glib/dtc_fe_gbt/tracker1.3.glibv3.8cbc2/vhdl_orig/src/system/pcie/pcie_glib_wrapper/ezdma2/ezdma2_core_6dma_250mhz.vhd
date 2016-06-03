--  megafunction wizard: %PLDA PCI Express EZ Core%
--  PLDA HDL Writer v11.0
--  This instance is for PLDA EZ DMA for Xilinx Hard IP v1.4.4 build 190
-- 
library ieee;
use ieee.std_logic_1164.all;


-- 
-- Xilinx Virtex-6 Integrated Block for PCI Express (v1.4 or later)
-- must be configured as indicated below for proper core behaviour :
-- 
-- - Interface frequency : 250
-- - Maximum payload size supported : 256
-- - Performance level : high
-- - Trim TLP digest ECRC : checked
-- 
-- all other settings are left to user's choice
-- 

-- PARAM: PRV_DEV_TYPE 1
-- PARAM: PRV_INTERFACE_TYPE 0
-- PARAM: PRV_PROTOCOL 0
-- PARAM: PRV_LANGUAGE 0
-- PARAM: PRV_STR_LANGUAGE 'VHDL'
-- PARAM: PRV_SIMUL_RQS 8
-- PARAM: PRV_MAX_PAYLOAD 8
-- PARAM: PRV_MAX_RDSIZE 8
-- PARAM: PRV_USER_CLOCK 0
-- PARAM: PRV_NB_DMA 6
-- PARAM: PRV_CPL_TIMEOUTEN 1
-- PARAM: PRV_CPL_TIMEOUT 20
-- PARAM: PRV_MAX_DMA_TRANS_SIZE 32
-- PARAM: PRV_DMA_LCL_ADDR_SIZE 32
-- PARAM: PRV_NB_EDMA 0
-- PARAM: PRV_DMA_SUP_LAT 3
-- PARAM: PRV_LOCK_SUPPORT 0
-- PARAM: PRV_ENABLE_AER 0
-- PARAM: PRV_ENABLE_ECRC 0
-- PARAM: PRV_NUM_FUNC 1
-- PARAM: PRV_ATOMIC32 0
-- PARAM: PRV_ATOMIC64 0
-- PARAM: PRV_ATOMIC128 0
-- PARAM: DMASIZE 32
-- PARAM: LOCSIZE 32
-- PARAM: BUFSIZE 6
-- PARAM: USERCLK 0
-- PARAM: DATAPATH 64
-- PARAM: DEVTYPE 1


entity ezdma2_core_6dma_250mhz is
  port (
    clk                     : in    std_logic;
    rstn                    : in    std_logic;
    test_mode               : in    std_logic_vector(15 downto 0);
    trn_lnk_up_n            : in    std_logic;
    trn_td                  : out   std_logic_vector(63 downto 0);
    trn_trem_n              : out   std_logic_vector(1 downto 0);
    trn_tsof_n              : out   std_logic;
    trn_teof_n              : out   std_logic;
    trn_tsrc_dsc_n          : out   std_logic;
    trn_tsrc_rdy_n          : out   std_logic;
    trn_tdst_rdy_n          : in    std_logic;
    trn_terr_drop_n         : in    std_logic;
    trn_terrfwd_n           : out   std_logic;
    trn_tstr_n              : out   std_logic;
    trn_tbuf_av             : in    std_logic_vector(5 downto 0);
    trn_rd                  : in    std_logic_vector(63 downto 0);
    trn_rsof_n              : in    std_logic;
    trn_reof_n              : in    std_logic;
    trn_rsrc_dsc_n          : in    std_logic;
    trn_rsrc_rdy_n          : in    std_logic;
    trn_rbar_hit_n          : in    std_logic_vector(6 downto 0);
    trn_rdst_rdy_n          : out   std_logic;
    trn_rerrfwd_n           : in    std_logic;
    trn_rnp_ok_n            : out   std_logic;
    cfg_err_cor_n           : out   std_logic;
    cfg_err_cpl_abort_n     : out   std_logic;
    cfg_err_cpl_timeout_n   : out   std_logic;
    cfg_err_cpl_unexpect_n  : out   std_logic;
    cfg_err_ecrc_n          : out   std_logic;
    cfg_err_posted_n        : out   std_logic;
    cfg_err_tlp_cpl_header  : out   std_logic_vector(47 downto 0);
    cfg_err_ur_n            : out   std_logic;
    cfg_err_cpl_rdy_n       : in    std_logic;
    cfg_err_locked_n        : out   std_logic;
    cfg_interrupt_n         : out   std_logic;
    cfg_interrupt_rdy_n     : in    std_logic;
    cfg_pcie_link_state_n   : in    std_logic_vector(2 downto 0);
    cfg_interrupt_assert_n  : out   std_logic;
    cfg_interrupt_di        : out   std_logic_vector(7 downto 0);
    cfg_interrupt_do        : in    std_logic_vector(7 downto 0);
    cfg_interrupt_mmenable  : in    std_logic_vector(2 downto 0);
    cfg_interrupt_msienable : in    std_logic;
    cfg_trn_pending_n       : out   std_logic;
    cfg_bus_number          : in    std_logic_vector(7 downto 0);
    cfg_device_number       : in    std_logic_vector(4 downto 0);
    cfg_function_number     : in    std_logic_vector(2 downto 0);
    cfg_status              : in    std_logic_vector(15 downto 0);
    cfg_command             : in    std_logic_vector(15 downto 0);
    cfg_dstatus             : in    std_logic_vector(15 downto 0);
    cfg_dcommand            : in    std_logic_vector(15 downto 0);
    cfg_lstatus             : in    std_logic_vector(15 downto 0);
    cfg_lcommand            : in    std_logic_vector(15 downto 0);
    int_request             : in    std_logic;
    int_ack                 : out   std_logic;
    int_msgnum              : in    std_logic_vector(4 downto 0);
    cfg_prmcsr              : out   std_logic_vector(31 downto 0);
    cfg_devcsr              : out   std_logic_vector(31 downto 0);
    cfg_linkcsr             : out   std_logic_vector(31 downto 0);
    cfg_msicsr              : out   std_logic_vector(15 downto 0);
    cfg_ltssm               : out   std_logic_vector(4 downto 0);
    slv_dataout             : out   std_logic_vector(63 downto 0);
    slv_bytevalid           : out   std_logic_vector(7 downto 0);
    slv_bytecount           : out   std_logic_vector(12 downto 0);
    slv_dwcount             : out   std_logic_vector(10 downto 0);
    slv_addr                : out   std_logic_vector(63 downto 0);
    slv_bar                 : out   std_logic_vector(6 downto 0);
    slv_readreq             : out   std_logic;
    slv_cpladdr             : out   std_logic_vector(31 downto 0);
    slv_cplparam            : out   std_logic_vector(7 downto 0);
    slv_writereq            : out   std_logic;
    slv_write               : out   std_logic;
    slv_lastwrite           : out   std_logic;
    slv_io                  : out   std_logic;
    slv_accept              : in    std_logic;
    slv_abort               : in    std_logic;
    slv_ur                  : in    std_logic;
    dma_rd                  : out   std_logic;
    dma_rdaddr              : out   std_logic_vector(31 downto 0);
    dma_rdchannel           : out   std_logic_vector(15 downto 0);
    dma_rddata              : in    std_logic_vector(63 downto 0);
    dma_wr                  : out   std_logic;
    dma_wraddr              : out   std_logic_vector(31 downto 0);
    dma_wrchannel           : out   std_logic_vector(15 downto 0);
    dma_wrdata              : out   std_logic_vector(63 downto 0);
    dma_wrbytevalid         : out   std_logic_vector(7 downto 0);
    dma0_regin              : in    std_logic_vector(127 downto 0);
    dma0_regout             : out   std_logic_vector(127 downto 0);
    dma0_param              : in    std_logic_vector(23 downto 0);
    dma0_control            : in    std_logic_vector(5 downto 0);
    dma0_status             : out   std_logic_vector(3 downto 0);
    dma0_fifocnt            : in    std_logic_vector(12 downto 0);
    dma1_regin              : in    std_logic_vector(127 downto 0);
    dma1_regout             : out   std_logic_vector(127 downto 0);
    dma1_param              : in    std_logic_vector(23 downto 0);
    dma1_control            : in    std_logic_vector(5 downto 0);
    dma1_status             : out   std_logic_vector(3 downto 0);
    dma1_fifocnt            : in    std_logic_vector(12 downto 0);
    dma2_regin              : in    std_logic_vector(127 downto 0);
    dma2_regout             : out   std_logic_vector(127 downto 0);
    dma2_param              : in    std_logic_vector(23 downto 0);
    dma2_control            : in    std_logic_vector(5 downto 0);
    dma2_status             : out   std_logic_vector(3 downto 0);
    dma2_fifocnt            : in    std_logic_vector(12 downto 0);
    dma3_regin              : in    std_logic_vector(127 downto 0);
    dma3_regout             : out   std_logic_vector(127 downto 0);
    dma3_param              : in    std_logic_vector(23 downto 0);
    dma3_control            : in    std_logic_vector(5 downto 0);
    dma3_status             : out   std_logic_vector(3 downto 0);
    dma3_fifocnt            : in    std_logic_vector(12 downto 0);
    dma4_regin              : in    std_logic_vector(127 downto 0);
    dma4_regout             : out   std_logic_vector(127 downto 0);
    dma4_param              : in    std_logic_vector(23 downto 0);
    dma4_control            : in    std_logic_vector(5 downto 0);
    dma4_status             : out   std_logic_vector(3 downto 0);
    dma4_fifocnt            : in    std_logic_vector(12 downto 0);
    dma5_regin              : in    std_logic_vector(127 downto 0);
    dma5_regout             : out   std_logic_vector(127 downto 0);
    dma5_param              : in    std_logic_vector(23 downto 0);
    dma5_control            : in    std_logic_vector(5 downto 0);
    dma5_status             : out   std_logic_vector(3 downto 0);
    dma5_fifocnt            : in    std_logic_vector(12 downto 0));
end ezdma2_core_6dma_250mhz;

architecture structural of ezdma2_core_6dma_250mhz is
  component pciez_xebp
    generic (
      DMASIZE                 : integer;
      LOCSIZE                 : integer;
      BUFSIZE                 : integer;
      USERCLK                 : integer;
      DATAPATH                : integer;
      DEVTYPE                 : integer);
    port (
      clk                     : in    std_logic;
      rstn                    : in    std_logic;
      test_mode               : in    std_logic_vector(15 downto 0);
      trn_lnk_up_n            : in    std_logic;
      trn_td                  : out   std_logic_vector(63 downto 0);
      trn_trem_n_v5           : out   std_logic_vector(7 downto 0);
      trn_trem_n_v6           : out   std_logic_vector(1 downto 0);
      trn_tsof_n              : out   std_logic;
      trn_teof_n              : out   std_logic;
      trn_tsrc_dsc_n          : out   std_logic;
      trn_tsrc_rdy_n          : out   std_logic;
      trn_tdst_rdy_n          : in    std_logic;
      trn_terr_drop_n_v6      : in    std_logic;
      trn_terrfwd_n           : out   std_logic;
      trn_tstr_n_v6           : out   std_logic;
      trn_tbuf_av_v5          : in    std_logic_vector(3 downto 0);
      trn_tbuf_av_v6          : in    std_logic_vector(5 downto 0);
      trn_rd                  : in    std_logic_vector(63 downto 0);
      trn_rsof_n              : in    std_logic;
      trn_reof_n              : in    std_logic;
      trn_rsrc_dsc_n          : in    std_logic;
      trn_rsrc_rdy_n          : in    std_logic;
      trn_rbar_hit_n          : in    std_logic_vector(6 downto 0);
      trn_rrem_n_v6           : in    std_logic_vector(1 downto 0);
      trn_rdst_rdy_n          : out   std_logic;
      trn_rerrfwd_n           : in    std_logic;
      trn_rnp_ok_n            : out   std_logic;
      trn_rcpl_streaming_n_v5 : out   std_logic;
      cfg_err_cor_n           : out   std_logic;
      cfg_err_cpl_abort_n     : out   std_logic;
      cfg_err_cpl_timeout_n   : out   std_logic;
      cfg_err_cpl_unexpect_n  : out   std_logic;
      cfg_err_ecrc_n          : out   std_logic;
      cfg_err_posted_n        : out   std_logic;
      cfg_err_tlp_cpl_header  : out   std_logic_vector(47 downto 0);
      cfg_err_ur_n            : out   std_logic;
      cfg_err_cpl_rdy_n       : in    std_logic;
      cfg_err_locked_n        : out   std_logic;
      cfg_interrupt_n         : out   std_logic;
      cfg_interrupt_rdy_n     : in    std_logic;
      cfg_pcie_link_state_n   : in    std_logic_vector(2 downto 0);
      cfg_interrupt_assert_n  : out   std_logic;
      cfg_interrupt_di        : out   std_logic_vector(7 downto 0);
      cfg_interrupt_do        : in    std_logic_vector(7 downto 0);
      cfg_interrupt_mmenable  : in    std_logic_vector(2 downto 0);
      cfg_interrupt_msienable : in    std_logic;
      cfg_trn_pending_n       : out   std_logic;
      cfg_bus_number          : in    std_logic_vector(7 downto 0);
      cfg_device_number       : in    std_logic_vector(4 downto 0);
      cfg_function_number     : in    std_logic_vector(2 downto 0);
      cfg_status              : in    std_logic_vector(15 downto 0);
      cfg_command             : in    std_logic_vector(15 downto 0);
      cfg_dstatus             : in    std_logic_vector(15 downto 0);
      cfg_dcommand            : in    std_logic_vector(15 downto 0);
      cfg_lstatus             : in    std_logic_vector(15 downto 0);
      cfg_lcommand            : in    std_logic_vector(15 downto 0);
      k_ez                    : in    std_logic_vector(63 downto 0);
      int_request             : in    std_logic;
      int_ack                 : out   std_logic;
      int_msgnum              : in    std_logic_vector(4 downto 0);
      cfg_prmcsr              : out   std_logic_vector(31 downto 0);
      cfg_devcsr              : out   std_logic_vector(31 downto 0);
      cfg_linkcsr             : out   std_logic_vector(31 downto 0);
      cfg_msicsr              : out   std_logic_vector(15 downto 0);
      cfg_ltssm               : out   std_logic_vector(4 downto 0);
      slv_dataout             : out   std_logic_vector(63 downto 0);
      slv_bytevalid           : out   std_logic_vector(7 downto 0);
      slv_bytecount           : out   std_logic_vector(12 downto 0);
      slv_dwcount             : out   std_logic_vector(10 downto 0);
      slv_addr                : out   std_logic_vector(63 downto 0);
      slv_bar                 : out   std_logic_vector(6 downto 0);
      slv_readreq             : out   std_logic;
      slv_cpladdr             : out   std_logic_vector(31 downto 0);
      slv_cplparam            : out   std_logic_vector(7 downto 0);
      slv_cpllocked           : out   std_logic;
      slv_writereq            : out   std_logic;
      slv_write               : out   std_logic;
      slv_lastwrite           : out   std_logic;
      slv_io                  : out   std_logic;
      slv_accept              : in    std_logic;
      slv_abort               : in    std_logic;
      slv_ur                  : in    std_logic;
      dma_rd                  : out   std_logic;
      dma_rdaddr              : out   std_logic_vector(31 downto 0);
      dma_rdchannel           : out   std_logic_vector(15 downto 0);
      dma_rddata              : in    std_logic_vector(63 downto 0);
      dma_wr                  : out   std_logic;
      dma_wraddr              : out   std_logic_vector(31 downto 0);
      dma_wrchannel           : out   std_logic_vector(15 downto 0);
      dma_wrdata              : out   std_logic_vector(63 downto 0);
      dma_wrbytevalid         : out   std_logic_vector(7 downto 0);
      dma0_regin              : in    std_logic_vector(127 downto 0);
      dma0_regout             : out   std_logic_vector(127 downto 0);
      dma0_param              : in    std_logic_vector(23 downto 0);
      dma0_control            : in    std_logic_vector(5 downto 0);
      dma0_status             : out   std_logic_vector(3 downto 0);
      dma0_fifocnt            : in    std_logic_vector(12 downto 0);
      dma1_regin              : in    std_logic_vector(127 downto 0);
      dma1_regout             : out   std_logic_vector(127 downto 0);
      dma1_param              : in    std_logic_vector(23 downto 0);
      dma1_control            : in    std_logic_vector(5 downto 0);
      dma1_status             : out   std_logic_vector(3 downto 0);
      dma1_fifocnt            : in    std_logic_vector(12 downto 0);
      dma2_regin              : in    std_logic_vector(127 downto 0);
      dma2_regout             : out   std_logic_vector(127 downto 0);
      dma2_param              : in    std_logic_vector(23 downto 0);
      dma2_control            : in    std_logic_vector(5 downto 0);
      dma2_status             : out   std_logic_vector(3 downto 0);
      dma2_fifocnt            : in    std_logic_vector(12 downto 0);
      dma3_regin              : in    std_logic_vector(127 downto 0);
      dma3_regout             : out   std_logic_vector(127 downto 0);
      dma3_param              : in    std_logic_vector(23 downto 0);
      dma3_control            : in    std_logic_vector(5 downto 0);
      dma3_status             : out   std_logic_vector(3 downto 0);
      dma3_fifocnt            : in    std_logic_vector(12 downto 0);
      dma4_regin              : in    std_logic_vector(127 downto 0);
      dma4_regout             : out   std_logic_vector(127 downto 0);
      dma4_param              : in    std_logic_vector(23 downto 0);
      dma4_control            : in    std_logic_vector(5 downto 0);
      dma4_status             : out   std_logic_vector(3 downto 0);
      dma4_fifocnt            : in    std_logic_vector(12 downto 0);
      dma5_regin              : in    std_logic_vector(127 downto 0);
      dma5_regout             : out   std_logic_vector(127 downto 0);
      dma5_param              : in    std_logic_vector(23 downto 0);
      dma5_control            : in    std_logic_vector(5 downto 0);
      dma5_status             : out   std_logic_vector(3 downto 0);
      dma5_fifocnt            : in    std_logic_vector(12 downto 0);
      dma6_regin              : in    std_logic_vector(127 downto 0);
      dma6_regout             : out   std_logic_vector(127 downto 0);
      dma6_param              : in    std_logic_vector(23 downto 0);
      dma6_control            : in    std_logic_vector(5 downto 0);
      dma6_status             : out   std_logic_vector(3 downto 0);
      dma6_fifocnt            : in    std_logic_vector(12 downto 0);
      dma7_regin              : in    std_logic_vector(127 downto 0);
      dma7_regout             : out   std_logic_vector(127 downto 0);
      dma7_param              : in    std_logic_vector(23 downto 0);
      dma7_control            : in    std_logic_vector(5 downto 0);
      dma7_status             : out   std_logic_vector(3 downto 0);
      dma7_fifocnt            : in    std_logic_vector(12 downto 0);
      edma_maxmask            : out   std_logic_vector(9 downto 0);
      edma8_req               : in    std_logic;
      edma8_desc              : in    std_logic_vector(127 downto 0);
      edma8_arbhint           : in    std_logic_vector(12 downto 0);
      edma8_locaddr           : in    std_logic_vector(31 downto 0);
      edma8_ctrl              : out   std_logic_vector(6 downto 0);
      edma9_req               : in    std_logic;
      edma9_desc              : in    std_logic_vector(127 downto 0);
      edma9_arbhint           : in    std_logic_vector(12 downto 0);
      edma9_locaddr           : in    std_logic_vector(31 downto 0);
      edma9_ctrl              : out   std_logic_vector(6 downto 0);
      edma10_req              : in    std_logic;
      edma10_desc             : in    std_logic_vector(127 downto 0);
      edma10_arbhint          : in    std_logic_vector(12 downto 0);
      edma10_locaddr          : in    std_logic_vector(31 downto 0);
      edma10_ctrl             : out   std_logic_vector(6 downto 0);
      edma11_req              : in    std_logic;
      edma11_desc             : in    std_logic_vector(127 downto 0);
      edma11_arbhint          : in    std_logic_vector(12 downto 0);
      edma11_locaddr          : in    std_logic_vector(31 downto 0);
      edma11_ctrl             : out   std_logic_vector(6 downto 0);
      edma12_req              : in    std_logic;
      edma12_desc             : in    std_logic_vector(127 downto 0);
      edma12_arbhint          : in    std_logic_vector(12 downto 0);
      edma12_locaddr          : in    std_logic_vector(31 downto 0);
      edma12_ctrl             : out   std_logic_vector(6 downto 0);
      edma13_req              : in    std_logic;
      edma13_desc             : in    std_logic_vector(127 downto 0);
      edma13_arbhint          : in    std_logic_vector(12 downto 0);
      edma13_locaddr          : in    std_logic_vector(31 downto 0);
      edma13_ctrl             : out   std_logic_vector(6 downto 0);
      edma14_req              : in    std_logic;
      edma14_desc             : in    std_logic_vector(127 downto 0);
      edma14_arbhint          : in    std_logic_vector(12 downto 0);
      edma14_locaddr          : in    std_logic_vector(31 downto 0);
      edma14_ctrl             : out   std_logic_vector(6 downto 0);
      edma15_req              : in    std_logic;
      edma15_desc             : in    std_logic_vector(127 downto 0);
      edma15_arbhint          : in    std_logic_vector(12 downto 0);
      edma15_locaddr          : in    std_logic_vector(31 downto 0);
      edma15_ctrl             : out   std_logic_vector(6 downto 0));
  end component;

  signal ZERO                 : std_logic_vector (383 downto 0);
  signal k_ez                 : std_logic_vector(63 downto 0);

begin
  ZERO <=(others=>'0');
  k_ez <=x"00FF0240" & x"22093F14";

  core_inst : pciez_xebp
    generic map (
      DMASIZE                 => 32,
      LOCSIZE                 => 32,
      BUFSIZE                 => 6,
      USERCLK                 => 0,
      DATAPATH                => 64,
      DEVTYPE                 => 1)
    port map (
      clk                     => clk,
      rstn                    => rstn,
      test_mode               => test_mode,
      trn_lnk_up_n            => trn_lnk_up_n,
      trn_td                  => trn_td,
      trn_trem_n_v5           => open,
      trn_trem_n_v6           => trn_trem_n,
      trn_tsof_n              => trn_tsof_n,
      trn_teof_n              => trn_teof_n,
      trn_tsrc_dsc_n          => trn_tsrc_dsc_n,
      trn_tsrc_rdy_n          => trn_tsrc_rdy_n,
      trn_tdst_rdy_n          => trn_tdst_rdy_n,
      trn_terr_drop_n_v6      => trn_terr_drop_n,
      trn_terrfwd_n           => trn_terrfwd_n,
      trn_tstr_n_v6           => trn_tstr_n,
      trn_tbuf_av_v5          => ZERO(3 downto 0),
      trn_tbuf_av_v6          => trn_tbuf_av,
      trn_rd                  => trn_rd,
      trn_rsof_n              => trn_rsof_n,
      trn_reof_n              => trn_reof_n,
      trn_rsrc_dsc_n          => trn_rsrc_dsc_n,
      trn_rsrc_rdy_n          => trn_rsrc_rdy_n,
      trn_rbar_hit_n          => trn_rbar_hit_n,
      trn_rrem_n_v6           => ZERO(1 downto 0),
      trn_rdst_rdy_n          => trn_rdst_rdy_n,
      trn_rerrfwd_n           => trn_rerrfwd_n,
      trn_rnp_ok_n            => trn_rnp_ok_n,
      trn_rcpl_streaming_n_v5 => open,
      cfg_err_cor_n           => cfg_err_cor_n,
      cfg_err_cpl_abort_n     => cfg_err_cpl_abort_n,
      cfg_err_cpl_timeout_n   => cfg_err_cpl_timeout_n,
      cfg_err_cpl_unexpect_n  => cfg_err_cpl_unexpect_n,
      cfg_err_ecrc_n          => cfg_err_ecrc_n,
      cfg_err_posted_n        => cfg_err_posted_n,
      cfg_err_tlp_cpl_header  => cfg_err_tlp_cpl_header,
      cfg_err_ur_n            => cfg_err_ur_n,
      cfg_err_cpl_rdy_n       => cfg_err_cpl_rdy_n,
      cfg_err_locked_n        => cfg_err_locked_n,
      cfg_interrupt_n         => cfg_interrupt_n,
      cfg_interrupt_rdy_n     => cfg_interrupt_rdy_n,
      cfg_pcie_link_state_n   => cfg_pcie_link_state_n,
      cfg_interrupt_assert_n  => cfg_interrupt_assert_n,
      cfg_interrupt_di        => cfg_interrupt_di,
      cfg_interrupt_do        => cfg_interrupt_do,
      cfg_interrupt_mmenable  => cfg_interrupt_mmenable,
      cfg_interrupt_msienable => cfg_interrupt_msienable,
      cfg_trn_pending_n       => cfg_trn_pending_n,
      cfg_bus_number          => cfg_bus_number,
      cfg_device_number       => cfg_device_number,
      cfg_function_number     => cfg_function_number,
      cfg_status              => cfg_status,
      cfg_command             => cfg_command,
      cfg_dstatus             => cfg_dstatus,
      cfg_dcommand            => cfg_dcommand,
      cfg_lstatus             => cfg_lstatus,
      cfg_lcommand            => cfg_lcommand,
      k_ez                    => k_ez,
      int_request             => int_request,
      int_ack                 => int_ack,
      int_msgnum              => int_msgnum,
      cfg_prmcsr              => cfg_prmcsr,
      cfg_devcsr              => cfg_devcsr,
      cfg_linkcsr             => cfg_linkcsr,
      cfg_msicsr              => cfg_msicsr,
      cfg_ltssm               => cfg_ltssm,
      slv_dataout             => slv_dataout,
      slv_bytevalid           => slv_bytevalid,
      slv_bytecount           => slv_bytecount,
      slv_dwcount             => slv_dwcount,
      slv_addr                => slv_addr,
      slv_bar                 => slv_bar,
      slv_readreq             => slv_readreq,
      slv_cpladdr             => slv_cpladdr,
      slv_cplparam            => slv_cplparam,
      slv_cpllocked           => open,
      slv_writereq            => slv_writereq,
      slv_write               => slv_write,
      slv_lastwrite           => slv_lastwrite,
      slv_io                  => slv_io,
      slv_accept              => slv_accept,
      slv_abort               => slv_abort,
      slv_ur                  => slv_ur,
      dma_rd                  => dma_rd,
      dma_rdaddr              => dma_rdaddr,
      dma_rdchannel           => dma_rdchannel,
      dma_rddata              => dma_rddata,
      dma_wr                  => dma_wr,
      dma_wraddr              => dma_wraddr,
      dma_wrchannel           => dma_wrchannel,
      dma_wrdata              => dma_wrdata,
      dma_wrbytevalid         => dma_wrbytevalid,
      dma0_regin              => dma0_regin,
      dma0_regout             => dma0_regout,
      dma0_param              => dma0_param,
      dma0_control            => dma0_control,
      dma0_status             => dma0_status,
      dma0_fifocnt            => dma0_fifocnt,
      dma1_regin              => dma1_regin,
      dma1_regout             => dma1_regout,
      dma1_param              => dma1_param,
      dma1_control            => dma1_control,
      dma1_status             => dma1_status,
      dma1_fifocnt            => dma1_fifocnt,
      dma2_regin              => dma2_regin,
      dma2_regout             => dma2_regout,
      dma2_param              => dma2_param,
      dma2_control            => dma2_control,
      dma2_status             => dma2_status,
      dma2_fifocnt            => dma2_fifocnt,
      dma3_regin              => dma3_regin,
      dma3_regout             => dma3_regout,
      dma3_param              => dma3_param,
      dma3_control            => dma3_control,
      dma3_status             => dma3_status,
      dma3_fifocnt            => dma3_fifocnt,
      dma4_regin              => dma4_regin,
      dma4_regout             => dma4_regout,
      dma4_param              => dma4_param,
      dma4_control            => dma4_control,
      dma4_status             => dma4_status,
      dma4_fifocnt            => dma4_fifocnt,
      dma5_regin              => dma5_regin,
      dma5_regout             => dma5_regout,
      dma5_param              => dma5_param,
      dma5_control            => dma5_control,
      dma5_status             => dma5_status,
      dma5_fifocnt            => dma5_fifocnt,
      dma6_regin              => ZERO(127 downto 0),
      dma6_regout             => open,
      dma6_param              => ZERO(23 downto 0),
      dma6_control            => ZERO(5 downto 0),
      dma6_status             => open,
      dma6_fifocnt            => ZERO(12 downto 0),
      dma7_regin              => ZERO(127 downto 0),
      dma7_regout             => open,
      dma7_param              => ZERO(23 downto 0),
      dma7_control            => ZERO(5 downto 0),
      dma7_status             => open,
      dma7_fifocnt            => ZERO(12 downto 0),
      edma_maxmask            => open,
      edma8_req               => ZERO(0),
      edma8_desc              => ZERO(127 downto 0),
      edma8_arbhint           => ZERO(12 downto 0),
      edma8_locaddr           => ZERO(31 downto 0),
      edma8_ctrl              => open,
      edma9_req               => ZERO(0),
      edma9_desc              => ZERO(127 downto 0),
      edma9_arbhint           => ZERO(12 downto 0),
      edma9_locaddr           => ZERO(31 downto 0),
      edma9_ctrl              => open,
      edma10_req              => ZERO(0),
      edma10_desc             => ZERO(127 downto 0),
      edma10_arbhint          => ZERO(12 downto 0),
      edma10_locaddr          => ZERO(31 downto 0),
      edma10_ctrl             => open,
      edma11_req              => ZERO(0),
      edma11_desc             => ZERO(127 downto 0),
      edma11_arbhint          => ZERO(12 downto 0),
      edma11_locaddr          => ZERO(31 downto 0),
      edma11_ctrl             => open,
      edma12_req              => ZERO(0),
      edma12_desc             => ZERO(127 downto 0),
      edma12_arbhint          => ZERO(12 downto 0),
      edma12_locaddr          => ZERO(31 downto 0),
      edma12_ctrl             => open,
      edma13_req              => ZERO(0),
      edma13_desc             => ZERO(127 downto 0),
      edma13_arbhint          => ZERO(12 downto 0),
      edma13_locaddr          => ZERO(31 downto 0),
      edma13_ctrl             => open,
      edma14_req              => ZERO(0),
      edma14_desc             => ZERO(127 downto 0),
      edma14_arbhint          => ZERO(12 downto 0),
      edma14_locaddr          => ZERO(31 downto 0),
      edma14_ctrl             => open,
      edma15_req              => ZERO(0),
      edma15_desc             => ZERO(127 downto 0),
      edma15_arbhint          => ZERO(12 downto 0),
      edma15_locaddr          => ZERO(31 downto 0),
      edma15_ctrl             => open);

end structural;

