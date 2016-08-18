--------------------------------------------------------------------------------
--
-- This source code is confidential information and may be used only as
-- authorized by a licensing agreement from PLDA.
--
--------------------------------------------------------------------------------
-- Project : PCIEZ Reference design
-- $RCSfile: dma_sg.vhd,v $
-- $Date: 2011/06/28 15:08:38 $
-- $Revision: 1.1.1.7 $
-- $Name: PCIEZREFD_20110627 $
-- $Author: reid $
-------------------------------------------------------------------------------
-- Dependency  :
-------------------------------------------------------------------------------
-- Description : PCIEZ reference design DMA scatter-gather module
-------------------------------------------------------------------------------
-- Revision:
-- $Log: dma_sg.vhd,v $
-- Revision 1.1.1.7  2011/06/28 15:08:38  reid
-- importing projects/pciez_refdesign (PCIEZREFD_20110627, PCIEZREFD_20110627) to RTK database
--
-- Revision 1.23  2011/06/17 13:24:25  plegros
-- SG now terminates gracefully and correctly reports error status when an error occurs while fetching descriptor.
--
-- Revision 1.22  2011/05/24 08:48:25  plegros
-- Clarified DMA end detection so that it is similar with/without scatter-gather enabled
--
-- Revision 1.21  2011/02/21 14:43:35  plegros
-- Fixed dma_regin[127:96] (local address) initialisation. FIxed initialisation of dma_regin[95:0] in several clock cycles.
--
-- Revision 1.20  2010/07/15 08:06:12  plegros
-- Added support for 256-bit datapath, partial code rewrite for clarity
--
-- Revision 1.19  2010/01/06 09:14:53  plegros
-- Fix for page end mode
--
-- Revision 1.18  2009/11/18 12:57:06  plegros
-- Removed useless when others=>
--
-- Revision 1.17  2009/08/31 07:48:17  plegros
-- Optimized dma_fifocnt
--
-- Revision 1.16  2009/08/24 12:19:50  plegros
-- Added 32-bit support
--
-- Revision 1.15  2009/05/14 09:49:23  plegros
-- Renamed dma_fifocnt  ports of dma_sg for consistency
--
-- Revision 1.14  2009/04/27 14:31:34  jdenis
-- Modify S&G mode
--
-- Revision 1.13  2009/04/14 13:57:04  jdenis
-- Modify SG management.
--
-- Revision 1.12  2009/04/03 14:12:17  jdenis
-- all 64-128 bit case supported in the descriptor
--
-- Revision 1.11  2009/03/31 08:52:57  plegros
-- 128-bit mode fixes
--
-- Revision 1.10  2009/03/30 13:39:25  jdenis
-- Implemented 128-bit support
--
-- Revision 1.9  2009/01/23 10:06:45  plegros
-- Renamed ports to be more clear. Fixed local address handling that was incorrect.
--
-- Revision 1.8  2008/11/21 13:54:59  plegros
-- Fixed page_req_count increment in order to get rid of synthesis warning
--
-- Revision 1.7  2008/11/10 14:41:55  plegros
-- *** empty log message ***
--
-- Revision 1.6  2007/07/25 09:33:06  plegros
-- Descriptor are now fetched in RAM mode so that dma_fifocnt is not taken into account when fetching descriptors
--
-- Revision 1.5  2007/06/21 12:33:51  plegros
-- Added translateoff to report statement
--
-- Revision 1.4  2006/08/21 13:53:32  plegros
-- Removed translate on/off
--
-- Revision 1.3  2006/08/21 09:26:38  plegros
-- Update for v1.4
--
-- Revision 1.2  2006/08/02 14:47:25  plegros
-- Code clean-up, removed some unnecessary registers
--
-- Revision 1.1  2006/07/20 15:03:14  plegros
-- Added scatter-gather DMA support
--
--
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

---------------------------------------------------------------

