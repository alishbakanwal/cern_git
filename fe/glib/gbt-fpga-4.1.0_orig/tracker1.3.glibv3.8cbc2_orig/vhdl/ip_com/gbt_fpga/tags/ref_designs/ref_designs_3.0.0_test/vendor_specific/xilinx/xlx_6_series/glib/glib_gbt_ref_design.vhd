--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																																  	--
-- Company:  					CERN (PH-ESE-BE)																			--
-- Engineer: 					Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros@ieee.org)	--
-- 																																--
-- Create Date:		    	04/06/2013     																			--
-- Project Name:				GBT-FPGA                      														--
-- Module Name:   		 	GBT HDL on GLIB reference design 													--
-- 																																--
-- Language:					VHDL'93                                       									--
--																																	--
-- Target Devices: 			GLIB (Virtex 6)																			--
-- Tool versions: 			ISE 14.5          																		--
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
use work.gbt_link_package.all;

--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--

entity glib_gbt_ref_design is	
	port (	
      
      --===============--
      -- General reset --
      --===============--
      
      FPGA_POWER_ON_RESET_B			      : in	std_logic;
      
      --=======================--
      -- GLIB control & status --
      --=======================--
      
      -- Crosspoint Swith 1 control:
      XPOINT1_S10					            : out	std_logic;
      XPOINT1_S11					            : out	std_logic;
      
      -- CDCE62005 control & status:
      CDCE_PWR_DOWN				            : out	std_logic;	
      CDCE_REF_SEL				            : out	std_logic;	
      CDCE_SYNC					            : out	std_logic;	
      CDCE_PLL_LOCK				            : in	std_logic;      
      
      -- On-board LEDs:
      V6_LED                              : out	std_logic_vector(1 to 3);      
      
      -- SMA output:
      FPGA_CLKOUT  			               : out	std_logic;	    
      
      --====================--
      -- GLIB clocks scheme --
      --====================--
      
      -- GTX reference clock:
      CDCE_OUT0_P			                  : in	std_logic;
      CDCE_OUT0_N			                  : in	std_logic;
      
      -- 40MHz fabric clock:            
      XPOINT1_CLK1_P		                  : in	std_logic;
      XPOINT1_CLK1_N		                  : in	std_logic;

      --=============================--
      -- GTX transceivers (SFP Quad) --
      --=============================--
      
      -- Serial lanes:
      SFP_TX_P						            : out	std_logic_vector(1 to 4);
      SFP_TX_N						            : out	std_logic_vector(1 to 4);
      SFP_RX_P						            : in	std_logic_vector(1 to 4);
      SFP_RX_N						            : in	std_logic_vector(1 to 4);
      
      -- SFP status:
      SFP_MOD_ABS					            : in	std_logic_vector(1 to 4);		
      SFP_RXLOS					            : in	std_logic_vector(1 to 4);		
      SFP_TXFAULT					            : in	std_logic_vector(1 to 4)
      
   );
