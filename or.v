
module or #(parameter size = 32)(
	input wire [size-1:0] Ra,
	input wire [size-1:0] Rb,
	output wire [size-1:0] Rz
);

	generate
		genvar k
		
		for (k = 0; k < size; k = k + 1) begin
			assign Rz[k] = Ra[k] | Rb[k];
		end
	endgenerate

endmodule