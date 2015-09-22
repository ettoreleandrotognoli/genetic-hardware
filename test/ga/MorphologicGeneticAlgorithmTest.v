`include "ga/MorphologicGeneticAlgorithm.v"

module MorphologicGeneticAlgorithmTest;

	parameter ImageWidth = 32;
	parameter ImageHeight = 16;
	parameter ErrorWidth = $clog2(ImageHeight*ImageWidth);
	parameter OpcodeWidth = 16;
	parameter OpCounterWidth = 2;
	parameter InstructionWidth = OpcodeWidth * (2**OpCounterWidth);
	parameter IndividualWidth = InstructionWidth;

	reg clk;
	reg rst;
	reg [ImageHeight*ImageWidth-1:0]origin;
	reg [ImageWidth*ImageHeight-1:0]objetive;
	wire [IndividualWidth-1:0]bestIndividual;
	wire [ErrorWidth-1:0]bestError;
	wire cycle;

	MorphologicGeneticAlgorithm #(
		.ImageWidth(ImageWidth),
		.ImageHeight(ImageHeight),
		.ErrorWidth(ErrorWidth),
		.OpcodeWidth(OpcodeWidth),
		.OpCounterWidth(OpCounterWidth),
		.InstructionWidth(InstructionWidth),
		.IndividualWidth(IndividualWidth)
	)
	ga (
		.clk(clk),
		.rst(rst),
		.origin(origin),
		.objetive(objetive),
		.bestIndividual(bestIndividual),
		.bestError(bestError),
		.cycle(cycle)
	);

	initial
	begin
		$dumpfile("test/ga/MorphologicGeneticAlgorithmTest.vcd");
		$dumpvars(0,ga);
		clk = 1'b0;
		rst = 1'b1;
		origin = {
			32'b10000000000100000000000000000001,
			32'b00000000000100000000000000000000,
			32'b00000000000100000000000000000000,
			32'b00001110000000011100000000010000,
			32'b00000000000000000000000000010000,
			32'b00111000011100000000000000010000,
			32'b00000000000000000000000000000000,
			32'b00000000000000010000111000000000,
			32'b00010000000000111000000000000000,
			32'b00010000000000010000000000000000,
			32'b00010000000000000000000000001000,
			32'b00000000000000010000000000001000,
			32'b00000000000000111000000000001000,
			32'b00000000000000010000000000000000,
			32'b00000111000000000000000000000000,
			32'b10000000000000000000000000000001
		};
		objetive = {
			32'b00000000000000000000000000000000,
			32'b00000000000000000000000000000000,
			32'b00000000000000000000000000000000,
			32'b00000000000000000000000000000000,
			32'b00000000000000000000000000000000,
			32'b00000000000000000000000000000000,
			32'b00000000000000000000000000000000,
			32'b00000000000000010000000000000000,
			32'b00000000000000111000000000000000,
			32'b00000000000000010000000000000000,
			32'b00000000000000000000000000000000,
			32'b00000000000000010000000000000000,
			32'b00000000000000111000000000000000,
			32'b00000000000000010000000000000000,
			32'b00000000000000000000000000000000,
			32'b00000000000000000000000000000000
		};
		#1
		rst = 1'b0;
	end

	initial
	begin
		#500000;
		$finish;
	end

	initial
	begin
		forever
		begin
			#1;
			clk = ~clk;
			if(bestError ==0)
			begin
				$finish;
			end
		end
	end

endmodule
