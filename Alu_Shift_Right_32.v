module Alu_Shift_Right_32(input [31:0] X, input [31:0] shift, output [31:0] Y);

	assign Y = X >> shift; 

endmodule