`ifndef __RANDOM__RANDOMIC_LCA__
`define __RANDOM__RANDOMIC_LCA__

`include "ca/DynamicBinaryCellularAutomata2D.v"

module RandomicLCA #(
	parameter Width = 8

) (
	input clk,
	input rst,
	input ce,
	input [Width-1:0]seed,
	output reg [Width-1:0]random =0
);

	reg [5:0] counter = 0;
	wire [7:0] rule;
	wire [Width-1:0]caState;

	assign rule =
			counter[5:4]== 2'b00 ? 8'b00011110 :
			counter[5:4]== 2'b01 ? 8'b00111100 :
			counter[5:4]== 2'b10 ? 8'b01011010 : 8'b10010110;

	DynamicBinaryCellularAutomata2D #(
		.Width(Width)
	)
	automata (
		.clk(clk),
		.rst(rst),
		.ce(ce),
		.rule(rule),
		.set(seed),
		.state(caState)
	);

	always @(posedge clk or posedge rst)
	begin
		if (rst)
		begin
			counter = 0;
			random = 0;
		end
		else if (ce)
		begin
			random = {random[Width-2:0],random[Width-1]} ^ caState;
			counter = counter + 1 + ^caState;
			//$monitor("%d",caState);
		end
	end


endmodule

`endif