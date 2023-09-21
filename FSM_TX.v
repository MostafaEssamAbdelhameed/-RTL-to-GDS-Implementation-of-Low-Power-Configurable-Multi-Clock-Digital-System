`timescale 1ns / 1ps

module FSM_TX (
    input ser_done,
    input PAR_EN,
    input data_valid,
    input clk,
    input rst,
    output reg ser_en,
    output reg [1:0] mux_sel,
    output reg par_load,
    output reg busy

    );
    parameter state_reg_width = 5;
	parameter [state_reg_width -1 : 0] idle_state = 5'b00001 ,
									   start_state = 5'b00010,
									   data_state=5'b00100,
									   parity_state=5'b01000,
									   stop_state = 5'b10000;
	reg [state_reg_width -1 : 0] curr_state , next_state ;
	reg busy_c;

//state register
	always @(posedge clk or negedge rst)begin
		if(!rst)
			begin
			curr_state <= idle_state;
			end
		else 
			begin
			curr_state <= next_state;
			end
	end
//state logic
    always @(*) begin
        mux_sel=1;
        ser_en=0;
        par_load=0;
        busy_c=0;
        case(curr_state)
            idle_state:
                begin
                    mux_sel=1;
                    ser_en=0;
                    par_load=0;
                    busy_c=0;
                    if(data_valid) next_state = start_state;
                    else next_state = idle_state;
                end   
            start_state:
                begin
                    mux_sel=0;
                    ser_en=1;
                    par_load=1;
                    busy_c=1;
                    next_state = data_state;
                end
            data_state:
                begin
                    mux_sel=2;
                    ser_en=1;
                    par_load=1;
                    busy_c=1;
                    if(ser_done && PAR_EN) next_state = parity_state;
                    else if(ser_done && !PAR_EN) next_state = stop_state;        
                    else next_state = data_state;    
                end
            parity_state:
                begin
                    mux_sel=3;
                    ser_en=0;
                    par_load=0;
                    busy_c=1;
                    next_state = stop_state;    
                end
            stop_state:
                begin
                    mux_sel=1;
                    ser_en=0;
                    par_load=0;
                    busy_c=1; 
                    //if(data_valid) next_state = start_state;
                     next_state = idle_state;           
                end
            default: 
                begin
                    mux_sel=1;
                    ser_en=0;
                    par_load=0;
                    busy_c=0; 
		            next_state = idle_state;
                end
        endcase
    end
//register output 
always @ (posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    busy <= 1'b0 ;
   end
  else
   begin
    busy <= busy_c ;
   end
 end
endmodule
