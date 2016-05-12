	component gx_latopt_x2 is
		port (
			tx_analogreset          : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- tx_analogreset
			tx_digitalreset         : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- tx_digitalreset
			rx_analogreset          : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rx_analogreset
			rx_digitalreset         : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rx_digitalreset
			tx_cal_busy             : out std_logic_vector(1 downto 0);                      -- tx_cal_busy
			rx_cal_busy             : out std_logic_vector(1 downto 0);                      -- rx_cal_busy
			rx_cdr_refclk0          : in  std_logic                      := 'X';             -- clk
			tx_serial_data          : out std_logic_vector(1 downto 0);                      -- tx_serial_data
			rx_serial_data          : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rx_serial_data
			rx_is_lockedtoref       : out std_logic_vector(1 downto 0);                      -- rx_is_lockedtoref
			rx_is_lockedtodata      : out std_logic_vector(1 downto 0);                      -- rx_is_lockedtodata
			tx_coreclkin            : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- clk
			rx_coreclkin            : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- clk
			tx_clkout               : out std_logic_vector(1 downto 0);                      -- clk
			rx_clkout               : out std_logic_vector(1 downto 0);                      -- clk
			tx_parallel_data        : in  std_logic_vector(39 downto 0)  := (others => 'X'); -- tx_parallel_data
			rx_parallel_data        : out std_logic_vector(39 downto 0);                     -- rx_parallel_data
			unused_tx_parallel_data : in  std_logic_vector(215 downto 0) := (others => 'X'); -- unused_tx_parallel_data
			unused_rx_parallel_data : out std_logic_vector(215 downto 0);                    -- unused_rx_parallel_data
			tx_bonding_clocks       : in  std_logic_vector(11 downto 0)  := (others => 'X'); -- clk
			rx_seriallpbken         : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rx_seriallpbken
			rx_pma_clkslip          : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rx_pma_clkslip
			rx_polinv               : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- rx_polinv
			tx_polinv               : in  std_logic_vector(1 downto 0)   := (others => 'X'); -- tx_polinv
			reconfig_clk            : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- clk
			reconfig_reset          : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- reset
			reconfig_write          : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- write
			reconfig_read           : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- read
			reconfig_address        : in  std_logic_vector(10 downto 0)  := (others => 'X'); -- address
			reconfig_writedata      : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- writedata
			reconfig_readdata       : out std_logic_vector(31 downto 0);                     -- readdata
			reconfig_waitrequest    : out std_logic_vector(0 downto 0)                       -- waitrequest
		);
	end component gx_latopt_x2;

	u0 : component gx_latopt_x2
		port map (
			tx_analogreset          => CONNECTED_TO_tx_analogreset,          --          tx_analogreset.tx_analogreset
			tx_digitalreset         => CONNECTED_TO_tx_digitalreset,         --         tx_digitalreset.tx_digitalreset
			rx_analogreset          => CONNECTED_TO_rx_analogreset,          --          rx_analogreset.rx_analogreset
			rx_digitalreset         => CONNECTED_TO_rx_digitalreset,         --         rx_digitalreset.rx_digitalreset
			tx_cal_busy             => CONNECTED_TO_tx_cal_busy,             --             tx_cal_busy.tx_cal_busy
			rx_cal_busy             => CONNECTED_TO_rx_cal_busy,             --             rx_cal_busy.rx_cal_busy
			rx_cdr_refclk0          => CONNECTED_TO_rx_cdr_refclk0,          --          rx_cdr_refclk0.clk
			tx_serial_data          => CONNECTED_TO_tx_serial_data,          --          tx_serial_data.tx_serial_data
			rx_serial_data          => CONNECTED_TO_rx_serial_data,          --          rx_serial_data.rx_serial_data
			rx_is_lockedtoref       => CONNECTED_TO_rx_is_lockedtoref,       --       rx_is_lockedtoref.rx_is_lockedtoref
			rx_is_lockedtodata      => CONNECTED_TO_rx_is_lockedtodata,      --      rx_is_lockedtodata.rx_is_lockedtodata
			tx_coreclkin            => CONNECTED_TO_tx_coreclkin,            --            tx_coreclkin.clk
			rx_coreclkin            => CONNECTED_TO_rx_coreclkin,            --            rx_coreclkin.clk
			tx_clkout               => CONNECTED_TO_tx_clkout,               --               tx_clkout.clk
			rx_clkout               => CONNECTED_TO_rx_clkout,               --               rx_clkout.clk
			tx_parallel_data        => CONNECTED_TO_tx_parallel_data,        --        tx_parallel_data.tx_parallel_data
			rx_parallel_data        => CONNECTED_TO_rx_parallel_data,        --        rx_parallel_data.rx_parallel_data
			unused_tx_parallel_data => CONNECTED_TO_unused_tx_parallel_data, -- unused_tx_parallel_data.unused_tx_parallel_data
			unused_rx_parallel_data => CONNECTED_TO_unused_rx_parallel_data, -- unused_rx_parallel_data.unused_rx_parallel_data
			tx_bonding_clocks       => CONNECTED_TO_tx_bonding_clocks,       --       tx_bonding_clocks.clk
			rx_seriallpbken         => CONNECTED_TO_rx_seriallpbken,         --         rx_seriallpbken.rx_seriallpbken
			rx_pma_clkslip          => CONNECTED_TO_rx_pma_clkslip,          --          rx_pma_clkslip.rx_pma_clkslip
			rx_polinv               => CONNECTED_TO_rx_polinv,               --               rx_polinv.rx_polinv
			tx_polinv               => CONNECTED_TO_tx_polinv,               --               tx_polinv.tx_polinv
			reconfig_clk            => CONNECTED_TO_reconfig_clk,            --            reconfig_clk.clk
			reconfig_reset          => CONNECTED_TO_reconfig_reset,          --          reconfig_reset.reset
			reconfig_write          => CONNECTED_TO_reconfig_write,          --           reconfig_avmm.write
			reconfig_read           => CONNECTED_TO_reconfig_read,           --                        .read
			reconfig_address        => CONNECTED_TO_reconfig_address,        --                        .address
			reconfig_writedata      => CONNECTED_TO_reconfig_writedata,      --                        .writedata
			reconfig_readdata       => CONNECTED_TO_reconfig_readdata,       --                        .readdata
			reconfig_waitrequest    => CONNECTED_TO_reconfig_waitrequest     --                        .waitrequest
		);

