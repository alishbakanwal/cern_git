----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.07.2016 14:12:19
-- Design Name: 
-- Module Name: xlx_ku_mgt_ip_reset_synchronizer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xlx_ku_mgt_ip_reset_synchronizer is                                            
   port (
      CLK_IN           : in  std_logic;
      RST_IN           : in  std_logic;
      RST_OUT          : out std_logic      
   );
end xlx_ku_mgt_ip_reset_synchronizer;

architecture Behavioral of xlx_ku_mgt_ip_reset_synchronizer is

    signal rst_in_meta:     std_logic;
    signal rst_in_sync1:    std_logic;
    signal rst_in_sync2:    std_logic;
    signal rst_in_sync3:    std_logic;
    signal rst_in_out:      std_logic;
    
begin

    rstFsm_proc: process(clk_in, rst_in)
    begin
        if rst_in = '1' then
            rst_in_meta     <= '1';
            rst_in_sync1    <= '1';
            rst_in_sync2    <= '1';
            rst_in_sync3    <= '1';
            rst_in_out      <= '1';
        elsif rising_edge(clk_in) then
            rst_in_meta     <= '0';
            rst_in_sync1    <= rst_in_meta;
            rst_in_sync2    <= rst_in_sync1;
            rst_in_sync3    <= rst_in_sync2;
            rst_in_out      <= rst_in_sync3;        
        end if;
    end process;
    
    rst_out <= rst_in_out;
    
end Behavioral;
