`include "time/ClockDivisor.v"

module ClockDivisorTest;
	reg clock;
	reg rst = 1'b0;
	wire dclock;

	ClockDivisor #(.TimerWidth(8),.TimerStart(55)) cd(clock,rst,dclock);

	integer i;

	initial
	begin
		$dumpfile("test/time/ClockDivisorTest.vcd");
		$dumpvars(0,cd);
		i=0;
		clock = 0;
		while(i<100000)
		begin
			#1 i = i +1;
			clock = ~clock;
		end
		$finish;
	end
	
endmodule