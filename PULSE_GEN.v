`timescale 1ns / 1ps

module PULSE_GEN #(parameter BUS_WIDTH = 8)(
    input bus_enable,
    input [BUS_WIDTH - 1 :0] Unsync_bus,
    output reg [BUS_WIDTH - 1 :0] sync_bus,
    output reg enable_pulse,
    input clk,
    input rst
    );
    reg q;
    wire sel;
    wire [BUS_WIDTH - 1 :0] bus;
    
    assign bus = (sel==1)? Unsync_bus : sync_bus;
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
            sync_bus <= 0;
        end
        else begin
            enable_pulse <= sel ;
            sync_bus <= bus;         
        end    
    end 
    
endmodule
