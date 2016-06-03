--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   28/01/2013  	 																			
-- Project Name:			bert                              													
-- Module Name:   		pattern_detector						 													
-- 																															
-- Language:				VHDL'93																						
--																																
-- Target Devices: 		No target device																			
-- Tool versions: 		ISE 13.2																						
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
-- Xilinx devices library:
library unisim;
use unisim.vcomponents.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity pattern_detector is
	generic (			
      N                                : integer := 84
	);	               
	port (	               
		RESET_I						         : in  std_logic;
		CLK_I							         : in  std_logic;
      DATA_I	   				         : in  std_logic_vector(N-1 downto 0);
      MATCHFLAG_O					         : out std_logic;	
      -- Control/Status registers interface: 
      CLK_IF_I						         : in  std_logic;
      ENABLE_IF_I                      : in  std_logic;
      CHECKWIDTH_IF_I                  : in  std_logic_vector(  7 downto 0); -- Number of bits to compare
		PATTERN_IF_I		               : in  std_logic_vector(N-1 downto 0);
      DEASSERTDELAY_IF_I               : in  std_logic_vector(  7 downto 0)
	);
end pattern_detector;
architecture structural of pattern_detector is	
	--======================== Signal Declarations ========================--
   signal enable					         : std_logic;
   signal checkwidth					      : std_logic_vector(  7 downto 0);
   signal pattern			               : std_logic_vector(N-1 downto 0);
   signal deassertdelay					   : std_logic_vector(  7 downto 0);
   signal matchflag					      : std_logic;	   
 	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--
 	--========================= Port Assignments ==========================-- 
   MATCHFLAG_O                         <= matchflag;
 	--=====================================================================--  
   --============================ User Logic =============================--
	main_process: process(RESET_I, CLK_I)
      variable cw                      : integer range 0 to 255;
      variable deassert_timer          : unsigned(7 downto 0);
	begin
		if RESET_I = '1' then
			cw                            :=  0;           
         deassert_timer                := (others => '0'); 
         matchflag							<= '0';
		elsif rising_edge(CLK_I) then
			cw                            := to_integer(unsigned(checkwidth));         
         -- Pattern check and flag assertion:
         if enable = '1' then
            if DATA_I(cw downto 0) = pattern(cw downto 0) then
               matchflag			      <= '1';	               
            end if;                           
         end if;
         -- Deassert flag:
         if matchflag = '1' then
            if deassert_timer = 0 then
               matchflag				   <= '0';	
               deassert_timer          := unsigned(deassertdelay);
            else  
               deassert_timer          := deassert_timer - 1;
            end if;
         end if;
      end if;	
	end process;		
	--=====================================================================--	
   --===================== Component Instantiations ======================--   
	control_cdc: entity work.dist_mem_gen_v5_1
      port map (
         CLK						         => CLK_IF_I,
         A							         => "0000",        
         D(  7 downto  0)					=> DEASSERTDELAY_IF_I,         
         D( 15 downto  8)					=> CHECKWIDTH_IF_I, 
         D( 16)                        => ENABLE_IF_I,         
         D(127 downto 17)					=> (others => '0'),        
         WE							         => '1',
         ------------------------------         
         DPRA						         => "0000",
         QDPO_CLK					         => CLK_I,
         QDPO(  7 downto  0)		      => deassertdelay,
         QDPO( 15 downto  8)		      => checkwidth,
         QDPO( 16)                     => enable,
         QDPO(127 downto 17)		      => open
      );
   pattern_cdc: entity work.dist_mem_gen_v5_1
      port map (
         CLK						         => CLK_IF_I,
         A							         => "0000",        
         D(N-1 downto  0)					=> PATTERN_IF_I,
         D(127 downto N)					=> (others => '0'),
         WE							         => '1',
         ------------------------------         
         DPRA						         => "0000",
         QDPO_CLK					         => CLK_I,
         QDPO(N-1 downto  0)		      => pattern,
         QDPO(127 downto  N)		      => open
      );   
end structural;
--=================================================================================================--
--=================================================================================================--