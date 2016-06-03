--=================================================================================================--
--##################################   Module Information   #######################################--
--=================================================================================================--
--                                                                                         
-- Company:               CERN (PH-ESE-BE)                                                         
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)                            
--                                                                                                 
-- Project Name:          GBT-FPGA                                                                
-- Module Name:           GBT RX frame aligner pattern search
--                                                                                                 
-- Language:              VHDL'93                                                                  
--                                                                                                   
-- Target Device:         Device agnostic                                                         
-- Tool version:                                                                       
--                                                                                                   
-- Version:               3.0                                                                      
--
-- Description:           Searches 4-bits header pattern in the 4 LSB of a 120-bits word. The MSB of the header being the
--                        bit 0 and its LSB the bit 3. The header pattern can be the idle or data header pattern.
--                        If more than "Nb_Accepted_falseHeader" are found in "Nb_checkedHeader" checked header, a bit slip
--                        command is sent and the RX_HEADER_LOCKED_O state is set low. If more than "Desired_consecCorrectHeaders"
--                        correct consecutive headers are found, the RX_HEADER_LOCKED_O state is proclaimed.
--   
-- Versions history:      DATE         VERSION   AUTHOR                               DESCRIPTION
--
--                        25/09/2008   0.1       F. Marin (CPPM)                      First .vhd entity definition.
--
--                        07/04/2009   0.2       F. Marin (CPPM)                      Modification.
--
--                        02/11/2010   0.3       S. Muschter (Stockholm University)   Dataflow and counters optimized for low latency.
--
--                        04/07/2012   3.0       M. Barros Marin                      - Cosmetic and minor modifications.
--                                                                                    - Support for 20bit and 40bit words.
--                                                                                    - Uses "gbt_bank_package.vhd" instead of "Constant_Declaration.vhd".
--                                                                                    - Removed gearbox address control.
--
-- Additional Comments:                                                                               
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!   (Note!! These parameters are vendor specific)                                           !!                    
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_bank_package.vhd").                                !! 
-- !!     (e.g. xlx_v6_gbt_bank_package.vhd)                                                    !!
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<vendor>_<device>_gbt_bank_user_setup.vhd".     !!
-- !!     (e.g. xlx_v6_gbt_bank_user_setup.vhd)                                                 !! 
-- !!                                                                                           !! 
-- !! * The "<vendor>_<device>_gbt_bank_user_setup.vhd" is the only file of the GBT Bank that   !!
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
use work.gbt_bank_package.all; 
use work.vendor_specific_gbt_bank_package.all;

--=================================================================================================--
--#######################################   Entity   ##############################################--
--=================================================================================================--

entity gbt_rx_framealigner_pattsearch is
   port (   
      
      --===============--
      -- Reset & Clock --
      --===============--    
      
      -- Reset:
      ---------
      
      RX_RESET_I                                : in  std_logic;    
      
      -- Clock:
      ---------
      
      RX_WORDCLK_I                              : in  std_logic;      
      
      --=========--
      -- Control --
      --=========--
      
      RIGHTSHIFTER_READY_I                      : in  std_logic;
      RX_WRITE_ADDRESS_I                        : in  std_logic_vector(WORD_ADDR_MSB downto 0);
      RX_BITSLIP_CMD_O                          : out std_logic;    
      RX_HEADER_LOCKED_O                        : out std_logic;   
      RX_HEADER_FLAG_O                          : out std_logic; 
      RX_GB_WRITE_ADDRESS_RST_O                 : out std_logic;
      
      --======--
      -- Word --
      --======--
      
      RX_WORD_I                                 : in  std_logic_vector(WORD_WIDTH-1 downto 0);       
      RX_WORD_O                                 : out std_logic_vector(WORD_WIDTH-1 downto 0) 
      
   );  
end gbt_rx_framealigner_pattsearch;

--=================================================================================================--
--####################################   Architecture   ###########################################-- 
--=================================================================================================--

