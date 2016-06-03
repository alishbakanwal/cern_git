-------------------------------------------------------------------------------
-- Copyright (c) 2016 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.7
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : xlx_v6_chipscope_vio.vhd
-- /___/   /\     Timestamp  : Fri Apr 08 15:28:15 W. Europe Daylight Time 2016
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY xlx_v6_chipscope_vio IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    ASYNC_IN: in std_logic_vector(17 downto 0);
    SYNC_OUT: out std_logic_vector(12 downto 0));
END xlx_v6_chipscope_vio;

ARCHITECTURE xlx_v6_chipscope_vio_a OF xlx_v6_chipscope_vio IS
BEGIN

END xlx_v6_chipscope_vio_a;
