--=================================================================================================--
--##################################   Package Information   ######################################--
--=================================================================================================--
--                                                                                       
-- Company:               CERN (PH-ESE-BE)                                                        
-- Engineer:              Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
--                        (Original design by P. VICHOUDIS & M. BARROS MARIN)                                                                                                   
--
-- Project Name:          GBT-FPGA                                                                
-- Package Name:          GBT Bank package                                      
--                                                                                                 
-- Language:              VHDL'93                                                           
--                                                                                                 
-- Target Device:         Vendor agnostic                                                         
-- Tool version:                                                                          
--                                                                                                 
-- Revision:              1.1                                                                     
--
-- Description:            
--
-- Versions history:      DATE         VERSION   AUTHOR            DESCRIPTION
--
--                        21/06/2013   1.0       M. Barros Marin   - First .vhd package definition 
--
--                        04/07/2013   1.1       M. Barros Marin   - Merged with Constant_Declaration.vhd
--                                                                   (Authors: Frederic Marin (CPPM), Sophie BARON (CERN))            
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
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--

-- IEEE VHDL standard library:
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Custom libraries and packages:
use work.vendor_specific_gbt_bank_package.all;
use work.gbt_banks_user_setup.all;

--=================================================================================================--
--##################################   Package Declaration   ######################################--
--=================================================================================================--

package gbt_bank_package is  
  
   --================================ Record Declarations ================================--
   
   --===============--
   -- Clocks scheme --
   --===============--

   type gbtBankClks_i_R is
   record
      mgt_clks                                  : gbtBankMgtClks_i_R;
      ------------------------------------------         
      tx_frameClk                               : std_logic;
      rx_frameClk                               : std_logic_vector(1 to MAX_NUM_GBT_LINK);        
   end record;     
       
   type gbtBankClks_o_R is  
   record       
      mgt_clks                                  : gbtBankMgtClks_o_R;
   end record; 

   --=================--
   -- GBT transmitter --
   --=================--
      
   type gbtTx_i_R is   
   record   
      reset                                     : std_logic;
      ------------------------------------------     
      encodingSel                               : std_logic_vector( 1 downto 0);
      ------------------------------------------
      isDataSel                                 : std_logic;
      ------------------------------------------         
      data                                      : std_logic_vector(83 downto 0);
      widebusExtraData                          : std_logic_vector(31 downto 0);
      enc8b10bExtraData                         : std_logic_vector( 1 downto 0);
   end record; 
   
   --==============--
   -- GBT receiver --
   --==============--   
      
   type gbtRx_i_R is   
   record   
      reset                                     : std_logic;
      ------------------------------------------     
      encodingSel                               : std_logic_vector( 1 downto 0);
   end record;                
                  
   type gbtRx_o_R is             
   record               
      descrRdy                                  : std_logic;   -- Comment: This signal will be removed in future revisions
      ------------------------------------------        
      bitSlip_nbr                               : std_logic_vector(GBTRX_BITSLIP_NBR_MSB downto 0);
      ------------------------------------------        
      header_flag                               : std_logic;
      header_lockedFlag                         : std_logic;
      ------------------------------------------        
      isDataFlag                                : std_logic;
      ------------------------------------------
      data                                      : std_logic_vector(83 downto 0);
      widebusExtraData                          : std_logic_vector(31 downto 0);
      enc8b10bExtraData                         : std_logic_vector( 1 downto 0);
   end record;
   
   --=====================================================================================--
   
   --================================= Array Declarations ================================--
   
   --========--
   -- Common --
   --========--     
   
   type word_nbit_A                             is array (natural range <>) of std_logic_vector(WORD_WIDTH-1 downto 0);      
            
   --=================--         
   -- GBT Transmitter --         
   --=================--            
            
   type gbtTx_i_R_A                             is array (natural range <>) of gbtTx_i_R;                              
            
   type scramblerResetPatterns_21bit_A          is array (natural range <>) of std_logic_vector(20 downto 0);
   type scramblerResetPatterns_16bit_A          is array (natural range <>) of std_logic_vector(15 downto 0);
         
   --==============--                                                                                       
   -- GBT Receiver --               
   --==============--                  
            
   type gbtRx_i_R_A                             is array (natural range <>) of gbtRx_i_R;
   type gbtRx_o_R_A                             is array (natural range <>) of gbtRx_o_R;
   
   --=====================================================================================--   
   
   --=============================== Constant Declarations ===============================--
  
   --========--
   -- Common --
   --========--
   
   -- GBT frame header:
   --------------------
   
   constant DATA_HEADER_PATTERN                 : std_logic_vector(3 downto 0) := "0101";                   
   constant DATA_HEADER_PATTERN_REVERSED        : std_logic_vector(3 downto 0) := DATA_HEADER_PATTERN(0) &
                                                                                  DATA_HEADER_PATTERN(1) &
                                                                                  DATA_HEADER_PATTERN(2) &
                                                                                  DATA_HEADER_PATTERN(3);   
            
   constant IDLE_HEADER_PATTERN                 : std_logic_vector(3 downto 0) := "0110";                   
   constant IDLE_HEADER_PATTERN_REVERSED        : std_logic_vector(3 downto 0) := IDLE_HEADER_PATTERN(0) &
                                                                                  IDLE_HEADER_PATTERN(1) &
                                                                                  IDLE_HEADER_PATTERN(2) &
                                                                                  IDLE_HEADER_PATTERN(3);   
      
   -- Comment: * DESIRED_CONSEC_CORRECT_HEADERS: Number of correct headers found after which we
   --                                            declared to have found the correct boundary.
   --
   --          * NB_ACCEPTED_FALSE_HEADER: Number of false header we accept to find within "Nb_Checked_Header" 
   --                                      checked headers without declaring to have lost the boundary.
   
   constant NBR_CHECKED_HEADER                  : integer := 64;   
   constant NBR_ACCEPTED_FALSE_HEADER           : integer :=  4;
   constant DESIRED_CONSEC_CORRECT_HEADERS      : integer := 23;
   
   --=================--
   -- GBT Transmitter -- 
   --=================--
   
   -- 84bit scrambler (GBT frame):
   -------------------------------
   
   -- Comment: Value of SCRAMBLER_21BIT_RESET_PATTERNS[1:4] chosen arbitrarily except the
   --          last byte (=0 because it is OR-ed with i during multiple instantiations).
   
   constant SCRAMBLER_21BIT_RESET_PATTERNS      : scramblerResetPatterns_21bit_A := ('1' & x"A23E0",
                                                                                     '0' & x"F4350",
                                                                                     '1' & x"3EDC0",
                                                                                     '0' & x"78E20"); 

   -- 32bit scrambler (Wide-bus):
   -------------------------------
   
   -- Comment: Value of SCRAMBLER_16BIT_RESET_PATTERNS[1:2] chosen arbitrarily except the 
   --          last byte (=0 because it is OR-ed with i during multiple instantiations).
   
   constant SCRAMBLER_16BIT_RESET_PATTERNS      : scramblerResetPatterns_16bit_A := (x"23E0",
                                                                                     x"4350");                                                                                
                                                                                
   --=====================================================================================--  

   --======================== Function and Procedure Declarations ========================--
   
   --========--
   -- Common --
   --========--
   
   -- GBT frame encoding:
   ----------------------
   
   function gf16add (signal input1, input2 : in std_logic_vector(3 downto 0)) return std_logic_vector;                                 
   function gf16mult(signal input1, input2 : in std_logic_vector(3 downto 0)) return std_logic_vector;                                       
   
   --=====================================================================================--
   
