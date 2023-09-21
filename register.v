`timescale 1ns / 1ps

module register #(parameter BUS_WIDTH = 1) (
input [BUS_WIDTH - 1 : 0] async ,
input clk , rst ,
output reg [BUS_WIDTH - 1 : 0] sync 
);

always@(posedge clk or negedge rst) begin
	if(!rst) begin
		sync <= 0; 
	end
	else begin
		sync <= async ;
	end
end

endmodule
