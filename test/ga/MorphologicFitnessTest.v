`include "ga/MorphologicFitness.v"

module MorphologicFitnessTest;

	parameter ImageWidth = 8;
	parameter ImageHeight = 4;
	parameter ErrorWidth = $clog2(ImageWidth*ImageHeight);
	parameter OpcodeWidth = 16;
	parameter OpCounterWidth = 2;
	parameter InstructionWidth = OpcodeWidth * (2**OpCounterWidth);

	reg clk;
	reg rst;
	reg [ImageHeight*ImageWidth-1:0]origin;
	reg [ImageHeight*ImageWidth-1:0]objetive;
	reg [InstructionWidth-1:0]individual;
	reg start;
	wire [ErrorWidth-1:0]error;
	wire finish;
	wire buzy;

	MorphologicFitness #(
		.ImageHeight(ImageHeight),
		.ImageWidth(ImageWidth),
		.ErrorWidth(ErrorWidth),
		.OpcodeWidth(OpcodeWidth),
		.OpCounterWidth(OpCounterWidth),
		.InstructionWidth(InstructionWidth)
	)
	fitness(
		.clk(clk),
		.rst(rst),
		.origin(origin),
		.objetive(objetive),
		.individual(individual),
		.start(start),
		.error(error),
		.finish(finish),
		.buzy(buzy)
	);

	integer i;
	initial
	begin
		$dumpfile("test/ga/MorphologicFitnessTest.vcd");
		$dumpvars(0,fitness);
		clk = 1'b0;
		rst = 1'b1;
		origin = {
			8'b00000000,
			8'b00010000,
			8'b00010000,
			8'b00000000
		};
		//objetive = {
		//	8'b00010000,
		//	8'b00111000,
		//	8'b00111000,
		//	8'b00010000
		//};
		objetive = {
			8'b00001000,
			8'b00011100,
			8'b00011100,
			8'b00001000
		};
		//individual = {
		//	//cross	dilate 
		//	{9'b010111010,3'b001,1'b0,3'b001},
		//	{9'b000000000,3'b000,1'b0,3'b000},
		//	{9'b000000000,3'b000,1'b0,3'b000},
		//	{9'b000000000,3'b000,1'b0,3'b000}
		//};
		individual = {
			//>>> dilate
			{9'b000001000,3'b001,1'b0,3'b001},
			//cross	dilate 
			{9'b010111010,3'b001,1'b0,3'b001},
			{9'b000000000,3'b000,1'b0,3'b000},
			{9'b000000000,3'b000,1'b0,3'b000}
		};
		//individual = 64'h551E1406D3915F17;
		start= 1'b0;
		#1;
		rst = 1'b0;
		for(i=0;i<32;i=i+1)
		begin
			#1;
			start = 1'b1;
			@(posedge finish);
			#1;
			individual=$random;
		end
		#10;
		$finish;
	end

	initial
	begin
		#10000;
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