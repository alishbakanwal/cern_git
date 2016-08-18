--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   12/11/2012		 																			
-- Project Name:			pcie_demo																					
-- Module Name:   		pcie_bert_chk		 																		
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
entity pcie_bert_chk is		
	generic(
		DMA_WRCHANNEL_BIT								: in  integer := 2
	);		
	port(  		
		-- Reset and clock:	
		RESET_I											: in  std_logic;		
		DMA_CLK_I										: in  std_logic;	
		-- Control:
      ENABLE_I   					               : in  std_logic;	                            
      -- EZDMA2:						
		DMA_WRCHANNEL_I								: in  std_logic_vector( 7 downto 0);
      DMA_WRTRANS_SIZE_I					      : in  std_logic_vector(31 downto 0);
      DMA_WRSTATUS_I					            : in  std_logic_vector( 3 downto 0);
		DMA_WR_I											: in  std_logic;
		DMA_WRDATA_I									: in  std_logic_vector(63 downto 0);		
		-- PRBS:
		PRBS_RESET_O									: out std_logic;	
		PRBS_ENABLE_O									: out std_logic;	
		PRBS_DATA_VALID_I								: in  std_logic;
		PRBS_DATA_I										: in  std_logic_vector(63 downto 0);					
		-- BER test:
		BERT_RESET_I 									: in  std_logic;
		BERT_2DW_CNTR_O			                  : out std_logic_vector(28 downto 0);
      BERT_ERROR_CNTR_O  							: out std_logic_vector(31 downto 0);
		BERT_ERROR_FLAG_O								: out std_logic;
		BERT_NOERR_FLAG_O								: out std_logic;
      -- Status:
      BUSSY_O     				               : out std_logic      
	);
