
module Multiplexer_32_1 (
	input [4:0] select,
 	input [31:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, 
	in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, 
	in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31,
	output reg [31:0] MuxOut
);

	always@(*) begin
		case(select)
			5'd0 : MuxOut <= in0;
			5'd1 : MuxOut <= in1;
			5'd2 : MuxOut <= in2;
			5'd3 : MuxOut <= in3;
			5'd4 : MuxOut <= in4;
			5'd5 : MuxOut <= in5;
			5'd6 : MuxOut <= in6;
			5'd7 : MuxOut <= in7;
			5'd8 : MuxOut <= in8;
			5'd9 : MuxOut <= in9;
			5'd10 : MuxOut <= in10;
			5'd11 : MuxOut <= in11;
			5'd12 : MuxOut <= in12;
			5'd13 : MuxOut <= in13;
			5'd14 : MuxOut <= in14;
			5'd15 : MuxOut <= in15;
			5'd16 : MuxOut <= in16;
			5'd17 : MuxOut <= in17;
			5'd18 : MuxOut <= in18;
			5'd19 : MuxOut <= in19;
			5'd20 : MuxOut <= in20;
			5'd21 : MuxOut <= in21;
			5'd22 : MuxOut <= in22;
			5'd23 : MuxOut <= in23;
			5'd24 : MuxOut <= in24;
			5'd25 : MuxOut <= in25;
			5'd26 : MuxOut <= in26;
			5'd27 : MuxOut <= in27;
			5'd28 : MuxOut <= in28;
			5'd29 : MuxOut <= in29;
			5'd30 : MuxOut <= in30;
			5'd31 : MuxOut <= in31;
			default: MuxOut <= 32'b0;
		endcase
	end
endmodule