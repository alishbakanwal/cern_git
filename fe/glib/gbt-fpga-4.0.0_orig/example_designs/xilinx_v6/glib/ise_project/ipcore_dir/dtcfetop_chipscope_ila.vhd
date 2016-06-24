-------------------------------------------------------------------------------
-- Copyright (c) 2016 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.5
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : dtcfetop_chipscope_ila.vhd
-- /___/   /\     Timestamp  : Fri Jun 17 08:56:37 Pakistan Standard Time 2016
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY dtcfetop_chipscope_ila IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    TRIG0: in std_logic_vector(83 downto 0);
    TRIG1: in std_logic_vector(83 downto 0);
    TRIG2: in std_logic_vector(0 to 0);
    TRIG3: in std_logic_vector(39 downto 0);
    TRIG4: in std_logic_vector(39 downto 0);
    TRIG5: in std_logic_vector(39 downto 0);
    TRIG6: in std_logic_vector(39 downto 0);
    TRIG7: in std_logic_vector(39 downto 0);
    TRIG8: in std_logic_vector(39 downto 0);
    TRIG9: in std_logic_vector(39 downto 0);
    TRIG10: in std_logic_vector(39 downto 0);
    TRIG11: in std_logic_vector(9 downto 0));
END dtcfetop_chipscope_ila;

ARCHITECTURE dtcfetop_chipscope_ila_a OF dtcfetop_chipscope_ila IS
BEGIN

END dtcfetop_chipscope_ila_a;
