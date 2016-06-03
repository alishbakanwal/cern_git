--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	10/07/2012		 																			--
-- Project Name:				pcie_glib																					--
-- Module Name:   		 	ezdma2_ipbus_int_ezdma2				 													--
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
-- * This interface is able to work with 62.5, 125, or 250 MHz PCIe clocks.								--
--																																	--
-- * Supported Transactions: Memory Read/Memory Write (DW or Burst)											--
--																																	--
-- * Data is sent/received by PCIe trough 64 bit data frames as shown below:								--
--																																	--
--	  [32bit data1][32bit data0]																							--
--	  [32bit data3][32bit data2]																							--
--   [32bit data4][xxxxxxxxxxx]																							--
--																																	--
--	* Note!!! Address must be DW-aligned 																				--
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
use work.system_pcie_package.all;
use work.ezdma2_ipbus_int_addr_enc.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity ezdma2_ipbus_int_ezdma2 is
	port (
		-- General reset and clock:
		RESET_I 									: in  std_logic;										
		PCIE_CLK_I 								: in  std_logic;	                          
		-- EZDMA2:				
	   CFG_LTSSM_I								: in  std_logic_vector(  4 downto 0);
	   CFG_LINKCSR_I 							: in  std_logic_vector( 31 downto 0);				
		-- Status:		
		RETRAINING_CNT_O						: out std_logic_vector(  7 downto 0);
		LINK_RDY_O								: out std_logic;    
		BUSY_O									: out std_logic;		
		-- Slave interface: 
	   SLV_BAR_I 								: in  std_logic_vector(  6 downto 0);	
		SLV_ADDR_I 								: in  std_logic_vector( 63 downto 0);  		
	   SLV_READREQ_I 							: in  std_logic;                             
	   SLV_WRITEREQ_I 						: in  std_logic;
	   SLV_BYTECOUNT_I						: in  std_logic_vector( 12 downto 0);
		SLV_DWCOUNT_I 							: in  std_logic_vector( 10 downto 0);		
	   SLV_WRITE_I 							: in  std_logic;                             
	   SLV_DATAOUT_I 							: in  std_logic_vector( 63 downto 0);         
		SLV_CPLADDR_I 							: in  std_logic_vector( 31 downto 0);        
	   SLV_CPLPARAM_I 						: in  std_logic_vector(  7 downto 0);         
	   SLV_ACCEPT_O 							: out std_logic;                            
	   SLV_ABORT_O 							: out std_logic;                           
		SLV_UR_O									: out std_logic;
		-- General DMA:			            		                                           
	   DMA_RD_I									: in  std_logic;                            
		DMA_RDCHANNEL_I 						: in  std_logic_vector( 15 downto 0);	 
		DMA_RDDATA_O  							: out std_logic_vector( 63 downto 0);	    
		-- DMA0:
		DMA0_REGIN_O							: out std_logic_vector(127 downto 0);     
	   DMA0_PARAM_O 							: out std_logic_vector( 23 downto 0);      
	   DMA0_CONTROL_O 						: out std_logic_vector(  5 downto 0);       
	   DMA0_STATUS_I 							: in  std_logic_vector(  3 downto 0);       
	   DMA0_FIFOCNT_O 						: out std_logic_vector( 12 downto 0);	    
		-- Ports from/to IPbus clock domain:                   
		CDC_SLAVE_WR_O							: out std_logic;	                         
		CDC_SLAVE_RD_O							: out std_logic;		                        
		CDC_DWCOUNT_O							: out std_logic_vector( 10 downto 0);	      
		CDC_IPBUS_ADDR_O						: out std_logic_vector( 31 downto 0);	      
		CDC_IPBUS_BUSY_I						: in  std_logic;
		CDC_IPBUS_ERROR_I						: in  std_logic;
		CDC_IPBUS_TIMEOUT_I					: in  std_logic;                           
		CDC_WR_FIFO_WE_O						: out std_logic;		                        
		CDC_SLV_DATAOUT_O						: out std_logic_vector( 63 downto 0);		   	                        
		CDC_RD_IPBUS_RDY_I					: in  std_logic;		
		CDC_RD_FIFO_EMPTY_I					: in  std_logic;	
		CDC_RD_FIFO_RE_O						: out std_logic;	
		CDC_RD_FIFO_DATA_I  					: in  std_logic_vector( 63 downto 0)	      
	);                                                                         
