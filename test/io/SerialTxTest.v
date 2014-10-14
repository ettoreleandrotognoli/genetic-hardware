`include "io/SerialTx.v"

module SerialTxTest;
	
	reg [7:0]data;
	reg clk,ce,bound;
	
	wire tx,busy;

	SerialTx #(.Width(8),.TimerWidth(2))s(clk,1'b0,ce,data,tx,busy);
	
	integer i;

	initial
	begin
		$dumpfile("test/io/SerialTxTest.vcd");
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
