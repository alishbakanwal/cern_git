--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	10/07/2012		 																			--
-- Project Name:				pcie_glib																					--
-- Module Name:   		 	ezEZDMA22_ipbus_int_cdc				 													--
-- 																																--
-- Language:					VHDL'93																						--
--																																	--
-- Target Devices: 			GLIB (Virtex 6)																			--
-- Tool versions: 			13.2																							--
--																																	--
-- Revision:		 			1.0 																							--
--																																	--
-- Additional Comments: 																									--
--																																	--
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
entity ezdma2_ipbus_int_cdc is
	port (
		-- General reset and clocks:
		RESET_I										: in  std_logic;
		PCIE_CLK_I									: in  std_logic;
		IPBUS_CLK_I									: in  std_logic;
		-- Control DPRAM:		
		EZDMA2_SLAVE_WR_I							: in  std_logic;
		EZDMA2_SLAVE_RD_I							: in  std_logic;
		EZDMA2_DWCOUNT_I							: in  std_logic_vector (10 downto 0);			
		EZDMA2_IPBUS_ADDR_I						: in  std_logic_vector (31 downto 0);		
		EZDMA2_IPBUS_BUSY_O						: out std_logic;
		EZDMA2_IPBUS_ERROR_O						: out std_logic;	
		EZDMA2_IPBUS_TIMEOUT_O					: out std_logic;	
		EZDMA2_RD_IPBUS_RDY_O					: out std_logic;	
		IPBUS_SLAVE_WR_O							: out std_logic;
		IPBUS_SLAVE_RD_O							: out std_logic;
		IPBUS_DWCOUNT_O							: out std_logic_vector (10 downto 0);			
		IPBUS_IPBUS_ADDR_O						: out std_logic_vector (31 downto 0);
		IPBUS_IPBUS_BUSY_I						: in  std_logic;	
		IPBUS_IPBUS_ERROR_I						: in  std_logic;	
		IPBUS_IPBUS_TIMEOUT_I					: in  std_logic;	
		IPBUS_RD_IPBUS_RDY_I						: in  std_logic;	
		-- Slave Write FIFO:
		EZDMA2_WR_FIFO_WE_I						: in  std_logic;
		EZDMA2_WR_FIFO_DATA_I					: in  std_logic_vector(63 downto 0);
		IPBUS_WR_FIFO_EMPTY_O					: out std_logic;
		IPBUS_WR_FIFO_RE_I						: in  std_logic;
		IPBUS_WR_FIFO_DATA_O						: out std_logic_vector(63 downto 0);
		-- Slave Read FIFO:
		IPBUS_RD_FIFO_WE_I						: in  std_logic;
		IPBUS_RD_FIFO_DATA_I						: in  std_logic_vector(63 downto 0);	
		EZDMA2_RD_FIFO_EMPTY_O					: out std_logic;
		EZDMA2_RD_FIFO_RE_I						: in  std_logic;
		EZDMA2_RD_FIFO_DATA_O					: out std_logic_vector(63 downto 0)		
	);
