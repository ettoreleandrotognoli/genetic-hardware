`include "image/StaticVGAController.v"
`include "ga/MorphologicGeneticAlgorithm.v"
`include "random/RandomicCAParitBased.v"
`include "ca/DynamicBinaryCellularAutomata2D.v"

module GeneticHardware (
	////////////////////	Clock Input	 	////////////////////	 
	input CLOCK_27,							//	27 MHz
	input CLOCK_50,							//	50 MHz
	input EXT_CLOCK,						//	External Clock
	////////////////////	Push Button		////////////////////
	input [3:0]KEY,							//	Button[3:0]
	////////////////////	DPDT Switch		////////////////////
	input [17:0]DPDT_SW,						//	DPDT Switch[17:0]
	////////////////////	7-SEG Dispaly	////////////////////
	output [7:0]HEX0,							//	Seven Segment Digital 0
	output [7:0]HEX1,							//	Seven Segment Digital 1
	output [7:0]HEX2,							//	Seven Segment Digital 2
	output [7:0]HEX3,							//	Seven Segment Digital 3
	output [7:0]HEX4,							//	Seven Segment Digital 4
	output [7:0]HEX5,							//	Seven Segment Digital 5
	output [7:0]HEX6,							//	Seven Segment Digital 6
	output [7:0]HEX7,							//	Seven Segment Digital 7
	////////////////////////	LED		////////////////////////
	output [8:0]LEDG,						//	LED Green[8:0]
	output [17:0]LEDR,						//	LED Red[17:0]
	////////////////////////	UART	////////////////////////
//	UART_TXD,						//	UART Transmitter
//	UART_RXD,						//	UART Receiver
//	////////////////////////	IRDA	////////////////////////
//	IRDA_TXD,						//	IRDA Transmitter
//	IRDA_RXD,						//	IRDA Receiver
//	/////////////////////	SDRAM Interface		////////////////
//	DRAM_DQ,						//	SDRAM Data bus 16 Bits
//	DRAM_ADDR,						//	SDRAM Address bus 12 Bits
//	DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
//	DRAM_UDQM,						//	SDRAM High-byte Data Mask
//	DRAM_WE_N,						//	SDRAM Write Enable
//	DRAM_CAS_N,						//	SDRAM Column Address Strobe
//	DRAM_RAS_N,						//	SDRAM Row Address Strobe
//	DRAM_CS_N,						//	SDRAM Chip Select
//	DRAM_BA_0,						//	SDRAM Bank Address 0
//	DRAM_BA_1,						//	SDRAM Bank Address 0
//	DRAM_CLK,						//	SDRAM Clock
//	DRAM_CKE,						//	SDRAM Clock Enable
//	////////////////////	Flash Interface		////////////////
//	FL_DQ,							//	FLASH Data bus 8 Bits
//	FL_ADDR,						//	FLASH Address bus 22 Bits
//	FL_WE_N,						//	FLASH Write Enable
//	FL_RST_N,						//	FLASH Reset
//	FL_OE_N,						//	FLASH Output Enable
//	FL_CE_N,						//	FLASH Chip Enable
//	////////////////////	SRAM Interface		////////////////
//	SRAM_DQ,						//	SRAM Data bus 16 Bits
//	SRAM_ADDR,						//	SRAM Adress bus 18 Bits
//	SRAM_UB_N,						//	SRAM High-byte Data Mask 
//	SRAM_LB_N,						//	SRAM Low-byte Data Mask 
//	SRAM_WE_N,						//	SRAM Write Enable
//	SRAM_CE_N,						//	SRAM Chip Enable
//	SRAM_OE_N,						//	SRAM Output Enable
//	////////////////////	ISP1362 Interface	////////////////
//	OTG_DATA,						//	ISP1362 Data bus 16 Bits
//	OTG_ADDR,						//	ISP1362 Address 2 Bits
//	OTG_CS_N,						//	ISP1362 Chip Select
//	OTG_RD_N,						//	ISP1362 Write
//	OTG_WR_N,						//	ISP1362 Read
//	OTG_RST_N,						//	ISP1362 Reset
//	OTG_FSPEED,						//	USB Full Speed,	0 = Enable, Z = Disable
//	OTG_LSPEED,						//	USB Low Speed, 	0 = Enable, Z = Disable
//	OTG_INT0,						//	ISP1362 Interrupt 0
//	OTG_INT1,						//	ISP1362 Interrupt 1
//	OTG_DREQ0,						//	ISP1362 DMA Request 0
//	OTG_DREQ1,						//	ISP1362 DMA Request 1
//	OTG_DACK0_N,					//	ISP1362 DMA Acknowledge 0
//	OTG_DACK1_N,					//	ISP1362 DMA Acknowledge 1
//	////////////////////	LCD Module 16X2		////////////////
//	LCD_ON,							//	LCD Power ON/OFF
//	LCD_BLON,						//	LCD Back Light ON/OFF
//	LCD_RW,							//	LCD Read/Write Select, 0 = Write, 1 = Read
//	LCD_EN,							//	LCD Enable
//	LCD_RS,							//	LCD Command/Data Select, 0 = Command, 1 = Data
//	LCD_DATA,						//	LCD Data bus 8 bits
//	////////////////////	SD_Card Interface	////////////////
//	SD_DAT,							//	SD Card Data
//	SD_DAT3,						//	SD Card Data 3
//	SD_CMD,							//	SD Card Command Signal
//	SD_CLK,							//	SD Card Clock
//	////////////////////	USB JTAG link	////////////////////
//	TDI,  							// CPLD -> FPGA (data in)
//	TCK,  							// CPLD -> FPGA (clk)
//	TCS,  							// CPLD -> FPGA (CS)
//	 TDO,  							// FPGA -> CPLD (data out)
//	////////////////////	I2C		////////////////////////////
//	I2C_SDAT,						//	I2C Data
//	I2C_SCLK,						//	I2C Clock
//	////////////////////	PS2		////////////////////////////
//	PS2_DAT,						//	PS2 Data
//	PS2_CLK,						//	PS2 Clock
//	////////////////////	VGA		////////////////////////////
	output VGA_CLK,   						//	VGA Clock
	output VGA_HS,							//	VGA H_SYNC
	output VGA_VS,							//	VGA V_SYNC
	output VGA_BLANK,						//	VGA BLANK
	output VGA_SYNC,						//	VGA SYNC
	output [9:0]VGA_R,   						//	VGA Red[9:0]
	output [9:0]VGA_G,	 						//	VGA Green[9:0]
	output [9:0]VGA_B  						//	VGA Blue[9:0]
//	////////////	Ethernet Interface	////////////////////////
//	ENET_DATA,						//	DM9000A DATA bus 16Bits
//	ENET_CMD,						//	DM9000A Command/Data Select, 0 = Command, 1 = Data
//	ENET_CS_N,						//	DM9000A Chip Select
//	ENET_WR_N,						//	DM9000A Write
//	ENET_RD_N,						//	DM9000A Read
//	ENET_RST_N,						//	DM9000A Reset
//	ENET_INT,						//	DM9000A Interrupt
//	ENET_CLK,						//	DM9000A Clock 25 MHz
//	////////////////	Audio CODEC		////////////////////////
//	AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
//	AUD_ADCDAT,						//	Audio CODEC ADC Data
//	AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
//	AUD_DACDAT,						//	Audio CODEC DAC Data
//	AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
//	AUD_XCK,						//	Audio CODEC Chip Clock
//	////////////////	TV Decoder		////////////////////////
//	TD_DATA,    					//	TV Decoder Data bus 8 bits
//	TD_HS,							//	TV Decoder H_SYNC
//	TD_VS,							//	TV Decoder V_SYNC
//	TD_RESET,						//	TV Decoder Reset
//	TD_CLK,							//	TV Decoder Line Locked Clock
//	////////////////////	GPIO	////////////////////////////
//	GPIO_0,							//	GPIO Connection 0
//	GPIO_1							//	GPIO Connection 1
);


