module CON_FF(input [31:0] IR_bits, BusMuxOut, output CON);

	wire [3:0] decoder_out;
	wire eq, neq, geq, lt, nor_out, or_out; 
	Decoder_2_4 decoder(IR_bits[20:19], decoder_out);
	
	assign nor_out = ~|BusMuxOut;
	assign eq = nor_out & decoder_out[0]; 
	assign neq = ~nor_out & decoder_out[1];
	assign geq = ~BusMuxOut[31] & decoder_out[2];
	assign lt = BusMuxOut[31] & decoder_out[3];
	
	assign CON = (eq | neq) | (geq | lt); 	
	
endmodule