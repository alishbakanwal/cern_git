--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   08/12/2011																					
-- Project Name:			sram_flash_buffers																		
-- Module Name:   		sram_flash_buffers							 											
-- 																															
-- Language:				VHDL'93																						
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
use work.system_flash_sram_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity sram_flash_buffers is	
	port (
		-- Control:		
		RESET_I										: in  std_logic;
		FLASH_SELECT_I								: in  std_logic;	-- 0: SRAM2, 1: FLASH	
		-- Logic Fabric side:		
			-- SRAM1:
			SRAM1_I									: in  wSramR;
			SRAM1_O									: out rSramR;					
			-- SRAM2:	
			SRAM2_I									: in  wSramR;
			SRAM2_O									: out rSramR;					
			-- FLASH:	
			FLASH_I									: in  wFlashR;	
			FLASH_O									: out rFlashR;
		-- Buffers side:			
		SRAM1_ADDR_O								: out   std_logic_vector(20 downto  0);	
		SRAM1_DATA_IO								: inout std_logic_vector(35 downto  0);		
		SRAM2_ADDR_O								: out   std_logic_vector(20 downto  0);	
		SRAM2_DATA_IO								: inout std_logic_vector(35 downto  0);		
		FPGA_A							         : out   std_logic_vector(22 downto 21);   -- FLASH use only
      FPGA_RS							         : out   std_logic_vector( 1 downto  0);   -- 
      SRAM_CLK_O									: out   std_logic_vector( 1 to  2);
		SRAM_CE1_B_O								: out   std_logic_vector( 1 to  2);	-- Chip Enable			
		SRAM_CEN_B_O								: out   std_logic_vector( 1 to  2);	-- Clock Enable		
		SRAM_OE_B_O									: out   std_logic_vector( 1 to  2);
		SRAM_WE_B_O									: out   std_logic_vector( 1 to  2);
		SRAM_MODE_O									: out   std_logic_vector( 1 to  2);	-- Burst Mode
		SRAM_ADV_LD_O								: out   std_logic_vector( 1 to  2);			
		SRAM2_CE2_O									: out   std_logic	-- Chip Enable 2 (Only SRAM2 and FLASH)
	);
