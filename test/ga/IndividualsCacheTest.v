`include "ga/IndividualsCache.v"

module IndividualsCacheTest;

	parameter IndividualWidth = 32;
	parameter AddressWidth = 6;
	parameter ErrorWidth = 32;

	reg clk;
	reg rst;
	reg we;
	reg [IndividualWidth-1:0]inIndividual;
	reg [ErrorWidth-1:0]inError;
	reg [AddressWidth-1:0]addrIndividual1;
	wire [IndividualWidth-1:0]outIndividual1;
	wire [ErrorWidth-1:0]outError1;
	reg [AddressWidth-1:0]addrIndividual2;
	wire [IndividualWidth-1:0]outIndividual2;
	wire [ErrorWidth-1:0]outError2;

	IndividualsCache #(
		.IndividualWidth(IndividualWidth),
		.AddressWidth(AddressWidth),
		.ErrorWidth(ErrorWidth)
	)
	individualsCache (
		.clk(clk),
		.rst(rst),
		.we(we),
		.inIndividual(inIndividual),
		.inError(inError),
		.addrIndividual1(addrIndividual1),
		.outIndividual1(outIndividual1),
		.outError1(outError1),
		.addrIndividual2(addrIndividual2),
		.outIndividual2(outIndividual2),
		.outError2(outError2)
	);

	integer i;
	initial
	begin
		$dumpfile("test/ga/IndividualsCacheTest.vcd");
		$dumpvars(0,individualsCache);
		clk = 1'b0;
		rst = 1'b1;
		we = 1'b0;
		inIndividual = {IndividualWidth{1'b0}};
		inError = {ErrorWidth{1'b1}};
		addrIndividual1 = {AddressWidth{1'b0}};
		addrIndividual2 = {AddressWidth{1'b0}};
		#1;
		rst =1'b0;
		#1;
		for(i=0;i<1024;i=i+1)
		begin
			we = 1'b1;
			inIndividual = $random;
			inError = ~inIndividual;
			@(posedge clk);
			#1;
		end
		we = 1'b0;
		for(i=0;i<2**AddressWidth;i=i+1)
		begin
			addrIndividual1 = i;
			addrIndividual2 = ~i;
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
