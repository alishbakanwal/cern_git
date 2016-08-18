--------------------------------------------------------------------------------
--
-- This source code is confidential information and may be used only as
-- authorized by a licensing agreement from PLDA.
--
--------------------------------------------------------------------------------
-- Project : PCIEZ Reference design
-- $RCSfile: ref_design.vhd,v $
-- $Date: 2011/06/28 15:08:38 $
-- $Revision: 1.1.1.7 $
-- $Name: PCIEZREFD_20110627 $
-- $Author: reid $
-------------------------------------------------------------------------------
-- Dependency  :
-------------------------------------------------------------------------------
-- Description : PCIEZ reference design top-level
-------------------------------------------------------------------------------
-- Revision:
-- $Log: ref_design.vhd,v $
-- Revision 1.1.1.7  2011/06/28 15:08:38  reid
-- importing projects/pciez_refdesign (PCIEZREFD_20110627, PCIEZREFD_20110627) to RTK database
--
-- Revision 1.16  2010/07/15 08:06:12  plegros
-- Added support for 256-bit datapath, partial code rewrite for clarity
--
-- Revision 1.15  2009/08/24 12:19:50  plegros
-- Added 32-bit support
--
-- Revision 1.14  2009/08/10 09:10:42  plegros
-- Update to new ez interface
--
-- Revision 1.13  2009/03/30 13:39:25  jdenis
-- Implemented 128-bit support
--
-- Revision 1.12  2009/03/12 07:52:02  plegros
-- Added clk_double input
--
-- Revision 1.11  2009/01/23 10:05:24  plegros
-- Updated dma_mgt port list
--
-- Revision 1.10  2008/11/28 15:14:44  plegros
-- usr_led is now registered and completely assigned in slave_mgt module
--
-- Revision 1.9  2008/11/10 14:41:55  plegros
-- *** empty log message ***
--
-- Revision 1.8  2008/10/16 12:35:08  plegros
-- slv_abort is now asserted when accesses not in BAR0/BAR2 are detected
--
-- Revision 1.7  2007/06/07 10:14:47  plegros
-- Renamed dma1_wrdata to dma_wrdata
--
-- Revision 1.6  2006/09/29 12:18:13  plegros
-- *** empty log message ***
--
-- Revision 1.5  2006/08/22 14:04:51  plegros
-- Added extrenal register support
--
-- Revision 1.4  2006/08/21 09:26:38  plegros
-- Update for v1.4
--
-- Revision 1.3  2006/06/28 13:41:42  plegros
-- Fixed bug reading last two dwords of internal ram
--
-- Revision 1.2  2006/04/14 09:00:16  plegros
-- *** empty log message ***
--
--

--####################### GLIB project modifications ###########################--
--# Modified by Manoel Barros Marin (manoel.barros.marin@cern.ch) (05/09/2012) #--
--##############################################################################--

-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

-- User libraries and packages:																			-- GLIB - Added
use work.user_pcie_ber_package.all;    																-- GLIB - Added

---------------------------------------------------------------

