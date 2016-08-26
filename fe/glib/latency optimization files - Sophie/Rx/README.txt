#### This folder contains the low latency optimization files for the GBT-FPGA receiver ####
Steffen Muschter, Sophie Baron

There are three different kinds of optimization you one can choose.
To use the optimized code one only have to replace the original files with the files within this folder.
One further more constraint is that the phase relation between the 40MHz and 120MHz clock signal is fixed and the phase difference is 0 degrees. 
Pay attention to this constraint, and read carefully the recommendations available on the GBT_FPGA web site to be fully aware of the constraints 
in term of timing imposed by the latency optimized scheme. 
This is not supposed to be used together with the ressource optimization in Altera or Xilinx devices.

1. low latency using RAM modules:
	Files to replace:
		Pattern_Search.vhd		with		Pattern_Search_opt.vhd
		Read_RX_DP_RAM.vhd		with		Read_RX_DP_RAM_opt.vhd
		Decoding.vhd			with		Decoding_opt.vhd
		Descrambler.vhd			with		Descrambler_opt.vhd

2. low latency using registers (the latency is the same like in 1.)
	Files to replace:
		Pattern_Search.vhd		with		Pattern_Search_opt.vhd
		Demux_40_to_120bits.vhd	with		Demux_40_to_120bits_opt2.vhd
		Decoding.vhd			with		Decoding_opt.vhd
		Descrambler.vhd			with		Descrambler_opt.vhd

	Components which are not necessary anymore:
		Read_RX_DP_RAM
		rx_dp_ram

3. lowest latency (latency is one clock cycle below 1. and 2.)
	Files to replace:
		Pattern_Search.vhd		with		Pattern_Search_opt.vhd
		Demux_40_to_120bits.vhd	with		Demux_40_to_120bits_opt.vhd
		Decoding.vhd			with		Decoding_opt.vhd
		Descrambler.vhd			with		Descrambler_opt.vhd

	Components which are not necessary anymore:
		Read_RX_DP_RAM
		rx_dp_ram

