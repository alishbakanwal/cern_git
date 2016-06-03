library ieee;
use ieee.std_logic_1164.all;
use work.gbt_package.all;

entity gbt_dec_top is
port
(
	ext_reset_i			: in 		std_logic;
	gbt_dec_o			: out		gbt_dec_out;
	gbt_dec_i			: in 		gbt_dec_in

);                    	
end gbt_dec_top;
							
architecture gbt_dec_top_arch of gbt_dec_top is                    	

begin -- architecture

		--====--
		gbt_dec: entity work.gbt_rx
		--====--
		port map
		(
			rx_reset_i 				=>(gbt_dec_i.reset 			or ext_reset_i),
			rx_word_clk_i 			=> gbt_dec_i.word_clk 		,
			rx_frame_clk_i 		=> gbt_dec_i.frame_clk 	,
			rx_word_i 				=> gbt_dec_i.word 			,
			rx_gtx_aligned_i 		=> gbt_dec_i.gtx_aligned 	,
			---	                         
			rx_data_o 				=> gbt_dec_o.data 			,
			rx_data_dv_o 			=> gbt_dec_o.data_dv 		,
			rx_bit_slip_cmd_o 	=> gbt_dec_o.bit_slip_cmd	,
			rx_bit_slip_nbr_o 	=> gbt_dec_o.bit_slip_nbr	,
			rx_aligned_o 			=> gbt_dec_o.aligned 		,
			rx_write_address_o 	=> gbt_dec_o.write_address,
			rx_word_o 				=> gbt_dec_o.word 			,
			rx_frame_o 				=> gbt_dec_o.frame 			,
			rx_frame_dv_o 			=> gbt_dec_o.frame_dv 		,
			rx_header_flag_o 		=> gbt_dec_o.header_flag 	,
			rx_shiftedword_o 		=> gbt_dec_o.shiftedword 	
		);	                                             
end gbt_dec_top_arch;