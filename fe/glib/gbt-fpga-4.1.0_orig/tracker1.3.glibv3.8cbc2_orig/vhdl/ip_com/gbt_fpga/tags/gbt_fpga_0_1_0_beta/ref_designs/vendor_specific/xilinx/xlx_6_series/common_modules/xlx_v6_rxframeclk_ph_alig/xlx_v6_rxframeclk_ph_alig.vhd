-- Created by P.Vichoudis and M. Barros Marin

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity xlx_v6_rxframeclk_ph_alig is	
	port (				
		RESET_I       										: in std_logic;
		--------------------------------------------
      RX_WORDCLK_I 										: in std_logic;			
		RX_FRAMECLK_O										: out std_logic;	-- phase aligned output		
		--------------------------------------------
		SYNC_I        										: in std_logic;
		--------------------------------------------
      DONE_O        										: out std_logic
	);
end xlx_v6_rxframeclk_ph_alig;


architecture behavioral of xlx_v6_rxframeclk_ph_alig is	

signal numbersteps		: std_logic_vector(2 downto 0);
signal set_numbersteps	: std_logic;
signal do_phaseshift		: std_logic;
signal stepsfound			: std_logic;
signal clk40				: std_logic;		
signal reset				: std_logic;		
signal pll_locked			: std_logic;		

begin
		 
	--=============================--
	pll: entity work.xlx_v6_rxfrmclkphalig_pll
	--=============================--
	port map
	(	
		reset_i				=> '0', --RESET_I,			
		clk240_i				=> RX_WORDCLK_I,		
		numbersteps_i		=> numbersteps,
		setnumsteps_i		=> set_numbersteps,
		incdec_phase_i		=> '0',
		dophaseshift_i		=> do_phaseshift,	
		clk40_o				=> clk40,						
		clk80_o				=> open,						
		clk120a_o			=> open,						
		clk120b_o			=> open,						
		clk160a_o			=> open,						
		clk160b_o			=> open,						
		clk240_o				=> open,						
		plllocked_o			=> pll_locked,
		phaseshiftdone_o	=> done_o	
	);
	--=============================--
	
	RX_FRAMECLK_O	      <= clk40;
	reset                <= '1' when (pll_locked='0' or RESET_I='1') else '0';

	--=============================--
	ctrl: process(RX_WORDCLK_I, reset)
	--=============================--
		variable cn_state								: std_logic_vector(1 downto 0);
		variable ps_state								: std_logic_vector(2 downto 0);
		variable	slowclk_prev, 	slowclk_curr	: std_logic;
		variable	sync_prev	,	sync_curr		: std_logic;
		variable stepcnt								: std_logic_vector(2 downto 0);
	begin
	if reset_i = '1' then
		--=====--
		cn_state			:= "00" ; 	
		ps_state 		:= "000" ; 	
		--=====--
		slowclk_prev	:= '0'; 	
		slowclk_curr	:= '0';
		sync_prev		:= '1'; 	
		sync_curr		:= '1'; 	
		stepcnt			:="000";
		--=====--
		numbersteps		<="000";
		set_numbersteps<= '0';
		do_phaseshift	<= '0';
		--=====--
		stepsfound		<= '0';
		
	elsif rising_edge(RX_WORDCLK_I) then
		
		numbersteps	<= stepcnt;
		--=====--
		case ps_state is
			when "000"	=> set_numbersteps<= '0';	do_phaseshift	<= '0';	if stepsfound='1' then 	ps_state:= "001"; end if;
			when "001"	=> set_numbersteps<= '0';	do_phaseshift	<= '0';									ps_state:= "010";
			when "010"	=> set_numbersteps<= '1';	do_phaseshift	<= '0';									ps_state:= "011";
			when "011"	=> set_numbersteps<= '0';	do_phaseshift	<= '0';									ps_state:= "100";
			when "100"	=> set_numbersteps<= '0';	do_phaseshift	<= '1';									ps_state:= "101";
			when "101" 	=> set_numbersteps<= '0';	do_phaseshift	<= '0';									ps_state:= "110";
			when others	=> 
		end case;	
		--=====--
		case cn_state is
			when "00"	=> if sync_prev='0' and sync_curr='1' 			then	cn_state:="01"; end if;
			when "01"	=> if slowclk_prev ='0' and slowclk_curr='1' then	cn_state:="10";
								else stepcnt:=stepcnt+1; end if;
			when "10"		=> stepsfound	<= '1';									cn_state:="11";
			when others	=> null;
		end case;	
		--=====--
		slowclk_prev:= slowclk_curr;	slowclk_curr:= clk40;
		sync_prev	:= sync_curr;		sync_curr	:= sync_i;
		--=====--
		
	end if;
	end process;

end behavioral;
