--=================================================================================================--
--==================================== Module Information =========================================--
--=================================================================================================--
--																															  	
-- Company:  				CERN (PH-ESE-BE)																			
-- Engineer: 				Manoel Barros Marin (manoel.barros.marin@cern.ch) (m.barros.marin@ieee.org)
-- 																															
-- Create Date:		   09/12/2011																					
-- Project Name:			glib_sram_interface																		
-- Module Name:   		glib_sram_interface_wrapper				 											
-- 																															
-- Language:				VHDL'93																						
--																																
-- Target Devices: 		GLIB (Virtex 6)																			
-- Tool versions: 		ISE 13.2																						
--																																
-- Revision:		 		2.6 																							
--																																
-- Additional Comments: 																								
--		                                                                                          
--   - This interface comply the WishBone SoC bus specification                                 
--                                                                                              
--   - With this configuration the latencies are:                                               
--                                                                                              
--	    * Writing: 3 cycles							                                                   
--     * Reading: 4 cycles						                                                      
--			                                                                                       
--   - Maximum USER clk frequency:                                                              
--                                                                                              
--     * 160MHz                                                                                 
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
-- User libraries and packages:
use work.ipbus.all;
use work.system_flash_sram_package.all;
--=================================================================================================--
--======================================= Module Body =============================================-- 
--=================================================================================================--
entity glib_sram_interface_wrapper is
	generic (		
		-- Built Int Self Test(BIST):
		BIST_MAXADDRESSWRITE										: natural := 2*(2**20) - 1;	-- 2M positions of the memory
		BIST_INITIALDELAY											: natural := 160	
	);					
	port (			
		-- Control:
		RESET_I														: in  std_logic;
		USER_SELECT_I												: in  std_logic; 	-- 0: IPBus, 1: User
		-- IPbus:         	
		IPBUS_CLK_I													: in  std_logic;		
		IPBUS_BIST_I												: in  wBistTestR;
		IPBUS_I														: in 	ipb_wbus;	
		IPBUS_O														: out ipb_rbus;	
		-- User:		        		
		USER_CONTROL_I												: in  userSramControlR;
		USER_BIST_I													: in  wBistTestR;
		USER_ADDR_I	   											: in  std_logic_vector(20 downto 0);
		USER_DATA_O	      										: out std_logic_vector(35 downto 0);
		USER_DATA_I		   										: in  std_logic_vector(35 downto 0);						
		-- BIST (Built In Self Test):
		BIST_SEED_I													: in 	std_logic_vector(6 downto 0);
		BIST_TEST_O													: out rBistTestR;								
		-- SRAM side:				
		SRAM_I														: in  rSramR;	
		SRAM_O														: out wSramR		
	);
end glib_sram_interface_wrapper;
architecture structural of glib_sram_interface_wrapper is
	--======================== Signal Declarations ========================--	
	-- Clock signals:
	signal sramIntClk_from_sramInterfaceIoControl		: std_logic;
	signal bistClk_from_sramInterfaceIoControl			: std_logic;
	-- SRAM interface input/output control:	
	signal sramIntReset_from_sramInterfaceIoControl 	: std_logic;		
	signal cs_from_sramInterfaceIoControl					: std_logic;	
	signal write_from_sramInterfaceIoControl				: std_logic;			
	signal addr_from_sramInterfaceIoControl				: std_logic_vector(20 downto 0); 	
	signal sramData_from_sramInterfaceIoControl			: std_logic_vector(35 downto 0); 
	signal bistData_from_sramInterfaceIoControl			: std_logic_vector(35 downto 0); 
	signal bistReset_from_sramInterfaceIoControl			: std_logic;
	signal bistEnable_from_sramInterfaceIoControl 		: std_logic;
	signal bistErrInject_from_sramInterfaceIoControl	: std_logic;
	-- SRAM interface:	
	signal data_from_sramInterface							: std_logic_vector(35 downto 0); 	
	-- BIST:	
	signal testDone_from_bist									: std_logic;	
	signal cs_from_bist											: std_logic;	
	signal write_from_bist										: std_logic;	
	signal addr_from_bist										: std_logic_vector(20 downto 0);
	signal data_from_bist										: std_logic_vector(35 downto 0); 	
	--=====================================================================--	
