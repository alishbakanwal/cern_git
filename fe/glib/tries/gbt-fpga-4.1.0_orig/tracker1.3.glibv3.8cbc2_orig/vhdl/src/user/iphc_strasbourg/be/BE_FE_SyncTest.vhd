----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:46:03 10/14/2013 
-- Design Name: 
-- Module Name:    BE_FE_SyncTest - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BE_FE_SyncTest is
   generic (    
      COMMON_STATIC_PATTERN                   	: std_logic_vector(83 downto 0) := x"0000BABEAC1DACDCFFFFF"; --used for SyncTest
		--
		STATIC_PATTERN	                 				: std_logic_vector(1 downto 0) := "10"; --from pattGen
		COUNTER_PATTERN	                 			: std_logic_vector(1 downto 0) := "01";
		--
		SYNC_TEST_IDLE										: std_logic_vector(1 downto 0) := "00";
		SYNC_TEST_GOOD										: std_logic_vector(1 downto 0) := "01";
		SYNC_TEST_FAIL										: std_logic_vector(1 downto 0) := "10"		
		
--    RESYNC_DELAY                       			: natural := 2   * 40e6  -- 2s    @ 40MHz --32-bit word (2**32-1)
--		SYNC_TEST_DELAY                      		: natural := 2   * 40e6  -- 2s    @ 40MHz --32-bit word (2**32-1)
			
				);
   port (   
      
      --===============--
      -- Resets scheme --
      --===============-- 
      
		-- General:
      -----------		
      GENERAL_RESET_I                           : in  std_logic;		
		
      --===============--
      -- Clocks scheme --
      --===============--
      CLK_I                            			: in  std_logic; 				
      
      --=======================--
      -- Test control & status --
      --=======================--
      
      -- Test pattern:
      ----------------
      
      TEST_PATTERN_SEL_I                        : in  std_logic_vector(1 downto 0);   --"01 : counter / "10" : static
		
      -- SFP status:
      --------------		
		sfp_presence_i										: in  std_logic;
		
      -- MGT GBT status:
      ------------------	
      MGT_READY_I                               : in std_logic;     
      RX_WORD_CLK_ALIGNED_I                     : in std_logic;
      RX_FRAME_CLK_ALIGNED_I                    : in std_logic;
      GBT_RX_READY_I                            : in std_logic;        

      -- TIMING From User:
      --------------------		
      RESYNC_DELAY                       			: std_logic_vector(31 downto 0); --32-bit word (Max = (2**32) * 25n = 100" )
		SYNC_TEST_DELAY                      		: std_logic_vector(31 downto 0); --32-bit word (Max = (2**32) * 25n = 100" )
		
		resyncWait_i										: in std_logic;

      -- Done :
      ----------------
		BE_FE_syncTest_done_o							: out std_logic; --'1' when sync done
		BE_FE_syncTest_result_o							: out std_logic_vector(1 downto 0); --"00" : NO / "01" : OK (done) / "10" : KO (fail) 
		BE_FE_syncTest_ErrorSeen_o						: out	std_logic;
      --===============--
      -- GBT Link data -- 
      --===============--
		from_gbtRx_data_i 								: in std_logic_vector(83 downto 0) --gbt_din
		
	);
			
		
		
end BE_FE_SyncTest;

architecture Behavioral of BE_FE_SyncTest is

signal BE_FE_syncTest_ErrorSeen						: std_logic:='0';

begin


BE_FE_syncTest_ErrorSeen_o <= BE_FE_syncTest_ErrorSeen;

   --============================ User Logic =============================--
   
   BE_FE_SyncTestFSM: process(GENERAL_RESET_I, CLK_I)   
      type stateT is (s0_idle, s1_resyncDelay, s2_syncTestDelay_StaticPattern,
                      s2_syncTestDelay_CounterPattern, s3_syncTestDone);
      variable state              		: stateT;      
      --variable timer              		: integer range 0 to (RESYNC_DELAY); --max !!! 
		variable timer              		: unsigned(RESYNC_DELAY'range);
		variable ErrorSeenCounter             : unsigned(RESYNC_DELAY'range);
		--
		variable from_gbtRx_data_i_unsigned 	: unsigned(from_gbtRx_data_i'range);
		variable previousCommonWord				: unsigned(20 downto 0);		
   begin
		--CAST
		from_gbtRx_data_i_unsigned := unsigned(from_gbtRx_data_i);
      --FSM
		if GENERAL_RESET_I = '1' then
         state                                  := s0_idle;
         timer                                  := (others=>'0');
			ErrorSeenCounter                       := (others=>'0');			
         BE_FE_syncTest_done_o                  <= '0';
			BE_FE_syncTest_result_o						<= SYNC_TEST_IDLE;
			BE_FE_syncTest_ErrorSeen        			<= '0';			
      --
		elsif rising_edge(CLK_I) then  
			--DEL
			previousCommonWord := unsigned(from_gbtRx_data_i(83 downto 63)); --from_gbtRx_data_i_unsigned(83 downto 63);
         --
			case state is
            --
				when s0_idle =>
					if (  -- Comment: Waits until MGT_READY to start after power up or general reset.
							MGT_READY_I						= '1'  	--to be sure that a data transmission is being performed
							--conditions from SFP (Physical)
							and sfp_presence_i 			= '1'  	--and others status...	
							and resyncWait_i				= '0'		--ctrl by user
						)
					then 
						state := s1_resyncDelay;
					end if;
					--init
					timer 									:= unsigned(RESYNC_DELAY); --preset the timer
					ErrorSeenCounter                 := (others=>'0');						
					BE_FE_syncTest_done_o            <= '0';
					BE_FE_syncTest_result_o				<= SYNC_TEST_IDLE;
					BE_FE_syncTest_ErrorSeen       <= '0';
				--
				when s1_resyncDelay =>  
					if timer = 0 then
						if 	TEST_PATTERN_SEL_I = STATIC_PATTERN then
							state := s2_syncTestDelay_StaticPattern;
						elsif TEST_PATTERN_SEL_I = COUNTER_PATTERN then 
							state := s2_syncTestDelay_CounterPattern;
						else
							null;
						end if;
						timer := unsigned(SYNC_TEST_DELAY); --preset the timer
					else	
						timer := timer - "01";
					end if;
				--
				when s2_syncTestDelay_StaticPattern =>  --
					if timer = 0 then
						state := s3_syncTestDone;
					elsif from_gbtRx_data_i /= COMMON_STATIC_PATTERN then
						ErrorSeenCounter := ErrorSeenCounter + "01";	
						BE_FE_syncTest_ErrorSeen <= '1';
					else
						null;
					end if;
					timer := timer - "01";
				--
				when s2_syncTestDelay_CounterPattern =>  --
					if timer = 0 then
						state := s3_syncTestDone;
					--elsif from_gbtRx_data_i_signed - from_gbtRx_data_i_signed_del1 /= to_signed(1,32) then
						--ErrorSeenCounter := ErrorSeenCounter + "01";	
						--BE_FE_syncTest_ErrorSeen        <= '1';
					-- Common counter pattern error detection:
					------------------------------------------
					elsif (	std_logic_vector(previousCommonWord + 1) 		/= from_gbtRx_data_i(83 downto 63)
								or from_gbtRx_data_i(83 downto 63)        	/= from_gbtRx_data_i(62 downto 42)
								or from_gbtRx_data_i(83 downto 63)       	 	/= from_gbtRx_data_i(41 downto 21)
								or from_gbtRx_data_i(83 downto 63)        	/= from_gbtRx_data_i(20 downto 0)
							)
					then
						ErrorSeenCounter := ErrorSeenCounter + "01";	
						BE_FE_syncTest_ErrorSeen  <= '1';						
					else
						null;						
					end if;
					timer := timer - "01";
				--
				when s3_syncTestDone =>
					if (		--ErrorSeenCounter 					= 0 
								BE_FE_syncTest_ErrorSeen		= '0'
								and RX_WORD_CLK_ALIGNED_I		= '1'  
								and RX_FRAME_CLK_ALIGNED_I 	= '1'  
								and GBT_RX_READY_I 				= '1'         
						)
					then
						BE_FE_syncTest_result_o <= SYNC_TEST_GOOD;
					else
						BE_FE_syncTest_result_o <= SYNC_TEST_FAIL;
						--BE_FE_syncTest_ErrorSeen        <= '1';
					end if;
					BE_FE_syncTest_done_o  <= '1';
					state := s3_syncTestDone;
			end case;
		end if;
	end process;
						

						
					
					
end Behavioral;

