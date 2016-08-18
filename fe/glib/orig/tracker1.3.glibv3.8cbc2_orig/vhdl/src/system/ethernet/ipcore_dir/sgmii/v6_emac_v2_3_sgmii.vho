--------------------------------------------------------------------------------
--     (c) Copyright 1995 - 2010 Xilinx, Inc. All rights reserved.            --
--                                                                            --
--     This file contains confidential and proprietary information            --
--     of Xilinx, Inc. and is protected under U.S. and                        --
--     international copyright and other intellectual property                --
--     laws.                                                                  --
--                                                                            --
--     DISCLAIMER                                                             --
--     This disclaimer is not a license and does not grant any                --
--     rights to the materials distributed herewith. Except as                --
--     otherwise provided in a valid license issued to you by                 --
--     Xilinx, and to the maximum extent permitted by applicable              --
--     law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND                --
--     WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES            --
--     AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING              --
--     BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-                 --
--     INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and               --
--     (2) Xilinx shall not be liable (whether in contract or tort,           --
--     including negligence, or under any other theory of                     --
--     liability) for any loss or damage of any kind or nature                --
--     related to, arising under or in connection with these                  --
--     materials, including for any direct, or any indirect,                  --
--     special, incidental, or consequential loss or damage                   --
--     (including loss of data, profits, goodwill, or any type of             --
--     loss or damage suffered as a result of any action brought              --
--     by a third party) even if such damage or loss was                      --
--     reasonably foreseeable or Xilinx had been advised of the               --
--     possibility of the same.                                               --
--                                                                            --
--     CRITICAL APPLICATIONS                                                  --
--     Xilinx products are not designed or intended to be fail-               --
--     safe, or for use in any application requiring fail-safe                --
--     performance, such as life-support or safety devices or                 --
--     systems, Class III medical devices, nuclear facilities,                --
--     applications related to the deployment of airbags, or any              --
--     other applications that could lead to death, personal                  --
--     injury, or severe property or environmental damage                     --
--     (individually and collectively, "Critical                              --
--     Applications"). Customer assumes the sole risk and                     --
--     liability of any use of Xilinx products in Critical                    --
--     Applications, subject only to applicable laws and                      --
--     regulations governing limitations on product liability.                --
--                                                                            --
--     THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS               --
--     PART OF THIS FILE AT ALL TIMES.                                        --
--------------------------------------------------------------------------------

--  Generated from component ID: xilinx.com:ip:v6_emac:2.3


-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component v6_emac_v2_3_sgmii
	port (
	glbl_rstn: in std_logic;
	rx_axi_rstn: in std_logic;
	tx_axi_rstn: in std_logic;
	gtx_clk: in std_logic;
	tx_axi_clk_out: out std_logic;
	rx_axi_clk: in std_logic;
	rx_reset_out: out std_logic;
	rx_axis_mac_tdata: out std_logic_vector(7 downto 0);
	rx_axis_mac_tvalid: out std_logic;
	rx_axis_mac_tlast: out std_logic;
	rx_axis_mac_tuser: out std_logic;
	rx_statistics_vector: out std_logic_vector(27 downto 0);
	rx_statistics_valid: out std_logic;
	tx_axi_clk: in std_logic;
	tx_reset_out: out std_logic;
	tx_axis_mac_tdata: in std_logic_vector(7 downto 0);
	tx_axis_mac_tvalid: in std_logic;
	tx_axis_mac_tlast: in std_logic;
	tx_axis_mac_tuser: in std_logic;
	tx_axis_mac_tready: out std_logic;
	tx_retransmit: out std_logic;
	tx_collision: out std_logic;
	tx_ifg_delay: in std_logic_vector(7 downto 0);
	tx_statistics_vector: out std_logic_vector(31 downto 0);
	tx_statistics_valid: out std_logic;
	pause_req: in std_logic;
	pause_val: in std_logic_vector(15 downto 0);
	speed_is_10_100: out std_logic;
	gmii_txd: out std_logic_vector(7 downto 0);
	gmii_rxd: in std_logic_vector(7 downto 0);
	gmii_rx_dv: in std_logic;
	dcm_locked: in std_logic;
	an_interrupt: out std_logic;
	signal_det: in std_logic;
	phy_ad: in std_logic_vector(4 downto 0);
	en_comma_align: out std_logic;
	loopback_msb: out std_logic;
	mgt_rx_reset: out std_logic;
	mgt_tx_reset: out std_logic;
	powerdown: out std_logic;
	sync_acq_status: out std_logic;
	rx_clk_cor_cnt: in std_logic_vector(2 downto 0);
	rx_buf_status: in std_logic;
	rx_char_is_comma: in std_logic;
	rx_char_is_k: in std_logic;
	rx_disp_err: in std_logic;
	rx_not_in_table: in std_logic;
	rx_run_disp: in std_logic;
	tx_buf_err: in std_logic;
	tx_char_disp_mode: out std_logic;
	tx_char_disp_val: out std_logic;
	tx_char_is_k: out std_logic;
	mdc_in: in std_logic;
	mdio_in: in std_logic;
	mdio_out: out std_logic;
	mdio_tri: out std_logic);
end component;

-- Synplicity black box declaration
attribute syn_black_box : boolean;
attribute syn_black_box of v6_emac_v2_3_sgmii: component is true;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------

-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.

------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG
your_instance_name : v6_emac_v2_3_sgmii
		port map (
			glbl_rstn => glbl_rstn,
			rx_axi_rstn => rx_axi_rstn,
			tx_axi_rstn => tx_axi_rstn,
			gtx_clk => gtx_clk,
			tx_axi_clk_out => tx_axi_clk_out,
			rx_axi_clk => rx_axi_clk,
			rx_reset_out => rx_reset_out,
			rx_axis_mac_tdata => rx_axis_mac_tdata,
			rx_axis_mac_tvalid => rx_axis_mac_tvalid,
			rx_axis_mac_tlast => rx_axis_mac_tlast,
			rx_axis_mac_tuser => rx_axis_mac_tuser,
			rx_statistics_vector => rx_statistics_vector,
			rx_statistics_valid => rx_statistics_valid,
			tx_axi_clk => tx_axi_clk,
			tx_reset_out => tx_reset_out,
			tx_axis_mac_tdata => tx_axis_mac_tdata,
			tx_axis_mac_tvalid => tx_axis_mac_tvalid,
			tx_axis_mac_tlast => tx_axis_mac_tlast,
			tx_axis_mac_tuser => tx_axis_mac_tuser,
			tx_axis_mac_tready => tx_axis_mac_tready,
			tx_retransmit => tx_retransmit,
			tx_collision => tx_collision,
			tx_ifg_delay => tx_ifg_delay,
			tx_statistics_vector => tx_statistics_vector,
			tx_statistics_valid => tx_statistics_valid,
			pause_req => pause_req,
			pause_val => pause_val,
			speed_is_10_100 => speed_is_10_100,
			gmii_txd => gmii_txd,
			gmii_rxd => gmii_rxd,
			gmii_rx_dv => gmii_rx_dv,
			dcm_locked => dcm_locked,
			an_interrupt => an_interrupt,
			signal_det => signal_det,
			phy_ad => phy_ad,
			en_comma_align => en_comma_align,
			loopback_msb => loopback_msb,
			mgt_rx_reset => mgt_rx_reset,
			mgt_tx_reset => mgt_tx_reset,
			powerdown => powerdown,
			sync_acq_status => sync_acq_status,
			rx_clk_cor_cnt => rx_clk_cor_cnt,
			rx_buf_status => rx_buf_status,
			rx_char_is_comma => rx_char_is_comma,
			rx_char_is_k => rx_char_is_k,
			rx_disp_err => rx_disp_err,
			rx_not_in_table => rx_not_in_table,
			rx_run_disp => rx_run_disp,
			tx_buf_err => tx_buf_err,
			tx_char_disp_mode => tx_char_disp_mode,
			tx_char_disp_val => tx_char_disp_val,
			tx_char_is_k => tx_char_is_k,
			mdc_in => mdc_in,
			mdio_in => mdio_in,
			mdio_out => mdio_out,
			mdio_tri => mdio_tri);
-- INST_TAG_END ------ End INSTANTIATION Template ------------

