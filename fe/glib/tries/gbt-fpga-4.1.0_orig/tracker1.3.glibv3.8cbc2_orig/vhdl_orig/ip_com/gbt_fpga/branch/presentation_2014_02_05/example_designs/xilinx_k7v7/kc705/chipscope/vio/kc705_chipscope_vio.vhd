-------------------------------------------------------------------------------
-- Copyright (c) 2014 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.5
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : kc705_chipscope_vio.vhd
-- /___/   /\     Timestamp  : Thu Jan 09 13:43:02 W. Europe Standard Time 2014
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY kc705_chipscope_vio IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    ASYNC_IN: in std_logic_vector(16 downto 0);
    SYNC_OUT: out std_logic_vector(11 downto 0));
END kc705_chipscope_vio;

ARCHITECTURE kc705_chipscope_vio_a OF kc705_chipscope_vio IS
BEGIN

END kc705_chipscope_vio_a;
