`ifndef __PWM__
`define __PWM__

`include "util/Buffer.v"

module Pwm #(
	parameter Resolution=8,
	parameter AddressWidth=2
)(
	input clk,
	input rst,
	input ce,
	input [Resolution-1:0]D,
	input [AddressWidth-1:0]addr,
	input pwmclk,
	output [(2**AddressWidth)-1:0]O
); 

	wire [Resolution-1:0]value[2**AddressWidth-1:0];
	wire [2**AddressWidth-1:0]bufferSelect = 1'b1 << addr;

	genvar outCounter;
	generate
		for(outCounter =0;outCounter<2**AddressWidth;outCounter=outCounter+1)
		begin: _pwm_
			Buffer #(Resolution,{Resolution{1'b0}}) pwmValue (clk,rst,bufferSelect[outCounter],D,value[outCounter]);
			assign O[outCounter] = ~rst & value[outCounter] > timer;
		end
	endgenerate


	
	reg [Resolution-1:0]timer = {Resolution{1'b0}};
	
	always @(posedge pwmclk or posedge rst)
	begin
		if(rst)
		begin
			timer = {Resolution{1'b0}};
		end
		else
		begin
			timer = timer +1'b1;
		end
	end



endmodule

`endif
