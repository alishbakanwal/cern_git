--------------------------------------------------------------------------------
--
-- This source code is confidential information and may be used only as
-- authorized by a licensing agreement from PLDA.
--
--------------------------------------------------------------------------------
-- Project : PCIEZ Reference design
-- $RCSfile: dma_mgt.vhd,v $
-- $Date: 2011/06/28 15:08:38 $
-- $Revision: 1.1.1.7 $
-- $Name: PCIEZREFD_20110627 $
-- $Author: reid $
-------------------------------------------------------------------------------
-- Dependency  :
-------------------------------------------------------------------------------
-- Description : PCIEZ reference design DMA management module
-------------------------------------------------------------------------------
-- Revision:
-- $Log: dma_mgt.vhd,v $
-- Revision 1.1.1.7  2011/06/28 15:08:38  reid
-- importing projects/pciez_refdesign (PCIEZREFD_20110627, PCIEZREFD_20110627) to RTK database
--
-- Revision 1.17  2011/05/24 08:48:25  plegros
-- Clarified DMA end detection so that it is similar with/without scatter-gather enabled
--
-- Revision 1.16  2011/02/23 15:42:41  plegros
-- Fixed dma1_status3_r reset value
--
-- Revision 1.15  2010/07/15 08:06:12  plegros
-- Added support for 256-bit datapath, partial code rewrite for clarity
--
-- Revision 1.14  2009/08/24 12:19:50  plegros
-- Added 32-bit support
--
-- Revision 1.13  2009/08/10 09:10:42  plegros
-- Update to new ez interface
--
-- Revision 1.12  2009/05/14 09:49:23  plegros
-- Renamed dma_fifocnt  ports of dma_sg for consistency
--
-- Revision 1.11  2009/04/27 14:31:30  jdenis
-- Modify S&G mode
--
-- Revision 1.10  2009/03/31 08:52:57  plegros
-- 128-bit mode fixes
--
-- Revision 1.9  2009/03/30 13:39:25  jdenis
-- Implemented 128-bit support
--
-- Revision 1.8  2009/03/12 07:52:02  plegros
-- Added clk_double input
--
-- Revision 1.7  2009/01/23 10:05:43  plegros
-- Updated dma_sg port list
--
-- Revision 1.6  2008/11/10 14:41:54  plegros
-- *** empty log message ***
--
-- Revision 1.5  2007/06/07 10:14:47  plegros
-- Renamed dma1_wrdata to dma_wrdata
--
-- Revision 1.4  2006/08/21 09:26:38  plegros
-- Update for v1.4
--
-- Revision 1.3  2006/07/20 15:03:14  plegros
-- Added scatter-gather DMA support
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

-- User libraries and packages:																				-- GLIB - Added
use work.user_pcie_ber_package.all;    																	-- GLIB - Added

---------------------------------------------------------------

entity dma_mgt is
	generic (
		DATAPATH    					: integer := 64;   -- Indicates DATA path : 32,64,128 or 256 bits
		CORE_FREQ						: integer := 250   -- Indicates core frequency : 62,125 or 250 MHz
	);	
	port (	
		clk 								: in  std_logic;
		rstn 								: in  std_logic;
		srst 								: in  std_logic;
		clk_doubled						: in  std_logic;

		-- Register write control:
		reg_write						: in  std_logic_vector (15 downto 0);
		reg_writedata					: in  std_logic_vector (DATAPATH-1 downto 0);

		-- DMA signals used in order to perform DMA
--		dma_wrchannel 					: in  std_logic_vector (15 downto 0);							-- GLIB - Modified
--		dma_rdchannel 					: in  std_logic_vector (15 downto 0);							-- GLIB - Modified
--		dma_wr							: in  std_logic;														-- GLIB - Modified
--		dma_rd 							: in  std_logic;														-- GLIB - Modified
--		dma_wrdata 		    			: in  std_logic_vector (DATAPATH-1 downto 0);				-- GLIB - Modified
		dma1_wrchannel 				: in  std_logic_vector(15 downto 0);							-- GLIB - Modified	
		dma1_wr							: in  std_logic;														-- GLIB - Modified
		dma1_wraddr 					: in  std_logic_vector(31 downto 0);							-- GLIB - Added
		dma1_wrdata 					: in  std_logic_vector(DATAPATH-1 downto 0);					-- GLIB - Modified		  
		dma2_wrchannel 				: in  std_logic_vector(15 downto 0);							-- GLIB - Modified
		dma2_wr							: in  std_logic;														-- GLIB - Modified
		dma2_wrdata 					: in  std_logic_vector(DATAPATH-1 downto 0);					-- GLIB - Modified			
		dma2_rdchannel 				: in  std_logic_vector(15 downto 0);							-- GLIB - Modified			
		dma2_rd 							: in  std_logic;														-- GLIB - Modified
	   dma2_rdaddr 					: in  std_logic_vector(31 downto 0);--(12 downto 0);		-- GLIB - Modified
		dma2_rddata						: out std_logic_vector(DATAPATH-1 downto 0);					-- GLIB - Modified

		-- A DMA is used to perform READ transactions (PCIe to Ref Design):		
		dma1_status 					: in  std_logic_vector (  3 downto 0);							-- GLIB - Modified
		dma1_regout						: in  std_logic_vector (127 downto 0);             		-- GLIB - Modified
		dma1_regin						: out std_logic_vector (127 downto 0);             		-- GLIB - Modified
		dma1_param 						: out std_logic_vector ( 23 downto 0);             		-- GLIB - Modified
		dma1_control					: out std_logic_vector (  5 downto 0);             		-- GLIB - Modified
		dma1_fifocnt					: out std_logic_vector ( 12 downto 0);            			-- GLIB - Modified
		dma1_info_reg					: out std_logic_vector ( 31 downto 0);             		-- GLIB - Modified

		-- A DMA is used to perform WRITE transactions (Ref Design to PCIe):
		dma2_status 					: in  std_logic_vector (  3 downto 0);							-- GLIB - Modified
		dma2_regout						: in  std_logic_vector (127 downto 0);                	-- GLIB - Modified
		dma2_regin						: out std_logic_vector (127 downto 0);                	-- GLIB - Modified
		dma2_param						: out std_logic_vector ( 23 downto 0);                	-- GLIB - Modified
		dma2_control					: out std_logic_vector (  5 downto 0);                	-- GLIB - Modified
		dma2_fifocnt					: out std_logic_vector ( 12 downto 0);               		-- GLIB - Modified
		dma2_info_reg					: out std_logic_vector ( 31 downto 0);		            	-- GLIB - Modified
		-- End of DMA interrupt signal:
		int_request						: in  std_logic; 														-- GLIB - Added
		dma_int_req						: out std_logic;

		-- BER:																										-- GLIB - Added
		BER_I								: in  R_pcieBer_to_ber;												-- GLIB - Added
		BER_O								: out R_pcieBer_from_ber											-- GLIB - Added
		
	);
