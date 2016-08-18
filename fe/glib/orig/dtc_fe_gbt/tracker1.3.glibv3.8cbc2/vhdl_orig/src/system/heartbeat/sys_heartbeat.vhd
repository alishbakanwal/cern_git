library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;

use work.system_package.all;

-------------------------------------------------------------------------------
-- Entity declaration for the example design
-------------------------------------------------------------------------------

----============--
entity sys_heartbeat is
----============--
  generic
  (
		step_cnt_size		: integer range 0 to 23	   := 21;
		upper_limit			: integer range 0 to 99    := 20;
		lower_limit			: integer range 0 to 99    :=  0;
		pwm_dc_index		: integer range 1 to  8    :=  8
		---------------------------------------------
		-- luminosity     : from [0/8]% to [20/8)% and back in 2*[30-0] steps of [2^21] clks
		---------------------------------------------
  );
   port(
		reset_i			   : in  std_logic;								
		clk_i				   : in  std_logic;	
		heartbeat_o       : out std_logic
   );
end sys_heartbeat;
----============--


architecture heartbeat_arch of sys_heartbeat is

begin

	--===================--
	heartbeat_process: process(clk_i, reset_i)
	--===================--
 
      constant step_pwm_maxcnt 	: integer range 0 to pwm_dc_index*100-1:= pwm_dc_index*100-1;
      variable step_pwm_cnt 		: integer range 0 to pwm_dc_index*100-1:= pwm_dc_index*100-1;
      variable step_pwm_dc			: integer range 0 to upper_limit-1;
		variable step_pwm_status	: std_logic;
		variable step_pwm_dir		: std_logic;
	
		constant timeout    			: integer        :=  2**step_cnt_size-1;
		variable timer     			: integer range 0 to 2**step_cnt_size-1;
		
	begin
	
   if (reset_i = '1') then
		
      timer          :=  0 ;
      step_pwm_dc		:=  0 ;
		step_pwm_dir	:= '0';
		
		
   elsif (clk_i = '1' and clk_i'event) then
		
		heartbeat_o		<= step_pwm_status; -- and global pwm
		
		--===== step pwm ========--   
      if step_pwm_cnt < step_pwm_dc then   
         step_pwm_status 	:= '1';
      else
         step_pwm_status 	:= '0';
      end if;
      if step_pwm_cnt=0 then
 			step_pwm_cnt   	:= step_pwm_maxcnt; 
		else
			step_pwm_cnt   	:= step_pwm_cnt - 1;
		end if;
		--===== step pwm ========--   
      
		
		--===== step timer ======--   
      if timer=0 	then
			timer					:= timeout;
			
			if step_pwm_dc     = upper_limit-1 then 		--==== upper limit ====--
				step_pwm_dir  	:= '1'; 							--> set direction to down 	
				step_pwm_dc   	:= step_pwm_dc-1;				--> count down
			
			elsif step_pwm_dc  = lower_limit   then 		--==== lower limit ====--
				step_pwm_dir	:= '0';							--> set direction to up 
				step_pwm_dc 	:= step_pwm_dc+1; 			--> count up
			
			elsif step_pwm_dir = '1' 				then 		--==== downwards   ====--
				step_pwm_dc 	:= step_pwm_dc-1; 			--> keep counting down
			
			elsif step_pwm_dir = '0' 				then 		--==== upwards     ====--
				step_pwm_dc		:= step_pwm_dc+1; 			--> keep counting up
			
			end if;
		else
			timer			:= timer - 1;
		end if;
		--===== step timer ======--   
      
   end if;
	end process;
end heartbeat_arch;