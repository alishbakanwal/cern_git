------------------------------------------------------------------------
-- Title      : Demo Testbench
-- Project    : Xilinx LogiCORE Virtex-6 Embedded Tri-Mode Ethernet MAC
-- File       : demo_tb.vhd
-- Version    : 2.3
-------------------------------------------------------------------------------
--
-- (c) Copyright 2004-2008 Xilinx, Inc. All rights reserved.
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
------------------------------------------------------------------------
-- Description: This testbench will exercise the PHY ports of the EMAC
--              to demonstrate the functionality.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;


architecture behavioral of testbench is


  ----------------------------------------------------------------------
  -- Component declaration for v6_emac_v2_3_sgmii_example_design
  --                           (the top level EMAC example deisgn)
  ----------------------------------------------------------------------
  component v6_emac_v2_3_sgmii_example_design
    port (
      -- asynchronous reset
      glbl_rst              : in  std_logic;


    -- SGMII-transceiver clock buffer input
      mgtclk_n              : in  std_logic;
      mgtclk_p              : in  std_logic;

      phy_resetn            : out std_logic;
          

    -- SGMII interface
      txp                   : out std_logic;
      txn                   : out std_logic;
      rxp                   : in  std_logic;
      rxn                   : in  std_logic;
      -- MDIO Interface
      -----------------
      mdio                  : inout std_logic;
      mdc_in                : in  std_logic;

      -- Serialised statistics vectors
      --------------------------------
      tx_statistics_s       : out std_logic;
      rx_statistics_s       : out std_logic;

      -- Serialised Pause interface controls
      --------------------------------------
      pause_req_s           : in  std_logic;

      -- Main example design controls
      -------------------------------
      mac_speed             : in  std_logic_vector(1 downto 0);
      update_speed          : in  std_logic;
      serial_command        : in  std_logic;
      syncacqstatus         : out std_logic;
      gen_tx_data           : in  std_logic;
      chk_tx_data           : in  std_logic;
      swap_address          : in  std_logic;
      reset_error           : in  std_logic;
      frame_error           : out std_logic;
      frame_errorn          : out std_logic

    );
  end component;

  ----------------------------------------------------------------------
  -- Component declaration for the MDIO tb
  ----------------------------------------------------------------------
  component mdio_tb
    port (
      resetn                : in  std_logic;
      mdio                  : inout std_logic;
      mdc_in                : out std_logic;
      mdio_done             : out std_logic
    );
  end component;

  ----------------------------------------------------------------------
  -- Component declaration for the PHY stimulus and monitor
  ----------------------------------------------------------------------

  component phy_tb is
    port(
      clk125m               : in std_logic;

      ------------------------------------------------------------------
      -- GMII interface
      ------------------------------------------------------------------
      txp                   : in  std_logic;
      txn                   : in  std_logic;
      rxp                   : out std_logic;
      rxn                   : out std_logic;

      ------------------------------------------------------------------
      -- Testbench semaphores
      ------------------------------------------------------------------
      configuration_busy    : in  boolean;
      monitor_finished_1g   : out boolean;
      monitor_finished_100m : out boolean;
      monitor_finished_10m  : out boolean
    );
  end component;


  ----------------------------------------------------------------------
  -- Testbench signals
  ----------------------------------------------------------------------
    signal reset              : std_logic := '1';
    signal resetn             : std_logic := '1';


    -- SGMII signals
    signal txp                : std_logic;
    signal txn                : std_logic;
    signal rxp                : std_logic;
    signal rxn                : std_logic;

    -- MDIO signals
    signal mdc                : std_logic;
    signal mdc_in             : std_logic := '1';
    signal mdio               : std_logic;
    signal mdio_done          : std_logic;

    -- Clock signals
    signal gtx_clk            : std_logic;
    signal mgtclk_p           : std_logic := '0';
    signal mgtclk_n           : std_logic := '1';
    signal mac_speed          : std_logic_vector(1 downto 0);
    signal update_speed       : std_logic;
    signal syncacqstatus      : std_logic;

    ------------------------------------------------------------------
    -- Testbench semaphores
    ------------------------------------------------------------------
    signal configuration_busy    : boolean := false;
    signal monitor_finished_1g   : boolean := false;
    signal monitor_finished_100m : boolean := false;
    signal monitor_finished_10m  : boolean := false;


