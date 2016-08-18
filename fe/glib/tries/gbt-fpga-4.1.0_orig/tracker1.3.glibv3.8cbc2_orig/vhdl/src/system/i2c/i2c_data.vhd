--------------------------------------------------
-- File:		I2Cmaster_data.vhd
-- Author:		P.Vichoudis
--------------------------------------------------
-- Description:	the data part of the I2C master
--------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY i2c_data IS
generic(M: integer :=1;
		    N: integer :=12);
	PORT
	(
		clk					: in  	std_logic;
		reset					: in  	std_logic;
		enable				: in  	std_logic;
		------------------------------
		clkprescaler		: in  	std_logic_vector(9 downto 0);
		startclk_ext		: in  	std_logic;
		execstart_ext		: in  	std_logic;
		execstop_ext		: in  	std_logic;
		execwr_ext			: in  	std_logic;
		execgetack_ext		: in  	std_logic;
		execrd_ext			: in  	std_logic;
		execsendack_ext	: in  	std_logic;
		bytetowrite_ext	: in  	std_logic_vector(7 downto 0);
		byteread				: out 	std_logic_vector(7 downto 0);
		bytereaddv			: out 	std_logic;
		i2c_bus_select		:in		std_logic;					
		------------------------------
		completed			: out  	std_logic;
		failed				: out  	std_logic;
		------------------------------
		scl_in				:in		std_logic_vector(1 downto 0);					
		scl_out				:out		std_logic_vector(1 downto 0);					
		scl_oe_l				:out		std_logic_vector(1 downto 0);				
		sda_in				:in		std_logic_vector(1 downto 0);					
		sda_out				:out		std_logic_vector(1 downto 0);					
		sda_oe_l				:out		std_logic_vector(1 downto 0)
	); 			

END i2c_data;
ARCHITECTURE behave OF i2c_data IS

signal exec			: std_logic;
signal addr			: std_logic_vector(7 downto 0);
signal datain		: std_logic_vector(7 downto 0);
signal wr			: std_logic;
signal prescaler	: std_logic_vector(9 downto 0);

signal en			: std_logic;
signal startclk		: std_logic;
signal execstart	: std_logic;
signal execstop 	: std_logic;
signal execwr		: std_logic;
signal execgetack	: std_logic;
signal execrd		: std_logic;
signal execsendack	: std_logic;
signal bytetowrite	: std_logic_vector(7 downto 0);



signal wrbit		: std_logic;
signal rdbit		: std_logic;
signal sclbit		: std_logic;
signal dv			: std_logic;
	
type datafsm_type	is 
(idle, 
startcondition_1, startcondition_2,
stopcondition_1 , stopcondition_2,
writebyte,
getack,
readbyte,
sendack
);
signal datafsm	: datafsm_type;

attribute keep: boolean;
attribute keep of rdbit					: signal is true;
attribute keep of sda_in				: signal is true;


BEGIN
--========================--
reg_in:process(clk, reset)
--========================--
begin
if reset='1' then
	
	en			<= '0';
	prescaler	<= (others=>'0');

--	startclk	<= '0';
--	execstart	<= '0';
--	execstop	<= '0';
--	execwr		<= '0';
--	execgetack	<= '0';
--	execrd		<= '0';
--	execsendack	<= '0';
--	bytetowrite	<= (others=>'0');
	
elsif clk'event and clk='1' then
	
	en			<= enable;
	prescaler	<= clkprescaler;

--	startclk	<= startclk_ext;
--	execstart	<= execstart_ext;
--	execstop	<= execstop_ext;
--	execwr		<= execwr_ext;
--	execgetack	<= execgetack_ext;
--	execrd		<= execrd_ext;
--	execsendack	<= execsendack_ext;
--	bytetowrite	<= bytetowrite_ext;

end if;		
end process;

	startclk	<= startclk_ext;
	execstart	<= execstart_ext;
	execstop	<= execstop_ext;
	execwr		<= execwr_ext;
	execgetack	<= execgetack_ext;
	execrd		<= execrd_ext;
	execsendack	<= execsendack_ext;
	bytetowrite	<= bytetowrite_ext;


--========================--
i2cscl:process(clk, reset)
--========================--
	variable timer : std_logic_vector(9 downto 0);
	variable level : std_logic;
	variable clkhasstarted : std_logic;
begin
if reset='1' then
	sclbit	<= '1';
	level 	:= '1';
	clkhasstarted := '0';
	
elsif clk'event and clk='1' then
	if en='1' then
		if clkhasstarted='1' then
			if timer=1 then
				level := not level; sclbit <= level; 
				timer	:= '0' & prescaler(9 downto 1);
			else
				timer	:= timer-1;
			end if;
		elsif startclk='1' then		
			level 	:= '0'; sclbit <= level;
			timer	:= '0' & prescaler(9 downto 1);
			clkhasstarted :='1';
		end if;
	else
		sclbit  <= '1';
		level	:= '0';
		clkhasstarted := '0';
		timer:= '0' & prescaler(9 downto 1);
	end if;
end if;
end process;

--========================--
i2csda:process(clk, reset)
--========================--
	variable timer : std_logic_vector(9 downto 0);
	variable byte  : std_logic_vector(7 downto 0);
	variable cnt   : integer range 0 to 15;
	variable ack   : std_logic;	
	variable samplingtime : std_logic_vector(9 downto 0);	
