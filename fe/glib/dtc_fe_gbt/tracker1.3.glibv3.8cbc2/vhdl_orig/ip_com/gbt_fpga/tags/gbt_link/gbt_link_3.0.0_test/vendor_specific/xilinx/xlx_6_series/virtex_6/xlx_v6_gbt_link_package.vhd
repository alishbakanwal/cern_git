--=================================================================================================--
--=================================== Package Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 				   Paschalis Vichoudis                                                     -- 
--							      Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	08/02/2012 																			      --
-- Module Name:				glib_gbt_link																		      --
-- Package Name:   		 	system_gbt_link_package																	--
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
--=================================================================================================--
--================================== Package Declaration ==========================================-- 
--=================================================================================================--
package gbt_link_package is	
	--======================= Record Declarations =========================--
	
   --========--
	-- Clocks --
	--========--

   type gbt_link_clks_in is
	record
      interface_clk        : std_logic;
      gtx_tx_refclk	      : std_logic;
      gtx_rx_refclk	      : std_logic;
      tx_frame_clk	      : std_logic;
      rx_frame_clk   	   : std_logic; 
      drp_dclk 	         : std_logic;      
   end record;	
   
   type gbt_link_clks_out is
	record     
      tx_word_clk    	   : std_logic;
      rx_word_clk	         : std_logic_vector (1 to 4);
   end record;	

	--=============--
	-- GBT Encoder --
	--=============--
		
	type gbt_tx_in is   
	record   
		reset     			   : std_logic;
		data      			   : std_logic_vector ( 83 downto 0);
	end record;
	
   type gbt_tx_out is
	record
		frame					   : std_logic_vector (119 downto 0);	
		word      			   : std_logic_vector ( 19 downto 0);
		header 				   : std_logic;
	end record;	      
      
	--=================--
	-- GTX Transceiver --
	--=================--
	
	type gtx_in is
	record
		loopback			      : std_logic_vector(2 downto 0);              
		tx_powerdown 	      : std_logic_vector(1 downto 0);              
		rx_powerdown 	      : std_logic_vector(1 downto 0);              
		---                                                               
		rxp				      : std_logic;                                 
		rxn    			      : std_logic;			
      rx_sync_reset	      : std_logic; 		
		rx_reset			      : std_logic;
		rx_slide_enable      : std_logic;	
      rx_slide_ctrl	      : std_logic;	      
		rx_slide_run	      : std_logic;
		rx_slide_nbr	      : std_logic_vector(4 downto 0);
		---      
		tx_reset			      : std_logic; 
		tx_sync_reset	      : std_logic;
		---      
		drp_daddr            : std_logic_vector(7 downto 0);  
		drp_den              : std_logic;   
		drp_di               : std_logic_vector(15 downto 0); 
		drp_dwe			      : std_logic;
		---      
		conf_diff		      : std_logic_vector(3 downto 0);
		conf_pstemph	      : std_logic_vector(4 downto 0);
		conf_preemph	      : std_logic_vector(3 downto 0);
		conf_eqmix           : std_logic_vector(2 downto 0);
		conf_rxpol		      : std_logic;
		conf_txpol 		      : std_logic;
      ---      
      prbs_txen            : std_logic_vector(2 downto 0);
      prbs_rxen            : std_logic_vector(2 downto 0);
      prbs_forcerr         : std_logic;
      prbs_errcntrst       : std_logic;     
   end record;

	type gtx_out is
	record
		txp				      : std_logic;
		txn				      : std_logic;
		---      
		resetdone		      : std_logic;		
		phasealigndone	      : std_logic;
		---
      rx_data              : std_logic_vector(19 downto 0); 
      ---      
		drp_drdy             : std_logic;  
		drp_drpdo            : std_logic_vector(15 downto 0);		
      ---      
      prbs_rxerr           : std_logic;  
	end record;	   
   
	--=============--
	-- GBT Decoder --
	--=============--	
      
	type gbt_rx_in is   
	record   
		reset      			   : std_logic;
   end record;	
   
   type gbt_rx_out is
	record
		data       			   : std_logic_vector( 83 downto 0);
		data_dv				   : std_logic;
		bit_slip_cmd		   : std_logic;
		bit_slip_nbr		   : std_logic_vector(  4 downto 0);
		aligned      		   : std_logic;
		write_address		   : std_logic_vector(  5 downto 0);
		frame       		   : std_logic_vector(119 downto 0);
		frame_dv				   : std_logic;	
		header_flag 	 	   : std_logic;
		shiftedword  		   : std_logic_vector( 19 downto 0);
	end record;	    
   
	--=====================================================================--	
	--======================== Type Declarations ==========================--     
   
   --========--
	-- Common --
	--========--     
   
   type word_array                is array(natural range <>) of std_logic_vector( 19 downto 0);      
   type frame_120b_array          is array(natural range <>) of std_logic_vector(119 downto 0);  
 
   --=============--
	-- GBT Encoder --
	--=============--   
   
   type gbt_tx_in_array          is array(natural range <>) of gbt_tx_in;                              
	type gbt_tx_out_array         is array(natural range <>) of gbt_tx_out;    
   
   --=================--   
	-- GTX Transceiver --   
	--=================--       

	type gtx_in_array 	          is array(natural range <>) of gtx_in;
	type gtx_out_array 	          is array(natural range <>) of gtx_out;
   -------------------------------    
   type rx_slide_nbr_array        is array(natural range <>) of std_logic_vector(4 downto 0);    
   
   --=============--       
	-- GBT Decoder --       
	--=============--          
   
   type gbt_rx_in_array          is array(natural range <>) of gbt_rx_in;
	type gbt_rx_out_array         is array(natural range <>) of gbt_rx_out;
   -------------------------------   
   type rx_gearbox_array          is array(1 to 4) of string(1 to 3);
   
	--=====================================================================--
end gbt_link_package;
--=================================================================================================--
--=================================================================================================--