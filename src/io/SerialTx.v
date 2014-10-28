`ifndef __SERIAL_TX__
`define __SERIAL_TX__


module SerialTx #(
	parameter Width = 8,
	parameter TimerWidth = 8
)(
	input clk,
	input rst,
	input ce,
	input [Width-1:0]D,
	output tx,
	output busy
);
	
	reg [TimerWidth-1:0]tmr = {TimerWidth{1'b0}};
	reg [Width+3:0]outWire = {1'b1,{Width+2{1'b0}},1'b1};
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			tmr = 0;
			outWire = {{Width+3{1'b0}},1'b1};
		end
		else
		begin
			if(ce == 1'b1 && busy == 1'b0)
			begin
				outWire = {2'b11,D,2'b01};
				tmr = {TimerWidth{1'b0}};
			end
			else if(busy == 1'b1)
			begin
				if(tmr == {TimerWidth{1'b1}})
				begin
					//outWire = {1'b0,outWire[Width+3:1]};
					outWire = outWire >> 1;
					tmr = {TimerWidth{1'b0}};
				end
				else
				begin
					tmr = (tmr + 1'b1);
				end
			end
		end
	end
	
	assign tx = outWire[0];
	assign busy = (outWire == {{Width+3{1'b0}},1'b1})?1'b0:1'b1;

endmodule

`endif