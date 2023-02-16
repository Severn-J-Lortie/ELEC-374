module Alu_Subtract_32 (
	input wire [31:0] X,
	input wire [31:0] Y,
	output wire [31:0] Z
);

	// Negate Y and add to X
	wire [31:0] t;
	Alu_Neg_32(Y, t);
	Alu_Add_32(X, t, 1'b0, Z);
endmodule