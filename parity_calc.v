`timescale 1ns / 1ps

module parity_calc(
    input [7:0] P_DATA,
    input PAR_TYP,
    input par_en,
    input clk,
    input rst,
    output reg PAR_BIT
    );
   reg [7:0] data;

   always @(posedge clk or negedge rst) begin 
    if(!rst) begin
        data <= 0;
    end
    else if (!par_en) begin
        data <= P_DATA ;
    end
  end
  
   always @(posedge clk or negedge rst) begin 
    if(!rst) begin
        PAR_BIT <= 0;
    end
    else if (par_en) begin
	  case(PAR_TYP)
	  1'b0 : begin                 
	          PAR_BIT <= ^data  ;     // Even Parity
	         end
	  1'b1 : begin
	          PAR_BIT <= ~^data ;     // Odd Parity
	         end		
	  endcase         
    end   
   end

endmodule
