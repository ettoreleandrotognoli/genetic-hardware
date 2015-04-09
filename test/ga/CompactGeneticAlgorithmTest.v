`include "ga/CompactGeneticAlgorithm.v"

module CompactGeneticAlgorithmTest;

	parameter IndividualWidth = 32;
	parameter FitnessWidth = 16;
	parameter Resolution = 10;
	parameter TaxWidth = 1;

	reg clk;
	reg rst;
	reg fitness_end;
	reg [FitnessWidth-1:0]fitness;
	reg [IndividualWidth*Resolution-1:0]seed;
	wire [IndividualWidth-1:0]individual;
	wire test_individual;

	CompactGeneticAlgorithm
		#(.IndividualWidth(IndividualWidth),.FitnessWidth(FitnessWidth),.Resolution(Resolution),.TaxWidth(TaxWidth))
	cga
		(clk,rst,fitness_end,fitness,seed,individual,test_individual);


	integer i;
	initial
	begin
		$dumpfile("test/ga/CompactGeneticAlgorithmTest.vcd");
		$dumpvars(0,cga);
		seed = {IndividualWidth{$random}};
		#1;
		clk = 1'b1;
		rst = 1'b1;
		fitness_end = 1'b0;
		fitness = {FitnessWidth{1'b1}};
		#1;
		rst = 1'b0;
		for (i=0;i<100000;i=i+1)
		begin
			clk = ~clk;
			#1;
		end
		$finish;
	end

	always @(posedge test_individual)
	begin
		#1;
		fitness_end = 1'b0;
		#2;
		fitness_end = 1'b1;
		fitness = ~individual;
		$display("%d",fitness);
	end

endmodule