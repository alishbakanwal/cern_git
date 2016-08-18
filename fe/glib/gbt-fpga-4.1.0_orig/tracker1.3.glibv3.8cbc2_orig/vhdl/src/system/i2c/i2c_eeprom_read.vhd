library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.system_package.all;

-- clken min factor 1:2, cannot tie clken to 1
entity i2c_eeprom_read is
	generic
	(	prescaler			: positive:= 4;
		init_delay			: positive:= 1000000
	);
	port
	(
		clk					: in  	std_logic;
		reset				: in  	std_logic;
		------------------------------
		slv_addr       		: std_logic_vector(6 downto 0):="1010110";
		base_reg_addr  		: std_logic_vector(7 downto 0):=x"00";
		regs_o				: out 	array_16x8bit;
		------------------------------
		scl_wr				: out	std_logic;
		sda_rd				: in	std_logic;
		sda_wr				: out	std_logic
	); 			

end i2c_eeprom_read;

architecture behave of i2c_eeprom_read is


signal rdbit, wrbit, sclbit : std_logic;


type state_bm_type is 
( 	idle,
	start_a,
	start_b,
	start_c,
	stop_a,
	stop_b,stop_c,
	wrbit_a,
	wrbit_b,
	wrbit_c,
	rdbit_a,
	rdbit_b,
	rdbit_c,
	done
);

type i2c_state_type is
(
	idle,
	send_start,
	send_byte,
	read_ack,
	read_byte,
	send_ack,
	send_nack,
	send_stop,
	done
);

signal state_bm			: state_bm_type; 
signal state_bm_load	: state_bm_type; 
signal i2c_state		: i2c_state_type;

signal i2c_rdbyte		: std_logic_vector(7 downto 0);
signal i2c_rdack		: std_logic;
signal eeprom_rd_done 	: std_logic;

signal clk_en			: std_logic;

BEGIN


presc: process(clk,reset) -- includes an initial delay
	variable timer: positive;
begin
if reset='1' then
	timer:= init_delay-1;
	clk_en <= '0';
elsif rising_edge(clk) then
	if timer=0 then
		clk_en <= '1';
		timer:= prescaler-1;
	else
		clk_en <= '0';
		timer:= timer-1;
	end if;	
		
end if;
end process;

bit_level_operations: process(clk,reset)
	constant off			: std_logic:='1';
begin
if reset='1' then
	
	rdbit 			<= '0';
	state_bm		<= idle;
	sda_wr			<= '1';
	scl_wr 			<= '1';
	
elsif rising_edge(clk) then

	if clk_en='1' then

		case state_bm is
			--	
			when idle	 => --scl_wr <= '0';  	 			 
							state_bm <= state_bm_load;
			--
			when start_a =>				   sda_wr <= '1';    state_bm <= start_b; 
			when start_b => scl_wr <= '1'; sda_wr <= '1';    state_bm <= start_c;
			when start_c => scl_wr <= '1'; sda_wr <= '0';    state_bm <= done; sclbit <= '0';
			--
			when stop_a  => scl_wr <= '0'; sda_wr <= '0';    state_bm <= stop_b; 
			when stop_b  => scl_wr <= '1'; sda_wr <= '0';    state_bm <= stop_c;
			when stop_c  => scl_wr <= '1'; sda_wr <= '1';    state_bm <= done; sclbit <= '1';
			--
			when wrbit_a => scl_wr <= '0'; sda_wr <= wrbit;  state_bm <= wrbit_b; 
			when wrbit_b => scl_wr <= '1';                   state_bm <= wrbit_c; 
			when wrbit_c => scl_wr <= '1';                   state_bm <= done; sclbit <= '0';
			--
			when rdbit_a => scl_wr <= '0'; sda_wr <= off;    state_bm <= rdbit_b;
			when rdbit_b => scl_wr <= '1';                   state_bm <= rdbit_c; 
			when rdbit_c => scl_wr <= '1'; rdbit  <= sda_rd; state_bm <= done; sclbit <= '0'; 
			--
			when done	 => scl_wr <= sclbit;				 state_bm <= idle;		
			--
		end case;
	end if;		

end if;
end process;



master_transactions: process(clk,reset)
	constant off			: std_logic:='1';
	variable state_ctrl	: std_logic;
	variable sbitcnt		: integer range 0 to 15;
	variable rbitcnt		: integer range 0 to 15;
	variable sbyte			: std_logic_vector(7 downto 0);
	variable rbyte			: std_logic_vector(7 downto 0);
	variable sshift		: std_logic;
	variable rshift		: std_logic;
	variable next_step	: integer range 0 to 63;	

	
	
	
	
begin
if reset='1' then
	
	i2c_rdbyte		<= x"00";
	i2c_rdack		<= '0';
	i2c_state		<= idle;
	state_bm_load	<= idle;
	wrbit 			<= '0';
	eeprom_rd_done	<= '0';
	next_step		:=  0 ;
	
	regs_o (0)		<= x"00";
	regs_o (1)		<= x"00";
	regs_o (2)		<= x"00";
	regs_o (3)		<= x"00";
	regs_o (4)		<= x"00";
	regs_o (5)		<= x"00";
	regs_o (6)		<= x"00";
	regs_o (7)		<= x"00";
	regs_o (8)		<= x"00";
	regs_o (9)		<= x"00";
	regs_o (10)		<= x"00";
	regs_o (11)		<= x"00";
	regs_o (12)		<= x"00";
	regs_o (13)		<= x"00";
	regs_o (14)		<= x"00";
	regs_o (15)		<= x"00";
	
