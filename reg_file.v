`timescale 1ns / 1ps

module reg_file #(parameter width=8 , parameter depth=4)(
    input [width - 1:0] data,
    input [depth - 1:0] address,
    input wr_en,
    input rd_en,
    input clk,
    input rst,
    output reg [width -1:0] data_out,
    output reg RdData_VLD,
    output wire   [width-1:0]  REG0,
    output wire   [width-1:0]  REG1,
    output wire   [width-1:0]  REG2,
    output wire   [width-1:0]  REG3
    );
    
    reg [width -1:0] memory [0:(2**depth)-1];
    integer i;
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            for(i=0 ; i<(2**depth) ; i = i+1) begin
                if(i==2)
                  memory[i] <= 'b100000_01 ;
		        else if (i==3) 
                  memory[i] <= 'b0010_0000 ;
                else
                  memory[i] <= 'b0 ;
            end
            data_out <= 0;
            RdData_VLD <= 0;
        end
        else begin
            if(wr_en && !rd_en) begin 
             memory[address] <= data;
            end
            else if(rd_en && !wr_en) begin
             data_out <= memory[address];
             RdData_VLD <= 1'b1 ;
            end
            else begin
                RdData_VLD <= 1'b0 ;
            end
        end
    end
    
    
assign REG0 = memory[0] ;
assign REG1 = memory[1] ;
assign REG2 = memory[2] ;
assign REG3 = memory[3] ; 

endmodule
