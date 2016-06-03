-------------------------------------------------------------------------------
-- Copyright (c) 2013 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.6
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : ila_TwoTrig84b.vhd
-- /___/   /\     Timestamp  : Tue Oct 15 16:28:59 Paris, Madrid (heure d'été) 2013
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY ila_TwoTrig84b IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    TRIG0: in std_logic_vector(83 downto 0);
    TRIG1: in std_logic_vector(83 downto 0));
END ila_TwoTrig84b;

ARCHITECTURE ila_TwoTrig84b_a OF ila_TwoTrig84b IS
BEGIN

END ila_TwoTrig84b_a;
