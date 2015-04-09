`ifndef __PROBABILITY_VECTOR_POPULATION__
`define __PROBABILITY_VECTOR_POPULATION__

`include "ca/BinaryCellularAutomata2D.v"


module ProbabilityVectorPopulation #(
	parameter Width = 32,
	parameter Resolution = 8,
	parameter Initial= {Width*Resolution{1'b0}},
	parameter TaxWidth=4
) (
	input clk,
	input rst,
	input we,
	input ce,
	input [Width-1:0]winner,
	input [TaxWidth-1:0]tax,
	input [Resolution*Width-1:0]random,
	output reg [Width-1:0]individual
);

reg [Resolution-1:0]probability_vector[Width-1:0];
reg overflow = 1'b0;
reg [Resolution-1:0]result = {Resolution{1'b0}};

generate
	genvar i,rule;
	for (i=0;i<Width;i=i+1)
	begin: _gen_
		always @(posedge clk or posedge rst) begin
			if (rst)
			begin
				individual = {Width{1'b0}};
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
				$display("probability_vector[%d]=%b",i,probability_vector[i]);
				individual[i] =
					random[Resolution*i +Resolution-1:Resolution*i] <= probability_vector[i] ? 1'b0 : 1'b1;
			end
		end
	end
	
endgenerate

endmodule

`endif
