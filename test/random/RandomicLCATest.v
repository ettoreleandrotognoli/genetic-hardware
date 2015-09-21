`include "random/RandomicLCA.v"

module RandomicLCATest;

	parameter Width = 8;

	reg clk;
	reg rst;
	reg ce;
	reg [Width-1:0]seed;
	wire [Width-1:0]random;


	RandomicLCA #(
		.Width(Width)
	) ca(
		.clk(clk),.rst(rst),.ce(ce),.seed(seed),.random(random)
	);

	integer i;
	initial
	begin
		$dumpfile("test/random/RandomicLCATest.vcd");
		$dumpvars(0,ca);
		clk = 1'b0;
		rst = 1'b1;
		ce = 1'b0;
		seed =  $random;
		$monitor("%b",$random);
		#1;
		rst= 1'b0;
		ce = 1'b1;
		for(i=0;i<10000;i=i+1)
		begin
			#1;
			if (i%2==0)
			begin
				$monitor("%d",random);
			end
			clk = ~clk;
		end
		$finish;
	end


endmodule