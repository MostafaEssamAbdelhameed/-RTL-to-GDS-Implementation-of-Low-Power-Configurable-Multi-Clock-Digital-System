`timescale 1ns / 1ps


module stop_check (
    input stop_check_en,
    input sampled_bit,
    input finish,
    output reg stop_err,
    input rst,
    input clk
    );
        
    always@(posedge clk or negedge rst) begin
        if (!rst) begin
             stop_err <= 0;
        end    
        else if (stop_check_en && finish) begin
             stop_err <= (sampled_bit == 1) ? 0:1;
        end  
          
    end      
    
endmodule
