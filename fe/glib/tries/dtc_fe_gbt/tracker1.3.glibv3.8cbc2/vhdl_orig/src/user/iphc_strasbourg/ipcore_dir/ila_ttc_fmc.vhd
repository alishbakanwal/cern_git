-------------------------------------------------------------------------------
-- Copyright (c) 2012 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 13.4
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : ila_ttc_fmc.vhd
-- /___/   /\     Timestamp  : Thu Oct 11 14:49:32 Paris, Madrid (heure d’été) 2012
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY ila_ttc_fmc IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    DATA: in std_logic_vector(149 downto 0);
    TRIG0: in std_logic_vector(0 to 0));
END ila_ttc_fmc;

ARCHITECTURE ila_ttc_fmc_a OF ila_ttc_fmc IS
BEGIN

END ila_ttc_fmc_a;