end dma_mgt;
architecture structural of dma_mgt is

	component ref_design_scfifo
		generic(
			ADDR_WIDTH 					: integer := 8;
			DATA_WIDTH 					: integer := 32);
		port(	
			clk							: in  std_logic;
			rstn							: in  std_logic;
			srst							: in  std_logic;
			wrreq							: in  std_logic;
			wrdata						: in  std_logic_vector(DATA_WIDTH-1 downto 0);
			wrfreew	 					: out std_logic_vector(ADDR_WIDTH-1 downto 0);
			rdreq							: in  std_logic;
			rddata						: out std_logic_vector(DATA_WIDTH-1 downto 0);
			rdusedw	 					: out std_logic_vector(ADDR_WIDTH-1 downto 0)
		);	
	end component;	
	
	component dma_sg is	
		generic (	
			DATAPATH   	 				: integer := 64;
			DMASIZE      				: integer := 32
      );
		port (
			clk 							: in  std_logic;
			rstn 							: in  std_logic;
			srst 							: in  std_logic;
			app_sg_enable   			: in  std_logic;
			app_dma_regin				: in  std_logic_vector(127 downto 0);
			app_dma_param 				: in  std_logic_vector( 23 downto 0);
			app_dma_control			: in  std_logic_vector(  5 downto 0);
			app_sg_idle					: out std_logic;
			app_dma_wr					: out std_logic;
			app_dma_fifocnt			: in  std_logic_vector( 12 downto 0);
			dma_wr						: in  std_logic;
			dma_wrchannel				: in  std_logic;
			dma_wrdata					: in  std_logic_vector(DATAPATH-1 downto 0);
			dma_status	 				: in  std_logic_vector(  3 downto 0);
			dma_regout					: in  std_logic_vector(127 downto 0);
			dma_regin					: out std_logic_vector(127 downto 0);
			dma_param 					: out std_logic_vector( 23 downto 0);
			dma_control					: out std_logic_vector(  5 downto 0);
			dma_fifocnt    			: out std_logic_vector( 12 downto 0)
	    );
	end component;

	---------------------------------------------------------------

	-- Compute least significant address bit, according to datapath size:
	-- 32-bit : 2, 64-bit : 3 , 128-bit : 4, 256-bit : 5
	constant ADDR_LOW					: integer := 2 + (DATAPATH/64) - (DATAPATH/256);

   -- Register numbers
   constant DMA1_ADRL_REG_NUM 	: integer := 0;                                    	   -- GLIB - Modified
   constant DMA1_ADRH_REG_NUM 	: integer := 1;                                    	   -- GLIB - Modified
   constant DMA1_SIZE_REG_NUM 	: integer := 2;                                    	   -- GLIB - Modified
   constant DMA1_INFO_REG_NUM 	: integer := 3;                                    	   -- GLIB - Modified
   constant DMA2_ADRL_REG_NUM 	: integer := 4;                                    	   -- GLIB - Modified
   constant DMA2_ADRH_REG_NUM 	: integer := 5;                                    	   -- GLIB - Modified
   constant DMA2_SIZE_REG_NUM 	: integer := 6;                                    	   -- GLIB - Modified
   constant DMA2_INFO_REG_NUM 	: integer := 7;                                          -- GLIB - Modified

    -- Compute register data position in slv_dataout, according to datapath size
	constant DMA1_ADRL_REG_POS 	: integer := (DMA1_ADRL_REG_NUM mod (DATAPATH/32))*32;   -- GLIB - Modified
	constant DMA1_ADRH_REG_POS 	: integer := (DMA1_ADRH_REG_NUM mod (DATAPATH/32))*32;   -- GLIB - Modified
	constant DMA1_SIZE_REG_POS 	: integer := (DMA1_SIZE_REG_NUM mod (DATAPATH/32))*32;   -- GLIB - Modified
	constant DMA1_INFO_REG_POS 	: integer := (DMA1_INFO_REG_NUM mod (DATAPATH/32))*32;   -- GLIB - Modified
	constant DMA2_ADRL_REG_POS 	: integer := (DMA2_ADRL_REG_NUM mod (DATAPATH/32))*32;   -- GLIB - Modified
	constant DMA2_ADRH_REG_POS 	: integer := (DMA2_ADRH_REG_NUM mod (DATAPATH/32))*32;   -- GLIB - Modified
	constant DMA2_SIZE_REG_POS 	: integer := (DMA2_SIZE_REG_NUM mod (DATAPATH/32))*32;   -- GLIB - Modified
	constant DMA2_INFO_REG_POS 	: integer := (DMA2_INFO_REG_NUM mod (DATAPATH/32))*32;   -- GLIB - Modified

	---------------------------------------------------------------

	-- Attributes:																									-- GLIB - Added
	-- (To avoid signal trimming for Chipscope)															-- GLIB - Added
	attribute S											: string; 												-- GLIB - Added
																														-- GLIB - Added
	-- Dummy signals for Chipscope:                                                        -- GLIB - Added
	--																													-- GLIB - Added		
	-- (Note!!! Some signals are trimmed by XST so must be registered for being tapped     -- GLIB - Added
	-- with Chipscope. For that reason, all signals tapped with Chipscope are registered	-- GLIB - Added
	-- in order to have the same delay in all of them).												-- GLIB - Added
	--                																							-- GLIB - Added
	signal dma1_wrchannel_chsc					   : std_logic_vector (15 downto 0);            -- GLIB - Added
	attribute S	of dma1_wrchannel_chsc			: signal is "true";                          -- GLIB - Added
	signal dma1_wr_chsc						      : std_logic;                                 -- GLIB - Added
	attribute S	of dma1_wr_chsc				   : signal is "true";                          -- GLIB - Added
	signal dma1_wraddr_chsc						   : std_logic_vector (31 downto 0);            -- GLIB - Added
	attribute S	of dma1_wraddr_chsc				: signal is "true";                          -- GLIB - Added
	signal dma1_wrdata_chsc						   : std_logic_vector (63 downto 0);            -- GLIB - Added	
	attribute S	of dma1_wrdata_chsc				: signal is "true";                          -- GLIB - Added
	signal dma2_rdchannel_chsc						: std_logic_vector (15 downto 0);            -- GLIB - Added
	attribute S	of dma2_rdchannel_chsc			: signal is "true";                          -- GLIB - Added
	signal dma2_rd_chsc						      : std_logic;                                 -- GLIB - Added
	attribute S	of dma2_rd_chsc				   : signal is "true";                          -- GLIB - Added
	signal dma2_rdaddr_chsc						   : std_logic_vector (31 downto 0);            -- GLIB - Added
	attribute S	of dma2_rdaddr_chsc				: signal is "true";                          -- GLIB - Added
	signal dma2_rddata_int						   : std_logic_vector (63 downto 0);            -- GLIB - Added	
	signal dma2_rddata_chsc						   : std_logic_vector (63 downto 0);            -- GLIB - Added	
	attribute S	of dma2_rddata_chsc				: signal is "true";                          -- GLIB - Added 
   signal dma1_sg_idle_chsc            		: std_logic;                                 -- GLIB - Added
	attribute S	of dma1_sg_idle_chsc				: signal is "true";                          -- GLIB - Added        
   signal dma1_sg_idle_r_chsc            		: std_logic;                                 -- GLIB - Added
	attribute S	of dma1_sg_idle_r_chsc			: signal is "true";                          -- GLIB - Added        
   signal dma2_sg_idle_chsc            		: std_logic;                                 -- GLIB - Added
	attribute S	of dma2_sg_idle_chsc				: signal is "true";                          -- GLIB - Added        
   signal dma2_sg_idle_r_chsc            		: std_logic;                                 -- GLIB - Added 
	attribute S	of dma2_sg_idle_r_chsc			: signal is "true";                          -- GLIB - Added         
   
