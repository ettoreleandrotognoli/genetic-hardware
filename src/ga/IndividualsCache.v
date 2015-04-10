`ifndef __INDIVIDUAL_CACHE__
`define __INDIVIDUAL_CACHE__


`include "memory/RAM3.v"

module IndividualsCache #(
	parameter IndividualWidth = 32,
	parameter AddressWidth = 4,
	parameter ErrorWidth = 32
) (
	input clk,
	input rst,
	input we,
	input [IndividualWidth-1:0]inIndividual,
	input [ErrorWidth-1:0]inError,
	input [AddressWidth-1:0]addrIndividual1,
	output [IndividualWidth-1:0]outIndividual1,
	output [ErrorWidth-1:0]outError1,
	input [AddressWidth-1:0]addrIndividual2,
	output [IndividualWidth-1:0]outIndividual2,
	output [ErrorWidth-1:0]outError2
);

wire [AddressWidth-1:0]hashAddress;
wire [IndividualWidth-1:0]oldIndividual;
wire [ErrorWidth-1:0]oldError;

generate
	genvar i;
	for (i =0;i<AddressWidth;i=i+1)
	begin: __hash__
		assign hashAddress[i] = ^ inIndividual[(i+1)*(IndividualWidth/AddressWidth)-1:i*(IndividualWidth/AddressWidth)];
	end
endgenerate

wire replaceIndividual = (inError < oldError) & we;


RAM3
	#(.AddressWidth(AddressWidth),.Width(IndividualWidth))
individuals (
	.clk(clk),
	.rst(rst),
	.pst(1'b0),
	.we(replaceIndividual),
	.waddr(hashAddress),
	.D(inIndividual),
	.r1addr(hashAddress),
	.Q1(oldIndividual),
	.r2addr(addrIndividual1),
	.Q2(outIndividual1),
	.r3addr(addrIndividual2),
	.Q3(outIndividual2)
);

RAM3
	#(.AddressWidth(AddressWidth),.Width(ErrorWidth))
errors (
	.clk(clk),
	.rst(1'b0),
	.pst(rst),
	.we(replaceIndividual),
	.waddr(hashAddress),
	.D(inError),
	.r1addr(hashAddress),
	.Q1(oldError),
	.r2addr(addrIndividual1),
	.Q2(outError1),
	.r3addr(addrIndividual2),
	.Q3(outError2)
);

endmodule

`endif