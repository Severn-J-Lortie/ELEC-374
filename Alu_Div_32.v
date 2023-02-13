module Alu_Div_32(input [31:0] dividend, divisor, input clk, output reg [0:0] done, output reg[5:0] count, output reg [31:0] A, Q
);

	//reg [31:0] A = 31'b0;
	reg [31:0] M;
	reg temp;
	//reg [31:0] Q;
	//reg [5:0] count;
	integer i; 
	
	// Make sure inputs are positive
	initial begin
		A = 32'b0;
		M = 32'b0;
		Q = 32'b0;
		temp = 0; 
		done = 0;
		count = 33;
	end
	
	// Use a sequential method to achieve non-restoring division
	always @(posedge clk) begin
	
		// Adopt wire values on clk edge
		if (count == 33) begin 
		
			M = divisor;
			Q = dividend;
			
			// Make positive
			//if (M[31] == 1) begin 
			//	M = ~M + 1;
			//end
			//if (Q[31] == 1) begin 
			//	Q = ~Q + 1;
			//end
			count = count -1;
		end else begin
			// On each clock edge, perform a step in the 
			// non-restoring algo
			
			// Algo. keeps going
			if (count > 0) begin
			
				// Step 1: Shift A and Q left
				temp = Q[31];
				$display(A);
				A = A << 1;
				$display(A);
				Q = Q << 1;
				A[0] = temp; 
				
				
				//If A > 0, sub M from A
				if (A[31] == 0) begin
					A = A + (~M + 1);
				end else begin
					//$display(A);
					A = A + M; // Add M to A
					//$display(A);
				end

				Q[0] = !A[31];
				
				count = count - 1;
				
			end else begin
			
				// Step 2
				done = 1;
				// If A is negative add M
				if (A[31] == 1) begin
					A = A + M;
				end
			end
		end
	end
	

endmodule