module Alu_Neg_32(input [31:0] X, output [31:0] Y);

	// Negate X and place the result in Y

	// Invert all bits and add 1
	wire [31:0] t;
	Alu_Not_32 inv(X, t);
	Alu_Add_32 add(t, 32'b1, 1'b0, Y);

endmodule