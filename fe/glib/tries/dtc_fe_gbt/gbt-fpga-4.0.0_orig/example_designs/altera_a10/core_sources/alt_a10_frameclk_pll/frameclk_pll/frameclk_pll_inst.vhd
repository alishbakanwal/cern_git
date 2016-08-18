	component frameclk_pll is
		port (
			cntsel           : in  std_logic_vector(4 downto 0) := (others => 'X'); -- cntsel
			locked           : out std_logic;                                       -- export
			num_phase_shifts : in  std_logic_vector(2 downto 0) := (others => 'X'); -- num_phase_shifts
			outclk_0         : out std_logic;                                       -- clk
			phase_done       : out std_logic;                                       -- phase_done
			phase_en         : in  std_logic                    := 'X';             -- phase_en
			refclk           : in  std_logic                    := 'X';             -- clk
			rst              : in  std_logic                    := 'X';             -- reset
			scanclk          : in  std_logic                    := 'X';             -- scanclk
			updn             : in  std_logic                    := 'X'              -- updn
		);
	end component frameclk_pll;

	u0 : component frameclk_pll
		port map (
			cntsel           => CONNECTED_TO_cntsel,           --           cntsel.cntsel
			locked           => CONNECTED_TO_locked,           --           locked.export
			num_phase_shifts => CONNECTED_TO_num_phase_shifts, -- num_phase_shifts.num_phase_shifts
			outclk_0         => CONNECTED_TO_outclk_0,         --          outclk0.clk
			phase_done       => CONNECTED_TO_phase_done,       --       phase_done.phase_done
			phase_en         => CONNECTED_TO_phase_en,         --         phase_en.phase_en
			refclk           => CONNECTED_TO_refclk,           --           refclk.clk
			rst              => CONNECTED_TO_rst,              --            reset.reset
			scanclk          => CONNECTED_TO_scanclk,          --          scanclk.scanclk
			updn             => CONNECTED_TO_updn              --             updn.updn
		);

