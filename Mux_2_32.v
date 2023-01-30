module Mux_2_32 (output [31:0] mux_out, input [31:0] data_0, data_1, input select);

	assign mux_out = select ? data_1 : data_0;
	
endmodule