--	signal wr_fiforeq, rd_fiforeq					: std_logic;
--	signal wr_fifosize, rd_fifosize				: std_logic_vector(8-ADDR_LOW downto 0);     -- GLIB - Modified
	signal dma1_idle_r, dma2_idle_r 				: std_logic;                                 -- GLIB - Modified

	-- DMA demo mode signals:			
	signal dma1_addr, dma2_addr					: std_logic_vector(63 downto 0);	                  -- GLIB - Modified
	signal dma1_size, dma2_size					: std_logic_vector(31 downto 0);--(19 downto 0);   -- GLIB - Modified	
	signal dma1_start, dma2_start					: std_logic;                                       -- GLIB - Modified
	signal dma1_demo, dma2_demo					: std_logic;                                       -- GLIB - Modified
	signal dma1_run, dma2_run						: std_logic;                                       -- GLIB - Modified
	signal dma1_abort, dma2_abort					: std_logic;                                       -- GLIB - Modified
	signal dma1_count, dma2_count					: std_logic_vector(15 downto 0);                   -- GLIB - Modified
	signal dma1_dmaperf, dma2_dmaperf			: std_logic_vector(15 downto 0);                   -- GLIB - Modified
	signal timer										: std_logic_vector(24 downto 0);
--	signal fiforst										: std_logic;                                       -- GLIB - Modified

	-- Scatter-Gather Signals:
	signal dma1_regin_int,dma2_regin_int		: std_logic_vector(127 downto 0);            -- GLIB - Modified
	signal dma1_param_int,dma2_param_int		: std_logic_vector( 23 downto 0);            -- GLIB - Modified
	signal dma1_control_int,dma2_control_int	: std_logic_vector(  5 downto 0);            -- GLIB - Modified
	signal dma1_fifocnt_int, dma2_fifocnt_int	: std_logic_vector( 12 downto 0);            -- GLIB - Modified
	signal dma1_sgmode,dma2_sgmode				: std_logic;                                 -- GLIB - Modified
	signal dma1_wr_int								: std_logic;                                 -- GLIB - Modified
	signal dma1_sg_idle,dma1_sg_idle_r   		: std_logic;	                              -- GLIB - Modified
	signal dma2_sg_idle,dma2_sg_idle_r   		: std_logic;                                 -- GLIB - Modified

	signal ZERO                               : std_logic_vector(31 downto 0);
	
	signal dma1_local_address      				: std_logic_vector(31 downto 0);             -- GLIB - Added
	signal dma2_local_address      				: std_logic_vector(31 downto 0);             -- GLIB - Added
	
	
