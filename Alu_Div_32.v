module Alu_Div_32(input [31:0] dividend, divisor, input clk, rst, output reg [0:0] done, output reg [32:0] A, output reg [31:0] Q);

	reg [31:0] M;
	reg[5:0] count;
	reg temp;
	integer i; 
	
	initial begin
		A = 33'b0;
		M = 32'b0;
		Q = 32'b0;
		done = 0;
		temp = 0;
		count = 6'd32;
	end
	
	// Use a sequential method to achieve non-restoring division
	always @(posedge clk) begin
	
		// Reset code
		if (rst == 1) begin 
			A = 33'b0;
			M = 32'b0;
			Q = 32'b0;
			done = 0;
			temp = 0; 
			count = 6'd32;
		end
	
		// Adopt wire values on clk edge
		if (count == 32) begin 
		
			M = divisor;
			Q = dividend;
			
			// Make positive
			if (M[31] == 1) begin 
				M = ~M + 1;
			end
			if (Q[31] == 1) begin 
				Q = ~Q + 1;
			end
		end 
		
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
			if (A[32] == 0) begin
				A = A + (~M + 1);
			end else begin
				//$display(A);
				A = A + M; // Add M to A
				//$display(A);
			end

			Q[0] = !A[32];
			
			count = count - 6'b1;
			
		end else begin
		
			// Step 2
			// If A is negative add M
			if (A[32] == 1 && done == 0) begin
				A = A + M;
				
				// Sign Q based on initial operand sign
				if (dividend[31] ^ divisor[31] == 1) begin
					Q = ~Q + 1;
				end
				
			end
			
			done = 1;
			
		end
	end
	

endmodule