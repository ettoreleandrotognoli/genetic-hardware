`include "ga/ProbabilityVectorPopulation.v"

module CompactGeneticAlgorithmTest;

	parameter Width = 32;
	parameter Resolution = 17;
	parameter TaxWidth = 2;
	reg clk;
	reg rst;
	reg rst_seed;
	reg we;
	reg ce;
	reg [Width-1:0]winner;
	reg [TaxWidth-1:0]tax;
	reg [Resolution*Width-1:0]seed;
	wire [Width-1:0]individual;

	ProbabilityVectorPopulation #(.Width(Width),.Resolution(Resolution))
		cga (clk,rst,rst_seed,we,ce,winner,tax,seed,individual);

	integer i,t;
	initial
	begin
		$dumpfile("test/ga/CompactGeneticAlgorithmTest.vcd");
		$dumpvars(0,cga);
		#1;
		seed = {Width{$random,$random,$random,$random,$random,$random}};
		rst_seed = 1'b0;
		clk = 1'b0;
		rst = 1'b1;
		we = 1'b0;
		ce = 1'b0;
		#1;
		rst = 1'b0;
		#1;
		ce = 1'b1;
		#1;
		for (i=0;i<0;i=i+1)
		begin
			clk = 1;
			#1;
			clk = 0;
			#1;
			winner = individual;
			tax = ~individual[Width-1:Width-3];
			for(t =0;t<5;t=t+1)
			begin
				clk = 1;
				#1;
				clk = 0;
				#1;
				if (individual < winner)
				begin
					winner = individual;
					tax = ~individual[Width-1:Width-3];
				end
			end
			we = 1;
			clk = 1;
			#1;
			clk = 0;
			we = 0;
			#1;
		end
		$finish;
	end


endmodule

