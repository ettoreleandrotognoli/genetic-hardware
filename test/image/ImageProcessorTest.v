`include "image/ImageProcessor.v"
`include "memory/RAM.v"
`include "memory/FileRAM.v"

module ImageProcessorTest;

	parameter WidthAddressSize = 6;
	parameter HeightAddressSize =6;
	parameter Width = 2**WidthAddressSize;
	parameter Height = 2**HeightAddressSize;
	parameter Resolution = 8;

	reg clk;
	reg rst;
	reg ce;
	reg invertX;
	reg invertY;
	reg [WidthAddressSize-1:0]translateX;
	reg [HeightAddressSize-1:0]translateY;
	reg [3:0]opcode;
	wire [Resolution*3-1:0]inputPixelA;
	wire [Resolution*3-1:0]inputPixelB;
	wire [HeightAddressSize-1:0]inputLine;
	wire [WidthAddressSize-1:0]inputColumn;
	wire [Resolution*3-1:0]outputPixel;
	wire [HeightAddressSize-1:0]outputLine;
	wire [WidthAddressSize-1:0]outputColumn;
	wire writePixel;
	wire buzy;

	ImageProcessor
		#(.WidthAddressSize(WidthAddressSize),.HeightAddressSize(HeightAddressSize),.Resolution(Resolution))
	imageProcessor
		(clk,rst,ce,invertX,invertY,translateX,translateY,opcode[2:0],inputPixelA,inputPixelB,inputLine,inputColumn,outputPixel,outputLine,outputColumn,writePixel,buzy);

	FileRAM
		#(.Width(Resolution*3),.AddressSize(WidthAddressSize+HeightAddressSize),.File("imagea.txt"))
	imageA
		(clk,rst,1'b0,{inputLine,inputColumn},0,inputPixelA);
	FileRAM
		#(.Width(Resolution*3),.AddressSize(WidthAddressSize+HeightAddressSize),.File("imageb.txt"))
	imageB
		(clk,rst,1'b0,{inputLine,inputColumn},0,inputPixelB);
	FileRAM
		#(.Width(Resolution*3),.AddressSize(WidthAddressSize+HeightAddressSize),.File("result.txt"))
	result
		(.clk(clk),.rst(rst),.we(writePixel),.addr({outputLine,outputColumn}),.D(outputPixel));
	

	initial
	begin
		$dumpfile("test/image/ImageProcessorTest.vcd");
		$dumpvars(0,imageProcessor);
		$dumpvars(0,imageA);
		$dumpvars(0,imageB);
		$dumpvars(0,result);
		clk = 1'b0;
		rst = 1'b1;
		ce = 1'b0;
		invertX = 1'b0;
		invertY = 1'b0;
		translateX = 0;
		translateY = 0;
		opcode = 4'b0000;
		#1;
		rst = 1'b0;
		ce = 1'b1;
		//#1;
		//while(opcode[3] == 1'b0)
		//begin
		//	#1;
		//	while(buzy)
		//	begin
		//		#1;
		//	end
		//	opcode = opcode +1;
		//	#1;
		//end
		opcode[2:0] = 3'b100;
		#2;
		while(buzy)
		begin
			#1;
		end
		$finish;
	end

	initial
	begin
		forever
		begin
			#1;
			clk = ~clk;
		end	
	end
	

endmodule