end ezdma2_ipbus_int_cdc;
architecture Behavioral of ezdma2_ipbus_int_cdc is
	--============================ Declarations ===========================--	
	-- Dummy signals and constants used to avoid errors in ISIM:
	signal dummy_floating_1						: std_logic_vector(63 downto 45);
	signal dummy_floating_2						: std_logic_vector( 7 downto  4);	
	constant zero_63_45							: std_logic_vector(63 downto 45) := (others => '0');
	constant zero_7_4								: std_logic_vector( 7 downto  4) := (others => '0');		
	-- General:
	signal fifo_reset								: std_logic;	
	-- PCIe:		
	signal ezdma2_rd_fifo_empty				: std_logic;
	signal ezdma2_rd_fifo_data					: std_logic_vector(63 downto 0);	
	-- IPbus:
	signal ipbus_wr_fifo_empty					: std_logic;
	--=====================================================================--	
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--=========================== User Logic ==============================--
	
	-- FIFOs reset OR gate:
	fifo_reset										<= RESET_I or 
															IPBUS_IPBUS_ERROR_I or 
															IPBUS_IPBUS_TIMEOUT_I;
	
	--===========--
	-- Registers --
	--===========--
	
	-- PCIe clk:
	pcie_clk_reg_process: process(RESET_I, PCIE_CLK_I)
	begin
		if RESET_I = '1' then				
			EZDMA2_RD_FIFO_EMPTY_O				<= '1';	
			EZDMA2_RD_FIFO_DATA_O				<= (others => '0');			
		elsif rising_edge(PCIE_CLK_I) then							
			-- RD_FIFO_EMPTY register:
			EZDMA2_RD_FIFO_EMPTY_O				<= ezdma2_rd_fifo_empty;	
			-- Slave Read FIFO output register:
			EZDMA2_RD_FIFO_DATA_O				<= ezdma2_rd_fifo_data;			
		end if;
	end process;			
	
	-- IPbus clk:
	ipbus_clk_reg_process: process(RESET_I, IPBUS_CLK_I)
	begin
		if RESET_I = '1' then				
			IPBUS_WR_FIFO_EMPTY_O				<= '1';	
		elsif rising_edge(IPBUS_CLK_I) then					
			-- WR_FIFO_EMPTY register:
			IPBUS_WR_FIFO_EMPTY_O				<= ipbus_wr_fifo_empty;	
		end if;
	end process;
	--=====================================================================--		
	--===================== Component Instantiations ======================--		

	--================--
	-- Control DPRAMs -- (with registered outputs)
	--================--
	
	-- EZDMA2 to IPbus:
	ezdma2ctrlDpram: entity work.ezdma2_ctrl_dpram
		port map (
			CLK 										=> PCIE_CLK_I,
			WE											=> '1',	
			A											=> "0000",
			D(10 downto  0)						=> EZDMA2_DWCOUNT_I,	
			D(42 downto 11)						=> EZDMA2_IPBUS_ADDR_I,
			D(43)										=> EZDMA2_SLAVE_WR_I,
			D(44)										=> EZDMA2_SLAVE_RD_I,
			D(63 downto 45)						=> zero_63_45,
			---------------------	
			QDPO_CLK 								=> IPBUS_CLK_I,
			DPRA 										=> "0000",
			QDPO(10 downto  0)					=> IPBUS_DWCOUNT_O,
			QDPO(42 downto 11)					=> IPBUS_IPBUS_ADDR_O,
			QDPO(43)									=> IPBUS_SLAVE_WR_O,
			QDPO(44) 								=> IPBUS_SLAVE_RD_O,			
			QDPO(63 downto 45)					=> dummy_floating_1(63 downto 45)	
		);

	--IPBUS to EZDMA2:
	ipbusCtrlDpram: entity work.ipbus_ctrl_dpram
		port map (
			CLK 										=> IPBUS_CLK_I,
			WE											=> '1',
			A		 									=> "0000",
			D(0)										=> IPBUS_IPBUS_BUSY_I,							
			D(1)										=> IPBUS_RD_IPBUS_RDY_I,
			D(2)										=> IPBUS_IPBUS_ERROR_I,		
			D(3)										=> IPBUS_IPBUS_TIMEOUT_I,	
			D(7 downto  4)							=> zero_7_4,				
			---------------------	
			QDPO_CLK 								=> PCIE_CLK_I,
			DPRA 										=> "0000",				
			QDPO(0)									=> EZDMA2_IPBUS_BUSY_O,
			QDPO(1)									=> EZDMA2_RD_IPBUS_RDY_O,
			QDPO(2)									=> EZDMA2_IPBUS_ERROR_O,	
			QDPO(3)									=> EZDMA2_IPBUS_TIMEOUT_O,
			QDPO(7 downto 4)						=> dummy_floating_2(7 downto 4)	
		);

	--=======--
	-- FIFOs --
	--=======--	
	
	-- Slave Write FIFO:	
	slvWrFifo: entity work.slv_wr_fifo
		port map (
			RST 										=> fifo_reset,			
			WR_CLK 									=> PCIE_CLK_I,
			RD_CLK 									=> IPBUS_CLK_I,
			DIN 										=> EZDMA2_WR_FIFO_DATA_I,
			WR_EN 									=> EZDMA2_WR_FIFO_WE_I,
			RD_EN 									=> IPBUS_WR_FIFO_RE_I,
			DOUT 										=> IPBUS_WR_FIFO_DATA_O,	-- DOUT is registered 
			FULL 										=> open,							-- in ipbus_int
			EMPTY										=> ipbus_wr_fifo_empty
		);
	
	-- Slave Read FIFO:
	slvRdFifo: entity work.slv_rd_fifo
		port map (
			RST 										=> fifo_reset,			
			WR_CLK 									=> IPBUS_CLK_I,
			RD_CLK 									=> PCIE_CLK_I,
			DIN 										=> IPBUS_RD_FIFO_DATA_I,
			WR_EN 									=> IPBUS_RD_FIFO_WE_I,
			RD_EN 									=> EZDMA2_RD_FIFO_RE_I,
			DOUT 										=> ezdma2_rd_fifo_data,
			FULL 										=> open,
			EMPTY 									=> ezdma2_rd_fifo_empty
		);
	--=====================================================================--
end Behavioral;
--=================================================================================================--
--=================================================================================================--