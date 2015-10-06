`ifndef __UTIL__DELAY_BORDER_DETECTOR__
`define __UTIL__DELAY_BORDER_DETECTOR__

module DelayBorderDetector #(
	parameter TempInit = 1'b0
)(
	input clk,
	input rst,
	input D,
	output reg up,
	output reg down
);

reg temp = TempInit;


always @(posedge clk or posedge rst) begin
	if (rst) begin
		temp = TempInit;
		up = 1'b0;
		down = 1'b0;
	end
	else// if (clk)
	begin
		if(temp != D)
		begin
			up = D;
			down = ~D;
		end
		else begin
			up = 1'b0;
			down = 1'b0;
		end
		temp = D;
	end
end

endmodule


`endif