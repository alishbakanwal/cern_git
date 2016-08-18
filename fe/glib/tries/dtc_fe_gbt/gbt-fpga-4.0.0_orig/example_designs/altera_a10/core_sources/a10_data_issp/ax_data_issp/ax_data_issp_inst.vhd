	component ax_data_issp is
		port (
			source : out std_logic_vector(202 downto 0);                    -- source
			probe  : in  std_logic_vector(200 downto 0) := (others => 'X')  -- probe
		);
	end component ax_data_issp;

	u0 : component ax_data_issp
		port map (
			source => CONNECTED_TO_source, -- sources.source
			probe  => CONNECTED_TO_probe   --  probes.probe
		);

