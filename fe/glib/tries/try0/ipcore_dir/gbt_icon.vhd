-------------------------------------------------------------------------------
-- Copyright (c) 2016 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.5
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : gbt_icon.vhd
-- /___/   /\     Timestamp  : Tue Jul 19 10:45:06 Pakistan Standard Time 2016
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY gbt_icon IS
  port (
    CONTROL0: inout std_logic_vector(35 downto 0));
END gbt_icon;

ARCHITECTURE gbt_icon_a OF gbt_icon IS
BEGIN

END gbt_icon_a;
