library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

library work;

entity gearbox_4x_to_1x is
generic	
(
	word_width		:positive:=32;
	wordcount_width:positive:=21
);
port
 (
	rst_i 	      : in  std_logic;
	clk_4x_i 		: in  std_logic;
	clk_1x_i  		: in  std_logic;
	frame_i        : in  std_logic_vector(4*word_width-1 		downto 0);
	word_o       	: out std_logic_vector(1*word_width-1 		downto 0);
	wordcount_o   	: out std_logic_vector(wordcount_width-1 	downto 0);
	busy_o			: out std_logic;	
	lsb_o				: out std_logic
	);
end gearbox_4x_to_1x;

architecture rtl of gearbox_4x_to_1x is

	attribute keep: boolean;
	attribute keep of word_o				: signal is true;
	attribute keep of wordcount_o			: signal is true;
	attribute keep of busy_o				: signal is true;
	
	
--  signal data          : std_logic_vector (4*word_width-1 downto 0);
	
	signal counter       : std_logic_vector (1 downto 0)   := "00";
	signal reset_counter : std_logic                       := '0';
	signal busy				: std_logic                       := '0';
	signal wordcount  	: std_logic_vector(wordcount_width-1 	downto 0);
	signal word  			: std_logic_vector(word_width-1 			downto 0);
	constant mincount		: std_logic_vector(wordcount_width-1 	downto 0):=(others=>'0');
	constant maxcount		: std_logic_vector(wordcount_width-1 	downto 0):=(others=>'1');
	
begin

	--=====================--
	process (clk_1x_i, rst_i)
	--=====================--
	begin
   if (rst_i = '1') then
      reset_counter <= '1';
   else
      if (rising_edge(clk_1x_i)) then
        reset_counter <= '0';
		end if;
   end if;
	end process;
	--=====================--
	
	
	
	--=====================--
	process (reset_counter, clk_4x_i)
	--=====================--
	variable	start_wordcount: std_logic;
	begin
   if (reset_counter = '1') then
      counter 				<= "00";
		busy					<= '0';
		word					<= (others=>'0');
		wordcount			<= mincount;
		start_wordcount	:= '0';

	elsif (rising_edge(clk_4x_i)) then
		
		if wordcount/=maxcount  then 
			busy <= '1';
			if busy = '1' then wordcount <= wordcount+1; end if;
		else		
			busy <='0'; 
		end if;
		
		case counter is
        when "00" => word <= frame_i(1*word_width-1  downto 0*word_width);	counter <= "01";	lsb_o <= '1';
        when "01" => word <= frame_i(2*word_width-1  downto 1*word_width);	counter <= "10";
        when "10" => word <= frame_i(3*word_width-1  downto 2*word_width);	counter <= "11";
        when "11" => word <= frame_i(4*word_width-1  downto 3*word_width); counter <= "00";
        when others => null;
      end case;
		
		
		
   end if;
	end process;
	--=====================--
	
	busy_o		<= busy;
	word_o		<= word;
	wordcount_o	<= wordcount;

end rtl;
