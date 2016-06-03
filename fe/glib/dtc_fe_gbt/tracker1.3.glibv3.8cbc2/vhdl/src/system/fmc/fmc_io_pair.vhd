library ieee;
use ieee.std_logic_1164.all;
library unisim;
use unisim.vcomponents.all;


entity fmc_io_pair is
    generic
    (
    	standard 		: string := "cmos";
    	direction_p		: string := "in__";
    	direction_n		: string := "in__"
    );     
    port
    (
       io_p				: inout 	std_logic;
       io_n 			: inout 	std_logic;
       lvds_i			: out		std_logic;
       lvds_o			: in		std_logic;
       lvds_oe_l		: in 		std_logic;
       cmos_p_i		: out		std_logic;
       cmos_p_o		: in		std_logic;
       cmos_p_oe_l	: in 		std_logic;
       cmos_n_i		: out		std_logic;
		 cmos_n_o		: in		std_logic;
		 cmos_n_oe_l	: in 		std_logic
       
	);    
end fmc_io_pair;

architecture fmc_io_pair_arch of fmc_io_pair is

	--new
	signal lvds_o_new : std_logic:='0';

begin

	--========================================================--
   -- LVDS
	--========================================================--
   L1: if (standard="lvds") and (direction_p = "in__") generate
   begin
		i_lvds:ibufds
	  	generic map
	  	(
	    	capacitance 		=> "dont_care",
	    	diff_term 			=> true,
	    	ibuf_delay_value 	=> "0",
	    	ibuf_low_pwr 		=> true,
	    	ifd_delay_value 	=> "auto",
	    	iostandard 			=> "lvds_25"
	    )	
 	 	port map 
 	 	(
     		i 						=> io_p,
     		ib 					=> io_n,
  			o 						=> lvds_i
     	);
   end generate;
	--========================================================--
   L2: if (standard="lvds") and (direction_p = "out_") generate
   begin
		o_lvds:obuftds 
		generic map
	  	(
     		capacitance 		=> "dont_care",
	      iostandard  		=> "lvds_25"
	   )
		port map
		(
	    	i 						=> lvds_o,
	    	t 						=> lvds_oe_l,
	    	o  					=> io_p,
	    	ob 					=> io_n
	    );
	end generate;
	

	
	--========================================================--
   L3: if (standard="lvds") and (direction_p = "i_o_") generate
   begin
