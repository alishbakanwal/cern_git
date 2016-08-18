--------------------------------------------------------------------------------
-- Project    : Xilinx LogiCORE Virtex-6 Embedded Tri-Mode Ethernet MAC
-- File       : v6_emac_v2_3_basex.vhd
-- Version    : 2.3
-------------------------------------------------------------------------------
--
-- (c) Copyright 2004-2011 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;


--------------------------------------------------------------------------------
-- The entity declaration for the top level wrapper.
--------------------------------------------------------------------------------

entity v6_emac_v2_3_basex is
    port(
      -- Clock signals
      ----------------------------
      gtx_clk                     : in  std_logic;

      -- Receiver Interface
      ----------------------------
      rx_axi_clk                  : in  std_logic;
      rx_reset_out                : out std_logic;
      rx_axis_mac_tdata           : out std_logic_vector(7 downto 0);
      rx_axis_mac_tvalid          : out std_logic;
      rx_axis_mac_tlast           : out std_logic;
      rx_axis_mac_tuser           : out std_logic;

      rx_statistics_vector        : out std_logic_vector(27 downto 0);
      rx_statistics_valid         : out std_logic;

      -- Transmitter Interface
      -------------------------------
      tx_axi_clk                  : in  std_logic;
      tx_reset_out                : out std_logic;
      tx_axis_mac_tdata           : in  std_logic_vector(7 downto 0);
      tx_axis_mac_tvalid          : in  std_logic;
      tx_axis_mac_tlast           : in  std_logic;
      tx_axis_mac_tuser           : in  std_logic;
      tx_axis_mac_tready          : out std_logic;

      tx_retransmit               : out std_logic;
      tx_collision                : out std_logic;
      tx_ifg_delay                : in  std_logic_vector(7 downto 0);
      tx_statistics_vector        : out std_logic_vector(31 downto 0);
      tx_statistics_valid         : out std_logic;

      -- MAC Control Interface
      ------------------------
      pause_req                   : in  std_logic;
      pause_val                   : in  std_logic_vector(15 downto 0);

      -- Current Speed Indication
      ---------------------------
      speed_is_10_100             : out std_logic;

      -- Physical Interface of the core
      --------------------------------
      gmii_txd                    : out std_logic_vector(7 downto 0);
      gmii_rxd                    : in  std_logic_vector(7 downto 0);
      gmii_rx_dv                  : in  std_logic;

      -- 1000BASE-X PCS/PMA interface
      --------------------------------
      dcm_locked                  : in  std_logic;
      an_interrupt                : out std_logic;
      signal_det                  : in  std_logic;
      phy_ad                      : in  std_logic_vector(4 downto 0);
      en_comma_align              : out std_logic;
      loopback_msb                : out std_logic;
      mgt_rx_reset                : out std_logic;
      mgt_tx_reset                : out std_logic;
      powerdown                   : out std_logic;
      sync_acq_status             : out std_logic;
      rx_clk_cor_cnt              : in  std_logic_vector(2 downto 0);
      rx_buf_status               : in  std_logic;
      rx_char_is_comma            : in  std_logic;
      rx_char_is_k                : in  std_logic;
      rx_disp_err                 : in  std_logic;
      rx_not_in_table             : in  std_logic;
      rx_run_disp                 : in  std_logic;
      tx_buf_err                  : in  std_logic;
      tx_char_disp_mode           : out std_logic;
      tx_char_disp_val            : out std_logic;
      tx_char_is_k                : out std_logic;


      glbl_rstn                   : in  std_logic;
      rx_axi_rstn                 : in  std_logic;
      tx_axi_rstn                 : in  std_logic

   );
end v6_emac_v2_3_basex;

