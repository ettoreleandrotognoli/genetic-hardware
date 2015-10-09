`include "io/Pwm.v"
`include "io/SerialRx.v"
`include "io/SerialTx.v"
`include "util/SerialTXPackage.v"
`include "io/ServoTx.v"
`include "time/ClockDivisor.v"
`include "ga/DebugMorphologicGeneticAlgorithm.v"
`include "image/DebugMorphologicProcessor.v"
//`include "morphology/Dilate.v"




module GeneticHardware #(
	parameter owner = "ettore"
)(
	input clk,
	//input rst,
	input rx,
	output tx
//	output [7:0]leds
//	output [1:0]servos
);

reg rst = 1'b1;
//reg pwmWe =1'b1;
//reg servoWe =1'b1;
//reg [2:0]ledAddress = 3'b000;
wire [7:0]data;
wire div10;
wire serialClock;
//wire rxFinish;
wire txBusy;
wire powerClock;
wire pwmClk;
wire error;
wire finish;
wire clock;

ClockDivisor #(24,6777216) powerupTimer (clk,1'b0,powerClock);

//ClockDivisor #(8,22) clockDivisorPwm (clk,rst,pwmClk);
ClockDivisor #(3,0) clockDivisorRx (clk,rst,serialClock);
ClockDivisor #(2,0) mainClock (clk,rst,clock);


DebugMorphologicGeneticAlgorithm debug(clock,rst,serialClock,rx,tx,finish);
always @(posedge powerClock)
begin
	if(powerClock)
	begin
		rst = 1'b0;
	end
end

/*always @(posedge rxFinish or posedge rst)
begin
	if(rst)
	begin
		ledAddress = 3'b000;
	end
	else
	begin
		ledAddress = ledAddress + 1'b1;
	end
end*/


endmodule

