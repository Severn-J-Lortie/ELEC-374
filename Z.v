module Z(input [63:0] Zdatain, input Zlowout, Zhighout, clr, clk, Zin, output [31:0] Zlowdataout, Zhighdataout);

	wire [63:0] Zdataout;
	Register_64 reg_64 (clr, clk, Zin, Zdatain, Zdataout);
	assign Zlowdataout = Zdataout[31:0];
	assign Zhighdataout = Zdataout[63:32];
	
endmodule