`timescale 1ns / 1ps

module FIFO_MEM #(parameter DATA_WIDTH = 8 , depth = 8) (
    input [DATA_WIDTH - 1:0] w_data,
    input [$clog2(depth) - 1:0] w_addr,
    input [$clog2(depth) - 1:0] r_addr,
    input w_full,
    input w_inc,
    input w_clk,
    input w_rst,
    output[DATA_WIDTH -1:0] r_data
    );
    
    wire w_en ;
    assign w_en = !w_full & w_inc ;
    
    reg [DATA_WIDTH - 1 : 0] mem [depth -1:0];
    
    reg [$clog2(depth):0] i;
    
    always @(posedge w_clk or negedge w_rst) begin
        if(!w_rst) begin
            for (i=0 ; i<depth ; i=i+1) begin
                mem[i] = {DATA_WIDTH{1'b0}};
            end
        end
        else if (w_en) begin
            mem[w_addr] = w_data;
        end
    end
    
    assign r_data = mem[r_addr];
endmodule
