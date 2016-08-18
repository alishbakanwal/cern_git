--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	31/07/2012																					--
-- Project Name:				pcie_glib																					--
-- Module Name:   		 	ezdma2_mux								 													--
-- 																																--
-- Language:					VHDL'93																						--
--																																	--
-- Target Devices: 			GLIB (Virtex 6)																			--
-- Tool versions: 			ISE 13.2																						--
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
-- Custom libraries and packages:
use work.ipbus.all;
use work.system_pcie_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity ezdma2_mux is
	port (	
		--========================--
		-- EZDMA2 Slave interface --
		--========================--

		-- EZDMA2:
		SLV_I									: in  R_slv_from_ezdma2; 
		SLV_O			      				: out R_slv_to_ezdma2;
		-- EZDMA2 - IPbus fabric interface:	
		IPBUS_SLV_I							: in  R_slv_to_ezdma2; 
		IPBUS_SLV_O                   : out R_slv_from_ezdma2;
		-- User:
		USER_SLV_I							: in  R_slv_to_ezdma2; 
		USER_SLV_O                    : out R_slv_from_ezdma2;
		
		--=============--
		-- General DMA --
		--=============--	
	
		-- EZDMA2:
		GDMA_I								: in  R_gDma_from_ezdma2;
		GDMA_O			               : out R_gDma_to_ezdma2;
		-- EZDMA2 - IPbus fabric interface:	
		IPBUS_GDMA_I						: in  R_gDma_to_ezdma2;
		IPBUS_GDMA_O      				: out R_gDma_from_ezdma2;
		-- User:
		USER_GDMA_I							: in  R_gDma_to_ezdma2_array	(1 to 7);
		USER_GDMA_O      					: out R_gDma_from_ezdma2_array(1 to 7)				
	);
end ezdma2_mux;
architecture behavioural of ezdma2_mux is			
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--
	--============================ User Logic =============================--	
	-- PCIe Slave:	
	slv_mux_process: process(SLV_I, IPBUS_SLV_I, USER_SLV_I)									
	begin	
		case SLV_I.bar is
			when "0000001" | "0000010" =>						-- BAR0|BAR1
				SLV_O							<= IPBUS_SLV_I;
				IPBUS_SLV_O					<= SLV_I;
				USER_SLV_O					<= ((others => '0'),(others => '0'),
													 (others => '0'),(others => '0'),
													 (others => '0'),(others => '0'),'0',
													 (others => '0'),(others => '0'),'0',
													 '0','0','0');							
			when others =>											-- BAR2|BAR3|BAR4|BAR5|ExROM BAR			
				SLV_O							<= USER_SLV_I;
				IPBUS_SLV_O					<= ((others => '0'),(others => '0'),
													 (others => '0'),(others => '0'),
													 (others => '0'),(others => '0'),'0',
													 (others => '0'),(others => '0'),'0',
													 '0','0','0');					
				USER_SLV_O					<= SLV_I;	
		end case;
	end process;
	
	-- PCIe General DMA:
		-- Read User Logic -> Write PCIe (Write transaction):
		IPBUS_GDMA_O.rd       			<= GDMA_I.rd when GDMA_I.rdchannel(0) = '1' else '0';	
		IPBUS_GDMA_O.rdaddr   			<= GDMA_I.rdaddr;	
		IPBUS_GDMA_O.rdchannel			<= GDMA_I.rdchannel;		
		rd_user_generate: for i in 1 to 7 generate
			USER_GDMA_O(i).rd       	<= GDMA_I.rd when GDMA_I.rdchannel(i) = '1' else '0';	
			USER_GDMA_O(i).rdaddr   	<= GDMA_I.rdaddr;		
			USER_GDMA_O(i).rdchannel	<= GDMA_I.rdchannel;		
		end generate;
		GDMA_O.rddata						<= IPBUS_GDMA_I.rddata 	 when GDMA_I.rdchannel(0) = '1' else
													USER_GDMA_I(1).rddata when GDMA_I.rdchannel(1) = '1' else	
													USER_GDMA_I(2).rddata when GDMA_I.rdchannel(2) = '1' else	
													USER_GDMA_I(3).rddata when GDMA_I.rdchannel(3) = '1' else	
													USER_GDMA_I(4).rddata when GDMA_I.rdchannel(4) = '1' else	
													USER_GDMA_I(5).rddata when GDMA_I.rdchannel(5) = '1' else	
													USER_GDMA_I(6).rddata when GDMA_I.rdchannel(6) = '1' else	
													USER_GDMA_I(7).rddata when GDMA_I.rdchannel(7) = '1'
													else (others => '0');	
		-- Write User Logic -> Read PCIe (Write transaction):	
		IPBUS_GDMA_O.wr          		<= GDMA_I.wr when GDMA_I.wrchannel(0) = '1' else '0';
		IPBUS_GDMA_O.wraddr      		<= GDMA_I.wraddr;	
		IPBUS_GDMA_O.wrchannel   		<= GDMA_I.wrchannel;	
		IPBUS_GDMA_O.wrdata      		<= GDMA_I.wrdata;	
		IPBUS_GDMA_O.wrbytevalid 		<= GDMA_I.wrbytevalid;		
		wr_user_generate: for i in 1 to 7 generate
			USER_GDMA_O(i).wr          <= GDMA_I.wr when GDMA_I.wrchannel(i) = '1' else '0';	
			USER_GDMA_O(i).wraddr      <= GDMA_I.wraddr;	
			USER_GDMA_O(i).wrchannel   <= GDMA_I.wrchannel;	
			USER_GDMA_O(i).wrdata      <= GDMA_I.wrdata;	
			USER_GDMA_O(i).wrbytevalid <= GDMA_I.wrbytevalid;		
		end generate;
	--=====================================================================--	
end behavioural;
--=================================================================================================--
--=================================================================================================--