`include "memory/Word.v"

module WordTest;

	parameter Width = 8;
	parameter RST = {Width{1'b0}};
	parameter PST = {Width{1'b1}};

	reg clk;
	reg rst;
	reg pst;
	reg we;
	reg [Width-1:0]D;
	wire [Width-1:0]Q;

	Word
		#(.Width(Width),.RST(RST),.PST(PST))
	word
		(clk,rst,pst,we,D,Q);

	initial
	begin
		$dumpfile("test/memory/WordTest.vcd");
		$dumpvars(0,word);
		clk = 1'b0;
		rst = 1'b1;
		pst = 1'b0;
		we = 1'b0;
		D = $random;
		#1;
		rst = 1'b0;
		#1;
		we = 1'b1;
		clk = 1'b1;
		#1;
		clk =1'b0;
		#1;
		pst= 1'b1;
		#1;
		rst = 1'b1;
		#1;
		$finish;
	end



endmodule