--========================================================================--
-----		  --===================================================--
begin		--================== Architecture Body ==================-- 
-----		  --===================================================--
--========================================================================--	
	--========================= Port Assignments ==========================--
	BIST_TEST_O.testDone											<= testDone_from_bist;		
	--=====================================================================--	
	--=====================================================================--
	--===================== Component Instantiations ======================--	
	-- SRAM interface I/O control:
	sramInterfaceIoControl: entity work.glib_sram_interface_ioControl
		port map (			
			-- Control:
			USER_SELECT_I											=> USER_SELECT_I,
			-- IPbus:
			IPBUS_CLK_I 											=> IPBUS_CLK_I, 
			IPBUS_RESET_I											=> RESET_I,					
			IPBUS_STROBE_I	   									=> IPBUS_I.ipb_strobe,
			IPBUS_WRITE_I	   									=> IPBUS_I.ipb_write,				
			IPBUS_TEST_I 											=> IPBUS_BIST_I.test, 	
			IPBUS_BIST_ERRINJECT_I 								=> IPBUS_BIST_I.errInject,			
			IPBUS_ADDR_I      									=> IPBUS_I.ipb_addr,   
			IPBUS_WDATA_I	   									=> IPBUS_I.ipb_wdata,	
			IPBUS_RDATA_O											=> IPBUS_O.ipb_rdata,		
			IPBUS_ACK_O												=> IPBUS_O.ipb_ack,
			IPBUS_ERR_O												=> IPBUS_O.ipb_err,
			-- User:		
			USER_CLK_I     										=> USER_CONTROL_I.clk,
			USER_RESET_I											=> USER_CONTROL_I.reset,	     
			USER_CS_I												=> USER_CONTROL_I.cs,		
			USER_WRITE_I											=> USER_CONTROL_I.writeEnable,			
			USER_TEST_I 											=> USER_BIST_I.test, 	
			USER_BIST_ERRINJECT_I 								=> USER_BIST_I.errInject, 					
			USER_ADDR_I	   										=> USER_ADDR_I,	   
			USER_DATA_I												=> USER_DATA_I,	
			USER_DATA_O												=> USER_DATA_O,	
			-- Built In Self Test:		
			BIST_RESET_O 											=> bistReset_from_sramInterfaceIoControl,
			BIST_CLK_O												=> bistClk_from_sramInterfaceIoControl,											
			BIST_ENABLE_O 											=> bistEnable_from_sramInterfaceIoControl,
			BIST_ERRINJECT_O										=> bistErrInject_from_sramInterfaceIoControl,
			BIST_CS_I 												=> cs_from_bist,
			BIST_WRITE_I 											=> write_from_bist,
			BIST_ADDR_I 											=> addr_from_bist,
			BIST_DATA_I 											=> data_from_bist,
			BIST_DATA_O 											=> bistData_from_sramInterfaceIoControl,
			BIST_TESTDONE_I										=> testDone_from_bist,
			-- SRAM interface:		
			SRAMINT_RESET_O										=> sramIntReset_from_sramInterfaceIoControl,			
			SRAMINT_CLK_O											=> sramIntClk_from_sramInterfaceIoControl,
			SRAMINT_CS_O 											=> cs_from_sramInterfaceIoControl,
			SRAMINT_WRITE_O 										=> write_from_sramInterfaceIoControl,
			SRAMINT_ADDR_O 										=> addr_from_sramInterfaceIoControl,
			SRAMINT_DATA_I 										=> data_from_sramInterface,
			SRAMINT_DATA_O 										=> sramData_from_sramInterfaceIoControl			
		);		
	-- SRAM interface:
	sramInterface: entity work.glib_sram_interface		
		port map (		
			-- Logic Fabric side:						
			RESET_I													=>	sramIntReset_from_sramInterfaceIoControl,						
			CLK_I														=>	sramIntClk_from_sramInterfaceIoControl,							
			CS_I														=>	cs_from_sramInterfaceIoControl,			
			WRITE_I													=>	write_from_sramInterfaceIoControl,							
			ADDR_I													=>	addr_from_sramInterfaceIoControl,							
			DATA_I													=>	sramData_from_sramInterfaceIoControl,							
			DATA_O													=>	data_from_sramInterface,			
			-- SRAM side:				
			CLK_O														=>	SRAM_O.clk,										
			CE1_B_O													=>	SRAM_O.ce1_b,								
			CEN_B_O													=>	SRAM_O.cen_b,											
			OE_B_O													=>	SRAM_O.oe_b,								
			WE_B_O													=>	SRAM_O.we_b,				
			TRISTATECTRL_O											=> SRAM_O.tristateCtrl,
			MODE_O													=>	SRAM_O.mode,
			ADV_LD_O													=>	SRAM_O.adv_ld,		
			ADDR_O													=>	SRAM_O.addr,		
			SRAM_DATA_O												=>	SRAM_O.data,
			SRAM_DATA_I												=>	SRAM_I.data	
		);				
	-- Built In Self Test (BIST):		
	bist: entity work.glib_sram_interface_bist		
		generic map (		
			MAXADDRESSWRITE										=> BIST_MAXADDRESSWRITE,
			INITIALDELAY											=> BIST_INITIALDELAY,				
			READDATADELAY   										=>	20,	
			PRBSENABLEDELAY										=> 4,		-- 4 (These are the correct values)
			COMPAREDATADELAY										=> 3)		-- 3   
		port map (		
			RESET_I													=>	bistReset_from_sramInterfaceIoControl,							
			CLK_I                								=> bistClk_from_sramInterfaceIoControl,			
			ENABLE_I													=> bistEnable_from_sramInterfaceIoControl,
			ERRINJECT_I												=> bistErrInject_from_sramInterfaceIoControl,
			SEED_I													=> BIST_SEED_I,
			STARTERRINJ_O											=> BIST_TEST_O.startErrInj,
			CS_O														=>	cs_from_bist,			
			WRITE_O		         								=> write_from_bist,		
			ADDR_O 	      										=> addr_from_bist,		
			DATA_O	       										=> data_from_bist,
			DATA_I	       										=>	bistData_from_sramInterfaceIoControl,
		   TESTDONE_O	         								=> testDone_from_bist,
			TESTRESULT_O         								=> BIST_TEST_O.testResult,
			ERRORCOUNTER_O											=> BIST_TEST_O.errCounter
		);			
	--=====================================================================--		
end structural;
--=================================================================================================--
--=================================================================================================--