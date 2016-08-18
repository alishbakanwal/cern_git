	component alt_a10_lpm_shiftreg is
		port (
			clock    : in  std_logic := 'X'; -- clock
			shiftin  : in  std_logic := 'X'; -- shiftin
			shiftout : out std_logic         -- shiftout
		);
	end component alt_a10_lpm_shiftreg;

	u0 : component alt_a10_lpm_shiftreg
		port map (
			clock    => CONNECTED_TO_clock,    --  lpm_shiftreg_input.clock
			shiftin  => CONNECTED_TO_shiftin,  --                    .shiftin
			shiftout => CONNECTED_TO_shiftout  -- lpm_shiftreg_output.shiftout
		);

