module Select_Encode(
input [31:0] IR_bits, 
input Gra, Grb, Grc, Rin,  
input Rout, BAout, 

output [31:0] register_outs,
output [31:0] register_ins
);

	wire [3:0] Ra, Rb, Rc, and_a;
	wire [3:0] and_b, and_c, or_out; 
	wire [15:0] decoder_out; 
	
	// Partition IR bits
	assign Ra = IR_bits[26:23];
	assign Rb = IR_bits[22:19];
	assign Rc = IR_bits[18:15];
	
	// Determine which register field to pass to decoder
	assign and_a = Ra & {4{Gra}}; 
	assign and_b = Rb & {4{Grb}}; 
	assign and_c = Rc & {4{Grc}}; 
	assign or_out = and_a | and_b | and_c;  
	
	Decoder_4_16 decoder(or_out, decoder_out);
	
	wire gate_bus_enabled;
	assign gate_bus_enabled = BAout | Rout;
	
	// Generate output signals from decoder 
	// and Rin, Rout, and Baout inputs
	
	// Rin
	assign register_ins = {16{Rin}} & decoder_out; 
	
	// Rout
	assign register_outs = {16{gate_bus_enabled}} & decoder_out; 
	
endmodule