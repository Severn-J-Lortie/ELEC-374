module MDR(input [31:0] BusMuxOut, Mdatain, input Read, clr, clk, MDRin, output [31:0] MDRout);

	wire [31:0] mux_out;
	Mux_2_32 MDR_mux(mux_out, Mdatain, BusMuxOut, Read);
	Register_32 MDR_reg(clr, clk, MDRin, mux_out, MDRout);
	
endmodule