-------------------------------------------------------------------------------
-- Copyright (c) 2013 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.5
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : xlx_v6_chipscope_icon.vhd
-- /___/   /\     Timestamp  : Fri Oct 04 14:42:10 W. Europe Daylight Time 2013
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY xlx_v6_chipscope_icon IS
  port (
    CONTROL0: inout std_logic_vector(35 downto 0);
    CONTROL1: inout std_logic_vector(35 downto 0);
    CONTROL2: inout std_logic_vector(35 downto 0));
END xlx_v6_chipscope_icon;

ARCHITECTURE xlx_v6_chipscope_icon_a OF xlx_v6_chipscope_icon IS
BEGIN

END xlx_v6_chipscope_icon_a;
