module Beat ( 
	input logic q_on,p_on,
	input logic [9:0]HP_X_Pos, NPC_X_Pos,
	input Clk,
			Reset,
			frame_clk,
	input logic [9:0] DrawX, DrawY,
	input HP_face_d,NPC_face_d,
	output logic is_Beat_HP,is_Beat_NPC,//used to find the position
	output reg [9:0] HP_X,NPC_X,
	output logic is_HPBeat,is_NPCBeat,
	output logic [31:0] BeatHP_SRAM_ADDR,BeatNPC_SRAM_ADDR,
	output logic beat_color,
	output logic [3:0] data_beat_hp,data_beat_npc
);

//0lengque
logic [31:0] offset,offset2;
//reg [9:0]HP_X,NPC_X;
reg hp_Beat,NPC_Beat;
reg [4:0] ff,mm;
reg [1:0]HP_d,NPC_d;
assign offset=32'h61A80;
assign offset2=32'hC8320;
reg [2:0] cc,dd;
logic [31:0]read_address_beat_hp;
logic [31:0]read_address_beat_npc;


parameter [9:0] Beat_SIZE_X = 10'd100;
parameter [9:0] Beat_SIZE_Y = 10'd50;
parameter [9:0] HP_Y = 10'd300;
parameter [9:0] NPC_Y = 10'd300;

