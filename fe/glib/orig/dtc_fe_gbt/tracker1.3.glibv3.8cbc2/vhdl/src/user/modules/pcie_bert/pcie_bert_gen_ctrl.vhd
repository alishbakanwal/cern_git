--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                               																				  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   05/11/2012		 																			
-- Project Name:			pcie_demo																					
-- Module Name:   		pcie_bert_gen		 																		
-- 																															
-- Target Devices: 		GLIB (Virtex 6)																			
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
-- User libraries and packages:
use work.user_pcie_bert_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity pcie_bert_gen_ctrl is		
	generic(
		DMA_RDCHANNEL_BIT								: in  integer := 2
	);		
	port(  			
		-- Reset and Clock:
      RESET_I	                              : in  std_logic;
      DMA_CLK_I                              : in  std_logic;
      -- Input Ports:						
		PCHK_BUSSY_I					            : in  std_logic;
      DMA_RDCHANNEL_I								: in  std_logic_vector( 7 downto 0);
      DMA_RDTRANS_SIZE_I			            : in  std_logic_vector(31 downto 0);
      DMA_RDSTATUS_I              				: in  std_logic_vector( 3 downto 0);
		DMA_RD_I											: in  std_logic;   
		PRBS_DATA_I										: in  std_logic_vector(63 downto 0);
		-- Output Ports:							
      PRBS_RESET_O									: out std_logic;		
      PRBS_ENABLE_O									: out std_logic;
		DMA_RDDATA_O									: out std_logic_vector(63 downto 0);
      PCHK_ENABLE_O								   : out std_logic
	);
end pcie_bert_gen_ctrl;
architecture behavioural of pcie_bert_gen_ctrl is	
	--============================ Declarations ===========================--
	-- Attributes:	
   attribute S											: string; -- To avoid signal trimming for Chipscope	
 	-- Signals:	  
   signal pgState        			            : T_pgState;
   signal dma_rdtrans_size                   : unsigned(28 downto 0);
   --=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--========================= Port Assignments ==========================--	
   PRBS_ENABLE_O                 <= (not PCHK_BUSSY_I) and
                                    (DMA_RDCHANNEL_I(DMA_RDCHANNEL_BIT) and DMA_RD_I);
   DMA_RDDATA_O                  <= PRBS_DATA_I when PCHK_BUSSY_I = '0' and
                                                     DMA_RDCHANNEL_I(DMA_RDCHANNEL_BIT) = '1'
                                    else (others => '0'); 
   --=====================================================================--    
   --============================ User Logic =============================--	  
	fsm_process: process(RESET_I, DMA_CLK_I)		
      variable PRBS_RST_DLY                  : integer := 2;
      variable timer                         : integer range 0 to PRBS_RST_DLY;
   begin					      		
      if RESET_I = '1' then   	
         pgState                 		      <= e0_idle;
         dma_rdtrans_size	                  <= (others => '0');
         timer                               := 0;
         PRBS_RESET_O          		         <= '0';
         PCHK_ENABLE_O               	      <= '0';      
      elsif rising_edge(DMA_CLK_I) then         
         case pgState is
            when e0_idle =>
               if PCHK_BUSSY_I = '0' and DMA_RDSTATUS_I(3) = '1' then
                  pgState                      <= e1_start;  
                  dma_rdtrans_size <= unsigned(DMA_RDTRANS_SIZE_I(31 downto 3)); -- Div by 8
               end if;                                                           -- (8 x Byte = 2DW)
            when e1_start =>
               if DMA_RD_I = '1' then 
                  dma_rdtrans_size           <= dma_rdtrans_size - 1;  
               end if;
               if dma_rdtrans_size = 0 then
                  pgState                    <= e2_resetPrbs; 
                  timer                      := PRBS_RST_DLY;
               end if;
            when e2_resetPrbs =>
               if timer = 0 then
                 pgState                     <= e3_enablePchk;   
                 PRBS_RESET_O                <= '1';                 
               else
                  timer                      := timer - 1;
               end if;           
            when e3_enablePchk =>
               PRBS_RESET_O                  <= '0';     
               pgState                       <= e4_stop;  
               PCHK_ENABLE_O                 <= '1';       
            when e4_stop =>           
               pgState                       <= e0_idle;  
               PCHK_ENABLE_O                 <= '0';                 
         end case; 
		end if;		
	end process;	
	--=====================================================================--	
end behavioural;
--=================================================================================================--
--=================================================================================================--