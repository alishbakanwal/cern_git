library ieee;
use ieee.std_logic_1164.all;
package user_version_package is
  constant usr_ver_major:integer range 0 to 15 :=1;
  constant usr_ver_minor:integer range 0 to 15 :=0;
  constant usr_ver_build:integer range 0 to 255:=3;
  constant usr_ver_year :integer range 0 to 99 :=12;
  constant usr_ver_month:integer range 0 to 12 :=01;
  constant usr_ver_day  :integer range 0 to 31 :=24;
end user_version_package;
package body user_enum_package is
end user_enum_package;