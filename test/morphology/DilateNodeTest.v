`include "morphology/DilateNode.v"

module DilateNodeTest();

	parameter H = 3;
	parameter W = 3;

	reg [8:0]element;
	reg [8:0]Q;
	wire D;

	DilateNode #(.Width(W),.Height(H)) dilate(element,Q,D);

	integer i;
	initial
	begin
		$dumpfile("test/morphology/DilateNodeTest.vcd");
		$dumpvars(0,dilate);
		i=0;
		while(i<10)
		begin
			i = i +1;
			element = $random;
			Q = $random;
			#1;
		end
		$finish;
	end

endmodule