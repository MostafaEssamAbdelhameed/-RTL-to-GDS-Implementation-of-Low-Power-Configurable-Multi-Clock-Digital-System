`timescale 1ns / 1ps


module SYS_CTRL(
    input [15:0] ALU_OUT,
    input OUT_Valid,
    input [7:0] RX_P_DATA,
    input RX_D_VLD,
    input [7:0] RdData,
    input RdData_Valid,
    input FIFO_FULL,
    input clk,
    input rst,
    output reg ALU_EN,
    output reg  [3:0] ALU_FUNC,
    output reg CLK_EN,
    output reg [3:0] address,
    output reg WrEn,
    output reg RdEn,
    output reg [7:0] WrData,
    output reg [7:0] TX_P_DATA,
    output reg clk_div_en,
    output reg REG_EN,
    output reg WR_INC
    );
    
    parameter state_reg_width = 4;
	parameter [state_reg_width -1 : 0] idle = 0 ,
									   check = 1 ,
									   reg_write_add = 2 ,
									   reg_write_data = 3,
									   reg_read = 4,
									   send_reg = 5,
									   opA_write = 6,
									   opB_write = 7,
									   alu_func = 8 ,
									   send_alu = 9 ,
									   send_alu_two=13,
									   alu_noop = 10 ,
									   increment = 11 ,
									   do_read = 14,
									   do_op = 12 ;
									   
	reg [state_reg_width -1 : 0] curr_state , next_state ;
	
	reg [3:0] address_reg;
	always @(posedge clk or negedge rst) begin
			if(!rst)
			begin
                address_reg <= 0;
			end
		else if (REG_EN)
			begin
                address_reg <= address;
			end
	end
	//state register
	always @(posedge clk or negedge rst)begin
		if(!rst)
			begin
                curr_state <= idle;
			end
		else 
			begin
                curr_state <= next_state;
			end
	end
	
	//state logic
    always @(*) begin
        ALU_EN = 0;
        ALU_FUNC = 0;
        CLK_EN = 0;
        address = 0;
        WrEn = 0;
        RdEn = 0;
        WrData = 0;
        TX_P_DATA = 0;
        clk_div_en = 1;
        WR_INC = 0;
        REG_EN = 0;
        case(curr_state)
            idle:
            begin
               ALU_EN = 0;
               ALU_FUNC = 0;
               CLK_EN = 0;
               address = 0;
               WrEn = 0;
               RdEn = 0;
               WrData = 0;
               TX_P_DATA = 0;
               clk_div_en = 1;
               WR_INC = 0;  
               REG_EN = 0;          
               if(RX_D_VLD) next_state = check; 
               else next_state = idle ;    
            end
            
            check:
            begin
                if(RX_P_DATA == 'hAA) next_state = reg_write_add;
                else if(RX_P_DATA == 'hBB) next_state = reg_read;
                else if(RX_P_DATA == 'hCC) next_state = opA_write;
                else if(RX_P_DATA == 'hDD) next_state = alu_noop;
                else next_state = check;
            end
            
            reg_write_add:
            begin                               
                if(RX_D_VLD) begin
                    address = RX_P_DATA;
                    //WrEn = 1;
                    REG_EN = 1;
                    next_state = reg_write_data;
                end
                else next_state = reg_write_add;
            end
            
            reg_write_data:
            begin
               address = address_reg;
                if(RX_D_VLD) begin
                    WrEn =1;
                    WrData = RX_P_DATA;
                    next_state = idle;
                end 
                else next_state = reg_write_data;
            end
            
            reg_read:
            begin                
                if(RX_D_VLD == 1) begin
                REG_EN=1;
                address = RX_P_DATA;
                next_state = do_read;
                end
                else next_state = reg_read;
            end
            
            do_read: 
            begin
               address = address_reg;
               RdEn = 1;
               REG_EN=1;
               if (RdData_Valid == 1) next_state = send_reg;
               else next_state = do_read;
            end
            
            send_reg:
            begin
                TX_P_DATA = RdData;
                if(FIFO_FULL == 0) begin 
                WR_INC = 1 ;
                next_state = idle;
                end
                else next_state = send_reg;
            end
            
            opA_write:
            begin
                CLK_EN = 1;
                if (RX_D_VLD == 1) begin
                    address = 0;
                    WrEn = 1;
                    WrData = RX_P_DATA;   
                    next_state = opB_write;
                end  
                else next_state = opA_write;   
            end
            
            opB_write:
            begin                
                CLK_EN = 1;
                if (RX_D_VLD == 1) begin
                        address = 1;
                        WrEn = 1;
                        WrData = RX_P_DATA;   
                        next_state = alu_func;
                 end  
                 else next_state = opB_write;
            end
            
            alu_noop:
            begin
                CLK_EN = 1;
                next_state = alu_func;
                
            end
            
            alu_func:
            begin
                CLK_EN = 1;
                if (RX_D_VLD == 1) begin
                    ALU_FUNC = RX_P_DATA;
                    next_state = do_op;
                end
                else next_state = alu_func;
                
            end
            
            do_op:
            begin
                ALU_EN = 1;
                ALU_FUNC = RX_P_DATA;
                CLK_EN = 1;
                if(OUT_Valid) next_state = send_alu;
                else next_state = do_op;
            end
            
            send_alu:
            begin
                TX_P_DATA = ALU_OUT[7:0];
                if(FIFO_FULL == 0) begin
                WR_INC = 1 ;
                next_state = send_alu_two;
                end
                else next_state = send_alu;                
            end
            
            send_alu_two:
            begin
                TX_P_DATA = ALU_OUT[15:8];
                if(FIFO_FULL == 0) begin
                WR_INC = 1 ;
                next_state = idle;
                end
                else next_state = send_alu_two;                
            end
            
            default: 
            begin
               ALU_EN = 0;
               ALU_FUNC = 0;
               CLK_EN = 0;
               address = 0;
               WrEn = 0;
               RdEn = 0;
               WrData = 0;
               TX_P_DATA = 0;
               clk_div_en = 1;
               WR_INC = 0;
               
               next_state = idle;            
            end
	    endcase   
	end
endmodule
