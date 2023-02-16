module alu_shift_right_arith_tb();

	wire [31:0] X, Y, shift;
	assign X = 32'H84FFFFFF;
	assign shift = 32'd4;
	Alu_Shift_Right_Arith_32 DUT(X, shift, Y);

endmodule