`ifndef __MORPHOLOGIC_PROCESSOR__
`define __MORPHOLOGIC_PROCESSOR__

`include "image/LogicUnit.v"
`include "morphology/MorphologicUnit.v"

module MorphologicProcessor #(
	parameter ImageWidth = 8,
	parameter ImageHeight =8,
	parameter OpCounterWidth = 2
) (
	input clk,
	input rst,
	input ce,
	input [ImageWidth*ImageHeight-1:0]image,
	input [8:0]el,
	input [2:0]morphOp,
	input morphInSelect,
	input [2:0]logicOp,
	output reg [OpCounterWidth-1:0]opCounter,
	output reg [ImageHeight*ImageWidth-1:0]imageAcc
);


wire [ImageHeight*ImageWidth-1:0]morpholicResult;
MorphologicUnit #(
	.ImageWidth(ImageWidth),
	.ImageHeight(ImageHeight)
)
morphologicUnit (
	.img((morphInSelect | opCounter ==0)?image:imageAcc),
	.el(el),
	.op(morphOp),
	.result(morpholicResult)
);

wire [ImageHeight*ImageWidth-1:0]logicResult;
LogicUnit #(
	.ImageWidth(ImageWidth),
	.ImageHeight(ImageHeight)
)
logicUnit (
	.imgA(opCounter == 0 ? image : imageAcc),
	.imgB(morpholicResult),
	.op(logicOp),
	.result(logicResult)
);

always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		opCounter = {OpCounterWidth{1'b0}};
		imageAcc = {ImageHeight*ImageWidth{1'b0}};
	end
	else
	if (ce)
	begin
		opCounter = opCounter + 1;
		imageAcc = logicResult;
	end
end


endmodule

`endif