--		--new
--		process(lvds_oe_l, lvds_o)
--		begin
--			if lvds_oe_l = '1' then --case no OUT
--				lvds_o_new <= '1';
--			else							--case OUT
--				lvds_o_new <= lvds_o;
--			end if;
--		end process;
		
		io_lvds:iobufds
		generic map
	  	(
	    	capacitance 		=> "dont_care",
	    	diff_term 			=> true,
	    	--ibuf_delay_value 	=> "0",
	    	--ibuf_low_pwr 		=> true,
	    	iostandard 			=> "blvds_25"			
	   )
		port map
		(
	    	i 						=> lvds_o, --lvds_o_new, --lvds_o,
	    	t 						=> lvds_oe_l,
			o						=> lvds_i,
	    	io  					=> io_p,
	    	iob 					=> io_n
	    );
	end generate;	
	--========================================================--
   L4: if (standard="lvds") and (direction_p = "ckin") generate
   begin
		i_lvds:ibufgds
	  	generic map
	  	(
	    	capacitance 		=> "dont_care",
	    	diff_term 			=> true,
	    	ibuf_delay_value 	=> "0",
	    	ibuf_low_pwr 		=> true,
	    	iostandard 			=> "lvds_25"
	    )	
 	 	port map 
 	 	(
     		i 						=> io_p,
     		ib 					=> io_n,
  			o 						=> lvds_i
     	);
   end generate;
	--========================================================--
   -- CMOS P
	--========================================================--
   P1: if (standard="cmos") and (direction_p = "in__") generate
   begin
		i_cmos_p:ibuf 
		generic map
		(    
        	capacitance 		=> "dont_care",
    		ibuf_delay_value 	=> "0",
    		ibuf_low_pwr 		=> true,
    		ifd_delay_value  	=> "auto",
    		iostandard  		=> "lvcmos25"
    	)
  		port map
  		(
    		i 						=> io_p,
    		o 						=> cmos_p_i
    	);
	end generate;
	--========================================================--
   P2: if (standard="cmos") and (direction_p = "out_") generate
   begin
		o_cmos_p:obuft 
  		generic map
  		(
			capacitance 		=> "dont_care",
		    drive       		=> 12,
		    iostandard  		=> "lvcmos25",
		    slew        		=> "slow"
		)
		port map
		(
    		i 						=> cmos_p_o, 
    		t 						=> cmos_p_oe_l,
    		o 						=> io_p
    	);
   end generate;
	--========================================================--
   P3: if (standard="cmos") and (direction_p = "i_o_") generate
   begin
		io_cmos_p:iobuf 	
		generic map 
		(
			capacitance 		=> "dont_care", 
			drive 				=> 12, 
			ibuf_delay_value 	=> "0", 
			ibuf_low_pwr 		=> true, 
			ifd_delay_value 	=> "auto", 
			iostandard			=> "lvcmos25", 
			slew 					=> "slow"
		)
		port map 
		(
			i 						=> cmos_p_o, 
			t 						=> cmos_p_oe_l, 
			o 						=> cmos_p_i, 
			io 					=> io_p
		);
	end generate;
	--========================================================--
   P4: if (standard="cmos") and (direction_p = "ckin") generate
   begin
		i_cmos_p:ibufg 
		generic map
		(    
        	capacitance 		=> "dont_care",
    		ibuf_delay_value 	=> "0",
    		ibuf_low_pwr 		=> true,
    		iostandard  		=> "lvcmos25"
    	)
  		port map
  		(
    		i 						=> io_p,
    		o 						=> cmos_p_i
    	);
	end generate;
	--========================================================--
   P5: if (standard="cmos") and (direction_p = "in_x") generate
   begin
   	cmos_p_i <= io_p;
   end generate;
	--========================================================--
   P6: if (standard="cmos") and (direction_p = "outx") generate
   begin
   	io_p <= cmos_p_o;
   end generate;
	--========================================================--
   -- CMOS N
	--========================================================--
   N1: if (standard="cmos") and (direction_n = "in__") generate
   begin
		i_cmos_n:ibuf 
		generic map
		(    
        	capacitance 		=> "dont_care",
    		ibuf_delay_value 	=> "0",
    		ibuf_low_pwr 		=> true,
    		ifd_delay_value  	=> "auto",
    		iostandard  		=> "lvcmos25"
    	)
  		port map
  		(
    		i 						=> io_n,
    		o 						=> cmos_n_i
    	);
	end generate;
	--========================================================--
   N2: if (standard="cmos") and (direction_n = "out_") generate
   begin
		o_cmos_n:obuft 
  		generic map
  		(
			capacitance 		=> "dont_care",
		    drive       		=> 12,
		    iostandard  		=> "lvcmos25",
		    slew        		=> "slow"
		)
		port map
		(
    		i 						=> cmos_n_o, 
    		t 						=> cmos_n_oe_l,
    		o 						=> io_n
    	);
   end generate;
	--========================================================--
   N3: if (standard="cmos") and (direction_n = "i_o_") generate
   begin
		io_cmos_p:iobuf 	
		generic map 
		(
			capacitance 		=> "dont_care", 
			drive 				=> 12, 
			ibuf_delay_value 	=> "0", 
			ibuf_low_pwr 		=> true, 
			ifd_delay_value 	=> "auto", 
			iostandard			=> "lvcmos25", 
			slew 					=> "slow"
		)
		port map 
		(
			i 						=> cmos_n_o, 
			t 						=> cmos_n_oe_l, 
			o 						=> cmos_n_i, 
			io 					=> io_n
		);
	end generate;
	--========================================================--
--    N4: if (standard="cmos") and (direction_n = "ckin") generate
--    begin
--		i_cmos_n:ibufg 
--		generic map
--		(    
--        	capacitance 		=> "dont_care",
--    		ibuf_delay_value 	=> "0",
--    		ibuf_low_pwr 		=> true,
--    		iostandard  		=> "lvcmos25"
--    	)
--  		port map
--  		(
--    		i 						=> io_n,
--    		o 						=> cmos_n_i
--    	);
--	 end generate;
	--========================================================--
   N5: if (standard="cmos") and (direction_n = "in_x") generate
   begin
    	cmos_n_i <= io_n;
	end generate;
	--========================================================--
   N6: if (standard="cmos") and (direction_n = "outx") generate
   begin
    	io_n <= cmos_n_o;
	end generate;
	--========================================================--

end fmc_io_pair_arch;