`ifndef __QUEUE__
`define __QUEUE__

`include "util/Buffer.v"

module Queue #(
	parameter Width = 8,
	parameter AddressWidth =2
)(
	input clk,
	input rst,
	input push,
	input pull,
	input [Width-1:0]D,
	output [Width-1:0]Q,
	output void,
	output full
);


	reg [AddressWidth-1:0]init = 0;
	reg [AddressWidth-1:0]finish =0;
	reg hasPush =1'b0;
	reg hasPull =1'b1;

	wire [2**AddressWidth-1:0]writeEnabled = 1'b1 << finish;
	wire [Width-1:0]data[2**AddressWidth-1:0];

	assign Q = data[init];

	generate
		genvar counter;
		for(counter=0;counter<2**AddressWidth;counter=counter+1)
		begin: queue_node
			Buffer #(.Width(Width),.Init({Width{1'b0}})) buffer (clk,rst,writeEnabled[counter] & push,D,data[counter]);
		end
	endgenerate

	always @(posedge clk or posedge rst)
	begin
		if(rst == 1'b1)	
		begin
			init = 0;
			finish = 0;
			hasPush = 1'b0;
			hasPull = 1'b1;
		end
		else
		begin
			if(push == 1'b1)
			begin
				finish = finish + 1'b1;
			end
			if(pull == 1'b1)
			begin
				init = init + 1'b1;
			end
			if(pull ^ push == 1'b1)
			begin
				hasPush = push;
				hasPull = pull;
			end
		end
	end

	assign void = hasPull & init == finish;
	assign full = hasPush & init == finish;

endmodule

`endif