--=================================================================================================--
--=================================== Package Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   09/07/2012 																					
-- Module Name:			pcie_glib																					
-- Package Name:   		user_sys_pcie_package   																
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
--=================================================================================================--
--================================== Package Declaration ==========================================-- 
--=================================================================================================--
package user_sys_pcie_constants_package is	  
	--====================== Constant Declarations ========================--	
	
	--====================--	
	-- User SYS PCIe BARs --
	--====================--	
	
	-- User IPbus and User Wishbone:
		
	-- BAR1 memory space configuration:		
	-- This memory space is shared equally between User IPbus fabric and Wishbone fabric. 
	-- The MSb of the address is used for the selection:
	--   + (MSb = 0): User IPbus fabric 
	--   + (MSb = 1): Wishbone fabric   
	
	-- e.g.
	--   BAR1_MEM_SPACE = x"FFC00000":
	--   User IPbus fabric base address = x"00000000"
	--   Wishbone fabric base address   = x"00200000"	
	
	constant BAR1_MEM_SPACE				   : bit_vector 	:= x"FFC00000"; -- 4 MB (22 bits)  						 		
                                                                      -- (2 MB IPbus/ 2 MB Wishbone)
	-- General purpose:
	
		-- Note!!! For 64 bit BAR two conditions must be done:
		--
		--   + Two consecutive BARs are concatenated to built the 64 bit BAR but with the restriction
		--		 of the LSDW BAR must be even (e.g. BAR3(MSDW)/BAR2(LSDW)).
		--
		--   + The four LSBs of the Base Address of the LSDW BAR must be:
		--		 -	"0100" (x"4") for 64 bit BAR no prefetchable. 
		--     - "1100" (x"C") for 64 bit BAR prefetchable. 
		--
		
		-- BAR2 memory space configuration(User defined):	
		constant BAR2_MEM_SPACE          : bit_vector 	:= x"FFFFFFFF"; 
		-- BAR3 memory space configuration(User defined):
		constant BAR3_MEM_SPACE          : bit_vector	:= x"FFFFFFFF";	
		-- BAR4 memory space configuration(User defined):
		constant BAR4_MEM_SPACE         	: bit_vector 	:= x"FFFFFFFF"; 
		-- BAR5 memory space configuration(User defined):
		constant BAR5_MEM_SPACE          : bit_vector 	:= x"FFFFFFFF";	
	
	--============================================--
	-- General purpose user SYS PCIe DMA Channels --
	--============================================--
	
	-- Note!!! The number of DMA used must match with the number of DMA instantiated.
	
	constant NUM_USER_SYS_PCIE_DMA   	: integer 		:= 0;					-- Min = 0 | Max = 7	   
   
	--=====================================================================--	
end user_sys_pcie_constants_package;
--=================================================================================================--
--=================================================================================================--