
module Alu_Add #(parameter size = 32)(
	input [size-1:0] Ra,
	input [size-1:0] Rb,
	input wire Cin,
	output wire [size-1:0] S,
	output wire Cout
);

	assign S[0] = Cin;
	
	generate
		genvar k;
		
		for (k = 0, k < size, k = k + 1) begin
			full_adder(S[k], Ra[K], Rb[k], Cin[k], S[k+1]);
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
	
	Cout = C1|C2;
	
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
