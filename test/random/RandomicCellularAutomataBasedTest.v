`include "random/RandomicCellularAutomataBased.v"

module RandomicCellularAutomataBasedTest;
	parameter Width = 32;
	reg clk;
	reg rst;
	reg ce;
	reg [Width-1:0]seed;
	wire [Width-1:0]random;

	RandomicCellularAutomataBased
		#(.Width(Width))
	randomic
		(clk,rst,ce,seed,random);

	integer i;
	initial
	begin
		$dumpfile("test/random/RandomicCellularAutomataBasedTest.vcd");
		$dumpvars(0,randomic);
		#1;
		clk = 1'b0;
		seed = $random;
		rst = 1'b1;
		ce = 1'b0;
		#1;
		rst = 1'b0;
		ce = 1'b1;
		#1;
		for (i=0;i<10000;i=i+1)
		begin
			clk = ~clk;#1;
		end
		$finish;
	end


endmodule

