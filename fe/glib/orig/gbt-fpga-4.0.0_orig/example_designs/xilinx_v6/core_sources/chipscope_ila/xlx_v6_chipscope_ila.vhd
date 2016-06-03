-------------------------------------------------------------------------------
-- Copyright (c) 2016 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.7
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : xlx_v6_chipscope_ila.vhd
-- /___/   /\     Timestamp  : Fri Apr 08 09:26:15 W. Europe Daylight Time 2016
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY xlx_v6_chipscope_ila IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    TRIG0: in std_logic_vector(83 downto 0);
    TRIG1: in std_logic_vector(31 downto 0);
    TRIG2: in std_logic_vector(0 to 0));
END xlx_v6_chipscope_ila;

ARCHITECTURE xlx_v6_chipscope_ila_a OF xlx_v6_chipscope_ila IS
BEGIN

END xlx_v6_chipscope_ila_a;
