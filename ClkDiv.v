`timescale 1ns / 1ps


module ClkDiv #(parameter width=6) (
    input i_ref_clk,
    input i_rst_n,
    input i_clk_en,
    input [width -1:0] i_div_ratio,
    output o_div_clk
    );
    
    reg [width -1:0] counter; 
    reg flag ; 
    wire [width-2:0] half_ratio;
    wire odd ;
    wire clk_div_en;
    reg div_clk;
    assign clk_div_en = i_clk_en && (i_div_ratio != 0) && (i_div_ratio != 1); 
    assign odd = (i_div_ratio[0]) ;
    assign half_ratio = (i_div_ratio >> 1);
    
    always @(posedge i_ref_clk or negedge i_rst_n) begin
        if(!i_rst_n) begin
          div_clk <=0;
          counter <= 0;
          flag <= 0;  
        end
        else if(clk_div_en) begin
            if (!odd && (counter == half_ratio-1)) begin
                div_clk <= !div_clk;
                counter <= 0;
            end
            else if (odd && (counter == half_ratio-1) && !flag) begin
                div_clk <= !div_clk;
                counter <= 0; 
                flag <= 1;           
            end
            else if (odd && (counter == half_ratio) && flag) begin
                div_clk <= !div_clk;
                counter <= 0; 
                flag <= 0;        
            end
            else  counter <= counter + 1 ;
        end
    end 
    
    assign o_div_clk = clk_div_en ? div_clk : i_ref_clk;
endmodule
