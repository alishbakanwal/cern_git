library ieee;
use ieee.std_logic_1164.all;
library work;

entity Demux_20_to_120bits is
  port
    (
      Reset         : in  std_logic;
      word_clk_i    : in  std_logic;
      frame_clk_i   : in  std_logic;
      Locked        : in  std_logic;
      Input         : in  std_logic_vector(19 downto 0);
      Write_Address : in  std_logic_vector(5 downto 0);
      DV            : out std_logic;
      Output        : out std_logic_vector(119 downto 0)
      );
end Demux_20_to_120bits;

architecture rtl of Demux_20_to_120bits is

	signal Word       					: std_logic_vector(159 downto 0);
	signal rd_address 					: std_logic_vector(  2 downto 0);
	signal TempLocked 					: std_logic_vector(  0 downto 0);
	signal demux_dv_o_reg				: std_logic;
	signal demux_frame_o_reg			: std_logic_vector(119 downto 0);
	signal DV_int  						: std_logic;

	attribute keep: boolean;
	attribute keep of demux_dv_o_reg	: signal is true;
	attribute keep of demux_frame_o_reg	: signal is true;

begin

	TempLocked(0) <= Locked;

	--ALTERA dp_ram instanciation
	rxdpram_ctrl : entity work.read_rx_dp_ram
    port map
    (
		Reset            	=> Reset,
        word_clk_i    		=> word_clk_i,
        frame_clk_i      	=> frame_clk_i,
        Locked_On_Header 	=> TempLocked(0),
        DV               	=> DV_int,
        Read_Address     	=> rd_address
	);
	
	dpram : entity work.rx_dp_ram
	PORT MAP
	(
		wren 				=> Locked,
        wrclock 			=> word_clk_i,
        rdclock 			=> frame_clk_i,
        data 				=> Input,
        rdaddress 			=> rd_address,
        wraddress 			=> Write_Address,
        q 					=> Word
	);

	process(frame_clk_i, reset)
	begin
	if reset='1' then
		demux_dv_o_reg      <= '0';
		demux_frame_o_reg   <= (others => '0');
	elsif frame_clk_i'event and frame_clk_i='1' then
		demux_dv_o_reg      <= DV_int;
		demux_frame_o_reg   <= WOrd(119 downto 0);
	end if;
	end process;
	
	DV 	<= demux_dv_o_reg;
	invert_bits : for i in 119 downto 0 generate
		OUTPUT(i) <= demux_frame_o_reg(119-i);
	end generate;

end rtl;