entity dma_sg is
    generic (
		DATAPATH    		: integer:=64;   -- Indicates DATA path : 32,64,128 or 256 bits
        DMASIZE     		: integer:=32;   -- Maximum dma/page size 13..32
        SG_MODE				: integer:=0	 -- Size_mode = 0	Page End mode = 1
        );
	port (
		clk 				: in std_logic;
		rstn 				: in std_logic;
		srst 				: in std_logic;

		-- Interface to application logic
        app_sg_enable   	: in std_logic;
		app_dma_regin		: in std_logic_vector (127 downto 0);
		app_dma_param 		: in std_logic_vector (23 downto 0);
		app_dma_control		: in std_logic_vector (5 downto 0);
		app_sg_idle			: out std_logic;
		app_dma_wr			: out std_logic;
   		app_dma_fifocnt 	: in std_logic_vector (12 downto 0);

		-- Interface to EZ DMA
		dma_wr				: in std_logic;
		dma_wrchannel		: in std_logic;
		dma_wrdata			: in std_logic_vector (DATAPATH-1 downto 0);
		dma_status	 		: in std_logic_vector (3 downto 0);
		dma_regout			: in  std_logic_vector (127 downto 0);
		dma_regin			: out std_logic_vector (127 downto 0);
		dma_param 			: out std_logic_vector (23 downto 0);
		dma_control			: out std_logic_vector (5 downto 0);
		dma_fifocnt     	: out std_logic_vector (12 downto 0)
		);
end dma_sg;

---------------------------------------------------------------

architecture structural of dma_sg is
	---------------------------------------------------------------

	-- Compute least significant address bit, according to datapath size
	-- 32-bit : 2, 64-bit : 3 , 128-bit : 4, 256-bit : 5
	constant ADDR_LOW			: integer:=2+(DATAPATH/64)-(DATAPATH/256);

    -- Descriptor field number
    constant PAGE_ADRL_REG_NUM 	: integer:=0;
    constant PAGE_ADRH_REG_NUM 	: integer:=1;
    constant PAGE_SIZE_REG_NUM 	: integer:=2;
    constant NEXT_ADRL_REG_NUM 	: integer:=3;
    constant NEXT_ADRH_REG_NUM 	: integer:=4;

    -- Compute descripor field position in dma_wrdata_shift, according to datapath size
	constant PAGE_ADRL_REG_POS 	: integer:=(PAGE_ADRL_REG_NUM mod (DATAPATH/32))*32;
	constant PAGE_ADRH_REG_POS 	: integer:=(PAGE_ADRH_REG_NUM mod (DATAPATH/32))*32;
	constant PAGE_SIZE_REG_POS 	: integer:=(PAGE_SIZE_REG_NUM mod (DATAPATH/32))*32;
	constant NEXT_ADRL_REG_POS 	: integer:=(NEXT_ADRL_REG_NUM mod (DATAPATH/32))*32;
	constant NEXT_ADRH_REG_POS 	: integer:=(NEXT_ADRH_REG_NUM mod (DATAPATH/32))*32;

	---------------------------------------------------------------

	type sgstate is (idle,page_read,send_req,wait_end_req,next_page_req,ending,aborting);
    type sgload is (init,desc_load,update_cnt,wait_end_dma);

	---------------------------------------------------------------

	-- Load descriptor
	signal sg_load							: sgload;
	signal page_desc_disal                  : std_logic_vector (2 downto 0);
	signal page_addr                        : std_logic_vector (63 downto 0);
	signal page_next_addr	    			: std_logic_vector (63 downto 0);
	signal dma_wrdata_shift					: std_logic_vector (DATAPATH-1 downto 0);
	signal page_size		                : std_logic_vector (DMASIZE-1 downto 0);
	signal page_end_chain				 	: std_logic;
	signal reg_write_ini,reg_write			: std_logic_vector (4 downto 0);
	signal reg_write_en						: std_logic;

    -- Scatter-gather control
	signal sg_state							: sgstate;
	signal dma_status3_r,next_page_needed 	: std_logic;
	signal dma_req_param	                : std_logic_vector (23 downto 0);
	signal dma_next_size,dma_left_size  	: std_logic_vector (DMASIZE-1 downto 0);