end ezdma2_ipbus_int_ezdma2;
architecture Behavioral of ezdma2_ipbus_int_ezdma2 is
	--============================ Declarations ===========================--
	-- Signals:
	signal cfg_ltssm_r						: std_logic_vector(4 downto 0);
	signal busy									: std_logic;	
	-- Constants:	
	constant DMA0_READ_LATENCY    		: std_logic_vector(1 downto 0) := "01"; 
	--
	-- 00: data is available on next clock cycle
	-- 01: data is available 2 clock cycles later (Correct for this module)
	-- 10: data is available 3 clock cycles later
	-- 11: data is available 4 clock cycles later	
	--
	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--================= Port Assignments and User Logic ===================--	
	-- General:		
	BUSY_O										<= busy;		
	SLV_ABORT_O									<= '0';	-- This module never aborts transactions  
	SLV_UR_O										<= '0';	-- when requested nor treats transactions
																-- as unsupported.
																-- Instead, a Completion Abort (CA) is 
																-- sent when IPbus ERROR or TIMEOUT. 		
																-- (See line 308)	
	-- Slave Write:							
	CDC_WR_FIFO_WE_O							<= SLV_WRITE_I;
	CDC_SLV_DATAOUT_O							<= SLV_DATAOUT_I;
			
	-- Slave Read:				
	CDC_RD_FIFO_RE_O 							<= DMA_RD_I and DMA_RDCHANNEL_I(0);
	DMA_RDDATA_O 								<= CDC_RD_FIFO_DATA_I;		 		
	DMA0_FIFOCNT_O								<= "1000000000000";	-- (4096 Bytes)
																				--	(In this module, FIFO is always
																				-- able to provide data)	
	-- DMA0 programming to preform completions:
		-- Local address (Not used in FIFO Mode):  
		DMA0_REGIN_O(127 downto 96)		<= (others => '0');
		-- Transfer Size:
		DMA0_REGIN_O(95 downto 64) 		<= "000" & x"0000" & SLV_BYTECOUNT_I;
		-- PCI address:
		DMA0_REGIN_O(63 downto 0) 			<= x"00000000" & SLV_CPLADDR_I;
	-- Set DMA0 parameters:
		-- Completion parameters:
		DMA0_PARAM_O(23 downto 16) 		<= SLV_CPLPARAM_I;	
		-- Reserved bits:
		DMA0_PARAM_O(15 downto 12) 		<= "0000";
		-- Command (Completion command):
		DMA0_PARAM_O(11 downto 8)  		<= "0100";
		-- Byte-enables are not used in completions:
		DMA0_PARAM_O(7 downto 4)   		<= "0000";
		-- Read Latency[3:2], Reserved[1], DMA Mode[0] (FIFO Mode)  			
		DMA0_PARAM_O(3 downto 0)   		<= DMA0_READ_LATENCY & "0" & "0";	

	--=================--
	-- Control process --
	--=================--
	
	ctrl_process: process(RESET_I, PCIE_CLK_I)
		-- General:
		variable retraining_cnt				: unsigned(7 downto 0);
		-- Read or Write:	
		variable rd_wr_state					: T_ezdma2ipbus_ezdma2_rd_wr_state;	
		-- Slave Write:	
		variable wr_state						: T_ezdma2ipbus_ezdma2_wr_state;		
		variable start_write					: boolean;	   	
		-- Slave Read:	
		variable rd_state						: T_ezdma2ipbus_ezdma2_rd_state;			
		variable start_read					: boolean;		
	begin			
		if RESET_I = '1' then	
			-- General:	
			cfg_ltssm_r							<= (others => '0');	
			retraining_cnt						:= (others => '0');			
			RETRAINING_CNT_O					<= (others => '0');	
			LINK_RDY_O							<= '0';
			busy									<= '0';			
			SLV_ACCEPT_O						<= '0';	
			CDC_IPBUS_ADDR_O					<= (others => '0');	
			CDC_DWCOUNT_O						<= (others => '0');			
			-- Read or Write:	
			rd_wr_state							:= e0_idle;
			-- Slave Write:				
			CDC_SLAVE_WR_O						<= '0';			
			wr_state								:= e0_idle;
			start_write							:= false;					
			-- Slave Read:	
			CDC_SLAVE_RD_O						<= '0';			
			wr_state								:= e0_idle;
			start_read							:= false;
			DMA0_CONTROL_O 					<= (others => '0'); 			
		elsif rising_edge(PCIE_CLK_I) then					
			
			--=============--	
			--	Link Status --
			--=============--	
			
			-- Retraining counter:
			--
			-- (LTSSM - Link Training and Status State Machine)
			--
			-- This counter is incremented each time link is retrained because
			-- of an error ("L0 -> Recovery State" transition is detected).
			-- This can help diagnose instable link
			--
			cfg_ltssm_r 						<= CFG_LTSSM_I;	
			if (CFG_LTSSM_I = "01100" and cfg_ltssm_r = "01111") or
				(CFG_LTSSM_I = "01011" and cfg_ltssm_r = "10000")
			then
	 			retraining_cnt 				:= retraining_cnt + 1;
				RETRAINING_CNT_O				<= std_logic_vector(retraining_cnt);
	 		end if;
	
			-- Link initialized:
			--
			-- Indicate that link is initialised when "Negotiated Link Width" field
			-- of link control register is set.
			--	
			if unsigned(CFG_LINKCSR_I(27 downto 20)) /= 0 then
	 			LINK_RDY_O 						<= '1';
	 		else
	 			LINK_RDY_O						<= '0';
	 		end if;					
				
			--====================--	
			--	Read/Write Control --
			--====================--	
				
			-- Read or Write selection control:
			case rd_wr_state is
				when e0_idle =>
					if CDC_IPBUS_BUSY_I = '0' and busy = '0' then
						rd_wr_state 			:= e1_select;
					end if;
				-- BAR0: System Regs, DRP, ICAP, SRAM1, SRAM2 and FLASH	
				-- BAR1: User IPbus and User Wishbone	
				when e1_select =>					
					if SLV_BAR_I(0) = '1' or SLV_BAR_I(1) = '1' then			
						if SLV_WRITEREQ_I = '1' then							
							rd_wr_state			:= e0_idle;
							start_write			:= true;												
						elsif SLV_READREQ_I = '1' and DMA0_STATUS_I(3) = '0' then
							rd_wr_state			:= e0_idle;
							start_read			:= true;
						end if;					 
					end if;
			end case;					
			
			-- Slave Write Control:	(See EZDMA2 Reference Manual page 37, figure 22)				
			case wr_state is
				when e0_idle =>						
					if start_write	= true then	
						wr_state					:= e1_write_enable;												
						busy						<= '1';														
						CDC_SLAVE_WR_O			<= '1';	
						CDC_IPBUS_ADDR_O		<=	addrEnc(SLV_ADDR_I(31 downto 0), SLV_BAR_I); 			
						CDC_DWCOUNT_O			<=	SLV_DWCOUNT_I;						  					
						SLV_ACCEPT_O			<= '1';	--	Data transmission begins 2 clock						
					end if;									-- cycles after SLV_ACCEPT assertion
				when e1_write_enable =>														
					SLV_ACCEPT_O				<= '0';		
					if CDC_IPBUS_BUSY_I = '1' then	
						wr_state					:= e0_idle;	
						busy						<= '0';
						start_write				:= false;									
						CDC_SLAVE_WR_O			<= '0';
						CDC_IPBUS_ADDR_O		<=	(others => '0');
						CDC_DWCOUNT_O			<=	(others => '0');		
					end if;																																															
			end case;					
			
			-- Slave Read Control:						
			case rd_state is				
				when e0_idle =>	
					DMA0_CONTROL_O 			<= "000000"; 	
					if start_read = true then					
						rd_state					:= e1_req_data;												
						busy						<= '1';														
						CDC_SLAVE_RD_O			<= '1';	
						CDC_IPBUS_ADDR_O		<=	addrEnc(SLV_ADDR_I(31 downto 0), SLV_BAR_I); 						
						CDC_DWCOUNT_O			<=	SLV_DWCOUNT_I;				  		  		
						SLV_ACCEPT_O			<= '1';
					end if;
				when e1_req_data =>							
					SLV_ACCEPT_O				<= '0';							
					if CDC_IPBUS_BUSY_I = '1' then
						CDC_SLAVE_RD_O			<= '0';	
						CDC_IPBUS_ADDR_O		<= (others => '0');
						CDC_DWCOUNT_O			<=	(others => '0');						
					end if;
					if CDC_RD_IPBUS_RDY_I = '1' then
						rd_state					:= e2_ipbus_rdy;
					end if;
				when e2_ipbus_rdy =>						
					if CDC_RD_FIFO_EMPTY_I = '0' then
						-- Programs & starts DMA0 to perform completion as soon as 
						-- there is enough data on FIFO:	
						rd_state					:= e0_idle;		
						busy						<= '0';			
						start_read 				:= false;
						DMA0_CONTROL_O 		<= "011111"; -- "Triggers" DMA0					
					end if;
			end case;			
			
			--=========================================--
			-- IPbus ERROR and TIMEOUT errors handling --
			--=========================================--
			
			-- Slave write does not need to be stopped because its control FSM goes 
			-- directly to idle state when CDC_IPBUS_BUSY_I is asserted.
			
			if start_read = true then 		-- Completions are sent in Read Requests
				if CDC_IPBUS_ERROR_I	= '1' or CDC_IPBUS_TIMEOUT_I = '1' then
					rd_state						:= e0_idle;					
					busy							<= '0';
					start_read 					:= false;
					DMA0_CONTROL_O 			<= "100000"; -- Sends a	Completion Abort (CA)						
				end if;			
			end if;				
				
		end if;
	end process;
	--=====================================================================--
end Behavioral;
--=================================================================================================--
--=================================================================================================--