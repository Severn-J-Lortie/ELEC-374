module PC #(parameter INITIAL_VAL = 32'b0) (input [31:0] data, input inc, clk, clr, in, output [31:0] reg_out);

	wire [31:0] reg_in;
	wire reg_enable;
	assign reg_enable = in | inc; 
	assign reg_in = inc == 1 ? reg_out + 4 : data;
	Register_32 #(INITIAL_VAL) register(clr, clk, reg_enable, reg_in, reg_out);

endmodule