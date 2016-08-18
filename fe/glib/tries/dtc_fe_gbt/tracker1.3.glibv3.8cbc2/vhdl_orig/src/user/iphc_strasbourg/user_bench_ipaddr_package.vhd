library ieee;
use ieee.std_logic_1164.all;
 
package 			user_ipaddr_package is

	constant glib_id  				: std_logic_vector( 7 downto 0):= x"00";
	
	type 		ipaddr_lut_type		is array (0 to 15) of std_logic_vector(31 downto 0);
	constant	ipaddr_lut_value		: ipaddr_lut_type:=
	(
		x"c0a8006f",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000"
	);		

end 				user_ipaddr_package;
   
package body 	user_ipaddr_package is
end 				user_ipaddr_package;