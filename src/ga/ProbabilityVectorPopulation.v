`ifndef __COMPACT_GENETIC_ALGORITHM__
`define __COMPACT_GENETIC_ALGORITHM__

`include "ca/BinaryCellularAutomata2D.v"


module ProbabilityVectorPopulation #(
	parameter Width = 32,
	parameter Resolution = 8,
	parameter Initial= {Width*Resolution{1'b0}},
	parameter TaxWidth=4
) (
	input clk,
	input rst,
	input rst_sedd,
	input we,
	input ce,
	input [Width-1:0]winner,
	input [TaxWidth-1:0]tax,
	input [Resolution*Width-1:0]seed,
	output reg [Width-1:0]individual
);

wire rst_automata = rst_sedd | rst;
wire [Resolution-1:0]random[Width-1:0];
reg [Resolution-1:0]probability_vector[Width-1:0];
reg overflow = 1'b0;
reg [Resolution-1:0]result = {Resolution{1'b0}};

generate
	genvar i,rule;
	for (i=0;i<Width;i=i+1)
	begin: _gen_		
		BinaryCellularAutomata2D #(
			//regras 30 60 90 150
			.Rule(i%4==0?8'b00011110:(i%4==1?8'b00110010:(i%4==2?8'b01011010:8'b10010110))),
			.Width(Resolution),
			.Initial(0)
		) automata (clk,rst_automata,ce,seed[i*Resolution + Resolution-1:i*Resolution],random[i]);
		always @(posedge clk or posedge rst) begin
			if (rst)
			begin
				probability_vector[i] = {1'b0,{Resolution-1{1'b1}}};
			end
			else if(we)
			begin
				if (winner[i])
				begin
					{overflow,result} = probability_vector[i] - tax;
					if (overflow)
					begin
						probability_vector[i] = {Resolution{1'b0}};
					end
					else begin
						probability_vector[i] = result;
					end
				end
				else
				begin
					{overflow,result} = probability_vector[i] + tax;
					if (overflow)
					begin
						probability_vector[i] = {Resolution{1'b1}};
					end
					else begin
						probability_vector[i] = result;
					end
				end
			end
			else if (ce)
			begin
				individual[i] = random[i] <= probability_vector[i] ? 1'b0 : 1'b1;
			end
		end
	end
	
endgenerate

endmodule

`endif
