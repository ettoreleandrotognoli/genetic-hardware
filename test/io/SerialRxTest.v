`include "io/SerialRx.v"
`include "io/SerialTx.v"

module SerialRxTest;

	reg clk,ce,rst;
	reg [7:0]dtx;
	wire s,txBusy,rxFinish;
	wire [7:0]drx;
	
	SerialTx #(8,8) stx(clk,rst,ce,dtx,s,txBusy);
	SerialRx #(8,8) srx(clk,rst,s,drx,rxFinish);

	integer i;
	initial
	begin
		$dumpfile("test/io/SerialRxTest.vcd");
		$dumpvars(0,stx);
		$dumpvars(0,srx);
		dtx = 0;
		ce = 1'b0;
		rst = 1'b1;
		#1;
		rst = 1'b0;
		#4;
		for(i=0;i<10;i=i+1)
		begin
			dtx = $random;
			ce = 1'b1;
			#4;
			while(txBusy == 1'b1)
			begin
				#2;
			end
			ce = 1'b0;
			#2;
			if(dtx != drx)
			begin
				$error("error");
			end
		end
		$finish;
	end
	initial
	begin
		clk=0;
		forever #1 clk = ~clk;
	end

endmodule
