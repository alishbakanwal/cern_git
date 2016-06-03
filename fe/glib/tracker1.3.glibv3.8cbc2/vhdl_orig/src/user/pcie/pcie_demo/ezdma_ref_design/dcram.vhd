--------------------------------------------------------------------------------
--
-- This source code is confidential information and may be used only as
-- authorized by a licensing agreement from PLDA.
--
--------------------------------------------------------------------------------
-- Project : PCIEZ Reference design
-- $RCSfile: dcram.vhd,v $
-- $Date: 2011/06/28 15:08:48 $
-- $Revision: 1.1.1.7 $
-- $Name: PCIEZREFD_20110627 $
-- $Author: reid $
-------------------------------------------------------------------------------
-- Dependency  :
-------------------------------------------------------------------------------
-- Description : General purpose DPRAM for Xilinx implementation
-------------------------------------------------------------------------------
-- Revision:
-- $Log: dcram.vhd,v $
-- Revision 1.1.1.7  2011/06/28 15:08:48  reid
-- importing projects/pciez_refdesign (PCIEZREFD_20110627, PCIEZREFD_20110627) to RTK database
--
-- Revision 1.4  2010/07/29 10:03:07  plegros
-- Use inferred RAM
--
-- Revision 1.3  2009/08/27 12:19:33  plegros
-- RAM width can now be up to 256 bits
--
-- Revision 1.2  2006/04/14 09:00:57  plegros
-- *** empty log message ***
--
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity dcram is
	generic
		(
		ADDR_WIDTH : integer:=4;
		DATA_WIDTH : integer:=32
		);
	port
		(
		data      : in std_logic_vector((DATA_WIDTH-1) downto 0);
		wren      : in std_logic ;
		wraddress : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		rdaddress : in std_logic_vector((ADDR_WIDTH-1) downto 0);
		wrclock   : in std_logic ;
		rdclock   : in std_logic ;
		q         : out std_logic_vector((DATA_WIDTH-1) downto 0)
		);
end dcram;

---------------------------------------------------------------

architecture xilinx of dcram is
  type   ram_type  is array(0 to ((2**ADDR_WIDTH)-1)) of std_logic_vector((DATA_WIDTH-1) downto 0);
  signal ram_array : ram_type;
  attribute ram_style : string ;
  attribute ram_style of ram_array : signal is "block";

begin
  process (wrclock)
  begin
    if rising_edge(wrclock) then
        if wren='1' then
            ram_array(conv_integer(wraddress)) <= data;
        end if;
    end if;
  end process;

  process (rdclock)
  begin
    if rising_edge(rdclock) then
        q <= ram_array(conv_integer(rdaddress));
    end if;
  end process;
end xilinx;



