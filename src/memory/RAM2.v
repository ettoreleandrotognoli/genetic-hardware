`ifndef __RAM2__
`define __RAM2__

`include "memory/Word.v"

module RAM2 #(
	parameter Width = 8,
	parameter AddressWidth = 4,
	parameter RST = {Width{1'b0}},
	parameter PST = {Width{1'b1}}
) (
	input clk,
	input rst,
	input pst,
	input we,
	input [AddressWidth-1:0]waddr,
	input [Width-1:0]D,
	input [AddressWidth-1:0]r1addr,
	output [Width-1:0]Q1,
	input [AddressWidth-1:0]r2addr,
	output [Width-1:0]Q2
);

	wire [Width-1:0]data[2**AddressWidth-1:0];
	wire [2**AddressWidth-1:0]selector = 1'b1 << waddr;

	assign Q1 = data[r1addr];
	assign Q2 = data[r2addr];

	generate
		genvar i;
		for (i=0;i<2**AddressWidth;i=i+1)
		begin : _word_
			Word
				#(.Width(Width),.RST(RST),.PST(PST))
			word
				(clk,rst,pst,selector[i] & we,D,data[i]);
		end
	endgenerate




endmodule

`endif