--=================================================================================================--
--================================== Test Bench Information =======================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   <day/month/year> 																			
-- Module Name:   		<module_entity_name>																		
-- Test Bench Name:		<test_bench_name>																			
--																																
-- Revision:		 		1.0 																							
--																																
-- Additional Comments: 																								
--																																
--=================================================================================================--
--=================================================================================================--

--=================================================================================================--
--=================================== Library Declarations ========================================--  
--=================================================================================================--

-- IEEE VHDL standard library:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--=================================================================================================--
--=================================================================================================--

--=================================================================================================--
--===================================== Test Bench Body ===========================================-- 
--=================================================================================================--

entity pcie_ber_chk_tb is
end pcie_ber_chk_tb;

architecture test_bench of pcie_ber_chk_tb is

	--========================= UUT Declaration ===========================--
	
	--=====================================================================--
	
	--======================== Signal Declarations ========================--
	
	-- Clock signal:	
	signal dma_clk 						: std_logic := '0';
		
	-- Reset signal:	
	signal reset							: std_logic := '0';
				
	-- Clock control signal:			
	signal stopSimulation				: boolean := false;
		
	-- Other signals:	
	signal dma_rdchannel					: std_logic_vector( 7 downto 0) := (others => '0');
	signal dma_wrchannel					: std_logic_vector( 7 downto 0) := (others => '0');
	signal dma_rdstatus					: std_logic_vector( 3 downto 0) := (others => '0');
	signal dma_wrstatus					: std_logic_vector( 3 downto 0) := (others => '0');
   signal dma_rdtrans_size		      : std_logic_vector(31 downto 0) := (others => '0');
	signal dma_wrdstatus					: std_logic_vector( 3 downto 0) := (others => '0');
   signal dma_wrtrans_size		      : std_logic_vector(31 downto 0) := (others => '0');
	signal dma_rd							: std_logic := '0';
	signal dma_wr							: std_logic := '0';
	signal dma_rdaddr						: std_logic_vector(31 downto 0) := (others => '0');
	signal dma_rddata						: std_logic_vector(63 downto 0) := (others => '0');	
	signal dma_wraddr						: std_logic_vector(31 downto 0) := (others => '0');
	signal dma_wrdata						: std_logic_vector(63 downto 0) := (others => '0');
	signal ber_cntr_reset				: std_logic := '0';
	signal dma2_status					: std_logic_vector(3 downto 0) := (others => '0');	
	signal prbs_reset 					: std_logic := '0';
	signal prbs_enable					: std_logic := '0';
   signal pdv_from_prbs					: std_logic := '0';
   signal pdata_from_prbs				: std_logic_vector(63 downto 0) := (others => '0'); 
 
	--=====================================================================--
	
	--======================= Constant Declarations =======================--
	
	-- Clock period definitions: 
   constant dma_clk_period 			: time := 4 ns;
 
	--=====================================================================--
		
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--
	
	prbs_generator: entity work.PRBS
		generic map (
			L												=> 7, 	-- PRBS type (e.g. for PRBS7 -> L=7)
			W												=> 64)  	-- Serializer data width
		port map (
			CLOCK 										=> dma_clk,
			ARESET 										=> prbs_reset or reset,
			ENABLE 										=> prbs_enable,
			SEED 											=> "0000001",
			SDV 											=> open,
			SDATA 										=> open,
			PDV 											=> pdv_from_prbs,
			PDATA 										=> pdata_from_prbs
		);
		
	--======================== UUT Instantiation ==========================--
	
	uut: entity work.pcie_ber_wrapper					
		port map (  		
			-- Reset and clock:	
			RESET_I								=>	reset,								
			DMA_CLK_I							=>	dma_clk,									
			-- Read:						
			DMA_RDCHANNEL_I					=>	dma_rdchannel,									
			DMA_RDTRANS_SIZE_I            => dma_rdtrans_size,
			DMA_RDSTATUS_I                => dma_rdstatus,
         DMA_RD_I								=>	dma_rd,									
			DMA_RDADDR_I						=>	dma_rdaddr,									
			DMA_RDDATA_O						=>	open,									
         -- Write:
			DMA_WRCHANNEL_I					=>	dma_wrchannel,								
         DMA_WRTRANS_SIZE_I            => dma_wrtrans_size,   
         DMA_WRSTATUS_I		            => dma_wrstatus,
			DMA_WR_I								=>	dma_wr,										
			DMA_WRADDR_I						=>	dma_wraddr,								
			DMA_WRDATA_I						=>	dma_wrdata,								
			-- BER test:
			BER_RESET_I 						=>	ber_cntr_reset,								
			BER_ERROR_FLAG_O					=>	open,								
			BER_ERROR_CNTR_O  				=>	open,								
			BER_NOERR_FLAG_O					=>	open								
		);
	
	--=====================================================================--
		
	--======================== Signal Assignments =========================--
	
	--=====================================================================--
		
	--============= Simulation Control and Stimulus Generation =============--
	
	-- Simulation control: 
