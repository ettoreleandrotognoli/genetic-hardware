`include "memory/DirectCache.v"

module DirectCacheTest;

	parameter Width = 8;
	parameter AddressWidth = 8;
	parameter CacheAddressWidth = 4;
	parameter PartialAddressWidth = AddressWidth - CacheAddressWidth;


	reg clk;
	reg rst;
	reg we;
	wire hit;
	wire miss;
	reg [AddressWidth-1:0]raddr;
	wire [Width-1:0]Q;
	reg [AddressWidth-1:0]waddr;
	reg [Width-1:0]D;

	DirectCache #(
		.Width(Width),
		.AddressWidth(AddressWidth),
		.CacheAddressWidth(CacheAddressWidth),
		.PartialAddressWidth(PartialAddressWidth)
	)
	cache (
		.clk(clk),
		.rst(rst),
		.we(we),
		.hit(hit),
		.miss(miss),
		.raddr(raddr),
		.Q(Q),
		.waddr(waddr),
		.D(D)
	);

	integer i;
	initial
	begin
		$dumpfile("test/memory/DirectCacheTest.vcd");
		$dumpvars(0,cache);
		clk = 1'b0;
		rst = 1'b1;
		we = 1'b0;
		raddr = 0;
		waddr =0;
		D =0;
		#1;
		rst = 1'b0;
		for (i=0;i<2**AddressWidth;i=i+1)
		begin
			#1;
			waddr = i;
			D = $random;
			we =1'b1;
			@(posedge clk);
		end
		we = 1'b0;
		waddr = 0;
		for (i=0;i<2**AddressWidth;i=i+1)
		begin
			raddr = i;
			#1;
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