begin

	ZERO 													<= (others => '0');

	-- Dummy Registers for Chipscope:													               -- GLIB - Added
	process(clk, rstn)																		               -- GLIB - Added
   begin                                                 						               -- GLIB - Added
		if rstn = '0' then                                 						               -- GLIB - Added
         dma1_wrchannel_chsc				      <= (others => '0');  			               -- GLIB - Added 
         dma1_wr_chsc					         <= '0';  			                           -- GLIB - Added 	      
         dma1_wraddr_chsc					      <= (others => '0');  			               -- GLIB - Added 
         dma1_wrdata_chsc					      <= (others => '0');  			               -- GLIB - Added 
         dma2_rdchannel_chsc				      <= (others => '0');  			               -- GLIB - Added 
         dma2_rd_chsc			 		         <= '0';     	                              -- GLIB - Added 
         dma2_rdaddr_chsc					      <= (others => '0');  			               -- GLIB - Added 
         dma2_rddata_chsc					      <= (others => '0');  			               -- GLIB - Added 
         dma1_sg_idle_chsc   		            <= '0';                                      -- GLIB - Added
         dma1_sg_idle_r_chsc 		            <= '0';		                                 -- GLIB - Added
         dma2_sg_idle_chsc   		            <= '0';		                                 -- GLIB - Added
         dma2_sg_idle_r_chsc 		            <= '0';		                                 -- GLIB - Added   
		elsif rising_edge(clk) then                        						               -- GLIB - Added
         dma1_wrchannel_chsc	         	   <=  dma1_wrchannel;                          -- GLIB - Added	
         dma1_wr_chsc			               <=  dma1_wr;			                        -- GLIB - Added
         dma1_wraddr_chsc		         	   <=  dma1_wraddr;		                        -- GLIB - Added
         dma1_wrdata_chsc		         	   <=  dma1_wrdata;		                        -- GLIB - Added
         dma2_rdchannel_chsc	         	   <=  dma2_rdchannel;	                        -- GLIB - Added
         dma2_rd_chsc			               <=  dma2_rd;			                        -- GLIB - Added
         dma2_rdaddr_chsc		         	   <=  dma2_rdaddr;		                        -- GLIB - Added
         dma2_rddata_chsc		         	   <=  dma2_rddata_int;	                        -- GLIB - Added
         dma1_sg_idle_chsc                   <=  dma1_sg_idle;                            -- GLIB - Added
         dma1_sg_idle_r_chsc                 <=  dma1_sg_idle_r;                          -- GLIB - Added
         dma2_sg_idle_chsc                   <=  dma2_sg_idle;                            -- GLIB - Added 
         dma2_sg_idle_r_chsc                 <=  dma2_sg_idle_r;                          -- GLIB - Added
      end if;                                          							               -- GLIB - Added
   end process;                                        							               -- GLIB - Added
   
   
	--------------------------------------------------------------------------
	-- DMA registers & control
	--
	--------------------------------------------------------------------------

	process(clk, rstn)
	begin
		if rstn = '0' then
			dma1_addr 									<= (others => '0');                          -- GLIB - Modified
			dma1_size 									<= (others => '0');                          -- GLIB - Modified
			dma1_sg_idle_r 							<= '1';                                      -- GLIB - Modified
			dma1_run 									<= '0';                                      -- GLIB - Modified
			dma1_demo 									<= '0';                                      -- GLIB - Modified
			dma1_start 									<= '0';                                      -- GLIB - Modified
			dma2_addr 									<= (others => '0');                          -- GLIB - Modified
			dma2_size 									<= (others => '0');                          -- GLIB - Modified
			dma2_sg_idle_r 							<= '1';                                      -- GLIB - Modified
			dma2_run 									<= '0';                                      -- GLIB - Modified
			dma2_demo 									<= '0';                                      -- GLIB - Modified
			dma2_start 									<= '0';                                      -- GLIB - Modified
			dma_int_req 								<= '0';                                      -- GLIB - Modified
			dma1_sgmode									<= '0';                                      -- GLIB - Modified
			dma2_sgmode									<= '0';                                      -- GLIB - Modified
			dma1_abort									<= '0';                                      -- GLIB - Modified
			dma2_abort									<= '0';                                      -- GLIB - Modified
		elsif rising_edge(clk) then
			if srst = '1' then
				dma1_addr 								<= (others => '0');                          -- GLIB - Modified
				dma1_size 								<= (others => '0');                          -- GLIB - Modified
				dma1_sg_idle_r 						<= '1';                                      -- GLIB - Modified
				dma1_run 								<= '0';                                      -- GLIB - Modified
				dma1_demo 								<= '0';                                      -- GLIB - Modified
				dma1_start 								<= '0';                                      -- GLIB - Modified
				dma1_sgmode 							<= '0';                                      -- GLIB - Modified
				dma1_abort								<= '0';                                      -- GLIB - Modified
				dma2_addr 								<= (others => '0');                          -- GLIB - Modified
				dma2_size 								<= (others => '0');                          -- GLIB - Modified
				dma2_sg_idle_r 						<= '1';                                      -- GLIB - Modified
				dma2_run 								<= '0';                                      -- GLIB - Modified
				dma2_demo 								<= '0';                                      -- GLIB - Modified
				dma2_start 								<= '0';                                      -- GLIB - Modified
				dma2_sgmode 							<= '0';                                      -- GLIB - Modified
				dma2_abort 								<= '0';                                      -- GLIB - Modified
				dma_int_req 							<= '0';                                      -- GLIB - Modified
			else
				-- Store dma1 start address & size:                                                             -- GLIB - Modified
				if reg_write(DMA1_ADRL_REG_NUM) = '1' then                                                      -- GLIB - Modified
					dma1_addr(31 downto  0) <= reg_writedata(DMA1_ADRL_REG_POS+31 downto DMA1_ADRL_REG_POS);     -- GLIB - Modified
				end if;
				if reg_write(DMA1_ADRH_REG_NUM) = '1' then                                                      -- GLIB - Modified
					dma1_addr(63 downto 32) <= reg_writedata(DMA1_ADRH_REG_POS+31 downto DMA1_ADRH_REG_POS);     -- GLIB - Modified
				end if;

