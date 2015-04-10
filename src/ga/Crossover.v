`ifndef __CROSSOVER__
`define __CROSSOVER__

`include "random/RandomicCAParitBased.v"

module Crossover #(
	parameter InidividualWidth = 32,
	parameter RotationIndexWidth = $clog2(InidividualWidth),
	parameter CrossMaskIndexWidth = $clog2(InidividualWidth)
) (
	input clk,
	input rst,
	input ce,
	input [InidividualWidth-1:0]dad,
	input [InidividualWidth-1:0]mom,
	output [InidividualWidth-1:0]son,
	output [InidividualWidth-1:0]daughter
);

RandomicCAParitBased #(
	.Width(RotationIndexWidth + CrossMaskIndexWidth),
	.ParitWidth(3)
)
randomRotation (
	.clk(clk),
	.rst(rst),
	.ce(ce),
	.random({crossMaskIndex,rotationIndex})
);

wire [CrossMaskIndexWidth-1:0]crossMaskIndex;
wire [RotationIndexWidth-1:0]rotationIndex;

wire [InidividualWidth-1:0]beforeRotateCrossMask = ({InidividualWidth{1'b1}} << crossMaskIndex);
wire [InidividualWidth*3-1:0]rotatedCrossMask = {beforeRotateCrossMask,beforeRotateCrossMask,beforeRotateCrossMask} << rotationIndex;
wire [InidividualWidth-1:0]crossMask =	rotatedCrossMask[InidividualWidth*2-1:InidividualWidth];


assign daughter = ((dad & crossMask) | (mom & ~crossMask ));
assign son = ((dad & ~crossMask) | (mom & crossMask ));




endmodule

`endif