`timescale 1ns/10ps
module alu_div_tb;

	wire [31:0] A, Q, dividend, divisor;
	assign dividend = 32'b100;
	assign divisor = 32'b11;
	reg Clock;
	wire done;
	wire [5:0] count;
	Alu_Div_32 DUT(dividend, divisor, Clock, done, count, A, Q);
	
	initial
		 begin 
			// Run clock
			Clock = 0;
			forever #10 Clock = ~ Clock;
	end


endmodule