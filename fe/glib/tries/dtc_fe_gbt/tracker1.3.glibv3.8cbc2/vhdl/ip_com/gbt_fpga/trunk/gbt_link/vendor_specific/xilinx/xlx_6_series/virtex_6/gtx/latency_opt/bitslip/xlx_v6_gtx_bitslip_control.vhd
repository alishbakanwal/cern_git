--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                         
-- Company:                CERN (PH-ESE-BE)                                                         
-- Engineer:               Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                                                                                                 
-- Project Name:           GBT-FPGA                                                                
-- Module Name:            Xilinx Virtex 6 GTX bitslip control                                       
--                                                                                                 
-- Language:               VHDL'93                                                                  
--                                                                                                   
-- Target Device:          Xilinx Virtex 6                                                         
-- Tool version:           ISE 14.5                                                                
--                                                                                                   
-- Version:                1.2                                                                      
--
-- Description:            
--
-- Versions history:       DATE         VERSION   AUTHOR            DESCRIPTION
--
--                         26/10/2011   1.0       M. BARROS MARIN   - First .vhd module definition
--
--                         22/06/2013   1.1       M. BARROS MARIN   - New module name and cosmetic modifications 
--
--                         25/06/2013   1.2       M. BARROS MARIN   - Added DONE_O flag. 
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

--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity xlx_v6_gtx_bitslip_control is
   generic (         
      DELAYBETWEENBITSLIPS                      : natural := 20 -- Note!!! DELAYBETWEENBITSLIPS >= 16 RXUSRCLK2 cycles
   );       
   port (         
      RESET_I                                   : in  std_logic;
      RXWORDCLK_I                               : in  std_logic;
      NUMBITSLIPS_I                             : in  std_logic_vector(4 downto 0);
      ENABLE_I                                  : in  std_logic;
      BITSLIP_O                                 : out std_logic;
      DONE_O                                    : out std_logic
   );
end xlx_v6_gtx_bitslip_control;
architecture structural of xlx_v6_gtx_bitslip_control is

--========================================================================--
-----        --===================================================--
begin      --================== Architecture Body ==================-- 
-----        --===================================================--
--========================================================================--   
   
   --============================ User Logic =============================--
      
   main_process: process(RESET_I, RXWORDCLK_I)
      type stateT is (e0_idle, e1_bitslipOrFinish, e2_doBitslip, e3_wait16cycles);
      variable state                            : stateT;
      variable bitslips                         : unsigned(4 downto 0);
      variable   counter                        : natural range 0 to DELAYBETWEENBITSLIPS - 1;   
   begin       
      if RESET_I = '1' then      
         state                                  := e0_idle;
         bitslips                               := (others => '0');
         counter                                := 0;
         DONE_O                                 <= '0';
         BITSLIP_O                              <= '0';
      elsif rising_edge(RXWORDCLK_I) then    
         -- Finite State Machine(FSM):    
         case state is     
            when e0_idle =>      
               if ENABLE_I = '1' then     
                  DONE_O                        <= '0';
                  state                         := e1_bitslipOrFinish;
                  bitslips                      := unsigned(NUMBITSLIPS_I);                  
               end if;     
            when e1_bitslipOrFinish =>                   
               if bitslips = 0 then    
                  DONE_O                        <= '1';
                  if ENABLE_I = '0' then     
                     state                      := e0_idle;
                  end if;        
               else     
                  state                         := e2_doBitslip;
                  bitslips                      := bitslips - 1;
               end if;                    
            when e2_doBitslip =>                   
               state                            := e3_wait16cycles;
               BITSLIP_O                        <= '1';            
            when e3_wait16cycles =>    
               BITSLIP_O                        <= '0';
               if counter = DELAYBETWEENBITSLIPS - 1 then
                  state                         := e1_bitslipOrFinish;
                  counter                       := 0;
               else     
                  counter                       := counter + 1;
               end if;
         end case;
      end if;
   end process;
   
   --=====================================================================--   
end structural;
--=================================================================================================--
--=================================================================================================--