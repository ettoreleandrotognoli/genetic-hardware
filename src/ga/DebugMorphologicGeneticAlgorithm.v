`ifndef __GA__DEBUG_MORPHOLOGIC_GENETIC_ALGORITHM__
`define __GA__DEBUG_MORPHOLOGIC_GENETIC_ALGORITHM__

`include "ga/MorphologicGeneticAlgorithm.v"
`include "util/SerialTXPackage.v"
`include "util/SerialRXPackage.v"
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
	input rx,
	output tx,
	//output error,
	output finish
);

	/*reg [ImageHeight*ImageWidth-1:0]origin;
	reg [ImageWidth*ImageHeight-1:0]objetive;*/
	wire [IndividualWidth-1:0]bestIndividual;
	wire [ErrorWidth-1:0]bestError;
	wire cycle;
	wire [63:0]rxData;
	wire [ImageHeight*ImageWidth-1:0]origin = rxData[63:32];
	wire[ImageWidth*ImageHeight-1:0]objetive = rxData[31:0];
	wire rxVoid;
	wire rxFull;
	wire txBusy;
	wire rxPull;

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
		.rst(rxVoid),
		.origin(origin),
		.objetive(objetive),
		.bestIndividual(bestIndividual),
		.bestError(bestError),
		.cycle(cycle)
	);


	wire running = bestError!={ErrorWidth{1'b0}};
	assign finish = ~running;
	
	reg [15:0] counter = {16{1'b0}};
	reg serialCe;

	always @(posedge cycle or posedge rxVoid) begin
		if (rxVoid) begin
			counter = {16{1'b0}};
			
			/*origin = {
				8'b00010000,
				8'b00111000,
				8'b00010000,
				8'b00000000
			};
			objetive = {
				8'b00111000,
				8'b01111100,
				8'b00111000,
				8'b00010000
			};*/
		end
		else begin
			if(running)
			begin
				counter = counter + 1'b1;
			end
			
		end
	end
	
	
	SerialRXPackage
		#(.AddressWidth(3),.WordWidth(8),.SerialTimerWidth(8),.QueueAddressWidth(1))
	serialRx
		(serialClk,rst,rx,~running & ~rxVoid,rxData,rxVoid,rxFull);
	

	SerialTXPackage
		#(.AddressWidth(3),.WordWidth(8),.SerialTimerWidth(8),.QueueAddressWidth(1))
	serialTx
		(serialClk,rst,~running & ~txBusy,{{16-ErrorWidth{1'b0}},bestError,counter,bestIndividual},tx,txBusy);



endmodule

`endif
