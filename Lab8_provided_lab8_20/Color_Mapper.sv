//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper (	input Clk,Reset,
                       input     [9:0] DrawX, DrawY,       // Current pixel coordinates
							  input [3:0]data_npc,data_hp,data_beat_hp,data_beat_npc,
                       output logic [7:0] VGA_R, VGA_G, VGA_B, // VGA RGB output
						  input logic [15:0]SRAM_DQ,
						  input logic is_HP,is_NPC,
						 // input logic is_HPBeat,is_NPCBeat,
						  input logic is_Beat_HP,is_Beat_NPC,
						 // input logic is_start,is_play,is_end1,is_end2;
						  input logic b_color,
						  input logic beat_color,
						  input logic [31:0]HP_SRAM_ADDR,BG_SRAM_ADDR,NPC_SRAM_ADDR,START_SRAM_ADDR,WIN1_SRAM_ADDR,WIN2_SRAM_ADDR,BeatHP_SRAM_ADDR,BeatNPC_SRAM_ADDR,//,START_SRAM_ADDR,WIN1_SRAM_ADDR,WIN2_SRAM_ADDR;
						  output logic [31:0]SRAM_ADDR,
						  //input logic is_background,
						  input logic [3:0] background_data,win1_data,win2_data,start_data,
						  input logic is_start,is_play,is_end1,is_end2
						  
					);
					
    
	 logic [23:0] color;
    logic [7:0] Red, Green, Blue;
    logic [23:0] portrait_palette [0:15];
	 logic [23:0] npc_palette [0:15];
	 logic [23:0] background_palette [0:15];
	 logic [23:0] start_palette [0:15];
	 logic [23:0] win1_palette [0:15];
	 logic [23:0] win2_palette [0:15];
	 logic [23:0] beat_palette [0:4];
	 
	 logic [23:0] background_color,start_color,win1_color,win2_color;
	 //logic [23:0] color_bg,color_hp,c
	 //logic [31:0]hp_ADDR;
	 //logic [31:0]SRAM_ADDR_in;
	//	logic present;
	
   assign background_palette='{24'h6B5A6B, 24'h592420, 24'h636C5D, 24'h7B7976,
										 24'hFC912E, 24'hDAC976, 24'h5097A9, 24'h326198, 
										 24'h202052, 24'h791A2D, 24'hC40D12, 24'h96BADC, 
										 24'h424A4F, 24'h131C0F, 24'h080804, 24'hBBC6C5};
	
	 assign portrait_palette=  '{24'hFFFFFF, 24'hB3BDC5, 24'h002798, 24'h453530, 
										  24'h54616B, 24'h906651, 24'hF1E3CF, 24'hE3ECF3, 
										  24'h838F98, 24'hC89F73, 24'hC89F73, 24'h2A3937, 
										  24'h000FF0, 24'h731210, 24'h4D3419, 24'hAEAE97};
										  
	assign npc_palette= '{24'hFFFFFF, 24'hF8D0F8, 24'h171D17, 24'h414149, 
								24'h242C24, 24'h767373, 24'h8F152C, 24'h170000, 
								24'h9D3A44, 24'h791A2D, 24'hBD060A, 24'h96BADC, 
								24'h424A4F, 24'h0F120F, 24'h040404, 24'hF8E090};
								
								
										
	 assign start_palette='{24'hAD0909, 24'h0953AD, 24'h636C5D, 24'h2314CF, 
									24'hCB7D1C, 24'hE0C8B3, 24'h8C4751, 24'hE6D1B8, 
									24'h202052, 24'h1C0A5F, 24'h12110F, 24'hEDE9DF, 
									24'hAF8634, 24'hB56876, 24'h1A2B93, 24'hFFCEDF};
									
	assign win1_palette='{24'h6B5A6B, 24'h592420, 24'h636C5D, 24'h7B7976,
										 24'hFC912E, 24'hDAC976, 24'h5097A9, 24'h326198, 
										 24'h202052, 24'h791A2D, 24'hC40D12, 24'h96BADC, 
										 24'h424A4F, 24'h131C0F, 24'h080804, 24'hBBC6C5};
					
  assign win2_palette='{24'h6B5A6B, 24'h592420, 24'h636C5D, 24'h7B7976,
										 24'hFC912E, 24'hDAC976, 24'h5097A9, 24'h326198, 
										 24'h202052, 24'h791A2D, 24'hC40D12, 24'h96BADC, 
										 24'h424A4F, 24'h131C0F, 24'h080804, 24'hBBC6C5};
										  
	assign beat_palette='{24'hFFFFFF,24'h892300,24'hF2AB0A,24'hFEE5A0,24'h360E00};	  
	
	assign VGA_R = color[23:16];
   assign VGA_G = color[15:8];
   assign VGA_B = color[7:0];	

	// always_comb
	//	begin
	//	SRAM_ADDR=BG_SRAM_ADDR;
	//	color=background_palette[SRAM_DQ];
	//	present=1'd1;
	//	if (b_color==1'b1)
	//	begin
	//		if (DrawX>10'd320)
	//			color=24'hF20500;
	//		else
	//			color=24'h0000FF;
	//	end
	//	
	//	if (is_HP == 1'b1)
	//		begin
	//			SRAM_ADDR=HP_SRAM_ADDR;
	//			color=portrait_palette[SRAM_DQ];
	//			
	//			
	//		end
	//	else if (is_NPC==1'b1)
	//		begin
	//			SRAM_ADDR=NPC_SRAM_ADDR;
	//			color=portrait_palette[SRAM_DQ];
	//			
	//		end
	//	end
	//	
		
		assign background_color=background_palette[background_data];
		assign start_color=start_palette[start_data];
		assign win1_color=win1_palette[win1_data];
		assign win2_color=win2_palette[win2_data];
		
		always_comb
		begin
		SRAM_ADDR=1'd0;
		color=start_color;
		if (is_start==1)
			begin
			SRAM_ADDR=1'd0;
			color=start_color;
			end
		else if (is_play==1)
			begin
				SRAM_ADDR=1'd0;
				color=background_color;
				if (b_color==1'b1)
					begin
						if (DrawX>10'd320)
							color=24'hF20500;
						else
							color=24'h0000FF;
						end
				if (beat_color==1'b1)
					begin
						if (DrawX>10'd320)
							color=24'h0000FF;
						else
							color=24'hF20500;
						end
				if ((is_HP == 1'b1)&&(data_hp))
					begin
						SRAM_ADDR=HP_SRAM_ADDR;
						color=portrait_palette[SRAM_DQ];
					end
				if ((is_NPC==1'b1)&&(data_npc))
					begin
						SRAM_ADDR=NPC_SRAM_ADDR;
						color=npc_palette[SRAM_DQ];
					end
				else if ((is_Beat_HP)&&(data_beat_hp))
					begin
						SRAM_ADDR=BeatHP_SRAM_ADDR;
						color=beat_palette[SRAM_DQ];
					end
				else if ((is_Beat_NPC)&&(data_beat_npc))
					begin
						SRAM_ADDR=BeatNPC_SRAM_ADDR;
						color=beat_palette[SRAM_DQ];
					end
			end
		else if(is_end1==1)
			begin
				SRAM_ADDR=1'd0;
				color=win1_color;
			end
		else if(is_end2==1)
			begin
				SRAM_ADDR=1'd0;
				color=win2_color;
				//color=win2_color;
			end
		end	
endmodule
