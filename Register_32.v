module Register_32 #(parameter INITIAL_VAL = 32'b0) (

	input clr,
	input clk,
	input enable,
	input [31:0] D,
	output reg [31:0] Q
	
);
	
	initial
		begin
			Q <= INITIAL_VAL;
		end
	
	always @(posedge clk or posedge clr) 
		begin
		
			if (clr) begin
				Q <= 32'b0;
			end
			else if (enable) begin
				Q <= D;
			end
	
		end

endmodule