-- Handles the writing of ipbus data back to the output buffer in the correct format
--
-- tx_func encoding:
-- 00xy:
--  x = write word to packet
--  y = incr. word counter
-- 0100: header word
-- 0101: transaction info word
-- 0111: packet done
-- 1xxx: error; xxx:
--		000: header err
--		001: bad trans id
--		01X: bus error (x=write/not_read)
--		10X: timeout (x=write/not_read)

-- Dave Newbold, April 2011
--
-- $Id$

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity transactor_tx is
  port(
    clk: in std_logic; 
    reset: in std_logic;
    pkt_addr: out std_logic_vector(9 downto 0); -- output packet data pointer
    pkt_we: out std_logic; -- output packet data write enable
    pkt_done: out std_logic; -- asserted after last output packet word has been written
	 tx_func: in std_logic_vector(3 downto 0); -- tx function required
    tx_data: out std_logic_vector(31 downto 0); -- output packet data
    ipb_data: in std_logic_vector(31 downto 0); -- ipbus input data
    rx_data: in std_logic_vector(31 downto 0); -- header input data
    start: in std_logic -- asserted by rx when new packet starts
 );
end transactor_tx;

architecture rtl of transactor_tx is
  
  signal addr, hdr_addr: unsigned(9 downto 0);
  signal words: unsigned(8 downto 0);
  signal hdr, out_hdr, err_info: std_logic_vector(31 downto 0);
  signal err_code: std_logic_vector(2 downto 0);
    
begin

  process(clk)
  begin
    if rising_edge(clk) then

      if reset = '1' then
        
        err_info <= (others => '0');
        addr <= "0000000001";
        pkt_we <= '0';
        pkt_done <= '0';
        hdr_addr <= "0000000001";
        
      elsif start = '1' then
        
        pkt_done <= '0';

      elsif tx_func(3) = '0' then
        
        if tx_func(2) = '1' then

          if tx_func(1 downto 0) = "00" then

-- Header word

            hdr_addr <= addr;
            hdr <= rx_data;
            tx_data <= out_hdr;
            pkt_we <= '1';
            pkt_addr <= std_logic_vector(hdr_addr);
            
            words <= (others => '0');
            addr <= addr + 1;
            
          elsif tx_func(1 downto 0) = "01" then

-- Transaction info word
            
            tx_data <= ipb_data;
            pkt_we <= '1';
            pkt_addr <= std_logic_vector(addr);
            addr <= addr + 1;
            words <= words + 1;

          elsif tx_func(1 downto 0) = "11" then

-- End of packet

            pkt_we <= '1';
            tx_data <= X"0000" & "000000" & std_logic_vector(addr - 2);
            pkt_addr <= (others => '0');
            hdr_addr <= "0000000001";
            pkt_done <= '1';
            addr <= "0000000001";
            
          end if;

        else

            
-- Data word / idle
            
          if tx_func(1)='1' then
					  tx_data <= ipb_data;
				  	 pkt_we <= '1';
            pkt_addr <= std_logic_vector(addr);
            addr <= addr + 1;
          else
            pkt_we <= '0';
          end if;

          if tx_func(0) ='1' then
            words <= words + 1;
          end if;
         
        end if;
        
      else
        
-- Error info word
                
			  err_info(10 downto 0) <= hdr(27 downto 17);
		    err_info(20 downto 12) <= std_logic_vector(words);
			  err_info(26 downto 24) <= err_code;
        tx_data <= out_hdr;
        pkt_we <= '1';
        pkt_addr <= std_logic_vector(hdr_addr);
        addr <= addr + 1;
            
      end if;

    end if; 
  end process;
    
  out_hdr <= hdr(31 downto 17) & std_logic_vector(words) & hdr(7 downto 3) & '1' & tx_func(3) & '0';

end rtl;
