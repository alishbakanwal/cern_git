--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Paschalis Vichoudis	                                                   
-- 							Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)	
-- 																															
-- Create Date:		   28/01/2013      																			
-- Project Name:			bert_wrapper														                  
-- Module Name:   		bert_wrapper							 													
-- 																															
-- Language:				VHDL'93                                      									
--																																
-- Target Devices: 		GLIB (Virtex 6)																			
-- Tool versions: 		ISE 13.2          																		
--																																
-- Revision:		 		1.0 																							
--																																
-- Additional Comments: 																								
--																																
--=================================================================================================--
--=================================================================================================--
-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--

entity bert_wrapper is
	generic (			
      N                                : integer := 84;
      BERT_DLY                         : integer := 8
	);
	port (	
      -- Reset and clocks:
      RESET_I			                  : in	std_logic;
      TX_CLK_I					            : in	std_logic;	 
      RX_CLK_I      			            : in	std_logic;
      -- Data:
      TX_DATA_I						      : in	std_logic_vector(N-1 downto 0);
      RX_DATA_I	   				      : in	std_logic_vector(N-1 downto 0);      
      -- BERT:     
      BERT_TX_O_REG_O						: out	std_logic_vector(N-1 downto 0);
      BERT_RX_O_REG_O						: out	std_logic_vector(N-1 downto 0);
      BERT_NUMBER_OF_WORDS_O				: out	std_logic_vector( 63 downto 0);	
      BERT_NUMBER_OF_WORD_ERRORS_O		: out	std_logic_vector( 63 downto 0);
      BERT_WORD_ERROR_O					   : out	std_logic;
      -- Pattern detector:        
      PD_TX_MATCHFLAG_O				      : out std_logic;
      PD_RX_MATCHFLAG_O				      : out std_logic;	   
      -- Control/Status registers interface:
      RESET_IF_I						      : in	std_logic;
      CLK_IF_I							      : in	std_logic;
      ----------------
      BERT_ENABLE_IF_I						: in	std_logic;		
      BERT_CLEAR_IF_I						: in	std_logic;		
      BERT_LOAD_IF_I						   : in	std_logic;		
      BERT_LATCH_IF_I						: in	std_logic;		
      BERT_LATENCY_IF_I					   : in	std_logic_vector(  5 downto 0);
      BERT_NUMBER_OF_WORDS_IF_O			: out	std_logic_vector( 63 downto 0);	
      BERT_NUMBER_OF_WORD_ERRORS_IF_O	: out	std_logic_vector( 63 downto 0);  
      -------------------------------
      PD_ENABLE_IF_I                   : in  std_logic;
      PD_CHECKWIDTH_IF_I               : in  std_logic_vector(  7 downto 0);
		PD_PATTERN_IF_I		            : in  std_logic_vector(N-1 downto 0);
      PD_DEASSERTDELAY_IF_I            : in  std_logic_vector(  7 downto 0) 
	);
end bert_wrapper;
architecture structural of bert_wrapper is
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--===================== Component Instantiations ======================--
	-- BERT:
   bert_module: entity work.bert
      generic map(
         N                             => N)       
      port map(
         TX_CLK_I                      => TX_CLK_I,
         RX_CLK_I                      => RX_CLK_I,
         TX_I                          => TX_DATA_I,
         RX_I                          => RX_DATA_I,
         TX_O_REG_O                    => BERT_TX_O_REG_O,
         RX_O_REG_O                    => BERT_RX_O_REG_O,
         NUMBER_OF_WORDS_O             => BERT_NUMBER_OF_WORDS_O,
         NUMBER_OF_WORD_ERRORS_O       => BERT_NUMBER_OF_WORD_ERRORS_O,
         WORD_ERROR_O                  => BERT_WORD_ERROR_O,
         CLK_IF_I                      => CLK_IF_I,
         RESET_IF_I                    => RESET_IF_I,
         ENABLE_IF_I                   => BERT_ENABLE_IF_I,
         CLEAR_IF_I                    => BERT_CLEAR_IF_I,
         LOAD_IF_I                     => BERT_LOAD_IF_I,
         LATCH_IF_I                    => BERT_LATCH_IF_I,
         LATENCY_IF_I                  => BERT_LATENCY_IF_I,
         NUMBER_OF_WORDS_IF_O          => BERT_NUMBER_OF_WORDS_IF_O,
         NUMBER_OF_WORD_ERRORS_IF_O    => BERT_NUMBER_OF_WORD_ERRORS_IF_O  
      );
   -- TX Pattern detector:
   tx_pattern_detector: entity work.pattern_detector
      generic map(
         N                             => N)   
      port map(
         RESET_I                       => RESET_I,
         CLK_I                         => TX_CLK_I,
         DATA_I                        => TX_DATA_I,
         MATCHFLAG_O                   => PD_TX_MATCHFLAG_O,
         -- Control/Status registers interface: 
         CLK_IF_I                      => CLK_IF_I,
         ENABLE_IF_I                   => PD_ENABLE_IF_I,
         CHECKWIDTH_IF_I               => PD_CHECKWIDTH_IF_I,
         PATTERN_IF_I                  => PD_PATTERN_IF_I,
         DEASSERTDELAY_IF_I            => PD_DEASSERTDELAY_IF_I
      );
   -- RX Pattern detector:
   rx_pattern_detector: entity work.pattern_detector
      generic map(
         N                             => N)   
      port map(
         RESET_I                       => RESET_I,
         CLK_I                         => RX_CLK_I,
         DATA_I                        => RX_DATA_I,
         MATCHFLAG_O                   => PD_RX_MATCHFLAG_O,
         -- Control/Status registers interface: 
         CLK_IF_I                      => CLK_IF_I,
         ENABLE_IF_I                   => PD_ENABLE_IF_I,
         CHECKWIDTH_IF_I               => PD_CHECKWIDTH_IF_I,
         PATTERN_IF_I                  => PD_PATTERN_IF_I,
         DEASSERTDELAY_IF_I            => PD_DEASSERTDELAY_IF_I   
      );
	--=====================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--