architecture wrapper of v6_emac_v2_3_basex is

  ------------------------------------------------------------------------------
  -- Component Declaration for the MAC core.
  ------------------------------------------------------------------------------
   component EMAC_WRAPPER
   generic (
      C_HAS_MII                   : boolean := false;
      C_HAS_GMII                  : boolean := true;
      C_HAS_RGMII_V1_3            : boolean := false;
      C_HAS_RGMII_V2_0            : boolean := false;
      C_HAS_SGMII                 : boolean := false;
      C_HAS_GPCS                  : boolean := false;
      C_TRI_SPEED                 : boolean := false;
      C_SPEED_10                  : boolean := false;
      C_SPEED_100                 : boolean := false;
      C_SPEED_1000                : boolean := true;
      C_HAS_HOST                  : boolean := false;
      C_HAS_DCR                   : boolean := false;
      C_HAS_MDIO                  : boolean := false;
      C_CLIENT_16                 : boolean := false;
      C_OVERCLOCKING_RATE_2000MBPS: boolean := false;
      C_OVERCLOCKING_RATE_2500MBPS: boolean := false;
      C_HAS_CLOCK_ENABLE          : boolean := false;
      C_BYTE_PHY                  : boolean := false;
      C_ADD_FILTER                : boolean := false;
      C_UNICAST_PAUSE_ADDRESS     : string  := "000000000000";
      C_PHY_RESET                 : boolean := false;
      C_PHY_AN                    : boolean := false;
      C_PHY_ISOLATE               : boolean := false;
      C_PHY_POWERDOWN             : boolean := false;
      C_PHY_LOOPBACK_MSB          : boolean := false;
      C_LT_CHECK_DIS              : boolean := false;
      C_CTRL_LENCHECK_DISABLE     : boolean := false;
      C_RX_FLOW_CONTROL           : boolean := false;
      C_TX_FLOW_CONTROL           : boolean := false;
      C_TX_RESET                  : boolean := false;
      C_TX_JUMBO                  : boolean := false;
      C_TX_FCS                    : boolean := false;
      C_TX                        : boolean := true;
      C_TX_VLAN                   : boolean := false;
      C_TX_HALF_DUPLEX            : boolean := false;
      C_TX_IFG                    : boolean := false;
      C_RX_RESET                  : boolean := false;
      C_RX_JUMBO                  : boolean := false;
      C_RX_FCS                    : boolean := false;
      C_RX                        : boolean := true;
      C_RX_VLAN                   : boolean := false;
      C_RX_HALF_DUPLEX            : boolean := false;
      C_DCR_BASE_ADDRESS          : string  := x"00";
      C_LINK_TIMER_VALUE          : string  := x"13d";
      C_PHY_GTLOOPBACK            : boolean := false;
      C_PHY_IGNORE_ADZERO         : boolean := false;
      C_PHY_UNIDIRECTION_ENABLE   : boolean := false;
      SGMII_FABRIC_BUFFER         : boolean := false;
      C_SERIAL_MODE_SWITCH_EN     : boolean := false;
      C_ADD_BUFGS                 : boolean := false;

      C_PHY_WIDTH                 : integer := 8;
      C_AT_ENTRIES                : integer := 4;
      C_HAS_STATS                 : boolean := true;
      C_NUM_STATS                 : integer := 44;
      C_CNTR_RST                  : boolean := true;
      C_STATS_WIDTH               : integer := 64;
      C_INTERNAL_INT              : boolean := false
    );
    port(
    ---------------------------------------------------------------------------
    -- RESET signals
    ---------------------------------------------------------------------------
    GLBL_RSTN            : in  std_logic;
    RX_AXI_RSTN          : in  std_logic;
    TX_AXI_RSTN          : in  std_logic;

    ---------------------------------------------------------------------------
    -- Clock signals - used in rgmii and serial modes
    ---------------------------------------------------------------------------
    GTX_CLK              : in  std_logic;
    GTX_CLK_DIV2         : in  std_logic;
    TX_AXI_CLK_OUT       : out std_logic;

    ---------------------------------------------------------------------------
    -- Receiver Interface.
    ---------------------------------------------------------------------------
    RX_AXI_CLK           : in std_logic;
    RX_RESET_OUT         : out std_logic;
    RX_AXIS_MAC_TDATA    : out std_logic_vector(7 downto 0);
    RX_AXIS_MAC_TKEEP    : out std_logic_vector(1 downto 0);
    RX_AXIS_MAC_TVALID   : out std_logic;
    RX_AXIS_MAC_TLAST    : out std_logic;
    RX_AXIS_MAC_TUSER    : out std_logic;

    -- RX sideband signals
    RX_STATISTICS_VECTOR : out std_logic_vector(27 downto 0);
    RX_STATISTICS_VALID  : out std_logic;
    RX_AXIS_FILTER_TUSER : out std_logic_vector(0 downto 0);
    ---------------------------------------------------------------------------
    -- Transmitter Interface
    ---------------------------------------------------------------------------
    TX_AXI_CLK           : in std_logic;
    TX_RESET_OUT         : out std_logic;
    TX_AXIS_MAC_TDATA    : in  std_logic_vector(7 downto 0);
    TX_AXIS_MAC_TKEEP    : in  std_logic_vector(1 downto 0);
    TX_AXIS_MAC_TVALID   : in  std_logic;
    TX_AXIS_MAC_TLAST    : in  std_logic;
    TX_AXIS_MAC_TUSER    : in  std_logic;
    TX_AXIS_MAC_TREADY   : out std_logic;

    -- TX sideband signals
    TX_RETRANSMIT        : out std_logic;
    TX_COLLISION         : out std_logic;
    TX_IFG_DELAY         : in  std_logic_vector(7 downto 0);
    TX_STATISTICS_VECTOR : out std_logic_vector(31 downto 0);
    TX_STATISTICS_VALID  : out std_logic;
    ---------------------------------------------------------------------------
    -- Statistics Interface
    ---------------------------------------------------------------------------
    STATS_REF_CLK        : in std_logic;
    INCREMENT_VECTOR     : in std_logic_vector(4 to 43);

    ---------------------------------------------------------------------------
    -- Flow Control
    ---------------------------------------------------------------------------
    PAUSE_REQ            : in  std_logic;
    PAUSE_VAL            : in  std_logic_vector(15 downto 0);

    ---------------------------------------------------------------------------
    -- Speed interface
    ---------------------------------------------------------------------------
    SPEED_IS_100         : out std_logic;
    SPEED_IS_10_100      : out std_logic;

    ---------------------------------------------------------------------------
    -- GMII/MII Interface
    ---------------------------------------------------------------------------
    GMII_COL             : in  std_logic;
    GMII_CRS             : in  std_logic;
    GMII_TXD             : out std_logic_vector(7 downto 0);
    GMII_TX_EN           : out std_logic;
    GMII_TX_ER           : out std_logic;
    GMII_RXD             : in  std_logic_vector(7 downto 0);
    GMII_RX_DV           : in  std_logic;
    GMII_RX_ER           : in  std_logic;

    ---------------------------------------------------------------------------
    -- Serial Phy interface
    ---------------------------------------------------------------------------
    DCMLOCKED            : in  std_logic;
    ANINTERRUPT          : out std_logic;
    SIGNALDET            : in  std_logic;
    PHYAD                : in  std_logic_vector(4 downto 0);
    ENCOMMAALIGN         : out std_logic;
    LOOPBACKMSB          : out std_logic;
    MGTRXRESET           : out std_logic;
    MGTTXRESET           : out std_logic;
    POWERDOWN            : out std_logic;
    SYNCACQSTATUS        : out std_logic;
    RXCLKCORCNT          : in  std_logic_vector(2 downto 0);
    RXBUFSTATUS          : in  std_logic;
    RXCHARISCOMMA        : in  std_logic;
    RXCHARISK            : in  std_logic;
    RXDISPERR            : in  std_logic;
    RXNOTINTABLE         : in  std_logic;
    RXRUNDISP            : in  std_logic;
    TXBUFERR             : in  std_logic;
    TXCHARDISPMODE       : out std_logic;
    TXCHARDISPVAL        : out std_logic;
    TXCHARISK            : out std_logic;

    ---------------------------------------------------------------------------
    -- MDIO Interface
    ---------------------------------------------------------------------------
    MDIO_IN              : in    std_logic;
    MDIO_OUT             : out   std_logic;
    MDIO_TRI             : out   std_logic;
    MDC_OUT              : out   std_logic;                    -- Whenever Host I/F is present, MDC is an output.
    MDC_IN               : in   std_logic;
    ---------------------------------------------------------------------------
    -- IPIC Interface
    ---------------------------------------------------------------------------
    -- JK 19 Feb 2010: Replaced host interface ports with IPIC interface.
    BUS2IP_CLK           : in    std_logic;
    BUS2IP_RESET         : in    std_logic;
    BUS2IP_ADDR          : in    std_logic_vector(31 downto 0);
    BUS2IP_CS            : in    std_logic;
    BUS2IP_RDCE          : in    std_logic;
    BUS2IP_WRCE          : in    std_logic;
    BUS2IP_DATA          : in    std_logic_vector(31 downto 0);
    IP2BUS_DATA          : out   std_logic_vector(31 downto 0);
    IP2BUS_WRACK         : out   std_logic;
    IP2BUS_RDACK         : out   std_logic;
    IP2BUS_ERROR         : out   std_logic;

    MAC_IRQ              : out   std_logic;

    BASE_X_SWITCH        : in std_logic
    );



   end component;

   signal GTX_CLK_INT              : std_logic;
   signal GTX_CLK_DIV2_INT         : std_logic;

   signal GMII_TXD_INT             : std_logic_vector(7 downto 0);
   signal GMII_RXD_INT             : std_logic_vector(7 downto 0);
   signal GMII_CRS_INT             : std_logic;
   signal GMII_COL_INT             : std_logic;
   signal GMII_RX_ER_INT           : std_logic;

   signal MDIO_IN_INT              : std_logic;
   signal BUS2IP_CLK_INT           : std_logic;
   signal BUS2IP_RESET_INT         : std_logic;
   signal BUS2IP_ADDR_INT          : std_logic_vector(31 downto 0);
   signal BUS2IP_CS_INT            : std_logic;
   signal BUS2IP_RDCE_INT          : std_logic;
   signal BUS2IP_WRCE_INT          : std_logic;
   signal BUS2IP_DATA_INT          : std_logic_vector(31 downto 0);
   signal IP2BUS_DATA_INT          : std_logic_vector(31 downto 0);
   signal IP2BUS_WRACK_INT         : std_logic;
   signal IP2BUS_RDACK_INT         : std_logic;
   signal IP2BUS_ERROR_INT         : std_logic;
   signal MAC_IRQ_INT              : std_logic;

   signal INCREMENT_VECTOR_INT     : std_logic_vector(4 to 43);
   signal STATS_REF_CLK_INT        : std_logic;

   signal DCM_LOCKED_INT           : std_logic;
   signal SIGNAL_DET_INT           : std_logic;
   signal PHY_AD_INT               : std_logic_vector(4 downto 0);
   signal RX_CLK_COR_CNT_INT       : std_logic_vector(2 downto 0);
   signal RX_BUF_STATUS_INT        : std_logic;
   signal RX_CHAR_IS_COMMA_INT     : std_logic;
   signal RX_CHAR_IS_K_INT         : std_logic;
   signal RX_DISP_ERR_INT          : std_logic;
   signal RX_NOT_IN_TABLE_INT      : std_logic;
   signal RX_RUN_DISP_INT          : std_logic;
   signal TX_BUF_ERR_INT           : std_logic;

   signal TX_AXI_CLK_OUT_INT       : std_logic;
   signal AN_INTERRUPT_INT         : std_logic;
   signal EN_COMMA_ALIGN_INT       : std_logic;
   signal LOOPBACK_MSB_INT         : std_logic;
   signal MGT_RX_RESET_INT         : std_logic;
   signal MGT_TX_RESET_INT         : std_logic;
   signal POWERDOWN_INT            : std_logic;
   signal SYNC_ACQ_STATUS_INT      : std_logic;
   signal TX_CHAR_DISP_MODE_INT    : std_logic;
   signal TX_CHAR_DISP_VAL_INT     : std_logic;
   signal TX_CHAR_IS_K_INT         : std_logic;

   signal GMII_TX_EN_INT           : std_logic;
   signal GMII_TX_ER_INT           : std_logic;
   signal RX_AXIS_FILTER_TUSER_INT : std_logic_vector(0 downto 0);

   signal MDC_OUT_INT              : std_logic;
   signal MDC_IN_INT               : std_logic;
   signal MDIO_TRI_INT             : std_logic;
   signal MDIO_OUT_INT             : std_logic;

   signal BASE_X_SWITCH_INT        : std_logic;

