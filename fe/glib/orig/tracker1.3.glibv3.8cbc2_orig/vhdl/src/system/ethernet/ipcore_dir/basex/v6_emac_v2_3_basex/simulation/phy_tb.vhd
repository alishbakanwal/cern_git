------------------------------------------------------------------------
-- Title      : Serial Testbench
-- Project    : Xilinx LogiCORE Virtex-6 Embedded Tri-Mode Ethernet MAC
-- File       : phy_tb.vhd
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
------------------------------------------------------------------------
-- Description: This testbench will exercise the PHY ports of the EMAC
--              to demonstrate the functionality.
------------------------------------------------------------------------
--
-- This testbench performs the following operations on the EMAC
-- and its design example:
--  - Four frames are pushed into the receiver from the PHY
--    interface (Gigabit Trasnceiver):
--    The first is of minimum length (Length/Type = Length = 46 bytes).
--    The second frame sets Length/Type to Type = 0x8000.
--    The third frame has an error inserted.
--    The fourth frame only sends 4 bytes of data: the remainder of the
--    data field is padded up to the minimum frame length i.e. 46 bytes.
--  - These frames are then parsed from the MAC into the MAC's design
--    example.  The design example provides a MAC client loopback
--    function so that frames which are received without error will be
--    looped back to the MAC transmitter and transmitted back to the
--    testbench.  The testbench verifies that this data matches that
--    previously injected into the receiver.
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity phy_tb is
    port(
      clk125m                 : in std_logic;

      ------------------------------------------------------------------
      -- Gigabit transceiver interface
      ------------------------------------------------------------------
      txp                     : in  std_logic;
      txn                     : in  std_logic;
      rxp                     : out std_logic;
      rxn                     : out std_logic;

      ------------------------------------------------------------------
      -- Testbench Semaphores
      ------------------------------------------------------------------
      configuration_busy      : in  boolean;
      monitor_finished_1g     : out boolean;
      monitor_finished_100m   : out boolean;
      monitor_finished_10m    : out boolean
      );
end phy_tb;


