`include "ga/MorphologicGeneticAlgorithm.v"

module MorphologicGeneticAlgorithmTest;

	parameter ImageWidth = 8;
	parameter ImageHeight = 4;
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
		.bestError(bestError)
	);

	initial
	begin
		$dumpfile("test/ga/MorphologicGeneticAlgorithmTest.vcd");
		$dumpvars(0,ga);
		clk = 1'b0;
		rst = 1'b1;
		origin = {
			8'b00000000,
			8'b00010000,
			8'b00010000,
			8'b00000000
		};
		objetive = {
			8'b00010000,
			8'b00111000,
			8'b00111000,
			8'b00010000
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
