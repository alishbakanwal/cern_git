	component alt_sv_issp_gbtBank2 is
		port (
			source     : out std_logic_vector(8 downto 0);                     -- source
			source_ena : in  std_logic                     := 'X';             -- source_ena
			probe      : in  std_logic_vector(19 downto 0) := (others => 'X'); -- probe
			source_clk : in  std_logic                     := 'X'              -- clk
		);
	end component alt_sv_issp_gbtBank2;

	u0 : component alt_sv_issp_gbtBank2
		port map (
			source     => CONNECTED_TO_source,     --    sources.source
			source_ena => CONNECTED_TO_source_ena, --           .source_ena
			probe      => CONNECTED_TO_probe,      --     probes.probe
			source_clk => CONNECTED_TO_source_clk  -- source_clk.clk
		);

