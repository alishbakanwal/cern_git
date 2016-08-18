--------------------------------------------------------------------------------
--
-- This source code is confidential information and may be used only as
-- authorized by a licensing agreement from PLDA.
--
--------------------------------------------------------------------------------
-- Project : PCIEZ Reference design
-- $RCSfile: slave_mgt.vhd,v $
-- $Date: 2011/06/28 15:08:38 $
-- $Revision: 1.1.1.7 $
-- $Name: PCIEZREFD_20110627 $
-- $Author: reid $
-------------------------------------------------------------------------------
-- Dependency  :
-------------------------------------------------------------------------------
-- Description : PCIEZ reference design registers & internal SRAM management
-------------------------------------------------------------------------------
-- Revision:
-- $Log: slave_mgt.vhd,v $
-- Revision 1.1.1.7  2011/06/28 15:08:38  reid
-- importing projects/pciez_refdesign (PCIEZREFD_20110627, PCIEZREFD_20110627) to RTK database
--
-- Revision 1.18  2010/10/04 12:28:58  plegros
-- Updated cfg_ltssm decoding for rich3 core
--
-- Revision 1.17  2010/07/15 08:06:12  plegros
-- Added support for 256-bit datapath, partial code rewrite for clarity
--
-- Revision 1.16  2009/09/04 12:13:48  plegros
-- Fixed register read-back in 64-bit mode
--
-- Revision 1.15  2009/08/26 13:05:43  plegros
-- Fixed slv_bytevalid out of range problem
--
-- Revision 1.14  2009/08/24 12:19:51  plegros
-- Added 32-bit support
--
-- Revision 1.13  2009/03/31 08:52:57  plegros
-- 128-bit mode fixes
--
-- Revision 1.12  2009/03/30 13:39:26  jdenis
-- Implemented 128-bit support
--
-- Revision 1.11  2008/11/28 15:14:45  plegros
-- usr_led is now registered and completely assigned in slave_mgt module
--
-- Revision 1.10  2008/11/10 14:41:55  plegros
-- *** empty log message ***
--
-- Revision 1.9  2008/10/16 12:35:08  plegros
-- slv_abort is now asserted when accesses not in BAR0/BAR2 are detected
--
-- Revision 1.8  2007/11/12 13:55:21  plegros
-- Link retraining is now a note and no longer an error
--
-- Revision 1.7  2007/06/21 08:26:01  plegros
-- Added translateoff to report statement
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
-- Revision 1.2  2006/04/14 09:00:17  plegros
-- *** empty log message ***
--

--####################### GLIB project modifications ###########################--
--# Modified by Manoel Barros Marin (manoel.barros.marin@cern.ch) (05/09/2012) #--
--##############################################################################--

-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

-- User libraries and packages:																				-- GLIB - Added
use work.user_pcie_ber_package.all;    																	-- GLIB - Added

-------------------------------------------------------------------------------

entity slave_mgt is
	generic (
		-- Indicates data path (32,64,128 or 256 bits):
		DATAPATH    					: integer:=64
	);			
	port (			
	   clk 								: in  std_logic;
	   rstn 								: in  std_logic;
	   srst								: in  std_logic;
					
		cfg_ltssm						: in  std_logic_vector( 4 downto 0);
	   cfg_linkcsr 					: in  std_logic_vector(31 downto 0);

		-- Slave interface:
	   slv_bar 							: in  std_logic_vector( 6 downto 0);
	   slv_addr 						: in  std_logic_vector(63 downto 0);
	   slv_readreq 					: in  std_logic;
	   slv_writereq 					: in  std_logic;
	   slv_write 						: in  std_logic;
	   slv_dataout 					: in  std_logic_vector(DATAPATH-1 downto 0);
	   slv_bytevalid 					: in  std_logic_vector(DATAPATH/8-1 downto 0);
	   slv_bytecount 					: in  std_logic_vector(12 downto 0);
	   slv_cpladdr 					: in  std_logic_vector(31 downto 0);
	   slv_cplparam 					: in  std_logic_vector( 7 downto 0);
	   slv_accept 						: out std_logic;
	   slv_abort 						: out std_logic;
			
	   -- Register write:			
	   reg_write						: out std_logic_vector(15 downto 0);
	   reg_writedata					: out std_logic_vector(DATAPATH-1 downto 0);
			
--	   -- Flash control:			
--	   flash_wr							: out std_logic_vector( 1 downto 0);							-- GLIB - Modified
--		flash_wrdata					: out std_logic_vector(63 downto 0);							-- GLIB - Modified
--		flash_rddata					: in  std_logic_vector(63 downto 0);							-- GLIB - Modified

	   -- Interrupt signal:
	   int_ack							: in  std_logic;														-- GLIB - Added
		int_request						: out std_logic;
	   dma_int_req						: in  std_logic;

		-- Used to indicate the DMA status and parameter content:
		dma1_regout 					: in  std_logic_vector(127 downto 0);
	   dma1_info_reg					: in  std_logic_vector( 31 downto 0);
	   dma1_status					   : in  std_logic_vector(  3 downto 0);
		dma2_regout 					: in  std_logic_vector(127 downto 0);
	   dma2_info_reg					: in  std_logic_vector( 31 downto 0);
	   dma2_status					   : in  std_logic_vector(  3 downto 0);

		-- A DMA is used to make memory read completion:
	   dma3_regin						: out std_logic_vector(127 downto 0);
	   dma3_param 						: out std_logic_vector( 23 downto 0);
	   dma3_control 					: out std_logic_vector(  5 downto 0);
	   dma3_status 					: in  std_logic_vector(  3 downto 0);
	   dma3_fifocnt 					: out std_logic_vector( 12 downto 0);

		-- DMA signals used in order to make CPL:
--	   slave_rddata   				: out std_logic_vector(DATAPATH-1 downto 0);					-- GLIB - Modified
--	   dma_rd							: in std_logic;                                    		-- GLIB - Modified
--	   dma_rdaddr 						: in std_logic_vector(12 downto 0);               			-- GLIB - Modified
		dma3_rddata   					: out std_logic_vector(DATAPATH-1 downto 0);
		dma3_rd							: in  std_logic;
		dma3_rdaddr						: in  std_logic_vector(12 downto 0);

--		-- On-board LED control:																	 			-- GLIB - Modified
--    usr_led           			: out std_logic_vector(3 downto 0)              			-- GLIB - Modified

		-- BER:																										-- GLIB - Added
		BER_I								: in  R_pcieBer_from_ber;											-- GLIB - Added
		BER_O								: out R_pcieBer_to_ber												-- GLIB - Added

	);
