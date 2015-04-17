`ifndef __MORPHOLOGIC_FITNESS__
`define __MORPHOLOGIC_FITNESS__


`include "image/MorphologicProcessor.v"
`include "util/Diff.v"
`include "util/Multiplex.v"

module MorphologicFitness #(
	parameter ImageWidth = 8,
	parameter ImageHeight = 8,
	parameter ErrorWidth = $clog2(ImageWidth*ImageHeight),
	parameter OpcodeWidth = 16,
	parameter OpCounterWidth = 2,
	parameter InstructionWidth = OpcodeWidth * (2**OpCounterWidth)
) (
	input clk,
	input rst,
	input [ImageHeight*ImageWidth-1:0]origin,
	input [ImageHeight*ImageWidth-1:0]objetive,
	input [InstructionWidth-1:0]individual,
	input start,
	output [ErrorWidth-1:0]error,
	output reg finish,
	output reg buzy
);

	MorphologicProcessor #(
		.ImageWidth(ImageWidth),
		.ImageHeight(ImageHeight),
		.OpCounterWidth(OpCounterWidth)
	)
	processor(
		.clk(clk),
		.rst(rst),
		.ce(buzy),
		.image(origin),
		.el(opcode[15:7]),
		.morphOp(opcode[6:4]),
		.morphInSelect(opcode[3]),
		.logicOp(opcode[2:0]),
		.opCounter(opCounter),
		.imageAcc(product)
	);

	Diff #(
		.Width(ImageWidth*ImageHeight),
		.DiffWidth(ErrorWidth)
	)
	diff(
		.A(product),
		.B(objetive),
		.Diff(error)
	);

	Multiplex #(
		.Width(OpcodeWidth),
		.AddressSize(OpCounterWidth)
	)
	multiplex(
		.D(individual),
		.S(opCounter),
		.Q(opcode)
	);
	
	wire [ImageWidth*ImageHeight-1:0]product;
	wire [OpCounterWidth-1:0]opCounter;
	wire [OpcodeWidth-1:0]opcode;

	always @(negedge clk or posedge rst)
	begin
		if (rst)
		begin
			buzy = 1'b0;
			finish = 1'b0;
		end
		else if (~buzy && ~finish && start)
		begin
			buzy = 1'b1;
			finish = 1'b0;
		end
		else if(~buzy && finish)
		begin
			finish = 1'b0;
		end
		else if(buzy && opCounter == 0)
		begin
			buzy = 1'b0;
			finish = 1'b1;
		end
		
	end


endmodule


`endif
