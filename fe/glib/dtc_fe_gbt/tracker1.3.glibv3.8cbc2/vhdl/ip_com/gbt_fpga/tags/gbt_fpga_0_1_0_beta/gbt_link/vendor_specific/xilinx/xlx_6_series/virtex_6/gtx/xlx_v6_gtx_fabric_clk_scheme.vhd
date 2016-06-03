--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                         
-- Company:                CERN (PH-ESE-BE)                                                         
-- Engineer:               Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:           GBT-FPGA                                                                
-- Module Name:            Xilinx Virtex 6 GTX fabric clock scheme                                       
--                                                                                                 
-- Language:               VHDL'93                                                                  
--                                                                                                   
-- Target Device:          Xilinx Virtex 6                                                         
-- Tool version:           ISE 14.5                                                                
--                                                                                                   
-- Version:                1.0                                                                      
--
-- Description:            
--
-- Versions history:       DATE         VERSION   AUTHOR              DESCRIPTION
--
--                         23/06/2013   1.0       M. BARROS MARIN     - First .vhd module definition           
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

-- Custom libraries and packages:
use work.gbt_link_user_setup.all;

--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--

entity xlx_v6_gtx_fabric_clk_scheme is     
   port (   
   
      --========--
      -- GTX TX --
      --========--           
      
      GTX_TXOUTCLK_I                            : in  std_logic_vector(1 to NUM_GBT_LINK);    
      USER_TXOUTCLK_O                           : out std_logic_vector(1 to NUM_GBT_LINK);  
      
      GTX_TXUSRCLK2_O                           : out std_logic_vector(1 to NUM_GBT_LINK);  
      USER_TXUSRCLK2_I                          : in  std_logic_vector(1 to NUM_GBT_LINK);  
      
      --========--
      -- GTX RX --
      --========--     
      
      GTX_RXRECCLK_I                            : in  std_logic_vector(1 to NUM_GBT_LINK);                  
      USER_RXRECCLK_O                           : out std_logic_vector(1 to NUM_GBT_LINK);    
      
      GTX_RXUSRCLK2_O                           : out std_logic_vector(1 to NUM_GBT_LINK);              
      USER_RXUSRCLK2_I                          : in  std_logic_vector(1 to NUM_GBT_LINK) 
     
   );
end xlx_v6_gtx_fabric_clk_scheme;
architecture structural of xlx_v6_gtx_fabric_clk_scheme is

   --========================= Signal Declarations ==========================--

   signal txusrclk2_from_txOutClk_bufg          : std_logic;

   --========================================================================--
--===========================================================================--
-----          --===================================================--
begin        --================== Architecture Body ==================-- 
-----          --===================================================--
--===========================================================================--
   
   --============================= User Logic ===============================--
   
   -- Comment: * Default setup: BUFG
   --
   --          * When using BUFG, TXOUTCLK from GTX1 is used to generate TXUSRCLK2 for all GTXs of the quad.
   --   
   --          * When bypassing the buffers, TXOUTCLK/TXUSRCLK2 and RXRECCLK/RXUSRCLK2 of all GTX are forwarded out from the 
   --            GBT Link so the user can connect the buffers as desired. 
   
   --========--
   -- GTX TX --
   --========--    

   -- TXOUTCLK to TXUSRCLK2 forwarding with BUFG:
   ----------------------------------------------

   txBufg_gen: if TX_OUTCLK_BUFFER_TYPE /= "BYPASS" generate
      
      txOutClk_bufg: BUFG
         port map (
            O                                   => txusrclk2_from_txOutClk_bufg, 
            I                                   => GTX_TXOUTCLK_I(1)  
         ); 
         
      gtxTxOutClk_gen: for i in 1 to NUM_GBT_LINK generate          
      
         GTX_TXUSRCLK2_O(i)                     <= txusrclk2_from_txOutClk_bufg;        
         
      end generate;   

   end generate;  
   
   -- TXOUTCLK to TXUSRCLK2 forwarding with NO buffer:
   ---------------------------------------------------
   
   -- Comment: Note!! In this case the buffer is provided off-GBT Link module by the user.
   
   txNoBuff_gen: if TX_OUTCLK_BUFFER_TYPE = "BYPASS" generate   
     
      USER_TXOUTCLK_O                           <= GTX_TXOUTCLK_I;
      GTX_TXUSRCLK2_O                           <= USER_TXUSRCLK2_I;
      
   end generate;
   
   --========--
   -- GTX RX --
   --========--    
   
   rxClkBuf_gen: for i in 1 to NUM_GBT_LINK generate
   
      -- RXRECCLK to RXUSRCLK2 forwarding with BUFG:
      ----------------------------------------------      
      
      rxBufg_gen: if RX_RECCLK_BUFFER_TYPE /= "BYPASS" generate
         
         rxRecClk_bufg: BUFG
            port map (
               O                                => GTX_RXUSRCLK2_O(i), 
               I                                => GTX_RXRECCLK_I(i)  
            );         
      
      end generate;
   
      -- RXRECCLK to RXUSRCLK2 forwarding with NO buffer:
      ---------------------------------------------------

      rxNoBuff_gen: if RX_RECCLK_BUFFER_TYPE = "BYPASS" generate   
        
         -- Comment: Note!! In this case the buffer is provided off-GBT Link module by the user.
        
         USER_RXRECCLK_O(i)                     <= GTX_RXRECCLK_I(i);
         GTX_RXUSRCLK2_O(i)                     <= USER_RXUSRCLK2_I(i);

      end generate;

   end generate;
  
   --========================================================================--   
end structural;
--=================================================================================================--
--=================================================================================================--