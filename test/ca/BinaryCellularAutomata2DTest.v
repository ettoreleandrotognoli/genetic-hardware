`include "ca/BinaryCellularAutomata2D.v"

module BinaryCellularAutomata2DTest;

	parameter Width=16;

	reg clk,rst,ce,migrate;
	reg [Width-1:0]set;
	wire [Width-1:0]state30;
	wire [Width-1:0]state60;
	wire [Width-1:0]state90;
	wire [Width-1:0]state150;

	BinaryCellularAutomata2D #(.Width(Width),.Rule(8'b00011110)) rule30(clk,rst,ce,migrate?state60:set,state30);
	BinaryCellularAutomata2D #(.Width(Width),.Rule(8'b00111100)) rule60(clk,rst,ce,migrate?state90:set,state60);
	BinaryCellularAutomata2D #(.Width(Width),.Rule(8'b01011010)) rule90(clk,rst,ce,migrate?state150:set,state90);
	BinaryCellularAutomata2D #(.Width(Width),.Rule(8'b10010110)) rule150(clk,rst,ce,migrate?state30:set,state150);


	integer i,m;
	initial
	begin
		$dumpfile("test/ca/BinaryCellularAutomata2DTest.vcd");
		$dumpvars(0,rule30);
		$dumpvars(0,rule60);
		$dumpvars(0,rule90);
		$dumpvars(0,rule150);
		set= $random;
		#1;
		migrate =1'b0;
		rst = 1'b1;
		ce = 1'b0;
		clk =1'b0;
		#1;
		for (m=0;m<10;m=m+1)
		begin
			rst = 1'b0;
			ce = 1'b1;
			for (i=0;i<10;i=i+1)
			begin
				clk = ~clk;
				#1;
			end	
			migrate = 1'b1;
			rst = 1'b1;
			#1;
		end
		
		$finish;
	end	


	
endmodule
