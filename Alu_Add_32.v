
module Alu_Add_32 (
	input [31:0] x,
	input [31:0] y,
	input wire Cin,
	output wire [31:0] S
);
	
	wire [31:0] carries;
	assign carries[0] = Cin;
	
	generate
		genvar i;
		
		for (i = 0; i < 32; i = i + 1) begin: loop
			if (i == 31) begin 
				full_adder fa(carries[i], x[i], y[i], S[i]);
			end
			else begin
				full_adder fa(carries[i], x[i], y[i], S[i], carries[i+1]);
			end
		end
	endgenerate
	
endmodule


module full_adder(
	input Cin,
	input x,
	input y,
	output S,
	output Cout
);

	wire S1;
	wire Cout1;
	wire Cout2;
	wire C2;
	
	half_adder X (x, y, S1, Cout1);
	half_adder Y (Cin, S1, S, Cout2);
	
	assign Cout = Cout1|Cout2;
	
endmodule


module half_adder (
	input x,
	input y,
	output S,
	output C
);

	assign S = x^y;
	assign C = x&y;
	
endmodule