begin
if reset='1' then

	dv			<= '0';
	wrbit		<= '1';  -- read
	datafsm 	<= idle;
	
elsif clk'event and clk='1' then
	
	
	bytereaddv 	<= dv;
	dv 			<='0';
		
	--=========--
	case datafsm is
	--=========--

		--=========--
		when idle =>
		--=========--
			completed 	<= '0';
			failed 		<= '0';
			ack	  		:= '1';
			if execstart='1' then
				datafsm <= startcondition_1;
				timer := "0" & prescaler(9 downto 1);
			elsif execstop='1' then
				datafsm <= stopcondition_1;
				timer := "0" & prescaler(9 downto 1);
			elsif execwr='1' then
				datafsm <= writebyte;
				timer := "00" & prescaler(9 downto 2); --x"01";
				byte  := bytetowrite;
				cnt	  := 8;		
			elsif execgetack='1' then
				datafsm <= getack;
				timer := prescaler;
				samplingtime:= prescaler - prescaler(9 downto 2);
			elsif execrd='1' then
				datafsm <= readbyte;
				timer := prescaler;
				samplingtime:= prescaler - prescaler(9 downto 2);
				byte  := (others=>'0');
				cnt	  := 7;		
			elsif execsendack='1' then
				datafsm <= sendack;
				timer := prescaler;
			else
				datafsm <= idle;
			end if;	
		
		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@-
		--@@@@ START CONDITION
		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@

		--=========--
		when startcondition_1 =>
		--=========--
			wrbit	<='1';
			if timer=1 then
				datafsm <= startcondition_2;
				timer := "00" & prescaler(9 downto 2);
			else
				timer:=timer-1;
			end if;
		
		--=========--
		when startcondition_2 =>
		--=========--
			if timer=1 then
				wrbit	<='0';
				datafsm <= idle;
			else
				timer:=timer-1;
			end if;

		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@-
		--@@@@ STOP CONDITION
		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		
		--=========--
		when stopcondition_1 =>
		--=========--
			wrbit	<='0';
			if timer=1 then
				datafsm <= stopcondition_2;
				timer := "00" & prescaler(9 downto 2);
			else
				timer:=timer-1;
			end if;
		
		--=========--
		when stopcondition_2 =>
		--=========--
			if timer=1 then
				wrbit	<='1';
				datafsm <= idle;
			else
				timer:=timer-1;
			end if;	

		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@-
		--@@@@ WRITE BYTE
		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@

		--=========--
		when writebyte =>
		--=========--
			if timer=(prescaler(9 downto 2)+2) and cnt=0 then
				datafsm <= idle;
			elsif timer=1 then
				timer := prescaler;
				wrbit <= byte(7); byte:=byte(6 downto 0) & '0';
				cnt:=cnt-1;
			else
				timer:=timer-1;
			end if;	

		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@-
		--@@@@ GET ACK
		--@@@@@@@@@@@@@@@@@@@@@@@@@@@@

		--=========--
		when getack =>
		--=========--

			completed <= '0'; 
			failed <= '0';
			wrbit	<='1'; -- read
			if timer=2 then
				datafsm <= idle;
			else
				if timer=samplingtime then 
					ack:=rdbit; 
					if ack='0' then 
						completed <= '1'; failed <= '0';
					else
						completed <= '0'; failed <= '1';
					end if;
				end if;
				timer:=timer-1;
			end if;	

		--=========--
		when readbyte =>
		--=========--
			wrbit	<='1'; -- read
			if timer=2 and cnt=0 then
				datafsm <= idle;
				byteread <= byte; dv <= '1';
			elsif timer=1 then
				timer := prescaler;
				cnt:=cnt-1;
			else
				if timer=samplingtime then byte:=byte(6 downto 0) & rdbit; end if;
				timer:=timer-1;
			end if;	

		--=========--
		when sendack =>
		--=========--
			wrbit <= '1'; --'0'; 
			if timer=2 then
				datafsm <= idle;
			else
				timer:=timer-1;
			end if;	

	end case;

end if;
end process;








rdbit		<= sda_in(0) 	when (i2c_bus_select='0') 										else 
				sda_in(1) 	when (i2c_bus_select='1') 										else 
				'1';

sda_out(0) 	<= '0'		when (i2c_bus_select='0' 	and wrbit='0')             else 'Z';
sda_oe_l(0)	<= '0'		when (i2c_bus_select='0' 	and wrbit='0' and en='1')  else '1';
sda_out(1) 	<= '0'		when (i2c_bus_select='1' 	and wrbit='0')             else 'Z';
sda_oe_l(1) <= '0'		when (i2c_bus_select='1' 	and wrbit='0' and en='1')  else '1';


-- scl_in
scl_out(0) 	<= '0'		when (i2c_bus_select='0' 	and sclbit='0')            else 'Z';
scl_oe_l(0)	<= '0'		when (i2c_bus_select='0' 	and sclbit='0' and en='1') else '1';
scl_out(1) 	<= '0'		when (i2c_bus_select='1' 	and sclbit='0')            else 'Z';
scl_oe_l(1)	<= '0'		when (i2c_bus_select='1' 	and sclbit='0' and en='1') else '1';



END behave;