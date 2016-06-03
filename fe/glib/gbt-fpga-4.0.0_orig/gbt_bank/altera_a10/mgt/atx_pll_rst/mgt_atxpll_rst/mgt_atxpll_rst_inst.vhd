	component mgt_atxpll_rst is
		port (
			clock         : in  std_logic                    := 'X'; -- clk
			pll_powerdown : out std_logic_vector(0 downto 0);        -- pll_powerdown
			reset         : in  std_logic                    := 'X'  -- reset
		);
	end component mgt_atxpll_rst;

	u0 : component mgt_atxpll_rst
		port map (
			clock         => CONNECTED_TO_clock,         --         clock.clk
			pll_powerdown => CONNECTED_TO_pll_powerdown, -- pll_powerdown.pll_powerdown
			reset         => CONNECTED_TO_reset          --         reset.reset
		);