//////////////////////////////	UART	////////////////////////////
//output			UART_TXD;				//	UART Transmitter
//input			UART_RXD;				//	UART Receiver
//////////////////////////////	IRDA	////////////////////////////
//output			IRDA_TXD;				//	IRDA Transmitter
//input			IRDA_RXD;				//	IRDA Receiver
/////////////////////////		SDRAM Interface	////////////////////////
//inout	[15:0]	DRAM_DQ;				//	SDRAM Data bus 16 Bits
//output	[11:0]	DRAM_ADDR;				//	SDRAM Address bus 12 Bits
//output			DRAM_LDQM;				//	SDRAM Low-byte Data Mask 
//output			DRAM_UDQM;				//	SDRAM High-byte Data Mask
//output			DRAM_WE_N;				//	SDRAM Write Enable
//output			DRAM_CAS_N;				//	SDRAM Column Address Strobe
//output			DRAM_RAS_N;				//	SDRAM Row Address Strobe
//output			DRAM_CS_N;				//	SDRAM Chip Select
//output			DRAM_BA_0;				//	SDRAM Bank Address 0
//output			DRAM_BA_1;				//	SDRAM Bank Address 0
//output			DRAM_CLK;				//	SDRAM Clock
//output			DRAM_CKE;				//	SDRAM Clock Enable
//////////////////////////	Flash Interface	////////////////////////
//inout	[7:0]	FL_DQ;					//	FLASH Data bus 8 Bits
//output	[21:0]	FL_ADDR;				//	FLASH Address bus 22 Bits
//output			FL_WE_N;				//	FLASH Write Enable
//output			FL_RST_N;				//	FLASH Reset
//output			FL_OE_N;				//	FLASH Output Enable
//output			FL_CE_N;				//	FLASH Chip Enable
//////////////////////////	SRAM Interface	////////////////////////
//inout		[15:0]	SRAM_DQ;				//	SRAM Data bus 16 Bits
//output	[17:0]	SRAM_ADDR;			//	SRAM Address bus 18 Bits
//output			SRAM_UB_N;				//	SRAM High-byte Data Mask 
//output			SRAM_LB_N;				//	SRAM Low-byte Data Mask 
//output			SRAM_WE_N;				//	SRAM Write Enable
//output			SRAM_CE_N;				//	SRAM Chip Enable
//output			SRAM_OE_N;				//	SRAM Output Enable
//////////////////////	ISP1362 Interface	////////////////////////
//inout	[15:0]	OTG_DATA;				//	ISP1362 Data bus 16 Bits
//output	[1:0]	OTG_ADDR;				//	ISP1362 Address 2 Bits
//output			OTG_CS_N;				//	ISP1362 Chip Select
//output			OTG_RD_N;				//	ISP1362 Write
//output			OTG_WR_N;				//	ISP1362 Read
//output			OTG_RST_N;				//	ISP1362 Reset
//output			OTG_FSPEED;				//	USB Full Speed,	0 = Enable, Z = Disable
//output			OTG_LSPEED;				//	USB Low Speed, 	0 = Enable, Z = Disable
//input			OTG_INT0;				//	ISP1362 Interrupt 0
//input			OTG_INT1;				//	ISP1362 Interrupt 1
//input			OTG_DREQ0;				//	ISP1362 DMA Request 0
//input			OTG_DREQ1;				//	ISP1362 DMA Request 1
//output			OTG_DACK0_N;			//	ISP1362 DMA Acknowledge 0
//output			OTG_DACK1_N;			//	ISP1362 DMA Acknowledge 1
//////////////////////	LCD Module 16X2	////////////////////////////
//inout	[7:0]	LCD_DATA;				//	LCD Data bus 8 bits
//output			LCD_ON;					//	LCD Power ON/OFF
//output			LCD_BLON;				//	LCD Back Light ON/OFF
//output			LCD_RW;					//	LCD Read/Write Select, 0 = Write, 1 = Read
//output			LCD_EN;					//	LCD Enable
//output			LCD_RS;					//	LCD Command/Data Select, 0 = Command, 1 = Data
//////////////////////	SD Card Interface	////////////////////////
//inout			SD_DAT;					//	SD Card Data
//inout			SD_DAT3;				//	SD Card Data 3
//inout			SD_CMD;					//	SD Card Command Signal
//output			SD_CLK;					//	SD Card Clock
//////////////////////////	I2C		////////////////////////////////
//inout			I2C_SDAT;				//	I2C Data
//output			I2C_SCLK;				//	I2C Clock
//////////////////////////	PS2		////////////////////////////////
//input		 	PS2_DAT;				//	PS2 Data
//input			PS2_CLK;				//	PS2 Clock
//////////////////////	USB JTAG link	////////////////////////////
//input  			TDI;					// CPLD -> FPGA (data in)
//input  			TCK;					// CPLD -> FPGA (clk)
//input  			TCS;					// CPLD -> FPGA (CS)
//output 			TDO;					// FPGA -> CPLD (data out)
//////////////////////////	VGA			////////////////////////////
//output			VGA_CLK;   				//	VGA Clock
//output			VGA_HS;					//	VGA H_SYNC
//output			VGA_VS;					//	VGA V_SYNC
//output			VGA_BLANK;				//	VGA BLANK
//output			VGA_SYNC;				//	VGA SYNC
//output	[9:0]	VGA_R;   				//	VGA Red[9:0]
//output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
//output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
//////////////////	Ethernet Interface	////////////////////////////
//inout	[15:0]	ENET_DATA;				//	DM9000A DATA bus 16Bits
//output			ENET_CMD;				//	DM9000A Command/Data Select, 0 = Command, 1 = Data
//output			ENET_CS_N;				//	DM9000A Chip Select
//output			ENET_WR_N;				//	DM9000A Write
//output			ENET_RD_N;				//	DM9000A Read
//output			ENET_RST_N;				//	DM9000A Reset
//input				ENET_INT;				//	DM9000A Interrupt
//output			ENET_CLK;				//	DM9000A Clock 25 MHz
//////////////////////	Audio CODEC		////////////////////////////
//inout			AUD_ADCLRCK;			//	Audio CODEC ADC LR Clock
//input			AUD_ADCDAT;				//	Audio CODEC ADC Data
//inout			AUD_DACLRCK;			//	Audio CODEC DAC LR Clock
//output		AUD_DACDAT;				//	Audio CODEC DAC Data
//inout			AUD_BCLK;				//	Audio CODEC Bit-Stream Clock
//output		AUD_XCK;				//	Audio CODEC Chip Clock
//////////////////////	TV Devoder		////////////////////////////
//input	[7:0]	TD_DATA;    			//	TV Decoder Data bus 8 bits
//input			TD_HS;					//	TV Decoder H_SYNC
//input			TD_VS;					//	TV Decoder V_SYNC
//output		TD_RESET;				//	TV Decoder Reset
//input			TD_CLK;					//	TV Decoder Line Locked Clock
//////////////////////////	GPIO	////////////////////////////////
//inout	[35:0]	GPIO_0;					//	GPIO Connection 0
//inout	[35:0]	GPIO_1;					//	GPIO Connection 1
////////////////////////////////////////////////////////////////////

