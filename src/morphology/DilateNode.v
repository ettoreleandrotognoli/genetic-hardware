module DilateNode #(
	parameter Width = 3,
	parameter Height = 3
)(
	input [Width*Height-1:0]element,
	input [Width*Height-1:0]D,
	output Q
);

	wire [Width*Height-1:0]products;
	assign Q = |products;
	
	genvar l,c;
	generate
		for(l=0;l<Height;l=l+1)
		begin: _line_
			for(c=0;c<Width;c=c+1)
			begin: _column_
				assign products[l*Width+c] = D[l*Width+c] & element[(Height-1-l)*Width+(Width-1-c)];
			end
		end

	endgenerate



endmodule