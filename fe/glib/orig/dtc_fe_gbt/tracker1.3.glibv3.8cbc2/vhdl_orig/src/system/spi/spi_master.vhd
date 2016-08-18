------------------------------------------
-- T_sck                 = 2 * T_clk * prescaler
-- T_sck_deassrt_to_mosi = 3 * T_clk + hold
-- T_mosi_to_sck_assrt   = T_sck/2 - T_sck_deassrt_to_mosi (setup)
-- T_sck_assrt_to_mosi   = T_sck - T_sck_deassrt_to_mosi	(hold)
-- T_mosi				 = T_sck	
------------------------------------------
-- optimum settings: prescaler = 2* (3+hold)
------------------------------------------
-- txdata/rxdata: 32 bit
-- control 29bit + 1 status bit (ss_b): 
------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY spi_master IS
generic(dwidth		: integer :=32);
	PORT
	(
		clk_i		: in  std_logic;
		reset_i		: in  std_logic;
		------------
		ssdelay_i	: in  std_logic_vector(9 downto 0);	
		hold_i		: in  std_logic_vector(2 downto 0);	
		enable_i	: in  std_logic;	
		cpol_i		: in  std_logic;
		cpha_i		: in  std_logic;
		msbfirst_i	: in  std_logic;
		prescaler_i	: in  std_logic_vector(11 downto 0);
		data_i		: in  std_logic_vector(dwidth-1 downto 0);
		data_o		: out std_logic_vector(dwidth-1 downto 0);
		------------
		miso_i		: in  std_logic;
		ss_b_o		: out std_logic;
		sck_o		: out std_logic;
		mosi_o		: out std_logic
	); 			
END spi_master;


ARCHITECTURE spi_master_arch of spi_master IS

signal sck		: std_logic;
signal busy		: std_logic;
signal strobe	: std_logic;
signal mosi		: std_logic;
signal ss_b		: std_logic;	

BEGIN


sck_o	<= sck;
mosi_o	<= mosi;
ss_b_o	<= ss_b;

sckgen: process(clk_i, reset_i)
	variable 	prescaler		: std_logic_vector(11 downto 0);
	variable 	timer			: std_logic_vector(11 downto 0);
	variable 	counter			: integer range 0 to 2*dwidth-1;
	variable 	state			: std_logic;
begin
if reset_i='1' then

	prescaler 		:= x"000";
	state			:= '0';
	sck				<= cpol_i;
	busy			<= '0';

elsif clk_i'event and clk_i='1' then
	case state is
		--------
		when '0' => 
		--------
			busy			<='0';
			sck				<= cpol_i;
			if strobe = '1' then 
				state 		:='1'; 
				prescaler	:= prescaler_i-1;
				timer		:= prescaler_i-1;
				busy		<='1';
				counter		:= 2*dwidth-1;
			end if;
		
		--------
		when '1' =>
		--------
			if timer=0 then
				sck 	<= not sck;
				if counter=0 then
					busy 	<= '0';
					state	:= '0';
				else
					timer	:= prescaler;
					counter	:= counter-1;
				end if;	
			else
				timer:=timer-1;
			end if;
		--------
		when others =>
		--------

			
	end case;
end if;
end process;



shiftreg: process(clk_i, reset_i)

	variable	sck_prev			: std_logic;
	variable	cpol				: std_logic;
	variable	cpha				: std_logic;
	variable	txdata, rxdata		: std_logic_vector(dwidth-1 downto 0);
	variable	sck_assertion_edge	: std_logic;
	variable	sck_deassertion_edge: std_logic;
	variable 	msbfirst			: std_logic;
	variable	fo, fi				: std_logic_vector(6 downto 0);
	variable 	hold				: std_logic_vector(2 downto 0);
	
begin
if reset_i='1' then

	fo				:= "0000000";
--	fi				:= "0000000";
	
