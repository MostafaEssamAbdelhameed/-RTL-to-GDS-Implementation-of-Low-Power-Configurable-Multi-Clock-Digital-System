`timescale 1ns / 1ps

module mux_prescale(
    input  [5:0]  sel ,
    output  [2:0] ratio
    );
    
    assign ratio = (sel == 32)? 1:((sel==16)? 2:((sel==8)? 4:0));
     
endmodule
