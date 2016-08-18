--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--                                                                                         
-- Company:                 CERN (PH-ESE-BE)                                                         
-- Engineer:                Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                          (Original design by Xilinx)   
--                                                                                                 
-- Project Name:            GBT-FPGA                                                                
-- Module Name:             Xilinx Virtex 6 standard GTX double reset                                        
--                                                                                                 
-- Language:                VHDL'93                                                                  
--                                                                                                   
-- Target Device:           Xilinx Virtex 6                                                         
-- Tool version:            ISE 14.5                                                               
--                                                                                                   
-- Version:                 1.0                                                                      
--
-- Description:             
--
-- Versions history:        DATE         VERSION   AUTHOR              DESCRIPTION
--
--                          10/07/2013   1.0       M. BARROS MARIN     - First .vhd module definition           
--
-- Additional Comments:                                                                               
--
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! IMPORTANT !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!                                                                                           !!
-- !! * The different parameters of the GBT Bank are set through:                               !!  
-- !!                                                                                           !!
-- !!   - The MGT control ports of the GBT Bank module (these ports are listed in the records   !!
-- !!     of the file "<vendor>_<device>_gbt_link_package.vhd").                                !!  
-- !!                                                                                           !!  
-- !!   - By modifying the content of the file "<hardware_platform>_gbt_link_user_setup.vhd".   !!
-- !!                                                                                           !!
-- !!   (Note!! These parameters are vendor specific).                                          !!                    
-- !!                                                                                           !! 
-- !! * The "<hardware_platform>_gbt_link_user_setup.vhd" is the only file of the GBT Bank that !!
-- !!   may be modified by the user. The rest of the files MUST be used as is.                  !!
-- !!                                                                                           !!  
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--                                                                                                   
--=================================================================================================--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--

entity xlx_v6_gtx_std_double_reset is
   port(
   
      --=======--
      -- Clock --
      --=======--  
      
      CLK_I                                     :   in  std_logic;
               
      --=======--       
      -- Input --       
      --=======--                
               
      PLLLKDET_I                                :   in  std_logic;      
               
      --========--         
      -- Output --         
      --========--         
            
      GTXTEST_DONE_O                            :   out std_logic;
      GTXTEST_BIT1_O                            :   out std_logic
      
   );
end xlx_v6_gtx_std_double_reset;
architecture behavioral of xlx_v6_gtx_std_double_reset is

--===========================================================================--
-----     --===================================================--
begin   --================== Architecture Body ==================-- 
-----     --===================================================--
--===========================================================================--

   --============================= User Logic ===============================--

   main: process(PLLLKDET_I, CLK_I)
      constant MAX_IDLE_COUNT                   : integer := 1024;
      constant MAX_RESET_COUNT                  : integer :=  256;
      type state_T                              is (e0_idle, e1_1stResetHigh, e2_1stResetLow,
                                                   e3_2stResetHigh, e4_2stResetLow, e5_assertDone,
                                                   e6_deassertDone);
      variable state                            : state_T;
      variable timer                            : integer range 0 to MAX_IDLE_COUNT;
   begin       
      if PLLLKDET_I = '0' then         
         state                                  := e0_idle; 
         GTXTEST_BIT1_O                         <= '0';
         GTXTEST_DONE_O                         <= '0';
      elsif rising_edge(CLK_I) then
         case state is
            when e0_idle =>
               if timer = MAX_IDLE_COUNT then
                  state                         := e1_1stResetHigh;  
                  timer                         := 0;
               else        
                  timer                         := timer + 1;
               end if;        
            when e1_1stResetHigh =>       
               GTXTEST_BIT1_O                   <= '1';
               if timer = MAX_RESET_COUNT then
                  state                         := e2_1stResetLow;  
                  timer                         := 0;
               else        
                  timer                         := timer + 1;
               end if;        
            when e2_1stResetLow =>        
               GTXTEST_BIT1_O                   <= '0';
               if timer = MAX_RESET_COUNT then
                  state                         := e3_2stResetHigh;  
                  timer                         := 0;
               else        
                  timer                         := timer + 1;
               end if;        
            when e3_2stResetHigh =>       
               GTXTEST_BIT1_O                   <= '1';
               if timer = MAX_RESET_COUNT then
                  state                         := e4_2stResetLow;  
                  timer                         := 0;
               else        
                  timer                         := timer + 1;
               end if;           
            when e4_2stResetLow =>        
               GTXTEST_BIT1_O                   <= '0';
               if timer = MAX_RESET_COUNT then
                  state                         := e5_assertDone;  
                  timer                         := 0;
               else        
                  timer                         := timer + 1;
               end if;              
            when e5_assertDone =>         
               GTXTEST_DONE_O                   <= '1';           
               state                            := e6_deassertDone;  
            when e6_deassertDone =>       
               GTXTEST_DONE_O                   <= '0'; 
         end case;
      end if;
   end process;

   --========================================================================--   
end behavioral;
--=================================================================================================--
--=================================================================================================--