`ifndef __UTIL__BORDER_DETECTOR__
`define __UTIL__BORDER_DETECTOR__

module BorderDetector #(
	parameter TempInit = 1'b0
)(
	input clk,
	input rst,
	input D,
	output up,
	output down
);

reg temp = TempInit;

assign up = (D != temp)?D:1'b0;
assign down = (D!=temp)?~D:1'b0;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		temp = TempInit;
	end
	else// if (clk)
	begin
		temp = D;
	end
end

endmodule


`endif