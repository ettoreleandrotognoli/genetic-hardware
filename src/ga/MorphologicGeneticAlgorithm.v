`ifndef __GA__MORPHOLOGIC_GENETIC_ALGORITHM__
`define __GA__MORPHOLOGIC_GENETIC_ALGORITHM__

`include "ga/MorphologicFitness.v"
`include "ga/EttoreAG.v"


module MorphologicGeneticAlgorithm #(
	parameter ImageWidth = 8,
	parameter ImageHeight = 4,
	parameter ErrorWidth = $clog2(ImageHeight*ImageWidth),
	parameter OpcodeWidth = 16,
	parameter OpCounterWidth = 2,
	parameter InstructionWidth = OpcodeWidth * (2**OpCounterWidth),
	parameter IndividualWidth = InstructionWidth
) (
	input clk,
	input rst,
	input [ImageHeight*ImageWidth-1:0]origin,
	input [ImageWidth*ImageHeight-1:0]objetive,
	output [IndividualWidth-1:0]bestIndividual,
	output [ErrorWidth-1:0]bestError,
	output cycle
);

wire fitnessStart;
assign cycle = fitnessStart;
wire fitnessFinish;
wire [IndividualWidth-1:0]fitnessIndividual;
wire [ErrorWidth-1:0]fitnessError;

EttoreAG #(
	.ErrorWidth(ErrorWidth),
	.IndividualWidth(IndividualWidth),
	.PopulationAddressWidth(4)
)
ag(
	.clk(clk),
	.rst(rst),
	.bestIndividual(bestIndividual),
	.bestError(bestError),
	.fitnessIndividual(fitnessIndividual),
	.fitnessError(fitnessError),
	.fitnessStart(fitnessStart),
	.fitnessFinish(fitnessFinish)
);

MorphologicFitness #(
	.ImageWidth(ImageWidth),
	.ImageHeight(ImageHeight),
	.ErrorWidth(ErrorWidth),
	.OpcodeWidth(OpcodeWidth),
	.OpCounterWidth(OpCounterWidth),
	.InstructionWidth(InstructionWidth)
)
fitness(
	.clk(clk),
	.rst(rst),
	.origin(origin),
	.objetive(objetive),
	.individual(fitnessIndividual),
	.start(fitnessStart),
	.finish(fitnessFinish),
	.error(fitnessError)
);



endmodule

`endif