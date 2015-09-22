`ifndef __UTIL__SERIAL_TX_PACKAGE__
`define __UTIL__SERIAL_TX_PACKAGE__

`include "io/SerialTx.v"
`include "util/Queue.v"
`include "util/Multiplex.v"

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
	wire [WordWidth-1:0]queueD;
	wire [WordWidth-1:0]queueQ;
	wire queueVoid;
	wire queueFull;

	reg work = 1'b0;
	reg [AddressWidth-1:0]counter = {AddressWidth{1'b0}};
	reg [2**AddressWidth*WordWidth-1:0]dataBuffer = {2**AddressWidth*WordWidth{1'b0}};

	SerialTx
		#(.Width(WordWidth),.TimerWidth(SerialTimerWidth))
	serialTx
		(.clk(clk),.rst(rst),.ce(txCe),.D(txData),.tx(tx),.busy(txBusy));

	Queue
		#(.Width(WordWidth),.AddressWidth(QueueAddressWidth))
	queue 
		(.clk(~clk),.rst(rst),.push(queuePush),.pull(queuePull),.D(queueD),.Q(queueQ),.void(queueVoid),.full(queueFull));

	Multiplex
		#(.Width(WordWidth),.AddressSize(AddressWidth))
	mux
		(.D(dataBuffer),.S(counter),.Q(queueD));

	assign busy = work;
	assign txCe =  ~queueVoid & ~txBusy;
	assign queuePull = ~txBusy & ~queueVoid;
	assign txData = queueQ;
	assign queuePush = work & ~queueFull;
	
	always @(posedge clk or posedge rst) begin
		if (rst)
		begin
			work = 1'b0;
			counter = {AddressWidth{1'b0}};
			dataBuffer = {2**AddressWidth*WordWidth{1'b0}};
		end
		else if (ce & !work)
		begin
			dataBuffer = data;
			work = 1'b1;
			counter = {AddressWidth{1'b0}};
		end
		else if (work)
		begin
			if (counter == {AddressWidth{1'b1}})
			begin
				work = 1'b0;
			end
			else begin
				counter = counter + 1;
			end
		end
	end


endmodule


`endif