--	stopSimulation <= true after 8 us;		-- Duration of the simulation	
	assert not stopSimulation report "SIMULATION FINISHED" severity note;	
	
	-- Clock generation process:	
   dma_clk_process : process	
	begin   
		if not stopSimulation then	
			dma_clk	<= '1';			
			wait for dma_clk_period/2;			
			dma_clk	<= '0';			
			wait for dma_clk_period/2;	
		end if;		
   end process;	
 
	-- Stimulus process:	
	stim_process: process   
		variable indexCounter			: unsigned(23 downto 0) := (others => '0');	
		variable hexCounter				: unsigned(3 downto 0)  := (others => '1');	 	
	begin		
      -- Hold reset state for 20 clock periods:		
		reset		<= '1';		
      wait for dma_clk_period*20;			
		reset		<= '0';			
		-- Stimulus:		
      wait for dma_clk_period*5;		
		
--		--###################--
--		-- Write Transaction --
--		--###################--
--      
--      dma_rdchannel						<= "00000100";		
--      dma_rdtrans_size				   <= x"00000200";
--      wait for dma_clk_period;
--      dma_rdstatus					   <= "1000";
--		wait for dma_clk_period*4;	
--		dma_rd								<= '1';	
--		wait for dma_clk_period*32;
--		dma_rd								<= '0';	
-- 		wait for dma_clk_period*7;     
--      dma2_status					      <= "0000";
--      --
--      --
--      wait for dma_clk_period*10;
--      dma2_status					      <= "1000";
--		wait for dma_clk_period*4;	
--		dma_rd								<= '1';	           
--		wait for dma_clk_period*32;  
--		dma_rd								<= '0';	     
--		wait for dma_clk_period*7;     
--      dma2_status					      <= "0000";
--	
--		--###################--
--		-- Read Transaction --
--		--###################--
--		
--		wait for dma_clk_period*160;
--		prbs_enable							<= '1';
--      dma_rdchannel						<= "00000010";		
--		dma_wrtrans_size              <= x"00000200";
--      wait for dma_clk_period;
--      dma_wrstatus					   <= "1000";
--      -- Error injection:
----    wait for dma_clk_period*3;
--      wait until pdv_from_prbs = '1'; 
--      --      
--		dma_wrchannel						<= "00000010";	      
--		dma_wr								<= '1';				
--		wait for dma_clk_period*31;
--		prbs_enable							<= '0';
-- 		wait for dma_clk_period*1;     
-- 		dma_wr								<= '0';     
-- 		wait for dma_clk_period*7;      
--      dma_wrstatus					   <= "0000";
--      --
--      --
--      wait for dma_clk_period*10;
--      dma_wrstatus					   <= "1000";
--		prbs_enable							<= '1';
--      wait for dma_clk_period*1; 	
--		dma_wrchannel						<= "00000010";	      
--		dma_wr								<= '1';				
--		wait for dma_clk_period*31;
--		prbs_enable							<= '0';
-- 		wait for dma_clk_period*1;     
-- 		dma_wr								<= '0';    
--
--		-- End of the first two transactions:      
--		wait for dma_clk_period*20;
--		ber_cntr_reset						<= '1';
--		prbs_reset			            <= '1';
--      wait for dma_clk_period;
--		ber_cntr_reset						<= '0';		
--		prbs_reset			            <= '0';
--
--		--###################--
--		-- Write Transaction --
--		--###################--
--      
--      dma_rdchannel						<= "00000100";		
--      dma_rdtrans_size				   <= x"00000200";
--      wait for dma_clk_period;
--      dma_rdstatus					   <= "1000";
--		wait for dma_clk_period*4;	
--		dma_rd								<= '1';	
--		wait for dma_clk_period*32;
--		dma_rd								<= '0';	
-- 		wait for dma_clk_period*7;     
--      dma2_status					      <= "0000";
--      --
--      --
--      wait for dma_clk_period*10;
--      dma2_status					      <= "1000";
--		wait for dma_clk_period*4;	
--		dma_rd								<= '1';	           
--		wait for dma_clk_period*32;  
--		dma_rd								<= '0';	     
--		wait for dma_clk_period*7;     
--      dma2_status					      <= "0000";
--	
--		--###################--
--		-- Read Transaction --
--		--###################--
--		
--		wait for dma_clk_period*160;
--		prbs_enable							<= '1';
--      dma_rdchannel						<= "00000010";		
--		dma_wrtrans_size              <= x"00000200";
--      wait for dma_clk_period;
--      dma_wrstatus					   <= "1000";
--      -- Error injection:
----    wait for dma_clk_period*3;
--      wait until pdv_from_prbs = '1'; 
--      --      
--		dma_wrchannel						<= "00000010";	      
--		dma_wr								<= '1';				
--		wait for dma_clk_period*31;
--		prbs_enable							<= '0';
-- 		wait for dma_clk_period*1;     
-- 		dma_wr								<= '0';     
-- 		wait for dma_clk_period*7;      
--      dma_wrstatus					   <= "0000";
--      --
--      --
--      wait for dma_clk_period*10;
--      dma_wrstatus					   <= "1000";
--		prbs_enable							<= '1';
--      wait for dma_clk_period*1; 	
--		dma_wrchannel						<= "00000010";	      
--		dma_wr								<= '1';				
--		wait for dma_clk_period*31;
--		prbs_enable							<= '0';
-- 		wait for dma_clk_period*1;     
-- 		dma_wr								<= '0';    
--
--		-- End of the second two transactions:      
--		wait for dma_clk_period*20;
--		ber_cntr_reset						<= '1';
--		prbs_reset			            <= '1';
--      wait for dma_clk_period;
--		ber_cntr_reset						<= '0';		
--		prbs_reset			            <= '0';
      