--				-- Size can be up to 512KB:                                                                     -- GLIB - Modified
--				if reg_write(DMA1_SIZE_REG_NUM) = '1' then                                                      -- GLIB - Modified
--					dma1_size <= reg_writedata(DMA1_SIZE_REG_POS+19 downto DMA1_SIZE_REG_POS);                   -- GLIB - Modified
--				end if;                                                                                         -- GLIB - Modified
                                                                                                            -- GLIB - Modified
            -- GLIB - With this modification it is possible to perform transations up to 4GB                -- GLIB - Modified        
				if reg_write(DMA1_SIZE_REG_NUM) = '1' then                                                      -- GLIB - Modified
					dma1_size <= reg_writedata(DMA1_SIZE_REG_POS+31 downto DMA1_SIZE_REG_POS);                   -- GLIB - Modified
				end if;				                                                                              -- GLIB - Modified

				-- A rising edge on dma1_sg_idle indicates end of DMA:                                          -- GLIB - Modified
				dma1_sg_idle_r 						<= dma1_sg_idle;                                               -- GLIB - Modified

				if reg_write(DMA1_INFO_REG_NUM) = '1' then                                                      -- GLIB - Modified
					-- DMA1 is started or aborted:
					dma1_demo 							<= dma1_demo or reg_writedata(DMA1_INFO_REG_POS+1);            -- GLIB - Modified
					
					if int_request = '0' then 																	                  -- GLIB - Modified
						dma1_start 						<= reg_writedata(DMA1_INFO_REG_POS+2); 		                  -- GLIB - Modified
						dma1_run 						<= reg_writedata(DMA1_INFO_REG_POS+2);			                  -- GLIB - Modified
					end if;																							                  -- GLIB - Modified
                                                                                                            -- GLIB - Modified
					dma1_abort 							<= reg_writedata(DMA1_INFO_REG_POS+3);                         -- GLIB - Modified
					dma1_sgmode 						<= reg_writedata(DMA1_INFO_REG_POS+4);                         -- GLIB - Modified
				elsif dma1_sg_idle_r = '0' and dma1_sg_idle = '1' then                                          -- GLIB - Modified
					-- DMA1 is finished:                                                                         -- GLIB - Modified					
               if dma1_run = '1' and dma1_demo = '1' and dma1_status = "0000" then	                        -- GLIB - Modified	
						-- Start a new transfer if in demo mode and last transfer was succesful:                  -- GLIB - Modified
						dma1_start 						<= '1';                                                        -- GLIB - Modified
					else                                                                                         -- GLIB - Modified
						dma1_demo 						<= '0';                                                        -- GLIB - Modified
						dma1_run 						<= '0';                                                        -- GLIB - Modified
					end if;                                                                                      -- GLIB - Modified
				else                                                                                            -- GLIB - Modified
					dma1_start 							<= '0';                                                        -- GLIB - Modified
					dma1_abort 							<= '0';                                                        -- GLIB - Modified
				end if;				                                                                              -- GLIB - Modified
                                                                  
				-- Store dma2 start address & size:                                                             -- GLIB - Modified          
				if reg_write(DMA2_ADRL_REG_NUM) = '1' then                                                      -- GLIB - Modified
					dma2_addr(31 downto  0) <=reg_writedata(DMA2_ADRL_REG_POS+31 downto DMA2_ADRL_REG_POS);      -- GLIB - Modified
				end if;                                                                                         -- GLIB - Modified
				if reg_write(DMA2_ADRH_REG_NUM)='1' then                                                        -- GLIB - Modified
					dma2_addr(63 downto 32) <=reg_writedata(DMA2_ADRH_REG_POS+31 downto DMA2_ADRH_REG_POS);      -- GLIB - Modified
				end if;                                                                                         -- GLIB - Modified        

--				-- Size can be up to 512KB:                                                               -- GLIB - Modified
--				if reg_write(DMA2_SIZE_REG_NUM) = '1' then                                                -- GLIB - Modified
--					dma2_size <= reg_writedata(DMA2_SIZE_REG_POS+19 downto DMA2_SIZE_REG_POS);             -- GLIB - Modified
--				end if;                                                                                   -- GLIB - Modified
                                                                                                      -- GLIB - Modified
            -- GLIB - With this modification it is possible to perform transations up to 4GB          -- GLIB - Modified        
				if reg_write(DMA2_SIZE_REG_NUM) = '1' then                                                -- GLIB - Modified
					dma2_size <= reg_writedata(DMA2_SIZE_REG_POS+31 downto DMA2_SIZE_REG_POS);             -- GLIB - Modified
				end if;				                                                                        -- GLIB - Modified
   
				-- A rising edge on dma2_sg_idle indicates end of DMA:                                    -- GLIB - Modified
				dma2_sg_idle_r 						<= dma2_sg_idle;                                         -- GLIB - Modified
   
				if reg_write(DMA2_INFO_REG_NUM) = '1' then                                                -- GLIB - Modified
					-- DMA2 is started or aborted:                                                         -- GLIB - Modified
               dma2_demo 							<= dma2_demo or reg_writedata(DMA2_INFO_REG_POS+1);      -- GLIB - Modified
                  
					if int_request = '0' then																	            -- GLIB - Modified
						dma2_start 						<= reg_writedata(DMA2_INFO_REG_POS+2);	 		            -- GLIB - Modified
						dma2_run 						<= reg_writedata(DMA2_INFO_REG_POS+2); 		            -- GLIB - Modified
					end if;                                                                 	            -- GLIB - Modified
                  
					dma2_abort 							<= reg_writedata(DMA2_INFO_REG_POS+3);                -- GLIB - Modified
					dma2_sgmode 						<= reg_writedata(DMA2_INFO_REG_POS+4);                -- GLIB - Modified
				elsif dma2_sg_idle_r = '0' and dma2_sg_idle = '1' then                                 -- GLIB - Modified
					-- DMA2 is finished:                                                                -- GLIB - Modified
					if dma2_run = '1' and dma2_demo = '1' and dma2_status = "0000" then	               -- GLIB - Modified
						-- Start a new transfer if in demo mode and last transfer was succesful:         -- GLIB - Modified
						dma2_start 						<= '1';                                               -- GLIB - Modified
					else                                                                                -- GLIB - Modified
						dma2_demo 						<= '0';                                               -- GLIB - Modified
						dma2_run 						<= '0';                                               -- GLIB - Modified
					end if;                                                                             -- GLIB - Modified
				else                                                                                   -- GLIB - Modified
					dma2_start 							<= '0';                                               -- GLIB - Modified
					dma2_abort 							<= '0';                                               -- GLIB - Modified
				end if;  
               
