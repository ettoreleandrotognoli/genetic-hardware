`include "ca/DynamicBinaryCellularAutomata2D.v"

module DynamicBinaryCellularAutomata2DTest;

	parameter Width = 16;

	reg clk;
	reg rst;
	reg ce;
	reg [7:0]rule;
	reg [Width-1:0]set;
	wire [Width-1:0]state;

	DynamicBinaryCellularAutomata2D 
		#(.Width(Width))
	automata
		(clk,rst,ce,rule,set,state);

	integer r,i;
	initial
	begin
		$dumpfile("test/ca/DynamicBinaryCellularAutomata2DTest.vcd");
		$dumpvars(0,automata);
		#1;
		for(r=0;r<=255;r=r+1)
		begin
			set = $random;
			clk = 1'b0;
			rst = 1'b1;
			ce = 1'b0;
			rule = r;
			#1;
			rst = 1'b0;
			ce = 1'b1;
			#1;
			for (i=0;i<50;i=i+1)
			begin
				clk = ~clk;#1;
			end
			clk = 1'b0;
			#1;
		end
		
		
		$finish;
	end

endmodule