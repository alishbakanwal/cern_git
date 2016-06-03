library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--! specific packages
library unisim;
use unisim.vcomponents.all;


entity bert is
generic (n : integer:=120;
         bert_dly : integer := 4);
port
(
	tx_clk_i							: in		std_logic;
	rx_clk_i							: in		std_logic;
	tx_i								: in		std_logic_vector(n-1 downto 0);
	rx_i								: in		std_logic_vector(n-1 downto 0);
	tx_o_reg_o						: out		std_logic_vector(n-1 downto 0);
	rx_o_reg_o						: out		std_logic_vector(n-1 downto 0);
	number_of_words_o				: out		std_logic_vector( 63 downto 0);	
	number_of_word_errors_o		: out		std_logic_vector( 63 downto 0);
	word_error_o					: out		std_logic;
	------------------------
	clk_if_i							: in		std_logic;
	reset_if_i						: in		std_logic;
	enable_if_i						: in		std_logic;		
	clear_if_i						: in		std_logic;		
	load_if_i						: in		std_logic;		
	latch_if_i						: in		std_logic;		
	latency_if_i					: in		std_logic_vector(  5 downto 0);
	number_of_words_if_o			: out		std_logic_vector( 63 downto 0);	
	number_of_word_errors_if_o	: out		std_logic_vector( 63 downto 0)	
);                    	
end bert;

                    	
architecture fifo_based_arch of bert is                    	

signal tx_i_reg					: std_logic_vector(n-1 downto 0);
signal rx_i_reg		 			: std_logic_vector(n-1 downto 0); 

signal tx_o			  				: std_logic_vector(n-1 downto 0); 
signal rx_o			   			: std_logic_vector(n-1 downto 0); 

signal tx_o_reg					: std_logic_vector(n-1 downto 0); 
signal rx_o_reg					: std_logic_vector(n-1 downto 0); 

signal tx_wr_en_reg				: std_logic; 
signal rx_wr_en_reg				: std_logic; 

signal tx_rd_en_reg				: std_logic; 
signal rx_rd_en_reg				: std_logic; 

signal enable_if_i_reg			: std_logic; 
signal latency_if_i_reg			: std_logic_vector( 5 downto 0); 
signal load_if_i_reg				: std_logic; 
signal clear_if_i_reg			: std_logic; 
signal latch_if_i_reg			: std_logic; 

signal words_reg					: std_logic_vector( 63 downto 0);	
signal errors_reg					: std_logic_vector( 63 downto 0);
signal error_flag_reg			: std_logic;
signal enable_error_checking	: std_logic;
signal enable_rd_ctrl			: std_logic;
signal latency_countdown		: unsigned(  5 downto 0);

signal bert_settings_tx_clk_i	: std_logic_vector(127 downto 0);
signal bert_settings_clk_if_i	: std_logic_vector(127 downto 0);

signal bert_settings_clk_if_i_latency			: std_logic_vector(5 downto 0);
signal bert_settings_clk_if_i_load_latency 	: std_logic;
signal bert_settings_clk_if_i_enable			: std_logic;
signal bert_settings_clk_if_i_clear				: std_logic;
signal bert_settings_clk_if_i_latch				: std_logic;

signal bert_results_tx_clk_i	: std_logic_vector(127 downto 0);
signal bert_results_clk_if_i	: std_logic_vector(127 downto 0);


signal unused_1					: std_logic_vector(127 downto 0);
signal unused_2					: std_logic_vector(127 downto 0);
signal unused_3					: std_logic_vector(127 downto 0);
signal unused_4					: std_logic_vector(127 downto 0);

begin

----================================--
--tx_fifo: entity work.scfifo
----================================--
--port map 
--(
--	rst					=> (not enable_if_i_reg), --reset_if_i,
--	clk					=> tx_clk_i,
--	din(127 downto N)	=> (others =>'0'),
--	din(N-1 downto 0)	=> tx_i_reg,
--	wr_en					=> tx_wr_en_reg,
--	rd_en					=> tx_rd_en_reg,
--	dout(127 downto N)=> unused_1(127 downto N),
--	dout(N-1 downto 0)=> tx_o,
--	full					=> open,
--	empty					=> open
--);
----================================--



