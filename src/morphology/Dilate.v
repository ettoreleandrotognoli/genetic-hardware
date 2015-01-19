module Dilate #(
	parameter Element = 1,
	parameter Width = 8,
	parameter Height = 8,
	parameter _ElementSize = Element * 2 +3
)(
	input clk,rst;
	input [_ElementSize*_ElementSize-1:0]element;
	input [Width*Height-1:0]D;
	output [Width*Height-1:0]Q;
);

endmodule