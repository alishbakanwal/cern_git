--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   10/07/2012		 																			
-- Project Name:			pcie_glib																					
-- Module Name:   		ezdma2_ipbus_int						 													
-- 																															
-- Language:				VHDL'93																						
--																																
-- Target Devices: 		GLIB (Virtex 6)																			
-- Tool versions: 		13.2																							
--																																
-- Revision:		 		1.0 																							
--																																
-- Additional Comments: 																								
--																																
-- * Supported Transactions: Memory Read/Memory Write (DW or Burst)										
--																																
-- * Data is sent/received by PCIe trough 64 bit data frames as shown below:							
--																																
--	  [32bit data1][32bit data0]																						
--	  [32bit data3][32bit data2]																						
--   [32bit data4][xxxxxxxxxxx]																						
--																																
--	* Note!!! Address must be DW-aligned (Bits [1:0] are discarded)										
--																																
--=================================================================================================--
--=================================================================================================--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
-- Custom libraries and packages:
use work.ipbus.all;
use work.system_pcie_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity ezdma2_ipbus_int is	
	port (
		-- General reset and clocks:
		RESET_I									: in  std_logic;
		PCIE_CLK_I								: in  std_logic;
		IPBUS_CLK_I								: in  std_logic;
		-- EZDMA2 Configuration interface:					
	   CFG_LTSSM_I								: in  std_logic_vector(  4 downto 0);
	   CFG_LINKCSR_I 							: in  std_logic_vector( 31 downto 0);
		-- Slave interface				
	   SLV_I 									: in  R_slv_from_ezdma2; 
	   SLV_O 									: out R_slv_to_ezdma2; 	
		-- General DMA:		   			                         
	   GDMA_I									: in  R_gDma_from_ezdma2; 
		GDMA_O  	 								: out R_gDma_to_ezdma2; 		
		-- DMA0: 				
	   DMA0_I									: in  R_dma_from_ezdma2; 
		DMA0_O 									: out R_dma_to_ezdma2; 	
		-- IPbus:				
		IPBUS_I 									: in  ipb_rbus;
      IPBUS_O									: out ipb_wbus;
	   -- Status:				
		RETRAINING_CNT_O						: out std_logic_vector(  7 downto 0);
		LINK_RDY_O								: out std_logic;    		
		BUSY_O									: out std_logic		
--		IPBUS_ERROR_O							: out std_logic;
--		IPBUS_TIMEOUT_O						: out std_logic	
	);
end ezdma2_ipbus_int;
architecture structural of ezdma2_ipbus_int is
	--============================ Declarations ===========================--	
	-- PCIe to IPbus address encoder:
	signal ipbusAddr_from_addrEnc			: std_logic_vector(31 downto 0);	
	-- EZDMA2:
	signal ezdma2_busy						: std_logic;
	signal slave_wr_from_ezdma2			: std_logic;
	signal slave_rd_from_ezdma2			: std_logic;
	signal dwcount_from_ezdma2				: std_logic_vector(10 downto 0);
	signal ipbus_addr_from_ezdma2			: std_logic_vector(31 downto 0);		
	signal ipbus_busy_to_ezdma2			: std_logic;
	signal ipbus_error_to_ezdma2			: std_logic;
	signal ipbus_timeout_to_ezdma2		: std_logic;
	signal wr_fifo_we_from_ezdma2			: std_logic;
	signal wr_fifo_data_from_ezdma2		: std_logic_vector(63 downto 0);
	signal rd_ipbus_rdy_to_ezdma2			: std_logic;
	signal rd_fifo_empty_to_ezdma2		: std_logic;
	signal rd_fifo_re_from_ezdma2			: std_logic;
	signal rd_fifo_data_to_ezdma2			: std_logic_vector(63 downto 0);			
	-- IPbus:	
	signal ipbus_busy							: std_logic;
	signal ipbus_error_from_ipbus			: std_logic;
	signal ipbus_timeout_from_ipbus		: std_logic;
	signal slave_wr_to_ipbus				: std_logic;
	signal slave_rd_to_ipbus				: std_logic;
	signal dwcount_to_ipbus					: std_logic_vector(10 downto 0);
	signal ipbus_addr_to_ipbus				: std_logic_vector(31 downto 0);
	signal wr_fifo_empty_to_ipbus			: std_logic;
	signal wr_fifo_re_from_ipbus			: std_logic;
	signal wr_fifo_data_to_ipbus			: std_logic_vector(63 downto 0);
	signal rd_fifo_we_from_ipbus			: std_logic;
	signal rd_fifo_data_from_ipbus		: std_logic_vector(63 downto 0);		
	signal rd_ipbus_rdy_from_ipbus		: std_logic;	
	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--		
	--========================= Port Assignments ==========================--	
