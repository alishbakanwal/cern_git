-- MBM (04/07/2013)
-- new name
--port names

library ieee;
use ieee.std_logic_1164.all;

library work;

entity gbt_rx_frame_aligner is
  port
    (
    
      RX_RESET_I           : in  std_logic;
      RX_WORDCLK_I         : in  std_logic;
      RX_MGT_RDY_I         : in  std_logic;
      RX_MGT_RDY_O         : out std_logic;
      RX_BITSLIP_CMD_I     : in  std_logic;
      RX_WRITE_ADDRESS_O   : out std_logic_vector( 5 downto 0);
      RX_WORD_I            : in  std_logic_vector(19 downto 0);
      SHIFTED_RX_WORD_O    : out std_logic_vector(19 downto 0)
    
    
      
      );
end gbt_rx_frame_aligner;

architecture rtl of gbt_rx_frame_aligner is

  signal Shift_Cmd     : std_logic_vector(4 downto 0);
  signal Shift_20b_Cmd : std_logic;

begin
  
  right_shift_inst : entity work.right_shifter_19b
    port map(Reset                 => RX_RESET_I,
             Clock                 => RX_WORDCLK_I,
             mgt_Alignment_Done_In  => RX_MGT_RDY_I,
             Input_Word            => RX_WORD_I,
             Shift_Cmd             => Shift_Cmd,
             mgt_Alignment_Done_Out => RX_MGT_RDY_O,
             Output_Word           => SHIFTED_RX_WORD_O);


  counter_inst : entity work.modulo_20_counter
    port map(Reset          => RX_RESET_I,
             Clock          => RX_WORDCLK_I,
             Bit_Slip_Cmd   => RX_BITSLIP_CMD_I,
             Shift_20b_Cmd  => Shift_20b_Cmd,
             Counter_Output => Shift_Cmd);


  dpram_ctrl : entity work.rx_gearbox_wr_addr
    port map(Reset         => RX_RESET_I,
             Clock         => RX_WORDCLK_I,
             Shift_20b_Cmd => Shift_20b_Cmd,
             Write_Address => RX_WRITE_ADDRESS_O);


end rtl;