end slave_mgt;
architecture structural of slave_mgt is
	
	component dcrambe
		generic (
			ADDR_WIDTH 					: integer := 4;
			DATA_WIDTH 					: integer := 32;
			BYTE_SIZE  					: integer range 8 to 9 := 8
		);			
		port (			
			wrclk							: in  std_logic;
			wraddr						: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
			wrdata						: in  std_logic_vector (DATA_WIDTH-1 downto 0);
			wrbe							: in  std_logic_vector (DATA_WIDTH/BYTE_SIZE-1 downto 0);
			rdclk							: in  std_logic;
			rdaddr						: in  std_logic_vector (ADDR_WIDTH-1 downto 0);
			rddata						: out std_logic_vector (DATA_WIDTH-1 downto 0)
		);
	end component;

	---------------------------------------------------------------

	-- Compute least significant address bit, according to datapath size:
	-- 32-bit : 2, 64-bit : 3 , 128-bit : 4, 256-bit : 5
	constant ADDR_LOW					: integer := 2 + (DATAPATH/64)-(DATAPATH/256);

   -- Register numbers:
   constant MAILBOX_REG_NUM 		: integer := 9;
-- constant FLASH0_REG_NUM 		: integer := 10;														-- GLIB - Modified
-- constant FLASH1_REG_NUM 		: integer := 11;														-- GLIB - Modified
	constant GLIB_CTRL_NUM	 		: integer := 10;														-- GLIB - Modified
	constant BER_ERR_CNTR_NUM 		: integer := 11;														-- GLIB - Modified
   constant INTERRUPT_REG_NUM 	: integer := 13;

    -- Compute register data position in slv_dataout, according to datapath size:
	constant MAILBOX_REG_POS 		: integer := (MAILBOX_REG_NUM   mod (DATAPATH/32))*32;
