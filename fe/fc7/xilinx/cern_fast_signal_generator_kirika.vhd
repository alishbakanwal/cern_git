--===========================--
-- fast_signal_generator 
-- 28.10.2016 Kirika Uchida
--===========================--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
use work.cbc_system_package.all;

entity fast_signal_generator is
generic( COUNTER_WIDTH : natural := 32 );
port (	clk					: in std_logic;
        reset               : in std_logic;
        load_cnfg           : in std_logic;
		start				: in std_logic;
		stop				: in std_logic;
		Ncycle_i			: in std_logic_vector( 31 downto 0 );
		fast_reset_en_i		: in std_logic;
		test_pulse_en_i		: in std_logic;
		trigger_en_i		: in std_logic;
		orbit_reset_en_i    : in std_logic;
		cycle_T_i			: in std_logic_vector( COUNTER_WIDTH-1 downto 0 );
		test_pulse_t_i 		: in std_logic_vector( COUNTER_WIDTH-1 downto 0 );
		trigger_t_i			: in std_logic_vector( COUNTER_WIDTH-1 downto 0 );
		orbit_reset_t_i		: in std_logic_vector( COUNTER_WIDTH-1 downto 0 );
		fast_signal_40MHz		: out std_logic_vector( 3 downto 0 );
		fsm_o					: out fast_signal_generator_fsm_type
);
end fast_signal_generator;

architecture Behavioral of fast_signal_generator is

    signal fsm					    : fast_signal_generator_fsm_type;
    signal fast_reset               : std_logic;
    signal test_pulse               : std_logic;
    signal trigger                  : std_logic;
    signal orbit_reset              : std_logic;
    signal cycle_T_ui               : unsigned( COUNTER_WIDTH-1 downto 0 );
    signal test_pulse_t_ui          : unsigned( COUNTER_WIDTH-1 downto 0 );
    signal trigger_t_ui             : unsigned( COUNTER_WIDTH-1 downto 0 );    
    signal orbit_reset_t_ui         : unsigned( COUNTER_WIDTH-1 downto 0 );    
    signal cycle_count              : unsigned( 31 downto 0 ) := (others => '0' );
    
    signal Ncycle                   : std_logic_vector( 31 downto 0 ) := (others => '0' );
    signal fast_reset_en            : std_logic := '0';
    signal test_pulse_en            : std_logic := '0';
    signal trigger_en               : std_logic := '0';
    signal orbit_reset_en           : std_logic := '0';    
    signal cycle_T                  : std_logic_vector( COUNTER_WIDTH-1 downto 0 ) := (others => '0' );
    signal test_pulse_t             : std_logic_vector( COUNTER_WIDTH-1 downto 0 ) := (others => '0' );
    signal trigger_t                : std_logic_vector( COUNTER_WIDTH-1 downto 0 ) := (others => '0' );
    signal orbit_reset_t            : std_logic_vector( COUNTER_WIDTH-1 downto 0 ) := (others => '0' );
	 

    
begin
	process( clk )
    variable counter : integer;
    begin
        if reset = '1' then
             cycle_count        <= ( others => '0' );
            fast_reset        <= '0';
            test_pulse        <= '0';
            trigger           <= '0';
            orbit_reset       <= '0';
            counter           := 0;
            Ncycle            <= Ncycle_i;
            fast_reset_en     <= '1';
            test_pulse_en     <= '1';
            trigger_en        <= '1';
            orbit_reset_en    <= '1';
            cycle_T           <= std_logic_vector(to_unsigned( 5, COUNTER_WIDTH ) );
            test_pulse_t      <= std_logic_vector(to_unsigned( 1, COUNTER_WIDTH ) );
            trigger_t         <= std_logic_vector(to_unsigned( 2, COUNTER_WIDTH ) );        
            orbit_reset_t     <= std_logic_vector(to_unsigned( 3, COUNTER_WIDTH ) );                
            fsm             <= idle;           
    
        elsif load_cnfg = '1' then
            cycle_count        <= ( others => '0' );
            fast_reset         <= '0';
            test_pulse         <= '0';
            trigger            <= '0';
            orbit_reset     <= '0';
            counter            := 0;
            Ncycle            <= Ncycle_i;
            fast_reset_en     <= fast_reset_en_i;
            test_pulse_en     <= test_pulse_en_i;
            trigger_en         <= trigger_en_i;
            orbit_reset_en     <= orbit_reset_en_i;
            cycle_T         <= cycle_T_i;
            test_pulse_t     <= test_pulse_t_i;
            trigger_t         <= trigger_t_i;        
            orbit_reset_t   <= orbit_reset_t_i;                
            fsm             <= idle;
            
        elsif rising_edge( clk ) then
    
            fast_reset     <= '0';
            test_pulse     <= '0';
            trigger        <= '0';
            orbit_reset <= '0';    
        case fsm is
            when idle =>
                cycle_count <= ( others => '0' );
                counter        := 0;    
                if start = '1' then
                    fsm    <= running;
                    cycle_count <= cycle_count + 1;
                    fast_reset <= '1';
                end if;
            when running =>
                
                if stop = '1' then
                 fsm <= idle;
                end if;
                
                if counter = 0 then
                    fast_reset     <= '1';
                elsif counter = to_integer( test_pulse_t_ui ) then
                    test_pulse     <= '1';
                elsif counter = to_integer( trigger_t_ui ) then
                    trigger        <= '1';
                elsif counter = to_integer( orbit_reset_t_ui ) then
                    orbit_reset <= '1';
                end if;
    
                counter := counter + 1;
                if counter >= to_integer( cycle_T_ui ) then
                    counter := 0;
                    cycle_count <= cycle_count + 1;
                    if cycle_count = unsigned( Ncycle ) and to_integer(cycle_count) /= 0 then
                        fsm <= idle;
                    end if;
    
                end if;
                
            end case;
        end if;
    end process;
    
    cycle_T_ui            <= unsigned(cycle_T);
    test_pulse_t_ui        <= unsigned(test_pulse_t);
    trigger_t_ui        <= unsigned(trigger_t);
    orbit_reset_t_ui    <= unsigned(orbit_reset_t);
    
    fast_signal_40MHz(3)     <= fast_reset     when fast_reset_en     = '1' else '0';
    fast_signal_40MHz(2)    <= trigger         when trigger_en     = '1' else '0';
    fast_signal_40MHz(1)    <= test_pulse     when test_pulse_en     = '1' else '0';
    fast_signal_40MHz(0)    <= orbit_reset    when orbit_reset_en    = '1' else '0';
    
    fsm_o <= fsm;



    
end Behavioral;
