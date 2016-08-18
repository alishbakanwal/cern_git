--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	06/09/2012 								      											--
-- Project Name:				glib_pcie_demo																				--
-- Module Name:   		 	pcie_ezdma2_ref_design_wrapper														--
-- 																																--
-- Language:					VHDL'93																						--
--																																	--
-- Target Devices: 			GLIB (Virtex 6)																			--
-- Tool versions: 			ISE 13.2	         																		--
--																																	--
-- Revision:		 			1.0 																							--
--																																	--
-- Additional Comments: 																									--
--			                                                                                          --
-- * General DMA signals and buses have been multiplexed in system so it is not necessary          --
--   extra logic for sharing these lines.                                                          --
--	                                                                                                --	
-- * This demo project is based on the reference design provided by PLDA for the EZDMA2            --
--   module.                                                                                       --
--                                                                                                 --
--       ~ BAR0/BAR1(PLDA simulation) -> BAR2/BAR3(GLIB demo)                                      --
--       ~ BAR2/BAR3(PLDA simulation) -> BAR4/BAR5(GLIB demo)                                      --
--                                                                                                 -- 
--       ~ DMA0(PLDA simulation)      -> DMA1(GLIB demo)                                           --
--       ~ DMA1(PLDA simulation)      -> DMA2(GLIB demo)                                           --
--       ~ DMA2(PLDA simulation)      -> DMA3(GLIB demo)                                           --
--                                                                                                 --
-- * Reference documentation:                                                                      --
--                                                                                                 --
--   + It is recommended to read the documents listed below:                                       --
--     - EZDMA2 IP for Xilinx Hard IP Reference Manual(PLDA)                                       --
--     - EZDMA2 IP for Xilinx Hard IP Getting Started (PLDA)                                       --                                                                                                 --
--     - PCIE Express Bus Functional Model (PLDA)                                                  --
--                                                                                                 --
--   + Further information can be found on the following documents:                                --
--		 - Virtex-6 FPGA integrated Block for PCI Expess (UG517) (Xilinx)                            --
--     - PCI EXPRESS BASE SPECIFICATION, REV. 2.1                                                  --
--                                                                                                 --
--=================================================================================================--
--=================================================================================================--
-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;
-- Custom libraries and packages:
use work.system_pcie_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity pcie_ezdma2_ref_design_wrapper is	
	port (	
		-- Reset:
		RESET_I    		 							: in  std_logic; 	
		-- Clock:
		PCIE_CLK_I           		 			: in  std_logic; 						
		-- PCIe Slave interface:
		PCIE_SLV_O									: out R_slv_to_ezdma2;		
		PCIE_SLV_I									: in  R_slv_from_ezdma2;						
		-- PCIe DMA:	
		PCIE_DMA_O	  								: out R_userDma_to_ezdma2_array  (1 to 3); 		
		PCIE_DMA_I 	  								: in  R_userDma_from_ezdma2_array(1 to 3);		
		-- PCIe Interruptions:
		PCIE_INTERRUPT_O							: out R_int_to_ezdma2;		
		PCIE_INTERRUPT_I							: in  R_int_from_ezdma2;
		-- PCIe Link Status:
		PCIE_CFG_I									: in  R_cfg_from_ezdma2;		
		-- PCIe Test Mode:
		PCIE_TEST_MODE_O							: out std_logic_vector(15 downto 0)
	);
