----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:41:15 06/24/2016 
-- Design Name: 
-- Module Name:    packet_checker - Behavioral 
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


-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- IEEE arithmetic library for mathematical operations
use ieee.std_logic_unsigned.all;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity packet_checker is
	port(
		-- Input clk
		CLK                                     : in std_logic;
		EN                                      : in std_logic;
		
		-- Input from Tx and Rx BRAMs
		DIN_0                                   : in std_logic_vector(319 downto 0);
		DIN_1                                   : in std_logic_vector(319 downto 0);
		
		-- Correct packer reception indicator
		PCKT_CHK_C                              : out std_logic;
		PCKT_CHK_IC                             : out std_logic
	);
end packet_checker;



architecture Behavioral of packet_checker is

	signal counter                             : std_logic_vector(2 downto 0);
	signal pChk_c                              : std_logic;
	signal pChk_ic                             : std_logic;
	
	signal en_int                              : std_logic;
	
begin
	
	
	process(EN, DIN_0)
	begin
		pChk_c                                    <= '0';
		
		if EN = '1' then
			if DIN_0 = DIN_1 then
				pChk_c                              <= '1';
			end if;
		end if;
	end process;
	
	
	
	process(CLK)
	begin
		if(rising_edge(CLK)) then
			en_int                                 <= EN;
		end if;
	end process;
	
	
	
	process(en_int, DIN_0, DIN_1)
	begin
		pChk_ic                                   <= '0';

		
		if en_int = '1' then
			pChk_ic                                <= '0';
			
			if DIN_0 /= DIN_1 then
				pChk_ic                             <= '1';
			end if;
		end if;
	end process;
	
	PCKT_CHK_C                                   <= pChk_c;
	PCKT_CHK_IC                                  <= pChk_ic;


end Behavioral;

