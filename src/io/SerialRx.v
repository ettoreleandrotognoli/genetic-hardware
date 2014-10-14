`ifndef __SERIAL_RX__
`define __SERIAL_RX__

`define INIT 2'b00
`define WAIT 2'b01
`define READ 2'b10

module SerialRx #(
	parameter Width = 8,
	parameter TimerWidth = 8
)(
	input clk,
	input rst,
	input rx,
	output reg [Width-1:0]Q = {Width{1'b0}},
	output reg finish
);

	reg [1:0]state = `INIT;
	reg [Width+1:0]data = {Width+2{1'b1}};
	reg [TimerWidth-1:0]tmr = {TimerWidth{1'b0}};


	always @(posedge clk or posedge rst)
	begin
		if(rst)
		begin
			state = `INIT;
			data = {Width+2{1'b1}};
			tmr = {TimerWidth{1'b0}};
			finish = 0;
			Q = {Width{1'b0}};
		end
		else
		begin
			case(state)
				`INIT:
				begin
					if(rx == 1'b1)
					begin
						state = `WAIT;
					end
				end
				`WAIT:
				begin
					if(rx == 1'b0)
					begin
						finish = 1'b0;
						tmr = {1'b1,{TimerWidth-1{1'b0}}};
						data = {Width+2{1'b1}};
						state = `READ;
					end
				end
				`READ:
				begin
					if(data[0] == 0)
					begin
						if(data[Width+1] == 1'b1)
						begin
							finish = 1'b1;
							Q = data[Width:1];
							state = `WAIT;
						end
						else
						begin
							state = `INIT;
						end
					end
					else
					begin
						if(tmr == {TimerWidth{1'b1}})
						begin
							tmr = {TimerWidth{1'b0}};
							data = {rx,data[Width+1:1]};
						end
						else
						begin
							tmr = (tmr +1);
						end
					end
				end
			endcase
		end
	end

endmodule

`endif