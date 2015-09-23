

`include "image/DebugMorphologicProcessor.v"

module DebugMorphologicProcessorTest;

	reg clk;
	reg rst;
	wire serialClk = clk;
	wire tx;

	DebugMorphologicProcessor debug(clk,rst,serialClk,tx);


	integer i;
	initial
	begin
		$dumpfile("test/image/DebugMorphologicProcessorTest.vcd");
		$dumpvars(0,debug);
		clk=1'b0;
		rst=1'b1;
		#1;
		rst=1'b0;
		#1;
		for(i=0;i<80000;i=i+1)
		begin
			clk = ~clk;#1;
		end
		$finish;
	end

endmodule
