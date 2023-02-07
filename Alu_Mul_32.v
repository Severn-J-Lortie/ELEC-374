
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
			3'b000: H <= 0; // rest are don't cares
			
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
			
			3'b111: H <= 1; 
		endcase
	end
endmodule

module Alu_Mul_32 (input [31:0] A, X, output [31:0] S);

	


endmodule