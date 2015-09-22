`ifndef __RANDOMIC_CELLULAR_AUTOMATA_BASED__
`define __RANDOMIC_CELLULAR_AUTOMATA_BASED__

`include "ca/BinaryCellularAutomata3D.v"

module RandomicCellularAutomataBased #(
	parameter Width = 32,
	parameter CAWidth = Width,
	parameter CAHeight = Width
) (
	input clk,
	input rst,
	input ce,
	input [Width-1:0]seed,
	output reg [Width-1:0]Q
);

	reg [7:0] counter;
	wire [17:0] rule;
	wire [8:0]survive = rule[17:9];
	wire [8:0]rise = rule[8:0];
	wire [Width-1:0]automataState;
	wire [Width-1:0]random;

	assign rule =
				counter[7:6]== 2'b00 ? {9'b000100110,9'b001001000}: // 125/36
				counter[7:6]== 2'b01 ? {9'b100001100,9'b010101000} : // 238/357
				counter[7:6]== 2'b10 ? {9'b000001100,9'b001001000} : // 23/36
									{9'b100101010,9'b010101000}; // 1358/357

	BinaryCellularAutomata3D
		#(.Width(CAWidth),.Height(CAHeight))
	automata
		(clk,rst | (~|automataState),ce,survive,rise,seed,automataState);

	/*genvar i;
	generate
		for (i=0;i<Width;i=i+1)
		begin: __assign__
			assign random[i] = automataState[(i*5 % CAHeight )*CAWidth+((i*3)%CAWidth)];
		end
	endgenerate*/

	assign random = automataState;

	always @(posedge clk or posedge rst)
	begin
		if (rst)
		begin
			Q = 0;
			counter = 0;
		end
		else
		begin
			Q = {Q[Width-2:0],Q[Width-1]} ^ random;
			counter = counter + 1 ;
		end
	end

endmodule

`endif
