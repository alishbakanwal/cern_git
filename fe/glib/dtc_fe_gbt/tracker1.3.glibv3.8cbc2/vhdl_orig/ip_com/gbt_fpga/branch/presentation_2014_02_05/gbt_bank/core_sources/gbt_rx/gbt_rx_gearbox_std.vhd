--MBM (04/07/2013)
--new name
--modified to wor with 20 and 40 bits words

library ieee;
use ieee.std_logic_1164.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;

entity gbt_rx_gearbox_std is
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
end gbt_rx_gearbox_std;

architecture structural of gbt_rx_gearbox_std is   
   
   signal readAddress_from_readControl          : std_logic_vector(  2 downto 0);
   signal dv_from_readControl                   : std_logic;   
   
   signal rxFrame_from_dpram                    : std_logic_vector(119 downto 0);
   
   signal rxFrame_from_invertDataOut            : std_logic_vector(119 downto 0);

begin

   readControl: entity work.gbt_rx_gearbox_std_rdctrl
      port map (
         RX_RESET_I                             => RX_RESET_I,
         RX_WORDCLK_I                           => RX_WORDCLK_I,
         RX_FRAMECLK_I                          => RX_FRAMECLK_I,
         RX_HEADER_LOCKED_I                     => RX_HEADER_LOCKED_I,
         READ_ADDRESS_O                         => readAddress_from_readControl,
         DV_O                                   => dv_from_readControl
      );
   
   dpram: entity work.gbt_rx_gearbox_std_dpram
      port map   (
         WR_EN_I                                => RX_HEADER_LOCKED_I,        
         WR_CLK_I                               => RX_WORDCLK_I,
         WR_ADDRESS_I                           => RX_WRITE_ADDRESS_I,   
         WR_DATA_I                              => RX_WORD_I,
         RD_CLK_I                               => RX_FRAMECLK_I,
         RD_ADDRESS_I                           => readAddress_from_readControl,
         RD_DATA_O                              => rxFrame_from_dpram
      );
   
   invertDataOut: for i in 119 downto 0 generate
      rxFrame_from_invertDataOut(i)             <= rxFrame_from_dpram(119-i);
   end generate;   
   
   process(RX_RESET_I, RX_FRAMECLK_I)
   begin
      if RX_RESET_I = '1' then
         DV_O                                   <= '0';
         RX_FRAME_O                             <= (others => '0');
      elsif rising_edge(RX_FRAMECLK_I) then
         DV_O                                   <= dv_from_readControl;      
         RX_FRAME_O                             <= rxFrame_from_invertDataOut;
      end if;
   end process;    

end structural;
