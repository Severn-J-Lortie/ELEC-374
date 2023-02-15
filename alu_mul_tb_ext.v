`timescale 1ns/10ps
module alu_mul_tb_ext;

	wire [63:0] dataout;
	reg [31:0] A, X;
	Alu_Mul_32_Ext DUT(A, X, dataout);
	
	initial
		begin
		
			A = 32'H8000_00DE;
			X = 32'H0000_4500;
		end


endmodule