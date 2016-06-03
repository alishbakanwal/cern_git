--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT Link                                        
--                                                                                                 
-- Language:              VHDL'93                                                              
--                                                                                                   
-- Target Device:         Vendor agnostic                                                      
-- Tool version:                                                                             
--                                                                                                   
-- Current version:       1.0                                                                      
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        08/02/2013   1.0       M. Barros Marin   - First .vhd module definition
--
-- Additional Comments:                                                                               
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Link are set through:                               !!  
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Link module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_link_package.vhd").                                !!  
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<hardware_platform>_gbt_link_user_setup.vhd".   !!
-- !!                                                                                           !!
-- !!   (Note!! These parameters are vendor specific).                                          !!                    
-- !!                                                                                           !! 
-- !! * The "<hardware_platform>_gbt_link_user_setup.vhd" is the only file of the GBT Link that !!
-- !!   may be modified by the user. The rest of the files MUST be used as is.                  !!
-- !!                                                                                           !!  
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                                                                                                   
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.gbt_link_user_setup.all;
use work.gbt_link_package.all;
use work.vendor_specific_gbt_link_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_link is     
   port (   
      
      --========--
      -- Clocks --     
      --========--
      
      CLKS_I                                    : in  gbtLinkClks_i_R;                                        
      CLKS_O                                    : out gbtLinkClks_o_R;
      
      --=================--
      -- GBT transmitter --                 
      --=================--
      
      GBT_TX_I                                  : in  gbtTx_i_R_A      (1 to NUM_GBT_LINK); 
      
      --============================--
      -- Multi Gigabit Transceivers --                              
      --============================--
      
      MGT_I                                     : in  mgt_i_R_A        (1 to NUM_GBT_LINK);
      MGT_O                                     : out mgt_o_R_A        (1 to NUM_GBT_LINK); 
      
      --==============--
      -- GBT receiver --
      --==============--
      
      GBT_RX_I                                  : in  gbtRx_i_R_A      (1 to NUM_GBT_LINK); 
      GBT_RX_O                                  : out gbtRx_o_R_A      (1 to NUM_GBT_LINK)
      
   );
end gbt_link;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture structural of gbt_link is   

   --================================ Signal Declarations ================================--

   --==================--
   -- GBT transmitters --
   --==================--   
   
   -- Comment: TX word width is device dependent.
   
   signal tx_wordNbit_from_gbtTx                : word_nbit_A         (1 to NUM_GBT_LINK);    
               
   --============================--              
   -- Multi Gigabit Transceivers --          
   --============================--                 
     
   -- Comment: RX word width is device dependent.
     
   signal wordClks_from_mgt                     : gbtLinkClks_o_R;
   signal ready_from_mgt                        : std_logic_vector    (1 to NUM_GBT_LINK); 
   signal rx_wordNbit_from_mgt                  : word_nbit_A         (1 to NUM_GBT_LINK);    
                  
   --===============--              
   -- GBT receivers --              
   --===============--     
   
   -- Comment: GBT RX bitslip width is device dependent.   
   
   signal bitSlipNbr_from_gbtRx                 : gbtRxSlideNbr_nbit_A(1 to NUM_GBT_LINK);   
   signal rxHeaderLocked_from_gbtRx             : std_logic_vector    (1 to NUM_GBT_LINK); 
   
   --=====================================================================================--
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--

   --==================================== User Logic =====================================--
   
   --==================--
   -- GBT transmitters --
   --==================--
      
   gbtTx_gen: for i in 1 to NUM_GBT_LINK generate         
      
      gbtTx: entity work.gbt_tx        
         port map (            
            -- Reset & clocks:
            TX_RESET_I                          => GBT_TX_I(i).reset,
            TX_FRAMECLK_I                       => CLKS_I.tx_frameClk,
            TX_WORDCLK_I                        => wordClks_from_mgt.tx_wordClk(i),
            -- Control:              
            TX_ENCODING_SEL_I                   => GBT_TX_I(i).encodingSel,
            TX_ISDATA_SEL_I                     => GBT_TX_I(i).isDataSel, 
            -- Data & word:        
            TX_DATA_I                           => GBT_TX_I(i).data,
            TX_WORD_O                           => tx_wordNbit_from_gbtTx(i),
            ------------------------------------
            TX_WIDEBUS_EXTRA_DATA_I             => GBT_TX_I(i).widebusExtraData       
         ); 
         
   end generate;

   --============================--  
   -- Multi Gigabit Transceivers --
   --============================--          
   
   mgt: entity work.multi_gigabit_transceivers     
      port map (        
         -- Clocks:    
         MGT_REFCLKS_I                          => CLKS_I.mgt_refClks,
         MGT_WORDCLKS_O                         => wordClks_from_mgt,
         -- MGT I/O:                
         MGT_I                                  => MGT_I,
         MGT_O                                  => MGT_O,
         -- Control & status:
         GBT_RX_HEADER_LOCKED_I                 => rxHeaderLocked_from_gbtRx,
         GBT_RX_BITSLIP_NBR_I                   => bitSlipNbr_from_gbtRx,
         GBT_RX_MGT_RDY_O                       => ready_from_mgt,
         -- Words:      
         GBT_TX_WORD_I                          => tx_wordNbit_from_gbtTx,      
         GBT_RX_WORD_O                          => rx_wordNbit_from_mgt
      );                
      
   CLKS_O                                       <= wordClks_from_mgt;        
   
   --===============--
   -- GBT receivers --
   --===============--
      
   gbtRx_gen: for i in 1 to NUM_GBT_LINK generate    
   
      gbtRx: entity work.gbt_rx            
         port map (              
            -- Reset & clocks:
            RX_RESET_I                          => GBT_RX_I(i).reset,
            RX_WORDCLK_I                        => wordClks_from_mgt.rx_wordClk(i),
            RX_FRAMECLK_I                       => CLKS_I.rx_frameClk,                  
            -- Control:    
            RX_ENCODING_SEL_I                   => GBT_RX_I(i).encodingSel,
            RX_MGT_RDY_I                        => ready_from_mgt(i),        
            -- Status:
            DESCR_RDY_O                         => GBT_RX_O(i).descrRdy,
            RX_BITSLIP_NBR_O                    => bitSlipNbr_from_gbtRx(i),            
            RX_HEADER_FLAG_O                    => GBT_RX_O(i).header_flag,
            RX_HEADER_LOCKED_O                  => rxHeaderLocked_from_gbtRx(i),                 
            RX_ISDATA_FLAG_O                    => GBT_RX_O(i).isDataFlag,
            -- Word & data:                  
            RX_WORD_I                           => rx_wordNbit_from_mgt(i),                  
            RX_DATA_O                           => GBT_RX_O(i).data,
            ------------------------------------
            RX_WIDEBUS_EXTRA_DATA_O             => GBT_RX_O(i).widebusExtraData    
         );             
            
      GBT_RX_O(i).bitSlip_nbr                   <= bitSlipNbr_from_gbtRx(i);                         
      GBT_RX_O(i).header_lockedFlag             <= rxHeaderLocked_from_gbtRx(i);
 
   end generate;
   
   --=====================================================================================--   
end structural;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--