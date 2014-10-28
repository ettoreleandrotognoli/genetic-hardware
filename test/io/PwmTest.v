`include "io/Pwm.v"

module PwmTest;


	reg clk,ce,rst,pwmclock;
	reg [7:0]data;
	reg [1:0]addr;
	wire [3:0]out;

	Pwm #(.Resolution(8),.AddressWidth(2)) pwm (clk,rst,ce,data,addr,pwmclock,out);

	initial
	begin
		$dumpfile("test/io/PwmTest.vcd");
		$dumpvars(0,pwm);
		rst = 1'b1;
		ce = 1'b0;
		data = 8'b00000000;
		addr = 2'b00;
		#1;
		rst = 1'b0;
		#1;
		data = $random;
		addr = 2'b00;
		ce = 1'b1;
		#2;
		ce = 1'b0;
		#1;
		data =$random;
		addr = 2'b01;
		ce = 1'b1;
		#2;
		ce = 1'b0;
		#1;
		data =$random;
		addr = 2'b10;
		ce = 1'b1;
		#2;
		ce = 1'b0;
		#1;
		data = 8'b11111111;
		addr = 2'b11;
		ce = 1'b1;
		#2;
		ce = 1'b0;
		#100000;
		$finish;
	end

	initial
	begin
		clk = 0;
		forever #1 clk = ~clk;
	end

	initial
	begin
		pwmclock=0;
		forever #5 pwmclock = ~pwmclock;
	end

endmodule
