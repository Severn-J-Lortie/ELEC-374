module Alu_Rotate_Right_32 (
	input [31:0] in,
	input [31:0] shift,
	output [31:0] out
);


	assign out = (in >> shift) | (in << (32 - shift));

endmodule
