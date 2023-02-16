module Alu_Mul_SB_Ext(input A, A_2, P_in, S, C_in, H, D, output P_out, C_out);

	wire cas_in;
	assign cas_in = S ? A_2 : A;
	
	// Basically a full adder. doing this so carry can be used
	// H controls whether or not the addition occurs
	// D controls add/sub
	// S controls A or 2A (shifted)
	assign P_out = P_in ^ (cas_in & H) ^ (C_in & H);
	assign C_out = (P_in ^ D) & (cas_in | C_in) | (cas_in & C_in);
	
endmodule

module Alu_Mul_CB_Ext(input [2:0] X, output reg H, S, D);

	always @(X) begin
	//$disp(X);
		case(X)
			// 0*A
			3'b000: begin	
				H <= 0; S <= 0; D <=0; // rest are don't cares
			end
			
			// A
			3'b001: begin
			H <= 1; S <= 0; D <= 0; 
			end
			
			// A
			3'b010: begin
				H <= 1; S <= 0; D <= 0; 
			end
			
			// 2*A
			3'b011: begin
				H <= 1; S <= 1; D <= 0; 
			end
			
			// -2*A
			3'b100: begin
				H <= 1; S <= 1; D <= 1; 
			end
			
			// -A
			3'b101: begin
				H <= 1; S <= 0; D <= 1; 
			end
			
			3'b110: begin
			

				H <= 1; S <= 0; D <= 1; 
			end
			
			3'b111: begin
				H <= 0; S <=0; D <= 0;
			end	
		endcase
	end
endmodule

module Alu_Mul_Row_Ext(input [31:0] A, input [2:0] X, input [33:0] prev, output [33:0] t);
	
	
	wire S, H, D;
	Alu_Mul_CB_Ext cb(X, H, S, D);
	wire [34:0] carry;
	
	generate 
		genvar i;
		for (i = 0; i < 34; i = i + 1) begin: loop
			if (i == 0) begin
				Alu_Mul_SB_Ext sb(A[i], 1'b0, prev[i], S, 1'b0, H, D, t[i], carry[i]);
			end
			else if (i >= 31) begin
				Alu_Mul_SB_Ext sb(A[31], i >= 32 ? A[31] :  A[30], prev[i], S, carry[i-1], H, D, t[i], carry[i]);
			end
			else begin
				Alu_Mul_SB_Ext sb(A[i], A[i - 1], prev[i], S, carry[i-1], H, D, t[i], carry[i]);
			end
		end
	endgenerate
endmodule

module Alu_Mul_32_Ext (input [31:0] A, X, output [63:0] O);

	// A --> multiplicand
	// X --> multiplier
	// O --> output
	// Can add to 32 bit numbers (with 31 being the sign extension)
	
	wire [33:0] t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16;

	Alu_Mul_Row_Ext r1(A, {X[1:0], 1'b0}, 34'b0, t1);
	assign O[1:0] = t1[1:0];
	Alu_Mul_Row_Ext r2(A, X[3:1], {t1[33], t1[33], t1[33], t1[32:2]}, t2);
	assign O[3:2] = t2[1:0];
	Alu_Mul_Row_Ext r3(A, X[5:3], {t2[33], t2[33], t2[33], t2[32:2]}, t3);
	assign O[5:4] = t3[1:0];
	Alu_Mul_Row_Ext r4(A, X[7:5], {t3[33], t3[33], t3[33], t3[32:2]}, t4);
	assign O[7:6] = t4[1:0];
	Alu_Mul_Row_Ext r5(A, X[9:7], {t4[33], t4[33], t4[33], t4[32:2]}, t5);
	assign O[9:8] = t5[1:0];
	Alu_Mul_Row_Ext r6(A, X[11:9], {t5[33], t5[33], t5[33], t5[32:2]}, t6);
	assign O[11:10] = t6[1:0];
	Alu_Mul_Row_Ext r7(A, X[13:11], {t6[33], t6[33], t6[33], t6[32:2]}, t7);
	assign O[13:12] = t7[1:0];
	Alu_Mul_Row_Ext r8(A, X[15:13], {t7[33], t7[33], t7[33], t7[32:2]}, t8);
	assign O[15:14] = t8[1:0];
	Alu_Mul_Row_Ext r9(A, X[17:15], {t8[33], t8[33], t8[33], t8[32:2]}, t9);
	assign O[17:16] = t9[1:0];
	Alu_Mul_Row_Ext r10(A, X[19:17], {t9[33], t9[33], t9[33], t9[32:2]}, t10);
	assign O[19:18] = t10[1:0];
	Alu_Mul_Row_Ext r11(A, X[21:19], {t10[33], t10[33], t10[33], t10[32:2]}, t11);
	assign O[21:20] = t11[1:0];
	Alu_Mul_Row_Ext r12(A, X[23:21], {t11[33], t11[33], t11[33], t11[32:2]}, t12);
	assign O[23:22] = t12[1:0];
	Alu_Mul_Row_Ext r13(A, X[25:23], {t12[33], t12[33], t12[33], t12[32:2]}, t13);
	assign O[25:24] = t13[1:0];
	Alu_Mul_Row_Ext r14(A, X[27:25], {t13[33], t13[33], t13[33], t13[32:2]}, t14);
	assign O[27:26] = t14[1:0];
	Alu_Mul_Row_Ext r15(A, X[29:27], {t14[33], t14[33], t14[33], t14[32:2]}, t15);
	assign O[29:28] = t15[1:0];
	Alu_Mul_Row_Ext r16(A, X[31:29], {t15[33], t15[33], t15[33], t15[32:2]}, t16);
	assign O[63:30] = t16;

endmodule