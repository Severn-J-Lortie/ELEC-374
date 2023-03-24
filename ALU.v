module ALU(
	input AND, OR, ADD, SUB, MUL, DIV, SHR, 
	input SHL, ROR, ROL, NEG, NOT, SHRA, BRANCH,
	input clk, div_rst, con,
	input [31:0] A, input [31:0] B, 
	output reg [63:0] C,
	output div_done
);

	wire [31:0] sub_out, ror_out, rol_out, or_out, and_out, add_out; 
	wire [31:0] div_out_lo, div_out_hi, not_out, neg_out, shr_out, shl_out, shra_out;
	wire [63:0] mul_out; 
	
	initial begin
		C = 64'b0;
	end
	
	always @(*) begin 
		C[63:0] = 32'b0;
		if (AND == 1) begin 
			C[31:0] = and_out;
			
		end
		else if (OR == 1) begin
			C[31:0] = or_out;
			
		end
		else if (ADD == 1) begin
			C[31:0] = add_out;
		end
		else if (SUB == 1) begin
			C[31:0] = sub_out;
		end
		else if (MUL == 1) begin
			C = mul_out;
		end
		else if (DIV == 1) begin
			C[31:0] = div_out_lo;
			C[63:32] = div_out_hi;
		end
		else if (SHR == 1) begin
			C[31:0] = shr_out;
			
		end
		else if (SHL == 1) begin
			C[31:0] = shl_out;
			
		end
		else if (ROR == 1) begin
			C[31:0] = ror_out;
			C[63:32] = 32'b0;
		end
		else if (ROL == 1) begin
			C[31:0] = rol_out;
			
		end
		else if (NEG == 1) begin
			C[31:0] = neg_out;
			
		end
		else if (NOT == 1) begin
			C[31:0] = not_out;

		end
		else if (SHRA == 1) begin 
			C[31:0] = shra_out;
		end
		else if (BRANCH == 1) begin
			if (con) begin
				C[31:0] = add_out; 
			end 
			else begin
				C[31:0] = A;
			end
		end
	end
	
	// Operations
	Alu_Subtract_32 subtract (A, B, sub_out);
	Alu_Rotate_Right_32 rotate_right(A, B, ror_out);
	Alu_Rotate_Left_32 rotate_left(A, B, rol_out);
	Alu_Or_32 or_32(A, B, or_out);
	Alu_And_32 and_32 (A, B, and_out);
	Alu_Add_32 add(A, B, /*BRANCH === 1 ? 1'b1 : 1'b0*/ 1'b0, add_out);
	Alu_Div_32 div(A, B, clk, div_rst, DIV, div_done, div_out_hi, div_out_lo);
	Alu_Mul_32_Ext mul(A, B, mul_out);
	Alu_Not_32 not_32(B, not_out);
	Alu_Neg_32 neg(B, neg_out);
	Alu_Shift_Right_32 shift_right(A, B, shr_out);
	Alu_Shift_Left_32 shift_left(A, B, shl_out);
	Alu_Shift_Right_Arith_32 shift_right_a(A, B, shra_out);
	
endmodule