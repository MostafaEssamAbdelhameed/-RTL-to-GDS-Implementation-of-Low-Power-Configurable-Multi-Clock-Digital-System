`timescale 1ns / 1ps

module TX_top(
    input [7:0] P_DATA,
    input data_valid,
    input PAR_EN,
    input PAR_TYP,
    input clk,
    input rst,
    output TX_OUT,
    output busy
    );
    
wire par_load , ser_en , ser_done , PAR_BIT , ser_data;
wire [1:0] mux_sel;


parity_calc DUT0 (  .P_DATA(P_DATA),
                    .PAR_TYP(PAR_TYP),
                    .par_en(par_load),
                    .clk(clk),
                    .rst(rst),
                    .PAR_BIT(PAR_BIT)
                    );
                    
serializer DUT1 (   .P_DATA(P_DATA),
                    .ser_en(ser_en),
                    .clk(clk),
                    .rst(rst),
                    .ser_done(ser_done),
                    .ser_data(ser_data)
                    );
                    
FSM_TX DUT3        (   .ser_done(ser_done),
                    .PAR_EN(PAR_EN),
                    .data_valid(data_valid),
                    .clk(clk),
                    .rst(rst),
                    .ser_en(ser_en),
                    .mux_sel(mux_sel),
                    .par_load(par_load),
                    .busy(busy)
                    );
                    
mux DUT4         (  .in1(1'b0),
                    .in2(1'b1),
                    .in3(ser_data),
                    .in4(PAR_BIT),
                    .clk(clk),
                    .rst(rst),
                    .sel(mux_sel),
                    .out(TX_OUT)
                    );                                      

endmodule
