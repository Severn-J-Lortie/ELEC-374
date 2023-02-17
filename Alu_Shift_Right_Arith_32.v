module Alu_Shift_Right_Arith_32(input [31:0] X, input [31:0] shift, output [31:0] Y);
	wire [31:0] temp;
	assign temp = X[31] == 1 ? 32'HFFFFFFFF : 32'b0;
	assign Y = (X >> shift) | (temp << (32 - shift)); // Basically a ROR with the top bits cloned
endmodule