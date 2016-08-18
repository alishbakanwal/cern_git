-------------------------------------------------------------------------------
-- Copyright (c) 2016 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.5
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : ila_TwoTrig84b_TwoTrig87b.vhd
-- /___/   /\     Timestamp  : Wed Aug 03 16:09:53 Pakistan Standard Time 2016
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY ila_TwoTrig84b_TwoTrig87b IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    TRIG0: in std_logic_vector(83 downto 0);
    TRIG1: in std_logic_vector(83 downto 0);
    TRIG2: in std_logic_vector(86 downto 0);
    TRIG3: in std_logic_vector(86 downto 0));
END ila_TwoTrig84b_TwoTrig87b;

ARCHITECTURE ila_TwoTrig84b_TwoTrig87b_a OF ila_TwoTrig84b_TwoTrig87b IS
BEGIN

END ila_TwoTrig84b_TwoTrig87b_a;
