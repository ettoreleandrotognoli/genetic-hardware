`ifndef __RAM__
`define __RAM__

`include "memory/Word.v"

module RAM #(
	parameter Width = 8,
	parameter AddressSize = 4
) (
	input clk,
	input rst,
	input we,
	input [AddressSize-1:0]addr,
	input [Width-1:0]D,
	output [Width-1:0]Q
);

	wire [Width-1:0]data[2**AddressSize-1:0];
	wire [2**AddressSize-1:0]selector = 1'b1 << addr;

	assign Q = data[addr];

	generate
		genvar i;
		for (i=0;i<2**AddressSize;i=i+1)
		begin
			Word
				#(.Width(Width))
			word
				(clk,rst,1'b0,selector[i] & we,D,data[i]);
		end
	endgenerate




endmodule

`endif