--	constant FLASH0_REG_POS 		: integer := (FLASH0_REG_NUM    mod (DATAPATH/32))*32;	-- GLIB - Modified
--	constant FLASH1_REG_POS 		: integer := (FLASH1_REG_NUM    mod (DATAPATH/32))*32;	-- GLIB - Modified
	constant GLIB_CTRL_POS 			: integer := (GLIB_CTRL_NUM 	  mod (DATAPATH/32))*32;	-- GLIB - Modified
	constant BER_ERR_CNTR_POS 		: integer := (BER_ERR_CNTR_NUM  mod (DATAPATH/32))*32;	-- GLIB - Modified
	constant INTERRUPT_REG_POS 	: integer := (INTERRUPT_REG_NUM mod (DATAPATH/32))*32;

	---------------------------------------------------------------

	-- Attributes:																									-- GLIB - Added
	-- (To avoid signal trimming for Chipscope)															-- GLIB - Added
	attribute S										: string; 													-- GLIB - Added					
																														-- GLIB - Added
	-- Dummy signals for Chipscope:                                                        -- GLIB - Added
	--																													-- GLIB - Added		
	-- (Note!!! Some signals are trimmed by XST so must be registered for being tapped     -- GLIB - Added
	-- with Chipscope. For that reason, all signals tapped with Chipscope are registered	-- GLIB - Added
	-- in order to have the same delay in all of them).												-- GLIB - Added
	--                																							-- GLIB - Added
	signal slv_bar_chsc							: std_logic_vector(6 downto 0);                 -- GLIB - Added
	attribute S	of slv_bar_chsc				: signal is "true";                             -- GLIB - Added
	signal slv_addr_chsc							: std_logic_vector(63 downto 0);                -- GLIB - Added
	attribute S	of slv_addr_chsc				: signal is "true";                             -- GLIB - Added
	signal slv_readreq_chsc						: std_logic;                                    -- GLIB - Added
	attribute S	of slv_readreq_chsc			: signal is "true";                             -- GLIB - Added
	signal slv_writereq_chsc					: std_logic;                                    -- GLIB - Added
	attribute S	of slv_writereq_chsc			: signal is "true";                             -- GLIB - Added
	signal slv_write_chsc						: std_logic;                        				-- GLIB - Added
	attribute S	of slv_write_chsc				: signal is "true";                             -- GLIB - Added
	signal slv_dataout_chsc						: std_logic_vector(63 downto 0);                -- GLIB - Added
	attribute S	of slv_dataout_chsc			: signal is "true";                             -- GLIB - Added
	signal slv_bytecount_chsc					: std_logic_vector(12 downto 0);                -- GLIB - Added
	attribute S	of slv_bytecount_chsc		: signal is "true";                             -- GLIB - Added
	signal slv_accept_int						: std_logic;                        				-- GLIB - Added
	signal slv_accept_chsc						: std_logic;                        				-- GLIB - Added
	attribute S	of slv_accept_chsc			: signal is "true";                             -- GLIB - Added
	signal slv_abort_int						   : std_logic;                        				-- GLIB - Added
	signal slv_abort_chsc						: std_logic;                        				-- GLIB - Added
	attribute S	of slv_abort_chsc				: signal is "true";                             -- GLIB - Added
	signal int_ack_chsc							: std_logic;                        				-- GLIB - Added
	attribute S	of int_ack_chsc				: signal is "true";                             -- GLIB - Added
	signal int_request_chsc						: std_logic;                        				-- GLIB - Added
	attribute S	of int_request_chsc			: signal is "true";                             -- GLIB - Added
	signal dma_int_req_chsc						: std_logic;                        				-- GLIB - Added
	attribute S	of dma_int_req_chsc			: signal is "true";                             -- GLIB - Added
	signal dma1_regout_chsc						: std_logic_vector(127 downto 0);              	-- GLIB - Added
	attribute S	of dma1_regout_chsc			: signal is "true";                             -- GLIB - Added
	signal dma1_info_reg_chsc					: std_logic_vector(31 downto 0);                -- GLIB - Added
	attribute S	of dma1_info_reg_chsc		: signal is "true";                             -- GLIB - Added
	signal dma2_regout_chsc						: std_logic_vector(127 downto 0);             	-- GLIB - Added
	attribute S	of dma2_regout_chsc			: signal is "true";                             -- GLIB - Added
	signal dma2_info_reg_chsc					: std_logic_vector(31 downto 0);                -- GLIB - Added
	attribute S	of dma2_info_reg_chsc		: signal is "true";                             -- GLIB - Added
	signal dma3_regin_int						: std_logic_vector(127 downto 0); 					-- GLIB - Added
	signal dma3_regin_chsc						: std_logic_vector(127 downto 0); 					-- GLIB - Added
	attribute S	of dma3_regin_chsc			: signal is "true";                             -- GLIB - Added
	signal dma3_control_int					   : std_logic_vector(  5 downto 0); 				   -- GLIB - Added
	signal dma3_control_chsc					: std_logic_vector(  5 downto 0); 					-- GLIB - Added
	attribute S	of dma3_control_chsc			: signal is "true";                             -- GLIB - Added
	signal dma3_status_chsc						: std_logic_vector(3 downto 0);                 -- GLIB - Added
	attribute S	of dma3_status_chsc			: signal is "true";                           	-- GLIB - Added
	signal dma3_rddata_int						: std_logic_vector(63 downto 0); 	            -- GLIB - Added
	signal dma3_rddata_chsc						: std_logic_vector(63 downto 0); 	            -- GLIB - Added
	attribute S	of dma3_rddata_chsc			: signal is "true";                             -- GLIB - Added			
 	signal dma3_rd_chsc							: std_logic; 							               -- GLIB - Added
	attribute S	of dma3_rd_chsc				: signal is "true";                             -- GLIB - Added  
	signal dma3_rdaddr_chsc						: std_logic_vector(12 downto 0);	               -- GLIB - Added
	attribute S	of dma3_rdaddr_chsc			: signal is "true";                             -- GLIB - Added 
	signal glib_ctrl_reg_chsc					: std_logic_vector(31 downto 0);	            	-- GLIB - Added
	attribute S	of glib_ctrl_reg_chsc		: signal is "true";                            	-- GLIB - Added
	signal error_cntr_chsc						: std_logic_vector(31 downto 0);               	-- GLIB - Added
	attribute S	of error_cntr_chsc			: signal is "true";                             -- GLIB - Added
	signal error_flag_chsc						: std_logic; 							               -- GLIB - Added
	attribute S	of error_flag_chsc			: signal is "true";                             -- GLIB - Added
	signal noerror_flag_chsc					: std_logic; 							               -- GLIB - Added
	attribute S	of noerror_flag_chsc			: signal is "true";                             -- GLIB - Added
 
	-- RAM management
	signal ram_wrbe								: std_logic_vector(DATAPATH/8-1 downto 0);
	signal ram_dataout, ram_dataout_r		: std_logic_vector(DATAPATH-1 downto 0);

	-- Registers management
	signal interrupt_status_r, readreg_r	: std_logic;
	attribute S	of interrupt_status_r		: signal is "true";                             -- GLIB - Added
	signal reg_write_r							: std_logic_vector(15 downto 0);
   signal reg_writedata_r, reg_dataout_r	: std_logic_vector(DATAPATH-1 downto 0);
	signal mailbox_reg     	               : std_logic_vector(31 downto 0);			
	signal glib_ctrl_reg    	            : std_logic_vector(31 downto 0);					   -- GLIB - Added	
	signal manual_int                      : std_logic;	                                 -- GLIB - Added	
   signal interrupt_reg, retraining_reg	: std_logic_vector(31 downto 0);
	signal cfg_ltssm_r							: std_logic_vector( 4 downto 0);
	signal retraining_count_r					: std_logic_vector( 7 downto 0);

	signal ZERO 									: std_logic_vector(31 downto 0);
	
