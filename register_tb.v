`timescale 1ns/10ps
module register_tb;

	reg clk, clr, enable; 
	reg [31:0] datain;
	wire [31:0] dataout;
	Register_32 DUT(clr, clk, enable, datain, dataout);
	
	initial 
		begin
		
			// Test data input
			enable = 1;
			datain = 32'b1111;
			clk = 0; 
			#20
			clk = 1;
			
			// Test clearing the register
			#10
			clk = 0;
			clr = 1;
			#10
			clk = 1;
			#10
			clr = 0;
			clk = 0;
			
			// Test enable/disable
			#10
			enable = 0;
			clk = 1;
			datain = 32'b10101; // Should not change data out
			
			
		end

endmodule