`timescale 1ns/10ps
module alu_mul_tb;

	wire [61:0] dataout;
	reg [31:0] A, X;
	Alu_Mul_32 DUT(A, X, dataout);
	
	initial
		begin
		
			A = 32'b10;
			X = 32'b10;
		end


endmodule