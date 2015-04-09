`ifndef __COMPACT_GENETIC_ALGORITHM__
`define __COMPACT_GENETIC_ALGORITHM__

`include "random/RandomicCellularAutomataBased.v"
`include "ga/ProbabilityVectorPopulation.v"
`include "ga/CrossoverMutation.v"

module CompactGeneticAlgorithm #(
	parameter IndividualWidth = 32,
	parameter FitnessWidth = 16,
	parameter Resolution = 10,
	parameter TaxWidth = 1
) (
	input clk,
	input rst,
	input fitness_end,
	input [FitnessWidth-1:0]fitness,
	input [IndividualWidth*Resolution-1:0]seed,
	output reg [IndividualWidth-1:0]individual,
	output reg test_individual
);
	
	parameter INIT = 3'b000;
	parameter GEN_DAD = 3'b001;
	parameter GEN_MOM = 3'b010;
	parameter FITNESS_SON = 3'b011;
	parameter FITNESS_DAUGHTER =3'b100;
	parameter COMPARE = 3'b101;

	reg [3:0]state = INIT;

	wire [IndividualWidth*Resolution-1:0]random;
	wire [IndividualWidth-1:0]generated;
	reg [IndividualWidth-1:0]dad;
	reg [IndividualWidth-1:0]mom;
	wire [IndividualWidth-1:0]daughter;
	reg [Resolution-1:0]daughter_points;
	wire [IndividualWidth-1:0]son;
	reg [Resolution-1:0]son_points;
	reg [IndividualWidth-1:0]winner;
	reg gen_individual = 1'b0;
	reg fitness_population = 1'b0;
	reg [IndividualWidth-1:0]daughter_mut_mask = {IndividualWidth{1'b0}};
	reg [IndividualWidth-1:0]son_mut_mask= {IndividualWidth{1'b0}};
	reg [IndividualWidth-1:0]cross_mask= {IndividualWidth{1'b0}};


	ProbabilityVectorPopulation
		#(.Width(IndividualWidth),.Resolution(Resolution),.TaxWidth(TaxWidth))
	population
		(clk,rst,fitness_population,gen_individual,winner,1'b1,random,generated);

	RandomicCellularAutomataBased
		#(.Width(IndividualWidth*Resolution))
	randomic
		(clk,rst,1'b1,seed,random);

	CrossoverMutation
		#(.Width(IndividualWidth))
	crossoverAndMutation
		(dad,mom,daughter_mut_mask,son_mut_mask,cross_mask,daughter,son);

	always @(posedge clk or posedge rst) begin
		if (rst)
		begin
			state = INIT;
			fitness_population = 1'b0;
			gen_individual = 1'b0;
			test_individual = 1'b0;
			mom = {IndividualWidth{1'b0}};
			dad = {IndividualWidth{1'b0}};
		end
		else
		begin
			case (state)
				INIT:
				begin
					fitness_population = 1'b0;
					state = GEN_DAD;
					gen_individual = 1'b1;
				end
				GEN_DAD:
				begin
					dad = generated;
					state = GEN_MOM;
				end
				GEN_MOM:
				begin
					mom = generated;
					state = FITNESS_DAUGHTER;
					individual = daughter;
					test_individual = 1'b1;
					gen_individual = 1'b0;
					cross_mask = random[IndividualWidth-1:0];
				end
				FITNESS_DAUGHTER:
				begin
					if (fitness_end == 1'b1)
					begin
						state = FITNESS_SON;	
						daughter_points = fitness;
						test_individual = 1'b1;
						individual=son;
						daughter_mut_mask = random[IndividualWidth-1:0];
					end
					else
					begin
						test_individual = 1'b0;	
					end
				end
				FITNESS_SON:
				begin
					if (fitness_end==1'b1)
					begin
						state = COMPARE;
						son_points = fitness;
						son_mut_mask = random[IndividualWidth-1:0];
					end
					else
					begin
						test_individual = 1'b0;	
					end
				end
				COMPARE:
				begin
					fitness_population = 1'b1;
					if (son_points >= daughter_points)
					begin
						winner = son;	
					end
					else
					begin
						winner = daughter;
					end
					state = INIT;
				end
				default:state = INIT;
			endcase
		end
	end



endmodule

`endif