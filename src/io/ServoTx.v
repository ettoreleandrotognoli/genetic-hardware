`ifndef __SERVO_TX__
`define __SERVO_TX__

`include "util/Buffer.v"

`define INIT 2'b00
`define VALUE 2'b01
`define END 2'b10

module ServoTx #(
	parameter Resolution = 8,
	parameter AddressWidth = 2,
	parameter Frequency = ((2 **Resolution) * 1000)
)(
	input clk,
	input rst,
	input we,
	input [Resolution-1:0]D,
	input [AddressWidth-1:0]addr,
	input servoclk,
	output [(2**AddressWidth)-1:0]servo
);
	 

	reg [Resolution-1:0]tmr;

	wire [Resolution-1:0]value[(2**AddressWidth)-1:0];
	wire [(2**AddressWidth)-1:0]bufferSelect = 1'b1 << addr;

	generate
		genvar outCounter;
		for(outCounter=0;outCounter<2**AddressWidth;outCounter=outCounter+1)
		begin: _servo_
			Buffer #(Resolution,{Resolution{1'b0}}) servoValue(clk,rst,bufferSelect[outCounter],D,value[outCounter]);
			assign servo[outCounter] = (state == `INIT)? 1'b1 :
										(state == `END) ? 1'b0 :
										tmr < value[outCounter] ? 1'b1 : 1'b0;
		end
		
	endgenerate

	reg [1:0]state = `INIT;

	always @(posedge servoclk or posedge rst)
	begin
		if(rst)
		begin
			state = `INIT;
			tmr = {Resolution{1'b0}};
		end
		else
		begin
			case (state)
				`INIT:
				begin
					if(tmr == {Resolution{1'b1}})
					begin
						tmr = {Resolution{1'b0}};
						state = `VALUE;
					end
					else
					begin
						tmr = tmr +1;
					end
				end
				`VALUE:
				begin
					if(tmr == {Resolution{1'b1}})
					begin
						tmr = {Resolution{1'b0}};
						state = `END;
					end
					begin
						tmr = tmr +1;
					end
				end
				`END:
				begin
					if(tmr == {Resolution{1'b1}})
					begin
						tmr = {Resolution{1'b0}};
						state = `INIT;
					end
					else
					begin
						tmr = tmr +1;
					end
				end
			endcase
		end
	end

endmodule



`endif
