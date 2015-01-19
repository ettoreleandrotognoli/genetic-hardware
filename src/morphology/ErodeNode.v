module ErodeNode #(
	parameter Width = 3,
	parameter Height = 3
)(
	input [Width*Height-1:0]element,
	input [Width*Height-1:0]D,
	output Q
);

	wire [Width*Height-1:0]sums;
	assign Q = &sums;
	
	genvar l,c;
	generate
		for(l=0;l<Height;l=l+1)
		begin: _line_
			for(c=0;c<Width;c=c+1)
			begin: _column_
				assign sums[l*Width+c] = D[l*Width+c] | ~element[l*Width+c];
			end
		end

	endgenerate



endmodule