-------------------------------------------------------------------------------------------------------
--  Copyright (c) 2009 Xilinx, Inc.
--
--   ____  ____
--  /   /\/   /
-- /___/  \  /   This   document  contains  proprietary information  which   is
-- \   \   \/    protected by  copyright. All rights  are reserved. No  part of
--  \   \        this  document may be photocopied, reproduced or translated to
--  /   /        another  program  language  without  prior written  consent of
-- /___/   /\    XILINX Inc., San Jose, CA. 95125                              
-- \   \  /  \ 
--  \___\/\___\
-- 
--  Xilinx Template Revision:
--   $RCSfile: example_prime_top_vhd.ejava,v $
--   $Revision: 1.3 $
--  Modify $Date: 2011/12/08 14:40:47 $
--   Application : Virtex-6 IBERT
--   Version : 1.4
--
--  Description:
--   This file is an example top wrapper for the ibert design with the required
--   clock buffers. User logic can be instatiated in this wrapper along with 
--   the ibert design.
--

--***************************** Entity declaration ****************************
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
LIBRARY UNISIM;
USE UNISIM.vcomponents.all;
LIBRARY chipscope_ibert_virtex6_gtx_v2_05_a;

ENTITY example_ibert IS
  PORT (
    -- Input Declarations

    IBERT_SYSCLOCK_P_IPAD : IN STD_LOGIC;
    IBERT_SYSCLOCK_N_IPAD : IN STD_LOGIC;
    X0Y0_RX_P_IPAD : IN STD_LOGIC;
    X0Y0_RX_N_IPAD : IN STD_LOGIC;
    Q0_CLK1_MGTREFCLK_P_IPAD : IN STD_LOGIC;
    Q0_CLK1_MGTREFCLK_N_IPAD : IN STD_LOGIC;
    --Output Declarations
    X0Y0_TX_P_OPAD : OUT STD_LOGIC;
    X0Y0_TX_N_OPAD : OUT STD_LOGIC;
  --User Ports
    X0Y0_RXRECCLK_P_OPAD : OUT STD_LOGIC;
    X0Y0_RXRECCLK_N_OPAD : OUT STD_LOGIC
  );
END example_ibert;

ARCHITECTURE top_virtex6 OF example_ibert IS


  COMPONENT ibert IS
    PORT (
      X0Y0_TX_P_OPAD : OUT STD_LOGIC;
      X0Y0_TX_N_OPAD : OUT STD_LOGIC;
      X0Y0_RXRECCLK_O : OUT STD_LOGIC;
      X0Y0_RX_P_IPAD : IN STD_LOGIC;
      X0Y0_RX_N_IPAD : IN STD_LOGIC;
      Q0_CLK1_MGTREFCLK_I : IN STD_LOGIC;
      CONTROL : INOUT STD_LOGIC_VECTOR(35 downto 0);
      IBERT_SYSCLOCK_I : IN STD_LOGIC
    );
  END COMPONENT ibert;
  COMPONENT chipscope_icon_1
    port (
      CONTROL0 : INOUT STD_LOGIC_VECTOR(35 downto 0));
  END COMPONENT;


  -- Local Signal Declarations
  SIGNAL q0_clk1_mgtrefclk : STD_LOGIC;
  SIGNAL ibert_sysclock : STD_LOGIC;
  SIGNAL x0y0_rxrecclk : STD_LOGIC;
  SIGNAL x0y0_rxrecclk_oddr_out : STD_LOGIC;
  SIGNAL CONTROL0 : STD_LOGIC_VECTOR(35 downto 0);

BEGIN


  -- Ibert Core Wrapper Instance
  U_IBERT: ibert
    PORT MAP (
      X0Y0_TX_P_OPAD => X0Y0_TX_P_OPAD,
      X0Y0_TX_N_OPAD => X0Y0_TX_N_OPAD,
      X0Y0_RXRECCLK_O => x0y0_rxrecclk,
      X0Y0_RX_P_IPAD => X0Y0_RX_P_IPAD,
      X0Y0_RX_N_IPAD => X0Y0_RX_N_IPAD,
      Q0_CLK1_MGTREFCLK_I => q0_clk1_mgtrefclk,
      CONTROL => CONTROL0,
      IBERT_SYSCLOCK_I => ibert_sysclock
    );
  U_ICON : chipscope_icon_1
    PORT MAP (
       CONTROL0 => CONTROL0);
  -- GT Refclock Instances
 ------ Refclk Q0-Refclk1 sources GT(s) X0Y0
  U_Q0_CLK1_MGTREFCLK : IBUFDS_GTXE1
   PORT MAP (
     O => q0_clk1_mgtrefclk,
     ODIV2 => OPEN,
     CEB => '0',
     I => Q0_CLK1_MGTREFCLK_P_IPAD,
     IB => Q0_CLK1_MGTREFCLK_N_IPAD
   );

  -- Sysclock source
  ibert_sysclock <= IBERT_SYSCLOCK_P_IPAD;


END top_virtex6;

