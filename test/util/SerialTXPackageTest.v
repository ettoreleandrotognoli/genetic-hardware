`include "util/SerialTXPackage.v"

module SerialTXPackageTest;

	parameter AddressWidth = 2;
	parameter WordWidth = 8;
	parameter SerialTimerWidth = 3;
	parameter QueueAddressWidth =1;

	reg clk;
	reg rst;
	reg ce;
	reg [2**AddressWidth*WordWidth-1:0]data;
	wire tx;
	wire busy;

	SerialTXPackage #(
		AddressWidth,WordWidth,SerialTimerWidth,QueueAddressWidth
	)
	txPackage (
		clk,rst,ce,data,tx,busy
	);

	integer i;
	initial
	begin
		$dumpfile("test/util/SerialTXPackageTest.vcd");
		$dumpvars(0,txPackage);
		rst = 1'b1;
		clk = 1'b0;
		ce = 1'b0;
		data = 0;
		#1;
		rst = 1'b0;
		data = $random;
		ce = 1'b1;
		#1;
		clk = 1'b1;
		#1;
		clk = 1'b0;
		//ce = 1'b0;
		#1;
		for(i=0;i<500;i=i+1)
		begin
			data = $random;
			clk = ~clk; #1;
		end
		ce = 1'b0;
		for(i=0;i<2000;i=i+1)
		begin
			data = 0;
			clk = ~clk; #1;
		end
		$finish;
	end

endmodule