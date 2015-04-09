`ifndef __FILE_RAM__
`define __FILE_RAM__

module FileRAM #(
	parameter Width = 8,
	parameter AddressSize = 4,
	parameter File = ""

) (
	input clk,
	input rst,
	input we,
	input [AddressSize-1:0]addr,
	input [Width-1:0]D,
	output [Width-1:0]Q
);

	reg [Width-1:0]mem[2**AddressSize-1:0];

	assign Q = mem[addr];

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			$readmemb(File,mem);	
		end
		else if (we) begin
			mem[addr] = D;
			$writememb(File, mem);
		end
	end




endmodule

`endif