begin
	---------------------------------------------------------------
	-- Load descriptor
	--
	-- Dword0 : page address[31:2], bits [1:0] not used
	-- Dword1 : page address[63:32]
	-- Dword2 : page size
	-- Dword3 : next descriptor address[31:2], bit 1 not used, bit 0 is end of chain
	-- Dword4 : next descriptor address[63:32]
	--
	---------------------------------------------------------------

  	g32 : if DATAPATH=32 generate
  		dma_wrdata_shift <=dma_wrdata;
  		reg_write_ini <="00001";
  	end generate g32;

 	-- Descriptor can be store at any 32-bit aligned location in memory
  	-- so shift received data to have always Dword0 aligned on LSB

  	g64 : if DATAPATH=64 generate
  		dma_wrdata_shift <=dma_wrdata(31 downto 0) & dma_wrdata(63 downto 32) when page_desc_disal(0)='1'
  					  else dma_wrdata;

  		reg_write_ini <="00001" when page_desc_disal(0)='1'
  				   else "00011";
  	end generate g64;

  	g128 : if DATAPATH=128 generate
  		dma_wrdata_shift <=dma_wrdata(95 downto 0) & dma_wrdata(127 downto 96) when page_desc_disal(1 downto 0)="11"
  					  else dma_wrdata(63 downto 0) & dma_wrdata(127 downto 64) when page_desc_disal(1 downto 0)="10"
  					  else dma_wrdata(31 downto 0) & dma_wrdata(127 downto 32) when page_desc_disal(1 downto 0)="01"
  					  else dma_wrdata;

  		reg_write_ini <="00001" when page_desc_disal(1 downto 0)="11"
  				   else "00011" when page_desc_disal(1 downto 0)="10"
  				   else "00111" when page_desc_disal(1 downto 0)="01"
  				   else "01111";
  	end generate g128;

  	g256 : if DATAPATH=256 generate
  		dma_wrdata_shift <=dma_wrdata(223 downto 0) & dma_wrdata(255 downto 224) when page_desc_disal="111"
  					  else dma_wrdata(191 downto 0) & dma_wrdata(255 downto 192) when page_desc_disal="110"
  					  else dma_wrdata(159 downto 0) & dma_wrdata(255 downto 160) when page_desc_disal="101"
  					  else dma_wrdata(127 downto 0) & dma_wrdata(255 downto 128) when page_desc_disal="100"
  					  else dma_wrdata(95 downto 0)  & dma_wrdata(255 downto 96)  when page_desc_disal="011"
  					  else dma_wrdata(63 downto 0)  & dma_wrdata(255 downto 64)  when page_desc_disal="010"
  					  else dma_wrdata(31 downto 0)  & dma_wrdata(255 downto 32)  when page_desc_disal="001"
  					  else dma_wrdata;

  		reg_write_ini <="00001" when page_desc_disal="111"
  				   else "00011" when page_desc_disal="110"
  				   else "00111" when page_desc_disal="101"
  				   else "01111" when page_desc_disal="100"
  				   else "11111";
   	end generate g256;

  	-- Enable write to register(s)
  	reg_write_en <='1' when sg_load=desc_load and app_dma_control(5)='0' and dma_wrchannel='1' and dma_wr='1'
  					  else '0';


	process (clk,rstn)
	begin
		if rstn='0' then
			sg_load <= init;
			page_desc_disal <=(others=>'0');
			page_addr <=(others=>'0');
			page_size <=(others=>'0');
			page_next_addr <=(others=>'0');
			page_end_chain <='0';
			reg_write <=(others=>'0');
		elsif rising_edge (clk) then
			if srst='1' then
				sg_load <= init;
				page_desc_disal <=(others=>'0');
				page_addr <=(others=>'0');
				page_size <=(others=>'0');
				page_next_addr <=(others=>'0');
				page_end_chain <='0';
				reg_write <=(others=>'0');
			else
				-- Descriptor loading state machine
				case sg_load is
					when init =>
						if sg_state = page_read and app_dma_control(5)/='1'  then
							sg_load <=desc_load;
						end if;
					when desc_load =>
						if reg_write_en='1' and reg_write(4)='1' then
							-- Last register is being written, this is the end of the transfer
							sg_load <=update_cnt;
					    elsif app_dma_control(5)='1' or dma_status(3)='0' then
							-- Give-up if DMA is aborted or ends unexpectedly
							sg_load <=wait_end_dma;
						end if;
					when update_cnt =>
						sg_load <= wait_end_dma;
					when wait_end_dma =>
						if dma_status(3)='0' then
							sg_load <= init;
						end if;
				end case;

				-- Remember descriptor start address alignement
				if sg_load=init then
					if sg_state=idle and app_dma_control(0)='1' then
						page_desc_disal	<=app_dma_regin(4 downto 2);
					else
					    page_desc_disal	<=page_next_addr(4 downto 2);
					end if;
				end if;

				-- Detect which register(s) must be written
				if sg_load=init then
					reg_write <=reg_write_ini;
				elsif sg_load=desc_load and reg_write_en='1' then
					if DATAPATH=32 then
						reg_write <=reg_write(3 downto 0) & '0';
					elsif DATAPATH=64 then
						if reg_write(1 downto 0)="01" then
							reg_write <=reg_write(2 downto 0) & "10";
						else
							reg_write <=reg_write(2 downto 0) & "00";
						end if;
					else -- 128 or 256 bits
						reg_write <=not reg_write;
					end if;
				end if;

				-- Load descriptor
				if reg_write_en='1' and reg_write(PAGE_ADRL_REG_NUM)='1' then
