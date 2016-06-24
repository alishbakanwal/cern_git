--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT pattern match flag                                        
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Device agnostic                                                        
-- Tool version:                                                                    
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        27/06/2013   3.0       M. Barros Marin   - First .vhd module definition           
--
-- Additional Comments:      
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!   (Note!! These parameters are vendor specific)                                           !!                    
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_bank_package.vhd").                                !! 
-- !!     (e.g. xlx_v6_gbt_bank_package.vhd)                                                    !!
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<vendor>_<device>_gbt_bank_user_setup.vhd".     !!
-- !!     (e.g. xlx_v6_gbt_bank_user_setup.vhd)                                                 !! 
-- !!                                                                                           !! 
-- !! * The "<vendor>_<device>_gbt_bank_user_setup.vhd" is the only file of the GBT Bank that   !!
-- !!   may be modified by the user. The rest of the files MUST be used as is.                  !!
-- !!                                                                                           !!  
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                                                                                              
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_pattern_matchflag is
   generic (    
      MATCH_PATTERN                             : std_logic_vector(7 downto 0) := x"FF"   -- Comment: 255d@40MHz = 6.375us               
   );                
   port (               

      --===============--
      -- Reset & Clock --
      --===============-- 
      
      -- Reset:
      ---------   
      
      RESET_I                                   : in  std_logic; 
      
      -- Clock:                                           
      ---------                           
      
      CLK_I                                     : in  std_logic; 
      
      --===============--
      -- Tx Data input --
      --===============--
      
      TXDATA_I                                  : in  std_logic_vector(83 downto 0);
      
      --======--
      -- Flag --
      --======--
      
      MATCHFLAG_O                               : out std_logic;
		
		--===============--
		-- Rx Data input --
		--===============--
		
		RXDATA_O                                  : in std_logic_vector(83 downto 0)		
      
   );
      
end gbt_pattern_matchflag;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_pattern_matchflag is 

	signal count                                 : std_logic_vector (1 downto 0);
	signal flag                                  : std_logic_vector (83 downto 0);
	
	
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--
 
 
	 --==========--
	 -- COUNTER3 --
	 --==========--
	 
	 counter3: entity work.counter3
		port map(
			CLK                                   => CLK_I,
			COUNT_O                               => count	
		);
	 
	 
   main: process(RESET_I, CLK_I)
   begin
      if RESET_I = '1' then
         MATCHFLAG_O                            <= '0';
			
      elsif rising_edge(CLK_I) then   			
         MATCHFLAG_O                            <= '0';
			
			
         -- if DATA_I(7 downto 0) = MATCH_PATTERN then
			if count = "11" then
				if RXDATA_O (83 downto 0) <= flag (83 downto 0) then	
					flag <= TXDATA_I;				
					MATCHFLAG_O                         <= '1'; 				
				end if;					
         end if;   
      end if;   
   end process;  
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--