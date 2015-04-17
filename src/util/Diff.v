`ifndef __DIFF__
`define __DIFF__

module Diff #(
	parameter Width = 32,
	parameter DiffWidth = $clog2(Width)
) (
	input [Width-1:0]A,
	input [Width-1:0]B,
	output reg [DiffWidth-1:0]Diff
);

wire [Width-1:0]diffBits = A ^ B;

integer i;
always @(*)
begin
	Diff = 0;
	for (i=0;i<Width;i=i+1)
	begin
		Diff = Diff + diffBits[i];
	end
end


endmodule

`endif