`timescale 1ns / 1ps

module data_sampling (
    input RX_IN,
    input data_samp_en,
    input [5:0] edge_cnt,
    input [5:0] prescale,
    output reg sampled_bit,
    input clk,
    input rst
    );
    wire [4:0] half ;
    reg done;
    reg [2:0] values;
    
    assign half = (prescale >> 1);
    
    always@(posedge clk or negedge rst) begin
        if(!rst) begin
            sampled_bit <=0;
            done <= 0;
            values <= 0;
        end
        else if (data_samp_en && !done) begin
        
            case(edge_cnt)
                half -2 :
                begin
                    values[0] <= RX_IN;                
                end
                half -1 :
                begin
                    values[1] <= RX_IN;                
                end            
                half  :
                begin
                    values[2] <= RX_IN;  
                    done <= 1;                             
                end 
                default :  values <= values;  
            endcase           
      
        end
        else if (done) begin
            sampled_bit <= (values == 0 || values == 1 || values == 2 || values == 4)? 0:1;
            done <= 0;
        end
    end    
endmodule