end gbt_bank_package;

package body gbt_bank_package is

   --=========================== Function and Procedure Bodies ===========================--

   --========--
   -- Common --
   --========--
   
   -- GBT frame encoding:
   ----------------------
   
   function gf16add(signal input1, input2 : in std_logic_vector(3 downto 0)) return std_logic_vector is
      variable output                           : std_logic_vector(3 downto 0);
   begin
      output(0)	                              := input1(0) XOR input2(0);
      output(1)	                              := input1(1) XOR input2(1);
      output(2)	                              := input1(2) XOR input2(2);
      output(3)	                              := input1(3) XOR input2(3);
      return output;
   end function;

   function gf16mult(signal input1, input2 : in std_logic_vector(3 downto 0)) return std_logic_vector is    
      variable output                           : std_logic_vector(3 downto 0);
   begin
   	output(0) := (input1(0) AND input2(0)) XOR (input1(3) AND input2(1)) XOR (input1(2) AND input2(2)) XOR (input1(1) AND input2(3));
      output(1) := (input1(1) AND input2(0)) XOR (input1(0) AND input2(1)) XOR (input1(3) AND input2(1)) XOR (input1(2) AND input2(2)) XOR (input1(3) AND input2(2)) XOR (input1(1) AND input2(3)) XOR (input1(2) AND input2(3));
      output(2) := (input1(2) AND input2(0)) XOR (input1(1) AND input2(1)) XOR (input1(0) AND input2(2)) XOR (input1(3) AND input2(2)) XOR (input1(2) AND input2(3)) XOR (input1(3) AND input2(3));
      output(3) := (input1(3) AND input2(0)) XOR (input1(2) AND input2(1)) XOR (input1(1) AND input2(2)) XOR (input1(0) AND input2(3)) XOR (input1(3) AND input2(3));
      return output;
   end function;   
   
   --=====================================================================================--
   
end gbt_bank_package;
--=================================================================================================--
--#################################################################################################--
--=================================================================================================--