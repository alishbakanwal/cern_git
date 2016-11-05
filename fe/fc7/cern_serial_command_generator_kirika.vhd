--===========================--
-- serial_command_generator 
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

entity serial_command_generator is
    port (
    clk_320MHz                   : in  std_logic;
    clk_40MHz                    : in  std_logic;
    ext_async_l1a                : in  std_logic;
    fmc_cbc_fast_signal_40MHz    : in  std_logic_vector(3 downto 0);
    ipb_ctrl                     : in  serial_command_generator_ctrl_type;
    ipb_cnfg                     : in  serial_command_generator_cnfg_type;
    serial_command               : out std_logic;      
    ipb_stat                     : out serial_command_generator_stat_type;
    l1a_320MHz                   : out std_logic;
    l1a_tdccount                 : out std_logic_vector(2 downto 0)
);
end serial_command_generator;

architecture Behavioral of serial_command_generator is

    signal ext_sync_l1a             : std_logic;
    signal ext_async_l1a_tdccount   : std_logic_vector(2 downto 0);
    signal ext_l1a_signal_40MHz     : std_logic_vector(3 downto 0);

    type trigger_fsm_type is (idle, running);
    signal trigger_fsm              : trigger_fsm_type;

    signal int_cbc_fast_signal_40MHz: std_logic_vector(3 downto 0);

    signal fast_signal_40MHz        : std_logic_vector(3 downto 0);

    signal l1a_40MHz                : std_logic;

	signal clk40_shift_reg 			: std_logic_vector( 1 downto 0 );
    signal flip_40mhz               : std_logic;
    signal clk40_edge               : std_logic;
    signal ext_input                : std_logic;
    signal header                   : std_logic_vector( 2 downto 0 ) := "110";
    signal trailer                  : std_logic := '1';
    signal index                    : unsigned(2 downto 0);
    signal cbc_fast_signal_40MHz    : std_logic_vector(3 downto 0);
    signal cbc_fast_signal_latched  : std_logic_vector(3 downto 0);
    signal fsm                      : serial_command_generator_fsm_type;
begin

	tdc : entity work.l1a_tdc
    Port map(   reset           => ipb_ctrl.reset,
                clk40           => clk_40MHz,
                clk320          => clk_320MHz,
                l1a_nosync      => ext_async_l1a,
                l1a_o           => ext_sync_l1a,
                l1a_tdccount_o  => ext_async_l1a_tdccount
             );


    process( clk_40MHz )
    begin
        for i in 0 to 3 loop
            if i = fast_signal_40MHz_indices.trigger then
                ext_l1a_signal_40MHz(i) <= ext_sync_l1a;
                l1a_tdccount <= ext_async_l1a_tdccount;
            else
                ext_l1a_signal_40MHz(i) <= '0';
            end if;
        end loop;
    end process;

    cbc_fast_signal_40MHz_gen:
    for i in 0 to 3 generate
        cbc_fast_signal_40MHz(i) <=     (fmc_cbc_fast_signal_40MHz(i)     and ipb_cnfg.fast_signal_fmc_en) 
                                     or (ipb_ctrl.cbc_fast_signal(i)      and ipb_cnfg.fast_signal_ipbus_en) 
                                     or (int_cbc_fast_signal_40MHz(i)     and ipb_cnfg.fast_signal_internal_en)
                                     or (ext_l1a_signal_40MHz(i)          and ipb_cnfg.ext_async_l1a_en);
    end generate;

   process( clk_320MHz )
    begin
        if ipb_ctrl.reset = '1' then
            trigger_fsm   <= idle;           
        elsif rising_edge( clk_320MHz ) then
            case trigger_fsm is
                when idle =>
                    if ipb_ctrl.start_trigger = '1' then
                        trigger_fsm <= running;
                    end if;
                when running =>
                    if ipb_ctrl.stop_trigger = '1' then
                        trigger_fsm <= idle;
                    end if;
            end case;
        end if;
    end process; 
 
    
    l1a_40MHz <= cbc_fast_signal_40MHz(fast_signal_40MHz_indices.trigger) when trigger_fsm = running else '0';
    l1a_320MHz_gen : entity work.dff_sync_edge_detect port map(reset => ipb_ctrl.reset, clkb => clk_320MHz, dina => l1a_40MHz, doutb => l1a_320MHz);
   
    process( clk_320MHz )
    begin
        if ipb_ctrl.reset = '1' then
            serial_command <= '0';
            index <= ( others => '0' );
            fsm   <= init;
            
        elsif rising_edge( clk_320MHz ) then
            case fsm is
                when init =>
                    clk40_shift_reg <= clk40_shift_reg(0) & flip_40mhz;   
                    if clk40_edge = '1' then
                        index <= "011";
                        fsm <= running;
                    end if;
                when running =>
                    if index = "001" then
                        cbc_fast_signal_latched <= cbc_fast_signal_40MHz;
                        if trigger_fsm /= running then
                            cbc_fast_signal_latched(fast_signal_40MHz_indices.trigger) <= '0';
                        end if;
                    end if; 
                    index <= index + 1;
                    
                    case index is  
                        when to_unsigned(7,3) =>
                            serial_command <= header(2);
                        when to_unsigned(0,3) =>                       
                            serial_command <= header(1);
                        when to_unsigned(1,3) =>                   
                            serial_command <= header(0);
                        when to_unsigned(2,3) =>
                            serial_command <= cbc_fast_signal_latched(3);
                        when to_unsigned(3,3) =>
                            serial_command <= cbc_fast_signal_latched(2);
                        when to_unsigned(4,3) =>
                            serial_command <= cbc_fast_signal_latched(1);                                                                  
                        when to_unsigned(5,3) =>                
                            serial_command <= cbc_fast_signal_latched(0);
                        when to_unsigned(6,3) =>                
                            serial_command <= trailer;
                    end case;                                                                                                      
            end case;
        end if;
    end process;

    clk40_edge <= not clk40_shift_reg(1) and clk40_shift_reg(0);