begin

	ZERO 												<= (others => '0');

	-- Dummy Registers for Chipscope:																		-- GLIB - Added
	process(clk, rstn)																							-- GLIB - Added
   begin                                                 											-- GLIB - Added
		if rstn = '0' then                                 											-- GLIB - Added
			slv_bar_chsc							<= (others => '0');										-- GLIB - Added	
			slv_addr_chsc				   		<= (others => '0');  									-- GLIB - Added
			slv_readreq_chsc			   		<= '0';              									-- GLIB - Added
			slv_writereq_chsc			   		<= '0';              									-- GLIB - Added
			slv_write_chsc							<= '0';	            									-- GLIB - Added
			slv_dataout_chsc						<= (others => '0');  									-- GLIB - Added	
			slv_bytecount_chsc					<= (others => '0');  									-- GLIB - Added
			slv_accept_chsc						<= '0';              									-- GLIB - Added
			slv_abort_chsc							<= '0';              									-- GLIB - Added	
			int_ack_chsc							<= '0';              									-- GLIB - Added	
			int_request_chsc						<= '0';              									-- GLIB - Added  
			dma_int_req_chsc						<= '0';              									-- GLIB - Added
			dma1_regout_chsc						<= (others => '0');  									-- GLIB - Added
			dma1_info_reg_chsc					<= (others => '0');  									-- GLIB - Added
			dma2_regout_chsc						<= (others => '0');  									-- GLIB - Added
			dma2_info_reg_chsc					<= (others => '0');										-- GLIB - Added
			dma3_regin_chsc						<= (others => '0');										-- GLIB - Added
			dma3_control_chsc						<= (others => '0');										-- GLIB - Added
			dma3_status_chsc						<= (others => '0');										-- GLIB - Added
			dma3_rddata_chsc						<= (others => '0');										-- GLIB - Added
			dma3_rd_chsc							<= '0';            										-- GLIB - Added
			dma3_rdaddr_chsc						<= (others => '0');										-- GLIB - Added
			glib_ctrl_reg_chsc					<= (others => '0');										-- GLIB - Added
			error_cntr_chsc						<= (others => '0');										-- GLIB - Added
			error_flag_chsc						<= '0';														-- GLIB - Added
			noerror_flag_chsc						<= '0';														-- GLIB - Added
		elsif rising_edge(clk) then                        											-- GLIB - Added
			slv_bar_chsc							<= slv_bar;													-- GLIB - Added	
			slv_addr_chsc				   		<= slv_addr;  												-- GLIB - Added
			slv_readreq_chsc			   		<= slv_readreq;              							-- GLIB - Added
			slv_writereq_chsc			   		<= slv_writereq;              						-- GLIB - Added
			slv_write_chsc							<= slv_write;	            							-- GLIB - Added
			slv_dataout_chsc						<= slv_dataout;  											-- GLIB - Added	
			slv_bytecount_chsc					<= slv_bytecount;  										-- GLIB - Added
			slv_accept_chsc						<= slv_accept_int;           							-- GLIB - Added
			slv_abort_chsc							<= slv_abort_int;            							-- GLIB - Added	
			int_ack_chsc							<= int_ack;              								-- GLIB - Added	
			int_request_chsc						<= interrupt_status_r;       							-- GLIB - Added  
			dma_int_req_chsc						<= dma_int_req;              							-- GLIB - Added
			dma1_regout_chsc						<= dma1_regout;  											-- GLIB - Added
			dma1_info_reg_chsc					<= dma1_info_reg;  										-- GLIB - Added
			dma2_regout_chsc						<= dma2_regout;  											-- GLIB - Added
			dma2_info_reg_chsc					<= dma2_info_reg;											-- GLIB - Added
			dma3_regin_chsc						<= dma3_regin_int;										-- GLIB - Added
			dma3_control_chsc						<= dma3_control_int;										-- GLIB - Added
			dma3_status_chsc						<= dma3_status;											-- GLIB - Added
			dma3_rddata_chsc						<= dma3_rddata_int;										-- GLIB - Added
			dma3_rd_chsc							<= dma3_rd;            									-- GLIB - Added
			dma3_rdaddr_chsc						<= dma3_rdaddr;											-- GLIB - Added 	 
			glib_ctrl_reg_chsc					<= glib_ctrl_reg; 										-- GLIB - Added
			error_cntr_chsc						<= BER_I.error_cntr;										-- GLIB - Added
			error_flag_chsc						<= BER_I.error_flag;										-- GLIB - Added
			noerror_flag_chsc						<= BER_I.noerr_flag;										-- GLIB - Added
      end if;                                          												-- GLIB - Added
   end process;                                        												-- GLIB - Added

	--------------------------------------------------------------------------
	-- Handle incoming transactions.
	--------------------------------------------------------------------------

