
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity measure_refclk is
GENERIC
	(
		CYC_MEASURE_CLK_IN_1_SEC	: std_logic_vector(31 downto 0) :=	X"02FAF080"  -- (50 Mhz clock is 50E6 samples in one second)
	);
port
	(
	RefClock				: in	std_logic;
	Measure_Clk				: in 	std_logic;
	reset					: in	std_logic;
	Valid					: out 	std_logic;					 -- Synchronized to Measure_Clk
	RefClock_Measure		: out  std_logic_vector(31 downto 0) -- Synchronized to Measure_Clk
	);
end;

architecture rtl of measure_refclk is

signal count_Measure_Clk	:std_logic_vector(33 downto 0);
signal count_RefClock		:std_logic_vector(31 downto 0);
signal Refclock_Measure_min2		:std_logic_vector(31 downto 0);
signal Refclock_Measure_min1		:std_logic_vector(31 downto 0);
signal Gate					:std_logic;
signal Gate_min2			:std_logic;
signal Gate_min1			:std_logic;
signal Gate_min0			:std_logic;
signal Latch				:std_logic;
signal Latch_min2			:std_logic;
signal Latch_min1			:std_logic;
signal Latch_min0			:std_logic;

begin

	process(Measure_Clk,reset)
	begin
		if reset = '1' then
			count_Measure_Clk 		<= (OTHERS => '0');
			Gate 					<= '0';
			RefClock_Measure_min2 	<= (OTHERS => '0');		
			RefClock_Measure_min1	<= (OTHERS => '0');	
			RefClock_Measure 		<= (OTHERS => '0');		
			Valid					<= '0';
			Latch					<= '0';
		elsif rising_edge(Measure_Clk) then
			if count_Measure_Clk = (CYC_MEASURE_CLK_IN_1_SEC-2) then
				Latch <= '1';
				count_Measure_Clk <= count_Measure_Clk + 1;
			elsif count_Measure_Clk = (CYC_MEASURE_CLK_IN_1_SEC-1) then 	
				count_Measure_Clk <= (OTHERS => '0');
				Gate <= not Gate;
				Latch <= '0';
			else
				count_Measure_Clk <= count_Measure_Clk + 1;
				Latch <= '0';
			end if;	
			if (Latch = '1') and (Gate = '1') then
				Valid <= '1';
				Refclock_Measure_min2 <= count_RefClock;
				RefClock_Measure_min1 <= RefClock_Measure_min2;
				RefClock_Measure	  <= RefClock_Measure_min1;
			else
				Valid <= '0';
			end if;				
		end if;
	end process;
	
	process(RefClock,reset)
	begin
		if reset = '1' then
			count_RefClock 		<= (OTHERS => '0');
			Gate_min2			<= '0';
			Gate_min1			<= '0';
			Gate_min0			<= '0';
			
		elsif rising_edge(RefClock) then	
			Gate_min2 <= Gate;
			Gate_min1 <= Gate_min2;
			Gate_min0 <= Gate_min1;		
			if (Gate_min0 = '1') then
				count_RefClock <= count_RefClock + 1;
			else
				count_RefClock <= (OTHERS => '0');
			end if;	
			
--			Latch_min2 <= Latch;
--			Latch_min1 <= Latch_min2;
--			Latch_min0 <= Latch_min1;	
						
--			if (Latch_min0 = '1') and (Gate_min0 = '1') then
--				Refclock_Measure <= count_RefClock;
--			end if;			
		end if;
	end process;									
		
end;