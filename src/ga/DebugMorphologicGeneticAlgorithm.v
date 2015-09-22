`ifndef __GA__DEBUG_MORPHOLOGIC_GENETIC_ALGORITHM__
`define __GA__DEBUG_MORPHOLOGIC_GENETIC_ALGORITHM__

`include "ga/MorphologicGeneticAlgorithm.v"
`include "util/SerialTXPackage.v"
//`include "io/Pwm.v"
//`include "io/SerialTx.v"
//`include "io/SerialRx.v"


module DebugMorphologicGeneticAlgorithm #(
	parameter ImageWidth = 8,
	parameter ImageHeight = 4,
	parameter ErrorWidth = $clog2(ImageHeight*ImageWidth),
	parameter OpcodeWidth = 16,
	parameter OpCounterWidth = 1,
	parameter InstructionWidth = OpcodeWidth * (2**OpCounterWidth),
	parameter IndividualWidth = InstructionWidth
) (
	input clk,
	input rst,
	input serialClk,
	//input rx,
	output tx,
	//output error,
	output finish
);

	reg [ImageHeight*ImageWidth-1:0]origin = {
		8'b00000000,
		8'b00010000,
		8'b00000000,
		8'b00000000
	};
	reg [ImageWidth*ImageHeight-1:0]objetive = {
		8'b00111000,
		8'b01111100,
		8'b00111000,
		8'b00010000
	};
	wire [IndividualWidth-1:0]bestIndividual;
	wire [ErrorWidth-1:0]bestError;
	wire cycle;
	wire [7:0]rxData;
	wire rxFinish;
	wire txBusy;

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

	/*SerialRx #(
		.Width(8),
		.TimerWidth(8)
	)
	serialRx (
		.clk(clk),
		.rst(rst),
		.rx(rx),
		.Q(rxData),
		.finish(rxFinish)
	);

	SerialTx #(
		.Width(8),
		.TimerWidth(8)
	)
	serialTx(
		.clk(clk),
		.rst(rst),
		.ce(cycle),
		.D(counter[31:25]),
		.tx(tx),
		.buzy()
	);

	Pwm #(
		.Resolution(ErrorWidth),
		.AddressWidth(0)
	)
	errorPwm(
		.clk(clk),
		.rst(rst),
		.ce(cycle),
		.D(bestError),
		.pwmclk(clk),
		.O(error)
	);*/

	assign finish = bestError==0?1'b1:1'b0;
	wire running = bestError != {ErrorWidth{1'b0}};
	reg [31:0] counter = {32{1'b0}};

	always @(posedge cycle or posedge rst) begin
		if (rst) begin
			counter = {32{1'b0}};
		end
		else if (running) begin
			counter = counter + 1;
		end
	end

	SerialTXPackage
		#(.AddressWidth(3),.WordWidth(8),.SerialTimerWidth(8),.QueueAddressWidth(3))
	serialTx
		(serialClk,rst,finish&~txBusy,{counter,bestIndividual},tx,txBusy);



endmodule

`endif
