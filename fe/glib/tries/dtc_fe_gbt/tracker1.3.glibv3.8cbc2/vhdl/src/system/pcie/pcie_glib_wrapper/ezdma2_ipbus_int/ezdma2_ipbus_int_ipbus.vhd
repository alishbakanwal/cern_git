--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	10/07/2012		 																			--
-- Project Name:				pcie_glib																					--
-- Module Name:   		 	ezdma2_ipbus_int_ipbus				 													--
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
-- Custom libraries and packages:
use work.ipbus.all;
use work.system_pcie_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity ezdma2_ipbus_int_ipbus is
	port (	
		-- General reset and clock:
		RESET_I 											: in std_logic;		
	   IPBUS_CLK_I										: in std_logic;
		-- Status:				
		BUSY_O											: out std_logic;		
		-- Ports from/to PCIe clock domain:			
		CDC_IPBUS_ERROR_O								: out std_logic;
		CDC_IPBUS_TIMEOUT_O							: out std_logic;		
		CDC_SLAVE_WR_I									: in  std_logic;	
		CDC_SLAVE_RD_I									: in  std_logic;	
		CDC_DWCOUNT_I									: in  std_logic_vector (10 downto 0);	
		CDC_IPBUS_ADDR_I								: in  std_logic_vector (31 downto 0);	
		CDC_WR_FIFO_EMPTY_I							: in  std_logic;	
		CDC_WR_FIFO_RE_O								: out std_logic;
		CDC_WR_FIFO_DATA_I							: in  std_logic_vector (63 downto 0);					
		CDC_RD_FIFO_WE_O								: out std_logic;		
	   CDC_RD_FIFO_DATA_O							: out std_logic_vector (63 downto 0);					
		CDC_RD_IPBUS_RDY_O							: out std_logic;	
		-- IPbus:				
		IPBUS_I											: in  ipb_rbus;		
		IPBUS_O											: out ipb_wbus			
	);		
end ezdma2_ipbus_int_ipbus;
architecture Behavioral of ezdma2_ipbus_int_ipbus is
	--============================ Declarations ===========================--		
	signal slv_wr_busy								: std_logic;
	signal slv_rd_busy								: std_logic;
	--=====================================================================--
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--		
	--============================ User Logic =============================--
	-- Bussy OR gate:
	BUSY_O												<= slv_wr_busy or slv_rd_busy;

	-- Control process:
	ctrl_process: process(RESET_I, IPBUS_CLK_I)
		-- General:		
		variable dwcount								: unsigned(10 downto 0);
		variable slv_addr								: unsigned(31 downto 0);	
		variable addr_top								: unsigned(31 downto 0);	
		variable timer 								: integer range 0 to IPBUS_TIMEOUT;
		-- Slave Write:			
		variable wr_state								: T_ezdma2ipbus_ipbus_wr_state;		
		variable slv_wr_init							: boolean;
		-- Slave Read:			
		variable rd_state								: T_ezdma2ipbus_ipbus_rd_state;		
--		variable rd_fifo_rdy							: integer range 0 to 1023;		
	begin					
		if RESET_I = '1' then			
			-- General:				
			dwcount										:= (others => '0');
			slv_addr										:= (others => '0');
			addr_top										:= (others => '0');	
			timer											:= 0;
			CDC_IPBUS_ERROR_O 						<= '0';
			CDC_IPBUS_TIMEOUT_O 						<= '0';
			-- IPbus:	               			                                   			                                                  
			IPBUS_O.ipb_write  						<= '0';		
			IPBUS_O.ipb_addr							<= (others => '0');	
			IPBUS_O.ipb_wdata							<= (others => '0');	
			IPBUS_O.ipb_strobe 						<= '0';
			-- Slave Write:			
			wr_state										:= e0_idle;			
			slv_wr_init									:= true;
			slv_wr_busy									<= '0';	
			CDC_WR_FIFO_RE_O							<= '0';	    
			-- Slave Read:			
			rd_state										:= e0_idle;		
			slv_rd_busy									<= '0';	
