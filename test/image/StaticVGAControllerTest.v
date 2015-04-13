`include "image/StaticVGAController.v"

module StaticVGAControllerTest;

	parameter LeftBorder = 48;
	parameter RightBorder = 16;
	parameter TopBorder = 33;
	parameter BottomBorder = 10;
	parameter Width = 640;
	parameter Height = 480;
	parameter SyncCounterWidth = 2;

	parameter LineAddressWidth = $clog2(Width);
	parameter ColumnAddressWidth = $clog2(Height);

	parameter LineCounterWidth = $clog2(Height+TopBorder+BottomBorder);
	parameter ColumnCounterWidth = $clog2(Width+LeftBorder+RightBorder);

	parameter MaxLine = Height+TopBorder+BottomBorder;
	parameter MaxColumn = Width+LeftBorder+RightBorder;

	reg clk;
	reg rst;
	wire [LineAddressWidth-1:0]line;
	wire [ColumnAddressWidth-1:0]column;
	wire verticalSync;
	wire horizontalSync;

	StaticVGAController #(
		.LeftBorder(LeftBorder),
		.RightBorder(RightBorder),
		.TopBorder(TopBorder),
		.BottomBorder(BottomBorder),
		.Width(Width),
		.Height(Height),
		.SyncCounterWidth(SyncCounterWidth),
		.LineAddressWidth(LineAddressWidth),
		.LineCounterWidth(LineCounterWidth),
		.MaxLine(MaxLine),
		.MaxColumn(MaxColumn)
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