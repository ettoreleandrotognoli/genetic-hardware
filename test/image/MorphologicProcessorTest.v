`include "image/MorphologicProcessor.v"

module MorphologicProcessorTest;

	parameter ImageWidth = 8;
	parameter ImageHeight =4;
	parameter OpCounterWidth = 2;

	reg clk;
	reg rst;
	reg ce;
	reg [ImageWidth*ImageHeight-1:0]image;
	reg [8:0]el;//9
	reg [2:0]morphOp;//3
	reg morphInSelect;//1
	reg [2:0]logicOp;//3
	wire [OpCounterWidth-1:0]opCounter;
	wire [ImageHeight*ImageWidth-1:0]imageAcc;

	//reg instruction[14*4:0] = $random;



	MorphologicProcessor #(
		.ImageHeight(ImageHeight),
		.ImageWidth(ImageWidth),
		.OpCounterWidth(OpCounterWidth)
	)
	morphologicProcessor(
		.clk(clk),
		.rst(rst),
		.ce(ce),
		.image(image),
		.el(el),
		.morphOp(morphOp),
		.morphInSelect(morphInSelect),
		.logicOp(logicOp),
		.opCounter(opCounter),
		.imageAcc(imageAcc)
	);

	initial
	begin
		$dumpfile("test/image/MorphologicProcessorTest.vcd");
		$dumpvars(0,morphologicProcessor);
		clk = 1'b0;
		rst = 1'b1;
		ce = 1'b0;
		image = {
			8'b00100000,
			8'b00011110,
			8'b01111000,
			8'b00000100
		};
		el = {
			3'b010,
			3'b111,
			3'b010
		};
		morphOp = 3'b010;
		logicOp = 3'b000;
		morphInSelect = 1'b1;
		#1;
		rst = 1'b0;
		ce = 1'b1;
		#2;
		el = {
			3'b000,
			3'b001,
			3'b000
		};
		morphOp = 3'b001;//dilate
		logicOp = 3'b000;
		morphInSelect = 1'b1;
		#2;
		$finish;
	end

	always @(posedge clk)
	begin
		$monitor("%b\n%b\n%b\n%b\n\n",imageAcc[31:24],imageAcc[23:16],imageAcc[15:8],imageAcc[7:0]);
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
