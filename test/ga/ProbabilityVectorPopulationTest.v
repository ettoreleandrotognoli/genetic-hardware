`include "ga/ProbabilityVectorPopulation.v"

module ProbabilityVectorPopulationTest;

	parameter Width = 32;
	parameter Resolution = 13;
	parameter TaxWidth = 2;
	reg clk;
	reg rst;
	reg we;
	reg ce;
	reg [Width-1:0]winner;
	reg [TaxWidth-1:0]tax;
	reg [Resolution*Width-1:0]random;
	wire [Width-1:0]individual;
	reg [Width-1:0]to_test;

	ProbabilityVectorPopulation #(.Width(Width),.Resolution(Resolution),.TaxWidth(TaxWidth))
		cga (clk,rst,we,ce,winner,tax,random,individual);

	integer i,t;
	initial
	begin
		$dumpfile("test/ga/ProbabilityVectorPopulationTest.vcd");
		$dumpvars(0,cga);
		#1;
		random = {Width{$random,$random,$random,$random,$random,$random}};
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
			for(t =0;t<3;t=t+1)
			begin
				random = {Width{$random,$random,$random,$random,$random,$random}};
				clk = 1;
				#1;
				clk = 0;
				#1;
				to_test = individual ^ ($random);
				if (to_test < winner)
				begin
					winner = to_test;
					tax = ~{to_test[Width-1],1'b0};
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

