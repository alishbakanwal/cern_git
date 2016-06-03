--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Julian Mendez (julian.mendez@cern.ch)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           Altera Stratix V - GBT Bank example design                                         
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Altera Stratix V                                                        
-- Tool version:          Quartus II 14.0                                                               
--                                                                                                   
-- Version:               3.6                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        11/03/2016   1.0       J. Mendez         First .vhd module definition                 
--
--                                                                                              
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Altera devices library:
library altera; 
library altera_mf;
library lpm;
use altera.altera_primitives_components.all;   
use altera_mf.altera_mf_components.all;
use lpm.lpm_components.all;

-- Custom libraries and packages:
use work.gbt_bank_package.all;
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity alt_ax_gbt_example_design_qsys is
	generic (
		GBT_BANK_ID											: integer := 0;
		NUM_LINKS											: integer := 1;
		TX_OPTIMIZATION										: integer range 0 to 1 := STANDARD;
		RX_OPTIMIZATION										: integer range 0 to 1 := STANDARD;
		TX_ENCODING											: integer range 0 to 1 := GBT_FRAME;
		RX_ENCODING											: integer range 0 to 1 := GBT_FRAME;
		
		-- Extended configuration --
		DATA_GENERATOR_ENABLE								: integer range 0 to 1 := 1;
		DATA_CHECKER_ENABLE									: integer range 0 to 1 := 1;
		MATCH_FLAG_ENABLE									: integer range 0 to 1 := 1
	);
   port ( 

		--==============--
		-- Clocks       --
		--==============--
		FRAMECLK_40MHZ												: in  std_logic;
		XCVRCLK														: in  std_logic;
				
		TX_FRAMECLK_O												: out std_logic_vector(1 to NUM_LINKS);
		RX_FRAMECLK_O												: out std_logic_vector(1 to NUM_LINKS);
		TX_WORDCLK_O												: out std_logic_vector(1 to NUM_LINKS);
		RX_WORDCLK_O												: out std_logic_vector(1 to NUM_LINKS);
		
		--==============--
		-- Reset        --
		--==============--
		GBTBANK_GENERAL_RESET_I									: in  std_logic;
		GBTBANK_MANUAL_RESET_TX_I								: in  std_logic;
		GBTBANK_MANUAL_RESET_RX_I								: in  std_logic;
		
		--==============--
		-- Serial lanes --
		--==============--
		GBTBANK_MGT_RX												: in  std_logic_vector(1 to NUM_LINKS);
		GBTBANK_MGT_TX												: out std_logic_vector(1 to NUM_LINKS);
		
		--==============--
		-- Data			 --
		--==============--		
		GBTBANK_GBT1_DATA_I									: in  std_logic_vector(83 downto 0);
		GBTBANK_GBT2_DATA_I									: in  std_logic_vector(83 downto 0);
		GBTBANK_GBT3_DATA_I									: in  std_logic_vector(83 downto 0);
		GBTBANK_GBT4_DATA_I									: in  std_logic_vector(83 downto 0);
		GBTBANK_GBT5_DATA_I									: in  std_logic_vector(83 downto 0);
		GBTBANK_GBT6_DATA_I									: in  std_logic_vector(83 downto 0);
		
		GBTBANK_WB1_DATA_I									: in  std_logic_vector(115 downto 0);
		GBTBANK_WB2_DATA_I									: in  std_logic_vector(115 downto 0);
		GBTBANK_WB3_DATA_I									: in  std_logic_vector(115 downto 0);
		GBTBANK_WB4_DATA_I									: in  std_logic_vector(115 downto 0);
		GBTBANK_WB5_DATA_I									: in  std_logic_vector(115 downto 0);
		GBTBANK_WB6_DATA_I									: in  std_logic_vector(115 downto 0);
		
		GBTBANK_GBT1_DATA_O									: out std_logic_vector(83 downto 0);
		GBTBANK_GBT2_DATA_O									: out std_logic_vector(83 downto 0);
		GBTBANK_GBT3_DATA_O									: out std_logic_vector(83 downto 0);
		GBTBANK_GBT4_DATA_O									: out std_logic_vector(83 downto 0);
		GBTBANK_GBT5_DATA_O									: out std_logic_vector(83 downto 0);
		GBTBANK_GBT6_DATA_O									: out std_logic_vector(83 downto 0);
		
		GBTBANK_WB1_DATA_O									: out std_logic_vector(115 downto 0);
		GBTBANK_WB2_DATA_O									: out std_logic_vector(115 downto 0);
		GBTBANK_WB3_DATA_O									: out std_logic_vector(115 downto 0);
		GBTBANK_WB4_DATA_O									: out std_logic_vector(115 downto 0);
		GBTBANK_WB5_DATA_O									: out std_logic_vector(115 downto 0);
		GBTBANK_WB6_DATA_O									: out std_logic_vector(115 downto 0);
		
		--==============--
		-- Reconf.		 --
		--==============--
		GBTBANK_RECONF_AVMM_RST									: in  std_logic;
		GBTBANK_RECONF_AVMM_CLK									: in  std_logic;
		GBTBANK_RECONF_AVMM_ADDR								: in  std_logic_vector(12 downto 0);
		GBTBANK_RECONF_AVMM_READ								: in  std_logic;
		GBTBANK_RECONF_AVMM_WRITE								: in  std_logic;
		GBTBANK_RECONF_AVMM_WRITEDATA							: in  std_logic_vector(31 downto 0);
		GBTBANK_RECONF_AVMM_READDATA							: out std_logic_vector(31 downto 0);
		GBTBANK_RECONF_AVMM_WAITREQUEST							: out std_logic;
			
		--==============--
		-- TX ctrl	    --
		--==============--
		GBTBANK_TX1_ISDATA_SEL_I								: in  std_logic;
		GBTBANK_TX2_ISDATA_SEL_I								: in  std_logic;
		GBTBANK_TX3_ISDATA_SEL_I								: in  std_logic;
		GBTBANK_TX4_ISDATA_SEL_I								: in  std_logic;
		GBTBANK_TX5_ISDATA_SEL_I								: in  std_logic;
		GBTBANK_TX6_ISDATA_SEL_I								: in  std_logic;
		
		GBTBANK_TEST_PATTERN_SEL_I								: in  std_logic_vector(1 downto 0);
		
		--==============--
		-- RX ctrl      --
		--==============--
		GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I       			: in  std_logic_vector(1 to NUM_LINKS);             
		GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I         		: in  std_logic_vector(1 to NUM_LINKS);
			
		
		--==============--
		-- TX Status    --
		--==============--
		GBTBANK_LINK1_TX_READY_O								 : out std_logic;
		GBTBANK_LINK2_TX_READY_O								 : out std_logic;
		GBTBANK_LINK3_TX_READY_O								 : out std_logic;
		GBTBANK_LINK4_TX_READY_O								 : out std_logic;
		GBTBANK_LINK5_TX_READY_O								 : out std_logic;
		GBTBANK_LINK6_TX_READY_O								 : out std_logic;
		
		GBTBANK_GBTRX_READY_O									 : out std_logic_vector(1 to NUM_LINKS);
		GBTBANK_LINK_RX_READY_O								 	 : out std_logic_vector(1 to NUM_LINKS);
		GBTBANK_LINK_READY_O									 : out std_logic_vector(1 to NUM_LINKS);
		GBTBANK_TX_MATCHFLAG_O									 : out std_logic;
			
		--==============--
		-- RX Status    --
		--==============--
		GBTBANK_RX1_ISDATA_SEL_O								: out std_logic;
		GBTBANK_RX2_ISDATA_SEL_O								: out std_logic;
		GBTBANK_RX3_ISDATA_SEL_O								: out std_logic;
		GBTBANK_RX4_ISDATA_SEL_O								: out std_logic;
		GBTBANK_RX5_ISDATA_SEL_O								: out std_logic;
		GBTBANK_RX6_ISDATA_SEL_O								: out std_logic;
		
		GBTBANK_GBTRXREADY_LOST_FLAG_O         			 : out std_logic_vector(1 to NUM_LINKS);
		GBTBANK_RXDATA_ERRORSEEN_FLAG_O                  : out std_logic_vector(1 to NUM_LINKS);
		GBTBANK_RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O     : out std_logic_vector(1 to NUM_LINKS);
		GBTBANK_RX_MATCHFLAG_O							 : out std_logic_vector(1 to NUM_LINKS);
		
		--==============--
		-- XCVR ctrl    --
		--==============--
		GBTBANK_LOOPBACK_I										 : in  std_logic_vector(1 to NUM_LINKS);
		GBTBANK_TX_POL											 : in  std_logic_vector(1 to NUM_LINKS);
		GBTBANK_RX_POL											 : in  std_logic_vector(1 to NUM_LINKS);
		GBTBANK_TXWORDCLKMON_EN									 : in  std_logic
		        
   );
