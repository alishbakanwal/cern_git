library ieee;
use ieee.std_logic_1164.all;
package user_version_package is --user_enum_package 
  constant usr_ver_major:integer range 0 to 15 :=0;
  constant usr_ver_minor:integer range 0 to 15 :=0;
  constant usr_ver_build:integer range 0 to 255:=4;
  constant usr_ver_year :integer range 0 to 99 :=12;
  constant usr_ver_month:integer range 0 to 12 :=10;
  constant usr_ver_day  :integer range 0 to 31 :=10;
end user_version_package; --user_enum_package
package body user_version_package is --user_enum_package 
end user_version_package; --user_enum_package