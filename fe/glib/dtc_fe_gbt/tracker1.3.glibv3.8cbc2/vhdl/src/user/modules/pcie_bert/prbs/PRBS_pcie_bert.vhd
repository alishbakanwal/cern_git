-- Configurable Pseudo Random Bit Sequence
-- Serial / Parallel (configurable width)
-- PRBS type configurable (select taps from Xilinx xapp052, Table 3
-- Starts from input seed
-- Paschalis Vichoudis, CERN

library ieee;
use ieee.std_logic_1164.all;
USE work.user_pcie_bert_package.all;

ENTITY PRBS_pcie_bert IS -- PRBS7 parallel, width 21bit
GENERIC 
(
	TA	: tap_array	:=( 31, 28, 0, 0);--Tap Array - max fixed size: 4
	TN	: integer  	:= 2 ;			--Number of Taps to take into account (max:4)
	L	: integer	:= 31 ; 			--PRBS type e.g. for PRBS7 -> L=7
	W	: integer	:= 64  			--Serializer data width
);

--======= LFSR Tap Examples (from xapp052) ========--
-- PRBS31: 31th, 28th			-> TN=2, TA=(31,28, 0, 0)
-- PRBS23: 23th, 18th			-> TN=2, TA=(23,18, 0, 0)
-- PRBS15: 15th, 14th			-> TN=2, TA=(15,14, 0, 0)
-- PRBS10: 10th, 7th 			-> TN=2, TA=(10, 7, 0, 0)
-- PRBS9 :  9th, 5th 			-> TN=2, TA=( 9, 5, 0, 0)
-- PRBS8 :  8th, 6th, 5th, 4th 	-> TN=4, TA=( 8, 6, 5, 4)
-- PRBS7 :  7th, 6th 			-> TN=2, TA=( 7, 6, 0, 0) # alternatively TA=( 7, 1, 0, 0)
-- PRBS6 :  6th, 5th 			-> TN=2, TA=( 6, 5, 0, 0)
-- PRBS5 :  5th, 3rd 			-> TN=2, TA=( 5, 3, 0, 0)
--=================================================--
PORT
(
	clock		: IN	STD_LOGIC;
	areset	: IN	STD_LOGIC;
	enable	: IN	STD_LOGIC;
	seed		: IN	STD_LOGIC_VECTOR(L-1 DOWNTO 0);
	sdv		: OUT	STD_LOGIC;
	sdata		: OUT	STD_LOGIC;
	pdv		: OUT	STD_LOGIC;
	pdata		: OUT	STD_LOGIC_VECTOR(W-1 DOWNTO 0)
);
END PRBS_pcie_bert;

ARCHITECTURE RTL OF PRBS_pcie_bert IS

--SIGNAL EN	: STD_LOGIC;

BEGIN
--===========================--
serial: process (areset, clock)
--===========================--
variable pattern	: std_logic_vector(L-1 DOWNTO 0);
variable feedback	: std_logic;
variable sdv_reg	: std_logic;
variable sdata_reg	: std_logic;
begin

if areset='1' then
		pattern  	:= seed;
		SDV		 	<= '0';
		SDATA			<= '0';
		sdv_reg		:= '0';
		sdata_reg	:= '0';
elsif clock'event and clock='1' then

	--==== out =====--
	SDATA	<= sdata_reg;
	SDV		<= sdv_reg;
	
	
	if enable = '1' then --en='1' then	
		--==== main ====--
		sdv_reg		:='1';
		sdata_reg	:= pattern(L-1);
		feedback:= pattern(TA(0)-1);
		for j in 1 to TN-1 loop
			feedback:=feedback xnor pattern(TA(j)-1);
		end loop;
		pattern (L-1 downto 1):= pattern(L-2 downto 0);
		pattern(0):=feedback;
	end if;
end if;
end process; 


--===========================--
parallel: process (areset, clock)
--===========================--
variable pattern	: std_logic_vector(L-1 DOWNTO 0);
variable feedback	: std_logic;
variable pdv_reg	: std_logic;
variable pdata_reg	: std_logic_vector(W-1 DOWNTO 0);
	
begin
if areset='1' then

	pattern  	:= seed;
	PDV		 	<= '0';
	PDATA		<= (others=>'0');
	pdv_reg		:= '0';
	pdata_reg	:= (others=>'0');

elsif clock'event and clock='1' then

	--==== out =====--
	PDATA	<= pdata_reg;
	PDV		<= pdv_reg;
	
	if enable = '1' then --en='1' then	
		--==== main ====--
		pdv_reg	:='1';
		for i in 0 to W-1 loop
			--==============--
			pdata_reg(i):= pattern(L-1);
			--==============--
			feedback:= pattern(TA(0)-1);
			for j in 1 to TN-1 loop
				feedback:=feedback xnor pattern(TA(j)-1);
			end loop;
			pattern (L-1 downto 1):= pattern(L-2 downto 0);
			pattern(0):=feedback;
		end loop;	
   else
      pdv_reg	:='0';
	end if;
end if;
end process;

----===========================--
--reg_in: process (areset, clock)
----===========================--
--begin
--if areset='1' then
--	en <= '0';
--elsif clock'event and clock='1' then
--	en <= enable;
--end if;
--end process;

END RTL;