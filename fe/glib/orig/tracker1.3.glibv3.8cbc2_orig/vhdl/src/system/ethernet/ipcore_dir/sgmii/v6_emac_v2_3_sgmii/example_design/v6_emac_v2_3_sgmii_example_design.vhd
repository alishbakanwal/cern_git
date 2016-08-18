--------------------------------------------------------------------------------
-- Project    : Xilinx LogiCORE Virtex-6 Embedded Tri-Mode Ethernet MAC
-- File       : v6_emac_v2_3_sgmii_example_design.vhd
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
-- Description:  This is the VHDL example design for the Virtex-6
--               Embedded Tri-Mode Ethernet MAC. It is intended that this
--               example design can be quickly adapted and downloaded onto
--               an FPGA to provide a real hardware test environment.
--
--               This level:
--
--               * Instantiates the FIFO Block wrapper, containing the
--                 block level wrapper and an RX and TX FIFO with an
--                 AXI-S interface;
--
--               * Instantiates a simple AXI-S example design,
--                 providing an address swap and a simple
--                 loopback function;
--
--               * Instantiates transmitter clocking circuitry
--                   -the User side of the FIFOs are clocked at gtx_clk
--                    at all times
--
--
--               * Serializes the Statistics vectors to prevent logic being
--                 optimized out
--
--               * Ties unused inputs off to reduce the number of IO
--
--               Please refer to the Datasheet, Getting Started Guide, and
--               the Virtex-6 Embedded Tri-Mode Ethernet MAC User Gude for
--               further information.
--
--
--    ---------------------------------------------------------------------
--    | EXAMPLE DESIGN WRAPPER                                            |
--    |           --------------------------------------------------------|
--    |           |FIFO BLOCK WRAPPER                                     |
--    |           |                                                       |
--    |           |                                                       |
--    |           |              -----------------------------------------|
--    |           |              | BLOCK LEVEL WRAPPER                    |
--    |           |              |    ---------------------               |
--    |           |              |    |   V6 EMAC CORE    |               |
--    |           |              |    |                   |               |
--    |           |              |    |                   |               |
--    |           |              |    |                   |               |
--    |           |              |    |                   |               |
--    | --------  |  ----------  |    |                   |               |
--    | |      |  |  |        |  |    |                   |               |
--    | |      |->|->|        |--|--->| Tx            Tx  |-------------->|
--    | |      |  |  |        |  |    | AXI-S         PHY |               |
--    | | ADDR |  |  |        |  |    | I/F           I/F |               |
--    | | SWAP |  |  |  AXI-S |  |    |                   |               |
--    | |      |  |  |  FIFO  |  |    |                   |               |
--    | |      |  |  |        |  |    |                   |               |
--    | |      |  |  |        |  |    | Rx            Rx  |               |
--    | |      |  |  |        |  |    | AX)-S         PHY |               |
--    | |      |<-|<-|        |<-|----| I/F           I/F |<--------------|
--    | |      |  |  |        |  |    |                   |               |
--    | --------  |  ----------  |    ---------------------               |
--    |           |              |                                        |
--    |           |              -----------------------------------------|
--    |           --------------------------------------------------------|
--    ---------------------------------------------------------------------
--
--------------------------------------------------------------------------------

library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------
-- The entity declaration for the example_design level wrapper.
--------------------------------------------------------------------------------

entity v6_emac_v2_3_sgmii_example_design is
    port (
      -- asynchronous reset
      glbl_rst                      : in  std_logic;


    -- SGMII-transceiver clock buffer input
      mgtclk_n                      : in  std_logic;
      mgtclk_p                      : in  std_logic;

      phy_resetn            : out std_logic;

    -- SGMII interface
      txp                           : out std_logic;
      txn                           : out std_logic;
      rxp                           : in  std_logic;
      rxn                           : in  std_logic;
      -- MDIO Interface
      -----------------
      mdio                          : inout std_logic;
      mdc_in                        : in  std_logic;

      -- Serialised statistics vectors
      --------------------------------
      tx_statistics_s               : out std_logic;
      rx_statistics_s               : out std_logic;

      -- Serialised Pause interface controls
      --------------------------------------
      pause_req_s                   : in  std_logic;

      -- Main example design controls
      -------------------------------
      mac_speed                     : in  std_logic_vector(1 downto 0);
      update_speed                  : in  std_logic;
      serial_command                : in  std_logic;
      syncacqstatus                 : out std_logic;
      gen_tx_data                   : in  std_logic;
      chk_tx_data                   : in  std_logic;
      swap_address                  : in  std_logic;
      reset_error                   : in  std_logic;
      frame_error                   : out std_logic;
      frame_errorn                  : out std_logic


    );