elsif rising_edge(clk) then
	
	if clk_en = '1' then
	
	
		case i2c_state is
		
			--
			when idle   =>  
				
				case next_step is
					when 0  => i2c_state <= send_start; 
					when 1  => i2c_state <= send_byte; sbitcnt:=0; sbyte:= slv_addr & '0';
					when 2  => i2c_state <= read_ack ;    
					when 3  => i2c_state <= send_byte; sbitcnt:=0; sbyte:= base_reg_addr;
					when 4  => i2c_state <= read_ack ;    
					when 5  => i2c_state <= send_start;
					when 6  => i2c_state <= send_byte; sbitcnt:=0; sbyte:= slv_addr & '1';
					when 7  => i2c_state <= read_ack ;    
					when 8  => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 9  => i2c_state <= send_ack;  regs_o (0) <= i2c_rdbyte ;
					when 10 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 11 => i2c_state <= send_ack;  regs_o (1) <= i2c_rdbyte ;	
					when 12 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 13 => i2c_state <= send_ack;  regs_o (2) <= i2c_rdbyte ;		
					when 14 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 15 => i2c_state <= send_ack;  regs_o (3) <= i2c_rdbyte ;		
					when 16 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 17 => i2c_state <= send_ack;  regs_o (4) <= i2c_rdbyte ;			
					when 18 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 19 => i2c_state <= send_ack;  regs_o (5) <= i2c_rdbyte ;	
					when 20 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 21 => i2c_state <= send_ack;  regs_o (6) <= i2c_rdbyte ;		
					when 22 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 23 => i2c_state <= send_ack;  regs_o (7) <= i2c_rdbyte ;			
					when 24 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   	
					when 25 => i2c_state <= send_ack;  regs_o (8) <= i2c_rdbyte ;				
					when 26 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 27 => i2c_state <= send_ack;  regs_o (9) <= i2c_rdbyte ;	
					when 28 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 29 => i2c_state <= send_ack;  regs_o(10) <= i2c_rdbyte ;		
					when 30 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 31 => i2c_state <= send_ack;  regs_o(11) <= i2c_rdbyte ;		
					when 32 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 33 => i2c_state <= send_ack;  regs_o(12) <= i2c_rdbyte ;	
					when 34 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 35 => i2c_state <= send_ack;  regs_o(13) <= i2c_rdbyte ;		
					when 36 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 37 => i2c_state <= send_ack;  regs_o(14) <= i2c_rdbyte ;		
					when 38 => i2c_state <= read_byte; rbitcnt:=0; rbyte:= x"00";   
					when 39 => i2c_state <= send_nack; regs_o(15) <= i2c_rdbyte ;		
					when 40 => i2c_state <= send_stop; eeprom_rd_done <= '1';
					when others =>
				end case;	
			
			if eeprom_rd_done = '0' then
				next_step:=next_step+1;
			end if;	
		
			--
			when send_start  => 
			
				
				if state_bm=idle then state_bm_load <= start_a; 					end if;
				if state_bm=done then state_bm_load <= idle   ; i2c_state <= done; 	end if;
			--
			when send_byte =>   
			--
				if state_bm=idle then state_bm_load <= wrbit_a; wrbit <= sbyte(7); sshift:='1'; end if; 
				if state_bm=done then
					if sbitcnt<7 then
						if sshift='1' then 
							sbyte	:=sbyte(6 downto 0) & '0'; 
							sbitcnt :=sbitcnt+1; 
						end	if;
						sshift:='0';
					else						
						state_bm_load	<= idle; 
						i2c_state 		<= done; 	
					end if;
				end if;
			--
			when read_ack  =>	
			--
				if state_bm=idle then state_bm_load	<= rdbit_a; 					end if; 
				if state_bm=done then state_bm_load <= idle   ; i2c_state <= done; 	
																i2c_rdack <= rdbit;	end if;	
				
			--
			when read_byte =>
			--
				if state_bm=idle then state_bm_load <= rdbit_a; rshift:='1';  end if; 
				if state_bm=done then
					if rbitcnt<7 then
						if rshift='1' then 
							rbyte	 :=rbyte(6 downto 0) & rdbit; 
							rbitcnt  :=rbitcnt+1; 
						end	if;
						rshift:='0';
					else
						state_bm_load 	<= idle; 
						i2c_state 		<= done; 
						i2c_rdbyte		<= rbyte(6 downto 0) & rdbit; 	
					end if;
				end if;
				
			--
			when send_ack  => 	
			--
				if state_bm=idle then state_bm_load <= wrbit_a; wrbit     <= '0';  	end if; 
				if state_bm=done then state_bm_load <= idle   ; i2c_state <= done; 	end if;
			--
			when send_nack =>  	
			--
				if state_bm=idle then state_bm_load <= wrbit_a; wrbit     <= '1'; 	end if;
				if state_bm=done then state_bm_load <= idle   ; i2c_state <= done; 	end if;
			--
			when send_stop =>  	
			--
				if state_bm=idle then state_bm_load <= stop_a;  					end if;
				if state_bm=done then state_bm_load <= idle   ; i2c_state <= done; 	end if;
			--
			when done	=> 
			--
				state_bm_load <= idle;
				i2c_state 	  <= idle;
			
			when others =>	
		end case;	
	end if;
end if;
end process;


end behave;