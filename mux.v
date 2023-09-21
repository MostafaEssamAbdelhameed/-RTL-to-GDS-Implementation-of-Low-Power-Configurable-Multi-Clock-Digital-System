`timescale 1ns / 1ps

module mux (
    input in1,
    input in2,
    input in3,
    input in4,
    input [1:0] sel,
    input clk,
    input rst,
    output reg out
    );
    reg out_c;
    
    always @(*) begin
        case(sel)
            0: out_c = in1;
            1: out_c = in2;
            2: out_c = in3;
            3: out_c = in4;
       endcase
    end

//register mux output
always @ (posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    out <= 'b0 ;
   end
  else
   begin
    out <= out_c ;
   end 
 end 
endmodule