--	IPBUS_ERROR_O								<= ipbus_error_to_ezdma2;
--	IPBUS_TIMEOUT_O							<= ipbus_timeout_to_ezdma2;	
	--=====================================================================--		
	--=========================== User Logic ==============================--
	-- Busy OR gate:
	BUSY_O										<= ezdma2_busy or ipbus_busy; 	
	--=====================================================================--
	--===================== Component Instantiations ======================--	
	-- EZDMA2 interface:
	ezdma2_int:	entity work.ezdma2_ipbus_int_ezdma2
		port map (
			-- General reset and clocks:
			RESET_I 								=> RESET_I,
			PCIE_CLK_I 							=> PCIE_CLK_I,			
			-- EZDMA2:			
			CFG_LTSSM_I							=> CFG_LTSSM_I,	
			CFG_LINKCSR_I 						=> CFG_LINKCSR_I,
			-- Status:	
			RETRAINING_CNT_O					=> RETRAINING_CNT_O,	
			LINK_RDY_O							=> LINK_RDY_O,		
			BUSY_O								=> ezdma2_busy,						
			-- Slave interface:	
			SLV_BAR_I 							=> SLV_I.bar,			
			SLV_ADDR_I							=> SLV_I.addr,		
			SLV_READREQ_I 						=> SLV_I.readreq,
			SLV_WRITEREQ_I						=> SLV_I.writereq,
			SLV_BYTECOUNT_I					=> SLV_I.bytecount,
			SLV_DWCOUNT_I 						=> SLV_I.dwcount,
			SLV_WRITE_I 						=> SLV_I.wr,
			SLV_DATAOUT_I 						=> SLV_I.dataout,			
			SLV_CPLADDR_I 						=> SLV_I.cpladdr,
			SLV_CPLPARAM_I 					=> SLV_I.cplparam,
			SLV_ACCEPT_O 						=> SLV_O.accept,
			SLV_ABORT_O 						=> SLV_O.abort,
			SLV_UR_O 							=> SLV_O.ur,
			-- General DMA:				
			DMA_RD_I 							=> GDMA_I.rd,
			DMA_RDCHANNEL_I					=> GDMA_I.rdchannel,
			DMA_RDDATA_O 						=> GDMA_O.rddata,			
			-- DMA0:
			DMA0_REGIN_O 						=> DMA0_O.regin,
			DMA0_PARAM_O 						=> DMA0_O.param,
			DMA0_CONTROL_O 					=> DMA0_O.control,
			DMA0_STATUS_I 						=> DMA0_I.status,
			DMA0_FIFOCNT_O 					=> DMA0_O.fifocnt,	
			-- Ports from/to IPbus clock domain:
			CDC_SLAVE_WR_O						=> slave_wr_from_ezdma2,
			CDC_SLAVE_RD_O						=> slave_rd_from_ezdma2,
			CDC_DWCOUNT_O 						=> dwcount_from_ezdma2,
			CDC_IPBUS_ADDR_O 					=> ipbus_addr_from_ezdma2,			
			CDC_IPBUS_BUSY_I 					=> ipbus_busy_to_ezdma2,
			CDC_IPBUS_ERROR_I					=> ipbus_error_to_ezdma2,
			CDC_IPBUS_TIMEOUT_I				=> ipbus_timeout_to_ezdma2,			
			CDC_WR_FIFO_WE_O 					=> wr_fifo_we_from_ezdma2,
			CDC_SLV_DATAOUT_O 				=> wr_fifo_data_from_ezdma2,
			CDC_RD_IPBUS_RDY_I				=> rd_ipbus_rdy_to_ezdma2,
			CDC_RD_FIFO_EMPTY_I				=> rd_fifo_empty_to_ezdma2,
			CDC_RD_FIFO_RE_O					=> rd_fifo_re_from_ezdma2,
			CDC_RD_FIFO_DATA_I				=>	rd_fifo_data_to_ezdma2			
		);
	
	-- Clock Domain Crossing module:
	cdc_module: entity work.ezdma2_ipbus_int_cdc
		port map (
			-- General reset and clocks:
			RESET_I 								=> RESET_I,
			PCIE_CLK_I 							=> PCIE_CLK_I,
			IPBUS_CLK_I 						=> IPBUS_CLK_I,
			-- Control DPRAM:					 
			EZDMA2_SLAVE_WR_I					=> slave_wr_from_ezdma2,		 
			EZDMA2_SLAVE_RD_I					=> slave_rd_from_ezdma2,		 
			EZDMA2_DWCOUNT_I 					=> dwcount_from_ezdma2, 		 
			EZDMA2_IPBUS_ADDR_I 				=> ipbus_addr_from_ezdma2, 	 
			EZDMA2_IPBUS_BUSY_O 				=> ipbus_busy_to_ezdma2,		
			EZDMA2_IPBUS_ERROR_O				=> ipbus_error_to_ezdma2,
			EZDMA2_IPBUS_TIMEOUT_O			=> ipbus_timeout_to_ezdma2,
			EZDMA2_RD_IPBUS_RDY_O			=> rd_ipbus_rdy_to_ezdma2,			
			IPBUS_SLAVE_WR_O					=> slave_wr_to_ipbus,
			IPBUS_SLAVE_RD_O					=> slave_rd_to_ipbus,
			IPBUS_DWCOUNT_O 					=> dwcount_to_ipbus,
			IPBUS_IPBUS_ADDR_O 				=> ipbus_addr_to_ipbus,			
			IPBUS_IPBUS_BUSY_I 				=> ipbus_busy,	
			IPBUS_IPBUS_ERROR_I				=> ipbus_error_from_ipbus,
			IPBUS_IPBUS_TIMEOUT_I			=> ipbus_timeout_from_ipbus,
			IPBUS_RD_IPBUS_RDY_I 			=> rd_ipbus_rdy_from_ipbus,			
			-- Slave Write FIFO:	
			EZDMA2_WR_FIFO_WE_I 				=> wr_fifo_we_from_ezdma2,
			EZDMA2_WR_FIFO_DATA_I 			=> wr_fifo_data_from_ezdma2,
			IPBUS_WR_FIFO_EMPTY_O 			=> wr_fifo_empty_to_ipbus,
			IPBUS_WR_FIFO_RE_I 				=> wr_fifo_re_from_ipbus,
			IPBUS_WR_FIFO_DATA_O 			=> wr_fifo_data_to_ipbus,
			-- Slave Read FIFO:	
			IPBUS_RD_FIFO_WE_I 				=> rd_fifo_we_from_ipbus,
			IPBUS_RD_FIFO_DATA_I 			=> rd_fifo_data_from_ipbus,
			EZDMA2_RD_FIFO_EMPTY_O			=> rd_fifo_empty_to_ezdma2,
			EZDMA2_RD_FIFO_RE_I 				=> rd_fifo_re_from_ezdma2,
			EZDMA2_RD_FIFO_DATA_O	 		=> rd_fifo_data_to_ezdma2			
		);

	-- IPbus interface:
	ipbus_int: entity work.ezdma2_ipbus_int_ipbus
		port map (
			-- General reset and clock:
			RESET_I 								=> RESET_I,
			IPBUS_CLK_I 						=> IPBUS_CLK_I,
			-- Status:	
			BUSY_O 								=> ipbus_busy,			
			-- Ports from/to PCIe clock domain:		
			CDC_IPBUS_ERROR_O					=> ipbus_error_from_ipbus,
			CDC_IPBUS_TIMEOUT_O				=> ipbus_timeout_from_ipbus,
			CDC_SLAVE_WR_I 					=> slave_wr_to_ipbus,
			CDC_SLAVE_RD_I 					=> slave_rd_to_ipbus,			
			CDC_DWCOUNT_I 						=> dwcount_to_ipbus,
			CDC_IPBUS_ADDR_I 					=> ipbus_addr_to_ipbus,
			CDC_WR_FIFO_EMPTY_I 				=> wr_fifo_empty_to_ipbus,
			CDC_WR_FIFO_RE_O 					=> wr_fifo_re_from_ipbus,
			CDC_WR_FIFO_DATA_I 				=> wr_fifo_data_to_ipbus,
			CDC_RD_FIFO_WE_O 					=> rd_fifo_we_from_ipbus,
			CDC_RD_FIFO_DATA_O 				=> rd_fifo_data_from_ipbus,
			CDC_RD_IPBUS_RDY_O				=> rd_ipbus_rdy_from_ipbus,			
			-- IPbus:	
			IPBUS_I								=> IPBUS_I,
			IPBUS_O 								=>	IPBUS_O		
		);
	--=====================================================================--
end structural;
--=================================================================================================--
--=================================================================================================--