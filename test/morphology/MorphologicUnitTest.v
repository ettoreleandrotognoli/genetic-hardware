`include "morphology/MorphologicUnit.v"

module MorphologicUnitTest;

	parameter ImageWidth=8;
	parameter ImageHeigh=4;

	reg [ImageWidth*ImageHeigh-1:0]img;
	reg [8:0]el;
	reg [2:0]op;
	wire [ImageWidth*ImageHeigh-1:0]result;	


	MorphologicUnit #(
		.ImageWidth(ImageWidth),
		.ImageHeight(ImageHeigh)
	)
	unit(
		.img(img),
		.el(el),
		.op(op),
		.result(result)
	);


	integer i;
	initial
	begin
		$dumpfile("test/morphology/MorphologicUnitTest.vcd");
		$dumpvars(0,unit);
		img = 0;
		el = 0;
		op =0;
		#1;
		img = {
			8'b00000000,
			8'b00001000,
			8'b00010000,
			8'b00000000
		};
		el = {
			3'b000,
			3'b001,
			3'b000
		};
		for(i=0;i<8;i=i+1)
		begin
			op = i;
			#1;
			$monitor("%b\n-------------\n",op);
			#1;
			$monitor("%b\n%b\n%b\n%b\n\n",img[31:24],img[23:16],img[15:8],img[7:0]);
			#1;
			$monitor("%b\n%b\n%b\n\n\n",el[8:6],el[5:3],el[2:0]);
			#1;
			$monitor("%b\n%b\n%b\n%b\n\n",result[31:24],result[23:16],result[15:8],result[7:0]);
			#1;
			$monitor("-------------");
		end
		$finish;
	end

endmodule