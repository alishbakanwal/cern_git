----------------------------------------------------------------------
----                                                              ----
---- GBT-FPGA SERDES Project                                              ----
----                                                              ----
---- This file is part of the GBT-FPGA Project                    ----
---- https://espace.cern.ch/GBT-Project/default.aspx              ----
---- https://svn.cern.ch/reps/gbt_fpga                                                    ----
----                                                              ----
----------------------------------------------------------------------
----                                                              ----
----                                                              ----
---- This source file may be used and distributed without         ----
---- restriction provided that this copyright statement is not    ----
---- removed from the file and that any derivative work contains  ----
---- the original copyright notice and the associated disclaimer. ----
----                                                              ----
---- This source file is free software; you can redistribute it   ----
---- and/or modify it under the terms of the GNU General          ----
---- Public License as published by the Free Software Foundation; ----
---- either version 2.0 of the License, or (at your option) any   ----
---- later version.                                               ----
----                                                              ----
---- This source is distributed in the hope that it will be       ----
---- useful, but WITHOUT ANY WARRANTY; without even the implied   ----
---- warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ----
---- PURPOSE. See the GNU General Public License for more details.----
----                                                              ----
---- You should have received a copy of the GNU General           ----
---- Public License along with this source; if not, download it   ----
---- from http://www.gnu.org/licenses/gpl.txt                     ----
----                                                              ----
---------------------------------------------------------------------- 
---------------------------------------------------------------------------------------------------------------------------------
--  ENTITY                              :       RSDECODER.VHD           
--  VERSION                             :       0.2                                             
--  VENDOR SPECIFIC?    :       NO
--  FPGA SPECIFIC?              :   NO
--  SOFTWARE RELEASE    :       QII 9.0 SP2
--  CREATION DATE               :       07/10/2008
--  LAST UPDATE         :   08/07/2009  
--  AUTHORs                             :       Frederic MARIN (CPPM), Sophie BARON (CERN)
--  LANGAGE                     :       VHDL'93
---------------------------------------------------------------------------------------------------------------------------------
--      DESCRIPTION                     :       Manually translated from verilog Reed Solomon decoder in the GBT A. Marchioro   2006
--                                                      Input: receivedcode             60 bit wide                             --
--                                                      Output: correctedmsg            44 bit wide                             --
--                                      
---------------------------------------------------------------------------------------------------------------------------------
--      VERSIONS HISTORY        :
--                      DATE                    VERSION                 AUTHOR          DESCRIPTION
--                      10/05/2009              0.1                     MARIN           first .vhdl entity definition           
--                                              08/07/2009                      0.2                                     BARON           cosmetic changes
---------------------------------------------------------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity RSDecoder is
  port(
    receivedcode : in  std_logic_vector(59 downto 0);
    correctedmsg : out std_logic_vector(43 downto 0);
    errordetect  : out std_logic
    );
end RSDecoder;


architecture a of RSDecoder is

  component syndromes is
    port(
      polycoeffs : in  std_logic_vector(59 downto 0);
      s1         : out std_logic_vector(3 downto 0);
      s2         : out std_logic_vector(3 downto 0);
      s3         : out std_logic_vector(3 downto 0);
      s4         : out std_logic_vector(3 downto 0)
      );
  end component;

  component lambdadeterminant is
    port(
      s1        : in  std_logic_vector(3 downto 0);
      s2        : in  std_logic_vector(3 downto 0);
      s3        : in  std_logic_vector(3 downto 0);
      detiszero : out std_logic
      );
  end component;

  component errorlocpolynomial is
    port(
      s1        : in  std_logic_vector(3 downto 0);
      s2        : in  std_logic_vector(3 downto 0);
      s3        : in  std_logic_vector(3 downto 0);
      s4        : in  std_logic_vector(3 downto 0);
      detiszero : in  std_logic;
      L1        : out std_logic_vector(3 downto 0);
      L2        : out std_logic_vector(3 downto 0)
      );
  end component;

  component ChienSearch is
    port(
      L1        : in  std_logic_vector(3 downto 0);
      L2        : in  std_logic_vector(3 downto 0);
      detiszero : in  std_logic;
      xx0       : out std_logic_vector(3 downto 0);
      xx1       : out std_logic_vector(3 downto 0)
      );
  end component;

  component RSTwoErrorsCorrect is
    port(
      s1        : in  std_logic_vector(3 downto 0);
      s2        : in  std_logic_vector(3 downto 0);
      xx0       : in  std_logic_vector(3 downto 0);
      xx1       : in  std_logic_vector(3 downto 0);
      reccoeffs : in  std_logic_vector(59 downto 0);
      detiszero : in  std_logic;
      corcoeffs : out std_logic_vector(59 downto 0)
      );
  end component;

  signal detiszero      : std_logic;
-- Syndromes
  signal s1, s2, s3, s4 : std_logic_vector(3 downto 0);
-- Locations of the two errors
  signal L1, L2         : std_logic_vector(3 downto 0);
-- Magnitudes
  signal xx0, xx1       : std_logic_vector(3 downto 0);
  signal corcoeffs      : std_logic_vector(59 downto 0);

begin
  
  syndromes_inst : syndromes
    port map(
      polycoeffs => receivedcode,
      s1         => s1,
      s2         => s2,
      s3         => s3,
      s4         => s4
      );

  lambdadeterminant_inst : lambdadeterminant
    port map(
      s1        => s1,
      s2        => s2,
      s3        => s3,
      detiszero => detiszero
      );

  errorlocpolynomial_inst : errorlocpolynomial
    port map(
      s1        => s1,
      s2        => s2,
      s3        => s3,
      s4        => s4,
      detiszero => detiszero,
      L1        => L1,
      L2        => L2
      );

  ChienSearch_inst : ChienSearch
    port map(
      L1        => L1,
      L2        => L2,
      detiszero => detiszero,
      xx0       => xx0,
      xx1       => xx1
      );

  RSTwoErrorsCorrect_inst : RSTwoErrorsCorrect
    port map(
      s1        => s1,
      s2        => s2,
      xx0       => xx0,
      xx1       => xx1,
      reccoeffs => receivedcode,
      detiszero => detiszero,
      corcoeffs => corcoeffs
      );

  correctedmsg <= receivedcode(59 downto 16)  when (s1 = X"0" and s2 = X"0" and s3 = X"0" and s4 = X"0") else corcoeffs(59 downto 16);
  errordetect  <= '0' when (s1 = X"0" and s2 = X"0" and s3 = X"0" and s4 = X"0") else '1';
  
end a;
