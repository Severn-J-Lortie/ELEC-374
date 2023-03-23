`timescale 1ns/10ps
module control_tb;

	reg clr, clk;
	
	// Monitoring signals
	wire [31:0] IRdataout, PCdataout;
	wire [31:0] BusMuxOut, MDRdataout;
	wire [31:0] MARdataout, R0dataout;
	wire [31:0] R1dataout, R2dataout;
	wire [31:0] R3dataout, R4dataout;
	wire [31:0] R5dataout, R6dataout;
	wire [31:0] R7dataout, R8dataout;
	wire [31:0] R9dataout, R10dataout;
	wire [31:0] R11dataout, R12dataout;
	wire [31:0] R13dataout, R14dataout;
	wire [31:0] R15dataout;
	wire [7:0] present_state;
	
	MiniSRC cpu(
	.clr(clr), .clk(clk), .IRdataout(IRdataout), 
	.PCdataout(PCdataout), .BusMuxOut(BusMuxOut), 
	.MDRdataout(MDRdataout), .MARdataout(MARdataout), 
	.present_state(present_state),
	
	.R1dataout(R1dataout), .R2dataout(R2dataout),
	.R3dataout(R3dataout), .R4dataout(R4dataout),
	.R5dataout(R5dataout), .R6dataout(R6dataout),
	.R7dataout(R7dataout), .R8dataout(R8dataout),
	.R9dataout(R9dataout), .R10dataout(R10dataout),
	.R11dataout(R11dataout), .R12dataout(R12dataout),
	.R13dataout(R13dataout), .R14dataout(R14dataout),
	.R15dataout(R15dataout), .R0dataout(R0dataout)
	);
	
	initial begin
		clr <= 0; clk = 1;
		
		// Assert clear to start the CPU
		clr <= 0;
		#10;
		clr <= 0; 
		
		forever begin
			#10 clk = ~clk;
		end
	end
	


endmodule