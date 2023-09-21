`timescale 1ns / 1ps


module FSM_RX (
    input RX_IN,
    input PAR_EN,
    input par_err,
    input start_glitch,
    input stop_err,
    input [3:0] bit_cnt,
    output reg par_check_en,
    output reg start_check_en,
    output reg stop_check_en,
    output reg deser_en,
    output reg data_valid,
    output reg enable,
    output reg data_samp_en,
    input rst,
    input clk
    );

    parameter state_reg_width = 3;
	parameter [state_reg_width -1 : 0] idle_state = 0 ,
									   start_state = 1 ,
									   data_state = 2 ,
									   parity_state = 3 ,
									   stop_state = 4 ,
									   error_state = 5 ;
									   
	reg [state_reg_width -1 : 0] curr_state , next_state ;
	reg data_valid_c;    
    
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
        par_check_en = 0;
        start_check_en = 0;
        stop_check_en = 0;
        deser_en = 0;
        data_valid_c = 0;
        enable = 0;
        data_samp_en = 0;
        case(curr_state)
            idle_state:
            begin
                par_check_en = 0;
                start_check_en = 0;
                stop_check_en = 0;
                deser_en = 0;
                data_valid_c = 0;
                enable = 0;
                data_samp_en = 0;            
                if (RX_IN==0) begin
                enable = 1;
                next_state = start_state;
                start_check_en = 1;               
                end
                else next_state = idle_state;
            end
            start_state:
            begin
                par_check_en = 0;
                start_check_en = 1;
                stop_check_en = 0;
                deser_en = 0;
                data_valid_c = 0;
                enable = 1;
                data_samp_en = 1;
                if(bit_cnt == 1)begin
                 deser_en = 1;
                 next_state = data_state;
                 end
                else next_state = start_state;
            end
            data_state:
            begin
                par_check_en = 0;
                start_check_en = 0;
                stop_check_en = 0;
                deser_en = 1;
                data_valid_c = 0;
                enable = 1;
                data_samp_en = 1;
                if (bit_cnt == 9 && PAR_EN == 1) next_state = parity_state;
                else if (bit_cnt == 9 && PAR_EN == 0) next_state = stop_state;           
                else next_state = data_state;
            end            
            parity_state:
            begin
                par_check_en = 1;
                start_check_en = 0;
                stop_check_en = 0;
                deser_en = 0;
                data_valid_c = 0;
                enable = 1;
                data_samp_en = 1; 
                if (bit_cnt == 10) next_state = stop_state;
                else next_state = parity_state;           
            end
            stop_state:
            begin
                par_check_en = 0;
                start_check_en = 0;
                stop_check_en = 1;
                deser_en = 0;
                data_valid_c = 0;
                enable = 1;
                data_samp_en = 1; 
                if ((bit_cnt==10 && PAR_EN==0) || (bit_cnt==11 && PAR_EN==1)) begin
					//next_state = error_state ;
					 enable = 0;
					 stop_check_en = 0;
					 data_samp_en = 0; 
					if (!par_err && !stop_err && !start_glitch) begin 
						data_valid_c = 1;
						if(RX_IN) next_state = idle_state;
						else next_state = start_state;
					end
					else begin
						data_valid_c = 0;
						if(RX_IN) next_state = idle_state;
						else next_state = start_state;                   
					end					
				end
                else next_state = stop_state;                      
            end
           
            default:
            begin
                par_check_en = 0;
                start_check_en = 0;
                stop_check_en = 0;
                deser_en = 0;
                data_valid_c = 0;
                enable = 0;
                data_samp_en = 0;
                next_state = idle_state;         
            end
        endcase 
    end
    
//register output 
always @ (posedge clk or negedge rst)
 begin
  if(!rst)
   begin
    data_valid <= 1'b0 ;
   end
  else
   begin
    data_valid <= data_valid_c ;
   end
 end
     
endmodule
