`timescale 1ns / 1ps

module System_top_tb ();

/////////////////////////////////////////////////////
//////////////////clk_generator//////////////////////
/////////////////////////////////////////////////////

parameter ref_clk_period= 20; 
reg ref_clk_tb=0; 
always #(ref_clk_period/2) ref_clk_tb = ~ref_clk_tb;

/*--------------------------------------------------------------*/

parameter uart_clk_period = 271.2673611;
parameter uart_clk_half_period =135.6336806 ;
reg uart_clk_tb = 0;
always #(uart_clk_half_period) uart_clk_tb = ~uart_clk_tb;

/*--------------------------------------------------------------*/

parameter tx_clk_period = uart_clk_period*32;
parameter tx_clk_half_period =tx_clk_period/2.0 ;
reg tx_clk_tb = 0;
always #(tx_clk_half_period) tx_clk_tb = ~tx_clk_tb;


/////////////////////////////////////////////////////
///////////////Decleration & Instances///////////////
/////////////////////////////////////////////////////

reg				rst_tb;
reg				RX_IN_tb;
wire			TX_OUT_tb;
wire			stop_err_tb;
wire			par_err_tb;


System_Top DUT (
		.ref_clk(ref_clk_tb),
		.uart_clk(uart_clk_tb),
		.rst(rst_tb),
		.RX_IN(RX_IN_tb),
		.TX_OUT(TX_OUT_tb),
		.stop_err(stop_err_tb),
		.par_err(par_err_tb)
		);


/////////////////////////////////////////////////////
///////////////////Initial Block/////////////////////
/////////////////////////////////////////////////////

initial begin 
	$dumpfile("System_Top.vcd"); 
	$dumpvars; 
	
	reset();
	//send_frame ( FRAME , STOP_BIT )//
	
	///////////////TEST_CASE(1)////////////////////
	//////////////Reg_File_Write///////////////////
	
	send_frame(8'haa,1);         //cmd
	send_frame(8'h0a,1);         //address
	send_frame(8'h89,1);         //data
	
	///////////////TEST_CASE(2)////////////////////
	//////////////Reg_File_Read///////////////////
	
	send_frame(8'hbb,1);         //cmd
	send_frame(8'h0a,1);         //address
	
	///////////////TEST_CASE(3)////////////////////
	//////////////ALU_ANDING//////////////////////
	send_frame(8'hcc,1);         //cmd
	send_frame(8'hff,1);         //OP_A	
	send_frame(8'haa,1);         //OP_B	
	send_frame(8'h04,1);         //ALU_FUNC
		
	///////////////TEST_CASE(4)////////////////////
	/////////ALU_MULT_NoOperands(16BIT)///////////
	send_frame(8'hdd,1);         //cmd	
	send_frame(8'h02,1);         //ALU_FUNC	
	
	///////////////TEST_CASE(5)////////////////////
	/////////ALU_Sub_NoOperands_Stop_Err///////////
	send_frame(8'hdd,1);         //cmd	
	send_frame(8'h01,0);         //ALU_FUNC	
	//resend the dismissed frame due to err 
	send_frame(8'h01,1);         //ALU_FUNC	







	#(50*tx_clk_period);
	$stop;
end 

/////////////////////////////////////////////////////
//////////////////////Tasks//////////////////////////
/////////////////////////////////////////////////////

task reset;
 begin
 rst_tb=1;
 #(ref_clk_period)
 rst_tb=0;
 #(ref_clk_period)
 rst_tb=1;
 end
endtask

integer i ;

task send_frame;                             //no parity
 input [7:0] frame;
 input stop_bit ;
 begin 
 		RX_IN_tb = 0;        				 //start bit 
		#(tx_clk_period);

	for (i=0 ; i<8 ; i=i+1) begin
		RX_IN_tb = frame[i];                //data bits
		#(tx_clk_period);		
	end 
	
 		RX_IN_tb = stop_bit;         				//stop bit
 		
 		if(stop_bit)
		#(2*tx_clk_period);	
		else 
		#(1*tx_clk_period);
 end
 endtask


endmodule