begin


  -- Set the bus width of the PHY port (4 bits MII or 8 bits GMII)
     GMII_RXD_INT                           <= gmii_rxd;
     gmii_txd                               <= GMII_TXD_INT;

  -- Tie-off unused ports for C_HAS_HOST generic
     BUS2IP_CLK_INT                         <= '0';
     BUS2IP_RESET_INT                       <= '0';
     BUS2IP_CS_INT                          <= '0';
     BUS2IP_RDCE_INT                        <= '0';
     BUS2IP_WRCE_INT                        <= '0';
     BUS2IP_ADDR_INT                        <= (others => '0');
     BUS2IP_DATA_INT                        <= (others => '0');
     ip2bus_data                            <= '0';
     ip2bus_wrack                           <= '0';
     ip2bus_rdack                           <= '0';
     ip2bus_error                           <= '0';
     mac_irq                                <= '0';

     MDIO_IN_INT                            <= '0';
     MDC_IN_INT                             <= '0';

  -- Connect or tie off the stats increment signals
     INCREMENT_VECTOR_INT                       <= (others => '0');
     STATS_REF_CLK_INT                          <= '0';

     GTX_CLK_INT                                <= gtx_clk;

     GTX_CLK_DIV2_INT                           <= '0';

     DCM_LOCKED_INT                             <= dcm_locked;
     SIGNAL_DET_INT                             <= signal_det;
     PHY_AD_INT                                 <= phy_ad;
     RX_CLK_COR_CNT_INT                         <= rx_clk_cor_cnt;
     RX_BUF_STATUS_INT                          <= rx_buf_status;
     RX_CHAR_IS_COMMA_INT                       <= rx_char_is_comma;
     RX_CHAR_IS_K_INT                           <= rx_char_is_k;
     RX_DISP_ERR_INT                            <= rx_disp_err;
     RX_NOT_IN_TABLE_INT                        <= rx_not_in_table;
     RX_RUN_DISP_INT                            <= rx_run_disp;
     TX_BUF_ERR_INT                             <= tx_buf_err;
     GMII_RX_ER_INT                             <= '0';

     GMII_CRS_INT                               <= '0';
     GMII_COL_INT                               <= '0';



     an_interrupt                               <= AN_INTERRUPT_INT;
     en_comma_align                             <= EN_COMMA_ALIGN_INT;
     loopback_msb                               <= LOOPBACK_MSB_INT;
     mgt_rx_reset                               <= MGT_RX_RESET_INT;
     mgt_tx_reset                               <= MGT_TX_RESET_INT;
     powerdown                                  <= POWERDOWN_INT;
     sync_acq_status                            <= SYNC_ACQ_STATUS_INT;
     tx_char_disp_mode                          <= TX_CHAR_DISP_MODE_INT;
     tx_char_disp_val                           <= TX_CHAR_DISP_VAL_INT;
     tx_char_is_k                               <= TX_CHAR_IS_K_INT;

     BASE_X_SWITCH_INT                          <= '0';

  EMAC_TOP : EMAC_WRAPPER
   generic map (
      C_HAS_MII                   => false,
      C_HAS_GMII                  => false,
      C_HAS_RGMII_V1_3            => false,
      C_HAS_RGMII_V2_0            => false,
      C_HAS_SGMII                 => false,
      C_HAS_GPCS                  => true,
      C_TRI_SPEED                 => false,
      C_SPEED_10                  => false,
      C_SPEED_100                 => false,
      C_SPEED_1000                => true,
      C_HAS_HOST                  => false,
      C_HAS_DCR                   => false,
      C_HAS_MDIO                  => false,
      C_CLIENT_16                 => false,
      C_OVERCLOCKING_RATE_2000MBPS=> false,
      C_OVERCLOCKING_RATE_2500MBPS=> false,
      C_HAS_CLOCK_ENABLE          => false,
      C_BYTE_PHY                  => false,
      C_ADD_FILTER                => false,
      C_UNICAST_PAUSE_ADDRESS     => "AABBCCDDEEFF",
      C_PHY_RESET                 => false,
      C_PHY_AN                    => false,
      C_PHY_ISOLATE               => false,
      C_PHY_POWERDOWN             => false,
      C_PHY_LOOPBACK_MSB          => false,
      C_LT_CHECK_DIS              => false,
      C_CTRL_LENCHECK_DISABLE     => false,
      C_RX_FLOW_CONTROL           => false,
      C_TX_FLOW_CONTROL           => false,
      C_TX_RESET                  => false,
      C_TX_JUMBO                  => false,
      C_TX_FCS                    => false,
      C_TX                        => true,
      C_TX_VLAN                   => false,
      C_TX_HALF_DUPLEX            => false,
      C_TX_IFG                    => false,
      C_RX_RESET                  => false,
      C_RX_JUMBO                  => false,
      C_RX_FCS                    => false,
      C_RX                        => true,
      C_RX_VLAN                   => false,
      C_RX_HALF_DUPLEX            => false,
      C_DCR_BASE_ADDRESS          => "00",
      C_LINK_TIMER_VALUE          => "13d",
      C_PHY_GTLOOPBACK            => false,
      C_PHY_IGNORE_ADZERO         => false,
      C_PHY_UNIDIRECTION_ENABLE   => false,
      SGMII_FABRIC_BUFFER         => false,
      C_SERIAL_MODE_SWITCH_EN     => false,
      C_ADD_BUFGS                 => false,

      C_PHY_WIDTH                 => 8,
      C_AT_ENTRIES                => 0,
      C_HAS_STATS                 => false,
      C_NUM_STATS                 => 44,
      C_CNTR_RST                  => true,
      C_STATS_WIDTH               => 32
      )
   port map (
      GLBL_RSTN                   => glbl_rstn,
      RX_AXI_RSTN                 => rx_axi_rstn,
      TX_AXI_RSTN                 => tx_axi_rstn,

      GTX_CLK                     => GTX_CLK_INT,
      GTX_CLK_DIV2                => GTX_CLK_DIV2_INT,
      TX_AXI_CLK_OUT              => TX_AXI_CLK_OUT_INT,

      GMII_TXD                    => GMII_TXD_INT,
      GMII_TX_EN                  => GMII_TX_EN_INT,
      GMII_TX_ER                  => GMII_TX_ER_INT,

      GMII_CRS                    => GMII_CRS_INT,
      GMII_COL                    => GMII_COL_INT,
      GMII_RXD                    => GMII_RXD_INT,
      GMII_RX_DV                  => gmii_rx_dv,
      GMII_RX_ER                  => GMII_RX_ER_INT,

      DCMLOCKED                   => DCM_LOCKED_INT,
      ANINTERRUPT                 => AN_INTERRUPT_INT,
      SIGNALDET                   => SIGNAL_DET_INT,
      PHYAD                       => PHY_AD_INT,
      ENCOMMAALIGN                => EN_COMMA_ALIGN_INT,
      LOOPBACKMSB                 => LOOPBACK_MSB_INT,
      MGTRXRESET                  => MGT_RX_RESET_INT,
      MGTTXRESET                  => MGT_TX_RESET_INT,
      POWERDOWN                   => POWERDOWN_INT,
      SYNCACQSTATUS               => SYNC_ACQ_STATUS_INT,
      RXCLKCORCNT                 => RX_CLK_COR_CNT_INT,
      RXBUFSTATUS                 => RX_BUF_STATUS_INT,
      RXCHARISCOMMA               => RX_CHAR_IS_COMMA_INT,
      RXCHARISK                   => RX_CHAR_IS_K_INT,
      RXDISPERR                   => RX_DISP_ERR_INT,
      RXNOTINTABLE                => RX_NOT_IN_TABLE_INT,
      RXRUNDISP                   => RX_RUN_DISP_INT,
      TXBUFERR                    => TX_BUF_ERR_INT,
      TXCHARDISPMODE              => TX_CHAR_DISP_MODE_INT,
      TXCHARDISPVAL               => TX_CHAR_DISP_VAL_INT,
      TXCHARISK                   => TX_CHAR_IS_K_INT,

      MDC_OUT                     => MDC_OUT_INT,
      MDC_IN                      => MDC_IN_INT,
      MDIO_TRI                    => MDIO_TRI_INT,
      MDIO_OUT                    => MDIO_OUT_INT,
      MDIO_IN                     => MDIO_IN_INT,

      TX_AXI_CLK                  => tx_axi_clk,
      TX_RESET_OUT                => tx_reset_out,
      TX_AXIS_MAC_TDATA           => tx_axis_mac_tdata,
      TX_AXIS_MAC_TKEEP           => "11",
      TX_AXIS_MAC_TVALID          => tx_axis_mac_tvalid,
      TX_AXIS_MAC_TLAST           => tx_axis_mac_tlast,
      TX_AXIS_MAC_TUSER           => tx_axis_mac_tuser,
      TX_AXIS_MAC_TREADY          => tx_axis_mac_tready,

      TX_COLLISION                => tx_collision,
      TX_RETRANSMIT               => tx_retransmit,
      TX_IFG_DELAY                => tx_ifg_delay,
      PAUSE_REQ                   => pause_req,
      PAUSE_VAL                   => pause_val,

      RX_AXI_CLK                  => rx_axi_clk,
      RX_RESET_OUT                => rx_reset_out,
      RX_AXIS_MAC_TDATA           => rx_axis_mac_tdata,
      RX_AXIS_MAC_TKEEP           => open,
      RX_AXIS_MAC_TVALID          => rx_axis_mac_tvalid,
      RX_AXIS_MAC_TLAST           => rx_axis_mac_tlast,
      RX_AXIS_MAC_TUSER           => rx_axis_mac_tuser,
      RX_AXIS_FILTER_TUSER        => RX_AXIS_FILTER_TUSER_INT,

      STATS_REF_CLK               => STATS_REF_CLK_INT,
      INCREMENT_VECTOR            => INCREMENT_VECTOR_INT,

      TX_STATISTICS_VECTOR        => tx_statistics_vector,
      TX_STATISTICS_VALID         => tx_statistics_valid,

      RX_STATISTICS_VECTOR        => rx_statistics_vector,
      RX_STATISTICS_VALID         => rx_statistics_valid,

      SPEED_IS_10_100             => speed_is_10_100,

      BUS2IP_CLK                  => BUS2IP_CLK_INT,
      BUS2IP_RESET                => BUS2IP_RESET_INT,
      BUS2IP_ADDR                 => BUS2IP_ADDR_INT,
      BUS2IP_CS                   => BUS2IP_CS_INT,
      BUS2IP_RDCE                 => BUS2IP_RDCE_INT,
      BUS2IP_WRCE                 => BUS2IP_WRCE_INT,
      BUS2IP_DATA                 => BUS2IP_DATA_INT,
      IP2BUS_DATA                 => IP2BUS_DATA_INT,
      IP2BUS_WRACK                => IP2BUS_WRACK_INT,
      IP2BUS_RDACK                => IP2BUS_RDACK_INT,
      IP2BUS_ERROR                => IP2BUS_ERROR_INT,

      MAC_IRQ                     => MAC_IRQ_INT,
      BASE_X_SWITCH               => BASE_X_SWITCH_INT
   );

end wrapper;