end v6_emac_v2_3_sgmii_example_design;

architecture wrapper of v6_emac_v2_3_sgmii_example_design is

  ------------------------------------------------------------------------------
  -- Component Declaration for the Tri-Mode EMAC core FIFO Block wrapper
  ------------------------------------------------------------------------------

   component v6_emac_v2_3_sgmii_fifo_block
   port(
      gtx_clk                    : in  std_logic;
      clk125_out                 : out std_logic;
      -- Receiver Statistics Interface
      -----------------------------------------
      rx_reset                   : out std_logic;
      rx_statistics_vector       : out std_logic_vector(27 downto 0);
      rx_statistics_valid        : out std_logic;

      -- Receiver (AXI-S) Interface
      ------------------------------------------
      rx_fifo_clock              : in  std_logic;
      rx_fifo_resetn             : in  std_logic;
      rx_axis_fifo_tdata         : out std_logic_vector(7 downto 0);
      rx_axis_fifo_tvalid        : out std_logic;
      rx_axis_fifo_tready        : in  std_logic;
      rx_axis_fifo_tlast         : out std_logic;

      -- Transmitter Statistics Interface
      --------------------------------------------
      tx_reset                   : out std_logic;
      tx_ifg_delay               : in  std_logic_vector(7 downto 0);
      tx_statistics_vector       : out std_logic_vector(31 downto 0);
      tx_statistics_valid        : out std_logic;

      -- Transmitter (AXI-S) Interface
      ---------------------------------------------
      tx_fifo_clock              : in  std_logic;
      tx_fifo_resetn             : in  std_logic;
      tx_axis_fifo_tdata         : in  std_logic_vector(7 downto 0);
      tx_axis_fifo_tvalid        : in  std_logic;
      tx_axis_fifo_tready        : out std_logic;
      tx_axis_fifo_tlast         : in  std_logic;

      -- MAC Control Interface
      --------------------------
      pause_req                  : in  std_logic;
      pause_val                  : in  std_logic_vector(15 downto 0);

    -- SGMII interface
      txp                       : out std_logic;
      txn                       : out std_logic;
      rxp                       : in  std_logic;
      rxn                       : in  std_logic;
      phyad                     : in  std_logic_vector(4 downto 0);
      resetdone                 : out std_logic;
      syncacqstatus             : out std_logic;
    -- SGMII transceiver clock buffer input
      clk_ds                    : in  std_logic;
      -- MDIO Interface
      -------------------
      mdio_i                    : in  std_logic;
      mdio_o                    : out std_logic;
      mdio_t                    : out std_logic;
      mdc_in                    : in  std_logic;

      -- asynchronous reset
      glbl_rstn                  : in  std_logic;
      rx_axi_rstn                : in  std_logic;
      tx_axi_rstn                : in  std_logic

   );
   end component;

  ------------------------------------------------------------------------------
  -- Component Declaration for the basic pattern generator
  ------------------------------------------------------------------------------

   component basic_pat_gen
   port (
    axi_tclk                    : in  std_logic;
    axi_tresetn                 : in  std_logic;
    check_resetn                : in  std_logic;

    enable_pat_gen              : in  std_logic;
    enable_pat_chk              : in  std_logic;
    enable_address_swap         : in  std_logic;

    -- data from the RX FIFO
    rx_axis_fifo_tdata          : in  std_logic_vector(7 downto 0);
    rx_axis_fifo_tvalid         : in  std_logic;
    rx_axis_fifo_tlast          : in  std_logic;
    rx_axis_fifo_tready         : out std_logic;

    -- data TO the tx fifo
    tx_axis_fifo_tdata          : out std_logic_vector(7 downto 0);
    tx_axis_fifo_tvalid         : out std_logic;
    tx_axis_fifo_tlast          : out std_logic;
    tx_axis_fifo_tready         : in  std_logic;

    frame_error                 : out std_logic
   );
   end component;



  ------------------------------------------------------------------------------
  -- Component declaration for the reset synchroniser
  ------------------------------------------------------------------------------
  component reset_sync
  port (
     reset_in                   : in  std_logic;    -- Active high asynchronous reset
     enable                     : in  std_logic;
     clk                        : in  std_logic;    -- clock to be sync'ed to
     reset_out                  : out std_logic     -- "Synchronised" reset signal
  );
  end component;

  ------------------------------------------------------------------------------
  -- Component declaration for the synchroniser
  ------------------------------------------------------------------------------
  component sync_block
  port (
     clk                        : in  std_logic;
     data_in                    : in  std_logic;
     data_out                   : out std_logic
  );
  end component;

   ------------------------------------------------------------------------------
   -- Constants used in this top level wrapper.
   ------------------------------------------------------------------------------
   constant LOCAL_PHY_ADDR                  : std_logic_vector(7 downto 0)  := "00000001";
   constant BOARD_PHY_ADDR                  : std_logic_vector(7 downto 0)  := "00000111";


   ------------------------------------------------------------------------------
   -- internal signals used in this top level wrapper.
   ------------------------------------------------------------------------------

   -- example design clocks
   signal gtx_clk_bufg                      : std_logic;
   signal s_axi_aclk                        : std_logic;


   signal phy_resetn_int                    : std_logic;
   signal clk_ds                            : std_logic;
   signal clk125_out                        : std_logic;
   signal resetdone                         : std_logic;
   signal resetdone_sync                    : std_logic;

   -- resets (and reset generation)
   signal local_chk_reset                   : std_logic;
   signal chk_reset_int                     : std_logic;
   signal chk_pre_resetn                    : std_logic := '0';
   signal chk_resetn                        : std_logic := '0';
   signal local_gtx_reset                   : std_logic;
   signal gtx_clk_reset_int                 : std_logic;
   signal gtx_pre_resetn                    : std_logic := '0';
   signal gtx_resetn                        : std_logic := '0';
   signal rx_reset                          : std_logic;
   signal tx_reset                          : std_logic;

   signal phy_reset_count                   : unsigned(5 downto 0);
   signal glbl_rst_intn                     : std_logic;

   -- USER side RX AXI-S interface
   signal rx_fifo_clock                     : std_logic;
   signal rx_fifo_resetn                    : std_logic;
   signal rx_axis_fifo_tdata                : std_logic_vector(7 downto 0);
   signal rx_axis_fifo_tvalid               : std_logic;
   signal rx_axis_fifo_tlast                : std_logic;
   signal rx_axis_fifo_tready               : std_logic;

   -- USER side TX AXI-S interface
   signal tx_fifo_clock                     : std_logic;
   signal tx_fifo_resetn                    : std_logic;
   signal tx_axis_fifo_tdata                : std_logic_vector(7 downto 0);
   signal tx_axis_fifo_tvalid               : std_logic;
   signal tx_axis_fifo_tlast                : std_logic;
   signal tx_axis_fifo_tready               : std_logic;

   -- RX Statistics serialisation signals
   signal rx_statistics_valid               : std_logic;
   signal rx_statistics_valid_reg           : std_logic;
   signal rx_statistics_vector              : std_logic_vector(27 downto 0);
   signal rx_stats_shift                    : std_logic_vector(29 downto 0);

   -- TX Statistics serialisation signals
   signal tx_statistics_valid               : std_logic;
   signal tx_statistics_valid_reg           : std_logic;
   signal tx_statistics_vector              : std_logic_vector(31 downto 0);
   signal tx_stats_shift                    : std_logic_vector(33 downto 0);

   -- Pause interface DESerialisation
   signal pause_shift                       : std_logic_vector(17 downto 0);
   signal pause_req                         : std_logic;
   signal pause_val                         : std_logic_vector(15 downto 0);

   signal syncacqstatus_int                 : std_logic;


   -- signal tie offs
   signal tx_ifg_delay                      : std_logic_vector(7 downto 0) := (others => '0');    -- not used in this example
  signal mdio_i                             : std_logic;
  signal mdio_o                             : std_logic;
  signal mdio_t                             : std_logic;
  signal mdc_in_i                           : std_logic;

  signal int_frame_error                    : std_logic;

  attribute keep : string;
  attribute keep of gtx_clk_bufg             : signal is "true";
  attribute keep of clk125_out              : signal is "true";
  attribute keep of rx_statistics_valid      : signal is "true";
  attribute keep of rx_statistics_vector     : signal is "true";
  attribute keep of tx_statistics_valid      : signal is "true";
  attribute keep of tx_statistics_vector     : signal is "true";

  ------------------------------------------------------------------------------
  -- Begin architecture
  ------------------------------------------------------------------------------

