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

entity i2c_master_no_iobuf is
port
(
	clk			: in  	std_logic;
	reset			: in  	std_logic;
	--- i2c registers ------------
	settings		: in  	std_logic_vector(12 downto 0);
	command		: in  	std_logic_vector(31 downto 0);
	reply			: out 	std_logic_vector(31 downto 0);
	--- ctrlsignals --------------
	busy			: out		std_logic;
	------------------------------
	scl_i			:in		std_logic_vector(1 downto 0);					
	scl_o			:out		std_logic_vector(1 downto 0);					
	scl_oe_l		:out		std_logic_vector(1 downto 0);					
	sda_i			:in		std_logic_vector(1 downto 0);
	sda_o			:out		std_logic_vector(1 downto 0);
	sda_oe_l		:out		std_logic_vector(1 downto 0)
); 			
end i2c_master_no_iobuf;


--===========================================
-- note: the response is latched when ctrl_done=1
--===========================================
architecture hierarchy of i2c_master_no_iobuf is

signal startclk								:std_logic;
signal execstart								:std_logic;
signal execstop								:std_logic;
signal execwr									:std_logic;
signal execgetack								:std_logic;
signal execrd									:std_logic;
signal execsendack							:std_logic;
signal bytetowrite							:std_logic_vector(7 downto 0);
signal byteread								:std_logic_vector(7 downto 0);	
signal bytereaddv								:std_logic;	
signal completed								:std_logic;
signal failed									:std_logic;
 
signal scl_from_core_oe_l					:std_logic_vector(1 downto 0);					
signal scl_from_core							:std_logic_vector(1 downto 0);					
signal scl_to_core							:std_logic_vector(1 downto 0);				
signal sda_from_core_oe_l					:std_logic_vector(1 downto 0);					
signal sda_from_core							:std_logic_vector(1 downto 0);					
signal sda_to_core							:std_logic_vector(1 downto 0); 
 
BEGIN


--===========================================
u1: entity work.i2c_data
--===========================================
port map
(
	clk				=> CLK,
	reset				=> RESET,
	------------------------------
	--=== settings ==--
	------------------------------
	enable			=> SETTINGS(11),
	i2c_bus_select	=> SETTINGS(10),
	clkprescaler	=> SETTINGS(9 downto 0),
	------------------------------
	--== interface w/ i2cdata ==--
	------------------------------
	startclk_ext	=> startclk,
	execstart_ext	=> execstart,
	execstop_ext	=> execstop,
	execwr_ext		=> execwr,
	execgetack_ext	=> execgetack,
	execrd_ext		=> execrd,
	execsendack_ext=> execsendack,
	bytetowrite_ext=> bytetowrite,
	completed		=> completed,
	failed			=> failed,
	byteread			=> byteread,
	bytereaddv		=> bytereaddv,
	------------------------------
	--== physical interface   ==--
	------------------------------
	scl_oe_l			=> scl_from_core_oe_l,
	scl_out			=> scl_from_core,
	scl_in			=> scl_to_core,
	sda_out			=> sda_from_core,				
	sda_in			=> sda_to_core,				
	sda_oe_l			=> sda_from_core_oe_l	


); 			
--===========================================



--===========================================
u2: entity work.i2c_ctrl
--===========================================
port map
(
	clk				=> CLK,
	reset				=> RESET,
	------------------------------
	--=== settings ==--
	------------------------------
	enable			=> SETTINGS(11),
	clkprescaler	=> SETTINGS(9 downto 0),
	------------------------------
	--=== command  ==--
	------------------------------
	executestrobe	=> COMMAND(31),
	extmode			=> COMMAND(25), --16bit data
	ralmode			=> COMMAND(24),
	writetoslave	=> COMMAND(23),
	slaveaddress	=> '0'&  COMMAND(22 downto 16),
	slaveregister	=> COMMAND(15 downto 8 ),
	datatoslave		=> COMMAND( 7 downto 0 ),
	------------------------------
	--== interface w/ i2cdata ==--
	------------------------------
	startclk			=> startclk,
	execstart		=> execstart,
	execstop			=> execstop,
	execwr			=> execwr,
	execgetack		=> execgetack,
	execrd			=> execrd,
	execsendack		=> execsendack,
	bytetowrite		=> bytetowrite,
	byteread			=> byteread,
	bytereaddv		=> bytereaddv,
	completed		=> completed,
	failed			=> failed,
	------------------------------
	done_o			=> open,
	busy_o			=> BUSY,
	reply_o			=> REPLY
); 
--===========================================



sda_to_core	<= SDA_I;
scl_to_core	<= SCL_I;

SDA_O			<= sda_from_core;
SCL_O			<= scl_from_core;

SDA_OE_L 	<= sda_from_core_oe_l;
SCL_OE_L 	<= scl_from_core_oe_l;


END hierarchy;
