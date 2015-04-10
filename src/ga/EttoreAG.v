`ifndef __ETTORE_AG__
`define __ETTORE_AG__

`include "ga/IndividualsCache.v"
`include "ga/Crossover.v"
`include "random/RandomicCAParitBased.v"
`include "util/Queue2To1.v"
`include "memory/DirectCache.v"

module EttoreAG #(
	parameter ErrorWidth=32,
	parameter IndividualWidth=32,
	parameter PopulationAddressWidth=5
) (
	input clk,
	input rst,

	output fitnessStart,
	input fitnessFinish,
	output [IndividualWidth-1:0]fitnessIndividual,
	input [ErrorWidth-1:0]fitnessError,
	output reg [IndividualWidth-1:0]bestIndividual,
	output reg [ErrorWidth-1:0]bestError
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
	.addrIndividual2(momAddress==dadAddress?momAddress^1'b1:momAddress),
	//.outError2(),
	.outIndividual2(momIndividual)
);

wire [PopulationAddressWidth-1:0]dadAddress;
wire [PopulationAddressWidth-1:0]momAddress;
wire [IndividualWidth-1:0]dadIndividual;
wire [IndividualWidth-1:0]momIndividual;
wire [IndividualWidth-1:0]sonIndividual;
wire [IndividualWidth-1:0]daughterIndividual;

RandomicCAParitBased #(
	.Width(PopulationAddressWidth*2)
)
randomicSelector(
	.clk(clk),
	.rst(rst),
	.ce(~fitnessQueueFull),
	.random({dadAddress,momAddress})
);

Crossover #(
	.IndividualWidth(IndividualWidth)
)
crossover(
	.clk(clk),
	.rst(rst),
	.ce(~fitnessQueueFull),
	.dad(dadIndividual),
	.mom(momIndividual),
	.son(sonIndividual),
	.daughter(daughterIndividual)
);

wire fitnessQueueVoid;
wire fitnessQueueFull;

Queue2To1 #(
	.Width(IndividualWidth),
	.AddressWidth(3)
)
fitnessQueue(
	.clk(clk),
	.rst(rst),
	.push(~fitnessQueueFull),
	.pull(~fitnessQueueVoid & fitnessCacheHit),
	.D({sonIndividual,daughterIndividual}),
	.Q(toMutateInidividual),
	.void(fitnessQueueVoid),
	.full(fitnessQueueFull)
);

RandomicCAParitBased #(
	.Width(IndividualWidth*3)
)
randomicMutation(
	.clk(clk),
	.rst(rst),
	.ce(~fitnessQueueVoid & fitnessCacheHit),
	.random(randomMutation)
);

wire [IndividualWidth*3-1:0]randomMutation;
wire [IndividualWidth-1:0]mutationMask =
	randomMutation[IndividualWidth*3-1:IndividualWidth*2] &
	randomMutation[IndividualWidth*2-1:IndividualWidth] &
	randomMutation[IndividualWidth-1:0];

wire[IndividualWidth-1:0]toMutateInidividual;
wire [IndividualWidth-1:0]toTestIndividual = toMutateInidividual ^ mutationMask;
wire [ErrorWidth-1:0]cachedError;
wire [ErrorWidth-1:0]fitnessError;
wire fitnessCacheHit;
wire fitnessCacheMiss;

assign fitnessStart = fitnessCacheMiss & ~fitnessQueueVoid & ~fitnessFinish;
assign fitnessIndividual = toTestIndividual;

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
	.raddr(toTestIndividual),
	.Q(cachedError),
	.waddr(toTestIndividual),
	.D(fitnessError)
);

always @(posedge clk or posedge rst) begin
	if (rst)
	begin
		bestIndividual = {IndividualWidth{1'b0}};
		bestError = {ErrorWidth{1'b1}};
	end
	else
	if (fitnessCacheHit) begin
		if(cachedError < bestError)
		begin
			bestError = cachedError;
			bestIndividual = toTestIndividual;
		end
	end
end



endmodule


`endif