end glib_gbt_ref_design;
architecture structural of glib_gbt_ref_design is	
   
   --============================= Attributes ===============================--   
   
   attribute S		                        : string;
	attribute keep                         : string;   
   
   --========================================================================--   

	--======================= Constants Declarations =========================--
	
   -- GBT Link setup:   
   constant NUM_GBT_LINK                  : integer range 1 to 4 := 1;  -- Note!! This ref design is designed for ONE GBT Link
   constant OPTIMIZATION                  : string := "STANDARD";       -- "LATENCY_" or "STANDARD"      
   
	--========================================================================-- 	
   
	--======================== Signals Declarations ==========================--   

   --===============--
   -- General reset --
   --===============--
   
   signal reset   								: std_logic;	      
   
   --=======================--
   -- GLIB control & status --
   --=======================--   
   
   signal cdce62005_locked						: std_logic;	 
      
   --====================--
   -- GLIB clocks scheme --
   --====================--
   
   signal cdce_out0								: std_logic;
   signal cdce_out0_bufg						: std_logic;
	signal xpoint1_clk1  						: std_logic;
   
   --==========--
   -- GBT Link --
   --==========--
   
   -- Resets scheme:
   signal gtx_txreset_from_gbt_link_rst	: std_logic; 
   signal gtx_rxreset_from_gbt_link_rst	: std_logic; 
   signal gbt_txreset_from_gbt_link_rst   : std_logic;
   signal gbt_rxreset_from_gbt_link_rst   : std_logic;
   ------------------------------
   signal tx_reset_to_gtx  	            : std_logic_vector(1 to NUM_GBT_LINK); 
   signal rx_reset_to_gtx  	            : std_logic_vector(1 to NUM_GBT_LINK); 
   signal reset_to_gbt_tx                 : std_logic_vector(1 to NUM_GBT_LINK);
   signal reset_to_gbt_rx                 : std_logic_vector(1 to NUM_GBT_LINK);      
   
   -- Patter generator:
   signal pg_data                         : std_logic_vector(83 downto 0);   
   attribute keep of pg_data				 	: signal is "true";	
   
   -- GBT Link (SFP quad):
   signal clks_to_gbt_link                : gbt_link_clks_in;                          
   signal clks_from_gbt_link              : gbt_link_clks_out;
   ------------------------------   
   signal to_gbt_tx                       : gbt_tx_in_array (1 to NUM_GBT_LINK); 
   signal from_gbt_tx                     : gbt_tx_out_array(1 to NUM_GBT_LINK);
   ------------------------------   
   signal to_gtx                          : gtx_in_array (1 to NUM_GBT_LINK);
   signal from_gtx                        : gtx_out_array(1 to NUM_GBT_LINK); 
   ------------------------------   
   signal to_gbt_rx                       : gbt_rx_in_array (1 to NUM_GBT_LINK); 
   signal from_gbt_rx                     : gbt_rx_out_array(1 to NUM_GBT_LINK);    
   attribute keep of from_gbt_rx   	 	   : signal is "true";	    
  
   --===========--
   -- Chipscope --
   --===========--
   
   signal vio_control                     : std_logic_vector(35 downto 0); 
   signal ila_control                     : std_logic_vector(35 downto 0); 
   signal sync_from_vio                   : std_logic_vector( 3 downto 0);   
   signal async_to_vio                    : std_logic_vector( 5 downto 0);

	--========================================================================--	

