---------------------------------------------------------------------------------------------------------------------------------
--  ENTITY				: 	ENCODING.VHD		
--  VERSION				:	0.2						
--  VENDOR SPECIFIC?	:	NO 
--  FPGA SPECIFIC? 		:   NO 
--  SOFTWARE RELEASE	:	QII 9.0 SP2
--  CREATION DATE		:	10/05/2009
--  LAST UPDATE     	:   07/07/2009  
--  AUTHORs				:	Frederic MARIN (CPPM), Sophie BARON (CERN)
--  LANGAGE 			:	VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--	DESCRIPTION			:	Gather 2 encoder blocks of 44 bits each. the upper encoder deals with TX_HEADER_I+bits83..44
--						the lower with bits43..0
--					
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--                      DATE            	VERSION           	AUTHOR		DESCRIPTION
--                      10/05/2009   		0.1                	MARIN   	first .BDF entity definition           
--						07/07/2009			0.2					BARON		bdf translation to vhdl entity
---------------------------------------------------------------------------------------------------------------------------------

-- MBM: (04/07/2013)
-- new names
-- no component declaration
-- port names
-- added widebus

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

use work.gbt_banks_user_setup.all;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ENTITY gbt_tx_encoder IS 
   generic (   
      GBT_BANK_ID                               : integer := 1   
   );
	PORT
	(
      TX_RESET_I        : IN  STD_LOGIC;
      TX_FRAMECLK_I : IN  STD_LOGIC;
		TX_ENCODING_SEL_I   : IN  STD_LOGIC_VECTOR(1 downto 0);
      TX_HEADER_I :  	IN  STD_LOGIC_VECTOR(3 DOWNTO 0);		
      TX_WIDEBUS_EXTRA_FRAME_I :	IN  STD_LOGIC_VECTOR(31 DOWNTO 0);  
      TX_FRAME_I :  	IN  STD_LOGIC_VECTOR(83 DOWNTO 0);      
		TX_FRAME_O :  	OUT  STD_LOGIC_VECTOR(119 DOWNTO 0)
	);
END gbt_tx_encoder;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
ARCHITECTURE rtl OF gbt_tx_encoder IS 

SIGNAL	sel_encodingSelector 		:  STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL	output_from_rsEncoder 		:  STD_LOGIC_VECTOR(119 DOWNTO 0);
SIGNAL	output_from_interleaver 	:  STD_LOGIC_VECTOR(119 DOWNTO 0);
SIGNAL	output_from_widebus 		   :  STD_LOGIC_VECTOR(119 DOWNTO 0);
SIGNAL	mixed_encoder_TX_FRAME_I   :  STD_LOGIC_VECTOR(43 DOWNTO 0);

---------------------------------------------------------------------------------------------------------------------------------

BEGIN 

mixed_encoder_TX_FRAME_I <= (TX_HEADER_I(3 DOWNTO 0) & TX_FRAME_I(83 DOWNTO 44));

reedSolomonEncoder0to59 : entity work.gbt_tx_encoder_gbtframe_rsencode
PORT MAP(msgin => TX_FRAME_I(43 DOWNTO 0),
		 codeout => output_from_rsEncoder(59 DOWNTO 0));


reedSolomonEncoder60to119 : entity work.gbt_tx_encoder_gbtframe_rsencode
PORT MAP(msgin => mixed_encoder_TX_FRAME_I,
		 codeout => output_from_rsEncoder(119 DOWNTO 60));

interleaver: entity work.gbt_tx_encoder_gbtframe_intlver
PORT MAP(
   TX_FRAME_I => output_from_rsEncoder,
	TX_FRAME_O => output_from_interleaver
	);

---------------------------------------------------------

   widebus_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_WIDE_BUS = true generate
      
      output_from_widebus   <= TX_HEADER_I & TX_FRAME_I & TX_WIDEBUS_EXTRA_FRAME_I;
   
   end generate;
   
   widebus_no_gen: if GBT_BANKS_USER_SETUP(GBT_BANK_ID).TX_WIDE_BUS = false generate
   
      output_from_widebus   <= (others => '0');
   
   end generate;

-----------------------------------------------------


encodingSelector:process(TX_RESET_I, TX_FRAMECLK_I)
begin
   if TX_RESET_I = '1' then
      sel_encodingSelector          <= "00";
   elsif rising_edge(TX_FRAMECLK_I) then   
      case TX_ENCODING_SEL_I is
         when "01" =>     
            sel_encodingSelector    <= "01";
         when "10" =>
            --8b10b
         when others =>
           sel_encodingSelector     <= "00"; 
      end case;
   end if;
end process;

   TX_FRAME_O      <= output_from_widebus when sel_encodingSelector = "01" else
--                    8b10b               when sel_encodingSelector = "10" else
                      output_from_interleaver;

END rtl;