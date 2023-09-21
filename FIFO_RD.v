`timescale 1ns / 1ps


module FIFO_RD #(parameter depth = 8)(
    input r_inc,
    input r_rst,
    input r_clk,
    input [$clog2(depth):0] gray_w_ptr,
    output [$clog2(depth) - 1:0] r_addr,
    output reg [$clog2(depth):0] gray_r_ptr,
    output r_empty
    );
    
    reg [$clog2(depth):0] r_ptr  ;
    assign r_addr = r_ptr[$clog2(depth) - 1:0] ;
    assign r_empty = (gray_w_ptr == gray_r_ptr);
    
    always @(posedge r_clk or negedge r_rst) begin
        if(!r_rst) begin 
            r_ptr <= 0;
        end
        else if (r_inc && !r_empty) begin
            r_ptr <= r_ptr + 1 ;   
        end
    end
    
    always @(posedge r_clk or negedge r_rst) begin
        if(!r_rst) begin 
            gray_r_ptr <= 0 ;
        end
        else begin
            case (r_ptr)
                4'b0000: gray_r_ptr <= 4'b0000;
                4'b0001: gray_r_ptr <= 4'b0001;
                4'b0010: gray_r_ptr <= 4'b0011;
                4'b0011: gray_r_ptr <= 4'b0010;
                4'b0100: gray_r_ptr <= 4'b0110;
                4'b0101: gray_r_ptr <= 4'b0111;
                4'b0110: gray_r_ptr <= 4'b0101;
                4'b0111: gray_r_ptr <= 4'b0100;
                4'b1000: gray_r_ptr <= 4'b1100;
                4'b1001: gray_r_ptr <= 4'b1101;
                4'b1010: gray_r_ptr <= 4'b1111;
                4'b1011: gray_r_ptr <= 4'b1110;
                4'b1100: gray_r_ptr <= 4'b1010;
                4'b1101: gray_r_ptr <= 4'b1011;
                4'b1110: gray_r_ptr <= 4'b1001;
                4'b1111: gray_r_ptr <= 4'b1000;
           endcase
         end
    end

endmodule