elsif clk_i'event and clk_i='1' then

	-------------------
	if cpha = '0' then
		
		case hold is
			when "000" => 																												if msbfirst='1' then mosi <= txdata(dwidth-1); else mosi <= txdata(0); end if; 
			when "001" => mosi	<= 				 																				fo(0);	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
			when "010" => mosi	<= 				 												 	    	   fo(1);	fo(1):= fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
			when "011" => mosi	<= 														   	   fo(2);	fo(2):=fo(1); 	fo(1):=	fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
			when "100" => mosi	<= 											   fo(3); 	fo(3):=fo(2);	fo(2):=fo(1); 	fo(1):=	fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
			when "101" => mosi	<= 							     fo(4); fo(4):=fo(3); 	fo(3):=fo(2);	fo(2):=fo(1); 	fo(1):=	fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
			when "110" => mosi	<= 			       fo(5); fo(5):=fo(4); fo(4):=fo(3); 	fo(3):=fo(2);	fo(2):=fo(1); 	fo(1):=	fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
			when "111" => mosi	<= fo(6); 	fo(6):=fo(5); fo(5):=fo(4); fo(4):=fo(3); 	fo(3):=fo(2); 	fo(2):=fo(1); 	fo(1):=	fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
			when others =>
		end case;

		if sck_deassertion_edge	='1' then
			if 	  msbfirst='1' then
				txdata:= txdata(dwidth-2 downto 0) & '0'; 	-- shift left
			elsif msbfirst='0' then
				txdata:= '0' & txdata(dwidth-1 downto 1);	-- shift right
			end if;
		
		end if;

		if sck_assertion_edge	='1' then
			if 	  msbfirst='1' then
				rxdata				:= rxdata(dwidth-2 downto 0) & miso_i; -- shift left
			elsif msbfirst='0' then
				rxdata				:= miso_i & rxdata(dwidth-1 downto 1);	-- shift right
			end if;
		end if;




	-------------------
	elsif cpha='1' then
		
		if sck_assertion_edge	='1' then

			case hold is
				when "000" => 																												if msbfirst='1' then mosi <= txdata(dwidth-1); else mosi <= txdata(0); end if;
				when "001" => mosi	<= 				 																				fo(0);	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
				when "010" => mosi	<= 				 												 	    	   fo(1);	fo(1):= fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
				when "011" => mosi	<= 														   	   fo(2);	fo(2):=fo(1); 	fo(1):=	fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
				when "100" => mosi	<= 											   fo(3); 	fo(3):=fo(2);	fo(2):=fo(1); 	fo(1):=	fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
				when "101" => mosi	<= 							     fo(4); fo(4):=fo(3); 	fo(3):=fo(2);	fo(2):=fo(1); 	fo(1):=	fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
				when "110" => mosi	<= 			       fo(5); fo(5):=fo(4); fo(4):=fo(3); 	fo(3):=fo(2);	fo(2):=fo(1); 	fo(1):=	fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
				when "111" => mosi	<= fo(6); 	fo(6):=fo(5); fo(5):=fo(4); fo(4):=fo(3); 	fo(3):=fo(2); 	fo(2):=fo(1); 	fo(1):=	fo(0); 	if msbfirst='1' then fo(0):= txdata(dwidth-1); else fo(0):= txdata(0); end if;
				when others =>
			end case;                                                                                                          

			if 	msbfirst='1' then
				txdata:= txdata(dwidth-2 downto 0) & '0'; 	-- shift left
			
			elsif msbfirst='0' then
				txdata:= '0' & txdata(dwidth-1 downto 1);	-- shift right
			end if;

		end if;
		
		if sck_deassertion_edge	='1' then
			if 	  msbfirst='1' then
				rxdata:= rxdata(dwidth-2 downto 0) & miso_i; 	-- shift left
			elsif msbfirst='0' then
				rxdata:= miso_i & rxdata(dwidth-1 downto 1);	-- shift right
			end if;
		end if;
		
		
		
	end if;
	
	--- edge detection ---
	if cpol='0' then
		sck_assertion_edge	:='0';		
		if sck_prev='0' and sck='1' then
			sck_assertion_edge	:='1';		
		end if;
		
		sck_deassertion_edge	:='0';		
		if sck_prev='1' and sck='0' then
			sck_deassertion_edge	:='1';		
		end if;
		
	elsif cpol='1' then
		sck_assertion_edge	:='0';		
		if sck_prev='1' and sck='0' then
			sck_assertion_edge	:='1';		
		end if;
		
		sck_deassertion_edge	:='0';		
		if sck_prev='0' and sck='1' then
			sck_deassertion_edge	:='1';		
		end if;
	end if;
	sck_prev		:= sck;
	
	--- latch inputs
	if strobe='1' then
		txdata	:= data_i;
		cpol	:= cpol_i;
		cpha	:= cpha_i;
		msbfirst:= msbfirst_i;
		hold	:= hold_i;
	end if;


	data_o	<= rxdata;

end if;
end process;

en: process(clk_i, reset_i)
	
	variable enable 	: std_logic;
	variable state  	: std_logic_vector(1 downto 0);
	variable timer		: std_logic_vector(9 downto 0);
	variable ssdelay	: std_logic_vector(9 downto 0);
begin
if reset_i='1' then

	enable	:= '0';
	strobe	<= '0';
	ss_b	<= '1';
elsif clk_i'event and clk_i='1' then

	case state is
		
		--========--
		when "00" =>
		--========--
			
			strobe 	<= '0';	
			ss_b	<= '1';
			if enable='1' then 
				ss_b 	<= '0';
				timer	:= ssdelay;
				state	:="01"; 
			end if;
				
		--========--
		when "01" =>
		--========--

			if timer=0 then
				strobe <='1';
				state:="10";
			else
				timer:=timer-1;
			end if;

		--========--
		when "10" =>		
		--========--
		
			strobe 	<= '0';
			timer	:= ssdelay;
			state	:= "11";
			
		--========--
		when "11" =>
		--========--
		
			if busy='0' then
				if timer=0 then
					ss_b <= '1';
					if enable = '0' then
						state:="00";
					end if;
				else
					timer:=timer-1;
				end if;
			end if;
		when others =>
	end case;	
	
	ssdelay:= ssdelay_i;
	enable := enable_i;

end if;
end process;


END spi_master_arch;