--	-- Abort transactions that are not in BAR0 and BAR2 (should not happen)															-- GLIB - Modified
--	slv_abort <= '1' when (slv_bar(0)='0' and slv_bar(2)='0')                              									-- GLIB - Modified
--				and (slv_writereq='1' or slv_readreq='1')																						-- GLIB - Modified
--				else '0';                                                                                                -- GLIB - Modified
																																							-- GLIB - Modified
	slv_abort_int	   <= '1' when (slv_bar(2) = '1' or slv_bar(4)='1')                     and                        -- GLIB - Modified          
                                 (slv_readreq = '1' and dma3_status(3) = '1')                                        -- GLIB - Modified
                        else '0';                                                                                  	-- GLIB - Modified
   slv_abort         <= slv_abort_int;                                                                               -- GLIB - Modified
                                                                                                                     -- GLIB - Modified
	-- Always accept writes in BAR2 and BAR4,																									-- GLIB - Modified
	-- Accept read transactions only if dma3 channel is available to perform completion          							-- GLIB - Modified
	slv_accept_int 	<= '1' when (slv_bar(2) = '1' or slv_bar(4) = '1')                   and           					-- GLIB - Modified
                                 (slv_writereq = '1' or (slv_readreq = '1' and dma3_status(3) = '0'))    				-- GLIB - Modified
                        else '0';        																										-- GLIB - Modified	                                       
   slv_accept        <= slv_accept_int;

	-------------------------------------------------------------------------- 
	-- Program DMA3 to perform completion when a read transaction              													-- GLIB - Modified
	-- is targeting BAR2 or BAR4.                                              													-- GLIB - Modified
	-------------------------------------------------------------------------- 
																										
	-- Save necessary registers in order to perform the completion:            
	--                                                                         
	-- Local address, note that bit 12 is used to remember which BAR was targetted ('0' -> BAR2 | '1' -> BAR4): 		-- GLIB - Modified
   dma3_regin_int(127 downto 96)		<= ZERO(31 downto 13) & slv_bar(4) & slv_addr(11 downto 0); 							-- GLIB - Modified
   -- Size:		                                                                                                      -- GLIB - Modified
	dma3_regin_int(95 downto 64) 		<= ZERO(31 downto 13) & slv_bytecount;                  		                     -- GLIB - Modified
	-- Address:		                                                                                                   -- GLIB - Modified
	dma3_regin_int(63 downto 0) 		<= ZERO & slv_cpladdr;                                                           -- GLIB - Modified
   dma3_regin                       <= dma3_regin_int;                                                               -- GLIB - Modified
 
	-- Set DMA parameters:                                                          
	--                                                                              
	-- Copy completion parameters:                                                             
	dma3_param(23 downto 16) 			<= slv_cplparam;                                            -- GLIB - Modified
	-- Reserved bits:																										
	dma3_param(15 downto 12) 			<= "0000";                                                  -- GLIB - Modified
	-- Cpl command:	
	dma3_param(11 downto 8)  			<= "0100";                                                  -- GLIB - Modified
	-- Byte-enables are n/a for completions: 
	dma3_param(7 downto 4)   			<= "0000";                                                  -- GLIB - Modified
	-- RAM mode, latency is 0 for registers & 1 for RAM due to extra-cycle to read from RAM:
	dma3_param(3 downto 0)   			<= "0" & slv_bar(4) & "01";                                 -- GLIB - Modified

	-- Program & start DMA to perform completion as soon as read request is received:		
   dma3_control_int 						<= "011111" when (slv_bar(2) = '1' or slv_bar(4) = '1')     -- GLIB - Modified
													and  (slv_readreq = '1' and dma3_status(3) = '0')        -- GLIB - Modified
													else (others => '0');                                    -- GLIB - Modified
   dma3_control                     <= dma3_control_int;                                        -- GLIB - Modified
                                                                                                
	-- FIFO count is not used because DMA operates in RAM-mode (data is always ready): 
	dma3_fifocnt 							<= (others => '0');                                         -- GLIB - Modified
                                                                                              
    -------------------------------------------------------------------------
	-- Implement 4KB RAM mapped in BAR4 (4KB address space).  												-- GLIB - Modified
    -------------------------------------------------------------------------

   -- Create ram write enable:
   ram_wrbe 								<= slv_bytevalid when slv_bar(4) = '1' and slv_write = '1'	-- GLIB - Modified		
													else (others => '0');												

	ram : dcrambe
		generic map (
			ADDR_WIDTH						=> (12-ADDR_LOW),
			DATA_WIDTH						=> DATAPATH,
			BYTE_SIZE  						=> 8)
		port map (		
			wrclk								=> clk,
			wraddr  							=> slv_addr(11 downto ADDR_LOW),
			wrdata 							=> slv_dataout,
			wrbe								=> ram_wrbe,
			rdclk								=> clk,
			rdaddr							=> dma3_rdaddr(11 downto ADDR_LOW),									-- GLIB - Modified
			rddata  							=> ram_dataout
		);

	-- Register RAM output:
	process(clk, rstn)
   begin
		if rstn = '0' then
         ram_dataout_r 					<= (others => '0');
      elsif rising_edge(clk) then
        	if srst = '1' then
        		ram_dataout_r 				<= (others => '0');
        	else		
        		ram_dataout_r 				<= ram_dataout;
        	end if;
      end if;
   end process;

	--------------------------------------------------------------------------
	-- Registers are mapped in BAR0 (4KB address space)
	--
	-- Note!!! This addresing shown here is DW-aligned
	--
	-- 000h - REG0  : dma1 address LSB register				
	-- 004h - REG1  : dma1 address MSB register
	-- 008h - REG2  : dma1 size register
	-- 00ch - REG3  : dma1 information register
	-- 010h - REG4  : dma2 address LSB register
	-- 014h - REG5  : dma2 address MSB register
	-- 018h - REG6  : dma2 size register
	-- 01ch - REG7  : dma2 information register
	-- 020h - REG8  : Version register
	-- 024h - REG9  : Mailbox register
	-- 028h - REG10 : BER 2DW count, BER reset(3), BER noErrFlag(1), BER cntReset(0) -- Flash control register #0	-- GLIB - Modified
	-- 02Ch - REG11 : BER Error Count 											               -- Flash control register #1	-- GLIB - Modified
	-- 030h - REG12 : Retraining counter
	-- 034h - REG13 : Manual Interrupt(2), Interrupt Ack(1), Interrupt reset(0)                                    -- GLIB - Modified
	-- 030h - REG12 : Retraining counter
	-- others       : reserved
	--------------------------------------------------------------------------

	process(clk, rstn)
   begin
		if rstn = '0' then
			reg_writedata_r 					<= (others => '0');
