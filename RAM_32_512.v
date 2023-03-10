module RAM_32_512(input Read, Write, input [31:0] data_in, input[8:0] address, input clk, output reg [31:0] data_out);

	// Basic synchronous ram implementation. Reads and writes always take 1 clock cycle

	reg [31:0] mem [511:0];
	initial begin: init
		integer i; 
		data_out <= 32'b0;
		// Give ram initial values
		for (i = 0; i < 512; i = i + 1) begin
			mem[i] = 32'b0;
		end
		
		/* Instructions */
		mem[0] = 32'h00800075; // ld R1, $75
		mem[1] = 32'h00080045; // ld R0, $45(R1) -> R1 = $B
		mem[2] = 32'h08800075; // ldi R1, $75
		mem[3] = 32'h08080045; // ldi R0, $45(R1) -> R1 = $13	
		mem[4] = 32'h12000090; // st $90, R4 -> R4 = $67
		mem[5] = 32'h12200090; // st $90(R4), -> R4 = $67
		mem[6] = 32'h611BFFFD; // add R2, R3, -4 -> R3 = $10	
		mem[7] = 32'h69180025; // andi R2, R3, $25 -> R3 = $FF23
		mem[8] = 32'h71180025; // ori R2, R3, $25 -> R3 = $FF23	
		mem[9] = 32'h9B000019; // brzr R6, 25
		mem[10] = 32'h9B080019; // brnz R6, 25
		mem[11] = 32'h9B100019; // brpl R6, 25
		mem[12] = 32'h9B180019;	// brmi R6, 25
	/* Data */
		mem['h50] = 32'h0000A0ED;
		mem['h75] = 32'h0000EADF; 
		
	end
	
	always @(posedge clk) begin
		if (Write & !Read) begin
			
			mem[address] <= data_in;
		end
		else if (!Write & Read) begin
			data_out <= mem[address];
		end
	end
	
endmodule