--				-- Issue an interrupt when dma2 is finished:											            -- GLIB - Modified		
--				if dma2_demo = '0' and dma2_sg_idle_r = '0' and dma2_sg_idle = '1' then	               -- GLIB - Modified
--					dma_int_req 						<= '1';											               -- GLIB - Modified
--				else																							               -- GLIB - Modified
--					dma_int_req 						<= '0';											               -- GLIB - Modified
--				end if;                                                                                -- GLIB - Modified
                                                                                                   -- GLIB - Modified
            dma_int_req 		   				<= '0';												            -- GLIB - Modified
				if int_request = '0' then																		         -- GLIB - Modified
					if (dma1_demo = '0' and (dma1_sg_idle_r = '0' and dma1_sg_idle = '1')) or	         -- GLIB - Modified
					   (dma2_demo = '0' and (dma2_sg_idle_r = '0' and dma2_sg_idle = '1'))		         -- GLIB - Modified
					then																								         -- GLIB - Modified								
						dma_int_req 					<= '1';	   											         -- GLIB - Modified						
					end if;																							         -- GLIB - Modified				
				end if;
				
			end if;	
		end if;
	end process;

	--------------------------------------------------------------------------
	-- Monitor DMA performance
	-- This module counts number of DMA transfers finished per millisecond
	--------------------------------------------------------------------------

	-- Note!!! Use Demo mode for the performance test (DMAs run continuously)                       -- GLIB - Modified

	process(clk, rstn)
	begin
		if rstn = '0' then
			timer 										<= (others => '0');
			dma1_count 									<= (others => '0');                                   -- GLIB - Modified
			dma2_count 									<= (others => '0');                                   -- GLIB - Modified
			dma1_dmaperf 								<= (others => '0');                                   -- GLIB - Modified
			dma2_dmaperf 								<= (others => '0');                                   -- GLIB - Modified
		elsif rising_edge(clk) then
			if srst = '1' then
				timer 									<= (others => '0');                                   -- GLIB - Modified
				dma1_count 								<= (others => '0');                                   -- GLIB - Modified
				dma2_count 								<= (others => '0');                                   -- GLIB - Modified
				dma1_dmaperf 							<= (others => '0');                                   -- GLIB - Modified
				dma2_dmaperf 							<= (others => '0');                                   -- GLIB - Modified
			else
				-- Count 50ms period:
				if ((timer(21+(CORE_FREQ/125) downto 20+(CORE_FREQ/125)) = "11") and clk_doubled = '0')
					or ((timer(22+(CORE_FREQ/125) downto 21+(CORE_FREQ/125)) = "11") and clk_doubled = '1')then
					timer 								<= (others => '0');
					dma1_count 							<= (others => '0');                                   -- GLIB - Modified
					dma2_count 							<= (others => '0');                                   -- GLIB - Modified
					dma1_dmaperf 						<= dma1_count;                                        -- GLIB - Modified
					dma2_dmaperf 						<= dma2_count;                                        -- GLIB - Modified
				else                                                                      
					
					timer 								<= unsigned(timer) + '1';
					
					-- Count how many DMA transfers have been finished during this period:
					if dma1_sg_idle_r = '0' and dma1_sg_idle = '1' then                                 -- GLIB - Modified
						dma1_count 						<= unsigned(dma1_count) + '1';                        -- GLIB - Modified
					end if;                                                                             -- GLIB - Modified
					if dma2_sg_idle_r = '0' and dma2_sg_idle = '1' then                                 -- GLIB - Modified
						dma2_count 						<= unsigned(dma2_count) + '1';                        -- GLIB - Modified
					end if;                                                     
					                                                            
				end if;                                                        
			end if;
		end if;
	end process;

	-- Assemble DMA information registers
	dma1_info_reg <=dma1_dmaperf & "0000" & dma1_status & "000" & dma1_sgmode & '0' & dma1_run & dma1_demo & '0';  -- GLIB - Modified
	dma2_info_reg <=dma2_dmaperf & "0000" & dma2_status & "000" & dma2_sgmode & '0' & dma2_run & dma2_demo & '0';  -- GLIB - Modified

	--------------------------------------------------------------------------
	-- DMA1                                                                                         -- GLIB - Modified
	-- Read from PCIExpress and write to GLIB.                                                      -- GLIB - Modified
	--------------------------------------------------------------------------

	-- Set DMA registers:
--	dma1_regin_int 									<= ZERO & x"000" & dma1_size & dma1_addr;			-- GLIB - Modified	
	                                                                                          -- GLIB - Modified
	dma1_local_address								<= (others => '0');                             -- GLIB - Modified
	dma1_regin_int 									<= dma1_local_address & dma1_size & dma1_addr;	-- GLIB - Modified


	-- Set DMA parameters:
		-- Attributes,TC,reserved bits:
		dma1_param_int(23 downto 12) 				<= x"000";                                      -- GLIB - Modified
		-- MemRd command:                                                                
		dma1_param_int(11 downto 8)  				<= "0110";                                      -- GLIB - Modified
		-- No byte-enables:                                               
		dma1_param_int(7 downto 4)   				<= "0000";		                                 -- GLIB - Modified
