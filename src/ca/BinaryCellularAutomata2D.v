`ifndef __2D_BINARY_CELLULAR_AUTOMATA__
`define __2D_BINARY_CELLULAR_AUTOMATA__

module BinaryCellularAutomata2D #(
	parameter Rule = 8'b00110010,
	parameter Width = 16,
	parameter Initial= {(Width/2){2'b01}}
) (
	input clk,
	input rst,
	input ce,
	input [Width-1:0]set,
	output reg [Width-1:0]state = Initial
);

	wire [7:0]rule = Rule;
	
	
	genvar i;
	generate
		for (i=0;i<Width;i=i+1)
		begin: _cell_			
			always @(posedge clk or posedge rst)
			begin
				if (rst)
				begin
					state[i] = set[i];
				end
				else if (ce)
				begin
					state[i] = rule[{state[(i+1)%Width],state[i],state[i-1<0?0:i-1]}];
				end
			end
		end
	endgenerate

	
	

endmodule

`endif