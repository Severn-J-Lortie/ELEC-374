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
		mem[0] = 32'h08800002;
		mem[1] = 32'h08080000;
		mem[2] = 32'h01000068;
		mem[3] = 32'h0917FFFC;
		mem[4] = 32'h00900001;
		mem[5] = 32'h09800069;
		mem[6] = 32'h99980004;
		mem[7] = 32'h09980002;
		mem[8] = 32'h039FFFFD;
		mem[9] = 32'h9B900002;
		mem[10] = 32'hD9000005;
		mem[11] = 32'hD09880002;
		mem[12] = 32'h19918000;
		mem[13] = 32'h63B80002;
		mem[14] = 32'h8BB80000;
		mem[15] = 32'h93B80000;
		mem[16] = 32'h6BB8000F;
		mem[17] = 32'h50880000;
		mem[18] = 32'h7388001C;
		mem[19] = 32'h43B80000;
		mem[20] = 32'h39180000;
		mem[21] = 32'h11000052;
		mem[22] = 32'h59100000;
		mem[23] = 32'h31180000;
		mem[24] = 32'h28908000;
		mem[25] = 32'h11880060;
		mem[26] = 32'h21918000;
		mem[27] = 32'h48900000;
		mem[28] = 32'h0A000006;
		mem[29] = 32'h0A800032;
		mem[30] = 32'h7AA00000;
		mem[31] = 32'hC3800000;
		mem[32] = 32'hCB000000;
		mem[33] = 32'h82A00000;
		mem[34] = 32'h0C27FFFF;
		mem[35] = 32'h0CAFFFED;
		mem[36] = 32'h0D300000;
		mem[37] = 32'h0DB80000;
		mem[38] = 32'hAD000000;
		
		mem[40] = 32'hD8000000; // halt --> $28
		mem['h12c] = 32'h1EC50000;
		mem['h12d] = 32'h264D8000;
		mem['h12e] = 32'h26EE0000;
		mem['h12f] = 32'hDA7800000;
		
		/* Data */
		mem['h68] = 32'h55;
		mem['h52] = 32'h26;

		
	end
	assign data_out = mem[address];
	always @(posedge clk) begin
		if (Write & !Read) begin
			
			mem[address] <= data_in;
		end
	end
	
endmodule