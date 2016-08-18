
--13/06/2013
-- mod by MBM
-- new style
-- scrambling opt (maybe get rid of the std)
-- added generic


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;




entity GBT_tx is
generic
	(
		OPTIMIZATION                  : string(1 to 8)       := "LATENCY_"  -- "LATENCY_" or "STANDARD" 
	);


  port 
  (
    tx_reset_i     	: in  std_logic;
    tx_word_clk_i  	: in  std_logic;
    tx_frame_clk_i 	: in  std_logic;
    tx_data_i      	: in  std_logic_vector ( 83 downto 0);
    tx_frame_o			: out std_logic_vector (119 downto 0);	
    tx_word_o      	: out std_logic_vector ( 19 downto 0);
	 tx_header_o 		: out  std_logic
  );  
end GBT_tx;


architecture RTL of GBT_tx is

  signal header_int      : std_logic_vector (3 downto 0);
  signal scrambler_out   : std_logic_vector (83 downto 0);
  signal encoder_out     : std_logic_vector (119 downto 0);
  signal interleaver_out : std_logic_vector (119 downto 0);
  
begin  -- RTL

  
   latOpt_gen: if OPTIMIZATION = "LATENCY_" generate	
    
        Scrambling_lat_opt_1 : entity work.Scrambling_lat_opt
          generic map (
            N => 0)
          port map (
            Reset  => tx_reset_i,
            Clock  => tx_frame_clk_i,
            Input  => tx_data_i,
            Header => header_int,
            Output => scrambler_out
            
            );
      
   end generate; 
   
   
   std_gen: if OPTIMIZATION /= "LATENCY_" generate	-- "STANDARD"
   
      Scrambling_1 : entity work.Scrambling
          generic map (
            N => 0)
          port map (
            Reset  => tx_reset_i,
            Clock  => tx_frame_clk_i,
            Input  => tx_data_i,
            Header => header_int,
            Output => scrambler_out
            
            );     

   end generate;

  Encoding_1 : entity work.Encoding
    port map (
      Header => header_int,
      Input  => scrambler_out,
      Output => encoder_out);

  Interleaving_1: entity work.Interleaving
    port map (
      Input  => encoder_out,
      Output => interleaver_out);
		
	   tx_frame_o <= interleaver_out;
		
  Tx_gearbox_reg_1: entity work.Mux_120_to_20bits_reg    -- MBM already optimiced  -- Check resources
    port map (
      Reset        	=> tx_reset_i,
      Tx_word_clk 	=> tx_word_clk_i,
      Tx_frame_clk   => tx_frame_clk_i,
      Input        	=> interleaver_out,
      Output       	=> tx_word_o,
		TxHeader			=> tx_header_o);
  
end RTL;