-- This does not work for 320MHz clock signals. 
    --    cbc_fast_signal <= header(2)                  when index = to_unsigned(0,3) else
    --                       header(1)                  when index = to_unsigned(1,3) else
    --                       header(0)                  when index = to_unsigned(2,3) else
    --                       cbc_fast_signal_latched(3) when index = to_unsigned(3,3) else
    --                       cbc_fast_signal_latched(2) when index = to_unsigned(4,3) else
    --                       cbc_fast_signal_latched(1) when index = to_unsigned(5,3) else
    --                       cbc_fast_signal_latched(0) when index = to_unsigned(6,3) else
    --                       trailer                    when index = to_unsigned(7,3);

    process ( ipb_ctrl.reset, clk_40MHz )
    begin
    --    if reset = '1' then    
    
    --    else
       if rising_edge( clk_40MHz ) then
    
         flip_40mhz <= not flip_40mhz;
    
       end if;
    --    end if;
    end process;

--	comm_cycle_reset <= ipb_cbc_system_ctrl.comm_cycle.reset or ipb_cbc_system_ctrl.global.reset;
    fast_signal_generator_inst : entity work.fast_signal_generator
    port map(
        clk                      => clk_40MHz,
        reset                    => ipb_ctrl.fast_signal_generator.reset,
        load_cnfg                => ipb_ctrl.fast_signal_generator.load_cnfg,            
        start                    => ipb_ctrl.fast_signal_generator.start,
        stop                     => ipb_ctrl.fast_signal_generator.stop,
        Ncycle_i                 => ipb_cnfg.fast_signal_generator.Ncycle,
        fast_reset_en_i          => ipb_cnfg.fast_signal_generator.fast_reset_en,
        test_pulse_en_i          => ipb_cnfg.fast_signal_generator.test_pulse_en,
        trigger_en_i             => ipb_cnfg.fast_signal_generator.trigger_en,
        orbit_reset_en_i         => ipb_cnfg.fast_signal_generator.orbit_reset_en,
        cycle_T_i                => ipb_cnfg.fast_signal_generator.cycle_T,
        test_pulse_t_i           => ipb_cnfg.fast_signal_generator.test_pulse_t,
        trigger_t_i              => ipb_cnfg.fast_signal_generator.trigger_t,
        orbit_reset_t_i          => ipb_cnfg.fast_signal_generator.orbit_reset_t,
        fast_signal_40MHz        => int_cbc_fast_signal_40MHz,
        fsm_o                    => ipb_stat.fast_signal_generator_fsm
    );    
   
--    signal_valid <= '0' when fsm = init else
--                    '1' when fsm = running;
                        
end Behavioral;
