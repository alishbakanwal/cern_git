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


-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

entity gbt_rx_gearbox is
   generic (   
      GBT_BANK_ID                               : integer := 1   
   );
   port (  
    
      RX_RESET_I                                : in  std_logic;
      RX_WORDCLK_I                              : in  std_logic;
      RX_FRAMECLK_I                             : in  std_logic;
      RX_HEADER_LOCKED_I                        : in  std_logic;
      RX_WRITE_ADDRESS_I                        : in  std_logic_vector(WORD_ADDR_MSB downto 0);
      RX_WORD_I                                 : in  std_logic_vector(WORD_WIDTH-1 downto 0);
      RX_FRAME_O                                : out std_logic_vector(119 downto 0);
      DV_O                                      : out std_logic
      
   );   
end gbt_rx_gearbox;

architecture structural of gbt_rx_gearbox is
   
begin
	
	rxGearboxStd_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).OPTIMIZATION /= "LAT" generate  -- Comment: "STD"
   
		rxGearboxStd:	entity work.gbt_rx_gearbox_std
         port map (      
            RX_RESET_I      	                  => RX_RESET_I,     
            RX_WORDCLK_I     	                  => RX_WORDCLK_I, 
            RX_FRAMECLK_I 	                     => RX_FRAMECLK_I, 
            RX_HEADER_LOCKED_I                  => RX_HEADER_LOCKED_I,
            RX_WRITE_ADDRESS_I                  => RX_WRITE_ADDRESS_I,
            RX_WORD_I          	               => RX_WORD_I,
            RX_FRAME_O       	                  => RX_FRAME_O,      
            DV_O                                => DV_O
         );	
      
	end generate;	

   rxGearboxLatOpt_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).OPTIMIZATION = "LAT" generate	
   
		rxGearboxLatOpt: entity work.gbt_rx_gearbox_latopt
         port map (
            RX_RESET_I      	                  => RX_RESET_I,     
            RX_WORDCLK_I     	                  => RX_WORDCLK_I, 
            RX_FRAMECLK_I 	                     => RX_FRAMECLK_I, 
            RX_HEADER_LOCKED_I                  => RX_HEADER_LOCKED_I,
            RX_WRITE_ADDRESS_I                  => RX_WRITE_ADDRESS_I,
            RX_WORD_I          	               => RX_WORD_I,
            RX_FRAME_O       	                  => RX_FRAME_O,      
            DV_O                                => DV_O
         );	
      
	end generate;
   
end structural;