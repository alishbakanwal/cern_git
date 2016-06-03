
-- MBM ' New name - (26/11/2013)
-- externally is a generic wrapper
-- this part is vendor specific

library ieee;
use ieee.std_logic_1164.all;

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

entity gbt_rx_gearbox_std_dpram is
   port (
    
      WR_EN_I                                   : in  std_logic;
      WR_CLK_I                                  : in  std_logic;
      WR_ADDRESS_I                              : in  std_logic_vector(  4 downto 0);
      WR_DATA_I                                 : in  std_logic_vector( 39 downto 0);
      RD_CLK_I                                  : in  std_logic;
      RD_ADDRESS_I                              : in  std_logic_vector(  2 downto 0);
      RD_DATA_O                                 : out std_logic_vector(119 downto 0)
      
   );
end gbt_rx_gearbox_std_dpram;

architecture structural of gbt_rx_gearbox_std_dpram is

   signal dOutB_from_dpram                      : std_logic_vector(159 downto 0);
   
begin

   dpram: entity work.xlx_k7v7_rxdpram_core
      port map (
         CLKA                                   => WR_CLK_I,
         WEA(0)                                 => WR_EN_I,
         ADDRA                                  => WR_ADDRESS_I,
         DINA                                   => WR_DATA_I,
         CLKB                                   => RD_CLK_I,
         ADDRB                                  => RD_ADDRESS_I,
         DOUTB                                  => dOutB_from_dpram
      );
   
   RD_DATA_O                                    <= dOutB_from_dpram(119 downto 0);
   
end structural;