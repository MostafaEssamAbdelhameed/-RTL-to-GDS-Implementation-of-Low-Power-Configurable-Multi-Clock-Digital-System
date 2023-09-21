`timescale 1ns / 1ps

module edge_bit_counter (
    input enable,
    input[5:0] prescale,
    output reg [3:0] bit_cnt,
    output reg [5:0] edge_cnt,
    output reg finish,
    input clk,
    input rst
    );
    reg flag;
    //assign finish = (edge_cnt == (prescale - 1)) ? 1:0;
    //assign finish_s = (edge_cnt == (prescale - 2)) ? 1:0;
    
    always @(*) begin
        if(!rst) begin
            finish = 0;
        end
        else if (flag == 0 && edge_cnt == (prescale - 2)) begin
            finish = 1;
        end
        else if  (flag == 1 && edge_cnt == (prescale - 1)) begin
            finish = 1;        
        end
        else begin
            finish = 0;
        end
        
    end
    always@(posedge clk or negedge rst) begin 
        if(!rst) begin
            bit_cnt <= 0;
            edge_cnt <= 0;
            flag <=0;
        end 
        else if (enable) begin
            edge_cnt <= edge_cnt + 1 ;
            if (edge_cnt == prescale - 2 && flag == 0) begin
                edge_cnt <= 0;
                bit_cnt <= bit_cnt +1;
                flag <= 1;
            end
            else if (edge_cnt == prescale -1 && flag == 1) begin
                edge_cnt <= 0;
                bit_cnt <= bit_cnt +1;
            end
        end
        else if (!enable) begin 
            bit_cnt <= 0;
            edge_cnt <= 0;
            flag <=0;
        end     
    end
    
endmodule
