----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:15:47 06/28/2013 
-- Design Name: 
-- Module Name:    gbt_rx_gearbox - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



-- MBM 27/06/2013
--port names

-- Custom libraries and packages:
use work.gbt_link_user_setup.all;

entity gbt_rx_gearbox is


    
    
    port
    (  
    
      RX_RESET_I         : in  std_logic;
      RX_WORDCLK_I   : in  std_logic;
      RX_FRAMECLK_I  : in  std_logic;
      RX_HEADER_LOCKED_I        : in  std_logic;
      RX_WRITE_ADDRESS_I : in  std_logic_vector(5 downto 0);
      RX_WORD_I         : in  std_logic_vector(19 downto 0);
      RX_FRAME_O        : out std_logic_vector(119 downto 0);
      DV_O            : out std_logic
      );     


end gbt_rx_gearbox;

architecture Behavioral of gbt_rx_gearbox is
    
    
   
begin



	latOptGearbox_gen: if OPTIMIZATION = "LATENCY" generate	
   
		--==========================--
		latOptGearbox: entity work.gbt_rx_latopt_gearbox
		--==========================--
		port map
         (
            Reset      	   => RX_RESET_I,     
            Rx_word_clk     	   => RX_WORDCLK_I, 
            Rx_frame_clk 	   => RX_FRAMECLK_I, 
 --			  data_header_flag_i => data_header_flag_i,
 --			   data_header_flag_o => data_header_flag_o,
           Locked          => RX_HEADER_LOCKED_I,
            Input          	   => RX_WORD_I,
            Write_Address   => RX_WRITE_ADDRESS_I,
            DV              => DV_O,
            Output       	   => RX_FRAME_O
      
		);	
      
	end generate;		
	stdGearbox_gen: if OPTIMIZATION /= "LATENCY" generate  -- "STANDARD"
   
		--==========================--
		stdGearbox:	entity work.gbt_rx_standard_gearbox
		--==========================--
		port map
		(
      
            Reset      	   => RX_RESET_I,     
           word_clk_i     	   => RX_WORDCLK_I, 
            frame_clk_i 	   => RX_FRAMECLK_I, 
--			  data_header_flag_i => data_header_flag_i,
 --		  data_header_flag_o => data_header_flag_o,
           Locked          => RX_HEADER_LOCKED_I,
            Input          	   => RX_WORD_I,
            Write_Address   => RX_WRITE_ADDRESS_I,
            DV              => DV_O,
            Output       	   => RX_FRAME_O
      
		);	
      
	end generate;	

end Behavioral;

