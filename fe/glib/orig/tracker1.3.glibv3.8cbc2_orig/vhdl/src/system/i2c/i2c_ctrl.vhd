--------------------------------------------------
-- File:		I2Cmaster_data.vhd
-- Author:		P.Vichoudis
--------------------------------------------------
-- Description:	the control part of the I2C master
--------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;

ENTITY i2c_ctrl IS
	PORT
	(
		clk				: in  	std_logic;
		reset				: in  	std_logic;
		------------------------------
		enable			: in  	std_logic;
		------------------------------
		clkprescaler	: in  	std_logic_vector(9 downto 0);
		executestrobe	: in  	std_logic;
		ralmode			: in  	std_logic;
		extmode			: in  	std_logic;
		slaveaddress	: in  	std_logic_vector(7 downto 0);
		slaveregister	: in  	std_logic_vector(7 downto 0);
		datatoslave		: in  	std_logic_vector(7 downto 0);
		writetoslave	: in  	std_logic;	
		------------------------------
		startclk			: out  	std_logic;
		execstart		: out 	std_logic;
		execstop			: out 	std_logic;
		execwr			: out 	std_logic;
		execgetack		: out 	std_logic;
		execrd			: out 	std_logic;
		execsendack		: out 	std_logic;
		bytetowrite		: out 	std_logic_vector(7 downto 0);
		byteread			: in  	std_logic_vector(7 downto 0);
		bytereaddv		: in  	std_logic;
		------------------------------
		completed		: in  	std_logic;
		failed			: in  	std_logic;
		------------------------------
		busy_o			: out		std_logic;
		done_o			: out		std_logic;
		reply_o			: out		std_logic_vector(31 downto 0)

		
	); 			

END i2c_ctrl;

ARCHITECTURE behave OF i2c_ctrl IS



signal enable_reg		: std_logic;

signal executestrobe_reg: std_logic;
signal slaveaddress_reg	: std_logic_vector(7 downto 0);
signal slaveregister_reg: std_logic_vector(7 downto 0);
signal datatoslave_reg	: std_logic_vector(7 downto 0);
signal writetoslave_reg	: std_logic;	
signal clkprescaler_reg	: std_logic_vector(9 downto 0);
signal ralmode_reg		: std_logic;
signal extmode_reg		: std_logic;
signal numberofbytes_reg: std_logic_vector(3 downto 0);
-------------------------
signal exec					: std_logic;
signal addr					: std_logic_vector(7 downto 0);
signal reg					: std_logic_vector(7 downto 0);
signal wrdata				: std_logic_vector(7 downto 0);
signal wr					: std_logic;
signal ral					: std_logic;
signal extm					: std_logic;
signal rddata				: std_logic_vector(7 downto 0);	
signal extrddata			: std_logic_vector(7 downto 0);	
-------------------------
signal done					: std_logic;
signal busy					: std_logic;
signal error_rdack1		: std_logic;		
signal error_rdack2		: std_logic;		
signal error_rdack3		: std_logic;		
signal error_rdack4		: std_logic;		
signal error				: std_logic;
signal reply				: std_logic_vector(31 downto 0);
-------------------------















type ctrlfsm_type	is 
(idle, 
req_startclk, 
req_start_1,
req_chipaddr_1,
req_getack_1,
req_regaddr,
req_getack_2,
req_wrdata,
req_getack_3,
req_stop_1,
req_start_2,
req_chipaddr_2,
req_getack_4,
req_rddata,
req_sendack,
req_stop_2
);
signal ctrlfsm		: ctrlfsm_type;
signal ctrlfsmprev	: ctrlfsm_type;

type chopexecfsm_type	is (idle,a,b);
signal chopexecfsm	:chopexecfsm_type;


BEGIN
--========================--
reg_in:process(clk, reset)
--========================--
-- registers the input
-- signals
--========================--
	variable ff, ff0, ff1,ff2,ff3,ff4: std_logic;
	
