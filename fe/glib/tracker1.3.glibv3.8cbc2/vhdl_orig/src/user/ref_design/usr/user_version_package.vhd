library ieee;
use ieee.std_logic_1164.all;
package user_version_package is
  constant usr_ver_major:integer range 0 to 15 :=2;
  constant usr_ver_minor:integer range 0 to 15 :=0;
  constant usr_ver_build:integer range 0 to 255:=1;
  constant usr_ver_year :integer range 0 to 99 :=14;
  constant usr_ver_month:integer range 0 to 12 :=02;
  constant usr_ver_day  :integer range 0 to 31 :=17;
end user_version_package;
package body user_version_package is
end user_version_package;