--		-- Latency is 0; use RAM-mode in DMA demo mode, FIFO-mode otherwise		               -- GLIB - Modified
--		dma1_param_int(3 downto 0)   				<= "000" & dma1_demo;				               -- GLIB - Modified
                                                                                             -- GLIB - Modified
		-- Latency is 0; RAM-mode																               -- GLIB - Modified
		dma1_param_int(3 downto 0)   				<= "00" & "0" & '1'; 				               -- GLIB - Modified
		-- Latency is 0; FIFO-mode																               -- GLIB - Modified
--		dma1_param_int(3 downto 0)   				<= "00" & "0" & '0'; 				               -- GLIB - Modified


	
	-- Program & start DMA (local address is not used, so corresponding registers are not written)    -- GLIB - Modified
	dma1_control_int 									<= "100000" 	when dma1_abort = '1' else               -- GLIB - Modified
																"010111"		when dma1_start = '1' else               -- GLIB - Modified
																"000000";                                               
    
	-- Compute how bytes of data are free in FIFO:	                                          
	-- (Each data word is 4..32 bytes depending on datapath)	                                 
	--                                                                                                                   -- GLIB - Modified
	-- (Note!!!  Not used in RAM-mode)                                                                                   -- GLIB - Modified                                                                    
	dma1_fifocnt_int 									<= (others => '0');	--"0000" & wr_fifosize & ZERO(ADDR_LOW-1 downto 0);   -- GLIB - Modified
--	dma1_fifocnt_int									<= "1000000000000";	-- (4096 Bytes)                                       -- GLIB - Modified
																						--	(FIFO is always able to provide data)	            -- GLIB - Modified


   -- Scatter-gather controller for DMA1:
	dma1_sg: dma_sg
		generic map(
			DATAPATH										=> DATAPATH,
			DMASIZE										=> 20)
		port map(
			clk		        							=> clk,
			rstn	        								=> rstn,
			srst	        								=> srst,
							
			app_sg_enable   							=> dma1_sgmode,                        -- GLIB - Modified
			app_dma_regin								=> dma1_regin_int,                     -- GLIB - Modified
			app_dma_param								=> dma1_param_int,                     -- GLIB - Modified
			app_dma_control							=> dma1_control_int,                   -- GLIB - Modified
			app_sg_idle									=> dma1_sg_idle,                       -- GLIB - Modified
			app_dma_wr									=> dma1_wr_int,                        -- GLIB - Modified
			app_dma_fifocnt 							=> dma1_fifocnt_int,                   -- GLIB - Modified
                                                                                 
			dma_wr										=> dma1_wr,                            -- GLIB - Modified
			dma_wrchannel								=> dma1_wrchannel(1),                  -- GLIB - Modified
			dma_wrdata									=> dma1_wrdata,                        -- GLIB - Modified
			dma_status									=> dma1_status,                        -- GLIB - Modified
			dma_regout									=> dma1_regout,                        -- GLIB - Modified
			dma_regin									=> dma1_regin,                         -- GLIB - Modified
			dma_param									=> dma1_param,                         -- GLIB - Modified
			dma_control									=> dma1_control,                       -- GLIB - Modified
			dma_fifocnt									=> dma1_fifocnt                        -- GLIB - Modified
	);

	--------------------------------------------------------------------------
	-- DMA2                                                                          -- GLIB - Modified
	-- Read from GLIB and write to PCIExpress.                                       -- GLIB - Modified
	--------------------------------------------------------------------------

	-- Set DMA registers:
--	dma2_regin_int 									<= ZERO & x"000" & dma2_size & dma2_addr;			-- GLIB - Modified	
                                                                                             -- GLIB - Modified
	dma2_local_address								<= (others => '0');	                           -- GLIB - Modified
	dma2_regin_int 									<= dma2_local_address & dma2_size & dma2_addr;  -- GLIB - Modified
	
	-- DMA parameters:
		-- Attributes,TC,reserved bits:
		dma2_param_int(23 downto 12) 				<=x"000";                                       -- GLIB - Modified
		-- MemWr command:				                           
		dma2_param_int(11 downto 8)  				<="0111";                                       -- GLIB - Modified
		-- no byte-enables:				                                 
		dma2_param_int(7 downto 4)   				<="0000";                                       -- GLIB - Modified
--		-- Latency is 0; use RAM-mode in DMA demo mode, FIFO-mode otherwise		               -- GLIB - Modified
--		dma2_param_int(3 downto 0)   				<= "000" & dma2_demo;				               -- GLIB - Modified
                                                                                             -- GLIB - Modified
		-- Latency is 1; RAM-mode																               -- GLIB - Modified
		dma2_param_int(3 downto 0)   				<= "01" & "0" & '1'; 				               -- GLIB - Modified 
		-- Latency is 1; FIFO-mode																               -- GLIB - Modified
--		dma2_param_int(3 downto 0)   				<= "01" & "0" & '0'; 				               -- GLIB - Modified 



	-- Program & start DMA (local address is not used, so corresponding registers are not written):
	dma2_control_int 									<= "100000" when dma2_abort = '1' else          -- GLIB - Modified
																"010111" when dma2_start = '1' else          -- GLIB - Modified
																"000000";

	-- Compute how bytes of data are available in FIFO:
	-- (Each data word is 4..32 bytes depending on datapath)
	--                                                                                                                   -- GLIB - Modified
	-- (Note!!!  Not used in RAM-mode)                                                                                   -- GLIB - Modified
	dma2_fifocnt_int 									<= (others => '0');--"0000" & rd_fifosize & ZERO(ADDR_LOW-1 downto 0);     -- GLIB - Modified
