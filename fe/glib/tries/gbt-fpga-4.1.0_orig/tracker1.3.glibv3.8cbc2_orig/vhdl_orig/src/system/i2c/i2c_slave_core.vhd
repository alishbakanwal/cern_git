library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.system_package.all;

entity i2c_slave_core is
	port
	(
		clk			: in  	std_logic;
		reset			: in  	std_logic;
		slv_addr		: in  	std_logic_vector(6 downto 0);
		
		regs_i		: in 		array_16x8bit;
		regs_o		: out 	array_16x8bit;
		
		scl_rd		: in	std_logic;
		sda_rd		: in	std_logic;
		sda_wr		: out	std_logic
	); 			

end i2c_slave_core;

architecture behave of i2c_slave_core is

	signal sda_curr		: std_logic;
	signal sda_prev		: std_logic;
	signal scl_curr		: std_logic;
	signal scl_prev		: std_logic;

	signal scl_rising		: std_logic;
	signal scl_falling	: std_logic;

	signal start_cond		: std_logic;
	signal stop_cond		: std_logic;

type i2c_state_type is
(
	idle,  			
	start, 			
	read_slv_addr,	
	check_slv_addr,	
	read_reg_addr,	
	send_reg_addr_ack,
	read_byte,		
	send_byte_ack,	
	send_byte,		
	read_byte_ack,	
	check_byte_ack,
	stop
);		
	
signal i2c_state: i2c_state_type;				

type state_bs_type is
(
	idle,
	start,
	send_byte,
	read_byte,
	read_ack,
	send_ack,
	stop,
	done
);

signal state_bs		: state_bs_type;
signal state_bs_load	: state_bs_type;

signal rxbyte			: std_logic_vector(7 downto 0);
signal rxack			: std_logic;
signal txbyte			: std_logic_vector(7 downto 0);
signal bitcnt			: integer range 0 to 15;

signal rx_slv_addr	: std_logic_vector(6 downto 0);
signal wr				: std_logic;
signal ack				: std_logic;
				


signal addr				: std_logic_vector(7 downto 0);
signal wdata			: std_logic_vector(7 downto 0);
signal rdata			: std_logic_vector(7 downto 0);
signal wren				: std_logic;

signal regs				: array_16x8bit;
	
			
BEGIN


				
bit_level_operations: process(clk,reset)
begin
if reset='1' then
	
	sda_curr 	<= '0'; 
	sda_prev 	<= '0';
	scl_curr 	<= '0';
	scl_prev 	<= '0';
	scl_rising	<= '0';
	scl_falling	<= '0';
	start_cond  <= '0';
	stop_cond	<= '0';
	
	sda_wr 		<= '1';
	
elsif rising_edge(clk) then

	scl_rising  <= '0'; 	if scl_curr='1' and scl_prev='0' then scl_rising  <= '1'; end if;
	scl_falling <= '0';	if scl_curr='0' and scl_prev='1' then scl_falling <= '1'; end if;
	stop_cond 	<= '0'; 	if sda_curr='1' and sda_prev='0' and scl_curr='1' and scl_prev='1' then stop_cond  <= '1'; end if;
	start_cond	<= '0';	if sda_curr='0' and sda_prev='1' and scl_curr='1' and scl_prev='1' then start_cond <= '1'; end if;
	
	sda_prev <= sda_curr; sda_curr <= sda_rd;
	scl_prev <= scl_curr; scl_curr <= scl_rd;
	
	if stop_cond ='1' then 
			state_bs 	<= stop;
	elsif start_cond ='1' then
		state_bs 		<= idle;
	else
		case state_bs is
		
			--
			when idle   	=> state_bs <= state_bs_load; rxbyte <= x"00"; txbyte <= rdata; bitcnt<= 0;
			--
			when start  	=> if scl_falling='1' then state_bs <= done; sda_wr <= '1'; end if;
			--
			when send_byte 	=>   
			--
				if bitcnt<8 then
					if scl_falling='1' then
						sda_wr <= txbyte(7); txbyte <= txbyte(6 downto 0) & '0';
						bitcnt <= bitcnt+1;
					end if;	
				elsif scl_rising='1' then
					state_bs <= done;
				end if;

			--
			when read_ack  	=>	if scl_falling='1' then sda_wr <= '1'; 								end if;
										if scl_rising ='1' then rxack <= sda_curr; state_bs <= done; 	end if;	
			--
			when read_byte 	=>	if scl_falling='1' then sda_wr <= '1'; 								end if;
			--
				if bitcnt<8 then
					if scl_rising='1' then
						rxbyte <= rxbyte(6 downto 0) & sda_curr;
						bitcnt <= bitcnt+1;
					end if;	
				else
					state_bs <= done;
				end if;
				
			--
			when send_ack  	=> 	if scl_falling='1' then sda_wr   <= '0';  end if;
											if scl_rising ='1' then state_bs <= done; end if;
			--
			when stop 		=>  sda_wr <= '1';	state_bs <= done; 	
			--
			when done		=>  state_bs <= idle; 	

			when others 	=>	
		end case;
	end if;	
end if;	
end process;



main: process(clk,reset)
begin
if reset='1' then
	
	i2c_state 	<= idle;
	wren 		<= '0'; 
		
