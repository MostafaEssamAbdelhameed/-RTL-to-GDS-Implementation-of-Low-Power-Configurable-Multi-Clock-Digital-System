
`timescale 1 ps / 1 ps

module System_Top
   (RX_IN,
    TX_OUT,
    ref_clk,
    rst,
    uart_clk,
    stop_err,
    par_err);
	
  input RX_IN;
  output TX_OUT;
  output stop_err;
  output par_err;
  input ref_clk;
  input rst;
  input uart_clk;

  wire [15:0]ALU_0_ALU_OUT;
  wire ALU_0_OUT_VALID;
  wire CLK_GATE_0_GATED_CLK;
  wire ClkDiv_0_o_div_clk;
  wire ClkDiv_1_o_div_clk;
  wire DATA_SYNC_0_enable_pulse;
  wire [7:0]DATA_SYNC_0_sync_bus;
  wire FIFO_0_empty;
  wire FIFO_0_full;
  wire [7:0]FIFO_0_r_data;
  wire PULSE_GEN_2_0_enable_pulse;
  wire RST_SYNC_0_sync_rst;
  wire RST_SYNC_1_sync_rst;
  wire RX_IN_0_1;
  wire SYS_CTRL_0_ALU_EN;
  wire [3:0]SYS_CTRL_0_ALU_FUNC;
  wire SYS_CTRL_0_CLK_EN;
  wire SYS_CTRL_0_RdEn;
  wire [7:0]SYS_CTRL_0_TX_P_DATA;
  wire SYS_CTRL_0_WR_INC;
  wire [7:0]SYS_CTRL_0_WrData;
  wire SYS_CTRL_0_WrEn;
  wire [3:0]SYS_CTRL_0_address;
  wire SYS_CTRL_0_clk_div_en;
  wire [7:0]TOP_rx_0_P_DATA;
  wire TOP_rx_0_data_valid;
  wire TX_top_0_TX_OUT;
  wire TX_top_0_busy;
  wire clk_0_1;
  wire i_ref_clk_0_1;
  wire inv_0_d;
  wire [2:0]mux_prescale_0_ratio;
  wire [7:0]reg_file_0_REG0;
  wire [7:0]reg_file_0_REG1;
  wire [7:0]reg_file_0_REG2;
  wire [7:0]reg_file_0_REG3;
  wire reg_file_0_RdData_VLD;
  wire [7:0]reg_file_0_data_out;
  wire rst_0_1;

  assign RX_IN_0_1 = RX_IN;
  assign TX_OUT = TX_top_0_TX_OUT;
  assign clk_0_1 = ref_clk;
  assign i_ref_clk_0_1 = uart_clk;
  assign rst_0_1 = rst;
  ALU ALU_0
       (.A(reg_file_0_REG0),
        .ALU_FUN(SYS_CTRL_0_ALU_FUNC),
        .ALU_OUT(ALU_0_ALU_OUT),
        .B(reg_file_0_REG1),
        .CLK(CLK_GATE_0_GATED_CLK),
        .EN(SYS_CTRL_0_ALU_EN),
        .OUT_VALID(ALU_0_OUT_VALID),
        .RST(RST_SYNC_0_sync_rst));
  CLK_GATE CLK_GATE_0
       (.CLK(clk_0_1),
        .CLK_EN(SYS_CTRL_0_CLK_EN),
        .GATED_CLK(CLK_GATE_0_GATED_CLK));
  ClkDiv ClkDiv_0
       (.i_clk_en(SYS_CTRL_0_clk_div_en),
        .i_div_ratio({1'b0,1'b0,1'b0,mux_prescale_0_ratio}),
        .i_ref_clk(i_ref_clk_0_1),
        .i_rst_n(RST_SYNC_1_sync_rst),
        .o_div_clk(ClkDiv_0_o_div_clk));
  ClkDiv ClkDiv_1
       (.i_clk_en(SYS_CTRL_0_clk_div_en),
        .i_div_ratio(reg_file_0_REG3[5:0]),
        .i_ref_clk(i_ref_clk_0_1),
        .i_rst_n(RST_SYNC_1_sync_rst),
        .o_div_clk(ClkDiv_1_o_div_clk));
  DATA_SYNC DATA_SYNC_0
       (.Unsync_bus(TOP_rx_0_P_DATA),
        .bus_enable(TOP_rx_0_data_valid),
        .clk(clk_0_1),
        .enable_pulse(DATA_SYNC_0_enable_pulse),
        .rst(RST_SYNC_0_sync_rst),
        .sync_bus(DATA_SYNC_0_sync_bus));
  FIFO FIFO_0
       (.empty(FIFO_0_empty),
        .full(FIFO_0_full),
        .r_clk(ClkDiv_1_o_div_clk),
        .r_data(FIFO_0_r_data),
        .r_inc(PULSE_GEN_2_0_enable_pulse),
        .r_rst(RST_SYNC_1_sync_rst),
        .w_clk(clk_0_1),
        .w_data(SYS_CTRL_0_TX_P_DATA),
        .w_inc(SYS_CTRL_0_WR_INC),
        .w_rst(RST_SYNC_0_sync_rst));
  PULSE_GEN_2 PULSE_GEN_2_0
       (.bus_enable(TX_top_0_busy),
        .clk(ClkDiv_1_o_div_clk),
        .enable_pulse(PULSE_GEN_2_0_enable_pulse),
        .rst(RST_SYNC_1_sync_rst));
  RST_SYNC RST_SYNC_0
       (.clk(clk_0_1),
        .rst(rst_0_1),
        .sync_rst(RST_SYNC_0_sync_rst));
  RST_SYNC RST_SYNC_1
       (.clk(i_ref_clk_0_1),
        .rst(rst_0_1),
        .sync_rst(RST_SYNC_1_sync_rst));
  SYS_CTRL SYS_CTRL_0
       (.ALU_EN(SYS_CTRL_0_ALU_EN),
        .ALU_FUNC(SYS_CTRL_0_ALU_FUNC),
        .ALU_OUT(ALU_0_ALU_OUT),
        .CLK_EN(SYS_CTRL_0_CLK_EN),
        .FIFO_FULL(FIFO_0_full),
        .OUT_Valid(ALU_0_OUT_VALID),
        .RX_D_VLD(DATA_SYNC_0_enable_pulse),
        .RX_P_DATA(DATA_SYNC_0_sync_bus),
        .RdData(reg_file_0_data_out),
        .RdData_Valid(reg_file_0_RdData_VLD),
        .RdEn(SYS_CTRL_0_RdEn),
        .TX_P_DATA(SYS_CTRL_0_TX_P_DATA),
        .WR_INC(SYS_CTRL_0_WR_INC),
        .WrData(SYS_CTRL_0_WrData),
        .WrEn(SYS_CTRL_0_WrEn),
        .address(SYS_CTRL_0_address),
        .clk(clk_0_1),
        .clk_div_en(SYS_CTRL_0_clk_div_en),
        .rst(RST_SYNC_0_sync_rst));
  TOP_rx TOP_rx_0
       (.PAR_EN(reg_file_0_REG2[0]),
        .PAR_TYP(reg_file_0_REG2[1]),
        .P_DATA(TOP_rx_0_P_DATA),
        .RX_IN(RX_IN_0_1),
        .clk(ClkDiv_0_o_div_clk),
        .data_valid(TOP_rx_0_data_valid),
        .prescale(reg_file_0_REG2[7:2]),
        .rst(RST_SYNC_1_sync_rst),
        .stop_err(stop_err),
        .parity_err(par_err));
  TX_top TX_top_0
       (.PAR_EN(reg_file_0_REG2[0]),
        .PAR_TYP(reg_file_0_REG2[1]),
        .P_DATA(FIFO_0_r_data),
        .TX_OUT(TX_top_0_TX_OUT),
        .busy(TX_top_0_busy),
        .clk(ClkDiv_1_o_div_clk),
        .data_valid(inv_0_d),
        .rst(RST_SYNC_1_sync_rst));
  inv inv_0
       (.d(inv_0_d),
        .q(FIFO_0_empty));
  mux_prescale mux_prescale_0
       (.ratio(mux_prescale_0_ratio),
        .sel(reg_file_0_REG2[7:2]));
  reg_file reg_file_0
       (.REG0(reg_file_0_REG0),
        .REG1(reg_file_0_REG1),
        .REG2(reg_file_0_REG2),
        .REG3(reg_file_0_REG3),
        .RdData_VLD(reg_file_0_RdData_VLD),
        .address(SYS_CTRL_0_address),
        .clk(clk_0_1),
        .data(SYS_CTRL_0_WrData),
        .data_out(reg_file_0_data_out),
        .rd_en(SYS_CTRL_0_RdEn),
        .rst(RST_SYNC_0_sync_rst),
        .wr_en(SYS_CTRL_0_WrEn));
		
endmodule
