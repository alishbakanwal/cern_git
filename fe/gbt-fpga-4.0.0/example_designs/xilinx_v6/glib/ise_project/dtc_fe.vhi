
-- VHDL Instantiation Created from source file dtc_fe.vhd -- 15:13:21 05/12/2016
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT dtc_fe
	PORT(
		clk40 : IN std_logic;
		clk320 : IN std_logic;
		clk40sh : IN std_logic;          
		dtc_fe_out : OUT std_logic_vector(31 downto 0);
		eport_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;

	Inst_dtc_fe: dtc_fe PORT MAP(
		clk40 => ,
		clk320 => ,
		clk40sh => ,
		dtc_fe_out => ,
		eport_out => 
	);


