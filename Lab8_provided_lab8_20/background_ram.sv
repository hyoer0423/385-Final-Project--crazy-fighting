//module PAGES_ADDR (
//	//input Clk, 
//	
//	input logic [9:0] DrawX, DrawY,
//	output logic [31:0] BG_SRAM_ADDR,
//	output logic [31:0] START_SRAM_ADDR,
//	output logic [31:0] WIN1_SRAM_ADDR,
//	output logic [31:0] WIN2_SRAM_ADDR
//	
//	//output logic is_background
//);
//	// screen size
//	//parameter [9:0] SCREEN_WIDTH =  10'd480;
//   //parameter [9:0] SCREEN_LENGTH = 10'd640;
//	parameter [9:0] RESHAPE_LENGTH = 10'd640;
//	
//	assign BG_SRAM_ADDR = DrawX + DrawY*RESHAPE_LENGTH+32'hD0000;
//	assign START_SRAM_ADDR = DrawX + DrawY*RESHAPE_LENGTH+32'hD0000;
//	assign WIN1_SRAM_ADDR = DrawX + DrawY*RESHAPE_LENGTH+32'hD0000;
//	assign WIN2_SRAM_ADDR = DrawX + DrawY*RESHAPE_LENGTH+32'hD0000;
//	
//endmodule


module background (
	input Clk, 
	input logic [9:0] DrawX, DrawY,
	output logic [3:0] background_data,
	output logic [3:0] start_data,
	output logic [3:0] win1_data,
	output logic [3:0] win2_data
	
);
	// screen size
	parameter [9:0] SCREEN_WIDTH =  10'd480;
   parameter [9:0] SCREEN_LENGTH = 10'd640;
	parameter [9:0] RESHAPE_LENGTH = 10'd320;
	//--------------------load memory-----------------//
	logic [18:0] read_address;
	assign read_address = DrawX/2 + DrawY/2*RESHAPE_LENGTH;
	background_RAM background_RAM(.*);
	start_RAM start_RAM(.*);
	win1_RAM win1_RAM(.*);
	win2_RAM win2_RAM(.*);
endmodule





module  background_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] background_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:76799];
initial
begin
	 $readmemh("huge_background/Background.txt", mem);
end


always_ff @ (posedge Clk) begin
	background_data<= mem[read_address];
end

endmodule





module  start_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] start_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:76799];
initial
begin
	 $readmemh("huge_background/start.txt", mem);
end


always_ff @ (posedge Clk) begin
	start_data<= mem[read_address];
end

endmodule




module  win1_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] win1_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:76799];
initial
begin
	 $readmemh("huge_background/end1.txt", mem);
end


always_ff @ (posedge Clk) begin
	win1_data<= mem[read_address];
end

endmodule

module  win2_RAM
(
		input [18:0] read_address,
		input Clk,

		output logic [3:0] win2_data
);

// mem has width of 4 bits and a total of 307200 addresses
//logic [3:0] mem [0:307199];
logic [3:0] mem [0:76799];
initial
begin
	 $readmemh("huge_background/end2.txt", mem);
end


always_ff @ (posedge Clk) begin
	win2_data<= mem[read_address];
end

endmodule
