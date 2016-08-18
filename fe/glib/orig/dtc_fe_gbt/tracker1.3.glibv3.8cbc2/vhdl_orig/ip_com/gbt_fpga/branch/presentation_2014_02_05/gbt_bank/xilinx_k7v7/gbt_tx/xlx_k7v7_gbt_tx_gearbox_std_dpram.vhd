
-- MBM ' New name - (26/11/2013)
-- externally is a generic wrapper
-- this part is vendor specific

library ieee;
use ieee.std_logic_1164.all;

-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;

entity gbt_tx_gearbox_std_dpram is
   port (
    
      WR_CLK_I                                  : in  std_logic;
      WR_ADDRESS_I                              : in  std_logic_vector(  2 downto 0);
      WR_DATA_I                                 : in  std_logic_vector(119 downto 0);
      RD_CLK_I                                  : in  std_logic;
      RD_ADDRESS_I                              : in  std_logic_vector(  4 downto 0);
      RD_DATA_O                                 : out std_logic_vector( 39 downto 0)
      
   );
end gbt_tx_gearbox_std_dpram;

architecture structural of gbt_tx_gearbox_std_dpram is
  
  signal writeData                              : std_logic_vector(159 downto 0);
  
begin

   writeData                                    <= x"0000000000" & WR_DATA_I;

   dpram: entity work.xlx_k7v7_txdpram_core
      port map (
         CLKA                                   => WR_CLK_I,
         WEA(0)                                 => '1',
         ADDRA                                  => WR_ADDRESS_I,
         DINA                                   => writeData,
         CLKB                                   => RD_CLK_I,
         ADDRB                                  => RD_ADDRESS_I,
         DOUTB                                  => RD_DATA_O
      );
   
end structural;