begin
  resetn <= not reset;

  ----------------------------------------------------------------------
  -- Wire up device under test
  ----------------------------------------------------------------------
  dut : v6_emac_v2_3_sgmii_example_design
   port map (
   -- asynchronous reset
   glbl_rst                        => reset,


   -- SGMII-transceiver clock buffer input
   mgtclk_n                        => mgtclk_n,
   mgtclk_p                        => mgtclk_p,
   phy_resetn                      => open,


   -- SGMII interface
   txp                             => txp,
   txn                             => txn,
   rxp                             => rxp,
   rxn                             => rxn,

   -- MDIO Interface
   -----------------
   mdio                            => mdio,
   mdc_in                          => mdc_in,

   -- Serialised statistics vectors
   --------------------------------
   tx_statistics_s                 => open,
   rx_statistics_s                 => open,

   -- Serialised Pause interface controls
   --------------------------------------
   pause_req_s                     => '0',

   -- Main example design controls
   -------------------------------
   mac_speed                       => mac_speed,
   update_speed                    => update_speed,
   serial_command                  => '0',
   syncacqstatus                   => syncacqstatus,
   gen_tx_data                     => '0',
   chk_tx_data                     => '0',
   swap_address                    => '1',
   reset_error                     => '0',
   frame_error                     => open,
   frame_errorn                    => open
  );


  ---------------------------------------------------------------------------
  -- If the simulation is still going after 620 us then
  -- something has gone wrong
  ---------------------------------------------------------------------------
  p_timebomb : process
  begin
    wait for 120 us;
    assert false
      report "ERROR - Simulation running forever!"
      severity failure;
  end process p_timebomb;

    ----------------------------------------------------------------------------
    -- Clock drivers
    ----------------------------------------------------------------------------

    -- Drive GTX_CLK at 125 MHz
    p_gtx_clk : process
    begin
        gtx_clk <= '0';
        wait for 10 ns;
        loop
            wait for 4 ns;
            gtx_clk <= '1';
            wait for 4 ns;
            gtx_clk <= '0';
        end loop;
    end process p_gtx_clk;

    -- Drive serial transceiver differential clock at 125MHz
    mgtclk_p <= gtx_clk;
    mgtclk_n <= not gtx_clk;

  -----------------------------------------------------------------------------
  -- Management process. This process sets up the configuration by
  -- turning off flow control, and checks gathered statistics at the
  -- end of transmission
  -----------------------------------------------------------------------------
  p_management : process

    -- Procedure to reset the MAC
    ------------------------------
    procedure mac_reset is
    begin
      assert false
        report "Resetting core..." & cr
        severity note;

      reset <= '1';
      wait for 400 ns;

      reset <= '0';

      assert false
        report "Timing checks are valid" & cr
        severity note;
    end procedure mac_reset;


  begin  -- process p_management

  assert false
      report "Timing checks are not valid" & cr
      severity note;
    configuration_busy <= true;

    mac_speed <= "10";
    update_speed <= '0';


    -- reset the core
    mac_reset;

    wait until mdio_done = '1';
    -- ensure the sync has been acquired - may have already asserted so cannot just look for edge
    wait for 20 us;
    wait until gtx_clk'event and syncacqstatus = '1';
    for j in 0 to 49 loop
      wait until gtx_clk'event and gtx_clk = '1';
    end loop;

    -- Signal that configuration is complete.  Other processes will now
    -- be allowed to run.
    configuration_busy <= false;

    -- The stimulus process will now send 4 frames at 1Gb/s.
    --------------------------------------------------------------------

    -- Wait for 1G monitor process to complete.
    wait until monitor_finished_1g;
    configuration_busy <= true;



    assert false
      report "Simulation stopped"
      severity failure;
    wait;

  end process p_management;

  ----------------------------------------------------------------------
  -- Instantiate the MDIO stimulus and monitor
  ----------------------------------------------------------------------
  mdio_test : mdio_tb
  port map (
    resetn                  => resetn,
    mdio                    => mdio,
    mdc_in                  => mdc_in,
    mdio_done               => mdio_done
   );


  ----------------------------------------------------------------------
  -- Instantiate the PHY stimulus and monitor
  ----------------------------------------------------------------------

  phy_test: phy_tb
    port map (
      clk125m               => gtx_clk,
      ------------------------------------------------------------------
      -- GMII interface
      ------------------------------------------------------------------
      txp                   => txp,
      txn                   => txn,
      rxp                   => rxp,
      rxn                   => rxn,

      ------------------------------------------------------------------
      -- Testbench semaphores
      ------------------------------------------------------------------
      configuration_busy    => configuration_busy,
      monitor_finished_1g   => monitor_finished_1g,
      monitor_finished_100m => monitor_finished_100m,
      monitor_finished_10m  => monitor_finished_10m
    );

end behavioral;