end sram_flash_buffers;
architecture structural of sram_flash_buffers is	
	--======================== Signal Declarations ========================--	
	signal data_from_memory						: array_2x36bit;
	signal data_from_fpga						: array_2x36bit;
	signal tristateCtrl							: std_logic_vector(1 to 2);
	signal dataIo_from_iobuf					: array_2x36bit;
	signal addr_from_obuf						: array_2x21bit;	
	signal addr_from_fpga						: array_2x21bit;
	signal ce1_b_from_fpga						: std_logic_vector(1 to 2);
	signal cen_b_from_fpga						: std_logic_vector(1 to 2);
	signal oe_b_from_fpga						: std_logic_vector(1 to 2);
	signal we_b_from_fpga						: std_logic_vector(1 to 2);	
	signal clk_from_oddr							: std_logic_vector(1 to 2);
	signal clk_from_fpga							: std_logic_vector(1 to 2);
	signal ce2_control							: std_logic;
	--=====================================================================--	
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--
	--========================= Port Assignments ==========================--
	SRAM_MODE_O										<= (SRAM1_I.mode, SRAM2_I.mode); 
	SRAM_ADV_LD_O									<= (SRAM1_I.adv_ld, SRAM2_I.adv_ld); 
	--=====================================================================--	
	--================ Combinatorial logic and Buffers ====================--	
	-- Data:
	sram1_sram2flash_dataIoBuf_generate: for i in 1 to 2 generate	
		dataIoBuf_generate: for j in 0 to 35 generate
			dataIoBuf: IOBUF
				generic map (
					CAPACITANCE 					=> "LOW",
					DRIVE 							=> 24,
					IBUF_DELAY_VALUE 				=> "0",
					IBUF_LOW_PWR 					=> FALSE,
					IFD_DELAY_VALUE  				=> "AUTO",
					IOSTANDARD 						=> "LVCMOS25",
					SLEW 								=> "FAST")
				port map (				
					O 									=> data_from_memory(i)(j),
					IO 								=> dataIo_from_iobuf(i)(j),   
					I 									=> data_from_fpga(i)(j),    
					T 									=> tristateCtrl(i)															
				);	
		end generate;
	end generate;
	SRAM1_DATA_IO									<= dataIo_from_iobuf(1); 
	SRAM2_DATA_IO									<= dataIo_from_iobuf(2);	
	tristateCtrl(1)								<= SRAM1_I.tristateCtrl;
	tristateCtrl(2)								<= FLASH_I.tristate	  					when FLASH_SELECT_I = '1'						
															else SRAM2_I.tristateCtrl;
	data_from_fpga(1)								<= SRAM1_I.data;
	data_from_fpga(2)								<= x"00000" & FLASH_I.data	  			when FLASH_SELECT_I = '1'
															else SRAM2_I.data;
	SRAM1_O.data                        	<= data_from_memory(1);
	SRAM2_O.data                        	<= data_from_memory(2) 		  			when FLASH_SELECT_I = '0'
															else (others => '0');
	FLASH_O.data                        	<= data_from_memory(2)(15 downto 0) when FLASH_SELECT_I = '1'
															else (others => '0');	
	-- Address:
	sram1_sram2flash_addrObuf_generate: for i in 1 to 2 generate	
		addrObuf_generate: for j in 0 to 20 generate
			addrObuf: OBUF
				generic map (
					CAPACITANCE 					=> "LOW",
					DRIVE 							=> 24,
					IOSTANDARD 						=> "LVCMOS25",
					SLEW 								=> "FAST")
				port map (				
					O 									=> addr_from_obuf(i)(j),    
					I 									=> addr_from_fpga(i)(j)    
				);				
		end generate;	
	end generate;	
	addr_from_fpga(1)								<= SRAM1_I.addr;
	addr_from_fpga(2)								<= FLASH_I.addr(20 downto 0) when FLASH_SELECT_I = '1'
															else SRAM2_I.addr;	
	
	SRAM1_ADDR_O									<= addr_from_obuf(1);
	SRAM2_ADDR_O									<= addr_from_obuf(2);
	
   -- FLASH A21-A22 and RS0-RS1:
	flash_a21_a22_generate: for i in 21 to 22 generate			
     flash_a21_a22Obuf: OBUF
         generic map (
            CAPACITANCE 					=> "LOW",
            DRIVE 							=> 24,
            IOSTANDARD 						=> "LVCMOS25",
            SLEW 								=> "FAST")
         port map (				
            O 									=> FPGA_A(i),    
            I 									=> FLASH_I.addr(i)    
         );	
 	end generate;           
   flash_rs0_rs1_generate: for i in 0 to 1 generate
      flash_rs0_rs1Obuf: OBUF
         generic map (
            CAPACITANCE 					=> "LOW",
            DRIVE 							=> 24,
            IOSTANDARD 						=> "LVCMOS25",
            SLEW 								=> "FAST")
         port map (				
            O 									=> FPGA_RS(i),    
            I 									=> FLASH_I.addr(21+i)     
         );				
	end generate;	
 
   -- Control:
	sram1_sram2flash_ctrlObuf_generate: for i in 1 to 2 generate				
		ce1_obuf: OBUF		
			generic map (		
				CAPACITANCE 						=> "LOW",
				DRIVE 								=> 24,
				IOSTANDARD 							=> "LVCMOS25",
				SLEW 									=> "FAST")
			port map (				
				O 										=> SRAM_CE1_B_O(i),    
				I 										=> ce1_b_from_fpga(i)
			);	
		ce1_b_from_fpga(1)						<= SRAM1_I.ce1_b;
		ce1_b_from_fpga(2)						<= FLASH_I.l_b 			when FLASH_SELECT_I = '1'
															else SRAM2_I.ce1_b;
		
		cen_b_obuf: OBUF		
			generic map (		
				CAPACITANCE 						=> "LOW",
				DRIVE 								=> 24,
				IOSTANDARD 							=> "LVCMOS25",
				SLEW 									=> "FAST")
			port map (				
				O 										=> SRAM_CEN_B_O(i),     
				I 										=> cen_b_from_fpga(i)
			);				
		cen_b_from_fpga(1)						<= SRAM1_I.cen_b;	
		cen_b_from_fpga(2)						<= SRAM2_I.cen_b;	
		
		oe_b_obuf: OBUF
			generic map (
				CAPACITANCE 						=> "LOW",
				DRIVE 								=> 24,
				IOSTANDARD 							=> "LVCMOS25",
				SLEW 									=> "FAST")
			port map (				
				O 										=> SRAM_OE_B_O(i),     
				I 										=> oe_b_from_fpga(i)
			);	
		oe_b_from_fpga(1)							<= SRAM1_I.cen_b; 
		oe_b_from_fpga(2)							<= FLASH_I.g_b 			when FLASH_SELECT_I = '1'
															else SRAM2_I.oe_b;
				
		we_b_obuf: OBUF		
			generic map (		
				CAPACITANCE 						=> "LOW",
				DRIVE 								=> 24,
				IOSTANDARD 							=> "LVCMOS25",
				SLEW 									=> "FAST")
			port map (			
				O 										=> SRAM_WE_B_O(i),     
				I 										=> we_b_from_fpga(i)
			);	
		we_b_from_fpga(1)							<= SRAM1_I.we_b; 
		we_b_from_fpga(2)							<= FLASH_I.w_b 			when FLASH_SELECT_I = '1'
															else SRAM2_I.we_b;	
	end generate;			
			
	ce2_obuf: OBUF		-- Chip Enable 2 (Only SRAM2 and FLASH)
		generic map (		
			CAPACITANCE 							=> "LOW",
			DRIVE 									=> 24,
			IOSTANDARD 								=> "LVCMOS25",
			SLEW 										=> "FAST")
		port map (					
			O 											=> SRAM2_CE2_O,    
			I 											=> ce2_control
		);
	ce2_control										<= '0' when (FLASH_SELECT_I = '1' and FLASH_I.e_b = '0') 								
															else '1';
															
	-- SRAM clock invertion:	
	--	
	-- (This trick with a DDR primitive is used to avoid the use of a not gate. If a not gate was used,  
	-- then there would be a clock using LUTs and going through the fabric instead of the dedicated clock 
	-- lanes(increasing the jitter))
	--
	-- (Note!!! The reference clock is inverted to be able to provide data to the SRAM for being 
	-- clocked by the rising edge of the Clk Out. The rising edge of the reference clk is used
	-- for clocking the data which comes from the FPGA)
	--	
	sramClockInverter_generate: for i in 1 to 2 generate
		sramClockInverter: ODDR
			generic map(
				DDR_CLK_EDGE 						=> "SAME_EDGE", 			-- "OPPOSITE_EDGE" or "SAME_EDGE" 
				INIT 									=> '0',   					-- Initial value for Q port ('1' or '0')
				SRTYPE 								=> "ASYNC") 				-- Reset Type ("ASYNC" or "SYNC")
			port map (		
				Q 										=> clk_from_oddr(i),		-- 1-bit DDR output
				C 										=> clk_from_fpga(i),		-- 1-bit clock input
				CE 									=> '1',  					-- 1-bit clock enable input
				D1 									=> '0',  					-- 1-bit data input (positive edge)
				D2 									=> '1',  					-- 1-bit data input (negative edge)
				R 										=> RESET_I,					-- 1-bit reset input
				S 										=> '0'    					-- 1-bit set input
			);				
		clk_from_fpga(1)							<= SRAM1_I.clk;
		clk_from_fpga(2)							<= SRAM2_I.clk;		
		
		clkBuf: OBUF	
			generic map (	
				CAPACITANCE 						=> "LOW",
				DRIVE 								=> 24,
				IOSTANDARD 							=> "LVCMOS25",
				SLEW 									=> "FAST")
			port map (				
				O 										=> SRAM_CLK_O(i),
				I 										=> clk_from_oddr(i)  	-- Note!!! Inverted clock   
			);
	end generate;
	--=====================================================================--					
end structural;
--=================================================================================================--
--=================================================================================================--