-- synthesis translate_off
					if unsigned (dma_wrdata_shift(PAGE_ADRL_REG_POS+ADDR_LOW downto PAGE_ADRL_REG_POS))/=0 then
						report "DMA_SG: ERROR : PAGE ADDRESS IS INCORRECTLY ALIGNED" severity error;
					end if;
-- synthesis translate_on
					page_addr(31 downto 0) <=dma_wrdata_shift(PAGE_ADRL_REG_POS+31 downto PAGE_ADRL_REG_POS);
				end if;

				if reg_write_en='1' and reg_write(PAGE_ADRH_REG_NUM)='1' then
					page_addr(63 downto 32) <=dma_wrdata_shift(PAGE_ADRH_REG_POS+31 downto PAGE_ADRH_REG_POS);
				end if;

				if reg_write_en='1' and reg_write(PAGE_SIZE_REG_NUM)='1' then
-- synthesis translate_off
					if unsigned (dma_wrdata_shift(PAGE_SIZE_REG_POS+ADDR_LOW downto PAGE_SIZE_REG_POS))/=0 then
						report "DMA_SG: ERROR : PAGE SIZE IS NOT A MULTIPLE OF DATAPATH SIZE" severity error;
					end if;
-- synthesis translate_on
					page_size <=dma_wrdata_shift(PAGE_SIZE_REG_POS+(DMASIZE-1) downto PAGE_SIZE_REG_POS);
				end if;

				if sg_state=idle and app_dma_control(0)='1' then
					page_next_addr(31 downto 2) <=app_dma_regin(31 downto 2);
					page_end_chain <='0';
				elsif reg_write_en='1' and reg_write(NEXT_ADRL_REG_NUM)='1' then
-- synthesis translate_off
					if dma_wrdata_shift(NEXT_ADRL_REG_POS+1)/='0' then
						report "DMA_SG: ERROR : NEXT DESCRIPTOR ADDRESS IS INCORRECTLY ALIGNED" severity error;
					end if;
