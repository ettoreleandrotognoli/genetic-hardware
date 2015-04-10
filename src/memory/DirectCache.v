`ifndef __DIRECT_CACHE__
`define __DIRECT_CACHE__

`include "memory/RAM.v"

module DirectCache #(
	parameter Width = 8,
	parameter AddressWidth = 8,
	parameter CacheAddressWidth = 4,
	parameter PartialAddressWidth = AddressWidth - CacheAddressWidth

) (
	input clk,
	input rst,
	input we,
	output hit,
	output miss,
	input [AddressWidth-1:0]raddr,
	output [Width-1:0]Q,
	input [AddressWidth-1:0]waddr,
	input [Width-1:0]D
);

RAM #(
	.Width(Width+1+PartialAddressWidth),
	.AddressWidth(CacheAddressWidth)
)
cache(
	.clk(clk),
	.rst(rst),
	.pst(1'b0),
	.we(we),
	.waddr(waddr[AddressWidth-1:PartialAddressWidth]),
	.D({1'b1,waddr[PartialAddressWidth-1:0],D}),
	.raddr(raddr[AddressWidth-1:PartialAddressWidth]),
	.Q({writed,partialAddress,value})
);

wire writed;
wire [PartialAddressWidth-1:0]partialAddress;
wire [Width-1:0]value;

assign hit = (partialAddress == raddr[PartialAddressWidth-1:0]) & writed;
assign miss = ~hit;
assign Q = value;


endmodule


`endif