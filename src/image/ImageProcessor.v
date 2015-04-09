`ifndef __IMAGE_PROCESSOR__
`define __IMAGE_PROCESSOR__

module ImageProcessor #(
	parameter WidthAddressSize = 8,
	parameter HeightAddressSize =8,
	parameter Width = 2**WidthAddressSize,
	parameter Height = 2**HeightAddressSize,
	parameter Resolution = 8
) (
	input clk,
	input rst,
	input ce,
	input invertX,
	input invertY,
	input [WidthAddressSize-1:0]translateX,
	input [HeightAddressSize-1:0]translateY,
	input [2:0]opcode,
	input [Resolution*3-1:0]inputPixelA,
	input [Resolution*3-1:0]inputPixelB,
	output [HeightAddressSize-1:0]inputLine,
	output [WidthAddressSize-1:0]inputColumn,
	output [Resolution*3-1:0]outputPixel,
	output [HeightAddressSize-1:0]outputLine,
	output [WidthAddressSize-1:0]outputColumn,
	output reg writePixel,
	output reg buzy
);

reg [2:0]operation;
reg [HeightAddressSize-1:0]line = {HeightAddressSize{1'b0}};
reg [WidthAddressSize-1:0]column = {WidthAddressSize{1'b0}};

assign inputLine = line;
assign inputColumn = column;
assign outputLine = (line + translateY) ^ {HeightAddressSize{invertY}};
assign outputColumn = (column + translateX) ^ {WidthAddressSize{invertX}};

wire [Resolution-1:0]redPixelA = inputPixelA[Resolution*3-1:Resolution*2];
wire [Resolution-1:0]greenPixelA = inputPixelA[Resolution*2-1:Resolution*1];
wire [Resolution-1:0]bluePixelA = inputPixelA[Resolution-1:0];

wire [Resolution-1:0]redPixelB = inputPixelB[Resolution*3-1:Resolution*2];
wire [Resolution-1:0]greenPixelB = inputPixelB[Resolution*2-1:Resolution*1];
wire [Resolution-1:0]bluePixelB = inputPixelB[Resolution-1:0];

wire sumSub = operation[0];
wire [Resolution:0]redMath = redPixelA + (redPixelB ^ {Resolution{sumSub}}) + sumSub;
wire [Resolution:0]greenMath = greenPixelA + (greenPixelB ^ {Resolution{sumSub}}) + sumSub;
wire [Resolution:0]blueMath = bluePixelA + (bluePixelB ^ {Resolution{sumSub}}) + sumSub;

wire [Resolution*3-1:0]pixelMath = {
	redMath[Resolution]^sumSub?{Resolution{~sumSub}}:redMath[Resolution-1:0],
	greenMath[Resolution]^sumSub?{Resolution{~sumSub}}:greenMath[Resolution-1:0],
	blueMath[Resolution]^sumSub?{Resolution{~sumSub}}:blueMath[Resolution-1:0]
};


wire [Resolution*3-1:0]shufflePixelA;
wire [Resolution*3-1:0]shufflePixelB;

generate
	genvar i;
	for(i=0;i<Resolution*3;i=i+3)
	begin
		assign shufflePixelA[i] = inputPixelA[i/3];
		assign shufflePixelA[i+1] = inputPixelA[i/3 + Resolution];
		assign shufflePixelA[i+2] = inputPixelA[i/3 + Resolution * 2];

		assign shufflePixelB[i] = inputPixelB[i/3];
		assign shufflePixelB[i+1] = inputPixelB[i/3 + Resolution];
		assign shufflePixelB[i+2] = inputPixelB[i/3 + Resolution * 2];
	end
endgenerate

assign outputPixel = 
	operation == 3'b000 ? inputPixelA & inputPixelB:
	operation == 3'b001 ? inputPixelA | inputPixelB:
	operation == 3'b010 ? inputPixelA ^ inputPixelB:
	operation == 3'b011 ? ~(inputPixelA ^ inputPixelB):
	operation == 3'b100 ? (shufflePixelA < shufflePixelB ? inputPixelA : inputPixelB):
	operation == 3'b101 ? (shufflePixelA > shufflePixelB ? inputPixelA : inputPixelB):
	operation[2:1] == 2'b11 ? pixelMath : 0;

always @(negedge clk or posedge rst) begin
	if (rst)
	begin
		line = {HeightAddressSize{1'b0}};
		column = {WidthAddressSize{1'b0}};
		buzy = 1'b0;
		writePixel = 1'b0;
		operation = 3'b000;
	end
	else if( ce & !buzy)
	begin
		operation = opcode;
		buzy = 1'b1;
		writePixel = 1'b1;
	end
	else if (ce)
	begin
		if (column == {WidthAddressSize{1'b1}})
		begin
			column = {WidthAddressSize{1'b0}};
			if (line == {HeightAddressSize{1'b1}})
			begin
				line = {HeightAddressSize{1'b0}};
				buzy = 1'b0;
			end
			else
			begin
				line = line + 1;	
			end
		end
		else
		begin
			column = column + 1;
		end
	end
	else
	begin
		writePixel = 1'b0;	
	end
end

endmodule

`endif