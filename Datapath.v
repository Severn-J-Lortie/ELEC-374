module Datapath
#(
parameter I_R0 = 32'b0, I_R1 = 32'b0, I_R2 = 32'b0, I_R3 = 32'b0,
parameter I_R4 = 32'b0, I_R5 = 32'b0, I_R6 = 32'b0, I_R7 = 32'b0,
parameter I_R8 = 32'b0, I_R9 = 32'b0, I_R10 = 32'b0, I_R11 = 32'b0,
parameter I_R12 = 32'b0, I_R13 = 32'b0, I_R14 = 32'b0, I_R15 = 32'b0, I_PC = 32'b0
)
(
input PCout, MDRout, Zhighout, Zlowout, HIin, LOin,
input MDRin, MARin, div_rst, div_rdy,
input Zin, Yin, IRin, PCin, Read, Write, clr, clk, IncPC,
input BAout, InPortout, OutPortin,
input Gra, Grb, Grc, Rin, Rout, Cout, CONin,

input AND, OR, ADD, SUB, MUL, DIV, SHR, 
input SHL, ROR, ROL, NEG, NOT, SHRA, 


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

// Output control signals
output div_done
);

	// Bus wire
	wire [4:0] BusEncoderOut;
	
	// Wire from register R0 to BusMuxInR0
	wire [31:0] R0OutputToBusMuxIn;
	
	// Clear R0DataOut when BAout is asserted
	assign R0dataout = R0OutputToBusMuxIn & {32{!BAout}};
	
	
	// Select and encode logic
	Select_Encode select_encode(IRdataout, Gra, Grb, Grc, Rin, 
		Rout, BAout, register_outs, register_ins, C_sign_extended);
	
	// General purpose registers
	Register_32 #(I_R0) R0(clr, clk, register_ins[0], BusMuxOut, R0OutputToBusMuxIn);
	Register_32 #(I_R1) R1(clr, clk, register_ins[1], BusMuxOut, R1dataout);
	Register_32 #(I_R2) R2(clr, clk, register_ins[2], BusMuxOut, R2dataout);
	Register_32 #(I_R3) R3(clr, clk, register_ins[3], BusMuxOut, R3dataout);
	Register_32 #(I_R4) R4(clr, clk, register_ins[4], BusMuxOut, R4dataout);
	Register_32 #(I_R5) R5(clr, clk, register_ins[5], BusMuxOut, R5dataout);
	Register_32 #(I_R6) R6(clr, clk, register_ins[6], BusMuxOut, R6dataout);
	Register_32 #(I_R7) R7(clr, clk, register_ins[7], BusMuxOut, R7dataout);
	Register_32 #(I_R8) R8(clr, clk, register_ins[8], BusMuxOut, R8dataout);
	Register_32 #(I_R9) R9(clr, clk, register_ins[9], BusMuxOut, R9dataout);
	Register_32 #(I_R10) R10(clr, clk, register_ins[10], BusMuxOut, R10dataout);
	Register_32 #(I_R11) R11(clr, clk, register_ins[11], BusMuxOut, R11dataout);
	Register_32 #(I_R12) R12(clr, clk, register_ins[12], BusMuxOut, R12dataout);
	Register_32 #(I_R13) R13(clr, clk, register_ins[13], BusMuxOut, R13dataout);
	Register_32 #(I_R14) R14(clr, clk, register_ins[14], BusMuxOut, R14dataout);
	Register_32 #(I_R15) R15(clr, clk, register_ins[15], BusMuxOut, R15dataout);
	
	// Datapath registers
	wire con_out;
	wire pc_in; 
	Register_32 Y(clr, clk, Yin, BusMuxOut, Ydataout);
	Register_32 IR(clr, clk, IRin, BusMuxOut, IRdataout);
	Register_32 MAR(clr, clk, MARin, BusMuxOut, MARdataout);
	MDR MDR_reg(BusMuxOut, RAMdataout, Read, clr, clk, MDRin, MDRdataout);
	Register_32 HI(clr, clk, HIin, BusMuxOut, HIdataout);
	Register_32 LO(clr, clk, LOin, BusMuxOut, LOdataout);
	Z z_reg(ALUdataout, Zlowout, Zhighout, clr, clk, Zin, Zlowdataout, Zhighdataout);
	PC #(I_PC) pc(BusMuxOut, IncPC, clk, clr, pc_in, PCdataout);
	Register_32 InputPort(clr, clk, 1'b1, InPortdatain, InPortdataout);
	Register_32 OutputPort(clr, clk, OutPortin, BusMuxOut, OutPortdataout);
	
	// RAM
	RAM_32_512 RAM(Read, Write, MDRdataout, MARdataout[8:0], clk, RAMdataout);
	
	// ALU
	ALU alu(AND, OR, ADD, SUB, MUL, DIV, SHR, SHL, ROR, ROL, NEG, NOT, SHRA, 
			clk, div_done, div_rst, Ydataout, BusMuxOut, ALUdataout);
	
	// CON FF
	
	assign pc_in = con_out | PCin;
	CON_FF con_ff(IRdataout, BusMuxOut, CONin, con_out);
	
	// Bus
	Encoder_32_5 BusEncoder({10'b0, Cout, InPortout, MDRout, PCout, Zlowout, Zhighout, register_outs}, BusEncoderOut);
	
	Multiplexer_32_1 BusMux(BusEncoderOut, R0dataout, R1dataout, R2dataout, R3dataout, R4dataout, 
	R5dataout, R6dataout, R7dataout, R8dataout, R9dataout, R10dataout, R11dataout, 
	R12dataout, R13dataout, R14dataout, R15dataout, Zhighdataout, Zlowdataout, PCdataout, 
	MDRdataout, InPortdataout, C_sign_extended, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, 32'b0, BusMuxOut);
	

endmodule