`timescale 1ns/10ps

module datapath_rol_inst(
input PCout, Zlowout, MDRout, R4out, R6out, MARin, 
input Zin, PCin, MDRin, IRin, Yin, IncPC,Read, ROL, 
input R4in, R6in, Clock, clr,
input [31:0] Mdatain,
output [31:0] R4, R6, BusMuxOut, MDR, PC, MAR, IR, Zlow
);


	Datapath DUT(.PCout(PCout), .Zlowout(Zlowout), .MDRout(MDRout), .R4out(R4out), 
			.R6out(R6out), .MARin(MARin), .Zin(Zin), .PCin(PCin), 
			.MDRin(MDRin), .IRin(IRin), .Yin(Yin), .IncPC(IncPC), .Read(Read), 
			.ROL(ROL), .R4in(R4in), .R6in(R6in), .clk(Clock), .clr(clr), .Mdatain(Mdatain),
			.R4dataout(R4), .R6dataout(R6), .BusMuxOut(BusMuxOut), .MDRdataout(MDR),
			.R0out(0), .R1out(0), .R2out(0), .R3out(0), .R5out(0), .R7out(0),
			.R8out(0), .R9out(0), .R10out(0), .R11out(0), .R12out(0), 
			.R13out(0), .R14out(0), .R15out(0), .Zhighout(0), .PCdataout(PC), .MARdataout(MAR),
			.IRdataout(IR), .Zlowdataout(Zlow));
endmodule 

module rol_tb;
   reg PCout, Zlowout, MDRout, R4out, R6out;
    
	// add any other signals to see in your simulation
	wire [31:0] R4, R6, BusMuxOut, MDR, PC, MAR, IR, Zlow;
   reg MARin, Zin, PCin, MDRin, IRin, Yin;
   reg IncPC,Read, ROL, R4in, R6in;
   reg Clock, clr;
   reg[31:0] Mdatain;

   parameter Default = 4'b0000, Reg_load1a= 4'b0001, Reg_load1b= 4'b0010, Reg_load2a= 4'b0011, Reg_load2b = 4'b0100, Reg_load3a = 4'b0101,
				  Reg_load3b = 4'b0110, T0= 4'b0111, T1= 4'b1000,T2= 4'b1001, T3= 4'b1010, T4= 4'b1011, T5= 4'b1100;

   reg[3:0] Present_state= Default;

	datapath_rol_inst DUT(PCout, Zlowout, MDRout, R4out, R6out, MARin, Zin, PCin, 
				MDRin, IRin, Yin, IncPC,Read, ROL, R4in, R6in, Clock, clr, Mdatain, 
				R4, R6, BusMuxOut, MDR, PC, MAR, IR, Zlow);
	
	// add test logic here
	initial begin
		 Clock = 0;
		 forever #10 Clock = ~Clock;
	end

	always @(posedge Clock)//finite state machine; if clock rising-edge
		 begin
			  case (Present_state)
					Default     : Present_state = Reg_load1a;
					Reg_load1a  : #40  Present_state = Reg_load1b;
					Reg_load1b  : #40  Present_state = Reg_load2a;
					Reg_load2a  : #40  Present_state = Reg_load2b;
					Reg_load2b  : #40  Present_state = Reg_load3a;
					Reg_load3a  : #40  Present_state = Reg_load3b;
					Reg_load3b  : #40  Present_state = T0;
					T0          : #40  Present_state = T1;
					T1          : #40  Present_state = T2;
					T2          : #40  Present_state = T3;
					T3          : #40  Present_state = T4;
					T4          : #40  Present_state = T5;
			  endcase
		 end

	always @(Present_state)// do the required job ineach state
		 begin
			  case (Present_state) //assert the required signals in each clock cycle
					Default: begin
						clr <= 1;
						PCout <= 0; Zlowout <= 0; MDRout<= 0;  //initialize the signals
						R4out <= 0; R6out <= 0; MARin <= 0; Zin <= 0;
						PCin <=0; MDRin <= 0; IRin  <= 0; Yin <= 0;
						IncPC <= 0; Read <= 0; ROL <= 0;
						R4in <= 0; R6in <= 0; Mdatain <= 32'h00000000;
						#5
						clr <= 0;
					end
					Reg_load1a: begin 
						Mdatain<= 32'h00000022;
						Read = 0; MDRin = 0; //the first zero is there for completeness
						#10 Read <= 1; MDRin <= 1;
						#15 Read <= 0; MDRin <= 0;
					end
					Reg_load1b: begin
						#10 MDRout<= 1; R6in <= 1;
						#15 MDRout<= 0; R6in <= 0; // initialize R6 with the value $22
					end
					Reg_load2a: begin 
						Mdatain <= 32'h00000002;
						#10 Read <= 1; MDRin <= 1;
						#15 Read <= 0; MDRin <= 0;
					end
					Reg_load2b: begin
						#10 MDRout<= 1; R4in <= 1;
						#15 MDRout<= 0; R4in <= 0; // initialize R4 with the value $2 
					end
					Reg_load3a: begin 
						Mdatain <= 32'h00000026;
						#10 Read <= 1; MDRin <= 1;
						#15 Read <= 0; MDRin <= 0;
					end
					Reg_load3b: begin
						/*#10 MDRout<= 1; R1in <= 1;
						#15 MDRout<= 0; R1in <= 0; // initialize R1 with the value $26 */
					end
					T0: begin//see if you need to de-assert these signals
						PCout<= 1; MARin <= 1; 
					end
					T1: begin
						PCout <= 0;
						IncPC <= 1;
						MARin <= 0;
						 
						/*Zlowout<= 1; PCin <= 1;*/ Read <= 1; MDRin <= 1;
						Mdatain <= 32'h2D550000; //opcode for “and R5, R2, R4”
						#25
						IncPC <= 0;
					end
					T2: begin
						//Zlowout <= 0;
						MDRout<= 1; IRin <= 1;
					end
					T3: begin
						MDRout <= 0; IRin <= 0;
						R6out<= 1; Yin <= 1;
					end
					T4: begin
						R6out <= 0; Yin <= 0;
						R4out<= 1; ROL <= 1; Zin <= 1;
						
						// Deassert 
						#25 Zin <= 0; 
					end
					T5: begin
						R4out <= 0;
						Zlowout<= 1; R6in <= 1;
					end
			  endcase
		 end
endmodule