-- 		mailbox_reg 						<= (others => '0');
			mailbox_reg 						<= x"beefcafe";		-- GLIB - Modified
			glib_ctrl_reg						<= (others => '0');	-- GLIB - Added
			cfg_ltssm_r 						<= (others => '0');
			retraining_count_r 				<= (others => '0');
			manual_int		               <= '0';              -- GLIB - Added
         interrupt_status_r 				<= '0';
--			usr_led 								<= (others => '0');	-- GLIB - Modified
      elsif rising_edge(clk) then
        	if srst = '1' then
        		reg_writedata_r 				<= (others => '0');
--				mailbox_reg 					<= (others => '0');
	         mailbox_reg 					<= x"beefcafe";		-- GLIB - Modified
				glib_ctrl_reg					<= (others => '0');	-- GLIB - Added
				cfg_ltssm_r 					<= (others => '0');
				retraining_count_r 			<= (others => '0');
            manual_int		            <= '0';              -- GLIB - Added
				interrupt_status_r 			<= '0';
--				usr_led 							<= (others => '0');	-- GLIB - Modified
        	else
        		-- Detect that register(s) is/are written					
        		-- when address match and byte enable for low-order bits is set:
 	        	for i in 0 to 15 loop
        	      if slv_bar(2) = '1' and slv_write = '1' and 
					unsigned(slv_addr(11 downto ADDR_LOW)) = (i/(DATAPATH/32)) then
            		reg_write_r(i) 		<= slv_bytevalid((i mod (DATAPATH/32))*4);
               else
               	reg_write_r(i) 		<= '0';
	            end if;
    	      end loop;

        		-- Remember written data:
        	 	reg_writedata_r 				<= slv_dataout;

				-- 24h: Mailbox register:
	         if reg_write_r(MAILBOX_REG_NUM) = '1' then
	            mailbox_reg 				<= reg_writedata_r(MAILBOX_REG_POS+31 downto MAILBOX_REG_POS);
	        	end if;
								
				
				-- 28h: BER 2DW counter, BER reset(2), BER no error flag(1), BER counter reset(0):        -- GLIB - Added
				glib_ctrl_reg(31 downto 3) <= BER_I.doubleDWcntr;                                         -- GLIB - Added
            glib_ctrl_reg(2)				<= '0';																		   -- GLIB - Added
	         glib_ctrl_reg(1)				<= BER_I.noerr_flag;														   -- GLIB - Added
				glib_ctrl_reg(0)				<= '0';																		   -- GLIB - Added
				if reg_write_r(GLIB_CTRL_NUM) = '1' then																   -- GLIB - Added										
               glib_ctrl_reg(2)			<= reg_writedata_r(GLIB_CTRL_POS+2);								   -- GLIB - Added					              
					glib_ctrl_reg(0)			<= reg_writedata_r(GLIB_CTRL_POS);									   -- GLIB - Added		
				end if;																											   -- GLIB - Added				
				

	        	-- 30h : Retraining counter:
	        	--
				-- This counter is incremented each time link is retrained because of an error
	        	-- (L0 -> recovery state transition is detected). This can help diagnose instable link.
	 			cfg_ltssm_r 					<= cfg_ltssm;

	 			if (cfg_ltssm = "01100" and cfg_ltssm_r = "01111")        	-- rich2/lite2/ezdma core
	 			   or (cfg_ltssm = "01011" and cfg_ltssm_r = "10000") then  -- rich3 core
					-- Synthesis translate_off:
						report "SLAVE_MGT : INFO : LINK RETRAINING DETECTED" severity note;
					-- Synthesis translate_on:
						retraining_count_r 	<= unsigned (retraining_count_r) + '1';
	 			end if;


				-- 34h: Interrupt register:
				--
				-- int_request is asserted when an interrupt is received from DMA management block.
				-- It is de-asserted when writing one at bit 0 of interrupt reg

            -- Manual Interrupt:                                                                       -- GLIB - Added
            manual_int              <= '0';
            if reg_write_r(INTERRUPT_REG_NUM) = '1' and reg_writedata_r(INTERRUPT_REG_POS+2) = '1' then           
               if interrupt_status_r = '0' then																		    -- GLIB - Added
						manual_int		   <= '1';                             								       -- GLIB - Added					
               end if;																										    -- GLIB - Added            
            end if;
           
            if reg_write_r(INTERRUPT_REG_NUM) = '1' and reg_writedata_r(INTERRUPT_REG_POS) = '1' then
	       		interrupt_status_r 		<= '0';
				elsif dma_int_req = '1' or manual_int = '1' then	 										          -- GLIB - Modified
					interrupt_status_r 		<= '1';
	 			end if;
            
            