--===========================================================================--
-----		    --===================================================--
begin		  --================== Architecture Body ==================-- 
-----		    --===================================================--
--===========================================================================--
   
   --============================ User Logic =============================--
   
   --===============--
   -- General Reset -- 
   --===============--  
   
   rst: entity work.reset_ctrl
      port map (
         CLK                              => xpoint1_clk1,
         EXT_RESET1_B                     => FPGA_POWER_ON_RESET_B,
         EXT_RESET2_B                     => (not sync_from_vio(0)),
         RST_MAC_O                        => open,
         RST_GTX_O                        => open,
         RST_FABRIC_O                     => reset 
      );  
   
   --==============--
   -- GLIB control --
   --==============--
   
   -- XPOINT1 control:
   XPOINT1_S10					               <= '0'; 	                   -- (xpoint_4x4 OUT_1 driven by IN_2)
	XPOINT1_S11					               <= '1'; 	                   --  		    
   
   -- CDCE62005 synchronizer:
   cdce62005_sync: entity work.cdce_synchronizer
      port map (
         RESET_I                          => reset,
         IPBUS_CTRL_I                     => '0',                     -- Control by USER
         IPBUS_SEL_I                      => '1',                     -- CDCE62005 PRI_REF *NOT USED*
         IPBUS_PWRDOWN_I                  => '1',                     -- Active low        *NOT USED*
         IPBUS_SYNC_I                     => '1',                     -- Active low        *NOT USED*
         USER_SEL_I                       => '1',                     -- CDCE62005 PRI_REF
         USER_SYNC_I                      => '1',                     -- Active low    
         USER_PWRDOWN_I                   => '1',                     -- Active low    
         PRI_CLK_I                        => xpoint1_clk1,
         SEC_CLK_I                        => '0',                     --                   *NOT USED*
         PWRDOWN_O                        => CDCE_PWR_DOWN,
         SYNC_O                           => CDCE_SYNC,
         REF_SEL_O                        => CDCE_REF_SEL,
         PLL_LOCK_I                       => CDCE_PLL_LOCK,
         SYNC_CLK_O                       => open,
         SYNC_CMD_O                       => open,
         SYNC_BUSY_O                      => open,
         SYNC_LOCK_O                      => cdce62005_locked,
         SYNC_DONE_O                      => async_to_vio(0)
      ); 	
	
   async_to_vio(1)                        <= cdce62005_locked;	   
   
   -- On-board LEDs:             
   V6_LED(1)                              <= cdce62005_locked;          
   V6_LED(2)                              <= from_gtx(1).phasealigndone;
   V6_LED(3)                              <= from_gbt_rx(1).data_dv;   
   
   -- SMA out:   
   FPGA_CLKOUT                            <= xpoint1_clk1 when sync_from_vio(1) = '1'
                                             else cdce_out0_bufg;   
   
   --====================--
   -- GLIB Clocks scheme -- 
   --====================--   

   -- Fabric clock (40MHz):
   xpsw1_clk1_ibufgds: IBUFGDS
      generic map (
         IBUF_LOW_PWR                     => FALSE,
         IOSTANDARD                       => "LVDS_25")
      port map (           
         O                                => xpoint1_clk1,
         I                                => XPOINT1_CLK1_P,
         IB                               => XPOINT1_CLK1_N
      );   
   
   -- GTX reference clock:
	sfp_ibufds_gtxe1: ibufds_gtxe1
      port map (
         I                                => CDCE_OUT0_P,
         IB                               => CDCE_OUT0_N,
         O                                => cdce_out0,
         ceb                              => '0'
      );          
   
   sfp_ibufds_bufg: bufg         
      port map (        
         O                                => cdce_out0_bufg,
         I                                => cdce_out0 
      );     
  
   --===================--
   -- Pattern generator --
   --===================--
   
   patt_gen: entity work.Word_Generator
      port map (
         CLOCK_40MHZ                      => xpoint1_clk1,
         GENERATED_WORD                   => pg_data
      );   
  
   --====================--
   -- GBT Link (SFP quad)--
   --====================--      
   
   -- GBT Link clocks assignments:   
   clks_to_gbt_link.interface_clk         <= xpoint1_clk1;
   clks_to_gbt_link.gtx_tx_refclk	      <= cdce_out0;
   clks_to_gbt_link.gtx_rx_refclk         <= cdce_out0;	
   clks_to_gbt_link.tx_frame_clk	         <= xpoint1_clk1;
   clks_to_gbt_link.rx_frame_clk          <= xpoint1_clk1;
   clks_to_gbt_link.drp_dclk 	            <= '0';          
   
   -- GBT Link reset:
	gbt_link_rst: entity work.glibLink_rst_ctrl 	
      port map (
         CLK_I 					            => xpoint1_clk1,                                               
         RESET_I 					            =>	reset,                                                                      
         GTX_TXRESET_O 			            => gtx_txreset_from_gbt_link_rst,                              
         GTX_RXRESET_O 			            => gtx_rxreset_from_gbt_link_rst,                             
         GBT_TXRESET_O 			            => gbt_txreset_from_gbt_link_rst,                                      
         GBT_RXRESET_O 			            => gbt_rxreset_from_gbt_link_rst,                              
         BUSY_O 					            => open,                                                                         
         DONE_O 					            => open                                                                          
      );	 
   
   to_gtx(1).tx_reset                     <= gtx_txreset_from_gbt_link_rst;
   to_gtx(1).rx_reset                     <= gtx_rxreset_from_gbt_link_rst;
   to_gbt_tx(1).reset                     <= gbt_txreset_from_gbt_link_rst;
   to_gbt_rx(1).reset                     <= gbt_rxreset_from_gbt_link_rst;
   
   -- GBT Link (SFP quad):
   gbt_link_sfp: entity work.gbt_link
      generic map (	            
         NUM_LINKS   			            => NUM_GBT_LINK, 
         OPTIMIZATION  			            => OPTIMIZATION)                      
      port map (	                  
         CLKS_I     			               => clks_to_gbt_link,                                  
         CLKS_O    			               => clks_from_gbt_link,               
         -------------------------------- 
         GBT_TX_I  			               => to_gbt_tx,             
         GBT_TX_O   			               => from_gbt_tx,             
         -------------------------------- 
         GTX_I     			               => to_gtx,              
         GTX_O    			               => from_gtx,              
         -------------------------------- 
         GBT_RX_I 			               => to_gbt_rx,              
         GBT_RX_O			                  => from_gbt_rx         
      );   

   to_gtx(1).rxp                          <= SFP_RX_P(1);	
   to_gtx(1).rxn                          <= SFP_RX_N(1);
   SFP_TX_P(1)                            <= from_gtx(1).txp;
   SFP_TX_N(1)                            <= from_gtx(1).txn;     
   
   to_gbt_tx(1).data                      <= pg_data;
   ---------------------------            
   to_gtx(1).drp_daddr                    <= x"00";
   to_gtx(1).drp_den                      <= '0';
   to_gtx(1).drp_di                       <= x"0000";
   to_gtx(1).drp_dwe		                  <= '0';
   ---------------------------            
   to_gtx(1).prbs_txen                    <= "000";
   to_gtx(1).prbs_rxen                    <= "000";
   to_gtx(1).prbs_forcerr                 <= '0';
   to_gtx(1).prbs_errcntrst               <= '0';      
   
   async_to_vio(2)                        <= from_gtx(1).phasealigndone;
   async_to_vio(3)                        <= from_gbt_rx(1).data_dv;
   
   --=================--
   -- Error Detection --
   --=================--    
  
   err_det: entity work.Error_Detection_Module
      port map (
         CLOCK                     => clks_to_gbt_link.rx_frame_clk,
         RESET_ERROR_SEEN_WHEN_DV  => gbt_rxreset_from_gbt_link_rst or sync_from_vio(2),
         RESET_ERROR_SEEN          => gbt_rxreset_from_gbt_link_rst or sync_from_vio(3),
         RECEIVED_DATA             => from_gbt_rx(1).data,
         DV                        => from_gbt_rx(1).data_dv,
         ERROR_SEEN_WHEN_DV        => async_to_vio(4),
         ERROR_SEEN                => async_to_vio(5)
      ); 
   
   --===========--
   -- Chipscope --
   --===========--   
   
   -- Chiscope ICON:
   icon: entity work.chipscope_icon
      port map (
         CONTROL0          => vio_control,
         CONTROL1          => ila_control
      );

   -- Chipscope VIO:
   vio: entity work.chipscope_vio
      port map (
         CONTROL           => vio_control,
         CLK               => xpoint1_clk1,
         ASYNC_IN          => async_to_vio,
         SYNC_OUT          => sync_from_vio
      );
      
   -- Chipscope ILA:
   ila: entity work. chipscope_ila
      port map (
         CONTROL           => ila_control,
         CLK               => xpoint1_clk1,
         TRIG0             => pg_data,
         TRIG1             => from_gbt_rx(1).data         
      );
   
	--========================================================================--	
end structural;
--=================================================================================================--
--=================================================================================================--