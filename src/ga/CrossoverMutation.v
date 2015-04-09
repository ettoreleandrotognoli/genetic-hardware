`ifndef __CROSSOVER_MUTATION__
`define __CROSSOVER_MUTATION__


module CrossoverMutation #(
	parameter Width = 32
) (
	input [Width-1:0]dad,
	input [Width-1:0]mom,

	input [Width-1:0]daughter_mutation_mask,
	input [Width-1:0]son_mutation_mask,

	input [Width-1:0]crossover_mask,


	output [Width-1:0]daughter,
	output [Width-1:0]son
);

assign daughter = ((dad & crossover_mask) | (mom & ~crossover_mask )) ^ daughter_mutation_mask;
assign son = ((dad & ~crossover_mask) | (mom & crossover_mask )) ^ son_mutation_mask;

endmodule



`endif