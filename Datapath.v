module Datapath(
input PCout, MDRout, Zhighout, Zlowout, HIin, LOin,
input MDRin, MARin,
input Zin, Yin, IRin, PCin, Read, clr, clk, IncPC,

input AND, OR, ADD, SUB, MUL, DIV, SHR, 
input SHL, ROR, ROL, NEG, NOT, SHRA, 

input R0out, R1out, R2out, R3out, R4out, 
input R5out, R6out, R7out, R8out, R9out, 
input R10out, R11out, R12out, R13out, R14out, R15out,
input R0in, R1in, R2in, R3in, R4in, 
input R5in, R6in, R7in, R8in, R9in, 
input R10in, R11in, R12in, R13in, R14in, R15in,

// Export these signals for the waveform demos
// general purpose registers
output [31:0] R0dataout, R1dataout, R2dataout,
output [31:0] R3dataout, R4dataout, R5dataout,
output [31:0] R6dataout, R7dataout, R8dataout,
output [31:0] R9dataout, R10dataout, R11dataout,
output [31:0] R12dataout, R13dataout, R14dataout,
output [31:0] R15dataout, 

// Datapath registers
output [31:0] HIdataout, LOdataout,
output [31:0] IRdataout, BusMuxOut, Zlowdataout, 
output [31:0] Zhighdataout, Ydataout, PCdataout,
output [31:0] MARdataout, MDRdataout, Mdatain,
output [63:0] Cout
);

	// Bus wire
	wire [4:0] BusEncoderOut;
	
	// General purpose registers
	Register_32 R0(clr, clk, R0in, BusMuxOut, R0dataout);
	Register_32 R1(clr, clk, R1in, BusMuxOut, R1dataout);
	Register_32 R2(clr, clk, R2in, BusMuxOut, R2dataout);
	Register_32 R3(clr, clk, R3in, BusMuxOut, R3dataout);
	Register_32 R4(clr, clk, R4in, BusMuxOut, R4dataout);
	Register_32 R5(clr, clk, R5in, BusMuxOut, R5dataout);
	Register_32 R6(clr, clk, R6in, BusMuxOut, R6dataout);
	Register_32 R7(clr, clk, R7in, BusMuxOut, R7dataout);
	Register_32 R8(clr, clk, R8in, BusMuxOut, R8dataout);
	Register_32 R9(clr, clk, R9in, BusMuxOut, R9dataout);
	Register_32 R10(clr, clk, R10in, BusMuxOut, R10dataout);
	Register_32 R11(clr, clk, R11in, BusMuxOut, R11dataout);
	Register_32 R12(clr, clk, R12in, BusMuxOut, R12dataout);
	Register_32 R13(clr, clk, R13in, BusMuxOut, R13dataout);
	Register_32 R14(clr, clk, R14in, BusMuxOut, R14dataout);
	Register_32 R15(clr, clk, R15in, BusMuxOut, R15dataout);
	
	// Datapath registers
	Register_32 Y(clr, clk, Yin, BusMuxOut, Ydataout);
	Register_32 IR(clr, clk, IRin, BusMuxOut, IRdataout);
	Register_32 MAR(clr, clk, MARin, BusMuxOut, MARdataout);
	MDR MDR_reg(BusMuxOut, Mdatain, Read, clr, clk, MDRin, MDRdataout);
	Register_32 HI(clr, clk, HIin, BusMuxOut, HIdataout);
	Register_32 LO(clr, clk, LOin, BusMuxOut, LOdataout);
	Z z_reg(Cout, Zlowout, Zhighout, clr, clk, Zin, Zlowdataout, Zhighdataout);
	//PC pc(BusMuxOut, IncPC, clk, clr, PCin, PCdataout);
	Register_32 PC(clr, clk, PCin, BusMuxOut, PCdataout);
	
	// ALU
	ALU alu(AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT, SHRA, clk, Ydataout, BusMuxOut, Cout);
	
	Encoder_32_5 BusEncoder({12'b0, MDRout, PCout, Zlowout, Zhighout, R15out, R14out, R13out, R12out, R11out, 
			R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out}, BusEncoderOut);
	
	Multiplexer_32_1 BusMux(BusEncoderOut, R0dataout, R1dataout, R2dataout, R3dataout, R4dataout, 
	R5dataout, R6dataout, R7dataout, R8dataout, R9dataout, R10dataout, R11dataout, 
	R12dataout, R13dataout, R14dataout, R15dataout, Zhighdataout, Zlowdataout, PCdataout, 
	MDRdataout, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, BusMuxOut);
	

endmodule