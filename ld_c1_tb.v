`timescale 1ns/10ps

module datapath_ld_c1_inst(
		// Input control signals
		input PCout, MARin, IncPC, Zin, Zlowout, 
		input PCin, Read, Write, MDRin, MDRout,
		input IRin, BAout, Yin,  ADD, Rin, Rout,
		input clr, clk,
		// Instruction field signals
		input Grb, Gra, Cout, 
		// Register fields
		output [31:0] R1dataout, R0dataout,
		// Monitoring signals
		output [15:0] register_outs, register_ins,
		output [31:0] BusMuxOut, MDRdataout, RAMdataout,
		output [31:0] Zlowdataout, IRdataout, MARdataout, PCdataout
);
	Datapath DUT
	(
		// Input control signals
		.PCout(PCout), .MARin(MARin), 
		.IncPC(IncPC), .Zin(Zin), .Zlowout(Zlowout), 
		.PCin(PCin), .Read(Read), .MDRin(MDRin), .MDRout(MDRout),
		.IRin(IRin),  .BAout(BAout), .Yin(Yin), .Zhighout(0), .Grc(0),
		.ADD(ADD), .Rin(Rin), .Rout(Rout), .Write(Write),
		.clr(clr), .clk(clk),
		// Instruction field signals
		.Grb(Grb), .Gra(Gra), .Cout(Cout), 
		// Register fields
		.R1dataout(R1dataout), .R0dataout(R0dataout),
		// Monitoring signals
		.register_outs(register_outs), .register_ins(register_ins),
		.BusMuxOut(BusMuxOut), .MARdataout(MARdataout), .RAMdataout(RAMdataout),
		.Zlowdataout(Zlowdataout), .IRdataout(IRdataout), .MDRdataout(MDRdataout),
		.PCdataout(PCdataout)
	);
endmodule 

module ld_c1_tb;
	/*
		Testbench signal setup. You'll need to update
		any changed signals here in the port list for
		the DUT instance, as well as the DUT in the testbench
	*/
	// Input control signals
   reg PCout, MARin, IncPC, Zin, Zlowout; 
	reg PCin, Read, MDRin, MDRout, Write;
	reg IRin, BAout, Yin,  ADD, Rin, Rout;
	// Instruction field signals
	reg Grb, Gra, Cout;
	// Register fields
	wire [31:0] R1dataout, R0dataout;
	// Monitoring signals
	wire [15:0] register_outs, register_ins;
	wire [31:0] BusMuxOut, MDRdataout, RAMdataout;
	wire [31:0] Zlowdataout, IRdataout, MARdataout;
	wire [31:0] PCdataout;
 	// Simulation generated signals
   reg Clock, clr;

   parameter Default = 4'b0000, T0= 4'b0001, T1= 4'b0010,T2= 4'b0011, 
	T3= 4'b0100, T4= 4'b0101, T5= 4'b0110, T6 = 4'b0111, T7 = 5'b1000;

   reg[3:0] Present_state= Default;

	datapath_ld_c1_inst DUT(
		// Input control signals
		PCout, MARin, IncPC, Zin, Zlowout, 
		PCin, Read, Write, MDRin, MDRout,
		IRin, BAout, Yin,  ADD, Rin, Rout,
		clr, Clock,
		// Instruction field signals
		Grb, Gra, Cout, 
		// Register fields
		R1dataout, R0dataout,
		// Monitoring signals
		register_outs, register_ins,
		BusMuxOut, MDRdataout, RAMdataout,
		Zlowdataout, IRdataout, MARdataout, PCdataout
	);
	
	// add test logic here
	initial begin
		 Clock = 0;
		 forever #10 Clock = ~Clock;
	end

	always @(posedge Clock)//finite state machine; if clock rising-edge
		 begin
			  case (Present_state)
					Default     : Present_state = T0;
					T0          : #40  Present_state = T1;
					T1          : #40  Present_state = T2;
					T2          : #40  Present_state = T3;
					T3          : #40  Present_state = T4;
					T4          : #40  Present_state = T5;
					T5				: #40  Present_state = T6;
					T6				: #40  Present_state = T7;
			  endcase
		 end

	always @(Present_state)// do the required job ineach state
		 begin
			  case (Present_state) //assert the required signals in each clock cycle
					Default: begin
						clr <= 1;
						// Input control signals
						PCout <= 0; MARin <= 0; IncPC <= 0; 
						Zin <= 0; Zlowout <= 0; PCin <= 0; 
						Read <= 0; MDRin <= 0; MDRout <= 0;
						IRin <= 0; BAout <= 0; Yin <= 0;  
						ADD <= 0; Rin <= 0; Rout <= 0; Write <= 0;
						// Instruction field signals
						Grb <= 0; Gra <= 0; Cout <=0;
						#5
						clr <= 0;
					end
					T0: begin
						PCout<= 1; MARin <= 1; 
					end
					T1: begin
						PCout <= 0;
						IncPC <= 1;
						MARin <= 0;
						 
						Read <= 1; MDRin <= 1;

						#25
						IncPC <= 0;
					end
					T2: begin
						//Zlowout <= 0;
						MDRin <= 0; Read <= 0;
						MDRout<= 1; IRin <= 1;
					end
					T3: begin
						IRin <= 0; MDRout <= 0;
						Grb <= 1; BAout <= 1; Yin <= 1;
					end
					T4: begin
						Grb <= 0; BAout <= 0; Yin <= 0; 
						Cout <= 1; ADD <= 1; Zin <= 1;
					end
					T5: begin
						Cout <= 0; ADD <= 0; Zin <= 0;
						Zlowout <= 1; MARin <= 1;
					end
					T6: begin
						Zlowout <= 0; MARin <= 0;
						Read <= 1; MDRin <= 1;
					end
					T7: begin
						Read <= 0; MDRin <= 0;
						MDRout <= 1; Gra <= 1; Rin <= 1; 
					end
			  endcase
		 end
endmodule