wire clk = CLOCK_50;
reg [24:0]resetTimer = 0;
reg rst = 1'b1;
reg clk25 = 1'b0;
reg [22:0]timer = 0;
wire lowClk = timer[22];
assign HEX0 = {7{lowClk}};

always @(posedge clk)
begin
	clk25=~clk25;
	timer = timer + 1;
end



always @(posedge clk)
begin
	if(rst && resetTimer != {25{1'b1}}) 
	begin
		resetTimer = resetTimer + 1;
	end
	else
	begin
		rst = 1'b0;
	end
end

wire [8:0]vgaLine;
wire [9:0]vgaColumn;
wire verticalOn;
wire horizontalOn;

wire [29:0]barColor = 
	(vgaColumn >= 0 && vgaColumn < 80)? {30{1'b1}}:
	(vgaColumn >= 80 && vgaColumn < 160)? {{10{1'b1}},{10{1'b1}},{10{1'b0}}}:
	(vgaColumn >= 160 && vgaColumn < 240)? {{10{1'b0}},{10{1'b1}},{10{1'b1}}}:
	(vgaColumn >= 240 && vgaColumn < 320)? {{10{1'b0}},{10{1'b1}},{10{1'b0}}}:
	(vgaColumn >= 320 && vgaColumn < 400)? {{10{1'b1}},{10{1'b0}},{10{1'b1}}}:
	(vgaColumn >= 400 && vgaColumn < 480)? {{10{1'b1}},{10{1'b0}},{10{1'b0}}}:
	(vgaColumn >= 480 && vgaColumn < 560)? {{10{1'b0}},{10{1'b0}},{10{1'b1}}}:{30{1'b0}};
	
assign {VGA_R,VGA_G,VGA_B} = 
	(~(horizontalOn & verticalOn))?0:
	(vgaLine >=0 && vgaLine < 240)?barColor:~barColor;
	
assign VGA_BLANK = horizontalOn & verticalOn;
assign VGA_SYNC = 1'b0;
assign VGA_CLK = clk25;

MorphologicGeneticAlgorithm #(
	.ImageWidth(8),
	.ImageHeight(4),
	.OpcodeWidth(16),
	.OpCounterWidth(1)
)
ga(
	.clk(clk),
	.rst(rst),
	.origin({
		8'b00000000,
		8'b00010000,
		8'b00010000,
		8'b00000000
	}),
	.objetive({
		8'b00001000,
		8'b00011100,
		8'b00011100,
		8'b00001000
	}),
	.bestIndividual(),
	.bestError(LEDG)
);


StaticVGAController
vga (
	.clk(clk25),
	.rst(rst),
	.line(vgaLine),
	.column(vgaColumn),
	.verticalOn(verticalOn),
	.verticalSync(VGA_VS),
	.horizontalOn(horizontalOn),
	.horizontalSync(VGA_HS)
);


RandomicCAParitBased#(
//DynamicBinaryCellularAutomata2D #(
	.Width(18)
)
randomic(
	.clk(lowClk),
	.rst(rst),
	.ce(~rst),
	.random(LEDR)
	//.clk(lowClk),
	//.rst(rst),
	//.ce(~rst),
	//.rule(150),
	//.set(18'b010011100101000110),
	//($random[CAWidth-1:0] | $random[CAWidth-1:0]),
	//.state(LEDR)
);

endmodule