begin

   frame_error  <= int_frame_error;
   frame_errorn <= not int_frame_error;

   ------------------------------------------------------------------------------
   -- Infer the IOBUF for MDIO
   ------------------------------------------------------------------------------
   mdio <= 'Z' when mdio_t = '1' else mdio_o;

   mdio_i <= mdio;

   mdio_pu : PULLUP
   port map (
      O                => mdio_i
   );


   -- Prevent XST from automatically adding a BUFG to MDC_IN
   mdc_in_ibuf : IBUF
   port map (
      I                => mdc_in,
      O                => mdc_in_i
   );

   syncacqstatus <= syncacqstatus_int;

  ------------------------------------------------------------------------------
  -- Generate clock logic for the example design
  ------------------------------------------------------------------------------


   -- Generate the clock input to the transceiver
   -- (clk_ds can be shared between multiple EMAC instances, including
   --  multiple instantiations of the EMAC wrappers)
   clkingen : IBUFDS_GTXE1
   port map (
      I                => mgtclk_p,
      IB               => mgtclk_n,
      CEB              => '0',
      O                => clk_ds,
      ODIV2            => open
   );

   -- The 125MHz clock from the transceiver is routed through a BUFG and
   -- input to the MAC wrappers
   -- (clk125 can be shared between multiple EMAC instances, including
   --  multiple instantiations of the EMAC wrappers)
   bufg_clk125 : BUFG
   port map (
      I                => clk125_out,
      O                => gtx_clk_bufg
   );


   -- Generate the axi4-lite clock
   bufg_axi : BUFG
   port map (
      I                => clk125_out,
      O                => s_axi_aclk
   );


   glbl_rst_intn <= not glbl_rst;


   -- generate the user side clocks for the axi fifos
   tx_fifo_clock <= gtx_clk_bufg;
   rx_fifo_clock <= gtx_clk_bufg;

   ------------------------------------------------------------------------------
   -- Generate resets required for the fifo side signals plus axi_lite logic
   ------------------------------------------------------------------------------
   -- in each case the async reset is first captured and then synchronised


   -- synchronise the reset done from the GT
   syncresetdone : sync_block
   port map (
      clk              => gtx_clk_bufg,
      data_in          => resetdone,
      data_out         => resetdone_sync
   );

  local_chk_reset <= glbl_rst or reset_error;

  -----------------
  -- data check reset
   chk_reset_gen : reset_sync
   port map (
       clk              => gtx_clk_bufg,
       enable           => resetdone_sync,
       reset_in         => local_chk_reset,
       reset_out        => chk_reset_int
   );

   -- Create fully synchronous reset in the gtx clock domain.
   gen_chk_reset : process (gtx_clk_bufg)
   begin
     if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
       if chk_reset_int = '1' then
         chk_pre_resetn   <= '0';
         chk_resetn       <= '0';
       else
         chk_pre_resetn   <= '1';
         chk_resetn       <= chk_pre_resetn;
       end if;
     end if;
   end process gen_chk_reset;

  local_gtx_reset <= glbl_rst or rx_reset or tx_reset;

  -----------------
  -- gtx_clk reset
   gtx_reset_gen : reset_sync
   port map (
       clk              => gtx_clk_bufg,
       enable           => resetdone_sync,
       reset_in         => local_gtx_reset,
       reset_out        => gtx_clk_reset_int
   );

   -- Create fully synchronous reset in the s_axi clock domain.
   gen_gtx_reset : process (gtx_clk_bufg)
   begin
     if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
       if gtx_clk_reset_int = '1' then
         gtx_pre_resetn   <= '0';
         gtx_resetn       <= '0';
       else
         gtx_pre_resetn   <= '1';
         gtx_resetn       <= gtx_pre_resetn;
       end if;
     end if;
   end process gen_gtx_reset;


   -----------------
   -- PHY reset
   -- the phy reset output (active low) needs to be held for at least 10x25MHZ cycles
   -- this is derived using the 125MHz available and a 6 bit counter
   gen_phy_reset : process (gtx_clk_bufg)
   begin
     if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
       if glbl_rst_intn = '0' then
         phy_resetn_int       <= '0';
         phy_reset_count      <= (others => '0');
       else
          if phy_reset_count /= "111111" then
             phy_reset_count <= phy_reset_count + "000001";
          else
             phy_resetn_int   <= '1';
          end if;
       end if;
     end if;
   end process gen_phy_reset;

   phy_resetn <= phy_resetn_int;

   -- generate the user side resets for the axi fifos
   tx_fifo_resetn <= gtx_resetn;
   rx_fifo_resetn <= gtx_resetn;

  ------------------------------------------------------------------------------
  -- Serialize the stats vectors
  -- This is a single bit approach, retimed onto gtx_clk
  -- this code is only present to prevent code being stripped..
  ------------------------------------------------------------------------------

  -- RX STATS

   -- when an update is txd load shifter (plus start/stop bit)
   -- shifter always runs (no power concerns as this is an example design)
   gen_shift_rx : process (gtx_clk_bufg)
   begin
      if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
         rx_statistics_valid_reg <= rx_statistics_valid;
         if rx_statistics_valid_reg = '0' and rx_statistics_valid = '1' then
            rx_stats_shift <= '1' & rx_statistics_vector & '1';
         else
            rx_stats_shift <= rx_stats_shift(28 downto 0) & '0';
         end if;
      end if;
   end process gen_shift_rx;

   rx_statistics_s <= rx_stats_shift(29);

  -- TX STATS

   -- when an update is txd load shifter (plus start/stop bit)
   -- shifter always runs (no power concerns as this is an example design)
   gen_shift_tx : process (gtx_clk_bufg)
   begin
      if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
         tx_statistics_valid_reg <= tx_statistics_valid;
         if tx_statistics_valid_reg = '0' and tx_statistics_valid = '1' then
            tx_stats_shift <= '1' & tx_statistics_vector & '1';
         else
            tx_stats_shift <= tx_stats_shift(32 downto 0) & '0';
         end if;
      end if;
   end process gen_shift_tx;

   tx_statistics_s <= tx_stats_shift(33);

  ------------------------------------------------------------------------------
  -- DESerialize the Pause interface
  -- This is a single bit approach timed on gtx_clk
  -- this code is only present to prevent code being stripped..
  ------------------------------------------------------------------------------
  -- the serialized pause info has a start bit followed by the quanta and a stop bit
  -- capture the quanta when the start bit hits the msb and the stop bit is in the lsb
   gen_shift_pause : process (gtx_clk_bufg)
   begin
      if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
         pause_shift <= pause_shift(16 downto 0) & pause_req_s;
      end if;
   end process gen_shift_pause;

   grab_pause : process (gtx_clk_bufg)
   begin
      if gtx_clk_bufg'event and gtx_clk_bufg = '1' then
         if (pause_shift(17) = '1' and pause_shift(0) = '1') then
            pause_req <= '1';
            pause_val <= pause_shift(16 downto 1);
         else
            pause_req <= '0';
            pause_val <= (others => '0');
         end if;
      end if;
   end process grab_pause;


   ------------------------------------------------------------------------------
   -- Instantiate the V6 Hard MAC core FIFO Block wrapper
   ------------------------------------------------------------------------------
   v6emac_fifo_block : v6_emac_v2_3_sgmii_fifo_block
    port map (
      gtx_clk                       => gtx_clk_bufg,
      clk125_out                    => clk125_out,
      -- Receiver Statistics Interface
      -----------------------------------------
      rx_reset                      => rx_reset,
      rx_statistics_vector          => rx_statistics_vector,
      rx_statistics_valid           => rx_statistics_valid,

      -- Receiver => AXI-S Interface
      ------------------------------------------
      rx_fifo_clock                 => rx_fifo_clock,
      rx_fifo_resetn                => rx_fifo_resetn,
      rx_axis_fifo_tdata            => rx_axis_fifo_tdata,
      rx_axis_fifo_tvalid           => rx_axis_fifo_tvalid,
      rx_axis_fifo_tready           => rx_axis_fifo_tready,
      rx_axis_fifo_tlast            => rx_axis_fifo_tlast,

      -- Transmitter Statistics Interface
      --------------------------------------------
      tx_reset                      => tx_reset,
      tx_ifg_delay                  => tx_ifg_delay,
      tx_statistics_vector          => tx_statistics_vector,
      tx_statistics_valid           => tx_statistics_valid,

      -- Transmitter => AXI-S Interface
      ---------------------------------------------
      tx_fifo_clock                 => tx_fifo_clock,
      tx_fifo_resetn                => tx_fifo_resetn,
      tx_axis_fifo_tdata            => tx_axis_fifo_tdata,
      tx_axis_fifo_tvalid           => tx_axis_fifo_tvalid,
      tx_axis_fifo_tready           => tx_axis_fifo_tready,
      tx_axis_fifo_tlast            => tx_axis_fifo_tlast,

      -- MAC Control Interface
      --------------------------
      pause_req                     => pause_req,
      pause_val                     => pause_val,

    -- SGMII interface
      txp                           => txp,
      txn                           => txn,
      rxp                           => rxp,
      rxn                           => rxn,
      phyad                         => LOCAL_PHY_ADDR(4 downto 0),
      resetdone                     => resetdone,
      syncacqstatus                 => syncacqstatus_int,
    -- SGMII transceiver clock buffer input
      clk_ds                        => clk_ds,
      -- MDIO Interface
      -------------------
      mdio_i                        => mdio_i,
      mdio_o                        => mdio_o,
      mdio_t                        => mdio_t,
      mdc_in                        => mdc_in_i,

      -- asynchronous reset
      glbl_rstn                     => glbl_rst_intn,
      rx_axi_rstn                   => '1',
      tx_axi_rstn                   => '1'

   );


  ------------------------------------------------------------------------------
  --  Instantiate the address swapping module and simple pattern generator
  ------------------------------------------------------------------------------
   basic_pat_gen_inst : basic_pat_gen
   port map (
       axi_tclk                     => tx_fifo_clock,
       axi_tresetn                  => tx_fifo_resetn,
       check_resetn                 => chk_resetn,

       enable_pat_gen               => gen_tx_data,
       enable_pat_chk               => chk_tx_data,
       enable_address_swap          => swap_address,

       rx_axis_fifo_tdata           => rx_axis_fifo_tdata,
       rx_axis_fifo_tvalid          => rx_axis_fifo_tvalid,
       rx_axis_fifo_tlast           => rx_axis_fifo_tlast,
       rx_axis_fifo_tready          => rx_axis_fifo_tready,

       tx_axis_fifo_tdata           => tx_axis_fifo_tdata,
       tx_axis_fifo_tvalid          => tx_axis_fifo_tvalid,
       tx_axis_fifo_tlast           => tx_axis_fifo_tlast,
       tx_axis_fifo_tready          => tx_axis_fifo_tready,

       frame_error                  => int_frame_error
   );

end wrapper;
