#### This folder contains the low latency optimization files for the GBT-FPGA transmitter ####
Steffen Muschter, Sophie Baron

There are three different kinds of optimization you one can choose.
To use the optimized code one only have to replace the original files with the files within this folder.
One further more constraint is that the phase relation between the 40MHz and 120MHz clock signal is fixed and the phase difference is 0 degrees.
This constraint is very important. We recommend as well strongly to read the recommendation document available on the GBT-FPGA to 
fully understand the constraints using such latency optimized schemes.
This is not supposed to be used together with the ressource optimization in Altera or Xilinx devices.

1. low latency using RAM modules:
	Files to replace:
		Scrambler.vhd			with		Scrambler_opt.vhd
		Scrambling.vhd			with		Scrambling_opt.vhd
		RW_TX_DP_RAM.vhd			with		RW_TX_DP_RAM_opt_ALTERA.vhd or RW_TX_DP_RAM_opt_XILINX.vhd 

2. low latency using registers (the latency is the same like in 1.)
	Files to replace:
		Mux_120_to_40bits.vhd		with		Mux_120_to_40bits_opt2.vhd
		Scrambler.vhd			with		Scrambler_opt.vhd
		Scrambling.vhd			with		Scrambling_opt.vhd

	Components which are not necessary anymore:
		RW_TX_DP_RAM
		tx_dp_ram

3. lowest latency (latency is one clock cycle below 1. and 2.)
	Files to replace:
		Mux_120_to_40bits.vhd		with		Mux_120_to_40bits_opt.vhd
		Scrambler.vhd			with		Scrambler_opt.vhd
		Scrambling.vhd			with		Scrambling_opt.vhd

	Components which are not necessary anymore:
		RW_TX_DP_RAM
		tx_dp_ram

