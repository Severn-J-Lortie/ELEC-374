
module Alu_Add_32 (
	input [31:0] Ra,
	input [31:0] Rb,
	input wire Cin,
	output wire [32:0] S
);

	assign S[0] = Cin;
	
	generate
		genvar k;
		
		for (k = 0; k < 32; k = k + 1) begin: loop
			full_adder fa(S[k], Ra[k], Rb[k], Cin, S[k+1]);
		end
	endgenerate
	
endmodule


module full_adder(
	input Cin,
	input Ra,
	input Rb,
	output S,
	output Cout
);

	wire S1;
	wire C1;
	wire C2;
	
	half_adder X (Ra, Rb, S1, C1);
	half_adder Y (Cin, S1, S, C2);
	
	assign Cout = C1|C2;
	
endmodule


module half_adder (
	input Ra,
	input Rb,
	output S,
	output C
);

	assign S = Ra^Rb;
	assign C = Ra&Rb;
	
endmodule
