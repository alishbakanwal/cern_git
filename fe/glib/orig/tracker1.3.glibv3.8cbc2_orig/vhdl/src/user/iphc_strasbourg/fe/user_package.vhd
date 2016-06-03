library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
 
package user_package is

	--=== system options ========--
   constant sys_eth_p1_enable       : boolean  := false;   
   constant sys_pcie_enable         : boolean  := false;   
   
   -- (Note!! Add user_sys_pcie_constants_package.vhd if system pcie enabled)
  
	--=== i2c master components ==--
	constant i2c_master_enable			: boolean  := true;
	constant auto_eeprom_read_enable	: boolean  := true;    

	--=== wishbone slaves ========--
	constant number_of_wb_slaves		: positive := 1 ;
	
--	constant user_wb_regs				: integer  := 0 ;
--	constant user_wb_timer				: integer  := 1 ;
	constant user_wb_fe					: integer  := 0 ;	
	
	--=== ipb slaves =============--
	constant number_of_ipb_slaves		: positive := 2 ;
   
	constant user_ipb_stat_regs		: integer  := 0 ;
	constant user_ipb_ctrl_regs		: integer  := 1 ;
	


	--=== arrays declaration =====--	
	

	--REG CTRL
	constant	REG_CTRL_WORD_DEPTH						: natural := 5;
	constant	REG_CTRL_WORD_NB							: natural := 2**REG_CTRL_WORD_DEPTH;
	
	constant HEADER_ADDR_REG_CTRL						: std_logic_vector(31 downto 0+REG_CTRL_WORD_DEPTH) 	:= std_logic_vector(to_unsigned(0,32-REG_CTRL_WORD_DEPTH)); --x"000000";
	
	type array_REG_CTRL_WORD_DEPTHx32 				is array (REG_CTRL_WORD_NB-1 downto 0) of std_logic_vector(31 downto 0);
	signal REG_CTRL										: array_REG_CTRL_WORD_DEPTHx32;

	--REG STATUS
	--comment: REG_STATUS_WORD_DEPTH >or= REG_CTRL_WORD_DEPTH
	constant	REG_STATUS_WORD_DEPTH					: natural := 5;
	constant	REG_STATUS_WORD_NB						: natural := 2**REG_STATUS_WORD_DEPTH;
	
	constant HEADER_ADDR_REG_STATUS					: std_logic_vector(31 downto 0+REG_STATUS_WORD_DEPTH) := std_logic_vector(to_unsigned(1,32-REG_STATUS_WORD_DEPTH));

	type array_REG_STATUS_WORD_DEPTHx32 			is array (REG_STATUS_WORD_NB-1 downto 0) of std_logic_vector(31 downto 0);
	signal REG_STATUS										: array_REG_STATUS_WORD_DEPTHx32;		

	
	
	
	
	
end user_package;
   
package body user_package is
end user_package;