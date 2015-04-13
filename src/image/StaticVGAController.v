`ifndef __STATIC_VGA_CONTROLLER__
`define __STATIC_VGA_CONTROLLER__


module StaticVGAController #(
	parameter LeftBorder = 48,
	parameter RightBorder = 16,
	parameter TopBorder = 33,
	parameter BottomBorder = 10,
	parameter Width = 640,
	parameter Height = 480,
	parameter SyncCounterWidth = 2,

	parameter LineAddressWidth = $clog2(Width),
	parameter ColumnAddressWidth = $clog2(Height),

	parameter LineCounterWidth = $clog2(Height+TopBorder+BottomBorder),
	parameter ColumnCounterWidth = $clog2(Width+LeftBorder+RightBorder),
	
	parameter MaxLine = Height+TopBorder+BottomBorder,
	parameter MaxColumn = Width+LeftBorder+RightBorder
) (
	input clk,
	input rst,
	output [LineAddressWidth-1:0]line,
	output [ColumnCounterWidth-1:0]column,
	output verticalOn,
	output verticalSync,
	output horizontalOn,
	output horizontalSync
);

reg hSync;
reg vSync;
reg [SyncCounterWidth-1:0]syncCounter;
reg [LineCounterWidth-1:0]lineCounter;
reg [ColumnCounterWidth-1:0]columnCounter;

assign verticalSync = ~vSync;
assign horizontalSync = ~hSync;
assign verticalOn = lineCounter >= TopBorder && lineCounter < (Height + TopBorder) ;
assign horizontalOn = (columnCounter >= LeftBorder && columnCounter < (Width+LeftBorder)) & verticalOn;

assign line = verticalOn?lineCounter - TopBorder:0;
assign column = horizontalOn?columnCounter - LeftBorder:0;

always @(posedge clk or posedge rst) begin
	if (rst)
	begin
		syncCounter = 0;
		lineCounter = 0;
		columnCounter = 0;
		hSync = 1'b1;
		vSync = 1'b1;
	end
	else if(hSync | vSync)
	begin
		if(syncCounter == {SyncCounterWidth{1'b1}})
		begin
			syncCounter = 0;
			if(vSync)
			begin
				vSync = 1'b0;
			end
			else
			begin
				hSync = 1'b0;
			end
		end
		else
		begin
			syncCounter = syncCounter+1'b1;
		end
	end
	else
	begin
		if(columnCounter == MaxColumn)
		begin
			columnCounter = 0;
			hSync = 1'b1;
			if (lineCounter == MaxLine)
			begin
				lineCounter = 0;
				vSync = 1'b1;
			end
			else
			begin
				lineCounter = lineCounter + 1'b1;	
			end
		end
		else
		begin
			columnCounter = columnCounter + 1'b1;	
		end
		
	end
end

endmodule

`endif