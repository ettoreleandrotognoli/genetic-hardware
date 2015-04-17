`ifndef __ERODE__
`define __ERODE__

module Erode #(
	parameter Width = 32,
	parameter Height = 32
) (
	input [Width*Height-1:0]imageIn,
	input [8:0]mask,
	output [Width*Height-1:0]imageOut
);

wire [Width-1:0]point[Height-1:0];
wire [Width-1:0]ero[Height-1:0];

genvar l,c;
generate

for (l=0;l < Height ; l = l+1)
begin: _assign
  assign point[l] = imageIn[ (l * Width) + (Width - 1) :l * Width];
  assign imageOut[ (l * Width) + (Width - 1) :l * Width] = ero[l];
end

for (l =0; l< Height ; l = l+1)
begin: _ero
  for(c =0;c<Width;c = c+1)
  begin: _ero_
    assign ero[l][c] = &{
      ((l>0 && c>0 )?(point[l-1][c-1] | ~mask[0] ):1'b1),
      (( l >0 )?(point[l-1][c] | ~mask[1]):1'b1),
      (( l> 0 && c < Width-1)?(point[l-1][c+1] | ~mask[2]):1'b1),
      ((c >0)?(point[l][c-1] | ~mask[3]):1'b1),
      (point[l][c] | ~mask[4]),
      ((c<Width-1)?(point[l][c+1] | ~mask[5]):1'b1),
      ((l < Height-1 && c > 0)?(point[l+1][c-1] | ~mask[6]):1'b1),
      ((l<Height-1)?(point[l+1][c] | ~mask[7]):1'b1),
      ((l<Height-1 && c < Width-1)?(point[l+1][c+1] | ~mask[8]):1'b1)
    };
  end
end


endgenerate




endmodule


`endif