begin
if reset='1' then

	enable_reg			<= '0'; ff:='0';
	executestrobe_reg	<= '0';
	slaveaddress_reg	<= (others=>'0');
	slaveregister_reg	<= (others=>'0');
	datatoslave_reg	<= (others=>'0');
	writetoslave_reg	<= '0';
	clkprescaler_reg	<= (others=>'0');
	ralmode_reg			<= '0';
	extmode_reg			<= '0';
	ff:='0'; ff4:='0'; ff3:='0'; ff2:='0'; ff1:='0'; ff0:='0';
	
elsif clk'event and clk='1' then

	enable_reg			<= ff; ff:=enable; -- 1clk delay
	executestrobe_reg	<= ff3;ff3:=ff2; ff2:=ff1; ff1:=ff0; ff0:=executestrobe; --4clk delay
	slaveaddress_reg	<= slaveaddress;
	slaveregister_reg	<= slaveregister;
	datatoslave_reg	<= datatoslave;
	writetoslave_reg	<= writetoslave;
	clkprescaler_reg	<= clkprescaler;
	ralmode_reg			<= ralmode;
	extmode_reg			<= extmode;
end if;		
end process;


--========================--
i2creg:process(clk, reset)
--========================--
-- latches the i2ctransaction
-- parameters
--========================--	
	variable timer: std_logic_vector(9 downto 0);
begin
if reset='1' then

	exec				<= '0';
	addr				<= (others=>'0');
	reg				<= (others=>'0');
	wrdata			<= (others=>'0');
	wr					<= '0';
	ral				<= '0';
	extm				<= '0';
	chopexecfsm 	<= idle;
	
elsif clk'event and clk='1' then

	case chopexecfsm is

		--=========--
		when idle =>
		--=========--
			exec <= '0';
			if executestrobe_reg='1' then 
				chopexecfsm		<=  a ;		  
				timer				:= clkprescaler_reg;
				---------------------------------
				exec 				<= '1';
				addr				<= slaveaddress_reg;
				reg				<= slaveregister_reg;
				wrdata			<= datatoslave_reg;
				wr					<= writetoslave_reg;
				ral				<= ralmode_reg;
				extm				<= extmode_reg;
			end if;	
		
		--=========--
		when a =>
		--=========--
			if timer=0 then
				exec 			<= '0';
				chopexecfsm		<=  b ;		  
			else
				exec 			<= '1';
				timer			:=timer-1;
			end if;
		
		--=========--
		when b =>	
		--=========--
			exec <= '0';
			if executestrobe_reg='0' then 
				chopexecfsm		<= idle;		  
			end if;	
	end case;
end if;		
end process;


--========================--
main:process(clk, reset)
--========================--

variable timer				: std_logic_vector(9 downto 0);
variable stdWR, stdRD  	: std_logic;
variable ralWR, ralRD	: std_logic;
variable extRD				: std_logic;
variable cnt				: integer range 0 to 7;
variable extmflag			: std_logic;
variable startclkfsm		: std_logic;
variable interrupted		: std_logic;
variable clkhasstarted	: std_logic;

begin
if reset='1' then

	ctrlfsm		<= idle; ctrlfsmprev <= idle;
	startclk		<= '0';
	execstart	<= '0';
	execstop		<= '0'; 
	execwr		<= '0';
	execgetack	<= '0';
	execrd		<= '0';	
	execsendack	<= '0'; 

	busy 		<= '0';
	done		<= '0';
	error		<= '0'; 	interrupted := '0';
	-------------------
	error_rdack1<= '0';
	error_rdack2<= '0';
	error_rdack3<= '0';
	error_rdack4<= '0';
	-------------------

	clkhasstarted:='0';

	stdWR 		:= '0';
	stdRD 		:= '0';
	ralWR 		:= '0';
	ralWR 		:= '0';
	extRD			:= '0';
	extmflag		:= '0';
	