--			rd_fifo_rdy									:= 0;
			CDC_RD_FIFO_WE_O							<= '0';			
			CDC_RD_FIFO_DATA_O						<= (others => '0');	
			CDC_RD_IPBUS_RDY_O						<= '0';			
		elsif rising_edge(IPBUS_CLK_I) then				
		
		-- Slave Write control:					
			case wr_state is			
				when e0_idle =>					
					if CDC_SLAVE_WR_I = '1' and slv_rd_busy = '0' then				
						wr_state							:= e1_read_wr_fifo;
						slv_wr_busy						<= '1';
						dwcount							:= unsigned(CDC_DWCOUNT_I);			
						slv_addr							:= unsigned(CDC_IPBUS_ADDR_I);
						addr_top							:= unsigned(CDC_IPBUS_ADDR_I) + (dwcount - 1);
					end if;						
				when e1_read_wr_fifo =>								
					if CDC_WR_FIFO_EMPTY_I = '0' then					
						wr_state							:= e2_fifo_dly;							
						CDC_WR_FIFO_RE_O				<= '1';						
					end if;			
				when e2_fifo_dly =>					
					wr_state								:= e3_write_ipbus;
					CDC_WR_FIFO_RE_O					<= '0';			
				when e3_write_ipbus =>			
					CDC_WR_FIFO_RE_O					<= '0';
					if IPBUS_I.ipb_err = '1' then
						wr_state 						:= e4_write_disable;						
						IPBUS_O.ipb_strobe 			<= '0';
						CDC_IPBUS_ERROR_O 			<= '1';
					elsif IPBUS_I.ipb_ack = '1' or slv_wr_init = true then						
						if slv_addr > addr_top then
							wr_state						:= e4_write_disable;
							IPBUS_O.ipb_strobe		<= '0';														
						else							
							wr_state						:= e3_write_ipbus;
							slv_wr_init					:= false;
							IPBUS_O.ipb_write 		<= '1';	
							IPBUS_O.ipb_strobe		<= '1';								
							IPBUS_O.ipb_addr			<= std_logic_vector(slv_addr);							
							if slv_addr(0) = '0' then
								IPBUS_O.ipb_wdata		<= CDC_WR_FIFO_DATA_I(31 downto  0);
							elsif slv_addr(0) = '1' then
								IPBUS_O.ipb_wdata		<= CDC_WR_FIFO_DATA_I(63 downto 32);
								if slv_addr < addr_top then
									CDC_WR_FIFO_RE_O	<= '1';
								end if;
							end if;
							slv_addr						:= slv_addr + 1;		
							timer 						:= 0;						
						end if;			
					else
						if timer = IPBUS_TIMEOUT then
							wr_state 					:= e4_write_disable;																										
							IPBUS_O.ipb_strobe 		<= '0';
							CDC_IPBUS_TIMEOUT_O 		<= '1';		
						else	
							wr_state						:= e3_write_ipbus;							
							timer 						:= timer + 1;
						end if;							
					end if;																													
				when e4_write_disable =>	
					wr_state 							:= e0_idle;
					slv_wr_init							:= true;		
					slv_wr_busy							<= '0';
					CDC_IPBUS_ERROR_O 				<= '0';
					CDC_IPBUS_TIMEOUT_O 				<= '0';
					timer 								:= 0;						
               dwcount								:= (others => '0');					             
					slv_addr								:= (others => '0');
               addr_top								:= (others => '0');					
					IPBUS_O.ipb_write  				<= '0';	 
					IPBUS_O.ipb_addr					<= (others => '0');					
					IPBUS_O.ipb_wdata					<= (others => '0');										
			end case;			
				
			-- Slave Read control:				
			case rd_state is			
				when e0_idle =>					
					if CDC_SLAVE_RD_I = '1' and slv_wr_busy = '0' then				
						rd_state							:= e1_initial_strobe;
						slv_rd_busy						<= '1';
						dwcount							:= unsigned(CDC_DWCOUNT_I);	
						slv_addr							:= unsigned(CDC_IPBUS_ADDR_I);
						addr_top							:= unsigned(CDC_IPBUS_ADDR_I) + (dwcount - 1);
--						rd_ipbus_rdy					:= RD_IPBUS_RDY; -- MBM (To do...)
					end if;													   
				when e1_initial_strobe =>								  
					rd_state								:= e2_read_cycle;
					IPBUS_O.ipb_write  				<= '0';	
					IPBUS_O.ipb_addr					<= std_logic_vector(slv_addr);							
					IPBUS_O.ipb_strobe 				<= '1';				
				when e2_read_cycle =>									
					CDC_RD_FIFO_WE_O					<= '0';					
					if IPBUS_I.ipb_err = '1' then
						rd_state 						:= e3_read_disable;						
						IPBUS_O.ipb_strobe 			<= '0';
						CDC_IPBUS_ERROR_O 			<= '1';
					elsif IPBUS_I.ipb_ack = '1' then						
						if slv_addr(0) = '0' then
							CDC_RD_FIFO_DATA_O(31 downto  0)		<= IPBUS_I.ipb_rdata;
							if slv_addr = addr_top then
							  CDC_RD_FIFO_WE_O						<= '1';	 
							end if;								
						elsif slv_addr(0) = '1' then
							CDC_RD_FIFO_DATA_O(63 downto 32)		<= IPBUS_I.ipb_rdata;								
							CDC_RD_FIFO_WE_O							<= '1';	 																	
						end if;													
						if slv_addr = addr_top then
							rd_state 					:= e3_read_disable;
							IPBUS_O.ipb_strobe 		<= '0';
							CDC_RD_IPBUS_RDY_O		<= '1';
						else
							rd_state						:= e2_read_cycle;
							slv_addr						:= slv_addr + 1;
							IPBUS_O.ipb_addr			<= std_logic_vector(slv_addr);
							timer 						:= 0;						
						end if;						
--						if slv_addr = rd_ipbus_rdy then
--							CDC_RD_IPBUS_RDY_O		<= '1';
--						else
--							CDC_RD_IPBUS_RDY_O		<= '0';
--						end if;												
					else
						if timer = IPBUS_TIMEOUT then
							rd_state 					:= e3_read_disable;														
							IPBUS_O.ipb_strobe 		<= '0';
							CDC_IPBUS_TIMEOUT_O 		<= '1';		
						else
							rd_state						:= e2_read_cycle;
							timer 						:= timer + 1;
						end if;							
					end if;
				when e3_read_disable =>								
					rd_state 							:= e0_idle;					
					slv_rd_busy							<= '0';
					CDC_IPBUS_ERROR_O 				<= '0';					
					CDC_IPBUS_TIMEOUT_O 				<= '0';
					timer 								:= 0;	
               dwcount								:= (others => '0');				            
					slv_addr								:= (others => '0');
               addr_top								:= (others => '0');					
					IPBUS_O.ipb_addr					<= (others => '0');									
					CDC_RD_IPBUS_RDY_O				<= '0';
					CDC_RD_FIFO_DATA_O				<= (others => '0');					
					CDC_RD_FIFO_WE_O					<= '0';		
			end case;
		end if;
	end process;
--=====================================================================--
end Behavioral;
--=================================================================================================--
--=================================================================================================--