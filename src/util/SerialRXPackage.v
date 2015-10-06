`ifndef __UTIL_SERIAL_RX_PACKAGE__
`define __UTIL_SERIAL_RX_PACKAGE__

`include "io/SerialRx.v"
`include "util/Queue.v"
`include "util/Multiplex.v"
`include "util/Buffer.v"
`include "util/BorderDetector.v"
`include "util/DelayBorderDetector.v"

module SerialRXPackage #(
	parameter AddressWidth = 2,
	parameter WordWidth = 8,
	parameter SerialTimerWidth = 8,
	parameter QueueAddressWidth = 3
) (
	input clk,
	input rst,
	input rx,
	input pull,
	output [2**AddressWidth*WordWidth-1:0]Q,
	output void,
	output full
);

	wire [WordWidth-1:0]serialData;
	wire serialFinish;
	wire bufferCe;
	wire queueCe;
	wire bufferRst;

	wire [2**AddressWidth*WordWidth-1:0]package;

	reg [2**AddressWidth-1:0]buffersCe;

	generate
		genvar i;
		for (i=0;i<2**AddressWidth;i=i+1)
		begin: __buffer__
			Buffer
				#(.Width(WordWidth),.Init({WordWidth{1'b0}}))
			buff
				(.clk(serialFinish),.rst(rst),.ce(buffersCe[(2**AddressWidth-1)-i]),.D(serialData),.Q(package[(i+1)*WordWidth-1:i*WordWidth]));
		end
	endgenerate
	

	SerialRx
		#(.Width(WordWidth),.TimerWidth(SerialTimerWidth))
	serialRx
		(.clk(clk),.rst(rst),.rx(rx),.Q(serialData),.finish(serialFinish));

	Queue
		#(.Width(2**AddressWidth*WordWidth),.AddressWidth(QueueAddressWidth))
	queue
		(.clk(clk),.rst(rst),.push(queueCe),.pull(pull),.D(package),.Q(Q),.void(void),.full(full));


	//BorderDetector bdBuffer(.clk(clk),.rst(rst),.D(serialFinish),.up(bufferCe),.down());
	BorderDetector
		#(.TempInit(1'b1))
	bdQueue
		(.clk(clk),.rst(rst),.D(buffersCe[0]),.up(queueCe),.down());

	
	always @(posedge serialFinish or posedge rst) begin
		if (rst) begin
			buffersCe = {{2**AddressWidth-2{1'b0}},1'b1};
		end
		else// if (serialFinish)
		begin
			buffersCe = {buffersCe[2**AddressWidth-2:0],buffersCe[2**AddressWidth-1]};
		end
	end



endmodule


`endif