always_ff @(posedge frame_clk) 	
	//updates flip flop, current state is the only one
    begin
	 if (Reset)
		begin
		ff<=5'b0;
		is_HPBeat<=1'b0;
		//hp_Beat<=1'b1;
		HP_X<=10'b0;
		HP_d<=1'b0;
		cc<=4'b0;
		end
		
	 if ((q_on)&&(hp_Beat!=0))
		begin
		ff<=5'd1;
		cc<=4'b1;
		is_HPBeat<=1'd1;
		//hp_Beat<=1'd0;
		if (HP_face_d==1'd1)
			HP_d<=2'd0;
		else
			HP_d<=2'd2;
		 HP_X<=HP_X_Pos+100*(HP_d-1'd1);
		end
	 else if(hp_Beat==0)
		begin
		cc<= cc+4'b1;
		if (cc==4'b0)
			ff<= ff+1;
		if ((HP_X< 10'd739)&&(HP_X>0))
			begin
			is_HPBeat<=1'd1;
			HP_X<=HP_X+4*(HP_d-1'd1);
			end
		else
			is_HPBeat<=1'd0;
		end	
	 else 
		begin
		ff<=5'd0;
		is_HPBeat<=1'd0;
		cc<=4'b0;
		end
	end
	
	
	always_comb
	begin 
	if (ff==5'd0)
		hp_Beat=1'd1;
	else
		hp_Beat=1'd0;
	end
	
	
	hp_beat_matrix beat_matrix_hp(
				.read_address(read_address_beat_hp),
				.Clk,
				.data_Out(data_beat_hp),
				);	
	/////////////////////////////
	
	always_comb begin
	is_Beat_HP=1'b0;
	BeatHP_SRAM_ADDR=32'h0;
	read_address_beat_hp=32'h0;
	if (DrawX<=(HP_X+10'd99)&& DrawX>=(HP_X-10'd100)&& DrawY<=(HP_Y+10'd49)&& DrawY>=(HP_Y-10'd50))begin
			if (HP_face_d==1'b1)
					begin
					read_address_beat_hp=DrawX-HP_X+19'd100 + (DrawY-10'd300+10'd50)*19'd200;
					BeatHP_SRAM_ADDR = DrawX-HP_X+19'd100 + (DrawY-10'd300+10'd50)*19'd200+offset;
					end
			else
					begin
					read_address_beat_hp=-DrawX+HP_X+19'd100+ (DrawY-10'd300+10'd50)*19'd200;
					BeatHP_SRAM_ADDR =-DrawX+HP_X+19'd100+ (DrawY-10'd300+10'd50)*19'd200+offset;
					end
			is_Beat_HP=1'b1;
			end
	end
  //assign BeatHP_SRAM_ADDR= DrawX-HP_X+19'd50 + (DrawY-10'd300+10'd25)*19'd50+offset;
  
  always_ff @(posedge frame_clk) 
  begin
	 if (Reset)
		begin
		mm<=5'b0;
		is_NPCBeat<=1'b0;
		//NPC_Beat<=1'b1;
		NPC_X<=10'b0;
		NPC_d<=1'b0;
		dd<=4'b0;
		end
		
	 if ((p_on)&&(NPC_Beat!=0))
		begin
		mm<=5'd1;
		is_NPCBeat<=1'd1;
		//NPC_Beat<=1'd0;
		if (NPC_face_d==1'd1)
			NPC_d<=2'd0;
		else
			NPC_d<=2'd2;
		NPC_X<=NPC_X_Pos+10'd100*(NPC_d-10'd1);
		//NPC_X<=NPC_X_Pos+100;
		end
	 else if(NPC_Beat==0)
		begin
		dd<= dd+3'd1;
		if (dd==0)
			mm<=mm+5'b1;
		if ((NPC_X< 10'd739)&&(NPC_X>0))
			begin
			is_NPCBeat<=1'd1;
			NPC_X<=NPC_X+4*(NPC_d-1'd1);
			end
		else
			is_NPCBeat<=1'd0;
		end	
	 else 
		begin
		mm<=4'd0;
		dd<=4'd0;
		is_NPCBeat<=1'd0;
		end
	end
	
	
	always_comb
	begin 
	if (mm==10'd0)
		NPC_Beat=1'd1;
	else
		NPC_Beat=1'd0;
	end
	
	
	npc_beat_matrix beat_matrix_npc(
				.read_address(read_address_beat_npc),
				.Clk,
				.data_Out(data_beat_npc),
				);	
	
	always_comb begin
	is_Beat_NPC=1'b0;
	BeatNPC_SRAM_ADDR=32'h0;
	read_address_beat_npc=32'h0;
	if (DrawX<=(NPC_X+10'd99)&& DrawX>=(NPC_X-10'd100)&& DrawY<=(NPC_Y+10'd49)&& DrawY>=(NPC_Y-10'd50))begin
			if (NPC_face_d==1'b1)
					begin
					read_address_beat_npc=DrawX-NPC_X+19'd100 + (DrawY-10'd300+10'd50)*19'd200;
					BeatNPC_SRAM_ADDR= DrawX-NPC_X+19'd100 + (DrawY-10'd300+10'd50)*19'd200+offset2;
					end
			else	
					begin
					read_address_beat_npc=-DrawX+NPC_X+19'd100 + (DrawY-10'd300+10'd50)*19'd200;
					BeatNPC_SRAM_ADDR=-DrawX+NPC_X+19'd100 + (DrawY-10'd300+10'd50)*19'd200+offset2;
					end
			is_Beat_NPC=1'b1;
			end
	end
			
   parameter [9:0] NP_Xhp_end = 10'd600; 
   parameter [9:0] NP_Xnpc_Start = 10'd40;  
	parameter [9:0] NP_Y_Start = 10'd80;
	parameter [9:0] NP_SIZE_X = 10'd100;
	parameter [9:0] NP_SIZE_Y = 10'd25;
	
	always_comb begin
	//is_blood=1'd0;
	beat_color=1'd0;
	if ((DrawX<=NP_Xhp_end) && (DrawX>=NP_Xhp_end-NP_SIZE_X)&& (DrawY<=NP_Y_Start+NP_SIZE_Y)&& (DrawY>=NP_Y_Start))
	begin
		//is_blood=1'b1;
	if  (ff==10'd0)
				beat_color=1'd1;
	else
		begin
		if (DrawX<=NP_Xhp_end-ff*2)
			//grey
			beat_color=1'd0;
		else
			//red
			beat_color=1'd1;
		end
	if(hp_Beat==1'b0)
	begin
	 if ((DrawX<=NP_Xhp_end) &&(DrawX>=NP_Xhp_end-ff*2))
			beat_color=1'd1;
	 else 
		 beat_color=1'd0;
		end
	end
	
	
	if ((DrawX>=NP_Xnpc_Start) && (DrawX<=NP_Xnpc_Start+NP_SIZE_X) && (DrawY<=NP_Y_Start+NP_SIZE_Y)&& (DrawY>=NP_Y_Start))
	 begin
		//is_blood=1'b1;
		if (mm==4'd0)
			
				beat_color=1'd1;
		else
			begin
			if (DrawX>=NP_Xnpc_Start+mm*2)
			//grey
				beat_color=1'd0;
			else
			//red
				beat_color=1'd1;
	if(NPC_Beat==1'b0)
	begin
	 if ((DrawX>=NP_Xnpc_Start) &&(DrawX<=NP_Xnpc_Start+mm*2))
			beat_color=1'd1;
	 else 
		 beat_color=1'd0;
		
	end	
	end
	
			
	 end
	
	end	
endmodule
