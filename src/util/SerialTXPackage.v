`ifndef __UTIL__SERIAL_TX_PACKAGE__
`define __UTIL__SERIAL_TX_PACKAGE__

`include "io/SerialTx.v"
`include "util/Queue.v"
`include "util/Multiplex.v"
`include "util/BorderDetector.v"

module SerialTXPackage #(
	parameter AddressWidth = 2,
	parameter WordWidth = 8,
	parameter SerialTimerWidth = 8,
	parameter QueueAddressWidth = 3
) (
	input clk,
	input rst,
	input ce,
	input [2**AddressWidth*WordWidth-1:0]data,
	output tx,
	output busy
);

	wire txCe;
	wire [WordWidth-1:0]txData;
	wire txBusy;
	wire queuePush;
	wire queuePull;
	wire [2**AddressWidth*WordWidth-1:0]queueQ;
	wire queueVoid;
	wire queueFull;
	wire queueCe;
	reg [AddressWidth-1:0]counter = {AddressWidth{1'b0}};

	

	assign queuePull = ~txBusy & ~queueVoid & queueCe;

	Queue
		#(.Width(2**AddressWidth*WordWidth),.AddressWidth(QueueAddressWidth))
	queue 
		(.clk(clk),.rst(rst),.push(ce&~queueFull),.pull(queuePull),.D(data),.Q(queueQ),.void(queueVoid),.full(queueFull));

	assign txCe =  ~queueVoid & ~txBusy;

	SerialTx
		#(.Width(WordWidth),.TimerWidth(SerialTimerWidth))
	serialTx
		(.clk(clk),.rst(rst),.ce(txCe),.D(txData),.tx(tx),.busy(txBusy));

	BorderDetector
	bdQueue(.clk(clk),.rst(rst),.D(counter=={AddressWidth{1'b1}}),.up(queueCe),.down());

	Multiplex
		#(.Width(WordWidth),.AddressSize(AddressWidth))
	mux
		(.D(queueQ),.S(~counter),.Q(txData));

	assign busy = queueFull;

	always @(negedge txBusy or posedge rst) begin
		if (rst)
		begin
			counter = {AddressWidth{1'b0}};
		end
		else//if (~txBusy)
		begin
			counter = counter + 1'b1;
		end
	end


endmodule


`endif