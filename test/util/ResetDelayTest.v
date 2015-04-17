`include "util/ResetDelay.v"

module ResetDelayTest;

	reg clk;
	wire rst;

	ResetDelay #(
		.TimerMaxValue(250)
	)
	resetDelay(
		.clk(clk),
		.rst(rst)
	);

	initial
	begin
		$dumpfile("test/util/ResetDelayTest.vcd");
		$dumpvars(0,resetDelay);
		clk = 1'b0;
		#250000;
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