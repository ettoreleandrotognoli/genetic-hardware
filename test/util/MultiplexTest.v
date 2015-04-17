`include "util/Multiplex.v"

module MultiplexTest;

	parameter AddressSize = 2;
	parameter Width = 8;

	reg [(Width*(2**AddressSize))-1:0]D;
	reg [AddressSize-1:0]S;
	wire [Width-1:0]Q;


	Multiplex #(
		.Width(Width),
		.AddressSize(AddressSize)
	)
	mux(
		.D(D),
		.S(S),
		.Q(Q)
	);

	integer i;
	initial
	begin
		$dumpfile("test/util/MultiplexTest.vcd");
		$dumpvars(0,mux);
		D = $random;
		for(i=0;i<2**AddressSize;i=i+1)
		begin
			S = i;
			#1;
		end
		$finish;
	end


endmodule
