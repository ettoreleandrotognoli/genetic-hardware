`include "memory/RAM.v"

module RAMTest;

	parameter Width = 8;
	parameter AddressSize = 4;

	reg clk;
	reg rst;
	reg we;
	reg [AddressSize-1:0]addr;
	reg [Width-1:0]D;
	wire [Width-1:0]Q;

	RAM
		#(.Width(Width),.AddressSize(AddressSize))
	ram
		(clk,rst,we,addr,D,Q);


	integer i;
	initial
	begin
		$dumpfile("test/memory/RAMTest.vcd");
		$dumpvars(0,ram);
		clk = 1'b0;
		rst = 1'b1;
		we = 1'b0;
		addr = {Width{1'b0}};
		D = {Width{1'b0}};
		#1;
		rst = 1'b0;
		#1;
		for (i =0;i<2**AddressSize;i=i+1)
		begin
			#1;
			addr = i;
			we = 1'b1;
			#1;
			D = $random;
			clk  = 1'b1;
			#1;
			clk = 1'b0;
		end
		we = 1'b0;
		#1;
		for (i =0;i<2**AddressSize;i=i+1)
		begin
			addr = i;
			#1;
		end
		#1;
		$finish;
	end

endmodule