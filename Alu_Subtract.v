module Alu_Subtract (
	input wire [31:0] Ra,
	input wire [31:0] Rb,
	input wire Cin,
	output wire [31:0] S,
	output wire Cout
);

	wire [31:0] temp;
	Alu_Negate(.Ra(Rb), .Rz(temp));
	Alu_Add(.Ra(Ra), .Rb(temp), .Cin(Cin), .S(S), .Cout(Cout));
	
endmodule