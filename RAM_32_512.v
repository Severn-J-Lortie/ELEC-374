module RAM_32_512(input Read, Write, input [31:0] data_in, input[8:0] address, input clk, output [31:0] data_out);

	// Basic synchronous ram implementation. Reads and writes always take 1 clock cycle

	reg [31:0] mem [511:0];
	initial begin: init
		integer i; 
		// Give ram initial values
		for (i = 0; i < 512; i = i + 1) begin
			mem[i] = 32'hFFFFFFFF;
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
		mem[9] = 32'hD0000000;
		mem[10] = 32'h9B900002;
		mem[11] = 32'h00000000;
		mem[12] = 32'h09880002;
		mem[13] = 32'h19918000;
		mem[14] = 32'h63B80002;
		mem[15] = 32'h8BB80000;
		mem[16] = 32'h93B80000;
		mem[17] = 32'h6BB8000F;
		mem[18] = 32'h50880000;
		mem[19] = 32'h7388001C;
		mem[20] = 32'h43B80000;
		mem[21] = 32'h39180000;
		mem[22] = 32'h11000052;
		mem[23] = 32'h59100000;
		mem[24] = 32'h31180000;
		mem[25] = 32'h28908000;
		mem[26] = 32'h11880060;
		mem[27] = 32'h21918000;
		mem[28] = 32'h48900000;
		mem[29] = 32'h0A000006;
		mem[30] = 32'h0A800032;
		mem[31] = 32'h7AA00000;
		mem[32] = 32'hC3800000;
		mem[33] = 32'hCB000000;
		mem[34] = 32'h82A00000;
		mem[35] = 32'h0C27FFFF;
		mem[36] = 32'h0CAFFFED;
		mem[37] = 32'h0D300000;
		mem[38] = 32'h0DB80000;
		mem[39] = 32'hAD000000;
		mem[40] = 32'hB2000000;
		mem[41] = 32'h12000095;
		mem[42] = 32'h0880002D;
		mem[43] = 32'h0B800001;
		mem[44] = 32'h0A800028;
		mem[45] = 32'hBA000000;
		mem[46] = 32'h0AAFFFFF;
		mem[47] = 32'h9A800008;
		mem[48] = 32'h030000F0;
		mem[49] = 32'h0B37FFFF;
		mem[50] = 32'hD0000000;
		mem[51] = 32'h9B0FFFFD;
		mem[52] = 32'h3A238000;
		mem[53] = 32'h9A0FFFF7;
		mem[54] = 32'h02000095;
		mem[55] = 32'hA0800000;
		mem[56] = 32'h0A0000A5;
		mem[57] = 32'hBA000000;
		mem[58] = 32'hD8000000;
		
		mem['h12c] = 32'h1EC50000;
		mem['h12d] = 32'h264D8000;
		mem['h12e] = 32'h26EE0000;
		mem['h12f] = 32'hA7800000;
		
		/* Data */
		mem['h68] = 32'h55;
		mem['h52] = 32'h26;
		mem['hf0] = 32'h10;

		
	end
	assign data_out = mem[address];
	always @(posedge clk) begin
		if (Write & !Read) begin
			
			mem[address] <= data_in;
		end
	end
	
endmodule