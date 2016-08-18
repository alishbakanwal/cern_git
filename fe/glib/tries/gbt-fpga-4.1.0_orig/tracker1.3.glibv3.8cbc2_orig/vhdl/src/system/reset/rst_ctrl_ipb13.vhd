library unisim;
use unisim.vcomponents.all;

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
-- Entity declaration for the example design
-------------------------------------------------------------------------------

----============--
entity rst_ctrl is
----============--
   port(
		clk					   : in  std_logic;
		ext_reset1_b			: in  std_logic;								
		ext_reset2_b			: in  std_logic;								
		rst_mac_o				: out std_logic;
		rst_gtx_o				: out std_logic;
		rst_fabric_o     		: out std_logic
   );
end rst_ctrl;
----============--


architecture reset_ctrl_arch of rst_ctrl is

signal rst_powerup_b 		: std_logic;
signal rst_short 				: std_logic;
signal rst_mac					: std_logic;
signal rst_gtx					: std_logic;
signal rst            		: std_logic;



begin

  -- PowerUp Reset generation
  reset_gen : component srl16
--  generic map (
--      INIT => X"FE3F")	-- 1111111000111111 (active low pulse of 3x8ns = 24ns > 20ns)
   port map (				-- see Fig.3-10. pp92, ug366		
    a0 => '1',
    a1 => '1',
    a2 => '1',
    a3 => '1',
    clk => clk,
    d => '1',
    q => rst_powerup_b);

	-- combine internal & external resets
	rst_short <= (not rst_powerup_b) or (not ext_reset1_b) or (not ext_reset2_b);

--	-- generate enet reset with fixed length/delay 
--	enet_rst_legthen : process(clk, rst_short)
--		variable enet_rst_delay : integer;
--		variable enet_rst_state	: std_logic:='0';
--		variable enet_rst_pulse	: std_logic_vector(7 downto 0):=x"1c"; -- 24ns pulse @125MHz
--	begin
--	if (rst_short = '1') then
--		reset_out <= '0';
--		enet_rst_delay :=40000;  -- 320us @ 125MHz;
--		enet_rst_state	:='0';
--		enet_rst_pulse	:=x"00";
--	elsif (clk = '1' and clk'event) then
--		case enet_rst_state is
--			--====--
--			when '0' =>	
--			--====--
--				reset_out <= '0';
--				if enet_rst_delay=0 then
--					enet_rst_state:='1';
--					enet_rst_pulse	:=x"1c";
--				else
--					enet_rst_delay:=enet_rst_delay-1;
--				end if;
--			--====--
--			when '1' =>
--			--====--
--			
--					reset_out <= enet_rst_pulse(7);
--					enet_rst_pulse := enet_rst_pulse(6 downto 0) & '0';
--			
--			--====--
--			when others =>
--			--====--
--		end case;	
--	end if;
--	end process;


 -- In Xilinx ethernet simulation reset is 15us.
  rst_gtx_legthen : process(clk)
    variable rst_cnt : natural;
  begin
    if (clk = '1' and clk'event) then
      if (rst_short = '1') then
--        if sim = TRUE then
--          rst_cnt := 2000;    -- 16us
--        else
          rst_cnt := 20000;  -- 160us  
--        end if;
        rst_gtx <= '1';
      elsif (rst_cnt > 0) then
        rst_cnt := rst_cnt - 1;
        rst_gtx <= '1';
      else
        rst_gtx <= '0';
      end if;
    end if;
  end process rst_gtx_legthen;

  -- In Xilinx ethernet simulation reset is 15us.
  rst_mac_legthen : process(clk)
    variable rst_cnt : natural;
  begin
    if (clk = '1' and clk'event) then
      if (rst_short = '1') then
--        if sim = TRUE then
--          rst_cnt := 4000;    -- 32us
--        else
          rst_cnt := 40000;  -- 320us
--        end if;
        rst_mac <= '1';
      elsif (rst_cnt > 0) then
        rst_cnt := rst_cnt - 1;
        rst_mac <= '1';
      else
        rst_mac <= '0';
      end if;
    end if;
  end process rst_mac_legthen;

--  -- In Xilinx TEMAC simulation reset is 15us.
--  rst_legthen : process(clk, enet_ok, enet_gtx_rst)
--    variable rst_cnt : natural;
--    variable init: std_logic;
--  begin
--    if (enet_ok /= '1') or (enet_gtx_rst = '1') then
--      rst <= '1';
--      init := '1';
--    elsif (clk = '1' and clk'event) then
--      if (init = '1') then
--        init := '0';
--        rst_cnt := 2500;   -- 20us
--        rst <= '1';
--      elsif (rst_cnt > 0) then
--        rst_cnt := rst_cnt - 1;
--        rst <= '1';
--      else
--        rst <= '0';
--      end if;
--    end if;
--  end process rst_legthen;

  -- In Xilinx ethernet simulation reset is 15us.
  rst_legthen : process(clk)
    variable rst_cnt : natural;
  begin
    if (clk = '1' and clk'event) then
      if (rst_short = '1') then
--        if sim = TRUE then
--          rst_cnt := 4000;    -- 32us
--        else
          rst_cnt := 4000000;  -- 32ms
--        end if;
        rst <= '1';
      elsif (rst_cnt > 0) then
        rst_cnt := rst_cnt - 1;
        rst <= '1';
      else
        rst <= '0';
      end if;
    end if;
  end process rst_legthen;




	rst_mac_o 		<= rst_mac;
	rst_gtx_o 		<= rst_gtx;
	rst_fabric_o 	<= rst;
	



end reset_ctrl_arch;