library ieee;
use ieee.std_logic_1164.all;
use work.gbt_package.all;

entity gbt_enc_top is
port
(
	ext_reset_i		: in 		std_logic;
	gbt_enc_o		: out		gbt_enc_out;
	gbt_enc_i		: in 		gbt_enc_in

);                    	
end gbt_enc_top;
							
architecture gbt_enc_top_arch of gbt_enc_top is                    	

begin -- architecture

		--====--
		gbt_enc: entity work.gbt_tx
		--====--
		port map
		(
			tx_reset_i 				=>(gbt_enc_i.reset 			or ext_reset_i),
			tx_word_clk_i 			=> gbt_enc_i.word_clk 		,
			tx_frame_clk_i 		=> gbt_enc_i.frame_clk		,
			tx_data_i 				=> gbt_enc_i.data 			,
			---	                         
			tx_frame_o 				=> gbt_enc_o.frame 			,
			tx_word_o 				=> gbt_enc_o.word 			,
			tx_header_o 			=> gbt_enc_o.header 		

		);	                                             
end gbt_enc_top_arch;