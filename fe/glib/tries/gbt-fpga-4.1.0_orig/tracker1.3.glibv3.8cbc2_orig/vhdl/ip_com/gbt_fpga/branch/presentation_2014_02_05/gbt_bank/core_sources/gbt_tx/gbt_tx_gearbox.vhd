
--MBM 04/11/2013

library ieee;
use ieee.std_logic_1164.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

entity gbt_tx_gearbox is
   generic (   
      GBT_BANK_ID                               : integer := 1   
   );
   port (
   
      TX_RESET_I                                : in  std_logic;
      TX_FRAMECLK_I                             : in  std_logic; 
      TX_WORDCLK_I                              : in  std_logic;
      TX_FRAME_I                                : in  std_logic_vector(119 downto 0);
      TX_WORD_O                                 : out std_logic_vector(WORD_WIDTH-1 downto 0)
      
   );
end gbt_tx_gearbox;

architecture structural of gbt_tx_gearbox is  

begin

   txGearboxStd_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).OPTIMIZATION /= "LAT" generate   -- Comment: "STD"
      txGearboxStd: entity work.gbt_tx_gearbox_std
         port map (
            TX_RESET_I                          => TX_RESET_I,   
            TX_FRAMECLK_I                       => TX_FRAMECLK_I,      
            TX_WORDCLK_I                        => TX_WORDCLK_I,   
            TX_FRAME_I                          => TX_FRAME_I,    
            TX_WORD_O                           => TX_WORD_O      
         );
   end generate;
   
   txGearboxLatOpt_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).OPTIMIZATION = "LAT" generate   
      txGearboxLatOpt: entity work.gbt_tx_gearbox_latopt
         port map (
            TX_RESET_I                          => TX_RESET_I,   
            TX_FRAMECLK_I                       => TX_FRAMECLK_I,      
            TX_WORDCLK_I                        => TX_WORDCLK_I,   
            TX_FRAME_I                          => TX_FRAME_I,    
            TX_WORD_O                           => TX_WORD_O      
         );
   end generate;  

end structural;