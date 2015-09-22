`include "ca/BinaryCellularAutomata3D.v"


module BinaryCellularAutomata3DTest;

	parameter Width = 4;
	parameter Height = 4;

	reg clk;
	reg rst;
	reg ce;
	reg [8:0]survive;
	reg [8:0]rise;
	reg [Width*Height-1:0]set;
	wire [Width*Height-1:0]state;

	BinaryCellularAutomata3D
		#(.Width(Width),.Height(Height))
	automata
		(clk,rst,ce,survive,rise,set,state);

	integer r,i;
	initial
	begin
		$dumpfile("test/ca/BinaryCellularAutomata3DTest.vcd");
		$dumpvars(0,automata);
		set = {$random,$random};
		clk = 1'b0;
		rst = 1'b1;
		ce = 1'b0;
		survive = 9'b000010011;
		rise = 9'b000100100;
		#1;
		rst = 1'b0;
		ce = 1'b1;
		#1;
		for (i=0;i<5000;i=i+1)
		begin
			clk = ~clk;#1;
		end
		clk = 1'b0;
		#1;
		$finish;
	end

	

endmodule

