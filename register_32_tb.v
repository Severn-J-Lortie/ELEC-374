`timescale 1ns/10ps
module register_32_tb;

	reg clk;
	wire [31:0] Q;
	reg [31:0] D;
	Register_32 register(0, clk, 1, D, Q);
	initial begin
		D <= 0; clk = 0;
		forever begin
			#10 clk = ~clk;
		end
	end
	
	always @(posedge clk) begin
		D <= 32'b0101010;
	end


endmodule
