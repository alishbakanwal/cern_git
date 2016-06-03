-------------------------------------------------------------------------------
-- Copyright (c) 2013 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 13.3
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : ila_ttc_fmc.vhd
-- /___/   /\     Timestamp  : Mon Aug 26 17:45:17 Paris, Madrid (heure d'été) 2013
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
    DATA: in std_logic_vector(277 downto 0);
    TRIG0: in std_logic_vector(0 to 0));
END ila_ttc_fmc;

ARCHITECTURE ila_ttc_fmc_a OF ila_ttc_fmc IS
BEGIN

END ila_ttc_fmc_a;