end pcie_bert_chk;
architecture behavioural of pcie_bert_chk is	
	--============================ Declarations ===========================--
	-- Attributes:
	-- Attributes:
   attribute S											: string; -- To avoid signal trimming for Chipscope	
	-- Signals:		
	signal pchkState 								   : T_pchkState;
	attribute S	of pchkState	               : signal is "true";   
   signal dma_wrtrans_size                   : unsigned(28 downto 0);
	attribute S	of dma_wrtrans_size	         : signal is "true";   
   signal busy             						: std_logic;
	signal prbs_enable_from_fsm					: std_logic;
	signal fifo_reset_from_fsm						: std_logic;
	signal fifo_reset									: std_logic;   
	signal wr_enable_to_dma_fifo       			: std_logic;
	signal wr_enable_to_pchk_fifo       		: std_logic;
	signal dma_fifo_rd_enable_from_fsm			: std_logic;
	signal pchk_fifo_rd_enable_from_fsm			: std_logic;
 	signal wrdata_from_dma_fifo					: std_logic_vector(63 downto 0);	  
	signal prbs_from_pchk_fifo					   : std_logic_vector(63 downto 0);	
	signal data_count_from_dma_fifo				: std_logic_vector( 4 downto 0);		
   signal start_pchk_r                       : std_logic;
 	signal start_pchk                         : std_logic;  
   signal doubleDWcntr                       : unsigned(28 downto 0);
   signal error_cntr									: unsigned(31 downto 0);  
	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--========================= Port Assignments ==========================--	
	BUSSY_O                                   <= busy;
   PRBS_ENABLE_O				                  <= busy and
                                                (prbs_enable_from_fsm or
                                                (DMA_WRCHANNEL_I(DMA_WRCHANNEL_BIT) and DMA_WR_I)); 
   BERT_2DW_CNTR_O                            <= std_logic_vector(doubleDWcntr);	
   BERT_ERROR_CNTR_O  								<= std_logic_vector(error_cntr);	
	--=====================================================================--
	--============================ User Logic =============================--
	fsm_process: process(RESET_I, DMA_CLK_I)		
      constant PRBS_FIFO_FILL_DLY            : integer := 16;  -- 128 Bytes (up to 256 Bytes)
      constant PCHK_START_DLY                : integer := 4;       
      variable timer                         : integer range 0 to PRBS_FIFO_FILL_DLY-1;      
	begin	
		if RESET_I = '1' then						
			pchkState									<= e0_idle;		
			timer                               := PRBS_FIFO_FILL_DLY-1;
         dma_wrtrans_size                    <= (others => '0');
         busy                                <= '0'; 	
			fifo_reset_from_fsm						<= '0';
			dma_fifo_rd_enable_from_fsm			<= '0';          
			pchk_fifo_rd_enable_from_fsm			<= '0';          
         start_pchk_r		                  <= '0';
         start_pchk  		                  <= '0';
         PRBS_RESET_O								<= '0';
			prbs_enable_from_fsm						<= '0'; 
			BERT_ERROR_FLAG_O							<= '0';
			doubleDWcntr                        <= (others => '0');
         error_cntr									<= (others => '0');
			BERT_NOERR_FLAG_O							<= '0';
		elsif rising_edge(DMA_CLK_I) then			
			-- Delay register:
         start_pchk_r                        <= start_pchk;         
         -- Finite State Machine (FSM):
			case pchkState is 
				when e0_idle =>		
					if BERT_RESET_I = '1' then
                  doubleDWcntr               <= (others => '0');
                  error_cntr						<= (others => '0');
						BERT_NOERR_FLAG_O				<= '0';
               end if;                  
               if ENABLE_I = '1' then
						pchkState						<= e1_fillPrbsFifo;
						busy                       <= '1';
                  doubleDWcntr               <= (others => '0');
                  error_cntr						<= (others => '0');
						BERT_NOERR_FLAG_O				<= '0';
                  prbs_enable_from_fsm			<= '1';
					end if;					
				when e1_fillPrbsFifo =>	
               if timer = 0 then
                  pchkState                  <= e2_waitTranssaction;               
                  timer                      := PCHK_START_DLY-1;
                  prbs_enable_from_fsm		   <= '0';
               else
                  timer                      := timer - 1;                   
               end if;
				when e2_waitTranssaction =>	        
               if DMA_WRSTATUS_I(3) = '1' then
                  pchkState                  <= e3_startDly;  
                  dma_wrtrans_size <= unsigned(DMA_WRTRANS_SIZE_I(31 downto 3));  -- Div by 8
               end if;                                                            -- (8 x Byte = 2DW)            
				when e3_startDly =>	           
             	if timer = 0 then 
                  pchkState                  <= e4_start; 
                  timer                      := PRBS_FIFO_FILL_DLY-1;
               else
                  timer                      := timer - 1;
               end if;
 				when e4_start =>	
               BERT_ERROR_FLAG_O			      <= '0';
               if data_count_from_dma_fifo > "00001" then                   
                  dma_fifo_rd_enable_from_fsm  <= '1'; 
                  pchk_fifo_rd_enable_from_fsm <= '1';
                  start_pchk                 <= '1';
               else
                  dma_fifo_rd_enable_from_fsm  <= '0'; 
                  pchk_fifo_rd_enable_from_fsm <= '0';
                  start_pchk                 <= '0';
               end if;         
               if start_pchk_r = '1' then
                  dma_wrtrans_size           <= dma_wrtrans_size - 1;
                  doubleDWcntr              <= doubleDWcntr + 1;
                  if wrdata_from_dma_fifo /= prbs_from_pchk_fifo then
                     BERT_ERROR_FLAG_O			<= '1';
                     error_cntr					<= error_cntr + 1;					
                  end if;
                  if error_cntr /= 0 then
                     BERT_NOERR_FLAG_O			<= '0';
                  else
                     BERT_NOERR_FLAG_O			<= '1';
                  end if;
               end if;   
               if dma_wrtrans_size = 0 then
                  pchkState                  <= e6_reset;    
               else
                 pchkState                   <= e4_start;  
               end if;              
 				when e6_reset => 
   				BERT_ERROR_FLAG_O					<= '0';      
					pchkState		   				<= e7_stop;
 					PRBS_RESET_O						<= '1';	
               fifo_reset_from_fsm           <= '1';      
            when e7_stop =>
					PRBS_RESET_O						<= '0';		
               fifo_reset_from_fsm           <= '0';      
               pchkState	   					<= e0_idle;
               busy                          <= '0';
			end case;		
		end if;		
	end process;	
	--=====================================================================--	
	--===================== Component Instantiations ======================--
	-- FIFOs:	
   dma_fifo: entity work.distributed_fifo
		port map (
			clk 								         => DMA_CLK_I,
			rst 								         => fifo_reset,
			din 								         => DMA_WRDATA_I,
			wr_en 							         => wr_enable_to_dma_fifo,
			rd_en 							         => dma_fifo_rd_enable_from_fsm,
			dout 								         => wrdata_from_dma_fifo,
			full 								         => open,
			empty 							         => open,
			data_count 						         => data_count_from_dma_fifo
      ); 
		fifo_reset					               <= RESET_I or fifo_reset_from_fsm; 
      wr_enable_to_dma_fifo                  <= busy and 
                                                (DMA_WRCHANNEL_I(DMA_WRCHANNEL_BIT) and DMA_WR_I);    
    
	pchk_fifo: entity work.distributed_fifo
		port map (
			clk 								         => DMA_CLK_I,
			rst 								         => fifo_reset,
			din 								         => PRBS_DATA_I,
			wr_en 							         => wr_enable_to_pchk_fifo,
			rd_en 							         => pchk_fifo_rd_enable_from_fsm,
			dout 								         => prbs_from_pchk_fifo,
			full 								         => open,
			empty 							         => open,
			data_count 						         => open
		);      
		fifo_reset					               <= RESET_I or fifo_reset_from_fsm; 
      wr_enable_to_pchk_fifo                 <= busy and PRBS_DATA_VALID_I; 
	--=====================================================================--	
end behavioural;
--=================================================================================================--
--=================================================================================================--