`ifndef __RANDOMIC_CA_PARIT_BASED__
`define __RANDOMIC_CA_PARIT_BASED__

`include "ca/DynamicBinaryCellularAutomata2D.v"


module RandomicCAParitBased #(
	parameter Width = 32,
	parameter ParitWidth = 3,
	parameter CAWidth = Width * ParitWidth

) (
	input clk,
	input rst,
	input ce,
	output [Width-1:0]random
);

	reg [2:0] counter;
	wire [7:0] rule;
	wire [CAWidth-1:0]caState;

	assign rule =
				counter[2:1]== 2'b00 ? 8'b00011110 :
				counter[2:1]== 2'b01 ? 8'b00111100 :
				counter[2:1]== 2'b10 ? 8'b01011010 : 8'b10010110;

	DynamicBinaryCellularAutomata2D #(
		.Width(CAWidth)
	)
	automata (
		.clk(clk),
		.rst(1'b0),
		.ce(ce),
		.rule(rule),
		//($random[CAWidth-1:0] | $random[CAWidth-1:0]),
		.state(caState)
	);

	always @(posedge clk or posedge rst)
	begin
		if (rst)
		begin
			counter = 0;
		end
		else if (ce)
		begin
			counter = counter + 1;
		end
	end

	generate
		genvar i;
		for (i=0;i<Width;i=i+1)
		begin
			assign random[i] = (i%2)? ^caState[(i+1)*ParitWidth-1:i*ParitWidth]:~^caState[(i+1)*ParitWidth-1:i*ParitWidth];
		end
	endgenerate






endmodule

`endif