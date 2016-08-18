library ieee;
use ieee.std_logic_1164.all;

package gtx_package is

	--===========--
	type gtx_out is
	--===========--
	record
		rx_wordclk		: std_logic;
		rx_data			: std_logic_vector(19 downto 0);
		rx_slide			: std_logic;
		---
		txp				: std_logic;
		txn				: std_logic;
		tx_wordclk		: std_logic;		
		---
		resetdone		: std_logic;		
		phasealingdone	: std_logic;
		---
		drp_drdy       : std_logic;  
		drp_drpdo      : std_logic_vector(15 downto 0);		
      ---
      prbs_rxerr     : std_logic;  
	end record;
	--===========--
	
	
	--===========--
	type gtx_in is
	--===========--
	record
		loopback			: std_logic_vector(2 downto 0);              
		tx_powerdown 	: std_logic_vector(1 downto 0);              
		rx_powerdown 	: std_logic_vector(1 downto 0);              
		---                                                         
		rxp				: std_logic;                                 
		rxn    			: std_logic;	
		rx_sync_reset	: std_logic; 		
		rx_refclk		: std_logic;
		rx_reset			: std_logic;
		rx_slide			: std_logic;
		rx_slide_run	: std_logic;
		rx_slide_nbr	: std_logic_vector(4 downto 0);
		---
		tx_refclk		: std_logic;	
		tx_reset			: std_logic; 
		tx_sync_reset	: std_logic;
      tx_data			: std_logic_vector(19 downto 0);
		---
		drp_daddr      : std_logic_vector(7 downto 0);  
		drp_dclk       : std_logic;   
		drp_den        : std_logic;   
		drp_di         : std_logic_vector(15 downto 0); 
		drp_dwe			: std_logic;
		---
		conf_diff		: std_logic_vector(3 downto 0);
		conf_pstemph	: std_logic_vector(4 downto 0);
		conf_preemph	: std_logic_vector(3 downto 0);
		conf_eqmix     : std_logic_vector(2 downto 0);
		conf_rxpol		: std_logic;
		conf_txpol 		: std_logic;
      ---
      prbs_txen      : std_logic_vector(2 downto 0);
      prbs_rxen      : std_logic_vector(2 downto 0);
      prbs_forcerr   : std_logic;
      prbs_errcntrst : std_logic;     
   end record;
	--===========--

	type gtx_in_array 	is array(natural range <>) of gtx_in;
	type gtx_out_array 	is array(natural range <>) of gtx_out;

end gtx_package;