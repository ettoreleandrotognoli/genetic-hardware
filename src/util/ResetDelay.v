`ifndef __UTIL__RESET_DELAY__
`define __UTIL__RESET_DELAY__

module ResetDelay #(
	parameter TimerMaxValue = 50000000-1,
	parameter TimerWidth = $clog2(TimerMaxValue)
) (
	input clk,
	output rst
);


reg reset = 1'b1;
assign rst = reset;
reg [TimerWidth-1:0]timer = {TimerWidth{1'b0}};

always @(posedge clk)
begin
	if (timer != TimerMaxValue && reset)
	begin
		timer = timer + 1;
	end
	else if(reset)
	begin
		reset = 1'b0;
	end
end


endmodule



`endif