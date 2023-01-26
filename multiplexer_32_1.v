
module multiplexer_32_1 (
	input [31:0] R0,
	input [31:0] R1,
	input [31:0] R2,
	input [31:0] R3,
	input [31:0] R4,
	input [31:0] R5,
	input [31:0] R6,
	input [31:0] R7,
	input [31:0] R8,
	input [31:0] R9,
	input [31:0] R10,
	input [31:0] R11,
	input [31:0] R12,
	input [31:0] R13,
	input [31:0] R14,
	input [31:0] R15,
	input [31:0] HI,
	input [31:0] LO,
	input [31:0] Zhigh,
	input [31:0] Zlow,
	input [31:0] PC,
	input [31:0] MDR,
	input [31:0] InPort,
	input [31:0] C_sign_extended,
	
	input wire [4:0] encoder_logic,
	
	output reg [31:0] MuxOut

);

	always@(*) begin

		case(encoder_logic)
			5'b00000 : MuxOut <= R0[31:0];
			5'b00001 : MuxOut <= R1[31:0];
			5'b00010 : MuxOut <= R2[31:0];
			5'b00011 : MuxOut <= R3[31:0];
			5'b00100 : MuxOut <= R4[31:0];
			5'b00101 : MuxOut <= R5[31:0];
			5'b00110 : MuxOut <= R6[31:0];
			5'b00111 : MuxOut <= R7[31:0];
			5'b01000 : MuxOut <= R8[31:0];
			5'b01001 : MuxOut <= R9[31:0];
			5'b01010 : MuxOut <= R10[31:0];
			5'b01011 : MuxOut <= R11[31:0];
			5'b01100 : MuxOut <= R12[31:0];
			5'b01101 : MuxOut <= R13[31:0];
			5'b01110 : MuxOut <= R14[31:0];
			5'b01111 : MuxOut <= R15[31:0];
			5'b10000 : MuxOut <= HI[31:0];
			5'b10001 : MuxOut <= LO[31:0];
			5'b10010 : MuxOut <= Zhigh[31:0];
			5'b10011 : MuxOut <= Zlow[31:0];
			5'b10100 : MuxOut <= PC[31:0];
			5'b10101 : MuxOut <= MDR[31:0];
			5'b10110 : MuxOut <= InPort[31:0];
			5'b10111 : MuxOut <= C_sign_extended[31:0];
			default: MuxOut <= 32'b0;
		endcase
	end
endmodule