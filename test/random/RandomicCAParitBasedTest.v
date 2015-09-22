`include "random/RandomicCAParitBased.v"


module RandomicCAParitBasedTest;

	parameter Width = 8;
	parameter ParitWidth = 4;

	reg clk;
	reg rst;
	reg ce;
	wire [Width-1:0]random;


	RandomicCAParitBased #(
		.Width(Width),
		.ParitWidth(ParitWidth)
	)
	randomic(
		.clk(clk),
		.rst(rst),
		.ce(ce),
		.random(random)
	);


	initial
	begin
		$dumpfile("test/random/RandomicCAParitBasedTest.vcd");
		$dumpvars(0,randomic);
		clk = 1'b0;
		rst = 1'b1;
		ce = 1'b0;
		#1;
		rst = 1'b0;
		ce = 1'b1;
		#10000;
		$finish;
	end


	initial
	begin
		forever
		begin
			#1;
			clk = ~clk;
			if (clk)
			begin
				$monitor("%d",random);
			end
		end
	end



endmodule

