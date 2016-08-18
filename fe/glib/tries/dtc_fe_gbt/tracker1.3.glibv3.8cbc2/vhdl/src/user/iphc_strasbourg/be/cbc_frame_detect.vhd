--
-- VHDL Architecture cidaq.cbc_frame_detect.v1
--
-- Created:
--          by - Mark Pesaresi
--          at - 18:23:03 26/02/2011

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY cbc_frame_detect IS
	GENERIC ( CBC_DATA_BITS_NB : integer := 264 --138
				);

  PORT( 
   clk                     : IN     std_logic;
   async_reset             : IN     std_logic;
   
   data_in                 : IN     std_logic;
   data_out                : OUT    std_logic_vector(CBC_DATA_BITS_NB-1 downto 0);
   write_en                : OUT    std_logic;
	
	capture_out : out std_logic
);

-- Declarations

END ENTITY cbc_frame_detect;


ARCHITECTURE v1 OF cbc_frame_detect IS


signal last : std_logic := '0';
signal capture : std_logic := '0';
signal frame : std_logic_vector(CBC_DATA_BITS_NB-1 downto 0);
signal data_out_tmp : std_logic_vector(CBC_DATA_BITS_NB-1 downto 0);

BEGIN

capture_out <= capture;

--data_out 	<= data_out_tmp;

--order reversed
process(data_out_tmp)
begin
	reversed_data_out : for i in data_out_tmp'range loop --CBC_DATA_BITS_NB-1 downto 0 loop --data_out_tmp'range loop
		data_out(data_out'left - i) <= data_out_tmp(i);
	end loop;
end process;

 clock_proc: process(clk,async_reset)
  
  variable frame_count : unsigned(8 downto 0); --8b : 138 / 9b : 266

  begin
  
    if (async_reset = '1') then
      
      last <= '0';
      data_out_tmp <= (others => '0');
      frame <= (others => '0');
      capture <= '0';
      write_en <= '0';


    elsif (clk = '1' and clk'event) then
    

       
      if(capture = '0') then

        -- serial header detect (two consecutive 1's when not in frame capture)
        -- initiates capture mode
        if((last and data_in) = '1') then
          capture <= '1';
        end if;
 
        -- outputs when not capturing
        frame_count := (others => '0');
        frame <= (others => '0');
        --data_out_tmp <= (others => '0'); --lcharles : keep data after
        write_en <= '0';      
        
      else
        
        -- in serial frame capture mode
        
        if(frame_count = to_unsigned(CBC_DATA_BITS_NB,9)) then
          
          -- output 264 bits of data recieved since serial header detected and exit capure mode
          -- output 264 bits frame should be latched when write_en = '1' (1 clock cycle)
          frame_count := (others => '0');
          capture <= '0';
          
          data_out_tmp <= frame;

			 
          write_en <= '1';
        
        else
          
          -- shift register + counter for incoming serial data after header detect
          -- frame encoding (LSB->MSB)
          -- ERROR_BITS (2bits) | PIPELINE_ADDRESS (8bits) | DATA[0->253] (254bits)
          frame(to_integer(frame_count)) <= data_in;
          frame_count := frame_count + 1;
          
          --data_out_tmp <= (others => '0'); --lcharles : keep data after
          write_en <= '0';   
          
        end if;

      end if;
      
      last <= data_in;
      
    end if; -- clk and async_reset

  end process clock_proc;





END ARCHITECTURE v1;

