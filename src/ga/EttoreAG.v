`ifndef __ETTORE_AG__
`define __ETTORE_AG__

`include "ga/IndividualsCache.v"
`include "random/RandomicCellularAutomataBased.v"
`include "util/Queue.v"

module EttoreAG #(
	parameter ErrorWidth=32,
	parameter IndividualWidth=32,
	parameter PopulationAddressWidth=5,
) (
	input clk,
	input rst,

	output fitnessStart,
	input fitnessFinish,
	output [IndividualWidth-1:0]fitnessIndividual,
	input [ErrorWidth-1:0]fitnessError
);

IndividualsCache #(
	.IndividualWidth(IndividualWidth),
	.ErrorWidth(ErrorWidth),
	.AddressWidth(PopulationAddressWidth)
)
individualsCache (
	.clk(clk),
	.rst(rst),
	.we(fitnessCacheHit),
	.inIndividual(toTestIndividual),
	.inError(cachedError),
	.addrIndividual1(dadAddress),
	//.outError1(),
	.outIndividual1(dadIndividual),
	.addrIndividual2(momAddress),
	//.outError2(),
	.outIndividual2(momIndividual)
);

wire [PopulationAddressWidth-1:0]dadAddress;
wire [PopulationAddressWidth-1:0]momAddress;
wire [IndividualWidth-1:0]dadIndividual;
wire [IndividualWidth-1:0]momIndividual;

RandomicCellularAutomataBased #(
	.Width(PopulationAddressWidth*2)
)
randomicSelector(
	.clk(clk),
	.rst(rst),
	.ce(1'b1),
	.seed(?),
	.random({dadAddress,momAddress})
);


wire fitnessQueueVoid;
wire fitnessQueueFull;

Queue #(
	.Width(IndividualWidth),
	.AddressWidth(3)
)
fitnessQueue(
	.clk(clk),
	.rst(rst),
	.push(~fitnessQueueFull),
	.pull(~fitnessQueueVoid),
	.D(),
	.Q(toTestIndividual),
	.void(fitnessQueueVoid),
	.full(fitnessQueueFull)
);

wire [IndividualWidth-1:0]toTestIndividual;
wire [ErrorWidth-1:0]cachedError;
wire [ErrorWidth-1:0]fitnessError;
wire fitnessCacheHit;
wire fitnessCacheMiss;


DirectCache #(
	.Width(ErrorWidth),
	.AddressWidth(IndividualWidth),
	.CacheAddressWidth(4)
)
fitnessCache (
	.clk(clk),
	.rst(rst),
	.we(fitnessFinish),
	.hit(fitnessCacheHit),
	.miss(fitnessCacheMiss),
	.raddr(toTestIndividual)
	.Q(cachedError),
	.waddr(toTestIndividual),
	.D(fitnessError)
);



endmodule


`endif