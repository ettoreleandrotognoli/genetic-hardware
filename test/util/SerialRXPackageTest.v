`include "util/SerialRXPackage.v"
`include "util/SerialTXPackage.v"

module SerialRXPackageTest;

	parameter AddressWidth = 2;
	parameter WordWidth = 8;
	parameter SerialTimerWidth = 3;
	parameter QueueAddressWidth = 2;

	reg clk;
	reg rst;
	reg ce;
	
	reg pull;
	reg [2**AddressWidth*WordWidth-1:0]txData;
	wire [2**AddressWidth*WordWidth-1:0]rxData;
	wire void;
	wire full;
	wire txBusy;

	wire rxtx;

	SerialTXPackage
		#(.AddressWidth(AddressWidth),.WordWidth(WordWidth),.SerialTimerWidth(SerialTimerWidth),.QueueAddressWidth(QueueAddressWidth))
	serialTx
		(.clk(clk),.rst(rst),.ce(ce & ~txBusy),.data(txData),.tx(rxtx),.busy(txBusy));

	SerialRXPackage
		#(.AddressWidth(AddressWidth),.WordWidth(WordWidth),.SerialTimerWidth(SerialTimerWidth),.QueueAddressWidth(QueueAddressWidth))
	serialRx
		(.clk(clk),.rst(rst),.rx(rxtx),.pull(pull),.Q(rxData),.void(void),.full(full));


	integer i;
	initial
	begin
		$dumpfile("test/util/SerialRXPackageTest.vcd");
		$dumpvars(0,serialTx);
		$dumpvars(0,serialRx);
		clk = 1'b0;
		rst = 1'b1;
		ce = 1'b0;
		pull = 1'b0;
		txData = 0;
		#1;
		rst=1'b0;
		txData = $random;
		ce = 1'b1;
		for(i=0;i<10;i=i+1)
		begin
			#1;
			clk = ~clk;
			if (i % 2 == 1)
			begin
				txData = $random;	
			end
		end
		ce = 1'b0;
		for(i=0;i<5000;i=i+1)
		begin
			#1;
			clk = ~clk;
		end
		pull = 1'b1;
		while(~void)
		begin
			clk = ~clk;
			#1;
		end
		$finish;
	end

endmodule