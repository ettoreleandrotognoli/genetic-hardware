`ifndef __CLOCK_DIVISOR__
`define __CLOCK_DIVISOR__

`include "util/Buffer.v"

module ClockDivisor #(
	parameter TimerWidth = 8,
	parameter TimerStart = 56
)(
	input clk,
	input rst,
	output reg dclk = 1'b0
);

	wire [TimerWidth:0]timer;
	Buffer#(.Width(TimerWidth+1),.Init(TimerStart)) timerBuffer(clk,timer[TimerWidth]|rst,1'b1,timer+1'b1,timer);

	always @(posedge timer[TimerWidth] or posedge rst)
	begin
		if(rst)
		begin
			dclk = 1'b0;
		end
		else
		begin
			dclk = ~dclk;	
		end
	end


	
endmodule

`endif