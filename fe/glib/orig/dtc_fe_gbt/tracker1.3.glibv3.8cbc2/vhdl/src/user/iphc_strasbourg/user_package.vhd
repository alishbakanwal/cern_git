library ieee;
use ieee.std_logic_1164.all;
 
package 			user_package is

	--=== system pcie ========--
   constant sys_pcie_enable         : boolean  := false;   
   
   -- (Note!! Add user_sys_pcie_constans_package.vhd if system pcie enabled)
  



	--=== wishbone slaves ========--
	constant number_of_wb_slaves			: positive:= 3 ;
	
	constant user_wb_regs					: integer := 0 ;
	constant user_wb_timer					: integer := 1 ;
	constant user_wb_ttc_fmc_regs			: integer := 2 ;  --ttc_fmc
	
	
	--=== ipb slaves =============--
	--if 2  ko !!
	constant number_of_ipb_slaves		: positive:= 1 ;

	constant user_ipb_regs				: integer := 0 ; --not used








	

end 				user_package;
   
package body 	user_package is
end 				user_package;