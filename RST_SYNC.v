`timescale 1ns / 1ps

module RST_SYNC #(NUM_STAGES = 2) (
	input clk,
	input rst,
	output sync_rst
);


wire link [NUM_STAGES - 1 : 0];

register  U0 (1'b1 , clk , rst , link [0]);

genvar i  ;

for (i=1 ; i < NUM_STAGES - 1; i=i+1) begin

 register U (link[i-1] , clk , rst , link[i] );
 
end
register  U (link[NUM_STAGES - 2] , clk , rst , sync_rst );

endmodule
