`ifndef __WORD__
`define __WORD__

module Word #(
	parameter Width = 8,
	parameter RST = {Width{1'b0}},
	parameter PST = {Width{1'b1}}
) (
	input clk,
	input rst,
	input pst,
	input we,
	input [Width-1:0]D,
	output reg [Width-1:0]Q
);


always @(posedge clk or posedge rst or posedge pst)
begin
	if (rst) begin
		Q = RST;
	end
	else if(pst) begin
		Q = PST;
	end
	else if (we) begin
		Q = D;
	end
end


endmodule

`endif