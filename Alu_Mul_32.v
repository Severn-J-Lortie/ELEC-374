module Alu_Mul_32(input [31:0] M, Q, input clk, rst, output reg [63:0] O, output reg ready);

	reg [32:0] pp, m;
	reg [5:0] count;
	reg [2:0] q;
	reg [63:0] j;
	initial begin
		pp = 33'b0;
		count = 6'b0;
		m = 33'b0;
		q = 3'b0;
		O = 64'b0;
		j = 64'b0;
	end

	always @(posedge clk) begin
	
		if (rst == 1) begin
			count = 6'b0; 
			ready = 0;
			pp = 33'b0; 
			q = 3'b0; 
			O = 64'b0;
			j = 64'b0;
		end
	
		if (count < 16) begin
			// Setup
			m = {M[31], M[31:0]}; // sign extend by 2
			
			if (count == 0) begin
				q = {Q[1:0], 1'b0};
			end
			else begin
				
				q = {Q[count + count + 1], Q[count + count], Q[count + count - 1]};
				
			end
			// Decode q
			case(q)
				// 0*A
				3'b000: begin	
					m = 33'b0;
				end
				// 2*A
				3'b011: begin
					m = m << 1;
				end
				// -2*A
				3'b100: begin
					m = ~(m << 1) + 1; 
				end
				// -A
				3'b101: begin
					m = ~m + 1;
				end
				// -A
				3'b110: begin
					m = ~m + 1;
				end
				// 0*A
				3'b111: begin
					m = 33'b0;
				end	
			endcase
		
			// Right shift the partial product/output and save the output
			
			pp = pp + m; 
			
			j = O >> 2;
			O = j;
			//O = O >> 2;
			O[31:30] = pp[1:0];

			pp = pp >> 2;
			pp = {pp[30], pp[30], pp[30:0]};
			
			if (count == 15) begin 
				
				O[63:32] = pp[31:0];
			end
			
			// Increment count
			count = count + 6'd1;
		end
		else begin 
			ready = 1;
		end
	end
endmodule