entity ref_design is
	generic (		                              		
		DATAPATH    			: integer := 64;   -- Indicates DATA path : 32,64,128 or 256 bits  		
		CORE_FREQ				: integer := 250   -- Indicates core frequency : 62,125 or 250 MHz
	);	
	port (	
	   clk 						: in  std_logic;
	   rstn 						: in  std_logic;
	   srst						: in  std_logic;
	   clk_doubled				: in  std_logic;
		---------------------------------
		int_ack					: in  std_logic;															-- GLIB - Added
		int_request 			: out std_logic;
		---------------------------------
   	slv_dataout 			: in  std_logic_vector(DATAPATH-1 downto 0);
	   slv_bytevalid 			: in  std_logic_vector((DATAPATH/8)-1 downto 0);
	   slv_bytecount 			: in  std_logic_vector(12 downto 0);
	   slv_addr 				: in  std_logic_vector(63 downto 0);
	   slv_bar 					: in  std_logic_vector( 6 downto 0);
	   slv_readreq 			: in  std_logic;
	   slv_cpladdr 			: in  std_logic_vector(31 downto 0);
	   slv_cplparam 			: in  std_logic_vector( 7 downto 0);
	   slv_writereq 			: in  std_logic;
	   slv_write 				: in  std_logic;
	   slv_accept 				: out std_logic;
	   slv_abort 				: out std_logic;
		---------------------------------
--	   flash_wr          	: out std_logic_vector( 1 downto 0);								-- GLIB - Modified
--	   flash_wrdata      	: out std_logic_vector(63 downto 0);								-- GLIB - Modified
--	   flash_rddata      	: in  std_logic_vector(63 downto 0);								-- GLIB - Modified
		---------------------------------
--	   dma_rd 					: in  std_logic;															-- GLIB - Modified
--	   dma_rdaddr 				: in  std_logic_vector(12 downto 0);         					-- GLIB - Modified
--	   dma_rdchannel 			: in  std_logic_vector(15 downto 0);		   					-- GLIB - Modified
--	   dma_rddata 				: out std_logic_vector(DATAPATH-1 downto 0);						-- GLIB - Modified
	   dma2_rd 					: in  std_logic;															-- GLIB - Modified
	   dma2_rdaddr 			: in  std_logic_vector(31 downto 0);--(12 downto 0);			-- GLIB - Modified
	   dma2_rdchannel 		: in  std_logic_vector(15 downto 0);                        -- GLIB - Modified
	   dma2_rddata 			: out std_logic_vector(DATAPATH-1 downto 0);		            -- GLIB - Modified
	   dma3_rd 					: in  std_logic;															-- GLIB - Modified			
	   dma3_rdaddr 			: in  std_logic_vector(12 downto 0);                        -- GLIB - Modified
	   dma3_rdchannel 		: in  std_logic_vector(15 downto 0);                        -- GLIB - Modified
	   dma3_rddata 			: out std_logic_vector(DATAPATH-1 downto 0);		 		      -- GLIB - Modified
		--------------------------------- 
--		dma_wr 					: in  std_logic;															-- GLIB - Modified
--	   dma_wrchannel 			: in  std_logic_vector(15 downto 0);               			-- GLIB - Modified
--	   dma_wrdata 				: in  std_logic_vector(DATAPATH-1 downto 0);       			-- GLIB - Modified
		dma1_wr 					: in  std_logic;															-- GLIB - Modified
	   dma1_wrchannel 		: in  std_logic_vector(15 downto 0);                        -- GLIB - Modified
		dma1_wraddr 			: in  std_logic_vector(31 downto 0);								-- GLIB - Modified
		dma1_wrdata 			: in  std_logic_vector(DATAPATH-1 downto 0);                -- GLIB - Modified
		dma2_wr 					: in  std_logic;															-- GLIB - Modified
	   dma2_wrchannel 		: in  std_logic_vector(15 downto 0);                        -- GLIB - Modified
	   dma2_wrdata 			: in  std_logic_vector(DATAPATH-1 downto 0);		            -- GLIB - Modified
		dma3_wr 					: in  std_logic;                                            -- GLIB - Modified
	   dma3_wrchannel 		: in  std_logic_vector(15 downto 0);								-- GLIB - Modified
	   dma3_wrdata 			: in  std_logic_vector(DATAPATH-1 downto 0);		   			-- GLIB - Modified
		---------------------------------                         
	   dma1_regin 				: out std_logic_vector(127 downto 0);              			-- GLIB - Modified
	   dma1_regout 			: in  std_logic_vector(127 downto 0);								-- GLIB - Modified
	   dma1_param 				: out std_logic_vector( 23 downto 0);                    	-- GLIB - Modified
	   dma1_control 			: out std_logic_vector(  5 downto 0);                    	-- GLIB - Modified
	   dma1_status 			: in  std_logic_vector(  3 downto 0);                    	-- GLIB - Modified
	   dma1_fifocnt 			: out std_logic_vector( 12 downto 0);                    	-- GLIB - Modified
	   dma2_regin 				: out std_logic_vector(127 downto 0);                    	-- GLIB - Modified
	   dma2_regout 			: in  std_logic_vector(127 downto 0);                    	-- GLIB - Modified
	   dma2_param 				: out std_logic_vector( 23 downto 0);                    	-- GLIB - Modified
	   dma2_control 			: out std_logic_vector(  5 downto 0);                    	-- GLIB - Modified
	   dma2_status 			: in  std_logic_vector(  3 downto 0);                    	-- GLIB - Modified
	   dma2_fifocnt 			: out std_logic_vector( 12 downto 0);                    	-- GLIB - Modified
	   dma3_regin 				: out std_logic_vector(127 downto 0);                    	-- GLIB - Modified
	   dma3_param 				: out std_logic_vector( 23 downto 0);                    	-- GLIB - Modified
	   dma3_control 			: out std_logic_vector(  5 downto 0);								-- GLIB - Modified
	   dma3_status 			: in  std_logic_vector(  3 downto 0);        					-- GLIB - Modified
	   dma3_fifocnt 			: out std_logic_vector( 12 downto 0);        					-- GLIB - Modified
		---------------------------------                              	
   	cfg_linkcsr 			: in  std_logic_vector( 31 downto 0);        
   	cfg_ltssm				: in  std_logic_vector(  4 downto 0)--; 							-- GLIB - Modified     
		---------------------------------                              
--	   usr_led					: out std_logic_vector(  3 downto 0)         					-- GLIB - Modified
	);                                                               
