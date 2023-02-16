module Alu_Not_32(input [31:0] X, output [31:0] Y);


	// Invert every bit of X and place the result in Y
	generate
	
		genvar i;
		for (i = 0; i < 32; i = i + 1) begin: loop
			assign Y[i] = !X[i];
		end
	
	endgenerate
	

endmodule