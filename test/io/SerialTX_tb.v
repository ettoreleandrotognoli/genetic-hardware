`include "io/SerialTX.v"

module SerialTX_tb;
	
	reg [7:0]data;
	reg clk,ce,bound;
	
	wire tx,busy;

	SerialTX #(8,2)s(clk,1'b0,ce,data,tx,busy);
	
	integer i;

	initial
	begin
		$dumpfile("test/io/SerialTX_tb.vcd");
		$dumpvars(0,s);
		data =0;
		clk =0;
		ce =0;
		#1
		ce =1;
		data = $random;
		#1
		ce = 0;
		#1000
		$finish;
	end
	
	initial
	begin
		bound =0;
		forever #1 clk = ~clk;
	end
endmodule
