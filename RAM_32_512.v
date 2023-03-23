module RAM_32_512(input Read, Write, input [31:0] data_in, input[8:0] address, input clk, output [31:0] data_out);

	// Basic synchronous ram implementation. Reads and writes always take 1 clock cycle

	reg [31:0] mem [511:0];
	initial begin: init
		integer i; 
		// Give ram initial values
		for (i = 0; i < 512; i = i + 1) begin
			mem[i] = 32'b0;
		end
		
		/* Instructions */
		mem[0] = 32'h89A00000; 
		
		/* Data */

		
	end
	assign data_out = mem[address];
	always @(posedge clk) begin
		if (Write & !Read) begin
			
			mem[address] <= data_in;
		end
	end
	
endmodule