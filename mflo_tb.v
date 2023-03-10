`timescale 1ns/10ps

module datapath_mflo_inst(
		// Input control signals
		input PCout, MARin, IncPC, 
		input Read, Write, MDRin, MDRout,
		input IRin, Rin,
		input LOout,
		input clr, clk,
		// Instruction field signals
		input Gra, 
		// Register fields
		output [31:0] R6dataout, LOdataout,
		// Monitoring signals
		output [15:0] register_outs, register_ins,
		output [31:0] BusMuxOut, MDRdataout, RAMdataout,
		output [31:0] Zlowdataout, IRdataout, MARdataout, PCdataout
);
	Datapath DUT
	(
		// Input control signals
		.PCout(PCout), .MARin(MARin), 
		.IncPC(IncPC), .BAout(0), .Rout(0),
		.Read(Read), .MDRin(MDRin), .MDRout(MDRout),
		.IRin(IRin),
		.Rin(Rin), .Write(Write),
	   .LOout(LOout), .LOdataout(LOdataout),
		.clr(clr), .clk(clk),
		// Instruction field signals
		.Gra(Gra), 
		// Register fields
		.R6dataout(R6dataout),
		// Monitoring signals
		.register_outs(register_outs), .register_ins(register_ins),
		.BusMuxOut(BusMuxOut), .MARdataout(MARdataout), .RAMdataout(RAMdataout),
		.Zlowdataout(Zlowdataout), .IRdataout(IRdataout), .MDRdataout(MDRdataout),
		.PCdataout(PCdataout)
	);
	defparam DUT.I_PC = 32'b10000;
	defparam DUT.I_LO = 32'h15A;
endmodule 

module mflo_tb;
	/*
		Testbench signal setup. You'll need to update
		any changed signals here in the port list for
		the DUT instance, as well as the DUT in the testbench
		
		Instruction: brzr R6, 25 --> R6 = non-zero/zero
	*/
	// Input control signals
   reg PCout, MARin, IncPC; 
	reg Read, MDRin, MDRout, Write;
	reg IRin, Rin;
	reg LOout;
	// Instruction field signals
	reg Gra;
	// Register fields
	wire [31:0] R6dataout, LOdataout;
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

	datapath_mflo_inst DUT(
		// Input control signals
		PCout, MARin, IncPC, 
		Read, Write, MDRin, MDRout,
		IRin, Rin,
		LOout,
		clr, Clock,
		// Instruction field signals
		Gra, 
		// Register fields
		R6dataout, LOdataout,
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
			  endcase
		 end

	always @(Present_state)// do the required job ineach state
		 begin
			  case (Present_state) //assert the required signals in each clock cycle
					Default: begin
						// Input control signals
						PCout <= 0; MARin <= 0; IncPC <= 0; 
						Read <= 0; MDRin <= 0; MDRout <= 0;
						IRin <= 0;
					   Rin <= 0; Write <= 0; LOout <= 0;
						// Instruction field signals
						Gra <= 0;
						clr <= 0; // Clear is never set to allow register initial val parameters to work
					end
					T0: begin
						PCout<= 1; MARin <= 1; 
					end
					T1: begin
						PCout <= 0; MARin <= 0;
						IncPC <= 1;
						
						 
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
						MDRout<= 0; IRin <= 0;
						LOout <= 1; Gra <= 1; Rin <= 1;
					end
			  endcase
		 end
endmodule
