module RAM_32_512(input Read, Write, input [31:0] data_in, input[8:0] address, input clk, output reg [31:0] data_out);

	// Basic synchronous ram implementation. Reads and writes always take 1 clock cycle

	reg [31:0] mem [511:0];
	
	initial begin: init
		integer i; 
		// Give ram initial values
		for (i = 0; i < 512; i = i + 1) begin
			mem[i] = 32'b0;
		end
		mem[0] = 32'h00800075;
		mem['h75] = 32'h0000EADF;
	end
	
	always @(posedge clk) begin
		if (Write & !Read) begin
			
			mem[address] <= data_in;
		
		end
		data_out <= mem[address];
	
	end
	
endmodule