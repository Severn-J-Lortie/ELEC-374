`timescale 1ns/10ps
module alu_div_tb;

	wire [31:0] Q, dividend, divisor;
	wire [32:0] A; 
	assign dividend = 32'H8000_0100;
	assign divisor = 32'HFFFF_FFFC; // -2
	reg Clock;
	wire done;
	Alu_Div_32 DUT(dividend, divisor, Clock, 1'b0, done, A, Q);
	
	initial
		 begin 
			// Run clock
			Clock = 0;
			forever #10 Clock = ~ Clock;
	end


endmodule