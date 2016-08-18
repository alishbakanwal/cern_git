library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity GBT_rx is
  
	port 
	(
		rx_reset_i      	: in  std_logic;
		rx_word_clk_i  	: in  std_logic;
		rx_frame_clk_i  	: in  std_logic;
		rx_word_i       	: in  std_logic_vector(19 downto 0);
		rx_data_o       	: out std_logic_vector( 83 downto 0);
		rx_data_dv_o		: out std_logic;
		rx_gtx_aligned_i  : in  std_logic;
		rx_bit_slip_cmd_o	: out std_logic;
		rx_bit_slip_nbr_o	: out std_logic_vector(4 downto 0);
		rx_aligned_o      : out std_logic;
		rx_write_address_o: out std_logic_vector( 5 downto 0);
		rx_word_o       	: out std_logic_vector(19 downto 0);
		rx_frame_o       	: out std_logic_vector(119 downto 0);
		rx_frame_dv_o		: out std_logic;	
		rx_header_flag_o  : out std_logic;
		rx_shiftedword_o  : out std_logic_vector(19 downto 0)
	);	
end GBT_rx;


architecture RTL of GBT_rx is

	-- signals belonging to Manual_Frame_Alignment --
	signal GTX0_aligned_o                  : std_logic;
	signal shifted_20bits_Word_alignment_o : std_logic_vector (19 downto 0);
	signal write_address_alignment_o       : std_logic_vector (5 downto 0);

	-- signals belonging to Pattern_Search --
	signal bit_Slip_pattern_search      	: std_logic;
	signal word_out_pattern_search      	: std_logic_vector ( 19 downto 0);
	signal write_address_pattern_search 	: std_logic_vector (  5 downto 0);
	signal locked_pattern_search        	: std_logic;
	signal demux_frame_o							: std_logic_vector (119 downto 0);
	signal demux_dv_o								: std_logic;
	signal reverse_interleaving_frame_o		: std_logic_vector (119 downto 0);
	signal decoder_data_o						: std_logic_vector ( 83 downto 0);
	signal decoder_dv_o							: std_logic;
	signal descrambler_data_o					: std_logic_vector ( 83 downto 0);
	signal descrambler_dv_o						: std_logic;	


begin  -- RTL

	
	--==========================--
	Manual_Frame_Alignment_1 : entity work.Manual_Frame_Alignment
    --==========================--
	port map 
    (
		RX_Clock             => rx_word_clk_i,
		Reset                => rx_reset_i,
		GX_Alignment_Done    => rx_gtx_aligned_i,
		Bit_Slip_Cmd         => bit_Slip_pattern_search,
		RX_Parallel          => rx_word_i,
		GX_Alignment_Done_Out=> GTX0_aligned_o,
		Shifted_20bits_Word  => shifted_20bits_Word_alignment_o,
		Write_Address        => write_Address_alignment_o
	);
	rx_shiftedword_o			<=	shifted_20bits_Word_alignment_o;


	--==========================--
	Pattern_Search_1 : entity work.Pattern_Search
	--==========================--
	port map 
	(
		Reset               	=> rx_reset_i,
		Clock               	=> rx_word_clk_i,
		Word_In             	=> shifted_20bits_Word_alignment_o,
		GX_Alignment_Status 	=> GTX0_aligned_o,
		Write_Address_In    	=> write_address_alignment_o,
		Bit_Slip_Cmd        	=> bit_Slip_pattern_search,
		Word_Out            	=> word_out_pattern_search,
		Write_Address_Out   	=> write_address_pattern_search,
		Locked              	=> locked_pattern_search,
		Header_Flag				=> rx_header_flag_o
	);

		rx_aligned_o   		<= locked_pattern_search;
		rx_word_o   			<= word_out_pattern_search;
		rx_write_address_o 	<= write_address_pattern_search;
		rx_bit_slip_cmd_o		<= bit_Slip_pattern_search;



		--==========================--
		bitslipCounter: entity work.bitslip_counter
		--==========================--
		port map 
		(
			reset_i 				=> rx_reset_i,				
			rxwordclk_i 		=> rx_word_clk_i,
			bitslip_i 			=> bit_slip_pattern_search,
			steps_o 				=> rx_bit_slip_nbr_o
		);




	--==========================--
	Demux:	entity work.Demux_20_to_120bits
	--==========================--
	port map
    (
		  Reset         		=> rx_reset_i, 
		  RX_Clock    			=> rx_word_clk_i, 
		  Clock_40MHz   		=> rx_frame_clk_i, 
		  Locked        		=> locked_pattern_search,
		  Input         		=> word_out_pattern_search,
		  Write_Address 		=> write_address_pattern_search,
		  DV            		=> demux_dv_o,
		  Output        		=> demux_frame_o
      );
		  rx_frame_dv_o		<= demux_dv_o;
		  rx_frame_o			<= demux_frame_o;
		  

	--==========================--
	reverse_interleave: entity work.Reverse_Interleaving
	--==========================--
	port map
    (
		Input						=> demux_frame_o,
		Output					=> reverse_interleaving_frame_o
    );	


		  
	--==========================--
	decode: entity work.Decoding 
	--==========================--
	port map
	(
		Clock_40MHz 			=> rx_frame_clk_i, 
		DV_In 					=> demux_dv_o,
		Input 					=> reverse_interleaving_frame_o,
		DV_Out 					=> decoder_dv_o,
		Output 					=> decoder_data_o
	);



	--==========================--
	descramble: entity work.Descrambling
	--==========================--
	port map
	(
		Reset 					=> rx_reset_i, 
		frame_clk_i 			=> rx_frame_clk_i, 
		DV_In 					=> decoder_dv_o,
		Input 					=> decoder_data_o,
		DV_Out 					=> descrambler_dv_o,
		Output 					=> descrambler_data_o
	);
		rx_data_dv_o			<= descrambler_dv_o;
		rx_data_o				<= descrambler_data_o; 


end RTL;
