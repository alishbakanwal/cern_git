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

--  Generated from component ID: xilinx.com:ip:dist_mem_gen:5.1


-- You must compile the wrapper file dist_mem_gen_v5_1.vhd when simulating
-- the core, dist_mem_gen_v5_1. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY dist_mem_gen_v5_1 IS
	port (
	a: in std_logic_vector(3 downto 0);
	d: in std_logic_vector(127 downto 0);
	dpra: in std_logic_vector(3 downto 0);
	clk: in std_logic;
	we: in std_logic;
	qdpo_clk: in std_logic;
	qdpo: out std_logic_vector(127 downto 0));
END dist_mem_gen_v5_1;

ARCHITECTURE dist_mem_gen_v5_1_a OF dist_mem_gen_v5_1 IS
-- synthesis translate_off
component wrapped_dist_mem_gen_v5_1
	port (
	a: in std_logic_vector(3 downto 0);
	d: in std_logic_vector(127 downto 0);
	dpra: in std_logic_vector(3 downto 0);
	clk: in std_logic;
	we: in std_logic;
	qdpo_clk: in std_logic;
	qdpo: out std_logic_vector(127 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_dist_mem_gen_v5_1 use entity XilinxCoreLib.dist_mem_gen_v5_1(behavioral)
		generic map(
			c_has_clk => 1,
			c_has_qdpo_clk => 1,
			c_has_qdpo_ce => 0,
			c_parser_type => 1,
			c_has_d => 1,
			c_has_spo => 0,
			c_read_mif => 0,
			c_has_qspo => 0,
			c_width => 128,
			c_reg_a_d_inputs => 1,
			c_has_we => 1,
			c_pipeline_stages => 0,
			c_has_qdpo_rst => 0,
			c_reg_dpra_input => 0,
			c_qualify_we => 0,
			c_family => "virtex6",
			c_sync_enable => 1,
			c_depth => 16,
			c_has_qspo_srst => 0,
			c_has_qdpo_srst => 0,
			c_has_dpra => 1,
			c_qce_joined => 0,
			c_mem_type => 4,
			c_has_i_ce => 0,
			c_has_dpo => 0,
			c_mem_init_file => "no_coe_file_loaded",
			c_default_data => "0",
			c_has_spra => 0,
			c_has_qspo_ce => 0,
			c_addr_width => 4,
			c_has_qspo_rst => 0,
			c_has_qdpo => 1);
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_dist_mem_gen_v5_1
		port map (
			a => a,
			d => d,
			dpra => dpra,
			clk => clk,
			we => we,
			qdpo_clk => qdpo_clk,
			qdpo => qdpo);
-- synthesis translate_on

END dist_mem_gen_v5_1_a;

