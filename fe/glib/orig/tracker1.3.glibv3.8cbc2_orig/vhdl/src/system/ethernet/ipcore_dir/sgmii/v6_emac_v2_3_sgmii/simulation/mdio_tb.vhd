--------------------------------------------------------------------------------
-- Title      : MDIO testbench
-- Project    : Xilinx LogiCORE Virtex-6 Embedded Tri-Mode Ethernet MAC
-- File       : mdio_tb.vhd
-- Version    : 2.3
-------------------------------------------------------------------------------
--
-- (c) Copyright 2004-2008 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
--
-- Description: in this mode the testbench is the mdio master and therefore has
-- to initiate transactions the only transactions which are required are to write
-- to the internal PHY and clear the isolate bit
--
-- Standard MDIO write transaction:
--  __ _   _   _ __________ _   ________________
-- z  ~ |_| |_| |__________| |_|________________|-------
--  PRE  ST  OP PHYAD REGAD TA    WRITE DATA
--  x32         [5:0] [5:0]         [15:0]
--
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mdio_tb is
port (
   resetn            : in  std_logic;
   mdio              : inout std_logic;
   mdc_in            : out std_logic;
   mdio_done         : out std_logic
);

end mdio_tb;


architecture behavioral of mdio_tb is

  type state_typ is    (IDLE,
                        SEND);

  constant PHYAD     : std_logic_vector(4 downto 0) := "00000";
  constant REGAD     : std_logic_vector(4 downto 0) := "00000";

  signal mdc_count   : unsigned(6 downto 0);
  signal mdio_state  : state_typ;
  signal mdio_shift  : std_logic_vector(63 downto 0);
  signal mdc         : std_logic;

begin

    -- Drive mdc at 2.5 MHz
    p_mdc : process
    begin
        mdc <= '0';
        wait for 100 ns;
        loop
            wait for 400 ns;
            mdc <= '1';
            wait for 400 ns;
            mdc <= '0';
        end loop;
    end process p_mdc;

    mdc_in <= mdc;

    mdio <= mdio_shift(63) when mdio_state = SEND else 'Z';


   mdio_count_p : process (mdc, resetn)
   begin
      if resetn = '0' then
         mdio_done    <= '0';
         mdc_count    <= (others => '0');
      elsif mdc'event and mdc = '1' then
         if mdc_count < "1001011" then
            mdc_count <= mdc_count + "000001";
         else
            mdio_done <= '1';
         end if;
      end if;
   end process mdio_count_p;

   mdio_shift_p : process (mdc, resetn)
   begin
      if resetn = '0' then
         mdio_state   <= IDLE;
         mdio_shift   <= X"FFFFFFFF" & "0101" & PHYAD & REGAD & "10" & X"0000";
      elsif mdc'event and mdc = '1' then
         case mdio_state is
            when IDLE =>
               if mdc_count = "0000101" then
                  mdio_state  <= SEND;
               end if;
            when SEND =>
               mdio_shift     <= mdio_shift(62 downto 0) & 'Z';
               if mdc_count = "1000101" then
                  mdio_state  <= IDLE;
               end if;
         end case;
      end if;
   end process mdio_shift_p;

end behavioral;
