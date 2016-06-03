--=================================================================================================--
--=================================== Package Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	22/09/2012		 																			--
-- Module Name:				ezdma2_ipbus_int_ezdma2																	--
-- Package Name:   		 	pcie_addr_enc																				--
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
-- Custom libraries and packages:
use work.user_sys_pcie_constants_package.all;
--=================================================================================================--
--=================================================================================================--
package ezdma2_ipbus_int_addr_enc is	
	--=============== Function and Procedure Declarations =================--
	-- BAR1 MSB identifier:
	function bar1_msb(bar1_mem_space : in bit_vector(31 downto 0)) return integer;
	-- PCIe to IPbus address encoder:	
	function addrEnc(pcie_addr_lsdw, pcie_bar : in std_logic_vector) return std_logic_vector;	
	--=====================================================================--		
end ezdma2_ipbus_int_addr_enc;
--=================================================================================================--
--====================================== Package Body =============================================-- 
--=================================================================================================--
package body ezdma2_ipbus_int_addr_enc is
	--================== Function and Procedure Bodies ====================--
	-- BAR1 MSB identifier:
	function bar1_msb(bar1_mem_space : in bit_vector(31 downto 0))
	return integer is
		variable bar1_num_bits			: integer range 0 to 29;			
	begin	
		bar1_num_bits						:= 0;
		for i in 0 to 28 loop	 -- Bits [31:29] are not taken into account.
			if bar1_mem_space(i) = '0' then
				bar1_num_bits 				:= bar1_num_bits + 1;					
			else						
				exit;			
			end if;
		end loop;
		return bar1_num_bits - 1;
	end function;	

	-- PCIe to IPbus address encoder:	
	function addrEnc(pcie_addr_lsdw, pcie_bar : in std_logic_vector)
	return std_logic_vector is
		variable ipbus_addr				: std_logic_vector(31 downto 0);
		variable bar1_num_bits			: integer range 0 to 29;
		variable msb						: integer range 0 to 28;
		variable ZERO						: std_logic_vector(31 downto 0);
	begin				
		ipbus_addr							:= (others => '0');
		bar1_num_bits						:= 0; 
		msb                           := 0;
		ZERO									:= (others => '0');
		case pcie_bar is
			when "0000001" =>	-- BAR0 (System Regs, DRP, ICAP, SRAM1, SRAM2 and FLASH)	
				-- BAR0 address codification (Note!!! BAR0 must be x"FC000000"):
				if 	std_match(pcie_addr_lsdw, "------001-----------------------")  then  	 -- SRAM1			
					ipbus_addr				:= "00000010000"   & pcie_addr_lsdw(22 downto 2); 	-- (*)	                  
				elsif std_match(pcie_addr_lsdw, "------010-----------------------")  then  	 -- SRAM2
					ipbus_addr				:= "00000100000"   & pcie_addr_lsdw(22 downto 2); 	-- (*)				
				elsif	std_match(pcie_addr_lsdw, "------1-------------------------")  then  	 -- FLASH
					ipbus_addr				:= "000010000"   	 & pcie_addr_lsdw(24 downto 2); 	-- (*)										
				else	  														      				-- SYS REG, ICAP, DRP
					ipbus_addr				:= x"00000" & "00" & pcie_addr_lsdw(11 downto 2); 	-- (*)					 	
				end if;		
			when "0000010" =>	-- BAR1 (User IPbus and User Wishbone)													
				msb 							:= bar1_msb(BAR1_MEM_SPACE);			
				if pcie_addr_lsdw(msb) = '0' then		-- Address is within User IPbus memory space:						
					ipbus_addr				:= "01" & ZERO(29 downto msb-2)
													& pcie_addr_lsdw(msb-1 downto 2); 					-- (+)(*)
				elsif pcie_addr_lsdw(msb) = '1' then -- Address is within User Wishbone memory space:						
					ipbus_addr				:= "10" & ZERO(29 downto msb-2)
													& pcie_addr_lsdw(msb-1 downto 2);	 				-- (+)(*)
				end if;											
			when others =>
				ipbus_addr					:= (others => '0');
		end case;
		return ipbus_addr;
	end function;	
end ezdma2_ipbus_int_addr_enc;
--=================================================================================================--
--=================================================================================================--