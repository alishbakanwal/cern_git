----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:35:34 07/31/2012 
-- Design Name: 
-- Module Name:    cbc_frame_transmission - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cbc_frame_transmission is
generic (	bits_number 		: integer :=138
			);
port	(		clk 						: in std_logic;
				aclr 						: in std_logic;
				transmission_start	: in std_logic; --one cycle / active high
				transmission_end 		: out std_logic; --one cycle / active high
				cbc_frame_out			: out std_logic --data serialised
		);
end cbc_frame_transmission;

architecture Behavioral of cbc_frame_transmission is

signal data_to_transmit : std_logic_vector(137 downto 0):="10"&x"aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa_aa"; --header(10bits)&cbd_data(128bits)



begin

	--lsb first

	serialiser_block : block						
		type states is (s0,s1,s2,s3);
		signal state : states;
	begin
		process (clk,aclr)
		variable counter : integer range 0 to bits_number:=0;--bits_number;
			begin	
				if aclr = '1' then --totally async
					state 		<= s0;
					cbc_frame_out 	<= '0'; --idle
					transmission_end <= '0';
				elsif rising_edge(clk) then
					case state is
						--
						when s0 => 
							counter := 0;--bits_number;
							cbc_frame_out 	<= '0'; --idle
							transmission_end <= '0'; --one cycle
							if transmission_start = '1' then
								state <= s1;
							end if;
						--
						when s1 =>
							cbc_frame_out 	<= '1'; --first high
							state <= s2;
						--
						when s2 =>
							cbc_frame_out 	<= '1'; --second high
							state <= s3;
						--
						when s3 =>
							cbc_frame_out <= data_to_transmit(counter);
							if counter = bits_number then --0 then
								transmission_end <= '1';
								data_to_transmit <= not data_to_transmit;
								state <= s0;
							else
								counter := counter + 1; --counter - 1;
							end if;
					end case;
				end if;
		end process;
	end block;




end Behavioral;

