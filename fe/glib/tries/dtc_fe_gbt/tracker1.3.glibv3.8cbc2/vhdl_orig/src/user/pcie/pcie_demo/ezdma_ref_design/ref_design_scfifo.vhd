--------------------------------------------------------------------------------
--
-- This source code is confidential information and may be used only as
-- authorized by a licensing agreement from PLDA.
--
--------------------------------------------------------------------------------
-- Project : PCIEZ reference design
-- $RCSfile: ref_design_scfifo.vhd,v $
-- $Date: 2011/06/28 15:08:38 $
-- $Revision: 1.1.1.7 $
-- $Name: PCIEZREFD_20110627 $
-- $Author: reid $
-------------------------------------------------------------------------------
-- Dependency  :
-------------------------------------------------------------------------------
-- Description : General purpose synchronous Single-clock FIFO
-------------------------------------------------------------------------------
-- Revision:
-- $Log: ref_design_scfifo.vhd,v $
-- Revision 1.1.1.7  2011/06/28 15:08:38  reid
-- importing projects/pciez_refdesign (PCIEZREFD_20110627, PCIEZREFD_20110627) to RTK database
--
-- Revision 1.3  2010/01/11 17:12:16  plegros
-- Optimised rdaddr_next
--
-- Revision 1.2  2006/04/14 09:00:16  plegros
-- *** empty log message ***
--
--
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity ref_design_scfifo is
	generic
		(
		ADDR_WIDTH	: integer:=8;
		DATA_WIDTH	: integer:=32
		);
	port
		(
		clk			: in std_logic;
		rstn		: in std_logic;
		srst		: in std_logic;

		wrreq		: in std_logic;
		wrdata		: in std_logic_vector (DATA_WIDTH-1 downto 0);
		wrfreew	 	: out std_logic_vector(ADDR_WIDTH-1 downto 0);

		rdreq		: in std_logic;
		rddata		: out std_logic_vector (DATA_WIDTH-1 downto 0);
		rdusedw	 	: out std_logic_vector(ADDR_WIDTH-1 downto 0)
		);
end ref_design_scfifo;

architecture structural of ref_design_scfifo is

	component dcram
	generic
		(
		ADDR_WIDTH	: INTEGER:=4;
		DATA_WIDTH	: INTEGER:=32
		);
	port
		(
		data		: in std_logic_vector((DATA_WIDTH-1) downto 0);
		wren		: in std_logic ;
		wraddress	: in std_logic_vector((ADDR_WIDTH-1) downto 0);
		rdaddress	: in std_logic_vector((ADDR_WIDTH-1) downto 0);
		wrclock		: in std_logic ;
		rdclock		: in std_logic ;
		q			: out std_logic_vector((DATA_WIDTH-1) downto 0)
		);
	end component;

	signal rddata_n						: std_logic_vector (DATA_WIDTH-1 downto 0);
	signal rdad,wrad,rdad_plus1			: std_logic_vector (ADDR_WIDTH-1 downto 0);
	signal rdaddr_next					: std_logic_vector (ADDR_WIDTH-1 downto 0);

	signal read_allow,write_allow		: std_logic;
	signal write_allow_r,write_allow_rr	: std_logic;
	signal wrcount,rdcount				: std_logic_vector (ADDR_WIDTH-1 downto 0);
	signal wrfull_r,rdempty_r			: std_logic;
	
	signal ONE							: std_logic_vector(31 downto 0);
begin
    ONE <=x"00000001";
	
	----------------------------------------------------------------
	--                                                            --
	--  Dual-port RAM instantiation                               --
	--                                                            --
	----------------------------------------------------------------

	ram : dcram
	generic map ( ADDR_WIDTH=>ADDR_WIDTH, DATA_WIDTH=>DATA_WIDTH )
	port map
		(
		wrclock		=> clk,
		wren		=> write_allow,
		wraddress	=> wrad,
		data		=> wrdata,
		rdclock		=> clk,
		rdaddress	=> rdaddr_next,
		q			=> rddata_n
		);

	----------------------------------------------------------------
	--                                                            --
	-- Address pointers	& output register                         --
	--                                                            --
	----------------------------------------------------------------

	process (clk,rstn)
	begin
		if rstn='0' then
			rddata <=(others=>'0');
			wrad <=(others=>'0');
			rdad <=(others=>'0');
			rdad_plus1 <=ONE(ADDR_WIDTH-1 downto 0);
		elsif rising_edge (clk) then
			if srst='1' then
				rddata <=(others=>'0');
				wrad <=(others=>'0');
				rdad <=(others=>'0');
				rdad_plus1 <=ONE(ADDR_WIDTH-1 downto 0);
			else
				wrad <=unsigned (wrad)+write_allow;
				rdad <=rdaddr_next;
				rdad_plus1 <=unsigned(rdaddr_next)+'1';

				if read_allow='1' then
					rddata <=rddata_n;
				end if;
			end if;
		end if;
	end process;

    rdaddr_next <=rdad_plus1 when read_allow='1'
    			else rdad;

	----------------------------------------------------------------
	--                                                            --
	--  Read/write data counters	                              --
	--  Empty/full flags			                              --
	--                                                            --
	----------------------------------------------------------------

	write_allow <=wrreq and not wrfull_r;
	read_allow <=rdreq and not rdempty_r;

	-- Data counters
	process (clk,rstn)
	begin
		if rstn='0' then
			write_allow_r <='0';
			write_allow_rr <='0';
			wrcount <=(others=>'1');
			rdcount <=(others=>'0');
			wrfull_r <='0';
			rdempty_r <='1';
		elsif rising_edge (clk) then
			if srst='1' then
				write_allow_r <='0';
				write_allow_rr <='0';
				wrcount <=(others=>'1');
				rdcount <=(others=>'0');
				wrfull_r <='0';
				rdempty_r <='1';
			else
				write_allow_r <=write_allow;
				write_allow_rr <=write_allow_r;

				if read_allow='1' and write_allow='0' then
					wrcount <=unsigned (wrcount)+'1';
				elsif read_allow='0' and write_allow='1' then
					wrcount <=unsigned (wrcount)-'1';
				end if;

				if read_allow='1' and write_allow_rr='0' then
					rdcount <=unsigned (rdcount)-'1';
				elsif read_allow='0' and write_allow_rr='1' then
					rdcount <=unsigned (rdcount)+'1';
				end if;

			    if unsigned (wrcount(ADDR_WIDTH-1 downto 1))=0 and rdreq='0' and (wrcount(0)='0' or wrreq='1') then
			       wrfull_r <= '1';
			    else
			       wrfull_r <= '0';
			    end if;

				if unsigned (rdcount(ADDR_WIDTH-1 downto 1))=0 and write_allow_rr='0' and (rdcount(0)='0' or rdreq='1') then
					rdempty_r <= '1';
				else
					rdempty_r <= '0';
				end if;
			end if;
		end if;
	end process;

	wrfreew <=wrcount;
  	rdusedw <=rdcount;

end structural;
