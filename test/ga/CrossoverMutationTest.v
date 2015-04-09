`include "ga/CrossoverMutation.v"

module CrossoverMutationTest;
	parameter Width = 32;

	reg [Width-1:0]dad;
	reg [Width-1:0]mom;

	reg [Width-1:0]daughter_mutation_mask;
	reg [Width-1:0]son_mutation_mask;

	reg [Width-1:0]crossover_mask;

	wire [Width-1:0]daughter;
	wire [Width-1:0]son;

	CrossoverMutation
		#(.Width(Width))
	crossover_mutation
		(dad,mom,daughter_mutation_mask,son_mutation_mask,crossover_mask,daughter,son);

	initial
	begin
		$dumpfile("test/ga/CrossoverMutationTest.vcd");
		$dumpvars(0,crossover_mutation);
		dad = {Width{1'b1}};
		mom = {Width{1'b0}};
		daughter_mutation_mask = $random & $random;
		son_mutation_mask = $random & $random;
		crossover_mask = {{Width/2{1'b0}},{Width/2{1'b1}}};
		#1;
		$finish;
	end

endmodule
