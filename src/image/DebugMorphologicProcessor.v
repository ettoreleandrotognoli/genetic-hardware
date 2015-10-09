`ifndef __DEBUG_MORPHOLOGIC_PROCESSOR__
`define __DEBUG_MORPHOLOGIC_PROCESSOR__

`include "image/MorphologicProcessor.v"
`include "util/Multiplex.v"
`include "util/SerialTXPackage.v"

module DebugMorphologicProcessor #(
	parameter ImageWidth = 8,
	parameter ImageHeight =4,
	parameter OpCounterWidth = 1
) (
	input clk,
	input rst,
	input serialClk,
	output tx
);

reg [ImageWidth*ImageHeight-1:0]image;

reg [31:0]opcodes;

wire [8:0]el;
wire [2:0]morphOp;
wire morphInSelect;
wire [2:0]logicOp;
wire serialBusy;
wire [ImageHeight*ImageWidth-1:0]imageAcc;

wire [15:0]opcode;
assign  {el,morphOp,morphInSelect,logicOp} = opcode;

reg ce = 1'b1;
reg serialCe = 1'b0;

always @(negedge clk or posedge rst) begin
	if (rst) begin
		ce = 1'b1;
		serialCe = 1'b0;
		image = {
			8'b00000000,
			8'b00110000,
			8'b00011000,
			8'b00000000
		};
		opcodes = {
			{9'b010111010,3'b001,1'b0,3'b001},
			{9'b010010010,3'b001,1'b0,3'b001}
		};
	end
	else if (~clk) begin
		if(opCounter == 1'b0 && ce == 1'b1)
		begin
			ce = 1'b0;
			serialCe = 1'b1;
		end
		if (serialCe == 1'b1 && serialBusy == 1'b1)
		begin
			serialCe = 1'b0;
		end
	end
end


Multiplex
	#(.Width(16),.AddressSize(1))
multiplex
	(opcodes,~opCounter,opcode);

MorphologicProcessor
	#(.ImageWidth(ImageWidth),.ImageHeight(ImageHeight),.OpCounterWidth(OpCounterWidth))
processor
	(clk,rst,ce,image,el,morphOp,morphInSelect,logicOp,opCounter,imageAcc);


	
SerialTXPackage
	#(.AddressWidth(2),.WordWidth(8),.SerialTimerWidth(8),.QueueAddressWidth(1))
serialTx
	(serialClk,rst,serialCe,imageAcc,tx,serialBusy);


endmodule

`endif