elsif rising_edge(clk) then
	
	wren <= '0'; 
	state_bs_load 	<= idle;
	if stop_cond ='1' then 
		i2c_state 		<= stop;
	elsif start_cond ='1' then
		i2c_state 		<= start;
	else
		case i2c_state is
			--
			when idle  					=>
			--
			when start 					=> if state_bs = idle 			then state_bs_load 	<= start;				end if;
												if state_bs = done 			then i2c_state 		<= read_slv_addr; 	end if;
			--
			when read_slv_addr		=> if state_bs = idle 			then state_bs_load 	<= read_byte;			end if;
												if state_bs = done 			then i2c_state 		<= check_slv_addr;  	rx_slv_addr <= rxbyte(7 downto 1); wr <= not rxbyte(0); end if;
			--
			when check_slv_addr		=> if rx_slv_addr/=slv_addr 	then 
												if state_bs = idle 			then state_bs_load 	<= stop;					end if;
												if state_bs = done 			then i2c_state 		<= stop; 				end if;
											elsif wr='0' 						then 
												if state_bs = idle 			then state_bs_load 	<= send_ack;			end if;
												if state_bs = done 			then i2c_state			<= send_byte;			end if;
											elsif wr='1' 						then 
												if state_bs = idle 			then state_bs_load 	<= send_ack;			end if;
												if state_bs = done 			then i2c_state		<= read_reg_addr;			end if;
											end if;	
			--	
			when read_reg_addr		=> if state_bs = idle 			then state_bs_load 	<= read_byte;			end if;
												if state_bs = done 			then i2c_state 		<= send_reg_addr_ack;addr 	<= rxbyte; end if;
			--
			when send_reg_addr_ack	=> if state_bs = idle 			then state_bs_load 	<= send_ack;			end if;
												if state_bs = done 			then i2c_state 		<= read_byte;    		end if;
			--
			when read_byte				=> if state_bs = idle 			then state_bs_load 	<= read_byte;			end if;
												if state_bs = done 			then i2c_state 		<= send_byte_ack;   	wdata 	<= rxbyte; wren <= '1'; end if;
			--
			when send_byte_ack		=> if state_bs = idle 			then state_bs_load 	<= send_ack;			end if;
												if state_bs = done 			then i2c_state 		<= read_byte;    		addr   	<= addr+1; end if;
			--
			when send_byte				=>	if state_bs = idle 			then state_bs_load 	<= send_byte;			end if;
												if state_bs = done 			then i2c_state 		<= read_byte_ack; 	end if;
			--
			when read_byte_ack		=> if state_bs = idle 			then state_bs_load 	<= read_ack;			end if;
												if state_bs = done 			then i2c_state 		<= check_byte_ack; 	ack	   	<= rxack;  end if;	
			--
			when check_byte_ack		=> if ack = '0' 					then 
													addr			<= addr+1;
													i2c_state 	<= send_byte; 
												end if;	
			--	
			when stop					=>	
	
		end case;

	end if;

end if;	
end process;


regs_fsm: process(clk,reset)
begin
if reset='1' then

	regs(0)	<= regs_i(0);
	regs(1)	<= regs_i(1);
	regs(2)	<= regs_i(2);
	regs(3)	<= regs_i(3);
	regs(4)	<= regs_i(4);
	regs(5)	<= regs_i(5);
	regs(6)	<= regs_i(6);
	regs(7)	<= regs_i(7);
	regs(8)	<= regs_i(8);
	regs(9)	<= regs_i(9);
	regs(10)	<= regs_i(10);
	regs(11)	<= regs_i(11);
	regs(12)	<= regs_i(12);
	regs(13)	<= regs_i(13);
	regs(14)	<= regs_i(14);
	regs(15)	<= regs_i(15);
	

elsif rising_edge(clk) then
	
	if wren = '1' then
		case addr is
			when x"00" => regs(0)	<= wdata;
			when x"01" => regs(1)	<= wdata;
			when x"02" => regs(2)	<= wdata;
			when x"03" => regs(3)	<= wdata;
			when x"04" => regs(4)	<= wdata;
			when x"05" => regs(5)	<= wdata;
			when x"06" => regs(6)	<= wdata;
			when x"07" => regs(7)	<= wdata;
			when x"08" => regs(8)	<= wdata;
			when x"09" => regs(9)	<= wdata;
			when x"0A" => regs(10)	<= wdata;
			when x"0B" => regs(11)	<= wdata;
			when x"0C" => regs(12)	<= wdata;
			when x"0D" => regs(13)	<= wdata;
			when x"0E" => regs(14)	<= wdata;
			when x"0F" => regs(15)	<= wdata;
			when others =>	
		end case;
	else
		case addr is
			when x"00" => rdata <= regs(0)	;
			when x"01" => rdata <= regs(1)	;
			when x"02" => rdata <= regs(2)	;
			when x"03" => rdata <= regs(3)	;
			when x"04" => rdata <= regs(4)	;
			when x"05" => rdata <= regs(5)	;
			when x"06" => rdata <= regs(6)	;
			when x"07" => rdata <= regs(7)	;
			when x"08" => rdata <= regs(8)	;
			when x"09" => rdata <= regs(9)	;
			when x"0A" => rdata <= regs(10)	;
			when x"0B" => rdata <= regs(11)	;
			when x"0C" => rdata <= regs(12)	;
			when x"0D" => rdata <= regs(13)	;
			when x"0E" => rdata <= regs(14)	;
			when x"0F" => rdata <= regs(15)	;
			when others =>	   
		end case;
	
	
	
	end if;


end if;
end process;

regs_o <= regs;


end behave;