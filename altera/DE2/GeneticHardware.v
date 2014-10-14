`include "io/SerialTx.v"

module GeneticHardware #(
	parameter owner = "ettore"
)(
	input clk,
	input rst,
	output tx,
	output busy
);

SerialTx #(.Width(8),.TimerWidth(8)) serialTx(clk,rst,1'b1,8'b11111111,tx,busy);

always @(posedge clk or posedge rst)
begin
	if(rst)
	begin
	end
	else
	begin
		
	end
end

endmodule
