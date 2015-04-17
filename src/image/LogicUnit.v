`ifndef __LOGIC_UNIT__
`define __LOGIC_UNIT__


module LogicUnit #(
	parameter ImageWidth = 8,
	parameter ImageHeight = 8
) (
	input [ImageHeight*ImageWidth-1:0]imgA,
	input [ImageHeight*ImageWidth-1:0]imgB,
	input [2:0]op,
	output [ImageHeight*ImageWidth-1:0]result
);


assign result = 
	op == 3'b000 ? imgA : //a bypass
	op == 3'b001 ? imgB : //b bypass
	op == 3'b010 ? ~imgA : //not a
	op == 3'b011 ? ~imgB : //not b
	op == 3'b100 ? imgA & imgB : //and
	op == 3'b101 ? imgA | imgB : //or
	op == 3'b110 ? imgA ^ imgB : //xor
	op == 3'b111 ? ~(imgA ^ imgB) :0; //not xor

endmodule

`endif