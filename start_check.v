`timescale 1ns / 1ps


module start_check (
    input start_check_en,
    input sampled_bit,
    input finish,
    output reg start_glitch,
    input rst,
    input clk
    );
    
    
    always@(posedge clk or negedge rst) begin
        if (!rst) begin
            start_glitch <= 0;
        end
        else if (start_check_en && finish) begin
                start_glitch <= (sampled_bit == 0) ? 0:1;                
        end
    end 
    
    
endmodule
