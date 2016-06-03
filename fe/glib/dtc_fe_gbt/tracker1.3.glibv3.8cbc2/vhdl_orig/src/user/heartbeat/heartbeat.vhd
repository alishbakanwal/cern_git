library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- Entity declaration for the example design
-------------------------------------------------------------------------------

----============--
entity heartbeat is
----============--
   generic(
		period_clka	: integer:= 125000000;
		period_clkb	: integer:= 125000000		
   );
   port(
		reset					: in  std_logic;								
		clka				: in  std_logic;	
		clkb				: in  std_logic;	
		heartbeat_clka     : out std_logic;
		heartbeat_clkb      : out std_logic
   );
end heartbeat;
----============--


architecture heartbeat_arch of heartbeat is
begin
	-- generate heartbeat_clka 
	--===================--
	heartbeat_clka_process: process(clka, reset)
	--===================--
		constant period: integer:=period_clka/2;
		variable heartbeat_clka_timer : integer;  -- 1s; 
		variable hb_clka : std_logic;
	begin
	if (reset = '1') then
		heartbeat_clka_timer := period;  -- 1s;
		heartbeat_clka <= '0'; hb_clka :='0';
	elsif (clka = '1' and clka'event) then
		heartbeat_clka <= hb_clka;
		if heartbeat_clka_timer=0 then
			hb_clka := not hb_clka;
			heartbeat_clka_timer := period;  -- 1s;
		else
			heartbeat_clka_timer:=heartbeat_clka_timer - 1;
		end if;
	end if;
	end process;



	-- generate heartbeat_clkb 
	--===================--
	heartbeat_clkb_process : process(clkb, reset)
	--===================--
		constant period: integer:=period_clkb/2;
		variable heartbeat_clkb_timer : integer;
		variable hb_clkb : std_logic;
	begin
	if (reset = '1') then
		heartbeat_clkb_timer :=period;  -- 1s;
		heartbeat_clkb <= '0';
		heartbeat_clkb <= '0'; hb_clkb :='0';
	elsif (clkb = '1' and clkb'event) then
		heartbeat_clkb <= hb_clkb;
		if heartbeat_clkb_timer=0 then
			hb_clkb := not hb_clkb;
			heartbeat_clkb_timer := period;  -- 1s;
		else
			heartbeat_clkb_timer:=heartbeat_clkb_timer - 1;
		end if;
	end if;
	end process;
	
end heartbeat_arch;