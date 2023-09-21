
`timescale 1 ps / 1 ps

module FIFO
   (empty,
    full,
    r_clk,
    r_data,
    r_inc,
    r_rst,
    w_clk,
    w_data,
    w_inc,
    w_rst);
  output empty;
  output full;
  output [7:0]r_data;
  input r_clk;
  input r_inc;
  input r_rst;
  input w_clk;
  input [7:0]w_data;
  input w_inc;
  input w_rst;

  wire [3:0]BIT_SYNC_0_sync;
  wire [3:0]BIT_SYNC_1_sync;
  wire [7:0]FIFO_MEM_0_r_data;
  wire [3:0]FIFO_RD_0_gray_r_ptr;
  wire [2:0]FIFO_RD_0_r_addr;
  wire FIFO_RD_0_r_empty;
  wire [3:0]FIFO_WR_0_gray_w_ptr;
  wire [2:0]FIFO_WR_0_w_addr;
  wire FIFO_WR_0_w_full;
  wire r_clk_0_1;
  wire r_inc_0_1;
  wire r_rst_0_1;
  wire w_clk_0_1;
  wire [7:0]w_data_0_1;
  wire w_inc_0_1;
  wire w_rst_0_1;

  assign empty = FIFO_RD_0_r_empty;
  assign full = FIFO_WR_0_w_full;
  assign r_clk_0_1 = r_clk;
  assign r_data[7:0] = FIFO_MEM_0_r_data;
  assign r_inc_0_1 = r_inc;
  assign r_rst_0_1 = r_rst;
  assign w_clk_0_1 = w_clk;
  assign w_data_0_1 = w_data[7:0];
  assign w_inc_0_1 = w_inc;
  assign w_rst_0_1 = w_rst;
  
BIT_SYNC_2 BIT_SYNC_0
       (.async(FIFO_RD_0_gray_r_ptr),
        .clk(w_clk_0_1),
        .rst(w_rst_0_1),
        .sync(BIT_SYNC_0_sync));
BIT_SYNC_2 BIT_SYNC_1
       (.async(FIFO_WR_0_gray_w_ptr),
        .clk(r_clk_0_1),
        .rst(r_rst_0_1),
        .sync(BIT_SYNC_1_sync));
FIFO_MEM FIFO_MEM_0
       (.r_addr(FIFO_RD_0_r_addr),
        .r_data(FIFO_MEM_0_r_data),
        .w_addr(FIFO_WR_0_w_addr),
        .w_clk(w_clk_0_1),
        .w_data(w_data_0_1),
        .w_full(FIFO_WR_0_w_full),
        .w_inc(w_inc_0_1),
        .w_rst(w_rst_0_1));
FIFO_RD FIFO_RD_0
       (.gray_r_ptr(FIFO_RD_0_gray_r_ptr),
        .gray_w_ptr(BIT_SYNC_1_sync),
        .r_addr(FIFO_RD_0_r_addr),
        .r_clk(r_clk_0_1),
        .r_empty(FIFO_RD_0_r_empty),
        .r_inc(r_inc_0_1),
        .r_rst(r_rst_0_1));
FIFO_WR FIFO_WR_0
       (.gray_r_ptr(BIT_SYNC_0_sync),
        .gray_w_ptr(FIFO_WR_0_gray_w_ptr),
        .w_addr(FIFO_WR_0_w_addr),
        .w_clk(w_clk_0_1),
        .w_full(FIFO_WR_0_w_full),
        .w_inc(w_inc_0_1),
        .w_rst(w_rst_0_1));
endmodule