--================================--
tx_fifo: entity work.dcfifo
--================================--
port map 
(
	rst					=> (not enable_if_i_reg), --reset_if_i,
	wr_clk				=> tx_clk_i,
	rd_clk				=> tx_clk_i,
	din(127 downto N)	=> (others =>'0'),
	din(N-1 downto 0)	=> tx_i_reg,
	wr_en					=> tx_wr_en_reg,
	rd_en					=> tx_rd_en_reg,
	dout(127 downto N)=> unused_1(127 downto N),
	dout(N-1 downto 0)=> tx_o,
	full					=> open,
	empty					=> open
);
--================================--



--================================--
rx_fifo: entity work.dcfifo
--================================--
port map 
(
	rst					=> (not enable_if_i_reg), --reset_if_i,
	wr_clk				=> rx_clk_i,
	rd_clk				=> tx_clk_i, --***
	din(127 downto N)	=> (others =>'0'),
	din(N-1 downto 0)	=> rx_i_reg,
	wr_en					=> rx_wr_en_reg,
	rd_en					=> rx_rd_en_reg,
	dout(127 downto N)=> unused_2(127 downto N),
	dout(N-1 downto 0)=> rx_o,
	full					=> open,
	empty					=> open
);
--================================--



--================================--
tx_wr_ctrl:process(reset_if_i, tx_clk_i)
--================================--
begin
if reset_if_i='1' then
   	tx_wr_en_reg			<= '0';	
   	tx_i_reg    			<= (others => '0');
elsif tx_clk_i'event and tx_clk_i='1' then
   	tx_wr_en_reg			<= '1';	
   	tx_i_reg    			<= tx_i;
end if;
end process;
--================================--



--================================--
rx_wr_ctrl:process(reset_if_i, rx_clk_i)
--================================--
begin
if reset_if_i='1' then
   	rx_wr_en_reg			<= '0';	
   	rx_i_reg    			<= (others => '0');
elsif rx_clk_i'event and rx_clk_i='1' then
		rx_wr_en_reg			<= '1';	
   	rx_i_reg    			<= rx_i;
end if;
end process;
----================================--

    

--================================--
rd_ctrl:process(reset_if_i, tx_clk_i)
--================================--
variable ff: std_logic;
variable sr: std_logic_vector(11 downto 0);
begin
if reset_if_i='1' then
	latency_countdown 		<= (others =>'0');	
   rx_o_reg 					<= (others =>'0');
   tx_o_reg 					<= (others =>'0');
   rx_rd_en_reg    			<= '0';
   tx_rd_en_reg    			<= '0';
   enable_error_checking	<= '0'; ff:='0';
	enable_rd_ctrl				<= '0'; sr:=x"000";
	
elsif tx_clk_i'event and tx_clk_i='1' then

	
--	if enable_rd_ctrl='0' then         
	if enable_if_i_reg='0' then         
		if load_if_i_reg='1' then         
			latency_countdown 		<= unsigned(latency_if_i_reg) + bert_dly; 
		end if;
		rx_o_reg 						<= (others =>'0');
		tx_o_reg 						<= (others =>'0');
		rx_rd_en_reg    				<= '0';
		tx_rd_en_reg    				<= '0';
		enable_error_checking		<= '0'; ff:='0';

--	elsif enable_rd_ctrl='1' then
	elsif enable_if_i_reg='1' then
		enable_error_checking 		<= ff; ff:=tx_rd_en_reg;		
		rx_rd_en_reg    				<= '1';		
		if latency_countdown = 0 then
			tx_rd_en_reg    			<= '1';		
		else
			tx_rd_en_reg    			<= '0';
			latency_countdown			<= latency_countdown - 1;		
		end if;	
	end if;	
	
	tx_o_reg 							<= tx_o;
	rx_o_reg 							<= rx_o;
--	enable_rd_ctrl	<= sr(11); sr:= sr(10 downto 0) & enable_if_i_reg;				

end if;
end process;

	tx_o_reg_o 							<= tx_o_reg;
	rx_o_reg_o 							<= rx_o_reg;
	
--================================--


--================================--
error_checking:process(reset_if_i, tx_clk_i)
--================================--
begin
if reset_if_i='1' then
	errors_reg 					<= (others =>'0');
	words_reg  					<= (others =>'0');
	error_flag_reg 			<= '0';	
