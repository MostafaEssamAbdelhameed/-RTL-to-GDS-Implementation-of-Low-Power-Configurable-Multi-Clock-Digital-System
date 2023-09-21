`timescale 1ns / 1ps

module parity_check(
    input [7:0] P_DATA,
    input par_check_en,
    input sampled_bit,
    input PAR_TYP,
    input PAR_EN,
    input finish,
    input clk,
    input rst,
    output reg par_err
    );
    
    reg par_calc;
    reg par_sampled;
    reg done1 , done2 ;
//////////////////////////////////////////////////////////////////////////    
////////////////////////////Calculate New Parity//////////////////////////    
//////////////////////////////////////////////////////////////////////////  
     
    always @(posedge clk or negedge rst) begin 
        if (!rst) begin 
          par_calc <= 0; 
          done1 <= 0; 
        end
        else if (par_check_en) begin
          case(PAR_TYP)
          1'b0 : begin                 
                  par_calc <= ^P_DATA  ;     // Even Parity
                  done1 <= 1;
                 end
          1'b1 : begin
                  par_calc <= ~^P_DATA ;     // Odd Parity
                  done1 <= 1;                  
                 end		
          endcase 
        end  
        else begin 
          par_calc <= 0; 
          done1 <= 0;
        end 
    end
    
//////////////////////////////////////////////////////////////////////////    
////////////////////////////Capture The sent Parity///////////////////////    
//////////////////////////////////////////////////////////////////////////  
      
    always @(posedge clk or negedge rst) begin 
        if (!rst) begin 
          par_sampled <= 0;
          done2 <= 0;
        end  
        else if (par_check_en && finish) begin
          par_sampled <= sampled_bit;
          done2 <= 1;
        end 
        else begin
          par_sampled <= 0;        
          done2 <= 0;
        end 
    end
    
//////////////////////////////////////////////////////////////////////////    
////////////////////////////Compare Parites///////////////////////////////    
//////////////////////////////////////////////////////////////////////////   
  
    always @(posedge clk or negedge rst) begin 
        if (!rst) begin 
            par_err <= 0;
        end   
        else if(!PAR_EN) begin
            par_err <= 0 ;
        end  
        else if (done1 == 1 && done2 == 1) begin
            par_err <= (par_calc == par_sampled)? 0:1;
        end
    end 
      
endmodule
