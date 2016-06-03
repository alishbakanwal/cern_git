library IEEE;
use IEEE.STD_LOGIC_1164.all;

package gbt_package is

	--===========--
	type gbt_enc_out is
	--===========--
	record
		frame					: std_logic_vector (119 downto 0);	
		word      			: std_logic_vector ( 19 downto 0);
		header 				: std_logic;
   end record;
	--===========--
	
	
	--===========--
	type gbt_enc_in is
	--===========--
	record
		reset     			: std_logic;
		word_clk  			: std_logic;
		frame_clk 			: std_logic;
		data      			: std_logic_vector ( 83 downto 0);
   end record;
	--===========--
	
	
	--===========--
	type gbt_dec_out is
	--===========--
	record
		data       			: std_logic_vector( 83 downto 0);
		data_dv				: std_logic;
		bit_slip_cmd		: std_logic;
		bit_slip_nbr		: std_logic_vector(4 downto 0);
		aligned      		: std_logic;
		write_address		: std_logic_vector( 5 downto 0);
		word       			: std_logic_vector(19 downto 0);
		frame       		: std_logic_vector(119 downto 0);
		frame_dv				: std_logic;	
		header_flag 	 	: std_logic;
		shiftedword  		: std_logic_vector(19 downto 0);
	end record;
	--===========--
	
	
	--===========--
	type gbt_dec_in is
	--===========--
	record
		reset      			: std_logic;
		word_clk  			: std_logic;
		frame_clk  			: std_logic;
		word       			: std_logic_vector(19 downto 0);
		gtx_aligned  		: std_logic;
   end record;
	--===========--
	
	type gbt_dec_in_array  is array(natural range <>) of gbt_dec_in;
	type gbt_dec_out_array is array(natural range <>) of gbt_dec_out;
	type gbt_enc_in_array  is array(natural range <>) of gbt_enc_in;
	type gbt_enc_out_array is array(natural range <>) of gbt_enc_out;

end gbt_package;