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

entity i2c_master is
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
	scl			:inout	std_logic_vector(1 downto 0);					
	sda			:inout	std_logic_vector(1 downto 0)
	
	
); 			
end i2c_master;

architecture hierarchy of i2c_master is


signal scl_from_core_oe_l					:std_logic_vector(1 downto 0);					
signal scl_from_core							:std_logic_vector(1 downto 0);					
signal scl_to_core							:std_logic_vector(1 downto 0);				
signal sda_from_core_oe_l					:std_logic_vector(1 downto 0);					
signal sda_from_core							:std_logic_vector(1 downto 0);					
signal sda_to_core							:std_logic_vector(1 downto 0); 
 
BEGIN


--===========================================
u0: entity work.i2c_master_no_iobuf
--===========================================
port map
(
	clk			=> CLK			 			,
	reset			=> RESET						,
	settings		=> SETTINGS					,
	command		=> COMMAND					,
	reply			=> REPLY						,
	busy			=> BUSY						,
	------------
	scl_i			=> scl_to_core				,					
	scl_o			=> scl_from_core			,				
	scl_oe_l		=> scl_from_core_oe_l	,				
	sda_i			=> sda_to_core				,
	sda_o			=> sda_from_core			,
	sda_oe_l		=> sda_from_core_oe_l
); 			
--===========================================



--===========================================
-- i2c io buffers
--===========================================
scl0_od_buf	: iobuf 	generic map (capacitance => "dont_care", drive => 12, ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos25", slew => "slow")
							port map (i => scl_from_core(0), t => scl_from_core_oe_l(0), o => scl_to_core(0), io => SCL(0));

sda0_od_buf	: iobuf 	generic map (capacitance => "dont_care", drive => 12, ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos25", slew => "slow")
							port map (i => sda_from_core(0), t => sda_from_core_oe_l(0), o => sda_to_core(0), io => SDA(0));

scl1_od_buf	: iobuf 	generic map (capacitance => "dont_care", drive => 12, ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos25", slew => "slow")
							port map (i => scl_from_core(1), t => scl_from_core_oe_l(1), o => scl_to_core(1), io => SCL(1));

sda1_od_buf	: iobuf 	generic map (capacitance => "dont_care", drive => 12, ibuf_delay_value => "0", ibuf_low_pwr => true, ifd_delay_value => "auto", iostandard	=> "lvcmos25", slew => "slow")
							port map (i => sda_from_core(1), t => sda_from_core_oe_l(1), o => sda_to_core(1), io => SDA(1));
--===========================================


END hierarchy;