-- synthesis translate_on
					page_next_addr(31 downto 0) <=dma_wrdata_shift(NEXT_ADRL_REG_POS+31 downto NEXT_ADRL_REG_POS);
					page_end_chain <=dma_wrdata_shift(NEXT_ADRL_REG_POS);
				end if;

				if sg_state=idle and app_dma_control(1)='1' then
					page_next_addr(63 downto 32) <=app_dma_regin(63 downto 32);
				elsif reg_write_en='1' and reg_write(NEXT_ADRH_REG_NUM)='1' then
					page_next_addr(63 downto 32) <=dma_wrdata_shift(NEXT_ADRH_REG_POS+31 downto NEXT_ADRH_REG_POS);
				end if;
			end if;
		end if;
	end process;


	---------------------------------------------------------------
	-- Scatter-gather control
	---------------------------------------------------------------

	process (clk,rstn)
	begin
		if rstn='0' then
			dma_control <=(others=>'0');
			dma_param <=(others=>'0');
			dma_req_param <=(others=>'0');
			dma_regin <=(others=>'0');
		   	dma_status3_r <='0';
		   	sg_state <= idle;
			dma_next_size <=(others=>'0');
			dma_left_size <=(others=>'0');
			next_page_needed <='0';
		elsif rising_edge (clk) then
			if srst='1' then
				dma_control <=(others=>'0');
				dma_param <=(others=>'0');
				dma_req_param <=(others=>'0');
				dma_regin <= (others=>'0');
				dma_status3_r <='0';
				sg_state <= idle;
				dma_next_size <=(others=>'0');
				dma_left_size <=(others=>'0');
				next_page_needed <='0';
			else
-- synthesis translate_off
				if app_dma_control(4 downto 0)/="00000" and sg_state/=idle then
					report "DMA_SG : WARNING : DMA REQUEST WHILE DMA BUSY" severity error;
				end if;
-- synthesis translate_on
				dma_status3_r <= dma_status(3);

				-- DMA Control register
				if app_dma_control(5)='1' and (sg_state=page_read or sg_state=wait_end_req) then
					dma_control <="100000";
				elsif sg_state= idle and app_sg_enable='0' then
					dma_control <=app_dma_control;
				elsif sg_state= next_page_req and app_dma_control(5)='0' then
					dma_control <="010111";
				elsif sg_state = send_req and app_dma_control(5)='0' then
					dma_control <="011111";
				else
					dma_control <="000000";
				end if;

				-- DMA PARAM register
				if sg_state=idle and app_sg_enable='0' then
					dma_param <=app_dma_param;
				elsif sg_state=send_req then
					dma_param <=dma_req_param;
				elsif sg_state=next_page_req then
					dma_param <=x"000600";
				end if;

				-- DMA PARAM register temporary
				if sg_state= idle and app_sg_enable='1' and app_dma_control(4)='1' then
					dma_req_param <=app_dma_param;
				end if;

				-- DMA_REGIN register
				if sg_state=idle and app_sg_enable='0' then
				    if app_dma_control(0)='1' and app_sg_enable='0' then
				        dma_regin(31 downto 0) <=app_dma_regin(31 downto 0);
				    end if;
				    if app_dma_control(1)='1' and app_sg_enable='0' then
				        dma_regin(63 downto 32) <=app_dma_regin(63 downto 32);
				    end if;
				    if app_dma_control(2)='1' and app_sg_enable='0' then
				        dma_regin(95 downto 64) <=app_dma_regin(95 downto 64);
				    end if;
				elsif sg_state= next_page_req then
					dma_regin(95 downto 0) <= x"00000014" & page_next_addr(63 downto 2) & "00";
				elsif sg_state = send_req then
					if SG_MODE = 0 and next_page_needed ='0' then
						-- Send DMA Request with current page size
						dma_regin(95 downto 0) <=conv_std_logic_vector (unsigned (dma_left_size),32) & page_addr(63 downto 2) & "00";
					else
						dma_regin(95 downto 0) <=conv_std_logic_vector (unsigned (page_size),32) & page_addr(63 downto 2) & "00";
					end if;

				end if;

				if sg_state=idle and app_dma_control(3)='1' then
                    dma_regin(127 downto 96) <=app_dma_regin(127 downto 96);
				elsif sg_state = wait_end_req and dma_status(3)='0' then
					dma_regin(127 downto 96)<=dma_regout(127 downto 96);
				end if;

				-- SG state machine
				case sg_state is
					when idle =>
						if app_sg_enable='1' and app_dma_control(4)='1' then
							-- Scatter-Gather Mode
							sg_state <=next_page_req;
						end if;

					--  Request to have a descriptor
					when next_page_req =>
						if app_dma_control(5)='1' then
							sg_state <= aborting;
						else
							sg_state <= page_read;
						end if;

					-- Wait to read the descriptor
					when page_read =>
						if app_dma_control(5)='1' then
							-- Abort
							sg_state <=aborting;
						elsif dma_status(3)='0' and dma_status3_r='1' then
						    if dma_status(2 downto 0)="000" then
							    -- Wait that DMA FSM comes back in idle.
							    sg_state <= send_req;
							else
							    -- Error, give up
							    sg_state <= aborting;
							end if;
						end if;

					--  DMA short
					when send_req =>
						if app_dma_control(5)= '1' then
							sg_state <= aborting;
						elsif (SG_MODE=0 and next_page_needed='0') or (SG_MODE=1 and page_end_chain='1') then
							sg_state <= ending;
						else
							sg_state <= wait_end_req;
						end if;

					-- Next descripor
					when wait_end_req =>
						if app_dma_control(5)='1' then
							sg_state <= aborting;
						elsif dma_status(3)='0' and dma_status3_r='1' then
							if SG_MODE = 1 then
								sg_state <=next_page_req;
							else
								if page_end_chain='1' then
