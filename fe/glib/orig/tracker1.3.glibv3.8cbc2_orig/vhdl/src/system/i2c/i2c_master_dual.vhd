--------------------------------------------------
-- File:		I2Cmaster.vhd
-- Author:		P.Vichoudis
--------------------------------------------------
-- Description:	the I2C master. It supports the 
-- standard 7-bit addressing and the custom "RAL"
-- addressing mode.
--------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
library unisim;
use unisim.vcomponents.all;
use work.system_package.all;

entity i2c_master_dual is
port
(
	clk				: in  	std_logic;
	reset				: in  	std_logic;
	-- master regs -
	settings			: in  	std_logic_vector(12 downto 0);
	command			: in  	std_logic_vector(31 downto 0);
	reply				: out 	std_logic_vector(31 downto 0);
	-- IO pins -----
	scl_io			:inout	std_logic_vector(1 downto 0);					
	sda_io			:inout	std_logic_vector(1 downto 0)
	
	
); 			
end i2c_master_dual;

architecture iobufs of i2c_master_dual is



signal sda_i_master 	: std_logic_vector(1 downto 0);
signal sda_o_master 	: std_logic_vector(1 downto 0);
signal scl_i_master 	: std_logic_vector(1 downto 0);
signal scl_o_master 	: std_logic_vector(1 downto 0);

 
BEGIN


--===========================================
u0: entity work.i2c_master_core
--===========================================
port map
(
	clk			=> CLK			 	,
	reset			=> RESET				,
	settings		=> SETTINGS			,
	command		=> COMMAND			,
	reply			=> REPLY				,
	------------
	scl_i			=> scl_i_master	, 				
	scl_o			=> scl_o_master	, 
	sda_i			=> sda_i_master	, 
	sda_o			=> sda_o_master	
); 			
--===========================================



--===========================================
scl_i_master(0)	<= '0' when scl_io(0)='0'			else  '1';
scl_i_master(1)	<= '0' when scl_io(1)='0'			else  '1';
				
sda_i_master(0)	<= '0' when sda_io(0)='0' 			else 	'1';
sda_i_master(1)	<= '0' when sda_io(1)='0' 			else 	'1';

scl_io(0)			<= '0' when scl_o_master(0)='0'	else	'Z';
scl_io(1)			<= '0' when scl_o_master(1)='0'	else	'Z';
				
sda_io(0)			<= '0' when sda_o_master(0)='0'	else	'Z';
sda_io(1)			<= '0' when sda_o_master(1)='0'	else	'Z';
--===========================================

END iobufs;
