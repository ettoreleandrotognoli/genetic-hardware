`ifndef __DIRECT_CACHE__
`define __DIRECT_CACHE__

module DirectCache #(
	parameter CacheWidth = 8,
	parameter CacheAddressSize = 16,
	parameter MemWidth = 32,
	parameter MemAddressSize = 

) (
	input clk,
	input rst,
	input rw,
	input addr,
	input [CacheWidth-1:0]CacheD,
	output [CacheWidth-1:0]CacheQ
);

wire inCacheAddress;

RAM
	#(.Width(MemWidth),.AddressSize(?))
data
	(clk,rst,rw,addr[:0],CacheD,CacheQ);

RAM 
	#(clk,rst,?,addr[],addr,inCacheAddress)
addresses
	();

endmodule


`endif