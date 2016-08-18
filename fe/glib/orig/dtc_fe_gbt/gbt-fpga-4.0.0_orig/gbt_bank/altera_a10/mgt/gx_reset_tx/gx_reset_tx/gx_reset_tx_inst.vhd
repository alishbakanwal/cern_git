	component gx_reset_tx is
		port (
			clock           : in  std_logic                    := 'X';             -- clk
			pll_locked      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- pll_locked
			pll_select      : in  std_logic_vector(0 downto 0) := (others => 'X'); -- pll_select
			reset           : in  std_logic                    := 'X';             -- reset
			tx_analogreset  : out std_logic_vector(0 downto 0);                    -- tx_analogreset
			tx_cal_busy     : in  std_logic_vector(0 downto 0) := (others => 'X'); -- tx_cal_busy
			tx_digitalreset : out std_logic_vector(0 downto 0);                    -- tx_digitalreset
			tx_ready        : out std_logic_vector(0 downto 0)                     -- tx_ready
		);
	end component gx_reset_tx;

	u0 : component gx_reset_tx
		port map (
			clock           => CONNECTED_TO_clock,           --           clock.clk
			pll_locked      => CONNECTED_TO_pll_locked,      --      pll_locked.pll_locked
			pll_select      => CONNECTED_TO_pll_select,      --      pll_select.pll_select
			reset           => CONNECTED_TO_reset,           --           reset.reset
			tx_analogreset  => CONNECTED_TO_tx_analogreset,  --  tx_analogreset.tx_analogreset
			tx_cal_busy     => CONNECTED_TO_tx_cal_busy,     --     tx_cal_busy.tx_cal_busy
			tx_digitalreset => CONNECTED_TO_tx_digitalreset, -- tx_digitalreset.tx_digitalreset
			tx_ready        => CONNECTED_TO_tx_ready         --        tx_ready.tx_ready
		);

