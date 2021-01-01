//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab8( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1,
				 output logic [7:0] LEDG,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK ,     //SDRAM Clock
				output logic SRAM_CE_N,SRAM_UB_N,SRAM_LB_N,SRAM_OE_N,SRAM_WE_N,
				output logic [31:0] SRAM_ADDR,
				input logic [15:0] SRAM_DQ
                    );
    logic [8:0] hp_r;	
	 logic [8:0] npc_r;
	 assign hp_r=9'd150;
	 assign npc_r=9'd150;
    logic Reset_h, Clk;
    logic [31:0] keycode;
    logic [9:0] DrawX, DrawY;
	 logic [320:0] random_data;
    assign Clk = CLOCK_50;
	 
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        
    end
	 
    logic [31:0] BG_SRAM_ADDR,HP_SRAM_ADDR,NPC_SRAM_ADDR,START_SRAM_ADDR,WIN1_SRAM_ADDR,WIN2_SRAM_ADDR,BeatHP_SRAM_ADDR,BeatNPC_SRAM_ADDR;
	
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 
	 logic [15:0] Data_from_SRAM, Data_to_SRAM;
   //-------------------------------- 
	 
	 logic is_HP;
	 logic is_NPC;
	//------------------------------------ 
	logic [9:0]HP_X_Pos;
	logic [9:0]HP_Y_Pos;
	 //-------------------------------
	logic [9:0] NPC_X_Pos;	

	logic is_f,is_NPC_fist,is_win1,is_win2,is_hp2_fist;
	logic [8:0] hp_value,npc_value;
	logic [8:0] hp_hit,npc_hit;
	logic w_on, a_on, s_on, d_on, f_on, j_on, k_on,l_on,i_on,h_on,f1_on,f2_on, enter_on, esc_on,p_on,q_on;
	logic two_player;
	logic is_start,is_play,is_end1,is_end2;
	logic b_color,beat_color;
	logic [3:0] data_hp,data_npc,data_beat_hp,data_beat_npc;
   logic NPC_face_d, HP_face_d;
	logic is_HPBeat,is_NPCBeat;//whether beat
	logic is_Beat_NPC,is_Beat_HP;//for position
		reg [9:0] HP_X,NPC_X;//this is the postion of beat
	
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     
     lab8_soc lab8_soc(
                             .clk_clk(Clk), 
								     .random_export_export_data(random_data),
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset));
    
    
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
   
    VGA_controller vga_controller_instance( .Clk(Clk),         // 50 MHz clock
                                           .Reset(Reset_h),       // Active-high reset signal
														 .VGA_HS(VGA_HS),      // Horizontal sync pulse.  Active low
                                           .VGA_VS(VGA_VS),      // Vertical sync pulse.  Active low
														 .VGA_CLK(VGA_CLK),     // 25 MHz VGA clock input
														 .VGA_BLANK_N(VGA_BLANK_N), // Blanking interval indicator.  Active low.
                                           .VGA_SYNC_N(VGA_SYNC_N),  // Composite Sync signal.  Active low.  We don't use it in this lab,
                                                        // but the video DAC on the DE2 board requires an input for it.
														 .DrawX(DrawX),       // horizontal coordinate
                                           .DrawY(DrawY)        // vertical coordinate
                        );
    
   
	keycode_reader keycode_reader(.keycode,
											.w_on, .a_on, .s_on, .d_on,.f_on, .j_on, .k_on,.l_on,.i_on,.h_on,.f1_on,.f2_on, .enter_on, .esc_on,.p_on,.q_on
											);
											
	logic test_beat_hp,test_beat_npc;
						
						
   HP HP(.Clk,
			.frame_clk(VGA_VS),
			.Reset(Reset_h),
			//.is_play,
			.w_on, .a_on, .s_on, .d_on,.f_on,.f1_on,.f2_on,
			.HP_SRAM_ADDR,
         .DrawX,
         .DrawY,
			.data_hp,
         .is_HP,
			.is_f,
			.HP_face_d,
			.hp_hit,
			.HP_X_Pos,
			.HP_Y_Pos,
			.NPC_X_Pos,
			.NPC_X,
			.is_NPCBeat,
			.test_beat_hp
			);
	
	
	NPC NPC(.Clk,
			.frame_clk(VGA_VS),
			.Reset(Reset_h),
			//.is_play,
			.NPC_X_Pos,
			.NPC_SRAM_ADDR,
			.HP_X_Pos,
			.HP_Y_Pos,
         .DrawX,
         .DrawY,
			.data_npc,
         .is_NPC,
			.is_NPC_fist,
			.npc_hit,
			.two_player,
			.NPC_face_d,
			.j_on,.k_on,.l_on,.i_on,.h_on,.f1_on,.f2_on,
			.n(random_data[31:0]),
			.p(random_data[63:32]),
			.q(random_data[95:64]),
			.HP_X,
			.is_HPBeat,
			.test_beat_npc
			);
				
	
	
	fight fight(
			.Clk,
			//.is_play,
			.hp_f(is_f),
			.npc_f(is_NPC_fist),
			.f1_on,.f2_on,
			.Reset(Reset_h),
			.frame_clk(VGA_VS),
			.hp_r,
			.npc_r,
			.HP_X_Pos,
			.NPC_X_Pos,
			.hp_hit,.npc_hit,
			.hp_value,.npc_value,
			.is_win1, .is_win2,
			.NPC_X,.HP_X,//new
			.is_HPBeat,.is_NPCBeat,//new
			.test_beat_npc,.test_beat_hp
			);
	 
	
	//PAGES_ADDR PAGES_ADDR(//.Clk, 
	//							.DrawX, .DrawY,
	//							.BG_SRAM_ADDR,
	//							.START_SRAM_ADDR,
	//							.WIN1_SRAM_ADDR,
	//							.WIN2_SRAM_ADDR
	//							);	
	
	logic [3:0] background_data,win1_data,win2_data,start_data;
	background background(
								.Clk, 
								.DrawX, .DrawY,
								.background_data,
								.start_data,
								.win1_data,
								.win2_data,
								);
	
	
	blood blood(.DrawX, .DrawY,
					.blood_value_hp(hp_value),.blood_value_npc(npc_value),//if npc give negative blood va
					.b_color
					);
						
						
   color_mapper color_instance( .Reset(Reset_h),
											.Clk,
											.is_HP,
											.is_NPC,
											.is_start,.is_play,.is_end1,.is_end2, //new modified
											//.is_HPBeat,.is_NPCBeat,
											.is_Beat_HP,.is_Beat_NPC,
											.b_color,
											.beat_color,
											.SRAM_DQ,
											.HP_SRAM_ADDR,
											.BG_SRAM_ADDR,
											.NPC_SRAM_ADDR,.START_SRAM_ADDR,.WIN1_SRAM_ADDR,.WIN2_SRAM_ADDR,.BeatHP_SRAM_ADDR,.BeatNPC_SRAM_ADDR,
											.SRAM_ADDR,
											.data_npc,
											.data_hp,
											.data_beat_hp,.data_beat_npc,
											.DrawX, .DrawY,       // Current pixel coordinates
											.VGA_R, .VGA_G, .VGA_B,// VGA RGB output
											.start_data,
											.win1_data,
											.background_data,
											.win2_data
											);
							
	
	Beat Beat ( .q_on,.p_on,
					.HP_X_Pos, .NPC_X_Pos,
					.Clk,
					.Reset(Reset_h),
					.frame_clk(VGA_VS),
	            .DrawX, .DrawY,
					.HP_face_d,.NPC_face_d,
					.is_Beat_HP,.is_Beat_NPC,
					.is_HPBeat,.is_NPCBeat,
					.BeatHP_SRAM_ADDR,.BeatNPC_SRAM_ADDR,
					.beat_color,
					.data_beat_hp,.data_beat_npc,
					.HP_X,.NPC_X
				);

	Page_FSM Page_FSM(.Clk,.Reset(Reset_h),
							.f1_on,.f2_on,.enter_on, 
							.is_win1,.is_win2,
							.is_start,.is_play,.is_end1,.is_end2, .two_player
							);
	
	 assign SRAM_CE_N = 1'b0;
	 assign SRAM_UB_N = 1'b0;
	 assign SRAM_LB_N = 1'b0;
	 assign SRAM_WE_N = 1'b1; //I assume that we are never writing. 
	 assign SRAM_OE_N = 1'b0;
    
    endmodule
