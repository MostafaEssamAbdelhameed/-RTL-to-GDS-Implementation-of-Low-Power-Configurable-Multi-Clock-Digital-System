`timescale 1ns / 1ps

module FIFO_WR #(parameter depth = 8)(
    input w_inc,
    input w_rst,
    input w_clk,
    input [$clog2(depth): 0] gray_r_ptr,
    output [$clog2(depth) - 1 :0] w_addr,
    output reg [$clog2(depth) :0] gray_w_ptr,
    output w_full
    );
    
    reg [$clog2(depth) :0] w_ptr ;
    assign w_addr = w_ptr[$clog2(depth) - 1:0] ;
    assign w_full = ( (gray_w_ptr[$clog2(depth)] != gray_r_ptr [$clog2(depth)]) &&
                      (gray_w_ptr[$clog2(depth) - 1] != gray_r_ptr[$clog2(depth) - 1]) && 
                      (gray_w_ptr[$clog2(depth) - 2:0] == gray_r_ptr[$clog2(depth) - 2:0])
                    );
    
    always @(posedge w_clk or negedge w_rst) begin
        if(!w_rst) begin
            w_ptr <= 0;
        end
        else if (w_inc && !w_full) begin
            w_ptr <= w_ptr + 1 ;
        end
    end
    
    always @(posedge w_clk or negedge w_rst) begin
     if(!w_rst)
        begin
          gray_w_ptr<=0;
        end
     else begin
          case (w_ptr)
            4'b0000: gray_w_ptr <= 4'b0000;
            4'b0001: gray_w_ptr <= 4'b0001;
            4'b0010: gray_w_ptr <= 4'b0011;
            4'b0011: gray_w_ptr <= 4'b0010;
            4'b0100: gray_w_ptr <= 4'b0110;
            4'b0101: gray_w_ptr <= 4'b0111;
            4'b0110: gray_w_ptr <= 4'b0101;
            4'b0111: gray_w_ptr <= 4'b0100;
            4'b1000: gray_w_ptr <= 4'b1100;
            4'b1001: gray_w_ptr <= 4'b1101;
            4'b1010: gray_w_ptr <= 4'b1111;
            4'b1011: gray_w_ptr <= 4'b1110;
            4'b1100: gray_w_ptr <= 4'b1010;
            4'b1101: gray_w_ptr <= 4'b1011;
            4'b1110: gray_w_ptr <= 4'b1001;
            4'b1111: gray_w_ptr <= 4'b1000;
        endcase
       end  
    end
endmodule
