----------------------------------------------------------------------------------
-- company: 
-- engineer: 
-- 
-- create date:    14:49:29 06/30/2011 
-- design name: 
-- module name:    cdr2ttc - behavioral 
-- project name: 
-- target devices: 
-- tool versions: 
-- description: 
--
-- dependencies: 
--
-- revision: 
-- revision 0.01 - file created
-- additional comments: 
--
-- ttc hamming encoding
-- hmg[0] = d[0]^d[1]^d[2]^d[3];
-- hmg[1] = d[0]^d[4]^d[5]^d[6];
-- hmg[2] = d[1]^d[2]^d[4]^d[5]^d[7];
-- hmg[3] = d[1]^d[3]^d[4]^d[6]^d[7];
-- hmg[4] = d[0]^d[2]^d[3]^d[5]^d[6]^d[7];
-- this design does not decode individually addressed commands/data frame
-- brcst bits [7:6] and [5:2] are used together, so only one brcststr and coarse_delay is implemented
-- sy89872 outputs a low jitter and in phase ttc clock. if not required in phase, do not use div_nrst(if used, must keep
-- the trace as short as possible to avoid reflection. this signal is very timing critical)
-- fpga ttcclk output jitter is not measured.
-- all input/output should have vccio = 2.5v, vccaux is recommended to use 3.3v to have more accurate internal differential input termination
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;

-- uncomment the following library declaration if using
-- arithmetic functions with signed or unsigned values
-- use ieee.numeric_std.all;

-- uncomment the following library declaration if instantiating
-- any xilinx primitives in this code.
library unisim;
use unisim.vcomponents.all;

entity cdr2ttc is
generic (pll_locked_delay: integer:= 100000);
port 
(
-- adn2814 cdr interface
   ttc_los 				: in   std_logic;
   ttc_lol 				: in   std_logic;
   cdrclk_in			: in   std_logic;
   cdrdata_in 			: in   std_logic;
	--
	PC_config_ok 		: in std_logic;	
	CLK_OUT_MUX_SEL 	: in std_logic;
	--
	cdrclk_locked		: out  std_logic;		
	cdrclk_out 			: out  std_logic;--160M_0°
	cdrclk_div     	: out  std_logic;--40M_0°_180° 
	cdrclk_div_40M_0 	: out std_logic;--40M_0°
	--	
-- controls latency of l1a, broadcasr signals etc
	coarse_delay		: in   std_logic_vector(3 downto 0);
-- clock divider sy89872 div4/div2 control
   div4 					: out  std_logic;
-- clock divider sy89872 async reset control, used to align the phase of 40mhz clock divider output relative to ttcdata_p(n)
   div_nrst 			: out  std_logic;
-- ttc output signals
   ttcclk 				: out  std_logic;
   l1accept 			: out  std_logic;
   bcntres 				: out  std_logic;
   evcntres 			: out  std_logic;
   sinerrstr 			: out  std_logic;
   dberrstr 			: out  std_logic;
   brcststr 			: out  std_logic;
	brcst					: out  std_logic_vector(7 downto 2)
);
end cdr2ttc;

