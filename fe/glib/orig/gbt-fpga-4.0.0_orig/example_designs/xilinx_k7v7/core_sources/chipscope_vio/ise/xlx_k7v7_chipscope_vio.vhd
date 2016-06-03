-------------------------------------------------------------------------------
-- Copyright (c) 2014 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.5
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : xlx_k7v7_chipscope_vio.vhd
-- /___/   /\     Timestamp  : Thu Mar 06 09:21:27 W. Europe Standard Time 2014
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY xlx_k7v7_chipscope_vio IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    ASYNC_IN: in std_logic_vector(17 downto 0);
    SYNC_OUT: out std_logic_vector(11 downto 0));
END xlx_k7v7_chipscope_vio;

ARCHITECTURE xlx_k7v7_chipscope_vio_a OF xlx_k7v7_chipscope_vio IS
BEGIN

END xlx_k7v7_chipscope_vio_a;
