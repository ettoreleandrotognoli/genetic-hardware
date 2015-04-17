`include "util/Diff.v"

module DiffTest;

	parameter Width = 8;
	parameter DiffWidth = $clog2(Width);

	reg [Width-1:0]A;
	reg [Width-1:0]B;
	wire [DiffWidth-1:0]Diff;

	Diff #(
		.Width(Width)
	)
	diff(
		A,B,Diff
	);

	integer i;
	initial
	begin
		$dumpfile("test/util/DiffTest.vcd");
		$dumpvars(0,diff);
		for (i=0;i<100;i=i+1)
		begin
			A = $random;
			B = $random;
			#1;	
		end
		$finish;
	end




endmodule
