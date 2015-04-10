`include "util/Queue2To1.v"

module Queue2To1Test;

	parameter Width = 8;
	parameter AddressWidth =2;

	reg clk;
	reg rst;
	reg push;
	reg pull;
	reg [Width*2-1:0]D;
	wire [Width-1:0]Q;
	wire void;
	wire full;

	Queue2To1 #(
		.Width(Width),
		.AddressWidth(AddressWidth)
	)
	queue (
		.clk(clk),
		.rst(rst),
		.push(push),
		.pull(pull),
		.D(D),
		.Q(Q),
		.void(void),
		.full(full)
	);

	integer i;
	initial
	begin
		$dumpfile("test/util/Queue2To1Test.vcd");
		$dumpvars(0,queue);
		clk = 1'b0;
		rst = 1'b1;
		push = 1'b0;
		pull =1'b0;
		D = 0;
		#1;
		rst = 1'b0;
		for(i=0;i<500;i=i+1)
		begin
			#2;
			push = ~full;
			pull = ~void;
			D = $random;
		end
		while(1)
		begin
			#1;	
			push = 1'b0;
			pull = ~void;
		end
	end

	initial
	begin
		#1000;
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
