library ieee;
use ieee.std_logic_1164.all;
 
package system_package is

	type array_2x32bit   is array (0 to  1)  of std_logic_vector(31 downto 0);
	type array_4x32bit   is array (0 to  3)  of std_logic_vector(31 downto 0);
	type array_16x32bit  is array (0 to 15)  of std_logic_vector(31 downto 0);
	type array_32x32bit  is array (0 to 31)  of std_logic_vector(31 downto 0);
	type array_64x32bit  is array (0 to 63)  of std_logic_vector(31 downto 0);
	type array_128x32bit is array (0 to 127) of std_logic_vector(31 downto 0);
	type array_256x32bit is array (0 to 255) of std_logic_vector(31 downto 0);

   type array_2x8bit  is array  (0 to  1) of std_logic_vector( 7 downto 0);	
   type array_4x8bit  is array  (0 to  3) of std_logic_vector( 7 downto 0);
	type array_16x8bit is array  (0 to 15) of std_logic_vector( 7 downto 0);
	type array_32x8bit is array  (0 to 31) of std_logic_vector( 7 downto 0);

	--=== ethernet ports =========--
	constant amc_p0	               : integer := 0 ;
	constant amc_p1	               : integer := 1 ;
	constant phy		               : integer := 2 ;
   constant fmc2		               : integer := 3 ;
	--=== ipb slaves =============--
	constant number_of_slaves			: positive:= 8 ; --> sys_regs, sram1, sram2, flash, user_ipb, user_wb, drp, icap
   constant sys_regs	               : integer := 0 ;	
	constant sram1		               : integer := 1 ;
	constant sram2		               : integer := 2 ;
	constant flash		               : integer := 3 ;	
	constant user_wb	               : integer := 4 ;
	constant user_ipb	               : integer := 5 ;
	constant drp		               : integer := 6 ;
	constant icap		               : integer := 7 ;   
	
end system_package;
   
package body system_package is
end system_package;