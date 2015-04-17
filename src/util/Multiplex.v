`ifndef __MULTIPLEX__
`define __MULTIPLEX__

module Multiplex #(
	parameter Width = 8,
	parameter AddressSize = 2
) (
	input [(Width*(2**AddressSize))-1:0]D,
	input [AddressSize-1:0]S,
	output [Width-1:0]Q
);

	wire [Width-1:0]value[2**AddressSize-1:0];

	genvar i;
	generate
		for(i=0;i<2**AddressSize;i=i+1)
		begin:_assign
			assign value[i] = D[i*Width+Width-1:i*Width];
		end
	endgenerate

	assign Q = value[S];

endmodule


`endif