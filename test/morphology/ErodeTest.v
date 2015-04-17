`include "morphology/Erode.v"

module ErodeTest;

	parameter Width = 8;
	parameter Height = 4;

	reg [Width*Height-1:0]imageIn;
	reg [8:0]mask;
	wire [Width*Height-1:0]imageOut;


	Erode #(
		.Width(Width),
		.Height(Height)
	)
	erode(
		.imageIn(imageIn),
		.mask(mask),
		.imageOut(imageOut)
	);

	initial
	begin
		$dumpfile("test/morphology/ErodeTest.vcd");
		$dumpvars(0,erode);
		imageIn = 0;
		mask = 0;
		#1;
		imageIn = {
			8'b00001100,
			8'b01111100,
			8'b11111000,
			8'b01100000
		};
		mask = {
			3'b010,
			3'b111,
			3'b010
		};
		$monitor("%b\n%b\n%b\n%b\n\n",imageIn[31:24],imageIn[23:16],imageIn[15:8],imageIn[7:0]);
		#1;
		$monitor("%b\n%b\n%b\n\n\n",mask[8:6],mask[5:3],mask[2:0]);
		#1;
		$monitor("%b\n%b\n%b\n%b\n\n",imageOut[31:24],imageOut[23:16],imageOut[15:8],imageOut[7:0]);
		#1;
		$finish;
	end

endmodule