elsif tx_clk_i'event and tx_clk_i='1' then
	if enable_error_checking='1' then
		if tx_o_reg=rx_o_reg then
			error_flag_reg 	<= '0';
		else
			errors_reg 			<= errors_reg+1;
			error_flag_reg 	<= '1';
		end if;
		words_reg <= words_reg+1;		
		if clear_if_i_reg='1' then
			errors_reg 				<= (others =>'0');
			words_reg  				<= (others =>'0');
			error_flag_reg 		<= '0';	
		end if;			
	elsif enable_error_checking='0' then
		errors_reg 				<= (others =>'0');
		words_reg  				<= (others =>'0');
		error_flag_reg 		<= '0';	
	end if;
end if;
end process;
	word_error_o				<= error_flag_reg;
	number_of_words_o			<= words_reg;	
	number_of_word_errors_o	<= errors_reg;




--================================--
--################################--
--################################--
--################################--
--################################--
--################################--
--================================--



-- bert results clock domaing change

	bert_results_tx_clk_i( 63 downto  0) <= words_reg;
	bert_results_tx_clk_i(127 downto 64) <= errors_reg;
 
	--================================--
	bert_results: entity work.dist_mem_gen_v5_1
	--================================--
	port map
	(
		clk						=> tx_clk_i,
		a							=> "0000",
		d							=> bert_results_tx_clk_i,
		we							=> '1',
		---------------------
		dpra						=> "0000",
		qdpo_clk					=> clk_if_i,
		qdpo						=> bert_results_clk_if_i
	);

	--================================--
	bert_results_reg:process(reset_if_i,clk_if_i) 
	--================================--
		variable state : std_logic;
	begin 
	if reset_if_i = '1' then
		state := '0';
	elsif clk_if_i'event and clk_if_i='1' then
		case state is
		
			when '0' =>
			
				if bert_settings_clk_if_i_latch = '1' then
					number_of_words_if_o				<= bert_results_clk_if_i (63 downto  0);
					number_of_word_errors_if_o		<= bert_results_clk_if_i(127 downto 64);
					state :='1';
				end if;	
			
			when '1' =>
				
				if bert_settings_clk_if_i_latch = '0' then
					state :='0';
				end if;
			
			when others =>
			
		end case;	
			
	end if; 
	end process;
	


--================================--
--################################--
--################################--
--################################--
--################################--
--################################--
--================================--


-- bert settings clock domaing change


	--================================--
	bert_settings_if_clk:process(clk_if_i)
	--================================--
	begin
	if clk_if_i'event and clk_if_i='1' then
		bert_settings_clk_if_i_latency 		<= latency_if_i;
		bert_settings_clk_if_i_load_latency <= load_if_i; 
		bert_settings_clk_if_i_enable			<= enable_if_i;
		bert_settings_clk_if_i_clear			<= clear_if_i;
		bert_settings_clk_if_i_latch			<= latch_if_i;
	end if;
	end process;

	bert_settings_clk_if_i(5 downto 0)		<= bert_settings_clk_if_i_latency; 		
	bert_settings_clk_if_i(6)					<= bert_settings_clk_if_i_load_latency;
	bert_settings_clk_if_i(7)					<= bert_settings_clk_if_i_enable;	
	bert_settings_clk_if_i(8)					<= bert_settings_clk_if_i_clear;	
	bert_settings_clk_if_i(9)					<= bert_settings_clk_if_i_latch;	
	bert_settings_clk_if_i(127 downto 10)	<= (others => '0');		
	--================================--
	bert_settings: entity work.dist_mem_gen_v5_1
	--================================--
	port map
	(
		clk						=> clk_if_i,
		a							=> "0000",
		d							=> bert_settings_clk_if_i,
		we							=> '1',
		---------------------
		dpra						=> "0000",
		qdpo_clk					=> tx_clk_i,
		qdpo						=> bert_settings_tx_clk_i
	);

	--================================--
	bert_controls_tx_clk:process(tx_clk_i) 
	--================================--
	begin 
	if tx_clk_i'event and tx_clk_i='1' then
		latency_if_i_reg	<= bert_settings_tx_clk_i(5 downto 0); 		
		load_if_i_reg		<= bert_settings_tx_clk_i(6); 		
		enable_if_i_reg	<= bert_settings_tx_clk_i(7);
		clear_if_i_reg		<= bert_settings_tx_clk_i(8);
		latch_if_i_reg		<= bert_settings_tx_clk_i(9);
	end if; 
	end process;
	
end fifo_based_arch;