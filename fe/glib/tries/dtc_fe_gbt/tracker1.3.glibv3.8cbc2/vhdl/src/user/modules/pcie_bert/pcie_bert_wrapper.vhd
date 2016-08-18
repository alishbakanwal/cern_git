--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   12/11/2012		 																			
-- Project Name:			pcie_demo																					
-- Module Name:   		pcie_bert_wrapper		 																	
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
-- User libraries and packages:
use work.user_pcie_bert_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity pcie_bert_wrapper is		
	port(  		
		-- Reset and clock:	
		RESET_I										: in  std_logic;		
		DMA_CLK_I									: in  std_logic;	
		-- Read:						
		DMA_RDCHANNEL_I							: in  std_logic_vector( 7 downto 0);	
      DMA_RDTRANS_SIZE_I			         : in  std_logic_vector(31 downto 0);
      DMA_RDSTATUS_I						      : in  std_logic_vector( 3 downto 0);
		DMA_RD_I										: in  std_logic;		
		DMA_RDADDR_I								: in  std_logic_vector(31 downto 0);
		DMA_RDDATA_O								: out std_logic_vector(63 downto 0); 	
     -- Write:
		DMA_WRCHANNEL_I							: in  std_logic_vector( 7 downto 0);
      DMA_WRTRANS_SIZE_I				      : in  std_logic_vector(31 downto 0);
      DMA_WRSTATUS_I				            : in  std_logic_vector( 3 downto 0);   
		DMA_WR_I										: in  std_logic;
		DMA_WRADDR_I								: in  std_logic_vector(31 downto 0);	 
		DMA_WRDATA_I								: in  std_logic_vector(63 downto 0);
		-- BER test:
		BERT_RESET_I 								: in  std_logic;
		BERT_2DW_CNTR_O			            : out std_logic_vector(28 downto 0);
		BERT_ERROR_CNTR_O  						: out std_logic_vector(31 downto 0);
		BERT_ERROR_FLAG_O							: out std_logic;		
		BERT_NOERR_FLAG_O							: out std_logic	
	);
end pcie_bert_wrapper;
architecture behavioural of pcie_bert_wrapper is	
	--============================ Declarations ===========================--
	-- Dummy signals:
	signal dma_rdaddr_dummy						: std_logic_vector(31 downto 0);
	signal dma_wraddr_dummy						: std_logic_vector(31 downto 0);
	
	-- Signals:
	signal prbs_reset_from_pg					: std_logic;
	signal prbs_reset_from_pchk				: std_logic;
	signal prbs_reset								: std_logic;
	signal prbs_enable_from_pg 				: std_logic;
	signal prbs_enable_from_pchk				: std_logic;
	signal prbs_enable   						: std_logic;
	signal pdv_from_prbs							: std_logic;
	signal pdata_from_prbs						: std_logic_vector(63 downto 0);
 	signal bussy_from_pchk   					: std_logic;     
	signal pchk_enable_from_pg   				: std_logic;
	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--===================== Component Instantiations ======================--
	-- Dummy Registers (To avoid signal trimming for Chipscope):
	dummy_register: process(RESET_I, DMA_CLK_I)
	begin
		if RESET_I = '1' then
			dma_rdaddr_dummy						<= (others => '0');
			dma_wraddr_dummy						<= (others => '0');
		elsif rising_edge(DMA_CLK_I) then
			dma_rdaddr_dummy						<= DMA_RDADDR_I;
			dma_wraddr_dummy						<= DMA_WRADDR_I;		
		end if;
	end process;	
	
	-- Pattern Generator Control:
	pattern_generator_control: entity work.pcie_bert_gen_ctrl
		generic map (
			DMA_RDCHANNEL_BIT						=> DMA_RDCHANNEL_BIT)		
		port map (			
			RESET_I					            => RESET_I,
         DMA_CLK_I				            => DMA_CLK_I,
         PCHK_BUSSY_I		               => bussy_from_pchk,
         DMA_RDCHANNEL_I 						=> DMA_RDCHANNEL_I,
         DMA_RDTRANS_SIZE_I               => DMA_RDTRANS_SIZE_I,
         DMA_RDSTATUS_I						   => DMA_RDSTATUS_I,                  
			DMA_RD_I 								=> DMA_RD_I, 
         PRBS_DATA_I								=> pdata_from_prbs,
         PRBS_RESET_O						   => prbs_reset_from_pg,
         PRBS_ENABLE_O							=>	prbs_enable_from_pg,	
			DMA_RDDATA_O							=>	DMA_RDDATA_O,
         PCHK_ENABLE_O						   => pchk_enable_from_pg
		);
      
	-- PRBS-31 Generator:
	prbs31_generator: entity work.PRBS_pcie_bert 
		port map (
			CLOCK 									=> DMA_CLK_I,
			ARESET 									=> prbs_reset,
			ENABLE 									=> prbs_enable,
			SEED 										=> "0000000000000000000000000000001",
			SDV 										=> open,
			SDATA 									=> open,
			PDV 										=> pdv_from_prbs,
			PDATA 									=> pdata_from_prbs
		);
		prbs_reset									<= RESET_I or prbs_reset_from_pg or prbs_reset_from_pchk;
		prbs_enable									<= prbs_enable_from_pg or prbs_enable_from_pchk;	
		
	-- Pattern Checker:		
	pattern_checker: entity work.pcie_bert_chk
		generic map (
			DMA_WRCHANNEL_BIT						=> DMA_WRCHANNEL_BIT)		
		port map (
			RESET_I 									=> RESET_I,
			DMA_CLK_I 								=> DMA_CLK_I,
         ENABLE_I                         => pchk_enable_from_pg,
			DMA_WRCHANNEL_I 						=> DMA_WRCHANNEL_I,
			DMA_WRTRANS_SIZE_I				   => DMA_WRTRANS_SIZE_I,
         DMA_WRSTATUS_I						   => DMA_WRSTATUS_I,		
         DMA_WR_I 								=> DMA_WR_I,			
			DMA_WRDATA_I 							=> DMA_WRDATA_I,
			PRBS_RESET_O							=> prbs_reset_from_pchk,
			PRBS_ENABLE_O							=> prbs_enable_from_pchk,
			PRBS_DATA_VALID_I						=> pdv_from_prbs,
			PRBS_DATA_I								=> pdata_from_prbs,			
			BERT_RESET_I								=> BERT_RESET_I,
			BERT_2DW_CNTR_O			            => BERT_2DW_CNTR_O,
         BERT_ERROR_CNTR_O  					=> BERT_ERROR_CNTR_O,
			BERT_ERROR_FLAG_O						=> BERT_ERROR_FLAG_O,
			BERT_NOERR_FLAG_O						=> BERT_NOERR_FLAG_O,
         BUSSY_O						         => bussy_from_pchk
		);			
	--=====================================================================--	
end behavioural;
--=================================================================================================--
--=================================================================================================--