`include "io/SerialRX.v"
`include "io/SerialTX.v"

module SerialRX_tb;

	reg clk,ce,rst;
	reg [7:0]dtx;
	wire s,txBusy,rxFinish;
	wire [7:0]drx;
	
	SerialTX #(8,8) stx(clk,rst,ce,dtx,s,txBusy);
	SerialRX #(8,8) srx(clk,rst,s,drx,rxFinish);

	integer i;
	initial
	begin
		$dumpfile("test/io/SerialRX_tb.vcd");
		$dumpvars(0,stx);
		$dumpvars(0,srx);
		dtx = 0;
		ce = 0;
		rst = 1;
		#1;
		rst = 0;
		for(i=0;i<30;i=i+1)
		begin
			dtx = $random;
			ce = 1;
			#3000;
		end
		$finish;
	end
	initial
	begin
		clk=0;
		forever #1 clk = ~clk;
	end

endmodule