architecture behavioral of phy_tb is

  ----------------------------------------------------------------------
  -- Types to support frame data
  ----------------------------------------------------------------------
  -- Tx Data and Data_valid record
  type data_typ is record
      data : bit_vector(7 downto 0);  -- data
      valid : bit;                    -- data_valid
      error : bit;                    -- data_error
  end record;
  type frame_of_data_typ is array (natural range <>) of data_typ;

  -- Tx Data, Data_valid and underrun record
  type frame_typ is record
      columns   : frame_of_data_typ(0 to 65);-- data field
      bad_frame : boolean;  -- does this frame contain an error?
  end record;
  type frame_typ_ary is array (natural range <>) of frame_typ;

  ----------------------------------------------------------------------
  -- Stimulus - Frame data
  ----------------------------------------------------------------------
  -- The following constant holds the stimulus for the testbench. It is
  -- an ordered array of frames, with frame 0 the first to be injected
  -- into the core receiver PHY interface by the testbench.
  ----------------------------------------------------------------------
  constant frame_data : frame_typ_ary := (
   -------------
   -- Frame 0
   -------------
    0          => (
      columns  => (
        0      => ( DATA => X"DA", VALID => '1', ERROR => '0'), -- Destination Address (DA)
        1      => ( DATA => X"02", VALID => '1', ERROR => '0'),
        2      => ( DATA => X"03", VALID => '1', ERROR => '0'),
        3      => ( DATA => X"04", VALID => '1', ERROR => '0'),
        4      => ( DATA => X"05", VALID => '1', ERROR => '0'),
        5      => ( DATA => X"06", VALID => '1', ERROR => '0'),
        6      => ( DATA => X"5A", VALID => '1', ERROR => '0'), -- Source Address (5A)
        7      => ( DATA => X"02", VALID => '1', ERROR => '0'),
        8      => ( DATA => X"03", VALID => '1', ERROR => '0'),
        9      => ( DATA => X"04", VALID => '1', ERROR => '0'),
       10      => ( DATA => X"05", VALID => '1', ERROR => '0'),
       11      => ( DATA => X"06", VALID => '1', ERROR => '0'),
       12      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       13      => ( DATA => X"2E", VALID => '1', ERROR => '0'), -- Length/Type = Length = 46
       14      => ( DATA => X"01", VALID => '1', ERROR => '0'),
       15      => ( DATA => X"02", VALID => '1', ERROR => '0'),
       16      => ( DATA => X"03", VALID => '1', ERROR => '0'),
       17      => ( DATA => X"04", VALID => '1', ERROR => '0'),
       18      => ( DATA => X"05", VALID => '1', ERROR => '0'),
       19      => ( DATA => X"06", VALID => '1', ERROR => '0'),
       20      => ( DATA => X"07", VALID => '1', ERROR => '0'),
       21      => ( DATA => X"08", VALID => '1', ERROR => '0'),
       22      => ( DATA => X"09", VALID => '1', ERROR => '0'),
       23      => ( DATA => X"0A", VALID => '1', ERROR => '0'),
       24      => ( DATA => X"0B", VALID => '1', ERROR => '0'),
       25      => ( DATA => X"0C", VALID => '1', ERROR => '0'),
       26      => ( DATA => X"0D", VALID => '1', ERROR => '0'),
       27      => ( DATA => X"0E", VALID => '1', ERROR => '0'),
       28      => ( DATA => X"0F", VALID => '1', ERROR => '0'),
       29      => ( DATA => X"10", VALID => '1', ERROR => '0'),
       30      => ( DATA => X"11", VALID => '1', ERROR => '0'),
       31      => ( DATA => X"12", VALID => '1', ERROR => '0'),
       32      => ( DATA => X"13", VALID => '1', ERROR => '0'),
       33      => ( DATA => X"14", VALID => '1', ERROR => '0'),
       34      => ( DATA => X"15", VALID => '1', ERROR => '0'),
       35      => ( DATA => X"16", VALID => '1', ERROR => '0'),
       36      => ( DATA => X"17", VALID => '1', ERROR => '0'),
       37      => ( DATA => X"18", VALID => '1', ERROR => '0'),
       38      => ( DATA => X"19", VALID => '1', ERROR => '0'),
       39      => ( DATA => X"1A", VALID => '1', ERROR => '0'),
       40      => ( DATA => X"1B", VALID => '1', ERROR => '0'),
       41      => ( DATA => X"1C", VALID => '1', ERROR => '0'),
       42      => ( DATA => X"1D", VALID => '1', ERROR => '0'),
       43      => ( DATA => X"1E", VALID => '1', ERROR => '0'),
       44      => ( DATA => X"1F", VALID => '1', ERROR => '0'),
       45      => ( DATA => X"20", VALID => '1', ERROR => '0'),
       46      => ( DATA => X"21", VALID => '1', ERROR => '0'),
       47      => ( DATA => X"22", VALID => '1', ERROR => '0'),
       48      => ( DATA => X"23", VALID => '1', ERROR => '0'),
       49      => ( DATA => X"24", VALID => '1', ERROR => '0'),
       50      => ( DATA => X"25", VALID => '1', ERROR => '0'),
       51      => ( DATA => X"26", VALID => '1', ERROR => '0'),
       52      => ( DATA => X"27", VALID => '1', ERROR => '0'),
       53      => ( DATA => X"28", VALID => '1', ERROR => '0'),
       54      => ( DATA => X"29", VALID => '1', ERROR => '0'),
       55      => ( DATA => X"2A", VALID => '1', ERROR => '0'),
       56      => ( DATA => X"2B", VALID => '1', ERROR => '0'),
       57      => ( DATA => X"2C", VALID => '1', ERROR => '0'),
       58      => ( DATA => X"2D", VALID => '1', ERROR => '0'),
       59      => ( DATA => X"2E", VALID => '1', ERROR => '0'), -- 46th Byte of Data
       others  => ( DATA => X"00", VALID => '0', ERROR => '0')),

      -- No error in this frame
      bad_frame => false),


   -------------
   -- Frame 1
   -------------
    1          => (
      columns  => (
        0      => ( DATA => X"DA", VALID => '1', ERROR => '0'), -- Destination Address (DA)
        1      => ( DATA => X"02", VALID => '1', ERROR => '0'),
        2      => ( DATA => X"03", VALID => '1', ERROR => '0'),
        3      => ( DATA => X"04", VALID => '1', ERROR => '0'),
        4      => ( DATA => X"05", VALID => '1', ERROR => '0'),
        5      => ( DATA => X"06", VALID => '1', ERROR => '0'),
        6      => ( DATA => X"5A", VALID => '1', ERROR => '0'), -- Source Address (5A)
        7      => ( DATA => X"02", VALID => '1', ERROR => '0'),
        8      => ( DATA => X"03", VALID => '1', ERROR => '0'),
        9      => ( DATA => X"04", VALID => '1', ERROR => '0'),
       10      => ( DATA => X"05", VALID => '1', ERROR => '0'),
       11      => ( DATA => X"06", VALID => '1', ERROR => '0'),
       12      => ( DATA => X"80", VALID => '1', ERROR => '0'), -- Length/Type = Type = 8000
       13      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       14      => ( DATA => X"01", VALID => '1', ERROR => '0'),
       15      => ( DATA => X"02", VALID => '1', ERROR => '0'),
       16      => ( DATA => X"03", VALID => '1', ERROR => '0'),
       17      => ( DATA => X"04", VALID => '1', ERROR => '0'),
       18      => ( DATA => X"05", VALID => '1', ERROR => '0'),
       19      => ( DATA => X"06", VALID => '1', ERROR => '0'),
       20      => ( DATA => X"07", VALID => '1', ERROR => '0'),
       21      => ( DATA => X"08", VALID => '1', ERROR => '0'),
       22      => ( DATA => X"09", VALID => '1', ERROR => '0'),
       23      => ( DATA => X"0A", VALID => '1', ERROR => '0'),
       24      => ( DATA => X"0B", VALID => '1', ERROR => '0'),
       25      => ( DATA => X"0C", VALID => '1', ERROR => '0'),
       26      => ( DATA => X"0D", VALID => '1', ERROR => '0'),
       27      => ( DATA => X"0E", VALID => '1', ERROR => '0'),
       28      => ( DATA => X"0F", VALID => '1', ERROR => '0'),
       29      => ( DATA => X"10", VALID => '1', ERROR => '0'),
       30      => ( DATA => X"11", VALID => '1', ERROR => '0'),
       31      => ( DATA => X"12", VALID => '1', ERROR => '0'),
       32      => ( DATA => X"13", VALID => '1', ERROR => '0'),
       33      => ( DATA => X"14", VALID => '1', ERROR => '0'),
       34      => ( DATA => X"15", VALID => '1', ERROR => '0'),
       35      => ( DATA => X"16", VALID => '1', ERROR => '0'),
       36      => ( DATA => X"17", VALID => '1', ERROR => '0'),
       37      => ( DATA => X"18", VALID => '1', ERROR => '0'),
       38      => ( DATA => X"19", VALID => '1', ERROR => '0'),
       39      => ( DATA => X"1A", VALID => '1', ERROR => '0'),
       40      => ( DATA => X"1B", VALID => '1', ERROR => '0'),
       41      => ( DATA => X"1C", VALID => '1', ERROR => '0'),
       42      => ( DATA => X"1D", VALID => '1', ERROR => '0'),
       43      => ( DATA => X"1E", VALID => '1', ERROR => '0'),
       44      => ( DATA => X"1F", VALID => '1', ERROR => '0'),
       45      => ( DATA => X"20", VALID => '1', ERROR => '0'),
       46      => ( DATA => X"21", VALID => '1', ERROR => '0'),
       47      => ( DATA => X"22", VALID => '1', ERROR => '0'),
       48      => ( DATA => X"23", VALID => '1', ERROR => '0'),
       49      => ( DATA => X"24", VALID => '1', ERROR => '0'),
       50      => ( DATA => X"25", VALID => '1', ERROR => '0'),
       51      => ( DATA => X"26", VALID => '1', ERROR => '0'),
       52      => ( DATA => X"27", VALID => '1', ERROR => '0'),
       53      => ( DATA => X"28", VALID => '1', ERROR => '0'),
       54      => ( DATA => X"29", VALID => '1', ERROR => '0'),
       55      => ( DATA => X"2A", VALID => '1', ERROR => '0'),
       56      => ( DATA => X"2B", VALID => '1', ERROR => '0'),
       57      => ( DATA => X"2C", VALID => '1', ERROR => '0'),
       58      => ( DATA => X"2D", VALID => '1', ERROR => '0'),
       59      => ( DATA => X"2E", VALID => '1', ERROR => '0'),
       60      => ( DATA => X"2F", VALID => '1', ERROR => '0'), -- 47th Data byte
       others  => ( DATA => X"00", VALID => '0', ERROR => '0')),

      -- No error in this frame
      bad_frame => false),


   -------------
   -- Frame 2
   -------------
    2          => (
      columns  => (
        0      => ( DATA => X"DA", VALID => '1', ERROR => '0'), -- Destination Address (DA)
        1      => ( DATA => X"02", VALID => '1', ERROR => '0'),
        2      => ( DATA => X"03", VALID => '1', ERROR => '0'),
        3      => ( DATA => X"04", VALID => '1', ERROR => '0'),
        4      => ( DATA => X"05", VALID => '1', ERROR => '0'),
        5      => ( DATA => X"06", VALID => '1', ERROR => '0'),
        6      => ( DATA => X"5A", VALID => '1', ERROR => '0'), -- Source Address (5A)
        7      => ( DATA => X"02", VALID => '1', ERROR => '0'),
        8      => ( DATA => X"03", VALID => '1', ERROR => '0'),
        9      => ( DATA => X"04", VALID => '1', ERROR => '0'),
       10      => ( DATA => X"05", VALID => '1', ERROR => '0'),
       11      => ( DATA => X"06", VALID => '1', ERROR => '0'),
       12      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       13      => ( DATA => X"2E", VALID => '1', ERROR => '0'), -- Length/Type = Length = 46
       14      => ( DATA => X"01", VALID => '1', ERROR => '0'),
       15      => ( DATA => X"02", VALID => '1', ERROR => '0'),
       16      => ( DATA => X"03", VALID => '1', ERROR => '0'),
       17      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       18      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       19      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       20      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       21      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       22      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       23      => ( DATA => X"00", VALID => '1', ERROR => '1'), -- assert error here
       24      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       25      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       26      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       27      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       28      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       29      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       30      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       31      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       32      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       33      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       34      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       35      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       36      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       37      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       38      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       39      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       40      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       41      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       42      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       43      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       44      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       45      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       46      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       47      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       48      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       49      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       50      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       51      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       52      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       53      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       54      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       55      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       56      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       57      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       58      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       59      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       others  => ( DATA => X"00", VALID => '0', ERROR => '0')),

       -- Error this frame
      bad_frame => true),


   -------------
   -- Frame 3
   -------------
   3          => (
      columns  => (
        0      => ( DATA => X"DA", VALID => '1', ERROR => '0'), -- Destination Address (DA)
        1      => ( DATA => X"02", VALID => '1', ERROR => '0'),
        2      => ( DATA => X"03", VALID => '1', ERROR => '0'),
        3      => ( DATA => X"04", VALID => '1', ERROR => '0'),
        4      => ( DATA => X"05", VALID => '1', ERROR => '0'),
        5      => ( DATA => X"06", VALID => '1', ERROR => '0'),
        6      => ( DATA => X"5A", VALID => '1', ERROR => '0'), -- Source Address (5A)
        7      => ( DATA => X"02", VALID => '1', ERROR => '0'),
        8      => ( DATA => X"03", VALID => '1', ERROR => '0'),
        9      => ( DATA => X"04", VALID => '1', ERROR => '0'),
       10      => ( DATA => X"05", VALID => '1', ERROR => '0'),
       11      => ( DATA => X"06", VALID => '1', ERROR => '0'),
       12      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       13      => ( DATA => X"03", VALID => '1', ERROR => '0'), -- Length/Type = Length = 03
       14      => ( DATA => X"01", VALID => '1', ERROR => '0'), -- Therefore padding is required
       15      => ( DATA => X"02", VALID => '1', ERROR => '0'),
       16      => ( DATA => X"03", VALID => '1', ERROR => '0'),
       17      => ( DATA => X"00", VALID => '1', ERROR => '0'), -- Padding starts here
       18      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       19      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       20      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       21      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       22      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       23      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       24      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       25      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       26      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       27      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       28      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       29      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       30      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       31      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       32      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       33      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       34      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       35      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       36      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       37      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       38      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       39      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       40      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       41      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       42      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       43      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       44      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       45      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       46      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       47      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       48      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       49      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       50      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       51      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       52      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       53      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       54      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       55      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       56      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       57      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       58      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       59      => ( DATA => X"00", VALID => '1', ERROR => '0'),
       others  => ( DATA => X"00", VALID => '0', ERROR => '0')),

      -- No error in this frame
      bad_frame => false));


  ----------------------------------------------------------------------
  -- CRC engine
  ----------------------------------------------------------------------
  function calc_crc (data : in std_logic_vector;
                     fcs  : in std_logic_vector)
  return std_logic_vector is

     variable crc          : std_logic_vector(31 downto 0);
     variable crc_feedback : std_logic;
  begin

    crc := not fcs;

    for I in 0 to 7 loop
      crc_feedback      := crc(0) xor data(I);

      crc(4 downto 0)   := crc(5 downto 1);
      crc(5)            := crc(6)  xor crc_feedback;
      crc(7 downto 6)   := crc(8 downto 7);
      crc(8)            := crc(9)  xor crc_feedback;
      crc(9)            := crc(10) xor crc_feedback;
      crc(14 downto 10) := crc(15 downto 11);
      crc(15)           := crc(16) xor crc_feedback;
      crc(18 downto 16) := crc(19 downto 17);
      crc(19)           := crc(20) xor crc_feedback;
      crc(20)           := crc(21) xor crc_feedback;
      crc(21)           := crc(22) xor crc_feedback;
      crc(22)           := crc(23);
      crc(23)           := crc(24) xor crc_feedback;
      crc(24)           := crc(25) xor crc_feedback;
      crc(25)           := crc(26);
      crc(26)           := crc(27) xor crc_feedback;
      crc(27)           := crc(28) xor crc_feedback;
      crc(28)           := crc(29);
      crc(29)           := crc(30) xor crc_feedback;
      crc(30)           := crc(31) xor crc_feedback;
      crc(31)           :=             crc_feedback;
    end loop;

    -- return the CRC result
    return not crc;

  end calc_crc;


  ----------------------------------------------------------------------
  -- Procedure to perform 8B10B decoding
  ----------------------------------------------------------------------

  -- Decode the 8B10B code. No disparity verification is performed, just
  -- a simple table lookup.
  procedure decode_8b10b (
    constant d10  : in  std_logic_vector(0 to 9);
    variable q8   : out std_logic_vector(7 downto 0);
    variable is_k : out boolean) is
    variable k28 : boolean;
    variable d10_rev : std_logic_vector(9 downto 0);
  begin
    -- reverse the 10B codeword
    for i in 0 to 9 loop
      d10_rev(i) := d10(i);
    end loop;  -- i
    -- do the 6B5B decode
    case d10_rev(5 downto 0) is
      when "000110" =>
        q8(4 downto 0) := "00000";   --D.0
      when "111001" =>
        q8(4 downto 0) := "00000";   --D.0
      when "010001" =>
        q8(4 downto 0) := "00001";   --D.1
      when "101110" =>
        q8(4 downto 0) := "00001";   --D.1
      when "010010" =>
        q8(4 downto 0) := "00010";   --D.2
      when "101101" =>
        q8(4 downto 0) := "00010";   --D.2
      when "100011" =>
        q8(4 downto 0) := "00011";   --D.3
      when "010100" =>
        q8(4 downto 0) := "00100";   --D.4
      when "101011" =>
        q8(4 downto 0) := "00100";   --D.4
      when "100101" =>
        q8(4 downto 0) := "00101";   --D.5
      when "100110" =>
        q8(4 downto 0) := "00110";   --D.6
      when "000111" =>
        q8(4 downto 0) := "00111";   --D.7
      when "111000" =>
        q8(4 downto 0) := "00111";   --D.7
      when "011000" =>
        q8(4 downto 0) := "01000";   --D.8
      when "100111" =>
        q8(4 downto 0) := "01000";   --D.8
      when "101001" =>
        q8(4 downto 0) := "01001";   --D.9
      when "101010" =>
        q8(4 downto 0) := "01010";   --D.10
      when "001011" =>
        q8(4 downto 0) := "01011";   --D.11
      when "101100" =>
        q8(4 downto 0) := "01100";   --D.12
      when "001101" =>
        q8(4 downto 0) := "01101";   --D.13
      when "001110" =>
        q8(4 downto 0) := "01110";   --D.14
      when "000101" =>
        q8(4 downto 0) := "01111";   --D.15
      when "111010" =>
        q8(4 downto 0) := "01111";   --D.15
      when "110110" =>
        q8(4 downto 0) := "10000";   --D.16
      when "001001" =>
        q8(4 downto 0) := "10000";   --D.16
      when "110001" =>
        q8(4 downto 0) := "10001";   --D.17
      when "110010" =>
        q8(4 downto 0) := "10010";   --D.18
      when "010011" =>
        q8(4 downto 0) := "10011";   --D.19
      when "110100" =>
        q8(4 downto 0) := "10100";   --D.20
      when "010101" =>
        q8(4 downto 0) := "10101";   --D.21
      when "010110" =>
        q8(4 downto 0) := "10110";   --D.22
      when "010111" =>
        q8(4 downto 0) := "10111";   --D/K.23
      when "101000" =>
        q8(4 downto 0) := "10111";   --D/K.23
      when "001100" =>
        q8(4 downto 0) := "11000";   --D.24
      when "110011" =>
        q8(4 downto 0) := "11000";   --D.24
      when "011001" =>
        q8(4 downto 0) := "11001";   --D.25
      when "011010" =>
        q8(4 downto 0) := "11010";   --D.26
      when "011011" =>
        q8(4 downto 0) := "11011";   --D/K.27
      when "100100" =>
        q8(4 downto 0) := "11011";   --D/K.27
      when "011100" =>
        q8(4 downto 0) := "11100";   --D.28
      when "111100" =>
        q8(4 downto 0) := "11100";   --K.28
      when "000011" =>
        q8(4 downto 0) := "11100";   --K.28
      when "011101" =>
        q8(4 downto 0) := "11101";   --D/K.29
      when "100010" =>
        q8(4 downto 0) := "11101";   --D/K.29
      when "011110" =>
        q8(4 downto 0) := "11110";   --D.30
      when "100001" =>
        q8(4 downto 0) := "11110";   --D.30
      when "110101" =>
        q8(4 downto 0) := "11111";   --D.31
      when "001010" =>
        q8(4 downto 0) := "11111";   --D.31

      when others   =>
        q8(4 downto 0) := "11110";  --CODE VIOLATION - return /E/
    end case;

    k28 := not((d10(2) OR d10(3) OR d10(4) OR d10(5)
                OR NOT(d10(8) XOR d10(9)))) = '1';

    -- do the 4B3B decode
    case d10_rev(9 downto 6) is
      when "0010" =>
        q8(7 downto 5) := "000";       --D/K.x.0
      when "1101" =>
        q8(7 downto 5) := "000";       --D/K.x.0
      when "1001" =>
        if not k28 then
          q8(7 downto 5) := "001";     --D/K.x.1
        else
          q8(7 downto 5) := "110";     --K28.6
        end if;
      when "0110" =>
        if k28 then
          q8(7 downto 5) := "001";     --K.28.1
        else
          q8(7 downto 5) := "110";     --D/K.x.6
        end if;
      when "1010" =>
        if not k28 then
          q8(7 downto 5) := "010";     --D/K.x.2
        else
          q8(7 downto 5) := "101";     --K28.5
        end if;
      when "0101" =>
        if k28 then
          q8(7 downto 5) := "010";     --K28.2
        else
          q8(7 downto 5) := "101";     --D/K.x.5
        end if;
      when "0011" =>
        q8(7 downto 5) := "011";       --D/K.x.3
      when "1100" =>
        q8(7 downto 5) := "011";       --D/K.x.3
      when "0100" =>
        q8(7 downto 5) := "100";       --D/K.x.4
      when "1011" =>
        q8(7 downto 5) := "100";       --D/K.x.4
      when "0111" =>
        q8(7 downto 5) := "111";       --D.x.7
      when "1000" =>
        q8(7 downto 5) := "111";       --D.x.7
      when "1110" =>
        q8(7 downto 5) := "111";       --D/K.x.7
      when "0001" =>
        q8(7 downto 5) := "111";       --D/K.x.7

      when others =>
        q8(7 downto 5) := "111";   --CODE VIOLATION - return /E/
    end case;

    is_k := ((d10(2) and d10(3) and d10(4) and d10(5))
            or not (d10(2) or d10(3) or d10(4) or d10(5))
            or ((d10(4) xor d10(5))
              and ((d10(5) and d10(7) and d10(8) and d10(9))
                or not(d10(5) or d10(7) or d10(8) or d10(9))))) = '1' ;
  end decode_8b10b;


  ----------------------------------------------------------------------
  -- Procedure to perform comma detection
  ----------------------------------------------------------------------

  function is_comma (
    constant codegroup : in std_logic_vector(0 to 9))
    return boolean is
  begin  -- is_comma
    case codegroup(0 to 6) is
      when "0011111" =>
        return true;
      when "1100000" =>
        return true;
      when others =>
        return false;
    end case;
  end is_comma;


  ----------------------------------------------------------------------
  -- Procedure to perform 8B10B encoding
  ----------------------------------------------------------------------

  procedure encode_8b10b (
    constant d8                : in  std_logic_vector(7 downto 0);
    constant is_k              : in  boolean;
    variable q10               : out std_logic_vector(0 to 9);
    constant disparity_pos_in  : in  boolean;
    variable disparity_pos_out : out boolean) is
    variable b6                       : std_logic_vector(5 downto 0);
    variable b4                       : std_logic_vector(3 downto 0);
    variable k28, pdes6, a7, l13, l31 : boolean;
    variable a, b, c, d, e            : boolean;
  begin  -- encode_8b10b
    -- precalculate some common terms
    a := d8(0) = '1';
    b := d8(1) = '1';
    c := d8(2) = '1';
    d := d8(3) = '1';
    e := d8(4) = '1';

    k28 := is_k and d8(4 downto 0) = "11100";
    l13 := (((a xor b) and not (c or d))
            or ((c xor d) and not(a or b)));

    l31 := (((a xor b) and (c and d))
             or
             ((c xor d) and (a and b)));

    a7 := is_k or ((l31 and d and not e and disparity_pos_in)
                   or (l13 and not d and e and not disparity_pos_in));

    -- Do the 5B/6B conversion (calculate the 6b symbol)
    if k28 then                         --K.28
      if not disparity_pos_in then
        b6 := "111100";
      else
        b6 := "000011";
      end if;
    else
      case d8(4 downto 0) is
        when "00000" =>                 --D.0
          if disparity_pos_in then
            b6 := "000110";
          else
            b6 := "111001";
          end if;
        when "00001" =>                 --D.1
          if disparity_pos_in then
            b6 := "010001";
          else
            b6 := "101110";
          end if;
        when "00010" =>                 --D.2
          if disparity_pos_in then
            b6 := "010010";
          else
            b6 := "101101";
          end if;
        when "00011" =>
          b6 := "100011";               --D.3
        when "00100" =>                 --D.4
          if disparity_pos_in then
            b6 := "010100";
          else
            b6 := "101011";
          end if;
        when "00101" =>
          b6 := "100101";               --D.5
        when "00110" =>
          b6 := "100110";               --D.6
        when "00111" =>                 --D.7
          if not disparity_pos_in then
            b6 := "000111";
          else
            b6 := "111000";
          end if;
        when "01000" =>                 --D.8
          if disparity_pos_in then
            b6 := "011000";
          else
            b6 := "100111";
          end if;
        when "01001" =>
          b6 := "101001";               --D.9
        when "01010" =>
          b6 := "101010";               --D.10
        when "01011" =>
          b6 := "001011";               --D.11
        when "01100" =>
          b6 := "101100";               --D.12
        when "01101" =>
          b6 := "001101";               --D.13
        when "01110" =>
          b6 := "001110";               --D.14
        when "01111" =>                 --D.15
          if disparity_pos_in then
            b6 := "000101";
          else
            b6 := "111010";
          end if;
        when "10000" =>                 --D.16
          if not disparity_pos_in then
            b6 := "110110";
          else
            b6 := "001001";
          end if;
        when "10001" =>
          b6 := "110001";               --D.17
        when "10010" =>
          b6 := "110010";               --D.18
        when "10011" =>
          b6 := "010011";               --D.19
        when "10100" =>
          b6 := "110100";               --D.20
        when "10101" =>
          b6 := "010101";               --D.21
        when "10110" =>
          b6 := "010110";               --D.22
        when "10111" =>                 --D/K.23
          if not disparity_pos_in then
            b6 := "010111";
          else
            b6 := "101000";
          end if;
        when "11000" =>                 --D.24
          if disparity_pos_in then
            b6 := "001100";
          else
            b6 := "110011";
          end if;
        when "11001" =>
          b6 := "011001";               --D.25
        when "11010" =>
          b6 := "011010";               --D.26
        when "11011" =>                 --D/K.27
          if not disparity_pos_in then
            b6 := "011011";
          else
            b6 := "100100";
          end if;
        when "11100" =>
          b6 := "011100";               --D.28
        when "11101" =>                 --D/K.29
          if not disparity_pos_in then
            b6 := "011101";
          else
            b6 := "100010";
          end if;
        when "11110" =>                 --D/K.30
          if not disparity_pos_in then
            b6 := "011110";
          else
            b6 := "100001";
          end if;
        when "11111" =>                 --D.31
          if not disparity_pos_in then
            b6 := "110101";
          else
            b6 := "001010";
          end if;
        when others =>
          b6 := "XXXXXX";
      end case;
    end if;

    -- reverse the bits
    for i in 0 to 5 loop
      q10(i) := b6(i);
    end loop;  -- i

    -- calculate the running disparity after the 5B6B block encode
    if k28 then
      pdes6 := not disparity_pos_in;
    else
      case d8(4 downto 0) is
        when "00000" => pdes6 := not disparity_pos_in;
        when "00001" => pdes6 := not disparity_pos_in;
        when "00010" => pdes6 := not disparity_pos_in;
        when "00011" => pdes6 := disparity_pos_in;
        when "00100" => pdes6 := not disparity_pos_in;
        when "00101" => pdes6 := disparity_pos_in;
        when "00110" => pdes6 := disparity_pos_in;
        when "00111" => pdes6 := disparity_pos_in;

        when "01000" => pdes6 := not disparity_pos_in;
        when "01001" => pdes6 := disparity_pos_in;
        when "01010" => pdes6 := disparity_pos_in;
        when "01011" => pdes6 := disparity_pos_in;
        when "01100" => pdes6 := disparity_pos_in;
        when "01101" => pdes6 := disparity_pos_in;
        when "01110" => pdes6 := disparity_pos_in;
        when "01111" => pdes6 := not disparity_pos_in;

        when "10000" => pdes6 := not disparity_pos_in;
        when "10001" => pdes6 := disparity_pos_in;
        when "10010" => pdes6 := disparity_pos_in;
        when "10011" => pdes6 := disparity_pos_in;
        when "10100" => pdes6 := disparity_pos_in;
        when "10101" => pdes6 := disparity_pos_in;
        when "10110" => pdes6 := disparity_pos_in;
        when "10111" => pdes6 := not disparity_pos_in;

        when "11000" => pdes6 := not disparity_pos_in;
        when "11001" => pdes6 := disparity_pos_in;
        when "11010" => pdes6 := disparity_pos_in;
        when "11011" => pdes6 := not disparity_pos_in;
        when "11100" => pdes6 := disparity_pos_in;
        when "11101" => pdes6 := not disparity_pos_in;
        when "11110" => pdes6 := not disparity_pos_in;
        when "11111" => pdes6 := not disparity_pos_in;
        when others  => pdes6 := disparity_pos_in;
      end case;
    end if;

    case d8(7 downto 5) is
      when "000" =>                     --D/K.x.0
        if pdes6 then
          b4 := "0010";
        else
          b4 := "1101";
        end if;
      when "001" =>                     --D/K.x.1
        if k28 and not pdes6 then
          b4 := "0110";
        else
          b4 := "1001";
        end if;
      when "010" =>                     --D/K.x.2
        if k28 and not pdes6 then
          b4 := "0101";
        else
          b4 := "1010";
        end if;
      when "011" =>                     --D/K.x.3
        if not pdes6 then
          b4 := "0011";
        else
          b4 := "1100";
        end if;
      when "100" =>                     --D/K.x.4
        if pdes6 then
          b4 := "0100";
        else
          b4 := "1011";
        end if;
      when "101" =>                     --D/K.x.5
        if k28 and not pdes6 then
          b4 := "1010";
        else
          b4 := "0101";
        end if;
      when "110" =>                     --D/K.x.6
        if k28 and not pdes6 then
          b4 := "1001";
        else
          b4 := "0110";
        end if;
      when "111" =>                     --D.x.P7
        if not a7 then
          if not pdes6 then
            b4 := "0111";
          else
            b4 := "1000";
          end if;
        else                            --D/K.y.A7
          if not pdes6 then
            b4 := "1110";
          else
            b4 := "0001";
          end if;
        end if;
      when others =>
        b4 := "XXXX";
    end case;

    -- Reverse the bits
    for i in 0 to 3 loop
      q10(i+6) := b4(i);
    end loop;  -- i

    -- Calculate the running disparity after the 4B group
    case d8(7 downto 5) is
      when "000"  =>
        disparity_pos_out := not pdes6;
      when "001"  =>
        disparity_pos_out := pdes6;
      when "010"  =>
        disparity_pos_out := pdes6;
      when "011"  =>
        disparity_pos_out := pdes6;
      when "100"  =>
        disparity_pos_out := not pdes6;
      when "101"  =>
        disparity_pos_out := pdes6;
      when "110"  =>
        disparity_pos_out := pdes6;
      when "111"  =>
        disparity_pos_out := not pdes6;
      when others =>
        disparity_pos_out := pdes6;
    end case;

  end encode_8b10b;


  ----------------------------------------------------------------------
  -- Testbench signals and constants
  ----------------------------------------------------------------------

  -- Unit Interval for Gigabit Ethernet
  constant UI  : time := 800 ps;

  -- Testbench clocks and sampling
  signal bitclock             : std_logic;   -- clock running at GTX serial frequency
  signal stim_rx_sample       : std_logic;   -- Sample on every clock at 1Gbps, every 10 clocks at 100Mbps, every 100 clocks at 10Mbps
  signal mon_tx_sample        : std_logic;   -- Sample on every clock at 1Gbps, every 10 clocks at 100Mbps, every 100 clocks at 10Mbps

  -- Signals for the Tx monitor following 8B10B decode
  signal tx_pdata       : std_logic_vector(7 downto 0);
  signal tx_is_k        : std_logic;

  -- Signals for the Rx stimulus prior to 8B10B encode
  signal rx_pdata       : std_logic_vector(7 downto 0) := "10111100";
  signal rx_is_k        : boolean := true;
  signal rx_even        : std_logic := '1'; -- Keep track of the even/odd position
  signal rx_rundisp_pos : boolean := false; -- Indicates +ve running disparity

  -- Testbench control signals
  signal current_speed       : string(1 to 6) := "1gig  ";


