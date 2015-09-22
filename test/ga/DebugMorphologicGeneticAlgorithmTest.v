`include "ga/DebugMorphologicGeneticAlgorithm.v"

module DebugMorphologicGeneticAlgorithmTest;

	parameter ImageWidth = 8;
	parameter ImageHeight = 4;
	parameter ErrorWidth = $clog2(ImageHeight*ImageWidth);
	parameter OpcodeWidth = 16;
	parameter OpCounterWidth = 1;
	parameter InstructionWidth = OpcodeWidth * (2**OpCounterWidth);
	parameter IndividualWidth = InstructionWidth;

	reg clk;
	reg rst;
	wire serialClk = clk;
	wire tx;
	wire finish;

	DebugMorphologicGeneticAlgorithm
		#(ImageWidth,ImageHeight,ErrorWidth,OpcodeWidth,OpCounterWidth,InstructionWidth,IndividualWidth)
	debug (clk,rst,serialClk,tx,finish);

	integer i;
	initial
	begin
		$dumpfile("test/ga/DebugMorphologicGeneticAlgorithmTest.vcd");
		$dumpvars(0,debug);
		rst = 1'b1;
		clk = 1'b0;
		#1;
		rst = 1'b0;
		#1;
		for(i=0;i<500000;i=i+1)
		begin
			clk = ~clk;#1;
		end
		$finish;
	end

endmodule