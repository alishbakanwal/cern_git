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
--	DESCRIPTION			:	Gather 2 encoder blocks of 44 bits each. the upper encoder deals with header+bits83..44
--						the lower with bits43..0
--					
---------------------------------------------------------------------------------------------------------------------------------
--	VERSIONS HISTORY	:
--                      DATE            	VERSION           	AUTHOR		DESCRIPTION
--                      10/05/2009   		0.1                	MARIN   	first .BDF entity definition           
--						07/07/2009			0.2					BARON		bdf translation to vhdl entity
---------------------------------------------------------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

ENTITY Encoding IS 
	PORT
	(
		Header :  	IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		Input :  	IN  STD_LOGIC_VECTOR(83 DOWNTO 0);
		Output :  	OUT  STD_LOGIC_VECTOR(119 DOWNTO 0)
	);
END Encoding;

---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------
ARCHITECTURE rtl OF Encoding IS 

COMPONENT rsencoder
	PORT(msgin : IN STD_LOGIC_VECTOR(43 DOWNTO 0);
		 codeout : OUT STD_LOGIC_VECTOR(59 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	Temp_Output 		:  STD_LOGIC_VECTOR(119 DOWNTO 0);
SIGNAL	mixed_encoder_input :  STD_LOGIC_VECTOR(43 DOWNTO 0);

---------------------------------------------------------------------------------------------------------------------------------

BEGIN 

mixed_encoder_input <= (Header(3 DOWNTO 0) & Input(83 DOWNTO 44));


RSEncoder_41_0 : rsencoder
PORT MAP(msgin => Input(43 DOWNTO 0),
		 codeout => Temp_Output(59 DOWNTO 0));


RSEncoder_83_42 : rsencoder
PORT MAP(msgin => mixed_encoder_input,
		 codeout => Temp_Output(119 DOWNTO 60));

Output <= Temp_Output;

END rtl;