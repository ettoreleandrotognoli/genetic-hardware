`include "ga/Crossover.v"

module CrossoverTest;
	parameter InidividualWidth = 32;
	parameter RotationIndexWidth = $clog2(InidividualWidth);
	parameter CrossMaskIndexWidth = $clog2(InidividualWidth);

	reg clk;
	reg rst;
	reg ce;
	reg [InidividualWidth-1:0]dad;
	reg [InidividualWidth-1:0]mom;
	wire [InidividualWidth-1:0]son;
	wire [InidividualWidth-1:0]daughter;

	Crossover #(
		.InidividualWidth(InidividualWidth),
		.RotationIndexWidth(RotationIndexWidth),
		.CrossMaskIndexWidth(CrossMaskIndexWidth)
	)
	crossover(
		.clk(clk),
		.rst(rst),
		.ce(ce),
		.dad(dad),
		.mom(mom),
		.son(son),
		.daughter(daughter)
	);


	integer i;
	initial
	begin
		$dumpfile("test/ga/CrossoverTest.vcd");
		$dumpvars(0,crossover);
		clk = 1'b0;
		ce = 1'b0;
		rst = 1'b1;
		dad = 0;
		mom =0;
		#1;
		ce = 1'b1;
		rst = 1'b0;
		for(i=0;i<100;i=i+1)
		begin
			dad = $random;
			mom = $random;
			#2;
		end
		$finish;
	end


	initial
	begin
		forever
		begin
			#1;
			clk = ~clk;
		end	
	end




endmodule

