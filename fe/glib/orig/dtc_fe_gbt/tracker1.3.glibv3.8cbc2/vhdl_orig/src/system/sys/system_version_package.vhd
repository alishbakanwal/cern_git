library ieee;
use ieee.std_logic_1164.all;
package system_version_package is
	
	constant sys_ver_major:integer range 0 to 15 :=5;
	constant sys_ver_minor:integer range 0 to 15 :=0;
	constant sys_ver_build:integer range 0 to 255:=1;
	constant sys_ver_year :integer range 0 to 99 :=14;
	constant sys_ver_month:integer range 0 to 12 :=03;
	constant sys_ver_day  :integer range 0 to 31 :=18;
  
	constant sys_id		 :std_logic_vector(31 downto 0):= x"32307631"; -- '2_0_v1'
  
end system_version_package;
package body system_version_package is
end system_version_package;