end ref_design;                                                     
architecture structural of ref_design is                            
  
	component slave_mgt                                              
		generic (                                
			DATAPATH    		: integer := 64
		);
		port (
			clk 					: in  std_logic;
			rstn 					: in  std_logic;
			srst 					: in  std_logic;
			---------------------------------
			cfg_ltssm			: in 	std_logic_vector( 4 downto 0);
			cfg_linkcsr			: in 	std_logic_vector(31 downto 0);
			---------------------------------	
			slv_bar 				: in 	std_logic_vector( 6 downto 0);
			slv_addr 			: in 	std_logic_vector(63 downto 0);
			slv_readreq 		: in 	std_logic;
			slv_writereq 		: in 	std_logic;
			slv_write 			: in 	std_logic;
			slv_dataout 		: in 	std_logic_vector(DATAPATH-1 downto 0);
			slv_bytevalid 		: in 	std_logic_vector((DATAPATH/8)-1 downto 0);
			slv_bytecount 		: in 	std_logic_vector(12 downto 0);
			slv_cpladdr 		: in 	std_logic_vector(31 downto 0);
			slv_cplparam 		: in  std_logic_vector( 7 downto 0);
			slv_accept 			: out std_logic;
			slv_abort 			: out std_logic;
			---------------------------------
			reg_write			: out std_logic_vector(15 downto 0);
			reg_writedata		: out std_logic_vector(DATAPATH-1 downto 0);
			---------------------------------
--		   flash_wr				: out std_logic_vector( 1 downto 0);								-- GLIB - Modified
--			flash_wrdata		: out std_logic_vector(63 downto 0);      						-- GLIB - Modified
--			flash_rddata		: in  std_logic_vector(63 downto 0);      						-- GLIB - Modified
			---------------------------------					
		   int_ack				: in  std_logic;															-- GLIB - Added
			int_request			: out std_logic;
			dma_int_req			: in  std_logic;
			---------------------------------
			dma1_regout 		: in  std_logic_vector(127 downto 0);								-- GLIB - Modified
			dma1_info_reg		: in  std_logic_vector( 31 downto 0);                       -- GLIB - Modified
         dma1_status			: in  std_logic_vector(  3 downto 0);	                     -- GLIB - Added	
         dma2_regout 		: in  std_logic_vector(127 downto 0);                       -- GLIB - Modified
			dma2_info_reg		: in  std_logic_vector( 31 downto 0);								-- GLIB - Modified
         dma2_status		   : in  std_logic_vector(  3 downto 0);			               -- GLIB - Added
			dma3_regin			: out std_logic_vector(127 downto 0);								-- GLIB - Modified
			dma3_param 			: out std_logic_vector( 23 downto 0);								-- GLIB - Modified
			dma3_control 		: out std_logic_vector(  5 downto 0);								-- GLIB - Modified
			dma3_status 		: in  std_logic_vector(  3 downto 0);								-- GLIB - Modified
			dma3_fifocnt 		: out std_logic_vector( 12 downto 0);								-- GLIB - Modified
			---------------------------------
--		   slave_rddata   	: out std_logic_vector(DATAPATH-1 downto 0);						-- GLIB - Modified
--		   dma_rd				: in  std_logic;                            						-- GLIB - Modified
--		   dma_rdaddr 			: in  std_logic_vector(12 downto 0);        						-- GLIB - Modified
			dma3_rddata   		: out std_logic_vector(DATAPATH-1 downto 0);						-- GLIB - Modified
			dma3_rd				: in  std_logic;                            						-- GLIB - Modified
			dma3_rdaddr			: in  std_logic_vector(12 downto 0);        						-- GLIB - Modified
			---------------------------------
-- 	   usr_led           : out std_logic_vector(3 downto 0)									-- GLIB - Modified

			-- BER:																								-- GLIB - Added
			ber_i					: in  R_pcieBer_from_ber;												-- GLIB - Added
			ber_o					: out R_pcieBer_to_ber													-- GLIB - Added

		);
	end component;

	component dma_mgt
		generic (
			DATAPATH    		: integer := 64;
			CORE_FREQ			: integer := 125
		);		
		port (
			clk 					: in 	std_logic;
			rstn 					: in 	std_logic;
			srst					: in 	std_logic;
			clk_doubled			: in 	std_logic;
			---------------------------------	
			reg_write			: in 	std_logic_vector(15 downto 0);
			reg_writedata		: in 	std_logic_vector(DATAPATH-1 downto 0);
			---------------------------------
--	  	  	dma_wrchannel 		: in 	std_logic_vector(15 downto 0);								-- GLIB - Modified
--	  	  	dma_rdchannel 		: in 	std_logic_vector(15 downto 0);								-- GLIB - Modified
--			dma_wr				: in 	std_logic;															-- GLIB - Modified
--	  	  	dma_rd 				: in 	std_logic;															-- GLIB - Modified	
--	  	  	dma_wrdata 		   : in 	std_logic_vector(DATAPATH-1 downto 0);	   				-- GLIB - Modified
			dma1_wrchannel 	: in 	std_logic_vector(15 downto 0);								-- GLIB - Modified
			dma1_wr				: in 	std_logic;	                                          -- GLIB - Modified
			dma1_wraddr 		: in  std_logic_vector(31 downto 0);								-- GLIB - Added
			dma1_wrdata 		: in 	std_logic_vector(DATAPATH-1 downto 0);		  				-- GLIB - Modified
			dma2_wrchannel 	: in 	std_logic_vector(15 downto 0);	                     -- GLIB - Modified
			dma2_wr				: in 	std_logic;															-- GLIB - Modified
			dma2_wrdata 		: in 	std_logic_vector(DATAPATH-1 downto 0);				      -- GLIB - Modified
			dma2_rdchannel 	: in 	std_logic_vector(15 downto 0);								-- GLIB - Modified
			dma2_rd 				: in  std_logic;	                                          -- GLIB - Modified
			dma2_rdaddr 		: in  std_logic_vector(31 downto 0);--(12 downto 0);			-- GLIB - Modified 
			dma2_rddata			: out std_logic_vector(DATAPATH-1 downto 0);						-- GLIB - Modified
			---------------------------------
			dma1_status 		: in  std_logic_vector(  3 downto 0);								-- GLIB - Modified
			dma1_regout			: in  std_logic_vector(127 downto 0);                 		-- GLIB - Modified
			dma1_regin			: out std_logic_vector(127 downto 0);                 		-- GLIB - Modified
			dma1_param 			: out std_logic_vector( 23 downto 0);                 		-- GLIB - Modified
			dma1_control		: out std_logic_vector(  5 downto 0);                 		-- GLIB - Modified
			dma1_fifocnt		: out std_logic_vector( 12 downto 0);                 		-- GLIB - Modified
			dma1_info_reg		: out std_logic_vector( 31 downto 0);                       -- GLIB - Modified
			dma2_status 		: in  std_logic_vector(  3 downto 0);								-- GLIB - Modified
			dma2_regout			: in  std_logic_vector(127 downto 0);                 		-- GLIB - Modified
			dma2_regin			: out std_logic_vector(127 downto 0);                 		-- GLIB - Modified
			dma2_param			: out std_logic_vector( 23 downto 0);                 		-- GLIB - Modified
			dma2_control		: out std_logic_vector(  5 downto 0);                 		-- GLIB - Modified
			dma2_fifocnt		: out std_logic_vector( 12 downto 0);                 		-- GLIB - Modified
			dma2_info_reg		: out std_logic_vector( 31 downto 0);                       -- GLIB - Modified
			---------------------------------
			int_request			: in std_logic; 															-- GLIB - Added
			dma_int_req			: out std_logic;
			
			-- BER:																								-- GLIB - Added
			ber_i					: in  R_pcieBer_to_ber;													-- GLIB - Added
			ber_o					: out R_pcieBer_from_ber												-- GLIB - Added
			
		);
	end component;

	---------------------------------------------------------------

	signal dma_int_req							: std_logic;
	signal dma1_info_reg,dma2_info_reg    	: std_logic_vector(31 downto 0);
