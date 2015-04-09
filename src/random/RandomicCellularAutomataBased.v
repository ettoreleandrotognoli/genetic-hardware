`ifndef __RANDOMIC_CELLULAR_AUTOMATA_BASED__
`define __RANDOMIC_CELLULAR_AUTOMATA_BASED__

`include "ca/DynamicBinaryCellularAutomata2D.v"

module RandomicCellularAutomataBased #(
	parameter Width = 32
) (
	input clk,
	input rst,
	input ce,
	input [Width-1:0]seed,
	output [Width-1:0]random
);

	reg [2:0] counter;
	wire [7:0] rule;

	assign rule =
				counter[2:1]== 2'b00 ? 8'b00011110 :
				counter[2:1]== 2'b01 ? 8'b00111100 :
				counter[2:1]== 2'b10 ? 8'b01011010 : 8'b10010110;

	DynamicBinaryCellularAutomata2D
		#(.Width(Width))
	automata
		(clk,rst,ce,rule,seed,random);

	always @(posedge clk or posedge rst)
	begin
		if (rst)
		begin
			counter = 0;
		end
		else
		begin
			counter = counter + 1;
		end
	end

endmodule

`endif
