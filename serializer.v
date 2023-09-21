`timescale 1ns / 1ps

module serializer(
    input [7:0] P_DATA,
    input ser_en,
    input clk,
    input rst,
    output reg ser_done,
    output reg ser_data
    );
    reg [7:0] data ;
    reg [3:0] counter;
    
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            ser_data <= 0;
            ser_done <= 0;
            counter <=0;
            data <= 0;
        end
        else if (!ser_en) begin
         data <= P_DATA;
         counter <=0;
         ser_done <= 0;
         end
        else if (counter!=8 && ser_en) begin
            {data[6:0] , ser_data} <= data;
            counter <= counter + 1;
            if (counter == 7) begin
                ser_done <= 1;
            end
        end
    end
endmodule