--	signal slave_rddata,dma2_rddata			: std_logic_vector(DATAPATH-1 downto 0);	  	-- GLIB - Modified
	signal reg_write								: std_logic_vector(15 downto 0);
	signal reg_writedata							: std_logic_vector(DATAPATH-1 downto 0);
	
	signal int_request_from_slave				: std_logic;											-- GLIB - Added							
	signal pcieBer_to_dma						: R_pcieBer_to_ber;									-- GLIB - Added
	signal pcieBer_from_dma						: R_pcieBer_from_ber;								-- GLIB - Added

begin

	int_request										<= int_request_from_slave;							-- GLIB - Added

	-------------------------------------------------
	-- SLAVE MANAGEMENT
	-------------------------------------------------

	slave: slave_mgt
		generic map (
			DATAPATH									=> DATAPATH)
		port map (							
			clk 										=> clk,
			rstn 										=> rstn,
			srst										=> srst,
			---------------------------------					
			cfg_ltssm 								=> cfg_ltssm,
			cfg_linkcsr								=> cfg_linkcsr,
			---------------------------------			
			slv_bar 									=> slv_bar,
			slv_addr 								=> slv_addr,
			slv_readreq 							=> slv_readreq,
			slv_writereq 							=> slv_writereq,
			slv_write 								=> slv_write,
			slv_dataout 							=> slv_dataout,
			slv_bytevalid 							=> slv_bytevalid,
			slv_bytecount 							=> slv_bytecount,
			slv_cpladdr 							=> slv_cpladdr,
			slv_cplparam 							=> slv_cplparam,
			slv_accept 								=> slv_accept,
			slv_abort								=> slv_abort,
			---------------------------------			
			reg_write								=> reg_write,									
			reg_writedata							=> reg_writedata,                      
			---------------------------------						                     
-- 	  	flash_wr									=> flash_wr,											-- GLIB - Modified
-- 	  	flash_wrdata   						=> flash_wrdata,                       		-- GLIB - Modified
-- 	  	flash_rddata   						=> flash_rddata,                       		-- GLIB - Modified
			---------------------------------			
		   int_ack									=> int_ack,												-- GLIB - Modified
			int_request 							=> int_request_from_slave,							-- GLIB - Added
			dma_int_req								=> dma_int_req,
			---------------------------------			
			dma1_regout 							=> dma1_regout,										-- GLIB - Modified
			dma1_info_reg 							=> dma1_info_reg,                      		-- GLIB - Modified
         dma1_status 							=> dma1_status, 				                  -- GLIB - Added
			dma2_regout 							=> dma2_regout,										-- GLIB - Modified
			dma2_info_reg 							=> dma2_info_reg,	         						-- GLIB - Modified
         dma2_status 							=> dma2_status, 				                  -- GLIB - Added
			dma3_regin 								=> dma3_regin,											-- GLIB - Modified
			dma3_param 								=> dma3_param,             						-- GLIB - Modified
			dma3_control 							=> dma3_control,										-- GLIB - Modified
			dma3_status 							=> dma3_status,         							-- GLIB - Modified
			dma3_fifocnt 							=> dma3_fifocnt,										-- GLIB - Modified
			---------------------------------
--		   slave_rddata 							=> slave_rddata,										-- GLIB - Modified
--		   dma_rd									=> dma_rd,                                	-- GLIB - Modified
--		   dma_rdaddr 								=> dma_rdaddr,                            	-- GLIB - Modified
			dma3_rddata 							=> dma3_rddata,                           	-- GLIB - Modified
			dma3_rd									=> dma3_rd,                               	-- GLIB - Modified
			dma3_rdaddr 							=> dma3_rdaddr,                           	-- GLIB - Modified
			---------------------------------			
--		   usr_led 									=> usr_led						            		-- GLIB - Modified
	
			-- BER:																								-- GLIB - Added
			ber_i										=> pcieBer_from_dma,									-- GLIB - Added
			ber_o										=> pcieBer_to_dma										-- GLIB - Added

		);

	-------------------------------------------------
	-- DMA MANAGEMENT
	-------------------------------------------------
	
	dma: dma_mgt
		generic map (
			DATAPATH									=> DATAPATH,
			CORE_FREQ								=> CORE_FREQ)
		port map (					
			clk 										=> clk,
			rstn 										=> rstn,
			srst										=> srst,
			clk_doubled								=> clk_doubled,
			---------------------------------		
			reg_write								=> reg_write,
			reg_writedata							=> reg_writedata,
			---------------------------------		
--			dma_wrchannel 							=> dma_wrchannel,										-- GLIB - Modified	
--			dma_rdchannel 							=> dma_rdchannel,                            -- GLIB - Modified
--			dma_wr 									=> dma_wr,                                   -- GLIB - Modified
--			dma_rd 									=> dma_rd,                                   -- GLIB - Modified
--		   dma_wrdata								=> dma_wrdata,									    	-- GLIB - Modified
			dma1_wrchannel 						=>	dma1_wrchannel,                         	-- GLIB - Modified
			dma1_wr									=> dma1_wr,												-- GLIB - Modified
			dma1_wraddr								=>	dma1_wraddr,										-- GLIB - Added
			dma1_wrdata 							=>	dma1_wrdata, 			    						-- GLIB - Modified
			dma2_wrchannel 						=>	dma2_wrchannel,          						-- GLIB - Modified
			dma2_wr									=>	dma2_wr,			   								-- GLIB - Modified
			dma2_wrdata 							=>	dma2_wrdata,	   								-- GLIB - Modified		
			dma2_rdchannel 						=>	dma2_rdchannel,     								-- GLIB - Modified
			dma2_rd 									=>	dma2_rd,            								-- GLIB - Modified
			dma2_rdaddr								=>	dma2_rdaddr,										-- GLIB - Added
			---------------------------------		
			dma1_status								=> dma1_status,										-- GLIB - Modified	
			dma1_regout								=> dma1_regout,	            					-- GLIB - Modified
			dma1_regin 								=> dma1_regin,                					-- GLIB - Modified
			dma1_param 								=> dma1_param,                					-- GLIB - Modified
			dma1_control 							=> dma1_control,            						-- GLIB - Modified
			dma1_fifocnt 							=> dma1_fifocnt,            						-- GLIB - Modified
			dma1_info_reg							=> dma1_info_reg,	      							-- GLIB - Modified
			dma2_status								=> dma2_status,										-- GLIB - Modified	
			dma2_regout								=> dma2_regout,                  				-- GLIB - Modified
			dma2_regin 								=> dma2_regin,                   				-- GLIB - Modified
			dma2_param 								=> dma2_param,                   				-- GLIB - Modified
			dma2_control 							=> dma2_control,               					-- GLIB - Modified
			dma2_fifocnt 							=> dma2_fifocnt,               					-- GLIB - Modified
			dma2_info_reg							=> dma2_info_reg,          						-- GLIB - Modified
			dma2_rddata								=> dma2_rddata,										-- GLIB - Modified
			---------------------------------
			int_request								=> int_request_from_slave,							-- GLIB - Added
			dma_int_req								=> dma_int_req,			
			
			-- BER:																								-- GLIB - Added
			ber_i										=> pcieBer_to_dma,									-- GLIB - Added
			ber_o										=> pcieBer_from_dma									-- GLIB - Added		
			
	);

--	
--	-- GLIB - The following logic is not necessary because the multiplexing is already done in system:
--		
--	-------------------------------------------------												-- GLIB - Modified	
--	-- Multiplex DMA data to be read                                                    -- GLIB - Modified
--	-------------------------------------------------                                   -- GLIB - Modified
--                                                                                     -- GLIB - Modified
--	-- dma2 : DMA data from 'dma_mgt' module															-- GLIB - Modified	
--	-- dma3 : completion data from 'slave_mgt' module												-- GLIB - Modified
--    dma_rddata 									<= dma2_rddata when dma_rdchannel(1)='1' 	   -- GLIB - Modified
--															else slave_rddata;							   -- GLIB - Modified

end structural;