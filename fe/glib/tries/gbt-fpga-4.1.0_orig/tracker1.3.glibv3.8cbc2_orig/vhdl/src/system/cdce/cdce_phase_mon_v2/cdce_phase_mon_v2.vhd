library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library unisim;
use unisim.vcomponents.all;

entity cdce_phase_mon_v2 is
port
	(
	rst_i					         : in  std_logic;
	-- inputs --         
	ipbus_clk_i                : in  std_logic;
   ttclk_x6_i  				   : in  std_logic;
	ttclk_x6_cdce_i		      : in  std_logic;
	unrelated_clk_i		      : in  std_logic;
	-- settings --       
	threshold_upper_i		      : in  std_logic_vector(7 downto 0);
	threshold_lower_i		      : in  std_logic_vector(7 downto 0);
	-- debug outputs --
	debug_test_d_clk_o			: out std_logic;
	debug_test_d_clk_cdce_o	   : out std_logic;
	debug_test_xor_o				: out std_logic;
	debug_test_xor_mclk_o		: out std_logic;
	debug_monitoring_stats_o	: out std_logic_vector(15 downto 0);
	-- status --   
	monitoring_stats_o	      : out std_logic_vector(15 downto 0);
   done_o					      : out std_logic;	
	phase_ok_o				      : out std_logic
	);
end cdce_phase_mon_v2;
architecture rtl of cdce_phase_mon_v2 is

attribute keep                : string;

signal mclk				         : std_logic;
	
signal test_d_clk             : std_logic;
signal test_d_clk_cdce       	: std_logic;
signal test_xor			      : std_logic;
signal test_xor_mclk	         : std_logic;

signal threshold_upper		   : std_logic_vector(7 downto 0);
signal threshold_lower	   	: std_logic_vector(7 downto 0);

signal monitoring_stats		   : std_logic_vector(15 downto 0);
signal done	                  : std_logic;
signal phase_ok               : std_logic;


begin


-----------------------------------
-- comparison stage
-----------------------------------

ttclk_x6_ffd: FDCE
   generic map (
      INIT                    => '0') 
   port map (           
      Q                       => test_d_clk,   
      C                       => ttclk_x6_i,   
      CE                      => '1',  
      CLR                     => '0', 
      D                       => unrelated_clk_i    
   ); 
   
ttclk_x6_cdce_ffd: FDCE 
   generic map (  
      INIT                    => '0') 
   port map (  
      Q                       => test_d_clk_cdce,   
      C                       => ttclk_x6_cdce_i,   
      CE                      => '1',  
      CLR                     => '0', 
      D                       => unrelated_clk_i    
   );

test_xor 				         <= test_d_clk xor test_d_clk_cdce;

-----------------------------------
-- processing stage
-----------------------------------

mclk <= ttclk_x6_i;

xor_ffd: FDCE
   generic map (
      INIT                    => '0') 
   port map (           
      Q                       => test_xor_mclk,   
      C                       => mclk,   
      CE                      => '1',  
      CLR                     => '0', 
      D                       => test_xor    
   ); 

process (rst_i, mclk)
	variable timer : integer range 0 to 65536;
begin
   if rst_i='1' then
      timer 			         := 65536;
      monitoring_stats        <= (others => '0');
      done                    <= '0';
      phase_ok                <= '0';
   elsif rising_edge(mclk) then      
      if timer/=0 then
         done                 <= '0';
         if test_xor_mclk = '1' then
            monitoring_stats	<= monitoring_stats+1;
         end if;
         timer                := timer-1;
      else
         done                 <= '1';
      end if;	

      phase_ok                <= '0';
      if done = '1' then         
         if monitoring_stats(15 downto 8) < threshold_upper and            
            monitoring_stats(15 downto 8) > threshold_lower            
         then
            phase_ok          <= '1';
         end if;         
      end if;      
end if;
end process;

debug_test_d_clk_o			   <= test_d_clk;
debug_test_d_clk_cdce_o       <= test_d_clk_cdce;
debug_test_xor_o				   <= test_xor;
debug_test_xor_mclk_o			<= test_xor_mclk;
debug_monitoring_stats_o		<= monitoring_stats;

-----------------------------------
-- clock domain crossing (CDC)
-----------------------------------

ctrl_dpram: entity work.ttclk_distributed_dpram
   port map (
      a                       => (others => '0'),
      d( 7 downto  0)         => threshold_upper_i,
      d(15 downto  8)         => threshold_lower_i,
      d(31 downto 16)         => (others => '0'),
      dpra                    => (others => '0'),    
      clk                     => ipbus_clk_i,
      we                      => '1',
      qdpo_clk                => mclk,
      qdpo( 7 downto  0)      => threshold_upper,
      qdpo(15 downto  8)      => threshold_lower,
      qdpo(31 downto 16)      => open
   );

status_dpram: entity work.ttclk_distributed_dpram
   port map (
      a                       => (others => '0'),
      d(15 downto  0)         => monitoring_stats,
      d(16)                   => done,
      d(17)                   => phase_ok,
      d(31 downto 18)         => (others => '0'),
      dpra                    => (others => '0'),    
      clk                     => mclk,
      we                      => '1',
      qdpo_clk                => ipbus_clk_i,
      qdpo(15 downto  0)      => monitoring_stats_o,
      qdpo(16)                => done_o,
      qdpo(17)                => phase_ok_o,
      qdpo(31 downto 18)      => open
   );

end rtl;
