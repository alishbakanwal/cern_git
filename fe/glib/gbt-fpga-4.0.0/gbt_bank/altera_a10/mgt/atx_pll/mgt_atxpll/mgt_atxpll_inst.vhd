	component mgt_atxpll is
		port (
			mcgb_rst          : in  std_logic                    := 'X'; -- mcgb_rst
			pll_cal_busy      : out std_logic;                           -- pll_cal_busy
			pll_locked        : out std_logic;                           -- pll_locked
			pll_powerdown     : in  std_logic                    := 'X'; -- pll_powerdown
			pll_refclk0       : in  std_logic                    := 'X'; -- clk
			tx_bonding_clocks : out std_logic_vector(5 downto 0);        -- clk
			tx_serial_clk     : out std_logic                            -- clk
		);
	end component mgt_atxpll;

	u0 : component mgt_atxpll
		port map (
			mcgb_rst          => CONNECTED_TO_mcgb_rst,          --          mcgb_rst.mcgb_rst
			pll_cal_busy      => CONNECTED_TO_pll_cal_busy,      --      pll_cal_busy.pll_cal_busy
			pll_locked        => CONNECTED_TO_pll_locked,        --        pll_locked.pll_locked
			pll_powerdown     => CONNECTED_TO_pll_powerdown,     --     pll_powerdown.pll_powerdown
			pll_refclk0       => CONNECTED_TO_pll_refclk0,       --       pll_refclk0.clk
			tx_bonding_clocks => CONNECTED_TO_tx_bonding_clocks, -- tx_bonding_clocks.clk
			tx_serial_clk     => CONNECTED_TO_tx_serial_clk      --     tx_serial_clk.clk
		);