elsif clk'event and clk='1' then

	if bytereaddv='1' then
		extrddata 	<= rddata;
		rddata 		<= byteread;
	end if;

	execstart	<= '0';
	execstop		<= '0';
	execwr		<= '0';
	execgetack	<= '0';
	execrd		<= '0';
	execsendack	<= '0';
	
	if enable_reg='1' then
		--=================--
		-- error handling		
		--=================--
		if failed='1' then 
			interrupted := '1'; 
			-------------------
			--intividual report
			-------------------
			if ctrlfsmprev=req_getack_1 then
				error_rdack1<= '1';
				error_rdack2<= '0';
				error_rdack3<= '0';
				error_rdack4<= '0';
			elsif ctrlfsmprev=req_getack_2 then
				error_rdack1<= '0';
				error_rdack2<= '1';
				error_rdack3<= '0';
				error_rdack4<= '0';
			elsif ctrlfsmprev=req_getack_3 then
				error_rdack1<= '0';
				error_rdack2<= '0';
				error_rdack3<= '1';
				error_rdack4<= '0';
			elsif ctrlfsmprev=req_getack_4 then
				error_rdack1<= '0';
				error_rdack2<= '0';
				error_rdack3<= '0';
				error_rdack4<= '1';
			end if;		
			ctrlfsm <= req_stop_2;
		end if;
		
		if timer=1 then
			
			--=================--
			-- main routine		
			--=================--
			timer := clkprescaler_reg;
			
			case ctrlfsm is
				--=============--
				when idle =>
				--=============--
					interrupted := '0';
					--done			<= '0';
					busy			<= '0';
					if exec='1' then
						-------------------
						-- init report
						-------------------
						done			<= '0';
						busy			<= '1';
						error			<= '0';
						error_rdack1<= '0';
						error_rdack2<= '0';
						error_rdack3<= '0';
						error_rdack4<= '0';
						-------------------
						-- set mode
						-------------------
						if ral='1' and wr='1' then
							stdWR := '0';
							stdRD := '0';
							ralWR := '1';
							ralRD := '0';
							extRD := '0';
						elsif ral='1' and wr='0' then
							stdWR := '0';
							stdRD := '0';
							ralWR := '0';
							ralRD := '1';
							extRD := '0';
						elsif extm='1' and wr='0' then
							stdWR := '0';
							stdRD := '0';
							ralWR := '0';
							ralRD := '0';
							extRD := '1';
						elsif wr='1' then
							stdWR := '1';
							stdRD := '0';
							ralWR := '0';
							ralRD := '0';
							extRD := '0';
						elsif wr='0' then
							stdWR := '0';
							stdRD := '1';
							ralWR := '0';
							ralRD := '0';
							extRD := '0';
						end if;
						extmflag	:= extm;		
						-------------------
						-- startclk once
						-------------------
						if clkhasstarted='0' then
							ctrlfsm <= req_startclk; 	ctrlfsmprev <= idle;
							clkhasstarted:='1';
						else
							ctrlfsm <= req_start_1;	 	ctrlfsmprev <= idle;
						end if;
						-------------------
					end if;
			
				--=============--
				when req_startclk =>
				--=============--
					startclk	<= '1';
					ctrlfsm		<= req_start_1; 		ctrlfsmprev <= req_startclk;
						
			
				--=============--
				when req_start_1 =>
				--=============--
					startclk	<= '0';
					execstart 	<= '1';
					ctrlfsm		<= req_chipaddr_1; 		ctrlfsmprev <= req_start_1;
					cnt			:= 7;
					
				--=============--
				when req_chipaddr_1 =>
				--=============--
					bytetowrite(7 downto 1) <= addr(6 downto 0);
					bytetowrite(0) <= '0';
					if stdRD='1' then
						bytetowrite(0) <= '1';
					end if;	
					
					if cnt=0 then
						cnt			:= 7;
						ctrlfsm		<= req_getack_1; 	ctrlfsmprev <= req_chipaddr_1;
					else
						if cnt=7 then execwr<= '1'; end if;
						cnt:=cnt-1;
					end if;
					
				--=============--
				when req_getack_1 =>
				--=============--	
					execgetack 	<= '1';
					if    ralWR='1' then
						ctrlfsm		<= req_regaddr; 	ctrlfsmprev <= req_getack_1;
					elsif ralRD='1' then
						ctrlfsm		<= req_regaddr; 	ctrlfsmprev <= req_getack_1;
					elsif stdWR='1' then
						ctrlfsm		<= req_wrdata;  	ctrlfsmprev <= req_getack_1;
					elsif stdRD='1' then
						ctrlfsm		<= req_rddata;  	ctrlfsmprev <= req_getack_1;
					elsif extRD='1' then
						ctrlfsm		<= req_wrdata;  	ctrlfsmprev <= req_getack_1;
					end if;
					
				--=============--
				when req_regaddr =>
				--=============--
					bytetowrite <= reg; --reg(6 downto 0) & ralRD;
					if cnt=0 then
						cnt			:= 7;
						ctrlfsm		<= req_getack_2;	ctrlfsmprev <= req_regaddr;
					else
						if cnt=7 then execwr<= '1'; end if;
						cnt:=cnt-1;
					end if;
					
				--=============--
				when req_getack_2 =>
				--=============--
					execgetack 	<= '1';
					if    ralWR='1' then
						ctrlfsm		<= req_wrdata;		ctrlfsmprev <= req_getack_2;
					elsif ralRD='1' then
					--	ctrlfsm		<= req_stop_1;		ctrlfsmprev <= req_getack_2;
						ctrlfsm		<= req_start_2;	ctrlfsmprev <= req_getack_2;
					end if;

				--=============--
				when req_wrdata =>
				--=============--
					bytetowrite <= wrdata;
					if cnt=0 then
						cnt			:= 7;
						ctrlfsm		<= req_getack_3;	ctrlfsmprev <= req_wrdata;
					else
						if cnt=7 then execwr<= '1'; end if;
						cnt:=cnt-1;
					end if;
					
				--=============--
				when req_getack_3 =>
				--=============--
					execgetack 	<= '1';
					ctrlfsm		<= req_stop_2;			ctrlfsmprev <= req_getack_3;
					if extRD = '1' then
						ctrlfsm		<= req_start_2;
					end if;
					
				--=============--
				when req_stop_1 =>
				--=============--
					execstop 	<= '1';
					ctrlfsm		<= req_start_2;			ctrlfsmprev <= req_stop_1;

				--=============--
				when req_start_2 =>
				--=============--
					execstart 	<= '1';
					ctrlfsm		<= req_chipaddr_2;		ctrlfsmprev <= req_start_2;

				--=============--
				when req_chipaddr_2 =>
				--=============--
					bytetowrite <= addr(6 downto 0) & '1';
					if cnt=0 then
						cnt			:= 7;
						ctrlfsm		<= req_getack_4;	ctrlfsmprev <= req_chipaddr_2;
					else
						if cnt=7 then execwr<= '1'; end if;
						cnt:=cnt-1;
					end if;

				--=============--
				when req_getack_4 =>
				--=============--
					execgetack 	<= '1';
					ctrlfsm		<= req_rddata;			ctrlfsmprev <= req_getack_4;

				--=============--
				when req_rddata =>
				--=============--
					if cnt=0 then
						cnt			:= 7;
						ctrlfsm		<= req_sendack;		ctrlfsmprev <= req_rddata;
					else
						if cnt=7 then execrd<= '1'; end if;
						cnt:=cnt-1;
					end if;
					
				--=============--
				when req_sendack =>
				--=============--
					execsendack	<= '1'; 
					ctrlfsm		<= req_stop_2;			ctrlfsmprev <= req_sendack;
						
					

				--=============--
				when req_stop_2 =>
				--=============--
					execstop 	<= '1';	
					ctrlfsm		<= idle;				ctrlfsmprev <= req_stop_2;
					if interrupted='0' then 
						if extmflag = '1' then
							ctrlfsm	<= req_start_1;
							extmflag	:= '0';
						else
							done<= '1';error<='0';
						end if;
					else
						done<= '1';error<='1';
					end if;
			end case;

