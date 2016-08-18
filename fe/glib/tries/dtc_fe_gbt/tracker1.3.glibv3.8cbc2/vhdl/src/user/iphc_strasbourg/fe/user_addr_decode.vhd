library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use work.ipbus.all;
use work.user_package.all;

package user_addr_decode is

	function user_wb_addr_sel (signal addr : in std_logic_vector(31 downto 0)) return integer;
	function user_ipb_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer;

end user_addr_decode;

package body user_addr_decode is

	function user_ipb_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer is
		variable sel : integer;
	begin
		--              addr, "00------------------------------" is reserved (system ipbus fabric)
		if    std_match(addr, "01000000000000000000000000------") then  	sel := user_ipb_stat_regs;
		elsif std_match(addr, "01000000000000000000000001------") then  	sel := user_ipb_ctrl_regs;
--		 elsif std_match(addr, "01000000000000000000000100000000") then		sel := user_ipb_timer; -- xx
		--              addr, "1-------------------------------" is reserved (wishbone fabric)
		else	
			sel := 99;
		end if;
		return sel;
	end user_ipb_addr_sel;

   function user_wb_addr_sel(signal addr : in std_logic_vector(31 downto 0)) return integer is
		variable sel : integer;
   begin
		--              addr, "00------------------------------" is reserved (system ipbus fabric)
		--              addr, "01------------------------------" is reserved (user ipbus fabric)
--		if    std_match(addr, "100000000000000000000000--------") then  	sel := user_wb_regs;
--		elsif std_match(addr, "10000000000000000000000100000000") then		sel := user_wb_timer; -- xx
		if    std_match(addr, "100000000000000000000000--------") then  	sel := user_wb_fe;		
		else	
			sel := 99;
		end if;
		return sel;
	end user_wb_addr_sel; 

end user_addr_decode;