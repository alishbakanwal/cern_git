--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	10/07/2012		 																			--
-- Project Name:				pcie_interface																				--
-- Module Name:   		 	pcie_or_eth_to_ipbus_arb			 													--
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
-- User libraries and packages:
use work.system_pcie_package.all;
use work.ipbus.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity pcie_or_eth_to_ipbus_arb is	
	port (
		-- Reset:
		RESET_I								: in  std_logic;
		-- PCIe:
		PCIE_CLK_I							: in  std_logic;
		PCIE_BUSY_I							: in  std_logic;
		PCIE_FROM_IPBUS_O					: out	ipb_rbus;
		PCIE_TO_IPBUS_I					: in 	ipb_wbus;
		-- Ethernet:
		ETH_BUSY_I							: in  std_logic;
		ETH_FROM_IPBUS_O					: out	ipb_rbus;
		ETH_TO_IPBUS_I						: in	ipb_wbus;
		-- IPbus fabric:
		ARB_FROM_FABRIC_I					: in 	ipb_rbus;
		ARB_TO_FABRIC_O					: out	ipb_wbus
	);
end pcie_or_eth_to_ipbus_arb;
architecture structural of pcie_or_eth_to_ipbus_arb is	
	--============================ Declarations ===========================--
	-- Signals:
	signal pcie_busy_rr					: std_logic;
	signal pcie_busy_r					: std_logic;
	signal eth_busy_rr					: std_logic;
	signal eth_busy_r						: std_logic;
	signal sel								: T_pcieEthArb;
	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--============================ User Logic =============================--
	control_process: process(RESET_I, PCIE_CLK_I)		
	begin
		if RESET_I = '1' then
			sel								<= eth;
			pcie_busy_rr					<= '0';
			pcie_busy_r						<= '0';
			eth_busy_rr						<= '0';
			eth_busy_r						<= '0';	
		elsif rising_edge(PCIE_CLK_I) then
			-- Synchronizers:
			-- (The busy signal from the PCIe interface can come either 
			-- from the PCIe clock domain or from the IPbus clock domain)	
			pcie_busy_rr					<= pcie_busy_r;
			pcie_busy_r						<= PCIE_BUSY_I;
			eth_busy_rr						<= eth_busy_r;
			eth_busy_r						<= ETH_BUSY_I;	
			-- Arbiter:
			-- ("sel" signal is synchronous with the PCIe clock)
			case sel is
				when eth =>				
					if pcie_busy_rr = '1' and eth_busy_rr = '0' then						
						sel					<= pcie;
					end if;	
				when pcie =>				
					if pcie_busy_rr = '0' then
						sel 					<= eth;
					end if;			
			end case;
		end if;
	end process;
	-- Not registered buses and signals (asynchronous multiplexor):
	mux_process: process(sel, ARB_FROM_FABRIC_I, ETH_TO_IPBUS_I, PCIE_TO_IPBUS_I)	
	begin		
		case sel is
			when pcie =>
				ETH_FROM_IPBUS_O			<= ((others => '0'), '0', '0');		
				PCIE_FROM_IPBUS_O			<= ARB_FROM_FABRIC_I;
				ARB_TO_FABRIC_O			<= PCIE_TO_IPBUS_I;		
			when others =>	-- eth	
				ETH_FROM_IPBUS_O			<= ARB_FROM_FABRIC_I;	
				PCIE_FROM_IPBUS_O			<= ((others => '0'), '0', '0');
				ARB_TO_FABRIC_O			<= ETH_TO_IPBUS_I;					
		end case;
	end process;
	--=====================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--