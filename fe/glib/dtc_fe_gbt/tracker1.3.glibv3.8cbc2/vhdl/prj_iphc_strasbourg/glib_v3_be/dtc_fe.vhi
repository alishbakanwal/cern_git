
-- VHDL Instantiation Created from source file dtc_fe.vhd -- 10:23:11 06/01/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT dtc_fe
	PORT(
		CLK40 : IN std_logic;
		CLK320 : IN std_logic;
		CLK40sh : IN std_logic;          
		DTC_FE_OUT : OUT std_logic_vector(31 downto 0);
		EPORT_OUT : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	Inst_dtc_fe: dtc_fe PORT MAP(
		CLK40 => ,
		CLK320 => ,
		CLK40sh => ,
		DTC_FE_OUT => ,
		EPORT_OUT => 
	);


