module ALU(
	input AND, OR, ADD, SUB, MUL, DIV, SHR, 
	input SHL, ROR, ROL, NEG, NOT, SHRA, 
	input clk,
	input [31:0] A, input [31:0] B, 
	output reg [63:0] C
);

	wire [31:0] sub_out, ror_out, rol_out, or_out, and_out, add_out; 
	wire [31:0] div_out_lo, div_out_hi, not_out, neg_out, shr_out, shl_out, shra_out;
	wire [63:0] mul_out; 
	wire div_rst, div_done, mul_rst, mul_done;
	
	initial begin
		C = 64'b0;
	end
	
	always @(*) begin 
			if (AND) begin 
				C[31:0] = and_out;
				C[63:32] = 32'b0;
			end
			else if (OR) begin
				C[31:0] = or_out;
				C[63:32] = 32'b0;
			end
			else if (ADD) begin
				C[31:0] = add_out;
				C[63:32] = 32'b0;
			end
			else if (MUL) begin
				C = mul_out;
			end
			else if (DIV) begin
				C[31:0] = div_out_lo;
				C[63:32] = div_out_hi;
			end
			else if (SHR) begin
				C[31:0] = shr_out;
				C[63:32] = 32'b0;
			end
			else if (SHL) begin
				C[31:0] = shl_out;
				C[63:32] = 32'b0;
			end
			else if (ROR) begin
				C[31:0] = ror_out;
				C[63:32] = 32'b0;
			end
			else if (ROL) begin
				C[31:0] = rol_out;
				C[63:32] = 32'b0;
			end
			else if (NEG) begin
				C[31:0] = neg_out;
				C[63:32] = 32'b0;
			end
			else if (NOT) begin
				C[31:0] = not_out;
				C[63:32] = 32'b0;
			end
			
			else if (SHRA) begin 
				C[31:0] = shra_out;
				C[63:32] = 32'b0;
			end
			else begin
				C[31:0] = 32'b0;
				C[63:32] = 32'b0;
			end
	end
	
	// Operations
	Alu_Subtract_32 subtract (A, B, sub_out);
	Alu_Rotate_Right_32 rotate_right(A, B, ror_out);
	Alu_Rotate_Left_32 rotate_left(A, B, rol_out);
	Alu_Or_32 or_32(A, B, or_out);
	Alu_And_32 and_32 (A, B, and_out);
	Alu_Add_32 add(A, B, 1'b0, add_out);
	Alu_Div_32 div(A, B, clk, div_rst, div_done, div_out_hi, div_out_lo);
	Alu_Mul_32 mul(A, B, clk, mul_rst, mul_out, mul_done);
	Alu_Not_32 not_32(A, not_out);
	Alu_Neg_32 neg(A, neg_out);
	Alu_Shift_Right_32 shift_right(A, B, shr_out);
	Alu_Shift_Left_32 shift_left(A, B, shl_out);
	Alu_Shift_Right_Arith_32 shift_right_a(A, B, shra_out);

endmodule