`ifndef __BUFFER__
`define __BUFFER__

module Buffer #(
	parameter Width = 8,
	parameter Init = 0
)(
	input clk,
	input rst,
	input ce,
	input [Width-1:0]D,
	output [Width-1:0]Q
);


	
	reg [Width-1 : 0] data = Init;
	
	assign Q = data;
	
	always @(posedge rst or posedge clk)
	begin
		if (rst)
		begin
			data = Init;
		end
		else if(ce)
		begin
			data = D;
		end
	end

endmodule

`endif