module Register_64 #(parameter INITIAL_VAL = 64'b0) (

	input clr,
	input clk,
	input enable,
	input [63:0] D,
	output reg [63:0] Q
	
);
	
	initial
		begin
			Q = INITIAL_VAL;
		end
	
	always @(posedge clk or posedge clr) 
		begin
		
			if (clr) begin
				Q = 64'b0;
			end
			else if (enable) begin
				Q = D;
			end
	
		end

endmodule