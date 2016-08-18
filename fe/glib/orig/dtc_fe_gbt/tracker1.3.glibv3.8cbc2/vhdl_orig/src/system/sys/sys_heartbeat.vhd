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
		toggle_frequency	: integer := 40000000;
      pwm_duty_cycle    : integer range 0 to 100 := pwm_duty_cycle
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
		variable timer     : integer;
      variable timer_hb  : std_logic;
      
      variable pwm_timer : integer;
      variable pwm_status: std_logic;
	begin
	
   if (reset_i = '1') then
		
      timer_hb       := '0';
      timer          := toggle_frequency;  
      pwm_status     := '0';
      pwm_timer      := 99 ;
      
   elsif (clk_i = '1' and clk_i'event) then
      
		
     
      --===== heartbeat ========--   
      heartbeat_o <= timer_hb and pwm_status;
		
      --===== pwm_stage ========--   
      if pwm_timer<pwm_duty_cycle then   
         pwm_status := '1';
      else
         pwm_status := '0';
      end if;

      if pwm_timer=0 then
 			pwm_timer   := 99; 
		else
			pwm_timer   := pwm_timer - 1;
		end if;
      
      --===== global timer =====--   
      if timer=0 then
      	timer_hb    := not timer_hb;
			timer       := toggle_frequency; 
		else
			timer:= timer - 1;
		end if;
	
   end if;
	end process;
end heartbeat_arch;