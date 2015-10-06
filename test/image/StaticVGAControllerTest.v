`include "image/StaticVGAController.v"

module StaticVGAControllerTest;

	parameter Width = 640;
	parameter Height = 480;

	parameter LineAddressWidth = $clog2(Height);
	parameter ColumnAddressWidth = $clog2(Width);


	reg clk;
	reg rst;
	wire [LineAddressWidth-1:0]line;
	wire [ColumnAddressWidth-1:0]column;
	wire verticalSync;
	wire horizontalSync;

	StaticVGAController #(
		.Width(Width),
		.Height(Height),
		.LineAddressWidth(LineAddressWidth),
		.ColumnAddressWidth(ColumnAddressWidth)
	)
	vga (
		.clk(clk),
		.rst(rst),
		.line(line),
		.column(column),
		.verticalSync(verticalSync),
		.horizontalSync(horizontalSync)
	);


	initial
	begin
		$dumpfile("test/image/StaticVGAControllerTest.vcd");
		$dumpvars(0,vga);
		clk = 1'b0;
		rst = 1'b1;
		#1;
		rst = 1'b0;
	end

	initial
	begin
		forever
		begin
			#1;
			clk = ~clk;
		end
	end

	initial
	begin
		#1000000;
		$finish;
	end



endmodule