-- state		   |stdWR|stdRD|ralWR|ralRD|extRD
---------------+-----+-----+-----+-----+------
-- start_1		|	X	|	X	|	X	|	X	|  X
-- chipaddr_1	|	X+0|	X+1|	X+0|	X+0|  X+0
-- getack_1		|	X	|	X	|	X	|	X  |  X
---------------+-----+-----+-----+-----+------
-- regaddr_1	|	 	|    	|	X	|	X  |  
-- getack_2		|    	|    	|	X	|	X  |  
---------------+-----+-----+-----+-----+------
-- wrdata		|	X	|    	|	X	|     |  X
-- getack_3		|	X	|    	|	X	|     |  X
---------------+-----+-----+-----+-----+------
-- stop1		   |    	|    	|    	|	X  |
-- start_2		|	 	|    	|    	|	X  |  X
-- chipaddr_2	|	 	|    	|    	|	X+1|  X+1
-- getack_4		|    	|    	|    	|	X  |  X
---------------+-----+-----+-----+-----+------
-- rddata		|	 	|	X	|    	|	X  |  X
-- sendack		|    	|	X	|    	|	X  |  X
---------------+-----+-----+-----+-----+------
-- stop2		   |	X	|	X	|	X	|	X  |  X -> loop
		                            
		
		
		else	
			timer 	 := timer-1;
		end if;		
	else
		timer 		 := clkprescaler_reg;
		clkhasstarted:='0';
	end if;

