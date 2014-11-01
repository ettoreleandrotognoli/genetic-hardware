`include "util/Queue.v"

module QueueTest;

	reg clk,rst,push,pull;
	reg [7:0]data;
	wire [7:0]out;
	wire void,full;

	Queue #(.Width(8),.AddressWidth(2)) queue(clk,rst,push,pull,data,out,void,full);

	initial
	begin
		$dumpfile("test/util/QueueTest.vcd");
		$dumpvars(0,queue);
		rst = 1'b1;
		push = 1'b0;
		pull = 1'b0;
		data = 8'b00000000;
		#2;
		rst  =1'b0;
		#1;
		push = 1'b1;
		data = $random;
		#2;
		data = $random;
		#2;
		data = $random;
		#2;
		data = $random;
		#2;
		data = $random;
		#2;
		push = 1'b0;
		#2;
		pull = 1'b1;
		#2;
		#2;
		#2;
		#2;
		#2;
		pull = 1'b0;
		#100;
		$finish;
	end


	initial
	begin
		clk = 0;
		forever #1 clk = ~clk;
	end

endmodule
