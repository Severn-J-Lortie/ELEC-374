`timescale 1ns/10ps
module alu_mul_32_tb();

	wire [31:0] M, Q;
	wire [63:0] O;
	wire ready;
	reg Clock, reset;
	
	assign M = 32'H8000_0003;
	assign Q = 32'H0000_0400;
	Alu_Mul_32 DUT(M, Q, Clock, reset, O, ready);
	
	initial
		 begin 
			// Run clock
			Clock = 0;
			forever #10 Clock = ~ Clock;
	end
endmodule
