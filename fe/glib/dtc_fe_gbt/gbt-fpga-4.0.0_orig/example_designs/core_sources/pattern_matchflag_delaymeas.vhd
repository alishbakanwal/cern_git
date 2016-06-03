-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity pattern_matchflag_delaymeas is   
   port (   
      
      --===============--
      -- General reset --
      --===============--
      RESET_I                                                  : in  std_logic; 
    
      --===============--
      -- Clocks scheme --
      --===============--

      -- Ref clock:
      -----------------
      CLK_I                                               	   : in  std_logic;
		
      --==============--
      -- MatchFlag --
      --==============--
      TX_MATCHFLAG_I                                            : in  std_logic;
      RX_MATCHFLAG_I                                            : in  std_logic;
		
		--==============--
		-- Delay        --
		--==============--
		DELAY_O																	  : out std_logic_vector(31 downto 0)	
   );
end pattern_matchflag_delaymeas;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of pattern_matchflag_delaymeas is

    -- TYPES
    type delaycomp_FSM_T is (s0_waitForTxMatchFlag, s1_waitForRxMatchFlag);
	 
	 signal counter			: integer;
	 signal delaycomp			: delaycomp_FSM_T;
	 
begin

	measproc_inst: process(CLK_I)
	begin
	
		if RESET_I = '1' then
			counter <= 0;
			DELAY_O <= (others => '0');
			delaycomp <= s0_waitForTxMatchFlag;
			
		elsif rising_edge(CLK_I) then
			case (delaycomp) is
				
				when s0_waitForTxMatchFlag =>
					if (TX_MATCHFLAG_I = '1') then 
						delaycomp <= s1_waitForRxMatchFlag;
						counter <= 0;
					end if;
				
				when s1_waitForRxMatchFlag =>
					counter <= counter + 1;
					
					if (RX_MATCHFLAG_I = '1') then
						delaycomp <= s0_waitForTxMatchFlag;
						DELAY_O <= std_logic_vector(to_unsigned(counter, 32));
					end if;
					
			end case;
			
		end if;
	end process;
end;