architecture behavioral of gbt_rx_framealigner_pattsearch is
  
   --================================ Signal Declarations ================================--  
  
   signal checkedHeader                         : integer range 0 to NBR_CHECKED_HEADER;
   signal falseHeader                           : integer range 0 to NBR_ACCEPTED_FALSE_HEADER + 1;
   signal consecCorrectHeaders                  : integer range 0 to DESIRED_CONSEC_CORRECT_HEADERS;
   signal headerLocked                          : std_logic;

   --=====================================================================================--
   
--=================================================================================================--
begin                 --========####   Architecture Body   ####========-- 
--=================================================================================================--     
   
   --==================================== User Logic =====================================--   
   
   main: process (RX_RESET_I, RIGHTSHIFTER_READY_I, RX_WORDCLK_I)
      constant ZERO                             : std_logic_vector(WORD_ADDR_PS_CHECK_MSB downto 0) := (others => '0'); 
   begin    
      if (RX_RESET_I = '1') or (RIGHTSHIFTER_READY_I = '0') then
         checkedHeader                          <=  0 ;
         falseHeader                            <=  0 ;
         consecCorrectHeaders                   <=  0 ;
         headerLocked                           <= '0';
         RX_HEADER_FLAG_O                       <= '0';
         RX_GB_WRITE_ADDRESS_RST_O              <= '0';
         RX_BITSLIP_CMD_O                       <= '0';         
      elsif rising_edge(RX_WORDCLK_I) then        
         
         RX_HEADER_FLAG_O                       <= '0';         
         RX_GB_WRITE_ADDRESS_RST_O              <= '0';
         RX_BITSLIP_CMD_O                       <= '0';
         
         -- Comment: * "RX_WRITE_ADDRESS_I(WORD_ADDR_PS_CHECK_MSB downto 0)= ZERO" corresponds to the most significant word of the frame (header). 
         
         if RX_WRITE_ADDRESS_I(WORD_ADDR_PS_CHECK_MSB downto 0)= ZERO then
         
            -- Comment: Counter of false headers among a certain number of checked headers.
         
            if checkedHeader <= NBR_CHECKED_HEADER then
               checkedHeader                    <= checkedHeader + 1;
               if (RX_WORD_I(3 downto 0) /= DATA_HEADER_PATTERN_REVERSED) and (RX_WORD_I(3 downto 0) /= IDLE_HEADER_PATTERN_REVERSED) then
                  if falseHeader <= NBR_ACCEPTED_FALSE_HEADER then
                     falseHeader                <= falseHeader + 1;
                  end if;               
               end if;
            else
               checkedHeader                    <= 0;
               falseHeader                      <= 0;
            end if;         

            -- Comment: Counters of consecutive correct headers.
         
            if (RX_WORD_I(3 downto 0) = DATA_HEADER_PATTERN_REVERSED) or (RX_WORD_I(3 downto 0) = IDLE_HEADER_PATTERN_REVERSED) then
               if headerLocked = '1' then               
                  RX_HEADER_FLAG_O              <= '1';
               end if;   
               if consecCorrectHeaders < DESIRED_CONSEC_CORRECT_HEADERS then
                  consecCorrectHeaders          <= consecCorrectHeaders + 1;
               end if;
            else
               consecCorrectHeaders             <= 0;
            end if;         

            -- Comment: Out Of Lock or In Lock state decision.
            
            if (headerLocked = '0') and (consecCorrectHeaders = DESIRED_CONSEC_CORRECT_HEADERS) then   -- Comment: Goes from OOL to IL.
               headerLocked                     <= '1';
               RX_GB_WRITE_ADDRESS_RST_O        <= '1';
            elsif (headerLocked = '1') and (falseHeader >= NBR_ACCEPTED_FALSE_HEADER) then   -- Comment: Return from IL to OOL.
               headerLocked                     <= '0';
            end if;
        
         end if;

         -- Comment: Sending bit slip command.
         
         if falseHeader = NBR_ACCEPTED_FALSE_HEADER + 1 then
            RX_BITSLIP_CMD_O                    <= '1';
            checkedHeader                       <=  0 ;
            falseHeader                         <=  0 ;
         end if;      
         
      end if;
   end process;
   
   RX_HEADER_LOCKED_O                           <= headerLocked;
   RX_WORD_O                                    <= RX_WORD_I;

   --=====================================================================================--      
end behavioral;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--