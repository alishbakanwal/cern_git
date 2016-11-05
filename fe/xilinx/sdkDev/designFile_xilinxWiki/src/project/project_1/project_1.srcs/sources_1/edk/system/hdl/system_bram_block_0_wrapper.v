//-----------------------------------------------------------------------------
// system_bram_block_0_wrapper.v
//-----------------------------------------------------------------------------

(* x_core_info = "bram_block_0_elaborate_v1_00_a" *)
(* keep_hierarchy = "yes" *)
module system_bram_block_0_wrapper
  (
    BRAM_Rst_A,
    BRAM_Clk_A,
    BRAM_EN_A,
    BRAM_WEN_A,
    BRAM_Addr_A,
    BRAM_Din_A,
    BRAM_Dout_A,
    BRAM_Rst_B,
    BRAM_Clk_B,
    BRAM_EN_B,
    BRAM_WEN_B,
    BRAM_Addr_B,
    BRAM_Din_B,
    BRAM_Dout_B
  );
  input BRAM_Rst_A;
  input BRAM_Clk_A;
  input BRAM_EN_A;
  input [0:4] BRAM_WEN_A;
  input [0:31] BRAM_Addr_A;
  output [0:39] BRAM_Din_A;
  input [0:39] BRAM_Dout_A;
  input BRAM_Rst_B;
  input BRAM_Clk_B;
  input BRAM_EN_B;
  input [0:4] BRAM_WEN_B;
  input [0:31] BRAM_Addr_B;
  output [0:39] BRAM_Din_B;
  input [0:39] BRAM_Dout_B;

  bram_block_0_elaborate
    #(
      .C_MEMSIZE ( 'h40000 ),
      .C_PORT_DWIDTH ( 40 ),
      .C_PORT_AWIDTH ( 32 ),
      .C_NUM_WE ( 5 ),
      .C_FAMILY ( "zynq" )
    )
    bram_block_0 (
      .BRAM_Rst_A ( BRAM_Rst_A ),
      .BRAM_Clk_A ( BRAM_Clk_A ),
      .BRAM_EN_A ( BRAM_EN_A ),
      .BRAM_WEN_A ( BRAM_WEN_A ),
      .BRAM_Addr_A ( BRAM_Addr_A ),
      .BRAM_Din_A ( BRAM_Din_A ),
      .BRAM_Dout_A ( BRAM_Dout_A ),
      .BRAM_Rst_B ( BRAM_Rst_B ),
      .BRAM_Clk_B ( BRAM_Clk_B ),
      .BRAM_EN_B ( BRAM_EN_B ),
      .BRAM_WEN_B ( BRAM_WEN_B ),
      .BRAM_Addr_B ( BRAM_Addr_B ),
      .BRAM_Din_B ( BRAM_Din_B ),
      .BRAM_Dout_B ( BRAM_Dout_B )
    );

endmodule

