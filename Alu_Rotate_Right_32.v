module Alu_Rotate_Right_32 (
	input wire [31:0] in,
	input wire [31:0] shift,
	output reg [31:0] out
);

	reg [31:0] temp; 
	reg [31:0] r_in;
	
	always @(*) begin 
		r_in = in; 
		temp = (r_in >> shift) | (r_in << (32 - shift));
		out = temp;
	end


endmodule