architecture behavioral of cdr2ttc is

	signal cdr_bad 				: std_logic := '0';
	signal cdrclk 					: std_logic := '0';
	signal cdr_lock	 			: std_logic := '0';
	signal cdrdata_q 				: std_logic_vector(1 downto 0) := (others =>'0');
	signal div8 					: std_logic_vector(2 downto 0) := (others =>'0');
	signal toggle_cnt 			: std_logic_vector(1 downto 0) := (others =>'0');
	signal toggle_channel 		: std_logic := '1';
	signal a_channel 				: std_logic := '1';
	signal l1a 						: std_logic := '0';
	signal strng_length 			: std_logic_vector(3 downto 0) := (others =>'0');
	signal div_rst_cnt 			: std_logic_vector(4 downto 0) := (others =>'0');
	signal ttc_str 				: std_logic := '0';
	signal sr 						: std_logic_vector(12 downto 0) := (others => '0');
	signal rec_cntr 				: std_logic_vector(5 downto 0) := (others => '0');
	signal rec_frame 				: std_logic := '0';
	signal fmt 						: std_logic := '0';
	signal ttc_data 				: std_logic_vector(2 downto 0) := (others => '0');
	signal brcst_str 				: std_logic_vector(3 downto 0) := (others => '0');
	signal brcst_data 			: std_logic_vector(7 downto 0) := (others => '0'); -- hamming data bits
	signal brcst_syn 				: std_logic_vector(4 downto 0) := (others => '0'); -- hamming checking bits
	signal frame_err 				: std_logic := '0';
	signal single_err 			: std_logic := '0';
	signal double_err 			: std_logic := '0';
	signal evcntreset 			: std_logic := '0';
	signal bcntreset 				: std_logic := '0';
	signal brcst_i 				: std_logic_vector(7 downto 2) := (others => '0');



	--mmcm
	signal cdrclk_160M_0 			: std_logic:='0';	
	signal cdrclk_div_40M_0_180 	: std_logic:='0';
	signal reset_mmcm_cdrclk 		: std_logic:='0';
	signal lock_mmcm_cdrclk			: std_logic:='0';