end alt_ax_gbt_example_design_qsys;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of alt_ax_gbt_example_design_qsys is 
   
   --================================ Signal Declarations ================================--   
	component alt_ax_gbt_example_design is
		generic (
			GBT_BANK_ID											: integer := 1;
			NUM_LINKS											: integer := 1;
			TX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
			RX_OPTIMIZATION									: integer range 0 to 1 := STANDARD;
			TX_ENCODING											: integer range 0 to 1 := GBT_FRAME;
			RX_ENCODING											: integer range 0 to 1 := GBT_FRAME;
			
			-- Extended configuration --
			DATA_GENERATOR_ENABLE							: integer range 0 to 1 := 1;
			DATA_CHECKER_ENABLE								: integer range 0 to 1 := 1;
			MATCH_FLAG_ENABLE									: integer range 0 to 1 := 1
		);
	   port ( 

			--==============--
			-- Clocks       --
			--==============--
			FRAMECLK_40MHZ												: in  std_logic;
			XCVRCLK												: in  std_logic;
					
			TX_FRAMECLK_O												: out std_logic_vector(1 to NUM_LINKS);
			RX_FRAMECLK_O												: out std_logic_vector(1 to NUM_LINKS);
			TX_WORDCLK_O												: out std_logic_vector(1 to NUM_LINKS);
			RX_WORDCLK_O												: out std_logic_vector(1 to NUM_LINKS);
			
			--==============--
			-- Reset        --
			--==============--
			GBTBANK_GENERAL_RESET_I									: in  std_logic;
			GBTBANK_MANUAL_RESET_TX_I								: in  std_logic;
			GBTBANK_MANUAL_RESET_RX_I								: in  std_logic;
			
			--==============--
			-- Serial lanes --
			--==============--
			GBTBANK_MGT_RX												: in  std_logic_vector(1 to NUM_LINKS);
			GBTBANK_MGT_TX												: out std_logic_vector(1 to NUM_LINKS);
			
			--==============--
			-- Data			 --
			--==============--		
			GBTBANK_GBT_DATA_I										: in  gbtframe_A(1 to NUM_LINKS);
			GBTBANK_WB_DATA_I											: in  wbframe_A(1 to NUM_LINKS);
			GBTBANK_GBT_DATA_O										: out gbtframe_A(1 to NUM_LINKS);
			GBTBANK_WB_DATA_O											: out wbframe_A(1 to NUM_LINKS);
			
			--==============--
			-- Reconf.		 --
			--==============--
			GBTBANK_RECONF_AVMM_RST									: in  std_logic;
			GBTBANK_RECONF_AVMM_CLK									: in  std_logic;
			GBTBANK_RECONF_AVMM_ADDR								: in  std_logic_vector(12 downto 0);
			GBTBANK_RECONF_AVMM_READ								: in  std_logic;
			GBTBANK_RECONF_AVMM_WRITE								: in  std_logic;
			GBTBANK_RECONF_AVMM_WRITEDATA							: in  std_logic_vector(31 downto 0);
			GBTBANK_RECONF_AVMM_READDATA							: out std_logic_vector(31 downto 0);
			GBTBANK_RECONF_AVMM_WAITREQUEST						: out std_logic;
				
			--==============--
			-- TX ctrl	    --
			--==============--
			GBTBANK_TX_ISDATA_SEL_I									: in  std_logic_vector(1 to NUM_LINKS);
			GBTBANK_TEST_PATTERN_SEL_I								: in  std_logic_vector(1 downto 0);
			
			--==============--
			-- RX ctrl      --
			--==============--
			GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I       		: in  std_logic_vector(1 to NUM_LINKS);             
			GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I         		: in  std_logic_vector(1 to NUM_LINKS);
				
			
			--==============--
			-- TX Status    --
			--==============--
			GBTBANK_GBTRX_READY_O									 : out std_logic_vector(1 to NUM_LINKS);
			GBTBANK_LINK_TX_READY_O								 	 : out std_logic_vector(1 to NUM_LINKS);
			GBTBANK_LINK_RX_READY_O								 	 : out std_logic_vector(1 to NUM_LINKS);
			GBTBANK_LINK_READY_O									 	 : out std_logic_vector(1 to NUM_LINKS);
			GBTBANK_TX_MATCHFLAG_O									 : out std_logic;
				
			--==============--
			-- RX Status    --
			--==============--
			GBTBANK_RX_ISDATA_SEL_O								: out std_logic_vector(1 to NUM_LINKS);
			GBTBANK_GBTRXREADY_LOST_FLAG_O         			 : out std_logic_vector(1 to NUM_LINKS);
			GBTBANK_RXDATA_ERRORSEEN_FLAG_O                  : out std_logic_vector(1 to NUM_LINKS);
			GBTBANK_RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O     : out std_logic_vector(1 to NUM_LINKS);
			GBTBANK_RX_MATCHFLAG_O									 : out std_logic_vector(1 to NUM_LINKS);
			
			--==============--
			-- XCVR ctrl    --
			--==============--
			GBTBANK_LOOPBACK_I										 : in  std_logic_vector(1 to NUM_LINKS);
			GBTBANK_TX_POL												 : in  std_logic_vector(1 to NUM_LINKS);
			GBTBANK_RX_POL												 : in  std_logic_vector(1 to NUM_LINKS);
			GBTBANK_TXWORDCLKMON_EN									 : in  std_logic
					
	   );
	
	end component;
   --=====================================================================================--    

	signal TX_GBTBANK_GBT_DATA										: gbtframe_A(1 to NUM_LINKS);
	signal TX_GBTBANK_WB_DATA										: wbframe_A(1 to NUM_LINKS);
	signal RX_GBTBANK_GBT_DATA										: gbtframe_A(1 to NUM_LINKS);
	signal RX_GBTBANK_WB_DATA										: wbframe_A(1 to NUM_LINKS);
	
	signal TX_IS_DATASEL_sig										: std_logic_vector(1 to NUM_LINKS);
	signal GBTBANK_LINK_TX_READY_sig								: std_logic_vector(1 to NUM_LINKS);
	signal RX_IS_DATASEL_sig										: std_logic_vector(1 to NUM_LINKS);
	
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--
   
   --==================================== User Logic =====================================--
	gbtBank: alt_ax_gbt_example_design 
		generic map(
			GBT_BANK_ID											=> GBT_BANK_ID,
			NUM_LINKS											=> NUM_LINKS,
			TX_OPTIMIZATION										=> TX_OPTIMIZATION,
			RX_OPTIMIZATION										=> RX_OPTIMIZATION,
			TX_ENCODING											=> TX_ENCODING,
			RX_ENCODING											=> RX_ENCODING,
			
			-- Extended configuration --
			DATA_GENERATOR_ENABLE								=> DATA_GENERATOR_ENABLE,
			DATA_CHECKER_ENABLE									=> DATA_CHECKER_ENABLE,
			MATCH_FLAG_ENABLE									=> MATCH_FLAG_ENABLE
		)
	   port map( 

			--==============--
			-- Clocks       --
			--==============--
			FRAMECLK_40MHZ										=> FRAMECLK_40MHZ,
			XCVRCLK										=> XCVRCLK,
			
			TX_FRAMECLK_O										=> TX_FRAMECLK_O,
			RX_FRAMECLK_O										=> RX_FRAMECLK_O,
			TX_WORDCLK_O										=> TX_WORDCLK_O,
			RX_WORDCLK_O										=> RX_WORDCLK_O,
			
			--==============--                          		
			-- Reset        --                          		
			--==============--                          		
			GBTBANK_GENERAL_RESET_I								=> GBTBANK_GENERAL_RESET_I,
			GBTBANK_MANUAL_RESET_TX_I							=> GBTBANK_MANUAL_RESET_TX_I,
			GBTBANK_MANUAL_RESET_RX_I							=> GBTBANK_MANUAL_RESET_RX_I,
			
			--==============--                          		
			-- Serial lanes --                          		
			--==============--                          		
			GBTBANK_MGT_RX										=> GBTBANK_MGT_RX,
			GBTBANK_MGT_TX										=> GBTBANK_MGT_TX,
			
			--==============--                          	
			-- Data			 --                         	
			--==============--		                    	
			GBTBANK_GBT_DATA_I									=> TX_GBTBANK_GBT_DATA,
			GBTBANK_WB_DATA_I									=> TX_GBTBANK_WB_DATA,
			GBTBANK_GBT_DATA_O									=> RX_GBTBANK_GBT_DATA,
			GBTBANK_WB_DATA_O									=> RX_GBTBANK_WB_DATA,
			
			--==============--                          	
			-- Reconf.		 --                         	
			--==============--                          	
			GBTBANK_RECONF_AVMM_RST								=> GBTBANK_RECONF_AVMM_RST,
			GBTBANK_RECONF_AVMM_CLK								=> GBTBANK_RECONF_AVMM_CLK,
			GBTBANK_RECONF_AVMM_ADDR							=> GBTBANK_RECONF_AVMM_ADDR,
			GBTBANK_RECONF_AVMM_READ							=> GBTBANK_RECONF_AVMM_READ,
			GBTBANK_RECONF_AVMM_WRITE							=> GBTBANK_RECONF_AVMM_WRITE,
			GBTBANK_RECONF_AVMM_WRITEDATA						=> GBTBANK_RECONF_AVMM_WRITEDATA,
			GBTBANK_RECONF_AVMM_READDATA						=> GBTBANK_RECONF_AVMM_READDATA,
			GBTBANK_RECONF_AVMM_WAITREQUEST						=> GBTBANK_RECONF_AVMM_WAITREQUEST,
			
			--==============--                        
			-- TX ctrl	    --                        
			--==============--                        
			GBTBANK_TX_ISDATA_SEL_I								=> TX_IS_DATASEL_sig,
			GBTBANK_TEST_PATTERN_SEL_I							=> GBTBANK_TEST_PATTERN_SEL_I,
			
			--==============--                          	
			-- RX ctrl      --                          	
			--==============--                          	
			GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I       			=> GBTBANK_RESET_GBTRXREADY_LOST_FLAG_I,
			GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I         		=> GBTBANK_RESET_DATA_ERRORSEEN_FLAG_I,
			
			--==============--                          
			-- TX Status    --                          		
			--==============--                          		
			GBTBANK_GBTRX_READY_O								=> GBTBANK_GBTRX_READY_O,
			GBTBANK_LINK_TX_READY_O								=> GBTBANK_LINK_TX_READY_sig,
			GBTBANK_LINK_RX_READY_O								=> GBTBANK_LINK_RX_READY_O,
			GBTBANK_LINK_READY_O								=> GBTBANK_LINK_READY_O,
			GBTBANK_TX_MATCHFLAG_O								=> GBTBANK_TX_MATCHFLAG_O,
			
			--==============--                   
			-- RX Status    --                   
			--==============--          
			GBTBANK_RX_ISDATA_SEL_O								=> RX_IS_DATASEL_sig, 
			GBTBANK_GBTRXREADY_LOST_FLAG_O         				=> GBTBANK_GBTRXREADY_LOST_FLAG_O,
			GBTBANK_RXDATA_ERRORSEEN_FLAG_O             		=> GBTBANK_RXDATA_ERRORSEEN_FLAG_O, 
			GBTBANK_RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O		=> GBTBANK_RXEXTRADATA_WIDEBUS_ERRORSEEN_FLAG_O, 
			GBTBANK_RX_MATCHFLAG_O								=> GBTBANK_RX_MATCHFLAG_O,
			
			--==============--                          		
			-- XCVR ctrl    --                          		
			--==============--                          		
			GBTBANK_LOOPBACK_I									=> GBTBANK_LOOPBACK_I,
			GBTBANK_TX_POL										=> GBTBANK_TX_POL,
			GBTBANK_RX_POL										=> GBTBANK_RX_POL,
			GBTBANK_TXWORDCLKMON_EN								=> GBTBANK_TXWORDCLKMON_EN
					
		);
	
	gbtBank_1link_gen: if NUM_LINKS = 1 generate
		TX_GBTBANK_GBT_DATA(1)		<= GBTBANK_GBT1_DATA_I;
		
		TX_GBTBANK_WB_DATA(1)		<= GBTBANK_WB1_DATA_I;
		
		GBTBANK_GBT1_DATA_O			<= RX_GBTBANK_GBT_DATA(1);
		GBTBANK_GBT2_DATA_O			<= (others => '0');
		GBTBANK_GBT3_DATA_O			<= (others => '0');
		GBTBANK_GBT4_DATA_O			<= (others => '0');
		GBTBANK_GBT5_DATA_O			<= (others => '0');
		GBTBANK_GBT6_DATA_O			<= (others => '0');
		
		GBTBANK_WB1_DATA_O			<= RX_GBTBANK_WB_DATA(1);
		GBTBANK_WB2_DATA_O			<= (others => '0');
		GBTBANK_WB3_DATA_O			<= (others => '0');
		GBTBANK_WB4_DATA_O			<= (others => '0');
		GBTBANK_WB5_DATA_O			<= (others => '0');
		GBTBANK_WB6_DATA_O			<= (others => '0');
				
		GBTBANK_LINK1_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(1);
		GBTBANK_LINK2_TX_READY_O	<= '0';
		GBTBANK_LINK3_TX_READY_O	<= '0';
		GBTBANK_LINK4_TX_READY_O	<= '0';
		GBTBANK_LINK5_TX_READY_O	<= '0';
		GBTBANK_LINK6_TX_READY_O	<= '0';
		
		TX_IS_DATASEL_sig(1)		<= GBTBANK_TX1_ISDATA_SEL_I;
				
		GBTBANK_RX1_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(1);
		GBTBANK_RX2_ISDATA_SEL_O	<= '0';
		GBTBANK_RX3_ISDATA_SEL_O	<= '0';
		GBTBANK_RX4_ISDATA_SEL_O	<= '0';
		GBTBANK_RX5_ISDATA_SEL_O	<= '0';
		GBTBANK_RX6_ISDATA_SEL_O	<= '0';
				
	end generate;
	
	gbtBank_2link_gen: if NUM_LINKS = 2 generate
		TX_GBTBANK_GBT_DATA(1)		<= GBTBANK_GBT1_DATA_I;
		TX_GBTBANK_GBT_DATA(2)		<= GBTBANK_GBT2_DATA_I;
		
		TX_GBTBANK_WB_DATA(1)		<= GBTBANK_WB1_DATA_I;
		TX_GBTBANK_WB_DATA(2)		<= GBTBANK_WB2_DATA_I;
		
		GBTBANK_GBT1_DATA_O			<= RX_GBTBANK_GBT_DATA(1);
		GBTBANK_GBT2_DATA_O			<= RX_GBTBANK_GBT_DATA(2);
		GBTBANK_GBT3_DATA_O			<= (others => '0');
		GBTBANK_GBT4_DATA_O			<= (others => '0');
		GBTBANK_GBT5_DATA_O			<= (others => '0');
		GBTBANK_GBT6_DATA_O			<= (others => '0');
		
		GBTBANK_WB1_DATA_O			<= RX_GBTBANK_WB_DATA(1);
		GBTBANK_WB2_DATA_O			<= RX_GBTBANK_WB_DATA(2);
		GBTBANK_WB3_DATA_O			<= (others => '0');
		GBTBANK_WB4_DATA_O			<= (others => '0');
		GBTBANK_WB5_DATA_O			<= (others => '0');
		GBTBANK_WB6_DATA_O			<= (others => '0');	
				
		GBTBANK_LINK1_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(1);
		GBTBANK_LINK2_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(2);
		GBTBANK_LINK3_TX_READY_O	<= '0';
		GBTBANK_LINK4_TX_READY_O	<= '0';
		GBTBANK_LINK5_TX_READY_O	<= '0';
		GBTBANK_LINK6_TX_READY_O	<= '0';
		
		TX_IS_DATASEL_sig(1)		<= GBTBANK_TX1_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(2)		<= GBTBANK_TX2_ISDATA_SEL_I;
				
		GBTBANK_RX1_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(1);
		GBTBANK_RX2_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(2);
		GBTBANK_RX3_ISDATA_SEL_O	<= '0';
		GBTBANK_RX4_ISDATA_SEL_O	<= '0';
		GBTBANK_RX5_ISDATA_SEL_O	<= '0';
		GBTBANK_RX6_ISDATA_SEL_O	<= '0';
		
	end generate;
		
	gbtBank_3link_gen: if NUM_LINKS = 3 generate
		TX_GBTBANK_GBT_DATA(1)		<= GBTBANK_GBT1_DATA_I;
		TX_GBTBANK_GBT_DATA(2)		<= GBTBANK_GBT2_DATA_I;
		TX_GBTBANK_GBT_DATA(3)		<= GBTBANK_GBT3_DATA_I;
		
		TX_GBTBANK_WB_DATA(1)		<= GBTBANK_WB1_DATA_I;
		TX_GBTBANK_WB_DATA(2)		<= GBTBANK_WB2_DATA_I;
		TX_GBTBANK_WB_DATA(3)		<= GBTBANK_WB3_DATA_I;
		
		GBTBANK_GBT1_DATA_O			<= RX_GBTBANK_GBT_DATA(1);
		GBTBANK_GBT2_DATA_O			<= RX_GBTBANK_GBT_DATA(2);
		GBTBANK_GBT3_DATA_O			<= RX_GBTBANK_GBT_DATA(3);
		GBTBANK_GBT4_DATA_O			<= (others => '0');
		GBTBANK_GBT5_DATA_O			<= (others => '0');
		GBTBANK_GBT6_DATA_O			<= (others => '0');
		
		GBTBANK_WB1_DATA_O			<= RX_GBTBANK_WB_DATA(1);
		GBTBANK_WB2_DATA_O			<= RX_GBTBANK_WB_DATA(2);
		GBTBANK_WB3_DATA_O			<= RX_GBTBANK_WB_DATA(3);
		GBTBANK_WB4_DATA_O			<= (others => '0');
		GBTBANK_WB5_DATA_O			<= (others => '0');
		GBTBANK_WB6_DATA_O			<= (others => '0');		
				
		GBTBANK_LINK1_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(1);
		GBTBANK_LINK2_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(2);
		GBTBANK_LINK3_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(3);
		GBTBANK_LINK4_TX_READY_O	<= '0';
		GBTBANK_LINK5_TX_READY_O	<= '0';
		GBTBANK_LINK6_TX_READY_O	<= '0';
		
		TX_IS_DATASEL_sig(1)		<= GBTBANK_TX1_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(2)		<= GBTBANK_TX2_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(3)		<= GBTBANK_TX3_ISDATA_SEL_I;
				
		GBTBANK_RX1_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(1);
		GBTBANK_RX2_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(2);
		GBTBANK_RX3_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(3);
		GBTBANK_RX4_ISDATA_SEL_O	<= '0';
		GBTBANK_RX5_ISDATA_SEL_O	<= '0';
		GBTBANK_RX6_ISDATA_SEL_O	<= '0';
	end generate;
	
	
	gbtBank_4link_gen: if NUM_LINKS = 4 generate
		TX_GBTBANK_GBT_DATA(1)		<= GBTBANK_GBT1_DATA_I;
		TX_GBTBANK_GBT_DATA(2)		<= GBTBANK_GBT2_DATA_I;
		TX_GBTBANK_GBT_DATA(3)		<= GBTBANK_GBT3_DATA_I;
		TX_GBTBANK_GBT_DATA(4)		<= GBTBANK_GBT4_DATA_I;
		
		TX_GBTBANK_WB_DATA(1)		<= GBTBANK_WB1_DATA_I;
		TX_GBTBANK_WB_DATA(2)		<= GBTBANK_WB2_DATA_I;
		TX_GBTBANK_WB_DATA(3)		<= GBTBANK_WB3_DATA_I;
		TX_GBTBANK_WB_DATA(4)		<= GBTBANK_WB4_DATA_I;
		
		GBTBANK_GBT1_DATA_O			<= RX_GBTBANK_GBT_DATA(1);
		GBTBANK_GBT2_DATA_O			<= RX_GBTBANK_GBT_DATA(2);
		GBTBANK_GBT3_DATA_O			<= RX_GBTBANK_GBT_DATA(3);
		GBTBANK_GBT4_DATA_O			<= RX_GBTBANK_GBT_DATA(4);
		GBTBANK_GBT5_DATA_O			<= (others => '0');
		GBTBANK_GBT6_DATA_O			<= (others => '0');
		
		GBTBANK_WB1_DATA_O			<= RX_GBTBANK_WB_DATA(1);
		GBTBANK_WB2_DATA_O			<= RX_GBTBANK_WB_DATA(2);
		GBTBANK_WB3_DATA_O			<= RX_GBTBANK_WB_DATA(3);
		GBTBANK_WB4_DATA_O			<= RX_GBTBANK_WB_DATA(4);
		GBTBANK_WB5_DATA_O			<= (others => '0');
		GBTBANK_WB6_DATA_O			<= (others => '0');
				
		GBTBANK_LINK1_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(1);
		GBTBANK_LINK2_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(2);
		GBTBANK_LINK3_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(3);
		GBTBANK_LINK4_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(4);
		GBTBANK_LINK5_TX_READY_O	<= '0';
		GBTBANK_LINK6_TX_READY_O	<= '0';
		
		TX_IS_DATASEL_sig(1)		<= GBTBANK_TX1_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(2)		<= GBTBANK_TX2_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(3)		<= GBTBANK_TX3_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(4)		<= GBTBANK_TX4_ISDATA_SEL_I;
				
		GBTBANK_RX1_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(1);
		GBTBANK_RX2_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(2);
		GBTBANK_RX3_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(3);
		GBTBANK_RX4_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(4);
		GBTBANK_RX5_ISDATA_SEL_O	<= '0';
		GBTBANK_RX6_ISDATA_SEL_O	<= '0';
		
	end generate;
	
	
	gbtBank_5link_gen: if NUM_LINKS = 5 generate
		TX_GBTBANK_GBT_DATA(1)		<= GBTBANK_GBT1_DATA_I;
		TX_GBTBANK_GBT_DATA(2)		<= GBTBANK_GBT2_DATA_I;
		TX_GBTBANK_GBT_DATA(3)		<= GBTBANK_GBT3_DATA_I;
		TX_GBTBANK_GBT_DATA(4)		<= GBTBANK_GBT4_DATA_I;
		TX_GBTBANK_GBT_DATA(5)		<= GBTBANK_GBT5_DATA_I;
		
		TX_GBTBANK_WB_DATA(1)		<= GBTBANK_WB1_DATA_I;
		TX_GBTBANK_WB_DATA(2)		<= GBTBANK_WB2_DATA_I;
		TX_GBTBANK_WB_DATA(3)		<= GBTBANK_WB3_DATA_I;
		TX_GBTBANK_WB_DATA(4)		<= GBTBANK_WB4_DATA_I;
		TX_GBTBANK_WB_DATA(5)		<= GBTBANK_WB5_DATA_I;
		
		GBTBANK_GBT1_DATA_O			<= RX_GBTBANK_GBT_DATA(1);
		GBTBANK_GBT2_DATA_O			<= RX_GBTBANK_GBT_DATA(2);
		GBTBANK_GBT3_DATA_O			<= RX_GBTBANK_GBT_DATA(3);
		GBTBANK_GBT4_DATA_O			<= RX_GBTBANK_GBT_DATA(4);
		GBTBANK_GBT5_DATA_O			<= RX_GBTBANK_GBT_DATA(5);
		GBTBANK_GBT6_DATA_O			<= (others => '0');
		
		GBTBANK_WB1_DATA_O			<= RX_GBTBANK_WB_DATA(1);
		GBTBANK_WB2_DATA_O			<= RX_GBTBANK_WB_DATA(2);
		GBTBANK_WB3_DATA_O			<= RX_GBTBANK_WB_DATA(3);
		GBTBANK_WB4_DATA_O			<= RX_GBTBANK_WB_DATA(4);
		GBTBANK_WB5_DATA_O			<= RX_GBTBANK_WB_DATA(5);
		GBTBANK_WB6_DATA_O			<= (others => '0');
				
		GBTBANK_LINK1_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(1);
		GBTBANK_LINK2_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(2);
		GBTBANK_LINK3_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(3);
		GBTBANK_LINK4_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(4);
		GBTBANK_LINK5_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(5);
		GBTBANK_LINK6_TX_READY_O	<= '0';
		
		TX_IS_DATASEL_sig(1)		<= GBTBANK_TX1_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(2)		<= GBTBANK_TX2_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(3)		<= GBTBANK_TX3_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(4)		<= GBTBANK_TX4_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(5)		<= GBTBANK_TX5_ISDATA_SEL_I;
				
		GBTBANK_RX1_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(1);
		GBTBANK_RX2_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(2);
		GBTBANK_RX3_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(3);
		GBTBANK_RX4_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(4);
		GBTBANK_RX5_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(5);
		GBTBANK_RX6_ISDATA_SEL_O	<= '0';
	end generate;
	
	
	gbtBank_6link_gen: if NUM_LINKS = 6 generate		
		TX_GBTBANK_GBT_DATA(1)		<= GBTBANK_GBT1_DATA_I;
		TX_GBTBANK_GBT_DATA(2)		<= GBTBANK_GBT2_DATA_I;
		TX_GBTBANK_GBT_DATA(3)		<= GBTBANK_GBT3_DATA_I;
		TX_GBTBANK_GBT_DATA(4)		<= GBTBANK_GBT4_DATA_I;
		TX_GBTBANK_GBT_DATA(5)		<= GBTBANK_GBT5_DATA_I;
		TX_GBTBANK_GBT_DATA(6)		<= GBTBANK_GBT6_DATA_I;
		
		TX_GBTBANK_WB_DATA(1)		<= GBTBANK_WB1_DATA_I;
		TX_GBTBANK_WB_DATA(2)		<= GBTBANK_WB2_DATA_I;
		TX_GBTBANK_WB_DATA(3)		<= GBTBANK_WB3_DATA_I;
		TX_GBTBANK_WB_DATA(4)		<= GBTBANK_WB4_DATA_I;
		TX_GBTBANK_WB_DATA(5)		<= GBTBANK_WB5_DATA_I;
		TX_GBTBANK_WB_DATA(6)		<= GBTBANK_WB6_DATA_I;
		
		GBTBANK_GBT1_DATA_O			<= RX_GBTBANK_GBT_DATA(1);
		GBTBANK_GBT2_DATA_O			<= RX_GBTBANK_GBT_DATA(2);
		GBTBANK_GBT3_DATA_O			<= RX_GBTBANK_GBT_DATA(3);
		GBTBANK_GBT4_DATA_O			<= RX_GBTBANK_GBT_DATA(4);
		GBTBANK_GBT5_DATA_O			<= RX_GBTBANK_GBT_DATA(5);
		GBTBANK_GBT6_DATA_O			<= RX_GBTBANK_GBT_DATA(6);
		
		GBTBANK_WB1_DATA_O			<= RX_GBTBANK_WB_DATA(1);
		GBTBANK_WB2_DATA_O			<= RX_GBTBANK_WB_DATA(2);
		GBTBANK_WB3_DATA_O			<= RX_GBTBANK_WB_DATA(3);
		GBTBANK_WB4_DATA_O			<= RX_GBTBANK_WB_DATA(4);
		GBTBANK_WB5_DATA_O			<= RX_GBTBANK_WB_DATA(5);
		GBTBANK_WB6_DATA_O			<= RX_GBTBANK_WB_DATA(6);
				
		GBTBANK_LINK1_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(1);
		GBTBANK_LINK2_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(2);
		GBTBANK_LINK3_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(3);
		GBTBANK_LINK4_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(4);
		GBTBANK_LINK5_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(5);
		GBTBANK_LINK6_TX_READY_O	<= GBTBANK_LINK_TX_READY_sig(6);
		
		TX_IS_DATASEL_sig(1)		<= GBTBANK_TX1_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(2)		<= GBTBANK_TX2_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(3)		<= GBTBANK_TX3_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(4)		<= GBTBANK_TX4_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(5)		<= GBTBANK_TX5_ISDATA_SEL_I;
		TX_IS_DATASEL_sig(6)		<= GBTBANK_TX6_ISDATA_SEL_I;
				
		GBTBANK_RX1_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(1);
		GBTBANK_RX2_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(2);
		GBTBANK_RX3_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(3);
		GBTBANK_RX4_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(4);
		GBTBANK_RX5_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(5);
		GBTBANK_RX6_ISDATA_SEL_O	<= RX_IS_DATASEL_sig(6);
		
	end generate;
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--
