
-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity amc40_gbt_example_design is   
   port (   
      
      --===============--
      -- General reset --
      --===============--      
     
      SYS_RESET_N                                             : in  std_logic; 
    
      --===============--
      -- Clocks scheme --
      --===============--
      
      -- MGT(GX) clock:
      -----------------
      
      MAIN_CLOCK_SEL                                          : out std_logic;  
      --------------------------------------------------------
      REF_CLOCK_L4                                            : in  std_logic;   -- Comment:  (LHC PLL 120MHz)
      SYS_CLK_40MHz														  : in  std_logic;
		
      --==============--
      -- Serial lanes --
      --==============--
      
      -- GBT Bank 1:
      --------------
		
      GBTBANK_TX                                           		: out std_logic_vector(0 downto 0);
      GBTBANK_RX                                           		: in  std_logic_vector(0 downto 0);
		
      --====================--
      -- Signals forwarding --
      --====================--
      
      -- Pattern match flags:
      -----------------------
      
      -- GBT Bank 1:
      RTM_TX_1_P                                              : out std_logic;
      RTM_TX_1_N                                              : out std_logic;
      
      RTM_TX_2_P                                              : out std_logic;
      RTM_TX_2_N                                              : out std_logic
      
      -- Clocks forwarding:
      ---------------------
      --AMC_CLOCK_OUT                                         : out std_logic;      
   );
end amc40_gbt_example_design;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of amc40_gbt_example_design is
   --=====================================================================================--  
	component gbt_qsys is
		port (
			avmmclk_clk                 : in  std_logic                     := 'X';             -- clk
			frameclk_1_clk              : in  std_logic                     := 'X';             -- clk
			rx_gbt_1_data               : out std_logic_vector(83 downto 0);                    -- data
			rx_gbt_1_valid              : out std_logic;                                        -- valid
			serialintf_serial_rx_input  : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- serial_rx_input
			serialintf_serial_tx_output : out std_logic_vector(0 downto 0);                     -- serial_tx_output
			sysreset_reset_n            : in  std_logic                     := 'X';             -- reset_n
			tx_gbt_1_data               : in  std_logic_vector(83 downto 0) := (others => 'X'); -- data
			tx_gbt_1_valid              : in  std_logic                     := 'X';             -- valid
			tx_gbt_1_ready              : out std_logic;                                        -- ready
			xcvrclk_1_clk               : in  std_logic                     := 'X';             -- clk
			xcvrintf_xcvr_loopback      : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- xcvr_loopback
			xcvrintf_xcvr_tx_pol        : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- xcvr_tx_pol
			xcvrintf_xcvr_rx_pol        : in  std_logic_vector(0 downto 0)  := (others => 'X'); -- xcvr_rx_pol
			xcvrintf_xcvr_wordclkmon_en : in  std_logic                     := 'X';             -- xcvr_wordclkmon_en
			xcvrintf_xcvr_rx_ready      : out std_logic_vector(0 downto 0);                     -- xcvr_rx_ready
			xcvrintf_xcvr_link_ready    : out std_logic_vector(0 downto 0)                      -- xcvr_link_ready
		);
	end component gbt_qsys;
	--=====================================================================================--   
begin

	MAIN_CLOCK_SEL <= '0';
	
	gbtBank1: gbt_qsys
		port map(
			-- Clocks
			avmmclk_clk                 		=> SYS_CLK_40MHz,
			frameclk_1_clk              		=> SYS_CLK_40MHz,
			xcvrclk_1_clk               		=> REF_CLOCK_L4,
			
			-- Serial
			serialintf_serial_rx_input(0) 	=> GBTBANK_RX(0),
			serialintf_serial_tx_output(0) 	=> GBTBANK_TX(0),
			
			-- Reset
			sysreset_reset_n            		=> SYS_RESET_N,
					
			-- XCVR config		
			xcvrintf_xcvr_loopback      		=> (others => '0'),
			xcvrintf_xcvr_tx_pol        		=> (others => '0'),
			xcvrintf_xcvr_rx_pol        		=> (others => '0'),
			xcvrintf_xcvr_wordclkmon_en 		=> '1',
					
			-- XCVR status		
			xcvrintf_xcvr_rx_ready      		=> open,
			xcvrintf_xcvr_link_ready    		=> open,
					
			-- DATA		
			tx_gbt_1_data               		=> (others => '1'),
			tx_gbt_1_valid              		=> '1',
			tx_gbt_1_ready              		=> open,
					
			rx_gbt_1_data               		=> open,
			rx_gbt_1_valid              		=> open
		);
		
end structural;