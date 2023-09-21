`timescale 1ns / 1ps

module TOP_rx(
    input RX_IN,
    input [5:0] prescale,
    input PAR_EN,
    input PAR_TYP,
    input clk,
    input rst,
    output [7:0] P_DATA,
    output data_valid,
    output stop_err,
    output parity_err
    );
    
wire data_samp_en_w , par_check_en_w , par_err_w , start_check_en_w ,start_glitch_w ;
wire stop_check_en_w,stop_err_w , deser_en_w , sampled_bit_w , enable_w , finish_w;
wire [3:0] bit_cnt_w ;
wire [5:0] edge_cnt_w;

assign stop_err = stop_err_w;
assign parity_err = par_err_w;


FSM_RX DUT0 (.RX_IN(RX_IN),
          .PAR_EN(PAR_EN),
          .par_err(par_err_w),
          .start_glitch(start_glitch_w),
          .stop_err(stop_err_w),
          .bit_cnt(bit_cnt_w),
          .par_check_en(par_check_en_w),
          .start_check_en(start_check_en_w),
          .stop_check_en(stop_check_en_w),
          .deser_en(deser_en_w),
          .data_valid(data_valid),
          .enable(enable_w),
          .data_samp_en(data_samp_en_w),
          .rst(rst),
          .clk(clk)
                );
                
edge_bit_counter    DUT1   ( .enable(enable_w),
                             .prescale(prescale),
                             .bit_cnt(bit_cnt_w),
                             .edge_cnt(edge_cnt_w),
                             .finish(finish_w),
                             .rst(rst),
                             .clk(clk)
                           );

data_sampling DUT2 (    .RX_IN(RX_IN),
                        .data_samp_en(data_samp_en_w),
                        .edge_cnt(edge_cnt_w),
                        .prescale(prescale),
                        .sampled_bit(sampled_bit_w),
                        .rst(rst),
                        .clk(clk)
                        );
                        
parity_check  DUT3 ( .P_DATA(P_DATA),
                         .par_check_en(par_check_en_w),
                         .sampled_bit(sampled_bit_w),
                         .PAR_TYP(PAR_TYP),
                         .PAR_EN(PAR_EN),
                         .par_err(par_err_w),
                         .finish(finish_w),
                         .rst(rst),
                         .clk(clk)
                        );    
                    
start_check DUT4      ( .start_check_en(start_check_en_w),
                        .sampled_bit(sampled_bit_w),
                        .start_glitch(start_glitch_w),
                        .finish(finish_w),
                        .rst(rst),
                        .clk(clk)
                       );   
                       
stop_check  DUT5     (  .stop_check_en(stop_check_en_w),
                        .sampled_bit(sampled_bit_w),
                        .stop_err(stop_err_w),
                        .finish(finish_w),
                        .rst(rst),
                        .clk(clk)
                        );    
                        
deserializer      DUT6 (    .sampled_bit(sampled_bit_w),
                            .finish(finish_w),
                            .deser_en(deser_en_w),
                            .P_DATA(P_DATA),
                            .rst(rst),
                            .clk(clk)
                        );                           
endmodule                                                   
                           
                

