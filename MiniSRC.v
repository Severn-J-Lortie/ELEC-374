module MiniSRC (
input clr, clk,

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
output [31:0] MARdataout, MDRdataout,
output [31:0] InPortdataout, OutPortdataout,
output [31:0] InPortdatain, OutPortdatain,
output [63:0] ALUdataout, 

// Bus
output [15:0] register_outs,
output [15:0] register_ins,

// RAM
output [31:0] RAMdataout, C_sign_extended,

// Control
output [7:0] present_state,

// CPU state
output Run
);

	// Control signals
	wire PCout, MDRout, Zhighout, Zlowout, HIin, LOin;
	wire MDRin, MARin, div_rst, div_done;
	wire Zin, Yin, IRin, PCin, Read, Write, IncPC;
	wire BAout, InPortout, OutPortin;
	wire Gra, Grb, Grc, Rin, Rout, Cout, CONin;
	wire HIout, LOout;
	wire AND, OR, ADD, SUB, MUL, DIV, SHR; 
	wire SHL, ROR, ROL, NEG, NOT, SHRA, BRANCH;
	wire R15in;
	
	// Control signals to control unit
	wire Stop; 

	// Bus wire
	wire [4:0] BusEncoderOut;
	wire CONdataout;
	
	// Wire from register R0 to BusMuxInR0
	wire [31:0] R0OutputToBusMuxIn;
	
	// Clear R0DataOut when BAout is asserted
	assign R0dataout = R0OutputToBusMuxIn & {32{!BAout}};
	
	wire CONout; 
	
	// Select and encode logic
	Select_Encode select_encode(IRdataout, Gra, Grb, Grc, Rin, 
		Rout, BAout, register_outs, register_ins, C_sign_extended);
	
	// General purpose registers
	Register_32 R0(clr, clk, register_ins[0], BusMuxOut, R0OutputToBusMuxIn);
	Register_32 R1(clr, clk, register_ins[1], BusMuxOut, R1dataout);
	Register_32 R2(clr, clk, register_ins[2], BusMuxOut, R2dataout);
	Register_32 R3(clr, clk, register_ins[3], BusMuxOut, R3dataout);
	Register_32 R4(clr, clk, register_ins[4], BusMuxOut, R4dataout);
	Register_32 R5(clr, clk, register_ins[5], BusMuxOut, R5dataout);
	Register_32 R6(clr, clk, register_ins[6], BusMuxOut, R6dataout);
	Register_32 R7(clr, clk, register_ins[7], BusMuxOut, R7dataout);
	Register_32 R8(clr, clk, register_ins[8], BusMuxOut, R8dataout);
	Register_32 R9(clr, clk, register_ins[9], BusMuxOut, R9dataout);
	Register_32 R10(clr, clk, register_ins[10], BusMuxOut, R10dataout);
	Register_32 R11(clr, clk, register_ins[11], BusMuxOut, R11dataout);
	Register_32 R12(clr, clk, register_ins[12], BusMuxOut, R12dataout);
	Register_32 R13(clr, clk, register_ins[13], BusMuxOut, R13dataout);
	Register_32 R14(clr, clk, register_ins[14], BusMuxOut, R14dataout);
	Register_32 R15(clr, clk, register_ins[15] | (R15in === 1), BusMuxOut, R15dataout);
	
	// Datapath registers
	Register_32 Y(clr, clk, Yin, BusMuxOut, Ydataout);
	Register_32 IR(clr, clk, IRin, BusMuxOut, IRdataout);
	Register_32 MAR(clr, clk, MARin, BusMuxOut, MARdataout);
	MDR MDR_reg(BusMuxOut, RAMdataout, Read, clr, clk, MDRin, MDRdataout);
	Register_32 HI(clr, clk, HIin, BusMuxOut, HIdataout);
	Register_32 LO(clr, clk, LOin, BusMuxOut, LOdataout);
	Z z_reg(ALUdataout, Zlowout, Zhighout, clr, clk, Zin, Zlowdataout, Zhighdataout);
	PC pc(BusMuxOut, IncPC, clk, clr, PCin, PCdataout);
	Register_32 InputPort(clr, clk, 1'b0, InPortdatain, InPortdataout);
	Register_32 OutputPort(clr, clk, OutPortin, BusMuxOut, OutPortdataout);
	Register_32 CON(clr, clk, CONin, CONout, CONdataout);   
	// RAM
	RAM_32_512 RAM(Read, Write, MDRdataout, MARdataout[8:0], clk, RAMdataout);
	
	// ALU
	ALU alu(AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT, SHRA, 
			BRANCH, clk, div_rst, CONdataout, Ydataout, BusMuxOut, ALUdataout, div_done);
	
	// CON FF
	CON_FF con_ff(IRdataout, BusMuxOut, CONout);
	
	// Bus
	Encoder_32_5 BusEncoder({8'b0, LOout, HIout, Cout, InPortout, MDRout, PCout, Zlowout, Zhighout, register_outs}, BusEncoderOut);
	Multiplexer_32_1 BusMux(BusEncoderOut, R0dataout, R1dataout, R2dataout, R3dataout, R4dataout, 
	R5dataout, R6dataout, R7dataout, R8dataout, R9dataout, R10dataout, R11dataout, 
	R12dataout, R13dataout, R14dataout, R15dataout, Zhighdataout, Zlowdataout, PCdataout, 
	MDRdataout, InPortdataout, C_sign_extended, HIdataout, LOdataout, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, BusMuxOut);
	
	// Place control directly in with the datapath code.
	// Makes connecting control and various signals easier
	Control control(
		clk, clr, Stop, div_done, IRdataout, Run,
		PCout, MDRout, Zhighout, Zlowout, HIin, LOin,
		MDRin, MARin, div_rst,
		Zin, Yin, IRin, PCin, Read, Write, IncPC,
		BAout, InPortout, OutPortin,
		Gra, Grb, Grc, Rin, Rout, Cout, CONin,
		HIout, LOout,
		AND, OR, ADD, SUB, MUL, DIV, SHR, 
		SHL, ROR, ROL, NEG, NOT, SHRA, BRANCH,
		R15in, present_state
	);
	
endmodule