`ifndef __BINARY_CELLULAR_AUTOMATA_3D__
`define __BINARY_CELLULAR_AUTOMATA_3D__

`define beforeLine (l-1<0?Height-1:l-1)
`define afterLine ((l+1)%Height)
`define beforeColumn (c-1<0?Width-1:c-1)
`define afterColumn ((c+1)%Width)

module BinaryCellularAutomata3D #(
	parameter Width = 8,
	parameter Height = 8
) (
	input clk,
	input rst,
	input ce,
	input [8:0]survive,
	input [8:0]rise,
	input [Width*Height-1:0]set,
	output reg [Width*Height-1:0]state
);

	genvar l,c,beforeLine,afterLine,beforeColumn,afterColumn;
	generate
		for (l=0;l<Height;l=l+1)
		begin: __line__
			for (c=0;c<Width;c=c+1)
			begin: __column__
				wire [3:0]sum =
					state[`beforeLine*Width + `beforeColumn] +
					state[`beforeLine*Width + c] +
					state[`beforeLine*Width + `afterColumn] +
					state[l*Width + `beforeColumn] +
					//state[l*Width + c] +
					state[l*Width + `afterColumn] +
					state[`afterLine*Width + `beforeColumn]+
					state[`afterLine*Width + c] +
					state[`afterLine*Width + `afterColumn];
				always @(posedge clk or posedge rst)
				begin
					if (rst)
					begin
						state = set;	
					end
					else if (clk)
					begin
						state[l*Width+c] =
							state[l*Width + c] & survive[sum] | rise[sum];
					end
				end	
			end
		end
	endgenerate


endmodule


`endif