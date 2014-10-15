`ifndef __SERIAL_TX__
`define __SERIAL_TX__


module SerialTx #(
	parameter Width = 8,
	parameter TimerWidth = 8
)(
	input clk,
	input rst,
	input ce,
	input [0:Width-1]D,
	output tx,
	output busy
);
	
	reg [TimerWidth-1:0]tmr = {TimerWidth{1'b0}};
	reg [Width+4:0]outWire = {1'b1,{Width+3{1'b0}},1'b1};
	
	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			tmr = 0;
			outWire = {1'b1,{Width+3{1'b0}},1'b1};
		end
		else
		begin
			if(ce == 1'b1 && busy == 1'b0)
			begin
				outWire[1] = 0;
				outWire[Width+1:2] = D;
				outWire[Width+4:Width+2] = 3'b111;
				tmr = {TimerWidth{1'b0}};
			end
			else if(busy == 1'b1)
			begin
				if(tmr == {TimerWidth{1'b1}})
				begin
					outWire = {1'b0,outWire[Width+4:1]};
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
	assign busy = (outWire[Width+4:1] == 0)?1'b0:1'b1;

endmodule

`endif