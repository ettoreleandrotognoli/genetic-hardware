`ifndef __QUEUE_2_TO_1__
`define __QUEUE_2_TO_1__

`include "util/Buffer.v"
`include "util/Queue.v"

module Queue2To1 #(
	parameter Width = 8,
	parameter AddressWidth =2
)(
	input clk,
	input rst,
	input push,
	input pull,
	input [Width*2-1:0]D,
	output [Width-1:0]Q,
	output void,
	output full
);

wire [Width-1:0]queue1Q;
wire queue1Void;
wire queue1Full;
Queue #(
	.Width(Width),
	.AddressWidth(AddressWidth)
)
queue1 (
	.clk(clk),
	.rst(rst),
	.push(push),
	.pull(~pullSelector & ~queue1Void & pull),
	.D(D[Width-1:0]),
	.Q(queue1Q),
	.void(queue1Void),
	.full(queue1Full)
);

wire [Width-1:0]queue2Q;
wire queue2Void;
wire queue2Full;
Queue #(
	.Width(Width),
	.AddressWidth(AddressWidth)
)
queue2(
	.clk(clk),
	.rst(rst),
	.push(push),
	.pull(pullSelector & ~queue2Void & pull),
	.D(D[Width*2-1:Width]),
	.Q(queue2Q),
	.void(queue2Void),
	.full(queue2Full)
);

reg pullSelector = 1'b0;
always @(posedge clk or posedge rst) begin
	if (rst) begin
		pullSelector = 1'b0;
	end
	else if (pull) begin
		pullSelector = ~pullSelector;
	end
end

assign full = queue1Full | queue2Full;
assign void = queue1Void & queue2Void;
assign Q = ~pullSelector?queue1Q:queue2Q;

endmodule

`endif