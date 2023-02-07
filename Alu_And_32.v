
module Alu_And_32(
	input wire [31:0] Ra,
	input wire [31:0] Rb,
	output wire [31:0] Rz
);

	generate
		genvar k;
		
		for (k = 0; k < 32; k = k + 1) begin: loop
			assign Rz[k] = Ra[k] & Rb[k];
		end
	endgenerate

endmodule