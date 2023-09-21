`timescale 1ns / 1ps

module BIT_SYNC #(parameter BUS_WIDTH = 1 , NUM_STAGES = 2) (
	input [BUS_WIDTH - 1 : 0 ] async ,
	input clk,
	input rst,
	output [BUS_WIDTH - 1 : 0 ] sync
);


wire [BUS_WIDTH - 1:0] link [NUM_STAGES - 1 : 0];

register #(.BUS_WIDTH(BUS_WIDTH)) U0 (async , clk , rst , link [0]);

genvar i  ;

for (i=1 ; i < NUM_STAGES - 1; i=i+1) begin

 register #(.BUS_WIDTH(BUS_WIDTH)) U (link[i-1] , clk , rst , link[i] );
 
end
register #(.BUS_WIDTH(BUS_WIDTH)) U (link[NUM_STAGES - 2] , clk , rst , sync );

endmodule