begin

	brcst <= brcst_i;
	cdr_bad <= ttc_lol or ttc_los;



	reset_mmcm_cdrclk <= cdr_bad or not PC_config_ok; --cdr_bad before

	--===============================================================================================--	
	i_mmcm_cdrclk: entity work.mmcm_160M_in_dephasing 
	--===============================================================================================--
	port map (	-- clk in
					CLK_IN1 				=> cdrclk_in, --no bufg
					-- dephasing select
					CLK_OUT_MUX_SEL 	=> CLK_OUT_MUX_SEL,
					--clk out
					CLK_OUT1 			=> cdrclk_160M_0,--160M_0°
					CLK_OUT2 			=> cdrclk_div_40M_0_180,--40M_0°_180°
					CLK_OUT3 			=> cdrclk_div_40M_0, --40M_0°
					--
					RESET 				=> reset_mmcm_cdrclk,
					LOCKED 				=> lock_mmcm_cdrclk
			);
	--===============================================================================================--				
	
	--
	cdrclk		<= cdrclk_160M_0; --160M_0°


	--out 
	cdrclk_div 	<= cdrclk_div_40M_0_180;--40M_0°_180°
	cdrclk_out 	<= cdrclk; --160M_0°



	---------------********************************PLL_LOCK************************************----------------
		
	process(cdrclk, lock_mmcm_cdrclk)  
	variable timer: integer;
	begin
		if lock_mmcm_cdrclk = '0' then 
		 timer 		:= pll_locked_delay;
		 cdr_lock 	<= '0';
		elsif cdrclk'event and cdrclk='1' then
			if timer=0 then
			 cdr_lock <= '1';
			else
			 timer	:=timer - 1;
			end if;	
		end if;	
	end process;
	--out
	cdrclk_locked	<= cdr_lock;--lock_mmcm_cdrclk;
	---------------******************************END PLL_LOCK**********************************----------------





	---------------********************************DECODING************************************----------------
	div4 <= '1';
	process(cdrclk)
	begin
		if(cdrclk'event and cdrclk = '1')then
			cdrdata_q <= cdrdata_q(0) & cdrdata_in;
			if(toggle_channel = '0')then
				div8 <= div8 + 1;
			end if;
			if(div8 = "111" or toggle_cnt = "11")then
				toggle_cnt <= (others => '0');
	-- ttc signal should always toggle at a/b channel crossing, otherwise toggle_channel is at wrong position. toggle_cnt counts these errors.
			elsif(cdrdata_q(1) = cdrdata_q(0) and toggle_channel = '0')then
				toggle_cnt <= toggle_cnt + 1;
			end if;
			if(toggle_cnt /= "11")then
				toggle_channel <= not toggle_channel;
			end if;
	--  if illegal l1a='1'/data = '0' sequence reaches 11, resync the phase
			if(toggle_channel = '1' and (a_channel = '1' or strng_length /= x"b"))then
				a_channel <= not a_channel;
			end if;
			if(a_channel = '1' and toggle_channel = '1')then
				if(cdrdata_q(1) /= cdrdata_q(0))then
					l1a <= '1';
				else
					l1a <= '0';
				end if;
			end if;
			if(a_channel = '0' and toggle_channel = '1')then
	--	l1a = '1' and b_channel data = '0' can not repeat 11 times. strng_length counts the repeat length of this data pattern
				if(l1a = '0' or (cdrdata_q(1) /= cdrdata_q(0)) or strng_length = x"b")then
					strng_length <= (others => '0');
				else
					strng_length <= strng_length + 1;
				end if;
			end if;
		end if;
	end process;
	process(cdrclk,cdr_lock)
	begin
		if(cdr_lock = '0')then
			div_nrst <= '0';
			div_rst_cnt <= (others => '0');
		elsif(cdrclk'event and cdrclk = '1')then
	-- whenever phase adjustment occurs, reset ttc clock divider
			if(toggle_cnt = "11" or strng_length = x"b")then
				div_nrst <= '0';
				div_rst_cnt <= (others => '0');
			elsif(ttc_str = '1')then
	-- release the ttc clock divider reset if no more phase error for at least 16 ttc clock cycles
				div_nrst <= div_rst_cnt(4);
				if(div_rst_cnt(4) = '0')then
					div_rst_cnt <= div_rst_cnt + 1;
				end if;
			end if;
		end if;
	end process;
	process(cdrclk)
	begin
		if(cdrclk'event and cdrclk = '1')then
			if(toggle_channel = '1')then
				ttcclk <= not a_channel;
			end if;
			if(toggle_channel = '1' and a_channel = '0')then
	-- b channel data, command frames
				ttc_data(2) <= cdrdata_q(1) xor cdrdata_q(0);
			end if;
	-- ttc_str selects b-channel data
			ttc_str <= not toggle_channel and a_channel;
			if(ttc_str = '1')then
	-- b channel data, command frames
				ttc_data(1) <= ttc_data(2) or not div_rst_cnt(4);		
	-- a channel data, l1accept
				ttc_data(0) <= (cdrdata_q(1) xor cdrdata_q(0)) and div_rst_cnt(4);
				if(rec_frame = '0')then
					rec_cntr <= (others => '0');
				else
	-- rec_cntr counts frame length
					rec_cntr <= rec_cntr + 1;
				end if;
	-- terminates frame receiving at specified frame length
				if(div_rst_cnt(4) = '0' or rec_cntr(5 downto 3) = "101" or (fmt = '0' and rec_cntr(3 downto 0) = x"d"))then
					rec_frame <= '0';
	-- starts frame receiving when start bit encountered
				elsif(ttc_data(1) = '0')then
					rec_frame <= '1';
				end if;
	-- fmt = 0 for broadcast data
				if(or_reduce(rec_cntr) = '0')then
					fmt <= ttc_data(1);
				end if;
				sr <= sr(11 downto 0) & ttc_data(1);
				if(fmt = '0' and rec_cntr(3 downto 0) = x"e")then
	-- hamming data
					brcst_data <= sr(12 downto 5);
	-- hamming checking bits
					brcst_syn(0) <= sr(0) xor sr(5) xor sr(6) xor sr(7) xor sr(8);
					brcst_syn(1) <= sr(1) xor sr(5) xor sr(9) xor sr(10) xor sr(11);
					brcst_syn(2) <= sr(2) xor sr(6) xor sr(7) xor sr(9) xor sr(10) xor sr(12);
					brcst_syn(3) <= sr(3) xor sr(6) xor sr(8) xor sr(9) xor sr(11) xor sr(12);
					brcst_syn(4) <= xor_reduce(sr);
	-- checks for frame stop bit
					frame_err <= not ttc_data(1);
					brcst_str(0) <= '1';
				else
					brcst_str(0) <= '0';
				end if;
				single_err <= xor_reduce(brcst_syn) and not frame_err;
				if((or_reduce(brcst_syn) = '1' and xor_reduce(brcst_syn) = '0') or frame_err = '1')then
					double_err <= '1';
				else
					double_err <= '0';
				end if;
				sinerrstr <= single_err and brcst_str(1);
				dberrstr <= double_err and brcst_str(1);
				brcst_str(2) <= brcst_str(1) and not double_err;
	-- correct data if correctable
				if(brcst_syn(3 downto 0) = x"c")then
					brcst_i(7) <= not brcst_data(7);
				else
					brcst_i(7) <= brcst_data(7);
				end if;
				if(brcst_syn(3 downto 0) = x"a")then
					brcst_i(6) <= not brcst_data(6);
				else
					brcst_i(6) <= brcst_data(6);
				end if;
				if(brcst_syn(3 downto 0) = x"6")then
					brcst_i(5) <= not brcst_data(5);
				else
					brcst_i(5) <= brcst_data(5);
				end if;
				if(brcst_syn(3 downto 0) = x"e")then
					brcst_i(4) <= not brcst_data(4);
				else
					brcst_i(4) <= brcst_data(4);
				end if;
				if(brcst_syn(3 downto 0) = x"9")then
					brcst_i(3) <= not brcst_data(3);
				else
					brcst_i(3) <= brcst_data(3);
				end if;
				if(brcst_syn(3 downto 0) = x"5")then
					brcst_i(2) <= not brcst_data(2);
				else
					brcst_i(2) <= brcst_data(2);
				end if;
				if(brcst_syn(3 downto 0) = x"d")then
					evcntreset <= not brcst_data(1);
				else
					evcntreset <= brcst_data(1);
				end if;
				if(brcst_syn(3 downto 0) = x"3")then
					bcntreset <= not brcst_data(0);
				else
					bcntreset <= brcst_data(0);
				end if;
	--			--no correc lcharles
	--			brcst_i(7 downto 2) 	<= brcst_data(7 downto 2);
	--			evcntreset 				<= brcst_data(1);
	--			bcntreset 				<= brcst_data(0);
	--			--end no correc
				bcntres <= brcst_str(3) and bcntreset;
				evcntres <= brcst_str(3) and evcntreset;
				brcststr <= brcst_str(3) and or_reduce(brcst_i);
			end if;
		end if;
	end process;
	i_l1accept : srl16e
		port map (
			q 		=> l1accept,      		-- srl data output
			a0 	=> coarse_delay(0),     -- select[0] input
			a1 	=> coarse_delay(1),     -- select[1] input
			a2 	=> coarse_delay(2),     -- select[2] input
			a3 	=> coarse_delay(3),     -- select[3] input
			ce 	=> ttc_str,     			-- clock enable input
			clk 	=> cdrclk,   				-- clock input
			d 		=> ttc_data(0)        	-- srl data input
		);
	i_brcst_str1 : srl16e
		port map (
			q 		=> brcst_str(1),       	-- srl data output
			a0 	=> '1',     				-- select[0] input
			a1 	=> '0',     				-- select[1] input
			a2 	=> '0',     				-- select[2] input
			a3 	=> '0',     				-- select[3] input
			ce 	=> ttc_str,     			-- clock enable input
			clk 	=> cdrclk,   				-- clock input
			d 		=> brcst_str(0)        	-- srl data input
		);
	i_brcst_str3 : srl16e
		port map (
			q 		=> brcst_str(3),       	-- srl data output
			a0 	=> coarse_delay(0),     -- select[0] input
			a1 	=> coarse_delay(1),     -- select[1] input
			a2 	=> coarse_delay(2),     -- select[2] input
			a3 	=> coarse_delay(3),     -- select[3] input
			ce 	=> ttc_str,     			-- clock enable input
			clk 	=> cdrclk,   				-- clock input
			d 		=> brcst_str(2)        	-- srl data input
		);
	---------------******************************END DECODING**********************************----------------			
end behavioral;

