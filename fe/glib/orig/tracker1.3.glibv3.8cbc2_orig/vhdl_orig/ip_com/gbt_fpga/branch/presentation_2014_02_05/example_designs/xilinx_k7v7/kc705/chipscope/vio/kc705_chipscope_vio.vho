-------------------------------------------------------------------------------
-- Copyright (c) 2014 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.5
--  \   \         Application: Xilinx CORE Generator
--  /   /         Filename   : kc705_chipscope_vio.vho
-- /___/   /\     Timestamp  : Thu Jan 09 13:43:02 W. Europe Standard Time 2014
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: ISE Instantiation template
-- Component Identifier: xilinx.com:ip:chipscope_vio:1.05.a
-------------------------------------------------------------------------------
-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component kc705_chipscope_vio
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    ASYNC_IN : IN STD_LOGIC_VECTOR(16 DOWNTO 0);
    SYNC_OUT : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));

end component;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------
-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG

your_instance_name : kc705_chipscope_vio
  port map (
    CONTROL => CONTROL,
    CLK => CLK,
    ASYNC_IN => ASYNC_IN,
    SYNC_OUT => SYNC_OUT);

-- INST_TAG_END ------ End INSTANTIATION Template ------------