end pcie_ezdma2_ref_design_wrapper;
architecture structural of pcie_ezdma2_ref_design_wrapper is
	--======================= Constant Declarations =======================--
	constant DATAPATH 							: integer := 64;
	constant CORE_FREQ							: integer := 250;	
	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--		
	--========================= Port Assignments ==========================--		
	-- PCIe Interruptions:
   PCIE_INTERRUPT_O.msgnum 					<= (others => '0');
	-- PCIe Test Mode:	
	PCIE_TEST_MODE_O								<= (others => '0');
	--=====================================================================--	
	--===================== Component Instantiations ======================--
	ezdma2_ref_design: entity work.ref_design 
		generic map (		                              		
			DATAPATH 								=> DATAPATH,   
			CORE_FREQ								=> CORE_FREQ)		
		port map (
			clk 										=> PCIE_CLK_I,
			rstn 										=> not RESET_I,
			srst 										=> '0',
			clk_doubled 							=> '0',			
			---------------------------------			
			int_request 							=> PCIE_INTERRUPT_O.request,
			int_ack									=> PCIE_INTERRUPT_I.ack,
			---------------------------------		
			slv_dataout 							=> PCIE_SLV_I.dataout,
			slv_bytevalid 							=> PCIE_SLV_I.bytevalid,
			slv_bytecount 							=> PCIE_SLV_I.bytecount,
			slv_addr 								=> PCIE_SLV_I.addr,
			slv_bar 									=> PCIE_SLV_I.bar,
			slv_readreq 							=> PCIE_SLV_I.readreq,
			slv_cpladdr 							=> PCIE_SLV_I.cpladdr,
			slv_cplparam 							=> PCIE_SLV_I.cplparam,
			slv_writereq 							=> PCIE_SLV_I.writereq,
			slv_write 								=> PCIE_SLV_I.wr,
			slv_accept 								=> PCIE_SLV_O.accept,
			slv_abort 								=> PCIE_SLV_O.abort,			
			---------------------------------
			--
			-- Note!!! General DMA signals and buses have been multiplexed in
			--         system so it is not necessary extra logic for sharing these
			--         lines.
			--
			dma2_rd 									=> PCIE_DMA_I(2).rd,
			dma2_rdaddr 							=> PCIE_DMA_I(2).rdaddr,
			dma2_rdchannel 						=> PCIE_DMA_I(2).rdchannel,
			dma2_rddata 							=> PCIE_DMA_O(2).rddata,				
			dma3_rd 									=> PCIE_DMA_I(3).rd,
			dma3_rdaddr 							=> PCIE_DMA_I(3).rdaddr(12 downto 0),
			dma3_rdchannel 						=> PCIE_DMA_I(3).rdchannel,			
			dma3_rddata 							=> PCIE_DMA_O(3).rddata,
			---------------------------------			
			dma1_wr 									=> PCIE_DMA_I(1).wr,
			dma1_wrchannel 						=> PCIE_DMA_I(1).wrchannel,
			dma1_wraddr 							=> PCIE_DMA_I(1).wraddr,			
			dma1_wrdata 							=> PCIE_DMA_I(1).wrdata,
			dma2_wr 									=> PCIE_DMA_I(2).wr,
			dma2_wrchannel 						=> PCIE_DMA_I(2).wrchannel,
			dma2_wrdata 							=> PCIE_DMA_I(2).wrdata,
			dma3_wr 									=> PCIE_DMA_I(3).wr,			
			dma3_wrchannel 						=> PCIE_DMA_I(3).wrchannel,
			dma3_wrdata 							=> PCIE_DMA_I(3).wrdata,			
			---------------------------------			
			dma1_regin 								=> PCIE_DMA_O(1).regin,
			dma1_regout								=> PCIE_DMA_I(1).regout,
			dma1_param 								=> PCIE_DMA_O(1).param,
			dma1_control 							=> PCIE_DMA_O(1).control,
			dma1_status 							=> PCIE_DMA_I(1).status,
			dma1_fifocnt 							=> PCIE_DMA_O(1).fifocnt,
			dma2_regin 								=> PCIE_DMA_O(2).regin,
			dma2_regout	 							=> PCIE_DMA_I(2).regout,
			dma2_param 								=> PCIE_DMA_O(2).param,
			dma2_control 							=> PCIE_DMA_O(2).control,
			dma2_status 							=> PCIE_DMA_I(2).status,
			dma2_fifocnt 							=> PCIE_DMA_O(2).fifocnt,
			dma3_regin 								=> PCIE_DMA_O(3).regin,
			dma3_param 								=> PCIE_DMA_O(3).param,
			dma3_control 							=> PCIE_DMA_O(3).control,
			dma3_status 							=> PCIE_DMA_I(3).status,
			dma3_fifocnt 							=> PCIE_DMA_O(3).fifocnt,
			---------------------------------
			cfg_linkcsr 							=> PCIE_CFG_I.linkcsr,
			cfg_ltssm 								=> PCIE_CFG_I.ltssm		
		);		
	--=====================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--