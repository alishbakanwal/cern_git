-------------------------------------------------------------------------------
-- Copyright (c) 2014 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.5
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : xlx_k7v7_chipscope_ila.vhd
-- /___/   /\     Timestamp  : Thu Mar 06 09:06:01 W. Europe Standard Time 2014
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY xlx_k7v7_chipscope_ila IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    TRIG0: in std_logic_vector(83 downto 0);
    TRIG1: in std_logic_vector(31 downto 0);
    TRIG2: in std_logic_vector(3 downto 0);
    TRIG3: in std_logic_vector(0 to 0));
END xlx_k7v7_chipscope_ila;

ARCHITECTURE xlx_k7v7_chipscope_ila_a OF xlx_k7v7_chipscope_ila IS
BEGIN

END xlx_k7v7_chipscope_ila_a;