-- synthesis translate_off
									report "DMA_SG : WARNING : DESCRIPTOR CHAIN END REACHED" severity warning;
-- synthesis translate_on
									-- Error: no space for DMA transfer
									sg_state <=idle;
								else
									sg_state <=next_page_req;
								end if;
							end if;
						end if;

					when ending =>
                        -- Wait for last DMA transfer to be over
						if dma_status(3)='0' and dma_status3_r='1' then
							sg_state <= idle;
						end if;
				    when aborting =>
                        -- Wait for DMA to be idle
						if dma_status(3)='0' then
							sg_state <= idle;
						end if;
				end case;

				-- Compute DMA next size
				dma_next_size <= unsigned (dma_left_size)-unsigned(page_size);

				if sg_load = update_cnt and SG_MODE = 0 then
					if unsigned(dma_left_size)> unsigned(page_size) then
						next_page_needed <='1';
					else
						next_page_needed <='0';
					end if;
				end if;

			    -- Store size, remember when size=0, means infinite loop
			    if SG_MODE = 0 then
					if sg_state=idle and app_dma_control(2)='1' then
						dma_left_size <=app_dma_regin(DMASIZE+63 downto 64);
			    	elsif sg_state=send_req and  next_page_needed='1' then
				 		dma_left_size <=dma_next_size;
					end if;
				end if;

			end if;
		end if;
	end process;


	-- Inhibit dma_wr when SG is reading a descriptor
	app_dma_wr <= '0' when sg_state=page_read else dma_wr;

	-- Indicate when module is idle and DMA channel is idle
	app_sg_idle <= '1' when sg_state=idle and dma_status(3)='0'
	               else '0';

	-- Always enough space to receive a descriptor
    dma_fifocnt(12) <= '1' when sg_state=next_page_req or sg_state=page_read
    			else app_dma_fifocnt(12);
    dma_fifocnt(11 downto 0) <= app_dma_fifocnt(11 downto 0);

end structural;