end if;
end process;








--===========================================
-- output values
--===========================================
REPLY_O 		<= reply;

--===============--
process(clk, reset)
--===============--
	variable done_prev : std_logic;
begin
if reset='1' then
	reply	 			<=	(others =>'0');
	done_prev		:= '0';
elsif clk'event and clk='1' then

	DONE_O		<= done;
	BUSY_O		<= busy;

	
	if chopexecfsm	= a then		  

		reply(31)				<= '0'; -- very fast reaction for clearing immediately the error bits (no prescaling)
		reply(30)				<= '0'; -- very fast reaction for clearing immediately the error bits (no prescaling)
		reply(29)				<= '0'; -- very fast reaction for clearing immediately the error bits (no prescaling)
		reply(28)				<= '0'; -- very fast reaction for clearing immediately the error bits (no prescaling)
		reply(27)				<= '0'; -- very fast reaction for clearing immediately the error bits (no prescaling)
		reply(26)				<= '0'; -- very fast reaction for clearing immediately the done  bit  (no prescaling)
		reply(25)				<= extm;
		reply(24)				<= ral;
		reply(23) 				<= wr;
		
		reply(22 downto 16) 	<= addr(6 downto 0);
		reply(15 downto  8)	<= reg;		if extm='1'	then reply(15 downto 8)	<= extrddata; 	end if;
		reply(7 downto 0)		<= rddata; 	if wr='1' 	then reply(	7 downto 0)	<= wrdata;		end if;
	
	elsif done='1' and done_prev='0' then	-- update the contents only at the rising edge	of done

		reply(31)				<= error_rdack4;
		reply(30)				<= error_rdack3;
		reply(29)				<= error_rdack2;
		reply(28)				<= error_rdack1;
		reply(27)				<= error;
		reply(26)				<= '1';
		reply(25)				<= extm;
		reply(24)				<= ral;
		reply(23) 				<= wr;
		
		reply(22 downto 16) 	<= addr(6 downto 0);
		reply(15 downto  8)	<= reg;		if extm='1'	then reply(15 downto 8)	<= extrddata; 	end if;
		reply(7 downto 0)		<= rddata; 	if wr='1' 	then reply(	7 downto 0)	<= wrdata;		end if;
	
	end if;
	
	done_prev := done;
	
end if;
end process;
--===========================================













END behave;