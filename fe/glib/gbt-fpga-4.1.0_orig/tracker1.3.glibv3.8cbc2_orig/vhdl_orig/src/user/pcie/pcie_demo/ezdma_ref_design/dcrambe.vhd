--------------------------------------------------------------------------------
--
-- This source code is confidential information and may be used only as
-- authorized by a licensing agreement from PLDA.
--
--------------------------------------------------------------------------------
-- Project : PCIEZ Reference design
-- $RCSfile: dcrambe.vhd,v $
-- $Date: 2011/06/28 15:08:47 $
-- $Revision: 1.1.1.7 $
-- $Name: PCIEZREFD_20110627 $
-- $Author: reid $
-------------------------------------------------------------------------------
-- Dependency  :
-------------------------------------------------------------------------------
-- Description : General purpose DPRAM/BE for Xilinx implementation
-------------------------------------------------------------------------------
-- Revision:
-- $Log: dcrambe.vhd,v $
-- Revision 1.1.1.7  2011/06/28 15:08:47  reid
-- importing projects/pciez_refdesign (PCIEZREFD_20110627, PCIEZREFD_20110627) to RTK database
--
-- Revision 1.5  2010/10/21 09:22:05  plegros
-- Now uses inferred RAM
--
-- Revision 1.4  2009/08/27 12:19:33  plegros
-- RAM width can now be up to 256 bits
--
-- Revision 1.3  2006/11/02 08:51:16  plegros
-- Changed DATAPATH_SIZE default  value to 64
--
-- Revision 1.2  2006/04/14 09:00:57  plegros
-- *** empty log message ***
--
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity dcrambe_unit is
	generic
		(
		ADDR_WIDTH : integer:=4;
		DATA_WIDTH : integer:=32;
		BYTE_SIZE  : integer:=8
		);
	port
		(
		wrclk	: in std_logic;
		wraddr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		wrdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		wrbe	: in std_logic_vector(DATA_WIDTH/BYTE_SIZE-1 downto 0);

		rdclk	: in std_logic;
		rdaddr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		rddata	: out std_logic_vector(DATA_WIDTH-1 downto 0)
		);
end dcrambe_unit;

architecture xilinx of dcrambe_unit is
  type   ram_type  is array(0 to ((2**ADDR_WIDTH)-1)) of std_logic_vector((DATA_WIDTH-1) downto 0);
  signal ram_array : ram_type;
  attribute ram_style : string ;
  attribute ram_style of ram_array : signal is "block";

begin
  process (wrclk)
  begin
    if rising_edge(wrclk) then
        for i in 0 to DATA_WIDTH/BYTE_SIZE-1 loop
            if wrbe(i)='1' then
                ram_array(conv_integer(wraddr))((i+1)*BYTE_SIZE-1 downto i*BYTE_SIZE)
                    <= wrdata((i+1)*BYTE_SIZE-1 downto i*BYTE_SIZE);
            end if;
        end loop;
    end if;
  end process;

  process (rdclk)
  begin
    if rising_edge(rdclk) then
        rddata <= ram_array(conv_integer(rdaddr));
    end if;
  end process;
end xilinx;

---------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity dcrambe is
	generic
		(
		ADDR_WIDTH : integer:=4;
		DATA_WIDTH : integer:=256;
		BYTE_SIZE  : integer:=8
		);
	port
		(
		wrclk	: in std_logic;
		wraddr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		wrdata	: in std_logic_vector(DATA_WIDTH-1 downto 0);
		wrbe	: in std_logic_vector(DATA_WIDTH/BYTE_SIZE-1 downto 0);

		rdclk	: in std_logic;
		rdaddr	: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		rddata	: out std_logic_vector(DATA_WIDTH-1 downto 0)
		);
end dcrambe;

architecture xilinx of dcrambe is
	component dcrambe_unit
	generic
		(
		ADDR_WIDTH : integer:=4;
		DATA_WIDTH : integer:=32;
		BYTE_SIZE  : integer:=8
		);
	port
		(
		wrclk	: in std_logic;
		wraddr	: in std_logic_vector (ADDR_WIDTH-1 downto 0);
		wrdata	: in std_logic_vector (DATA_WIDTH-1 downto 0);
		wrbe	: in std_logic_vector (DATA_WIDTH/BYTE_SIZE-1 downto 0);
		rdclk	: in std_logic;
		rdaddr	: in std_logic_vector (ADDR_WIDTH-1 downto 0);
		rddata	: out std_logic_vector (DATA_WIDTH-1 downto 0)
		);
	end component;
begin
   gram : for i in 0 to DATA_WIDTH/32-1 generate
	ram : dcrambe_unit
	generic map (
		ADDR_WIDTH	=> ADDR_WIDTH,
		DATA_WIDTH	=> 32,
		BYTE_SIZE  	=> 8
		)
	port map (
		wrclk		=> wrclk,
		wraddr  	=> wraddr,
		wrdata 		=> wrdata(i*32+31 downto i*32),
		wrbe		=> wrbe(i*4+3 downto i*4),
		rdclk		=> rdclk,
		rdaddr		=> rdaddr,
		rddata  	=> rddata(i*32+31 downto i*32)
		);
   end generate gram;
end xilinx;