--         --###################--
--         -- Write Transaction --
--         --###################--
--         
--         dma_rdchannel						<= "00000100";		
--         dma_rdtrans_size				   <= x"01000000";
--         wait for dma_clk_period;
--         
--      for i in 0 to 16383 loop
--         dma_rdstatus					   <= "1000";
--         wait for dma_clk_period*4;	
--         dma_rd								<= '1';	
--         wait for dma_clk_period*32;
--         dma_rd								<= '0';	
--         wait for dma_clk_period*7;     
--         dma2_status					      <= "0000";
--         --
--         --
--         wait for dma_clk_period*10;
--         dma2_status					      <= "1000";
--         wait for dma_clk_period*4;	
--         dma_rd								<= '1';	           
--         wait for dma_clk_period*32;  
--         dma_rd								<= '0';	     
--         wait for dma_clk_period*7;     
--         dma2_status					      <= "0000";
--         --
--         --
--         wait for dma_clk_period*10;
--         dma2_status					      <= "1000";
--         wait for dma_clk_period*4;	
--         dma_rd								<= '1';	           
--         wait for dma_clk_period*32;  
--         dma_rd								<= '0';	     
--         wait for dma_clk_period*7;     
--         dma2_status					      <= "0000";
--         --
--         --
--         wait for dma_clk_period*10;
--         dma2_status					      <= "1000";
--         wait for dma_clk_period*4;	
--         dma_rd								<= '1';	           
--         wait for dma_clk_period*32;  
--         dma_rd								<= '0';	     
--         wait for dma_clk_period*7;     
--         dma2_status					      <= "0000";      
--      end loop;
-- 
--      --###################--
--      -- Read Transaction --
--      --###################--
--      
--      wait for dma_clk_period*200;  
--
--      dma_wrchannel						   <= "00000010";	      
--      dma_wrtrans_size                 <= x"01000000"; 
--      wait for dma_clk_period;
--      
--      for i in 0 to 16383 loop 
--         wait for dma_clk_period*10;
--         dma_wrstatus					   <= "1000";
--         prbs_enable							<= '1';
--         wait for dma_clk_period*1;        
--         dma_wr								<= '1';				
--         wait for dma_clk_period*31;
--         prbs_enable							<= '0';
--         wait for dma_clk_period*1;     
--         dma_wr								<= '0';     
--         wait for dma_clk_period*7;      
--         dma_wrstatus					   <= "0000";
--         --
--         --
--         wait for dma_clk_period*10;
--         dma_wrstatus					   <= "1000";
--         prbs_enable							<= '1';
--         wait for dma_clk_period*1; 	
--         dma_wr								<= '1';				
--         wait for dma_clk_period*31;
--         prbs_enable							<= '0';
--         wait for dma_clk_period*1;     
--         dma_wr								<= '0';    
--         wait for dma_clk_period*7;      
--         dma_wrstatus					   <= "0000";
--         --
--         --
--         wait for dma_clk_period*10;
--         dma_wrstatus					   <= "1000";
--         prbs_enable							<= '1';
--         wait for dma_clk_period*1; 	
--         dma_wr								<= '1';				
--         wait for dma_clk_period*31;
--         prbs_enable							<= '0';
--         wait for dma_clk_period*1;     
--         dma_wr								<= '0';
--         wait for dma_clk_period*7;      
--         dma_wrstatus					   <= "0000";
--         --
--         --
--         wait for dma_clk_period*10;
--         dma_wrstatus					   <= "1000";
--         prbs_enable							<= '1';
--         wait for dma_clk_period*1; 	
--         dma_wr								<= '1';				
--         wait for dma_clk_period*31;
--         prbs_enable							<= '0';
--         wait for dma_clk_period*1;     
--         dma_wr								<= '0';
--         wait for dma_clk_period*7;      
--         dma_wrstatus					   <= "0000"; 
--      end loop;
	
		--###################--
		-- Read Transaction --
		--###################--
		
		prbs_enable							<= '1';
      dma_rdchannel						<= "00000010";		
		dma_wrtrans_size              <= x"00000200";
      wait for dma_clk_period;
      dma_wrstatus					   <= "1000";
      -- Error injection:
--    wait for dma_clk_period*3;
      wait until pdv_from_prbs = '1'; 
      --      
		dma_wrchannel						<= "00000010";	      
		dma_wr								<= '1';				
		wait for dma_clk_period*31;
		prbs_enable							<= '0';
 		wait for dma_clk_period*1;     
 		dma_wr								<= '0';     
 		wait for dma_clk_period*7;      
      dma_wrstatus					   <= "0000";
      --
      --
      wait for dma_clk_period*10;
      dma_wrstatus					   <= "1000";
		prbs_enable							<= '1';
      wait for dma_clk_period*1; 	
		dma_wrchannel						<= "00000010";	      
		dma_wr								<= '1';				
		wait for dma_clk_period*31;
		prbs_enable							<= '0';
 		wait for dma_clk_period*1;     
 		dma_wr								<= '0';  
 
		--###################--
		-- Write Transaction --
		--###################--
 		
      wait for dma_clk_period*160;
     
      dma_rdchannel						<= "00000100";		
      dma_rdtrans_size				   <= x"00000200";
      wait for dma_clk_period;
      dma_rdstatus					   <= "1000";
		wait for dma_clk_period*4;	
		dma_rd								<= '1';	
		wait for dma_clk_period*32;
		dma_rd								<= '0';	
 		wait for dma_clk_period*7;     
      dma2_status					      <= "0000";
      --
      --
      wait for dma_clk_period*10;
      dma2_status					      <= "1000";
		wait for dma_clk_period*4;	
		dma_rd								<= '1';	           
		wait for dma_clk_period*32;  
		dma_rd								<= '0';	     
		wait for dma_clk_period*7;     
      dma2_status					      <= "0000"; 
      
      -- End of the stimulus process:      
		wait for dma_clk_period*20;
		ber_cntr_reset						<= '1';
		prbs_reset			            <= '1';
      wait for dma_clk_period;
		ber_cntr_reset						<= '0';		
		prbs_reset			            <= '0';

		wait for dma_clk_period*20;

      stopSimulation                <= true;   
         
		wait;		
   end process;		
	
	dma_wrdata							<= pdata_from_prbs when pdv_from_prbs = '1'
												else (others => '0');	
	
	
	--=====================================================================--	
end test_bench;
--=================================================================================================--
--=================================================================================================--
	