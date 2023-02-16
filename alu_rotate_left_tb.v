`timescale 1ns/10ps
module alu_rotate_left_tb();

	reg [31:0] in;
	wire [31:0] out;
	reg [31:0] shift;
	
	Alu_Rotate_Left_32 DUT(in, shift, out);
	
	initial begin
		#5
		in = 32'b101000110;
		shift = 32'd23;
	end
	

endmodule