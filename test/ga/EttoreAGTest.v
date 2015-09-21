`include "ga/EttoreAG.v"

module EttoreAGTest;

	parameter ErrorWidth=32;
	parameter IndividualWidth=32;
	parameter PopulationAddressWidth=5;

	reg clk;
	reg rst;

	wire fitnessStart;
	reg fitnessFinish;
	wire [IndividualWidth-1:0]fitnessIndividual;
	reg [ErrorWidth-1:0]fitnessError;
	wire [IndividualWidth-1:0]bestIndividual;
	wire [ErrorWidth-1:0]bestError;


	EttoreAG #(
		.ErrorWidth(ErrorWidth),
		.IndividualWidth(IndividualWidth),
		.PopulationAddressWidth(PopulationAddressWidth)
	)
	ag(
		.clk(clk),
		.rst(rst),
		.fitnessStart(fitnessStart),
		.fitnessFinish(fitnessFinish),
		.fitnessIndividual(fitnessIndividual),
		.fitnessError(fitnessError),
		.bestIndividual(bestIndividual),
		.bestError(bestError)
	);


	integer i;
	initial
	begin
		$dumpfile("test/ga/EttoreAGTest.vcd");
		$dumpvars(0,ag);
		clk= 1'b0;
		rst=1'b1;
		fitnessFinish=1'b0;
		fitnessError=0;
		#1;
		rst=1'b0;
		//for(i=0;i<10;i=i+1)
		while(1)
		begin
			fitnessFinish = 1'b0;
			@(posedge fitnessStart);
			#20;
			fitnessError = fitnessIndividual ^ {8{4'b1110}};
			fitnessFinish = 1'b1;
			#2;
		end
		fitnessFinish = 1'b0;
		//$finish;
	end


	initial
	begin
		forever
		begin
			#1;
			clk =~clk;
			if (bestError == 0)
			begin
				$finish;
			end
		end
	end

	initial
	begin
		#1000000;
		$finish;
	end


endmodule