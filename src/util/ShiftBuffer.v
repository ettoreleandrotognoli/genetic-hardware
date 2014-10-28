`ifndef __SHIFT_BUFFER__
`define __SHIFT_BUFFER__


module ShiftBuffer #(
	parameter Width = 8,
	parameter Init = {Width{1'b0}}

) (
	input clk;
	input rst;
	input we;
	input rightShift;
	input rightInput;
	input [Width-1:0]D;
	output [Width-1:0]Q;
);

reg [Width-1:0]data = Init;

assign Q = data;

always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		data = Init;
	end
	else if (we)
	begin
		data = D;
	end
	else if(rightShift)
	begin
		data = {data[Width-2:0],rightInput};
	end
end





`endif