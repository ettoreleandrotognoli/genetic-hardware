`ifndef __CROSSOVER__
`define __CROSSOVER__

`include "random/RandomicCAParitBased.v"

module Crossover #(
	parameter IndividualWidth = 32,
	parameter RotationIndexWidth = $clog2(IndividualWidth),
	parameter CrossMaskIndexWidth = $clog2(IndividualWidth)
) (
	input clk,
	input rst,
	input ce,
	input [IndividualWidth-1:0]dad,
	input [IndividualWidth-1:0]mom,
	output [IndividualWidth-1:0]son,
	output [IndividualWidth-1:0]daughter
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

wire [IndividualWidth-1:0]beforeRotateCrossMask = ({IndividualWidth{1'b1}} << crossMaskIndex);
wire [IndividualWidth*3-1:0]rotatedCrossMask = {beforeRotateCrossMask,beforeRotateCrossMask,beforeRotateCrossMask} << rotationIndex;
wire [IndividualWidth-1:0]crossMask =	rotatedCrossMask[IndividualWidth*2-1:IndividualWidth];


assign daughter = ((dad & crossMask) | (mom & ~crossMask ));
assign son = ((dad & ~crossMask) | (mom & crossMask ));




endmodule

`endif