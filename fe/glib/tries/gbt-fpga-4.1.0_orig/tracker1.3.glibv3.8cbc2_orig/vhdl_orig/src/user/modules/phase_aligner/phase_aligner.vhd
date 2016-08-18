library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity phase_aligner is	
	port (				
		reset_i											: in std_logic;
		clk240_i											: in std_logic;			
		clk40_o											: out std_logic;	-- phase aligned output		
		clk80_o											: out std_logic;	-- phase aligned output		
		clk120a_o										: out std_logic;	-- phase aligned output		
		clk120b_o										: out std_logic;	-- phase aligned output		
		clk160a_o										: out std_logic;	-- phase aligned output		
		clk160b_o										: out std_logic;	-- phase aligned output		
		clk240_o											: out std_logic;	-- phase aligned output		
		sync_i											: in std_logic;
		done_o											: out std_logic
	);
end phase_aligner;


architecture phase_aligner_arch of phase_aligner is	

signal numbersteps		: std_logic_vector(2 downto 0);
signal set_numbersteps	: std_logic;
signal do_phaseshift		: std_logic;
signal stepsfound			: std_logic;
signal clk40				: std_logic;		
signal reset				: std_logic;		
signal pll_locked			: std_logic;		

begin
		 
	--=============================--
	pll: entity work.phase_aligner_240to40MHz_6steps
	--=============================--
	port map
	(	
		reset_i				=> '0', --reset_i,			
		clk240_i				=> clk240_i,		
		numbersteps_i		=> numbersteps,
		setnumsteps_i		=> set_numbersteps,
		incdec_phase_i		=> '0',
		dophaseshift_i		=> do_phaseshift,	
		clk40_o				=> clk40,						
		clk80_o				=> clk80_o,						
		clk120a_o			=> clk120a_o,						
		clk120b_o			=> clk120b_o,						
		clk160a_o			=> clk160a_o,						
		clk160b_o			=> clk160b_o,						
		clk240_o				=> clk240_o,						
		plllocked_o			=> pll_locked,
		phaseshiftdone_o	=> done_o	
	);
	--=============================--
	
	clk40_o	<= clk40;
	reset <= '1' when (pll_locked='0' or reset_i='1') else '0';

	--=============================--
	ctrl: process(clk240_i, reset)
	--=============================--
		variable cn_state								: std_logic_vector(1 downto 0);
		variable ps_state								: std_logic_vector(2 downto 0);
		variable	slowclk_prev, 	slowclk_curr	: std_logic;
		variable	sync_prev	,	sync_curr		: std_logic;
		variable stepcnt								: std_logic_vector(2 downto 0);
	begin
	if reset = '1' then
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
		
	elsif clk240_i'event and clk240_i = '1' then
		
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

end phase_aligner_arch;