--	dma2_fifocnt_int									<= "1000000000000";	-- (4096 Bytes)                                       -- GLIB - Modified
																						--	(FIFO is always able to provide data)	            -- GLIB - Modified

   -- Scatter-gather controller for DMA2:
	dma2_sg: dma_sg
		generic map (
			DMASIZE										=> 20,
			DATAPATH										=> DATAPATH)
		port map (				
			clk		        							=> clk,
			rstn	        								=> rstn,
			srst	        								=> srst,
					
			app_sg_enable  	 						=> dma2_sgmode,                              -- GLIB - Modified
			app_dma_regin								=> dma2_regin_int,                           -- GLIB - Modified
			app_dma_param								=> dma2_param_int,                           -- GLIB - Modified
			app_dma_control							=> dma2_control_int,                         -- GLIB - Modified
			app_sg_idle									=> dma2_sg_idle,                             -- GLIB - Modified
			app_dma_wr									=> open,                                     
			app_dma_fifocnt 							=> dma2_fifocnt_int,                         -- GLIB - Modified
                                                                                       
			dma_wr										=> dma2_wr,                                  -- GLIB - Modified
			dma_wrchannel								=> dma2_wrchannel(2),                        -- GLIB - Modified
			dma_wrdata									=> dma2_wrdata,                              -- GLIB - Modified
			dma_status									=> dma2_status,                              -- GLIB - Modified
			dma_regout									=> dma2_regout,                              -- GLIB - Modified
			dma_regin									=> dma2_regin,                               -- GLIB - Modified
			dma_param									=> dma2_param,                               -- GLIB - Modified
			dma_control									=> dma2_control,                             -- GLIB - Modified
			dma_fifocnt									=> dma2_fifocnt                              -- GLIB - Modified
		);


	--------------------------------------------------------------------------
	-- 512 bytes FIFO
	--------------------------------------------------------------------------

--	-- FIFO read and write requests (FIFO is not used in DMA demo mode):                                  -- GLIB - Modified
--	wr_fiforeq <= '1' when dma1_wrchannel(1) = '1' and dma1_wr_int = '1' and dma1_demo = '0' else '0';    -- GLIB - Modified
--	rd_fiforeq <= '1' when dma2_rdchannel(2) = '1' and dma2_rd = '1' and dma2_demo = '0' else '0';        -- GLIB - Modified
--                                                                                                       -- GLIB - Modified
--	-- Reset FIFO when DMA is aborted:                                                  -- GLIB - Modified
--	fiforst 												<= srst or dma1_abort or dma2_abort;      -- GLIB - Modified
--                                                                                     -- GLIB - Modified
--	fifo: ref_design_scfifo                                                             -- GLIB - Modified
--		generic map (                                                                    -- GLIB - Modified
--			ADDR_WIDTH 									=> (9-ADDR_LOW),                          -- GLIB - Modified
--			DATA_WIDTH 									=> DATAPATH)                              -- GLIB - Modified
--		port map(                                                                        -- GLIB - Modified
--			clk											=> clk,                                   -- GLIB - Modified
--			rstn											=> rstn,                                  -- GLIB - Modified                             
--			srst											=> fiforst,                               -- GLIB - Modified
--			wrreq											=> wr_fiforeq,                            -- GLIB - Modified
--			wrdata										=> dma1_wrdata,                           -- GLIB - Modified
--			wrfreew										=> wr_fifosize,                           -- GLIB - Modified
--			rdreq											=> rd_fiforeq,                            -- GLIB - Modified
--			rddata										=> dma2_rddata,                           -- GLIB - Modified
--			rdusedw										=> rd_fifosize                            -- GLIB - Modified
--		);                                                                               -- GLIB - Modified
                                                                                       -- GLIB - Modified
		ber: entity work.pcie_ber_wrapper                                                -- GLIB - Modified
			port map (																			            -- GLIB - Modified
				RESET_I 									=> (not rstn) or BER_I.reset,             -- GLIB - Modified
				DMA_CLK_I 								=> clk,              			            -- GLIB - Modified
				DMA_RDCHANNEL_I 						=> dma2_rdchannel(7 downto 0),            -- GLIB - Modified
				DMA_RDTRANS_SIZE_I			      => dma2_size,                             -- GLIB - Modified
            DMA_RDSTATUS_I					      => dma2_status,                           -- GLIB - Modified
            DMA_RD_I 								=> dma2_rd,         				            -- GLIB - Modified
				DMA_RDADDR_I 							=> dma2_rdaddr,     				            -- GLIB - Modified
				DMA_RDDATA_O 							=> dma2_rddata_int,    			            -- GLIB - Modified
				DMA_WRCHANNEL_I 						=> dma1_wrchannel(7 downto 0),            -- GLIB - Modified
				DMA_WRTRANS_SIZE_I   		      => dma1_size,                             -- GLIB - Modified 
            DMA_WRSTATUS_I		   		      => dma1_status,                           -- GLIB - Modified
            DMA_WR_I 								=> dma1_wr_int,      			            -- GLIB - Modified
				DMA_WRADDR_I 							=> dma1_wraddr,      			            -- GLIB - Modified
				DMA_WRDATA_I 							=> dma1_wrdata,      			            -- GLIB - Modified
				BER_RESET_I 							=> BER_I.cntrReset,				            -- GLIB - Modified
            BER_2DW_CNTR_O			            => BER_O.doubleDWcntr,	                  -- GLIB - Modified
				BER_ERROR_CNTR_O 						=> BER_O.error_cntr,				            -- GLIB - Modified
				BER_ERROR_FLAG_O 						=> BER_O.error_flag,				            -- GLIB - Modified
				BER_NOERR_FLAG_O 						=> BER_O.noerr_flag 				            -- GLIB - Modified
			);												                     		               -- GLIB - Modified
         dma2_rddata                         <= dma2_rddata_int;  		               -- GLIB - Modified

end structural;