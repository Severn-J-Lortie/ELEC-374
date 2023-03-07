module RAM_32_512(input Read, Write, input [31:0] data_in, input[7:0] address, input clk, output reg [31:0] data_out);

	// Basic synchronous ram implementation. Reads and writes always take 1 clock cycle

	reg [31:0] mem [511:0];
	
	always @(posedge clk) begin
	
		if (Read & !Write) begin
		
			data_out = mem[address];
		
		else if (Write & !Read) begin
			
			mem[address] = data_in;
			
		end
	
	end
	
endmodule