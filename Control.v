`timescale 1ns/10ps
module Control(
input clk, Reset, Stop, div_done,
input [31:0] IR,
output reg Run,

// Datapath control signals to be generated
output reg PCout, MDRout, Zhighout, Zlowout, HIin, LOin,
output reg MDRin, MARin, div_rst,
output reg Zin, Yin, IRin, PCin, Read, Write, IncPC,
output reg BAout, InPortout, OutPortin,
output reg Gra, Grb, Grc, Rin, Rout, Cout, CONin,
output reg HIout, LOout,
output reg AND, OR, ADD, SUB, MUL, DIV, SHR, 
output reg SHL, ROR, ROL, NEG, NOT, SHRA, BRANCH,

output reg R15in,
output reg [7:0] present_state
);


	parameter reset_state = 8'd0, fetch0 = 8'd1, fetch1 = 8'd2, fetch2 = 8'd3;
	parameter add3 = 8'd4, add4 = 8'd5, add5 = 8'd6; 
	parameter sub3 = 8'd7, sub4 = 8'd8, sub5 = 8'd9; 
	parameter and3 = 8'd10, and4 = 8'd11, and5 = 8'd12;
	parameter or3 = 8'd13, or4 = 8'd14, or5 = 8'd15; 
	parameter shr3 = 8'd16, shr4 = 8'd17, shr5 = 8'd18;
	parameter shra3 = 8'd19, shra4 = 8'd20, shra5 = 8'd21;
	parameter shl3 = 8'd22, shl4 = 8'd23, shl5 = 8'd24;
	parameter ror3 = 8'd25, ror4 = 8'd26, ror5 = 8'd27; 
	parameter rol3 = 8'd28, rol4 = 8'd29, rol5 = 8'd30;
	parameter addi3 = 8'd31, addi4 = 8'd32, addi5 = 8'd33;
	parameter andi3 = 8'd34, andi4 = 8'd35, andi5 = 8'd36;
	parameter ori3 = 8'd37, ori4 = 8'd38, ori5 = 8'd39;
	parameter mul3 = 8'd40, mul4 = 8'd41, mul5 = 8'd42,  mul6 = 8'd43;
	parameter div3 = 8'd44, div4 = 8'd45, div5 = 8'd46,  div6 = 8'd47, div7 = 8'd48;
	parameter neg3 = 8'd49, neg4 = 8'd50;
	parameter not3 = 8'd51, not4 = 8'd52;
	parameter br3 = 8'd53, br4 = 8'd54, br5 = 8'd55, br6 = 8'd56;
	parameter ld3 = 8'd57, ld4 = 8'd58, ld5 = 8'd59, ld6 = 8'd60, ld7 = 8'd61;
	parameter ldi3 = 8'd62, ldi4 = 8'd63, ldi5 = 8'd64;
	parameter st3 = 8'd65, st4 = 8'd66, st5 = 8'd67, st6 = 8'd68, st7 = 8'd69;
	parameter jr3 = 8'd70;
	parameter jal3 = 8'd71, jal4 = 8'd72, jal5 = 8'd73;
	parameter in3 = 8'd74;
	parameter out3 = 8'd75;
	parameter mfhi3 = 8'd76;
	parameter mflo3 = 8'd77;
	parameter halt3 = 8'd78;
	
	initial begin
		present_state = reset_state;
	end
	
	// Advance the state. Control signals will update on the 
	// negative edge of the clock. This allows for
	// some setup time so that the registers will latch
	// values on the positive edge
	always @(negedge clk, posedge Reset, posedge Stop) begin
	
		if (Reset == 1) begin
			present_state = reset_state;
		end
		else if (Stop == 1) begin
			present_state = halt3;
		end
		else begin
			case(present_state)
				reset_state : present_state = fetch0;
				fetch0 : present_state = fetch1;
				fetch1 : present_state = fetch2; 
				fetch2: begin
					case (IR[31:27])
						5'b00011: present_state = add3; 
						5'b00100: present_state = sub3;
						5'b00101: present_state = and3;
						5'b00110: present_state = or3;
						5'b00111: present_state = shr3;
						5'b01000: present_state = shra3;
						5'b01001: present_state = shl3;
						5'b01010: present_state = ror3;
						5'b01011: present_state = rol3;
						5'b01100: present_state = addi3;
						5'b01101: present_state = andi3;
						5'b01110: present_state = ori3;
						5'b01111: present_state = mul3;
						5'b10000: present_state = div3;
						5'b10001: present_state = neg3;
						5'b10010: present_state = not3;
						5'b10011: present_state = br3;
						5'b00000: present_state = ld3;
						5'b00001: present_state = ldi3;
						5'b00010: present_state = st3;
						5'b10100: present_state = jr3;
						5'b10101: present_state = jal3;
						5'b10110: present_state = in3;
						5'b10111: present_state = out3;
						5'b11000: present_state = mfhi3;
						5'b11001: present_state = mflo3;
						5'b11010: present_state = reset_state;
						5'b11011: present_state = halt3;
					endcase
				end
				add3: present_state = add4;
				add4: present_state = add5;
				add5: present_state = reset_state;
				
				sub3: present_state = sub4;
				sub4: present_state = sub5;
				sub5: present_state = reset_state; 
				
				and3: present_state = and4;
				and4: present_state = and5;
				and5: present_state = reset_state;
				
				or3: present_state = or4;
				or4: present_state = or5;
				or5: present_state = reset_state;
				
				shr3: present_state = shr4;
				shr4: present_state = shr5;
				shr5: present_state = reset_state;
				
				shra3: present_state = shra4;
				shra4: present_state = shra5;
				shra5: present_state = reset_state;

				shl3: present_state = shl4;
				shl4: present_state = shl5;
				shl5: present_state = reset_state;
				
				ror3: present_state = ror4;
				ror4: present_state = ror5;
				ror5: present_state = reset_state;

				rol3: present_state = rol4;
				rol4: present_state = rol5;
				rol5: present_state = reset_state;
				
				
				addi3: present_state = addi4;
				addi4: present_state = addi5;
				addi5: present_state = reset_state;
				
				andi3: present_state = andi4;
				andi4: present_state = andi5;
				andi5: present_state = reset_state;
				
				ori3: present_state = ori4;
				ori4: present_state = ori5;
				ori5: present_state = reset_state;
				
				mul3: present_state = mul4;
				mul4: present_state = mul5;
				mul5: present_state = mul6;
				mul6: present_state = reset_state;
				
				div3: present_state = div4;
				div4: begin
							if (div_done) begin
								present_state = div5;
							end
						end
				div5: present_state = div6;
				div6: present_state = div7;
				div7: present_state = reset_state;	
				
				neg3: present_state = neg4;
				neg4: present_state = reset_state;
				
				not3: present_state = not4;
				not4: present_state = reset_state;
				
				br3: present_state = br4;
				br4: present_state = br5;
				br5: present_state = br6;
				br6: present_state = reset_state;
				
				ld3: present_state = ld4;
				ld4: present_state = ld5;
				ld5: present_state = ld6;
				ld6: present_state = ld7;
				ld7: present_state = reset_state;
				
				ldi3: present_state = ldi4;
				ldi4: present_state = ldi5;
				ldi5: present_state = reset_state;
				
				st3: present_state = st4;
				st4: present_state = st5;
				st5: present_state = st6;
				st6: present_state = st7;
				st7: present_state = reset_state;
				
				jr3: present_state = reset_state;
				
				jal3: present_state = jal4;
				jal4: present_state = jal5;
				jal5: present_state = reset_state;
				
				in3: present_state = reset_state;
				
				out3: present_state = reset_state;
				
				mfhi3: present_state = reset_state;
				
				mflo3: present_state = reset_state;
				
			endcase
		end
	end
	
	// Generate control signals based on the current state, IR, and other inputs
	always @(present_state) begin
		case(present_state)
			reset_state: begin
				PCout <= 0; MDRout <= 0; Zhighout <= 0; Zlowout <= 0;
				HIout <= 0; LOout <= 0; MDRin <= 0; MARin <= 0;
				div_rst <= 0; Zin <= 0; Yin <= 0; HIin <=0; LOin <= 0;
				IRin <= 0; PCin <= 0; Read <= 0; Write <= 0; IncPC <= 0;
				BAout <= 0; InPortout <= 0; OutPortin <= 0; Gra <= 0;
				Grb <= 0; Grc <= 0; Rin <= 0; Rout <= 0; Cout <= 0;
				CONin <= 0; AND <= 0; OR <= 0; ADD <= 0; SUB <= 0;
				MUL <= 0; DIV <= 0; SHR <= 0; SHL <= 0; ROR <= 0;
				ROL <= 0; NEG <= 0; NOT <= 0; SHRA <= 0; BRANCH <= 0;
				R15in <= 0; Run <= 1;
			end
			fetch0: begin
				PCout<= 1; MARin <= 1; 
			end
			fetch1: begin
				PCout <= 0; MARin <= 0;
				IncPC <= 1; Read <= 1; 
				MDRin <= 1;
			end
			fetch2: begin
				MDRin <= 0; Read <= 0;
				IncPC <= 0; 
				MDRout<= 1; IRin <= 1;
			end
/*****************************************************/
			add3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			add4: begin 
				Grb <= 0; Yin <= 0;
				Grc <= 1; ADD <= 1; Zin <= 1; 
			end
			add5: begin
				Grc <= 0; ADD <= 0; Zin <= 0; Rout <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/
			sub3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			sub4: begin 
				Grb <= 0; Yin <= 0;
				Grc <= 1; SUB <= 1; Zin <= 1; 
			end
			sub5: begin
				Grc <= 0; SUB <= 0; Zin <= 0; Rout <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/
			and3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			and4: begin 
				Grb <= 0; Yin <= 0;
				Grc <= 1; AND <= 1; Zin <= 1; 
			end
			and5: begin
				Grc <= 0; AND <= 0; Zin <= 0; Rout <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/			
			or3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			or4: begin 
				Grb <= 0; Yin <= 0;
				Grc <= 1; OR <= 1; Zin <= 1; 
			end
			or5: begin
				Grc <= 0; OR <= 0; Zin <= 0; Rout <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/				
			shr3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			shr4: begin 
				$display(present_state);
				Grb <= 0; Yin <= 0;
				Grc <= 1; SHR <= 1; Zin <= 1; 
			end
			shr5: begin
				Grc <= 0; SHR <= 0; Zin <= 0; Rout <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/
			shra3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			shra4: begin 
				Grb <= 0; Yin <= 0;
				Grc <= 1; SHRA <= 1; Zin <= 1; 
			end
			shra5: begin
				Grc <= 0; SHRA <= 0; Zin <= 0; Rout <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end	
/*****************************************************/			
			shl3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			shl4: begin 
				Grb <= 0; Yin <= 0;
				Grc <= 1; SHL <= 1; Zin <= 1; 
			end
			shl5: begin
				Grc <= 0; SHL <= 0; Zin <= 0; Rout <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/
			ror3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			ror4: begin 
				Grb <= 0; Yin <= 0;
				Grc <= 1; ROR <= 1; Zin <= 1; 
			end
			ror5: begin
				Grc <= 0; ROR <= 0; Zin <= 0; Rout <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/			
			rol3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			rol4: begin 
				Grb <= 0; Yin <= 0;
				Grc <= 1; ROL <= 1; Zin <= 1; 
			end
			rol5: begin
				Grc <= 0; ROL <= 0; Zin <= 0; Rout <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/			
			addi3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			addi4: begin 
				Grb <= 0; Rout <= 0; Yin <= 0;
				Cout <= 1; ADD <= 1; Zin <= 1;
			end
			addi5: begin
				Cout <= 0; ADD <= 0; Zin <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/
			andi3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			andi4: begin 
				Grb <= 0; Rout <= 0; Yin <= 0;
				Cout <= 1; AND <= 1; Zin <= 1;
			end
			andi5: begin
				Cout <= 0; AND <= 0; Zin <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/
			ori3: begin
				MDRout <= 0; IRin <= 0;
				Grb <= 1; Rout <= 1; Yin <= 1;
			end
			ori4: begin 
				Grb <= 0; Rout <= 0; Yin <= 0;
				Cout <= 1; OR <= 1; Zin <= 1;
			end
			ori5: begin
				Cout <= 0; OR <= 0; Zin <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/
			mul3: begin
				MDRout <= 0; IRin <= 0;
				Gra <= 1; Rout <= 1; Yin <= 1;
			end
			mul4: begin 
				Gra <= 0; Yin <= 0;
				Grb <= 1; MUL <= 1; Zin <= 1;
			end
			mul5: begin
				Rout <= 0; MUL <= 0; Zin <= 0; Grb <= 0;
				Zlowout <= 1; LOin <= 1;
			end
			mul6: begin
				Zlowout <= 0; LOin <= 0;
				Zhighout <= 1; HIin <= 1;
			end				
/*****************************************************/
			div3: begin
				MDRout <= 0; IRin <= 0;
				Gra <= 1; Rout <= 1; Yin <= 1;
			end
			div4: begin 
				Gra <= 0; Yin <= 0;
				Grb <= 1; DIV <= 1; 
			end
			div5: begin
				Zin <= 1;
			end
			div6: begin
				Rout <= 0;  Grb <= 0; 
				DIV <= 0; Zin <= 0;  
				div_rst <= 1;
				Zlowout <= 1; LOin <= 1;
			end
			div7: begin
				div_rst <= 0;
				Zlowout <= 0; LOin <= 0;
				Zhighout <= 1; HIin <= 1;
			end
/*****************************************************/
			neg3: begin
				MDRout <= 0; IRin <= 0; 
				Grb <= 1; Rout <= 1; NEG <= 1;
				Zin <= 1;
			end
			neg4: begin 
				Grb <= 0; Rout <= 0; NEG <= 0; Zin <= 0;
				Gra <= 1; Rin <= 1; Zlowout <=1;
			end
/*****************************************************/
			not3: begin
				MDRout <= 0; IRin <= 0; 
				Grb <= 1; Rout <= 1; NOT <= 1;
				Zin <= 1;
			end
			not4: begin 
				Grb <= 0; Rout <= 0; NOT <= 0; Zin <= 0;
				Gra <= 1; Rin <= 1; Zlowout <=1;
			end
/*****************************************************/
			br3: begin
				MDRout <= 0; IRin <= 0; 
				Gra <= 1; Rout <= 1; CONin <= 1;
			end
			br4: begin 
				Gra <= 0; Rout <= 0; CONin <= 0;
				PCout <= 1; Yin <= 1;
			end
			br5: begin 
				PCout <= 0; Yin <= 0;
				Cout <= 1; BRANCH <= 1; Zin <= 1;
			end
			br6: begin 
				Cout <= 0; BRANCH <= 0; Zin <= 0;
				Zlowout <= 1; PCin <= 1;
			end
/*****************************************************/
			ld3: begin
				MDRout <= 0; IRin <= 0; 
				Grb <= 1; BAout <= 1; Yin <= 1;
			end
			ld4: begin 
				Grb <= 0; BAout <= 0; Yin <= 0;
				Cout <= 1; ADD <= 1; Zin <= 1;
			end
			ld5: begin 
				Cout <= 0; ADD <= 0; Zin <= 0;
				Zlowout <= 1; MARin <= 1;
			end
			ld6: begin 
				Zlowout <= 0; MARin <= 0;
				Read <= 1; MDRin <= 1;
			end
			ld7: begin 
				Read <= 0; MDRin <= 0;
				MDRout <= 1; Gra <= 1; Rin <= 1; 
			end
/*****************************************************/
			ldi3: begin
				MDRout <= 0; IRin <= 0; 
				Grb <= 1; BAout <= 1; Yin <= 1;
			end
			ldi4: begin 
				Grb <= 0; BAout <= 0; Yin <= 0;
				Cout <= 1; ADD <= 1; Zin <= 1;
			end
			ldi5: begin 
				Cout <= 0; ADD <= 0; Zin <= 0;
				Zlowout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/
			st3: begin
				IRin <= 0; MDRout <= 0;
				Grb <= 1; BAout <= 1; Yin <= 1;
			end
			st4: begin 
				Grb <= 0; BAout <= 0; Yin <= 0; 
				Cout <= 1; ADD <= 1; Zin <= 1;
			end
			st5: begin 
				Cout <= 0; ADD <= 0; Zin <= 0;
				Zlowout <= 1; MARin <= 1;
			end
			st6: begin 
				Zlowout <= 0; MARin <= 0;
				MDRin <= 1; Gra <= 1; BAout <= 1; 
			end
			st7: begin 
				MDRin <= 0; Gra <= 0; BAout <= 0;
				MDRout <= 1; Write <= 1;
			end
/*****************************************************/
			jr3: begin
				IRin <= 0; MDRout <= 0;
				Gra <= 1; Rout <= 1; PCin <= 1;
			end
/*****************************************************/
			jal3: begin
				IRin <= 0; MDRout <= 0;
				//IncPC <= 1;
			end
			jal4: begin
				//IncPC <= 0; 
				R15in <= 1; PCout <= 1;
			end
			jal5: begin
				PCout <= 0; R15in <= 0;
				Gra <=1; Rout <= 1; PCin <= 1;
			end
/*****************************************************/
			in3: begin
				MDRout<= 0; IRin <= 0;
				Gra <= 1; Rin <= 1; InPortout <= 1;
			end
/*****************************************************/
			out3: begin
				MDRout<= 0; IRin <= 0;
				Gra <= 1; Rout <= 1; OutPortin <= 1;
			end
/*****************************************************/
			mfhi3: begin
				MDRout<= 0; IRin <= 0;
				HIout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/
			mflo3: begin
				MDRout<= 0; IRin <= 0;
				LOout <= 1; Gra <= 1; Rin <= 1;
			end
/*****************************************************/
			halt3: begin
				Run <= 0;
			end

		endcase
	end

endmodule