library ieee;
use ieee.std_logic_1164.all;

library work;

entity Manual_Frame_Alignment is
  port
    (
      Rx_word_clk           : in  std_logic;
      Reset                 : in  std_logic;
      GX_Alignment_Done     : in  std_logic;
      Bit_Slip_Cmd          : in  std_logic;
      RX_Parallel           : in  std_logic_vector(19 downto 0);
      GX_Alignment_Done_Out : out std_logic;
      Shifted_20bits_Word   : out std_logic_vector(19 downto 0);
      Write_Address         : out std_logic_vector(5 downto 0)
      );
end Manual_Frame_Alignment;

architecture rtl of Manual_Frame_Alignment is

  signal Shift_Cmd     : std_logic_vector(4 downto 0);
  signal Shift_20b_Cmd : std_logic;

begin
  
  right_shift_inst : entity work.right_shifter_19b
    port map(Reset                 => Reset,
             Clock                 => Rx_word_clk,
             GX_Alignment_Done_In  => GX_Alignment_Done,
             Input_Word            => RX_Parallel,
             Shift_Cmd             => Shift_Cmd,
             GX_Alignment_Done_Out => GX_Alignment_Done_Out,
             Output_Word           => Shifted_20bits_Word);


  counter_inst : entity work.modulo_20_counter
    port map(Reset          => Reset,
             Clock          => Rx_word_clk,
             Bit_Slip_Cmd   => Bit_Slip_Cmd,
             Shift_20b_Cmd  => Shift_20b_Cmd,
             Counter_Output => Shift_Cmd);


  dpram_ctrl : entity work.rx_gearbox_wr_addr
    port map(Reset         => Reset,
             Clock         => Rx_word_clk,
             Shift_20b_Cmd => Shift_20b_Cmd,
             Write_Address => Write_Address);


end rtl;