--	 			-- Control on-board LEDs																					    -- GLIB - Modified
--	 			usr_led(2 downto 0) 			<= mailbox_reg(2 downto 0);											    -- GLIB - Modified
--																																	    -- GLIB - Modified
--				-- Indicate that link is initialised when "Negotiated Link Width" field						    -- GLIB - Modified
--				-- of link control register is set:																		    -- GLIB - Modified
--				if unsigned (cfg_linkcsr(27 downto 20)) /= 0 then													    -- GLIB - Modified
--	 				usr_led(3) 					<='1';																		    -- GLIB - Modified
--	 			else																												    -- GLIB - Modified
--	 				usr_led(3) 					<='0';																		    -- GLIB - Modified
--	 			end if;																											    -- GLIB - Modified

			end if;
		end if;
	end process;
				
   BER_O.reset                         <= glib_ctrl_reg(2);														     -- GLIB - Added
	BER_O.cntrReset							<= glib_ctrl_reg(0);														     -- GLIB - Added

	int_request 								<= interrupt_status_r;
   interrupt_reg 								<= ZERO(31 downto 3) & manual_int & int_ack & interrupt_status_r;	-- GLIB - Modified
   
	retraining_reg 							<= ZERO(31 downto 8) & retraining_count_r;	

--   flash_wr 						<= reg_write_r(FLASH1_REG_NUM) & reg_write_r(FLASH0_REG_NUM);			-- GLIB - Modified			
--   flash_wrdata 				<= reg_writedata_r(FLASH1_REG_POS+31 downto FLASH1_REG_POS)          -- GLIB - Modified
--											& reg_writedata_r(FLASH0_REG_POS+31 downto FLASH0_REG_POS);       -- GLIB - Modified

	reg_write 									<= reg_write_r;
	reg_writedata 								<= reg_writedata_r;
	
	--------------------------------------------------------------------------
	-- Return read data (from registers or RAM) when DMA3 requests read										-- GLIB - Modified
	--------------------------------------------------------------------------

	-- Remember which BAR is read	(BAR4 for RAM / BAR2 for Registers):										-- GLIB - Modified
   process(clk, rstn)
   begin
      if rstn = '0' then
         readreg_r 							<= '0';
        elsif rising_edge(clk) then
         if srst = '1' then
            readreg_r 						<= '0';
         else
            -- select what is read
            if dma3_rd = '1' then																						-- GLIB - Modified
               if dma3_rdaddr(12) = '0' then																			-- GLIB - Modified
                  readreg_r 				<= '1';	-- read from registers
               else
                  readreg_r 				<= '0';	-- read from internal memory
               end if;
            end if;
         end if;
      end if;
   end process;

--	-- Multiplex registers for read-back (32-bit datapath):														-- GLIB - Modified
--	gread32: if DATAPATH = 32 generate                                                           	-- GLIB - Modified
--		process (clk, rstn)																									-- GLIB - Modified
--	   begin                                                                                        -- GLIB - Modified
--			if rstn = '0' then																								-- GLIB - Modified
--				reg_dataout_r 					<= (others => '0');                                         -- GLIB - Modified
--	      elsif rising_edge(clk) then                                                               -- GLIB - Modified
--	      	if srst = '1' then                                                                     -- GLIB - Modified
--	        		reg_dataout_r 				<= (others => '0');														-- GLIB - Modified
--	        	else                                                                                   -- GLIB - Modified
--	            case dma3_rdaddr(11 downto 2) is                                                    -- GLIB - Modified
--	    	      	when "0000000000" => reg_dataout_r <= dma1_regout(31 downto  0);                 -- GLIB - Modified
--	    	      	when "0000000001" => reg_dataout_r <= dma1_regout(63 downto 32);						-- GLIB - Modified
--	    	      	when "0000000010" => reg_dataout_r <= dma1_regout(95 downto 64);                 -- GLIB - Modified
--	    	      	when "0000000011" => reg_dataout_r <= dma1_info_reg;                             -- GLIB - Modified
--	    	      	when "0000000100" => reg_dataout_r <= dma2_regout(31 downto  0);                 -- GLIB - Modified
--	    	      	when "0000000101" => reg_dataout_r <= dma2_regout(63 downto 32);						-- GLIB - Modified
--	    	      	when "0000000110" => reg_dataout_r <= dma2_regout(95 downto 64);           		-- GLIB - Modified
--	    	      	when "0000000111" => reg_dataout_r <= dma2_info_reg;                    			-- GLIB - Modified
--	    	      	when "0000001000" => reg_dataout_r <= x"00000020";                            	-- GLIB - Modified
--	    	      	when "0000001001" => reg_dataout_r <= mailbox_reg;                               -- GLIB - Modified
--	    	      	when "0000001010" => reg_dataout_r <= flash_rddata(31 downto  0);    				-- GLIB - Modified
--	    	      	when "0000001011" => reg_dataout_r <= flash_rddata(63 downto 32);                -- GLIB - Modified
--	    	      	when "0000001100" => reg_dataout_r <= retraining_reg;                            -- GLIB - Modified
--	    	      	when "0000001101" => reg_dataout_r <= interrupt_reg;                             -- GLIB - Modified
--						when others 	 	=> reg_dataout_r <= (others => '0');               				-- GLIB - Modified
--					end case;                                                                       		-- GLIB - Modified
--	        	end if;                                                                                -- GLIB - Modified
--	      end if;                                                                                   -- GLIB - Modified
--	    end process;                                                                                -- GLIB - Modified
--	end generate gread32;                                                                           -- GLIB - Modified
                                                                                         
	-- Multiplex registers for read-back (64-bit datapath):                                         
	gread64: if DATAPATH = 64 generate                                                              
		process(clk, rstn)
	   begin
			if rstn = '0' then
				reg_dataout_r 					<= (others => '0');
	      elsif rising_edge(clk) then
	        	if srst = '1' then
	        		reg_dataout_r 				<= (others => '0');
	        	else
	            case dma3_rdaddr(11 downto 3) is		 -- Note!!! 2DW-alignment
	    	        	when "000000000" => reg_dataout_r <= dma1_regout(63 downto 0);
	    	        	when "000000001" => reg_dataout_r <= dma1_info_reg & dma1_regout(95 downto 64);
	    	        	when "000000010" => reg_dataout_r <= dma2_regout(63 downto 0);
	    	        	when "000000011" => reg_dataout_r <= dma2_info_reg & dma2_regout(95 downto 64);
	    	        	when "000000100" => reg_dataout_r <= mailbox_reg & x"00000020";
