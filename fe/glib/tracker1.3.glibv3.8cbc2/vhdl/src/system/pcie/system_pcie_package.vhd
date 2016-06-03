--=================================================================================================--
--=================================== Package Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   14/06/2012 																					
-- Module Name:			pcie_glib																					
-- Package Name:   		system_pcie_package																		
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
-- Custom libraries and packages:
use work.user_sys_pcie_constants_package.all;
--=================================================================================================--
--================================== Package Declaration ==========================================-- 
--=================================================================================================--
package system_pcie_package is
   --====================== Constant Declarations ========================--	
	-- PCIe Vendor ID:
   constant VENDOR_ID                     : bit_vector := x"10DC";   -- CERN Vendor ID
   -- PCIe/IPbus interface:
	constant IPBUS_TIMEOUT						: integer := 255;		      -- x"FF"			
	-- User DMAs:
	constant DMA1 									: integer := 1;
	constant DMA2 									: integer := 2;	
	constant DMA3 									: integer := 3;	
	constant DMA4 									: integer := 4;	
	constant DMA5 									: integer := 5;	
	constant DMA6 									: integer := 6;	
	constant DMA7 									: integer := 7;		
	--=====================================================================--
	--======================== Type Declarations ==========================--
	
	--========--
	-- EZDMA2 --
	--========--	
	
	-- Arrays:
	type T_dma_regin	 							is array (1 to 7) of std_logic_vector(127 downto 0);
	type T_dma_regout	 							is array (1 to 7) of std_logic_vector(127 downto 0);
	type T_dma_param 								is array (1 to 7) of std_logic_vector( 23 downto 0);
	type T_dma_control	 						is array (1 to 7) of std_logic_vector(  5 downto 0);	
	type T_dma_status	 							is array (1 to 7) of std_logic_vector(  3 downto 0);	
	type T_dma_fifocnt	 						is array (1 to 7) of std_logic_vector( 12 downto 0);
	
	--=================================--
	-- EZDMA2 - IPbus fabric interface --
	--=================================--
	
	-- General:
	type T_ezdma2ipbus_ezdma2_rd_wr_state 	is (e0_idle, e1_select);
	
	-- Slave Write:
	type T_ezdma2ipbus_ezdma2_wr_state 		is (e0_idle, e1_write_enable);
	type T_ezdma2ipbus_ipbus_wr_state  		is (e0_idle, e1_read_wr_fifo, e2_fifo_dly, 
															 e3_write_ipbus, e4_write_disable);
	-- Slave Read:	
	type T_ezdma2ipbus_ezdma2_rd_state 		is (e0_idle, e1_req_data, e2_ipbus_rdy);
	type T_ezdma2ipbus_ipbus_rd_state  		is (e0_idle, e1_initial_strobe, e2_read_cycle,
															 e3_read_disable);														 
	--===================================--
	-- PCIe or Ethernet to IPbus arbiter --
	--===================================--
	
	type T_pcieEthArb								is (eth, pcie);	
	
	--=====================================================================--				
	--======================= Record Declarations =========================--
	
	--========--
	-- EZDMA2 --
	--========--			
	
	-- Slave interface:
	type R_slv_from_ezdma2 is		
		record		
			dataout									: std_logic_vector(63 downto 0);
			bytevalid                        : std_logic_vector( 7 downto 0);
			bytecount                        : std_logic_vector(12 downto 0);
			dwcount                          : std_logic_vector(10 downto 0);
			addr                             : std_logic_vector(63 downto 0);
			bar                              : std_logic_vector( 6 downto 0);
			readreq                          : std_logic;
			cpladdr                          : std_logic_vector(31 downto 0);
			cplparam                         : std_logic_vector( 7 downto 0);
			writereq                         : std_logic;
			wr                               : std_logic;
			lastwrite                        : std_logic;
			io                               : std_logic;
	end record;
	type R_slv_to_ezdma2 is		
		record		
			accept 									: std_logic;
         abort                            : std_logic;
         ur		                           : std_logic;
	end record;
	
	-- General DMA:	
	type R_gDma_from_ezdma2 is
		record
			rd                  					: std_logic;
			rdaddr              					: std_logic_vector(31 downto 0);
			rdchannel           					: std_logic_vector(15 downto 0);
			---------------------------		
			wr                  					: std_logic;
			wraddr              					: std_logic_vector(31 downto 0);
			wrchannel           					: std_logic_vector(15 downto 0);
			wrdata              					: std_logic_vector(63 downto 0);
			wrbytevalid         					: std_logic_vector( 7 downto 0);		
	end record;					
	type R_gDma_to_ezdma2 is		
		record		
			rddata              					: std_logic_vector(63 downto 0);
	end record;		
	
	-- DMA:
	type R_dma_from_ezdma2 is		
		record					
			regout         						: std_logic_vector(127 downto 0);
			status         						: std_logic_vector(  3 downto 0);
	end record;				
	type R_dma_to_ezdma2 is		
		record		
			regin										: std_logic_vector(127 downto 0);
			param     								: std_logic_vector( 23 downto 0);
			control  								: std_logic_vector(  5 downto 0);
			fifocnt        						: std_logic_vector( 12 downto 0);
	end record;					
		
	-- User DMA:	
	type R_userDma_from_ezdma2 is
		record
			rd                  					: std_logic;
			rdaddr              					: std_logic_vector(31 downto 0);
			rdchannel           					: std_logic_vector(15 downto 0);
			---------------------------		
			wr                  					: std_logic;
			wraddr              					: std_logic_vector(31 downto 0);
			wrchannel           					: std_logic_vector(15 downto 0);
			wrdata              					: std_logic_vector(63 downto 0);
			wrbytevalid         					: std_logic_vector( 7 downto 0);		
			---------------------------
			regout         						: std_logic_vector(127 downto 0);
			status         						: std_logic_vector(  3 downto 0);			
	end record;					
	type R_userDma_to_ezdma2 is		
		record				
			rddata              					: std_logic_vector(63 downto 0);
			---------------------------
			regin										: std_logic_vector(127 downto 0);
			param     								: std_logic_vector( 23 downto 0);
			control  								: std_logic_vector(  5 downto 0);
			fifocnt        						: std_logic_vector( 12 downto 0);
	end record;						
		
	-- Interruptions:		
	type R_int_from_ezdma2 is		
		record				
			ack                 					: std_logic;
	end record;		
	type R_int_to_ezdma2 is		
		record			
			request             					: std_logic;
			msgnum              					: std_logic_vector( 4 downto 0);
	end record;		
	
	-- Configuration interface:
	type R_cfg_from_ezdma2 is		
		record
			prmcsr 									: std_logic_vector( 31 downto 0);
			devcsr 									: std_logic_vector( 31 downto 0);
			linkcsr 									: std_logic_vector( 31 downto 0);
			msicsr 									: std_logic_vector( 15 downto 0);						
			ltssm 									: std_logic_vector(  4 downto 0);			
	end record;			

	-- Record Arrays:
	
	type R_gDma_from_ezdma2_array 			is array (natural range <>) of R_gDma_from_ezdma2;
	type R_gDma_to_ezdma2_array 				is array (natural range <>) of R_gDma_to_ezdma2;

	type R_dma_from_ezdma2_array 				is array (natural range <>) of R_dma_from_ezdma2;
	type R_dma_to_ezdma2_array   				is array (natural range <>) of R_dma_to_ezdma2;
	
	type R_userDma_from_ezdma2_array 		is array (natural range <>) of R_userDma_from_ezdma2;
	type R_userDma_to_ezdma2_array   		is array (natural range <>) of R_userDma_to_ezdma2;

	--=====================================================================--
end system_pcie_package;
--=================================================================================================--
--=================================================================================================--