begin  -- behavioral

  ----------------------------------------------------------------------
  -- Clock drivers
  ----------------------------------------------------------------------

  -- Drives bitclock at line rate
  p_bitclock : process
  begin
      bitclock <= '0';
      wait for UI / 2;
      bitclock <= '1';
      wait for UI / 2;
  end process p_bitclock;


  ----------------------------------------------------------------------
  -- Simulus processes
  --------------------
  -- Send four frames through the MAC and Design Example
  --      -- frame 0 = minimum length frame
  --      -- frame 1 = type frame
  --      -- frame 2 = errored frame
  --      -- frame 3 = padded frame
  ----------------------------------------------------------------------
  -- sample on every clock
  stim_rx_sample <= '1';

  -- Rx stimulus process. This process will create frames of data to be
  -- pushed into the receiver side of the Gigabit Transceiver.
  p_stimulus : process
    variable current_col : natural := 0;  -- Column counter within frame
    variable fcs         : std_logic_vector(31 downto 0);

    -- A procedure to create an Idle /I1/ code group
    procedure send_I1 is
    begin
      rx_pdata  <= X"BC";  -- /K28.5/
      rx_is_k   <= true;
      wait until clk125m'event and clk125m = '1';
      rx_pdata  <= X"C5";  -- /D5.6/
      rx_is_k   <= false;
      wait until clk125m'event and clk125m = '1';
    end send_I1;

    -- A procedure to create an Idle /I2/ code group
    procedure send_I2 is
    begin
      rx_pdata  <= X"BC";  -- /K28.5/
      rx_is_k   <= true;
      wait until clk125m'event and clk125m = '1';
      rx_pdata  <= X"50";  -- /D16.2/
      rx_is_k   <= false;
      wait until clk125m'event and clk125m = '1';
    end send_I2;

    -- A procedure to create a Start of Packet /S/ code group
    procedure send_S is
    begin
      rx_pdata  <= X"FB";  -- /K27.7/
      rx_is_k   <= true;
      wait until clk125m'event and clk125m = '1';
    end send_S;

    -- A procedure to create a Terminate /T/ code group
    procedure send_T is
    begin
      rx_pdata  <= X"FD";  -- /K29.7/
      rx_is_k   <= true;
      wait until clk125m'event and clk125m = '1';
    end send_T;

    -- A procedure to create a Carrier Extend /R/ code group
    procedure send_R is
    begin
      rx_pdata  <= X"F7";  -- /K23.7/
      rx_is_k   <= true;
      wait until clk125m'event and clk125m = '1';
    end send_R;

    -- A procedure to create an Error Propogation /V/ code group
    procedure send_V is
    begin
      rx_pdata  <= X"FE";  -- /K30.7/
      rx_is_k   <= true;
    end send_V;

  begin
    -- Wait for the testbench to initialise
    wait until configuration_busy;

    -- Initialisation sequence: always start I2 in even position
    wait until rx_even = '1';

    current_speed <= "1gig  ";

    -- Wait for the configuration to initialise the MAC
    while (configuration_busy) loop
      send_I2;
    end loop;
      ------------------------------------
      -- Send the four frames
      ------------------------------------

      for current_frame in frame_data'low to frame_data'high loop

        assert false
          report "EMAC: Sending Frame " & integer'image(current_frame) & cr
          severity note;

        -- Send a Start of Packet code group
        ------------------------------------
        send_S;

        -- Adding the preamble field
        ------------------------------------
        if current_speed = "1gig  " then
          -- 1Gbps (the 1st preamble has been replaced with the /S/ character)
          for j in 0 to 5 loop
            rx_pdata  <= "01010101";
            rx_is_k   <= false;
            wait until clk125m'event and clk125m = '1' and stim_rx_sample = '1';
          end loop;
        else
          -- 10/100Mbps (the 1st preamble should still be sent)
          for j in 0 to 6 loop
            rx_pdata  <= "01010101";
            rx_is_k   <= false;
            wait until clk125m'event and clk125m = '1' and stim_rx_sample = '1';
          end loop;
        end if;

        -- Adding the Start of Frame Delimiter (SFD)
        rx_pdata    <= "11010101";
        rx_is_k     <= false;
        wait until clk125m'event and clk125m = '1' and stim_rx_sample = '1';

        -- Sending the MAC frame
        ------------------------------------
        fcs         := (others => '0'); -- reset the FCS field
        current_col := 0;
        -- loop over columns in frame.
        while frame_data(current_frame).columns(current_col).valid /= '0' loop
          fcs         := calc_crc(to_stdlogicvector(frame_data(current_frame).columns(current_col).data), fcs);
          if to_stdulogic(frame_data(current_frame).columns(current_col).error) = '1' then
            send_V; -- insert an error propogation code group
          else
            rx_pdata  <= to_stdlogicvector(frame_data(current_frame).columns(current_col).data);
            rx_is_k   <= false;
          end if;

          wait until clk125m'event and clk125m = '1' and stim_rx_sample = '1';
          current_col := current_col + 1;
        end loop;

        -- Send the FCS.
        ------------------------------------
        for j in 0 to 3 loop
          rx_pdata  <= fcs(((8*j)+7) downto (8*j));
          rx_is_k   <= false;

          wait until clk125m'event and clk125m = '1' and stim_rx_sample = '1';
        end loop;

        -- Send a frame termination sequence
        ------------------------------------
        send_T;    -- Terminate code group
        send_R;    -- Carrier Extend code group

        -- An extra Carrier Extend code group should be sent to end the frame
        -- on an even boundary.
        if rx_even = '1' then
          send_R;  -- Carrier Extend code group
        end if;

        -- Send an Inter Packet Gap.
        ------------------------------------
        -- The initial Idle following a frame should be chosen to ensure
        -- that the running disparity is returned to -ve.
        if rx_rundisp_pos then
          send_I1;  -- /I1/ will flip the running disparity
        else
          send_I2;  -- /I2/ will maintain the running disparity
        end if;

        -- The remainder of the IPG is made up of /I2/ 's.

        -- NOTE: the number 4 in the following calculations is made up
        --      from 2 bytes of the termination sequence and 2 bytes from
        --      the initial Idle.
        for j in 0 to 3 loop              -- 4 /I2/'s = 8 clock periods (12 - 4)
          send_I2;
        end loop;

      end loop;  -- current_frame
    -- After the completion of the simulus, send Idles continuously
    loop
      send_I2;
    end loop;

  end process p_stimulus;


  -- A process to keep track of the even/odd code group position for the
  -- injected receiver code groups.
  p_rx_even_odd: process
  begin
    wait until clk125m'event and clk125m = '1';
    rx_even <= not rx_even;
  end process p_rx_even_odd;


  -- Data from the Rx Stimulus is 8B10B encoded and serialised so that
  -- it can be injected into the GTX receiver port.
  p_rx_encode : process
    variable encoded_data : std_logic_vector(9 downto 0);
    variable rundisp      : boolean;

    -- A procedure to serialise a single 10-bit code group
    procedure send_10b_column (
      constant d : in std_logic_vector(0 to 9)) is
    begin
      for i in 0 to 9 loop
        rxp <= d(i);
        rxn <= not d(i);
        wait until bitclock'event and bitclock = '1';
      end loop;  -- i
    end send_10b_column;

  begin

    -- Get synced up with the Rx clock
    wait until clk125m'event and clk125m = '1';

    -- Perform 8B10B encoding of the data stream
    loop
       encode_8b10b(
         d8                => rx_pdata,
         is_k              => rx_is_k,
         disparity_pos_in  => rundisp,
         q10               => encoded_data,
         disparity_pos_out => rundisp);

       rx_rundisp_pos <= rundisp;
       send_10b_column(encoded_data);

    end loop;

  end process p_rx_encode;


  ----------------------------------------------------------------------
  -- Monitor processs.
  --------------------
  -- These processes checks the data coming out of the
  -- transmitter to make sure that it matches that inserted into the
  -- receiver.
  --      -- frame 0 = minimum length frame
  --      -- frame 1 = type frame
  --      -- frame 2 = errored frame
  --      -- frame 3 = padded frame
  --
  -- Repeated for all 3 speeds.
  ----------------------------------------------------------------------

  -- The Phy side serial transmitter output from the core is captured,
  -- converted to 10-bit parallel and 8B10B decoded.  Correct Parallel
  -- alignment is achieved using comma detection.
  p_tx_decode : process
    variable code_buffer  : std_logic_vector(0 to 9);
    variable decoded_data : std_logic_vector(7 downto 0);
    variable bit_count    : integer;
    variable is_k_var     : boolean;
    variable initial_sync : boolean;
  begin
    bit_count := 0;
    initial_sync := false;
    loop
      wait until bitclock'event and bitclock = '1';
      code_buffer := code_buffer(1 to 9) & txp;
      -- comma detection
      if is_comma(code_buffer) then
        bit_count := 0;
        initial_sync := true;
      end if;

      if bit_count = 0 and initial_sync then
        -- Perform 8B10B decoding of the data stream
        decode_8b10b(
          d10  => code_buffer,
          q8   => decoded_data,
          is_k => is_k_var);

        -- drive the output signals with the results
        tx_pdata <= decoded_data;

        if is_k_var then
          tx_is_k <= '1';
        else
          tx_is_k <= '0';
        end if;
      end if;

      if initial_sync then
        bit_count := bit_count + 1;
        if bit_count = 10 then
          bit_count := 0;
        end if;
      end if;
    end loop;
  end process p_tx_decode;
  -- sample on every clock
  mon_tx_sample <= '1';

  -- Monitor the frames coming out of the Gigabit Transceiver
  -- transmitter to make sure that they match those injected into the
  -- Gigabit Transceiver receiver.
  p_monitor : process
    variable f                  : frame_typ;       -- temporary frame variable
    variable current_col        : natural   := 0;  -- Column counter
    variable current_frame      : natural   := 0;
    variable fcs                : std_logic_vector(31 downto 0);
    begin  -- process p_monitor

    -- first, get synced up with the TX clock
    wait until clk125m'event and clk125m = '1';
    wait until clk125m'event and clk125m = '1';

      ------------------------------------
      -- Compare the four frames
      ------------------------------------
      -- loop over all the frames in the stimulus vector
      loop
        current_col := 0;

        -- If the current frame had an error inserted then it would have been
        -- dropped by the FIFO in the design example.  Therefore move
        -- immediately on to the next frame.
        while frame_data(current_frame).bad_frame loop
          current_frame := current_frame + 1;
       if current_frame = frame_data'high + 1 then
            exit;
          end if;
        end loop;

        -- There are only 4 frames in this test.
        if current_frame = frame_data'high + 1 then
          exit;
        end if;

        -- Detect the Start of Frame
        while tx_pdata /= X"FB" loop -- /K27.7/ character
          wait until clk125m'event and clk125m = '1';
        end loop;

        assert false
          report "EMAC: Comparing Frame " & integer'image(current_frame) & cr
         severity note;

        fcs         := (others => '0'); -- reset the FCS field

        -- Move past the Start of Frame code to the 1st byte of preamble
        wait until clk125m'event and clk125m = '1' and mon_tx_sample = '1';

        -- wait until the SFD code is detected.
        -- NOTE: It is neccessary to resynchronise on the SFD as the preamble field
        --       may have shrunk.
        while tx_pdata /= X"D5" loop
          wait until clk125m'event and clk125m = '1' and mon_tx_sample = '1';
        end loop;
        wait until clk125m'event and clk125m = '1' and mon_tx_sample = '1';

        -- frame has started, loop over columns of frame
        while ((frame_data(current_frame).columns(current_col).valid)='1') loop

          -- The transmitted Destination Address was the Source Address of the injected frame
            if current_col < 6 then
              fcs := calc_crc(to_stdlogicvector(frame_data(current_frame).columns(current_col+6).data), fcs);
              assert (tx_pdata =
                    to_stdlogicvector(frame_data(current_frame).columns(current_col+6).data(7 downto 0)))
                report "EMAC: data incorrect during Destination Address" & cr
                severity error;

          -- The transmitted Source Address was the Destination Address of the injected frame
            elsif current_col >= 6 and current_col < 12 then
              fcs := calc_crc(to_stdlogicvector(frame_data(current_frame).columns(current_col-6).data), fcs);
              assert (tx_pdata =
                    to_stdlogicvector(frame_data(current_frame).columns(current_col-6).data(7 downto 0)))
                report "EMAC: data incorrect during Source Address" & cr
                severity error;

          -- for remainder of frame
            else
              fcs := calc_crc(to_stdlogicvector(frame_data(current_frame).columns(current_col).data), fcs);
              assert (tx_pdata(7 downto 0) =
                    to_stdlogicvector(frame_data(current_frame).columns(current_col).data(7 downto 0)))
                report "EMAC: data incorrect" & cr
                severity error;
            end if;

          -- wait for next column of data
          current_col        := current_col + 1;
          wait until clk125m'event and clk125m = '1' and mon_tx_sample = '1';
        end loop;  -- while data valid

        -- Check the FCS
        -- Having checked all data columns, txd must contain FCS.
        for j in 0 to 3 loop
          assert (tx_pdata = fcs(((8*j)+7) downto (8*j)))
            report "EMAC: data incorrect during FCS field" & cr
            severity error;

          wait until clk125m'event and clk125m = '1' and mon_tx_sample = '1';
        end loop;  -- j

        -- move to the next frame
        if current_frame = frame_data'high then
          exit;
        else
          current_frame := current_frame + 1;
        end if;

      end loop;  -- four frames

        monitor_finished_1g   <= true;
    -- Our work here is done
    wait;

  end process p_monitor;


end behavioral;
