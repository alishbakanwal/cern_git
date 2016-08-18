-- Contains the instantiation of the Xilinx MAC IP plus the GMII PHY interface
--
-- Do not change signal names in here without corresponding alteration to the timing contraints file
--
-- Dave Newbold, April 2011
--
-- $Id$

library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.VComponents.all;

entity eth_v6_sgmii is
	generic(
		IODEL: integer := 20
	);
	port(
		sgmii_clk: in std_logic;
		sgmii_txp, sgmii_txn: out std_logic;
		sgmii_rxp, sgmii_rxn: in std_logic;
		sync_acq: out std_logic;
		locked: out std_logic;
		clk125_i: in 	std_logic;
		clk125_o: out 	std_logic;
		rxclko: out 	std_logic;
		rst: in std_logic;
		txd: in std_logic_vector(7 downto 0);
		txdvld: in std_logic;
		txack: out std_logic;
		rxd: out std_logic_vector(7 downto 0);
		rxdvld: out std_logic;
		rxgoodframe: out std_logic;
		rxbadframe: out std_logic
	);

end eth_v6_sgmii;

architecture rtl of eth_v6_sgmii is

	signal clkin, clk125, clk125_out: std_logic;
	signal clkp, clkn: std_logic;

begin

	bufg0: bufg port map(
		i => clk125_out,
		o => clk125
	);

	rxclko <= clk125;
	clk125_o <= clk125;

	sgmii: entity work.v6_emac_v1_5_block_sgmii 
	port map(
      CLK125_OUT => clk125_out,
      CLK125 => clk125_i,
      EMACCLIENTRXD => rxd,
      EMACCLIENTRXDVLD => rxdvld,
      EMACCLIENTRXGOODFRAME => rxgoodframe,
      EMACCLIENTRXBADFRAME => rxbadframe,
      EMACCLIENTRXFRAMEDROP => open,
      EMACCLIENTRXSTATS => open,
      EMACCLIENTRXSTATSVLD => open,
      EMACCLIENTRXSTATSBYTEVLD => open,
      CLIENTEMACTXD => txd,
      CLIENTEMACTXDVLD => txdvld,
      EMACCLIENTTXACK => txack,
      CLIENTEMACTXFIRSTBYTE => '0',
      CLIENTEMACTXUNDERRUN => '0',
      EMACCLIENTTXCOLLISION => open,
      EMACCLIENTTXRETRANSMIT => open,
      CLIENTEMACTXIFGDELAY => (others => '0'),
      EMACCLIENTTXSTATS => open,
      EMACCLIENTTXSTATSVLD => open,
      EMACCLIENTTXSTATSBYTEVLD => open,
      CLIENTEMACPAUSEREQ => '0',
      CLIENTEMACPAUSEVAL => (others => '0'),
      EMACCLIENTSYNCACQSTATUS => sync_acq,
      EMACANINTERRUPT => open,
      TXP => sgmii_txp,
      TXN => sgmii_txn,
      RXP => sgmii_rxp,
      RXN => sgmii_rxn,
      PHYAD => "00111", --(others => '0'),
      RESETDONE => locked,
      CLK_DS => sgmii_clk,
      RESET => rst,
      -------------
      mdc_in => '1',
   	mdio_i => '1'
   );

end rtl;
