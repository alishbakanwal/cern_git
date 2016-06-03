-------------------------------------------------------------------------------
-- Copyright (c) 2016 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.5
--  \   \         Application: Xilinx CORE Generator
--  /   /         Filename   : xlx_v6_chipscope_icon.vho
-- /___/   /\     Timestamp  : Thu May 05 16:14:26 Pakistan Standard Time 2016
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: ISE Instantiation template
-- Component Identifier: xilinx.com:ip:chipscope_icon:1.06.a
-------------------------------------------------------------------------------
-- The following code must appear in the VHDL architecture header:

------------- Begin Cut here for COMPONENT Declaration ------ COMP_TAG
component xlx_v6_chipscope_icon
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL1 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL2 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CONTROL3 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));

end component;

-- COMP_TAG_END ------ End COMPONENT Declaration ------------
-- The following code must appear in the VHDL architecture
-- body. Substitute your own instance name and net names.
------------- Begin Cut here for INSTANTIATION Template ----- INST_TAG

your_instance_name : xlx_v6_chipscope_icon
  port map (
    CONTROL0 => CONTROL0,
    CONTROL1 => CONTROL1,
    CONTROL2 => CONTROL2,
    CONTROL3 => CONTROL3);

-- INST_TAG_END ------ End INSTANTIATION Template ------------
