`timescale 1ns / 1ps

module PULSE_GEN_2 #(parameter BUS_WIDTH = 8)(
    input bus_enable,
    output reg enable_pulse,
    input clk,
    input rst
    );
    reg q;
    wire sel;    
    assign sel = bus_enable & !q ;
    
    always@(posedge clk or negedge rst) begin
        if(!rst) begin
            q <= 0;
        end
        else begin
            q <= bus_enable;
        end
    end
    
    
    always@(posedge clk or negedge rst) begin
        if(!rst) begin
            enable_pulse <= 0;
        end
        else begin
            enable_pulse <= sel ;
        end    
    end 
    
endmodule
