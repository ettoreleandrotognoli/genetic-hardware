`include "morphology/ErodeNode.v"

module ErodeNodeTest();

	parameter H = 3;
	parameter W = 3;

	reg [8:0]element;
	reg [8:0]Q;
	wire D;

	ErodeNode #(.Width(W),.Height(H)) erode(element,Q,D);

	integer i;
	initial
	begin
		$dumpfile("test/morphology/ErodeNodeTest.vcd");
		$dumpvars(0,erode);
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