`timescale 1ns / 1ps


module deserializer (
    input sampled_bit,
    input deser_en,
    input finish,
    output reg [7:0] P_DATA,
    input clk,
    input rst
    );
    
    reg [7:0] register ;
    reg [3:0] i;
    
    always@(posedge clk or negedge rst ) begin
        if(!rst) begin
            register <= 0;
            i<=0;
        end 
        else if (deser_en && finish && i!=8 ) begin
            register [i] <= sampled_bit;
            i <= i+1;
                
        end
        else if (!deser_en) begin
            i<=0;
        end
    end
    
    always@(posedge clk or negedge rst) begin 
        if(!rst) begin
            P_DATA <= 0;
        end
        else if (i == 8) begin
            P_DATA <= register;
        end    
    end 
    
endmodule
