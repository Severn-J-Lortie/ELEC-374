
module Alu_Mul_SB(input A, A_2, P_in, S, C_in, H, D, output P_out, C_out);

	assign cas_in = S ? A_2 : A;
	
	// Basically a full adder. doing this so carry can be used
	// H controls whether or not the addition occurs
	// D controls add/sub
	// S controls A or 2A (shifted)
	assign P_out = P_in ^ (cas_in & H) ^ (C_in & H);
	assign C_out = (P_in ^ D) & (cas_in | C_in) | (cas_in & C_in);
	
endmodule

module Alu_Mul_CB(input [2:0] X, output reg H, S, D);

	always @(X) begin
		case(X)
			// 0*A
			3'b000: begin	
				H <= 0; S <= 0; D <=0; // rest are don't cares
			end
			
			// A
			3'b001: begin
			H <= 1; S <= 0; D <= 0; 
			end
			
			// A
			3'b010: begin
				H <= 1; S <= 0; D <= 0; 
			end
			
			// 2*A
			3'b011: begin
				H <= 1; S <= 1; D <= 0; 
			end
			
			// -2*A
			3'b100: begin
				H <= 1; S <= 1; D <= 1; 
			end
			
			// -A
			3'b101: begin
				H <= 1; S <= 0; D <= 1; 
			end
			
			3'b110: begin
				H <= 1; S <= 0; D <= 1; 
			end
			
			3'b111: begin
				H <= 1; S <=0; D <= 0;
			end	
		endcase
	end
endmodule

module Alu_Mul_32 (input [31:0] A, X, output [61:0] O);

	generate
	
		// Net between layers of the array adder
		wire [29:0] t [15:0];
		
		genvar i;
		for (i = 0; i < 16; i = i + 1) begin: loop
		
			// Carries
			wire [31:0] carry;
			wire S, H, D;
			
			// Special case for the first row control block. 
			// Append 0 to the start of the number
			if (i == 0) begin
				Alu_Mul_CB cb({X[1:0], 1'b0}, H, S, D);
			end
			else begin
				Alu_Mul_CB cb(X[i + i: i + i - 2], H, S, D);
			end
			
			genvar j;
			for (j = 0; j < 32; j = j + 1) begin: loop
				// First row
				if (i == 0) begin
					if (j == 0) begin
						Alu_Mul_SB sb(A[0], 0, 0, S, 0, H, D, O[0], carry[0]);
					end
					else if (j == 1) begin
						Alu_Mul_SB sb(A[1], A[0], 0, S, carry[0], H, D, O[1], carry[1]);
					end
					else begin
						Alu_Mul_SB sb(A[j], A[j - 1], 0, S, carry[j - 1], H, D, t[i][j - 2], carry[j]);
					end
				end
				else if (i < 15) begin
					// Middle rows
					if (j == 0) begin
						Alu_Mul_SB sb(A[0], 0, t[i - 1][0], S, 0, H, D, O[i + i], carry[0]);
					end
					else if (j == 1) begin
						Alu_Mul_SB sb(A[1], A[0], t[i - 1][1], S, carry[0], H, D, O[i + i + 1], carry[1]);
					end
					else begin
						Alu_Mul_SB sb(A[j], A[j - 1], j > 27 ? t[i - 1][27] : t[i - 1][j], S, carry[j - 1], H, D, t[i][j - 2], carry[j]);
					end
				end
				else begin
					// Last row
					if (j == 0) begin
						Alu_Mul_SB sb(A[0], 0, t[i - 1][0], S, 0, H, D, O[i + i], carry[0]);
					end
					else if (j == 1) begin
						Alu_Mul_SB sb(A[1], A[0], t[i - 1][1], S, carry[0], H, D, O[i + i + 1], carry[1]);
					end
					else begin
						Alu_Mul_SB sb(A[j], A[j - 1], j > 27 ? t[i - 1][27] : t[i - 1][j], S, carry[j - 1], H, D, O[i + i + j], carry[j]);
					end
				end
			end 
		end	
	endgenerate
	

endmodule