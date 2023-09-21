`timescale 1ns / 1ps

module DATA_SYNC #(parameter BUS_WIDTH = 8 , NUM_STAGES = 2) (
    input [BUS_WIDTH -1:0] Unsync_bus,
    input bus_enable,
    input clk,
    input rst,
    output [BUS_WIDTH - 1:0] sync_bus,
    output enable_pulse
    );
    wire link;
    
    
    BIT_SYNC #( 1 , NUM_STAGES) DUT0 ( .async(bus_enable),
                                              .clk(clk),
                                              .rst(rst),
                                              .sync(link)
                                     );
                                              
    PULSE_GEN #(BUS_WIDTH) DUT1 ( .bus_enable(link),
                                   .Unsync_bus(Unsync_bus),
                                   .sync_bus(sync_bus),
                                   .enable_pulse(enable_pulse),
                                   .clk(clk),
                                   .rst(rst)
                                );                                           
    
    
endmodule
