`timescale 1ns/10ps
module select_encode_tb;

	reg [31:0] IR_bits;
	reg Gra, Grb, Grc, Rin;
	reg Rout, BAout;
	wire [15:0] register_ins, register_outs;
	
	Select_Encode DUT(IR_bits, Gra, Grb, Grc, Rin, Rout, BAout, register_outs, register_ins);
	
	initial begin
	
		// Test register field a (r5) input
		IR_bits = 32'h4A920000;
		Gra = 1;
		Grb = 0;
		Grc = 0;
		Rin = 1;
		Rout = 0;
		BAout = 0; 
		#50; 
		
		// Test register field b (r2) input
		IR_bits = 32'h4A920000;
		Gra = 0;
		Grb = 1;
		Grc = 0;
		Rin = 1;
		Rout = 0;
		BAout = 0; 
		#50; 
		
		// Test register field c (r4) input
		IR_bits = 32'h4A920000;
		Gra = 0;
		Grb = 0;
		Grc = 1;
		Rin = 1;
		Rout = 0;
		BAout = 0; 
		#50; 
		
		// Test register field c (r4) output
		IR_bits = 32'h4A920000;
		Gra = 0;
		Grb = 0;
		Grc = 1;
		Rin = 0;
		Rout = 0;
		BAout = 1; 
		#50; 
	
	end

endmodule