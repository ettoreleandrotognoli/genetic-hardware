`ifndef __MORPHOLOGIC_UNIT__
`define __MORPHOLOGIC_UNIT__

`include "morphology/Dilate.v"
`include "morphology/Erode.v"

module MorphologicUnit #(
	parameter ImageWidth=32,
	parameter ImageHeight=32
) (
	input [ImageWidth*ImageHeight-1:0]img,
	input [8:0]el,
	input [2:0]op,
	output [ImageWidth*ImageHeight-1:0]result
);

assign {ceDilate,swapDilate,ceErode,swapErode} =
	op == 3'b000 ? 4'b0000: //bypass
	op == 3'b001 ? 4'b1000: //dil
	op == 3'b010 ? 4'b0010: //ero
	op == 3'b011 ? 4'b1010: //dil ero
	op == 3'b100 ? 4'b1111: //ero dil
	op == 3'b101 ? 4'b1011: //dil dil
	op == 3'b110 ? 4'b1110: //ero ero
	op == 3'b111 ? 4'b0000:4'b0000; //bypass

wire [ImageWidth*ImageHeight-1:0]image = img;
wire [8:0]element = el;
wire [8:0]relement;

generate
	genvar l,c;
	for(l=0;l<3;l=l+1)
	begin:_el_line_
		for(c=0;c<3;c=c+1)
		begin: _el_column_
			assign relement[(3-l-1)*3+(3-c-1)] = el[l*3+c];
		end
	end
endgenerate


wire ceDilate;
wire swapDilate;
wire [ImageWidth*ImageHeight-1:0]dilateIn = image;
wire [ImageWidth*ImageHeight-1:0]dilated;
wire [ImageWidth*ImageHeight-1:0]dilateResult = ceDilate ? dilated ^ {ImageWidth*ImageHeight{swapDilate}} : dilateIn;
Dilate #(
	.Width(ImageWidth),
	.Height(ImageHeight)
)
dilate(
	.imageIn(dilateIn ^ {ImageHeight*ImageWidth{swapDilate}}),
	.mask(swapDilate?relement:element),
	.imageOut(dilated)
);

wire ceErode;
wire swapErode;
wire [ImageWidth*ImageHeight-1:0]erodeIn = dilateResult;
wire [ImageWidth*ImageHeight-1:0]eroded;
wire [ImageWidth*ImageHeight-1:0]erodeResult = ceErode ? eroded^{ImageWidth*ImageHeight{swapErode}} : erodeIn;
Erode #(
	.Width(ImageWidth),
	.Height(ImageHeight)
)
erode(
	.imageIn(erodeIn ^ {ImageWidth*ImageHeight{swapErode}}),
	.mask(swapErode?relement:element),
	.imageOut(eroded)
);


assign result = erodeResult;

endmodule

`endif