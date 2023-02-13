`timescale 1ns/10ps
module alu_mul_tb;

	wire [61:0] dataout;
	reg [31:0] A, X;
	wire [31:0] x;
	Alu_Mul_32 DUT(A, X, dataout, x);
	
	initial
		begin
		
			A = 32'b100;
			X = 32'b10;
		end


endmodule