--	    	        	when "000000101" => reg_dataout_r <= flash_rddata;                                        -- GLIB - Modified
	    	        	when "000000101" => reg_dataout_r <= BER_I.error_cntr & glib_ctrl_reg;                    -- GLIB - Modified
	    	        	when "000000110" => reg_dataout_r <= interrupt_reg & retraining_reg;
						when others 	  => reg_dataout_r <= (others => '0');
					end case;
	         end if;
	      end if;
	   end process;
	end generate gread64;

--	-- Multiplex registers for read-back (128-bit datapath):                                           		-- GLIB - Modified
--	gread128: if DATAPATH = 128 generate                                                                  	-- GLIB - Modified
--		process(clk, rstn)                                                                              		-- GLIB - Modified
--	   begin                                                                                                 -- GLIB - Modified
--			if rstn = '0' then                                                                           		-- GLIB - Modified
--				reg_dataout_r 					<=(others => '0');                                                   -- GLIB - Modified
--	      elsif rising_edge(clk) then                                                                        -- GLIB - Modified
--	        	if srst = '1' then                                                                              -- GLIB - Modified
--	        		reg_dataout_r 				<=(others=>'0');                                               		-- GLIB - Modified
--	        	else                                                                                            -- GLIB - Modified
--	            case dma3_rdaddr(11 downto 4) is                                                             -- GLIB - Modified
--	    	        	when "00000000" => reg_dataout_r <= dma1_info_reg & dma1_regout(95 downto 0);             -- GLIB - Modified
--	    	        	when "00000001" => reg_dataout_r <= dma2_info_reg & dma2_regout(95 downto 0);       		-- GLIB - Modified
--	    	        	when "00000010" => reg_dataout_r <= flash_rddata & mailbox_reg & x"00000020";             -- GLIB - Modified
--	    	        	when "00000011" => reg_dataout_r <= ZERO & ZERO & interrupt_reg & retraining_reg;         -- GLIB - Modified
--						when others 	 => reg_dataout_r <= (others => '0');                                      -- GLIB - Modified
--					end case;                                                                                		-- GLIB - Modified
--	      	end if;                                                        	                              -- GLIB - Modified
--	   	end if;                                                                                            -- GLIB - Modified
--		end process;                                                                                          -- GLIB - Modified
--	end generate gread128;                                                                                   -- GLIB - Modified
--                                                                         	                              -- GLIB - Modified
--	-- Multiplex registers for read-back (256-bit datapath):                                                 -- GLIB - Modified
--	gread256: if DATAPATH = 256 generate                                                                     -- GLIB - Modified
--		process(clk, rstn)                                                                                    -- GLIB - Modified
--	   begin                                                                                                 -- GLIB - Modified
--			if rstn = '0' then                                                                                 -- GLIB - Modified
--				reg_dataout_r 					<=(others => '0');                                             	   -- GLIB - Modified
--	      elsif rising_edge(clk) then                                                                        -- GLIB - Modified
--	        	if srst = '1' then                                                                              -- GLIB - Modified
--	        		reg_dataout_r 				<=(others => '0');                                                   -- GLIB - Modified
--	        	else                                                                                      	   -- GLIB - Modified
--	            case dma3_rdaddr(11 downto 5) is                                                       	   -- GLIB - Modified
--	    	        	when "0000000" => reg_dataout_r <= dma2_info_reg & dma2_regout(95 downto 0)               -- GLIB - Modified      
--	    	        							& dma1_info_reg & dma1_regout(95 downto 0);                             -- GLIB - Modified
--	    	        	when "0000001" => reg_dataout_r <= ZERO & ZERO & interrupt_reg & retraining_reg           -- GLIB - Modified
--	    	        							& flash_rddata & mailbox_reg & x"00000020";                       	   -- GLIB - Modified
--						when others    => reg_dataout_r <= (others=>'0');                                         -- GLIB - Modified
--					end case;                                                                                    -- GLIB - Modified
--	      	end if;                                                                                         -- GLIB - Modified
--	   	end if;                                                                                            -- GLIB - Modified
--		end process;                                                                                          -- GLIB - Modified
--	end generate gread256;                                                                                   -- GLIB - Modified

   -- Multiplex data outputs
   dma3_rddata_int 								<= reg_dataout_r when readreg_r = '1'                             -- GLIB - Modified
                                             else ram_dataout_r;                                            -- GLIB - Modified                  
   dma3_rddata                            <= dma3_rddata_int;                                               -- GLIB - Modified
   
end structural;