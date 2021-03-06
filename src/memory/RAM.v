`ifndef __RAM__
`define __RAM__

`include "memory/Word.v"

module RAM #(
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
	input [AddressWidth-1:0]raddr,
	output [Width-1:0]Q
);

	wire [Width-1:0]data[2**AddressWidth-1:0];
	wire [2**AddressWidth-1:0]selector = 1'b1 << waddr;

	assign Q = data[raddr];

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