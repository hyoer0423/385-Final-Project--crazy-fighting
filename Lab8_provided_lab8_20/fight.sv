module fight(
				input logic hp_f,
				input logic npc_f,
				input Clk,Reset,frame_clk,
				//input logic is_play,
				input logic f1_on,f2_on,
				input logic [8:0] hp_r,	npc_r,
				input logic [9:0] HP_X_Pos,
				input logic [9:0] NPC_X_Pos,
				input reg [9:0] NPC_X,HP_X,//new
				input logic is_HPBeat,is_NPCBeat,//new
				input logic test_beat_npc,test_beat_hp,
				output logic [8:0] hp_value,
				output logic [8:0] npc_value,
				output logic [8:0] hp_hit, npc_hit,hp_hit_big,npc_hit_big,
				output logic is_win1, is_win2
);

	logic [9:0] relative;
	logic [8:0] hp_hit_in, npc_hit_in,hp_value_in,npc_value_in;	
	logic hp_hit_big_in,npc_hit_big_in;
	
	logic frame_clk_delayed, frame_clk_rising_edge;
   always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
reg [3:0] mm,ff;
	always_ff @ (posedge Clk)
  begin
      if ((Reset)||(f1_on)||(f2_on))
      begin
			 mm<=4'b0;
          hp_value<=9'd200;
		    npc_value<=9'd200;
			 hp_hit<= 9'd0;
          npc_hit <= 9'd0;
			 hp_hit_big<=1'd0;
			 npc_hit_big<=1'd0;
			  ff<=4'b0;
      end

      else
      begin
         hp_value <= hp_value_in;
         npc_value <= npc_value_in;
			hp_hit <= hp_hit_in;
         npc_hit <= npc_hit_in;
			hp_hit_big <= hp_hit_big_in;
         npc_hit_big <= npc_hit_big_in;
      
		
		if (npc_hit!=0)
			
			mm <= mm+4'd1;
		else
			
			mm <= 4'b0;
		if (hp_hit!=0)
			
			ff <= ff+1'd1;
		else
			
			ff <= 4'b0;
		end
		
	end 
  

	always_comb
  begin

      // By default, keep motion and position unchanged
      hp_value_in = hp_value;
      npc_value_in = npc_value;
	   hp_hit_in = hp_hit;
      npc_hit_in = npc_hit;
		hp_hit_big_in = hp_hit_big;
      npc_hit_big_in = npc_hit_big;
		relative=npc_r;
      // Update position and motion only at rising edge of frame clock

      if (frame_clk_rising_edge)
      begin
			//if (HP_X_Pos>=NPC_X_Pos)
			//	relative = HP_X_Pos-NPC_X_Pos;
			//else
			//	relative= NPC_X_Pos-HP_X_Pos;
			
			if ((HP_X_Pos+hp_r)>=NPC_X_Pos &&(HP_X_Pos-hp_r)<=NPC_X_Pos)
				
				npc_hit_in=hp_f;
			else if ((HP_X+10'd10)>=NPC_X_Pos &&(HP_X-10'd10)<=NPC_X_Pos)
					npc_hit_in=2*(is_HPBeat|hp_f);
			else
				begin 
					npc_hit_in=0;
				end
				
			if ((NPC_X_Pos+npc_r)>=HP_X_Pos &&(NPC_X_Pos-npc_r)<=HP_X_Pos)
				hp_hit_in=npc_f;
			//else begin
			
				//else npc_hit_in=10'd0;
					
			else if ((NPC_X+10'd10)>=HP_X_Pos &&(NPC_X-10'd10)<=HP_X_Pos)
					hp_hit_in=2*(is_NPCBeat|npc_f);
			else 
				begin 
					hp_hit_in=0;
				end	
			
			//else 
			//	begin
			//		npc_hit_in=0;
			//		hp_hit_in=0;
			//	end
			//else hp_hit_in=10'd0;
			//if ((ff<4'd8)&&(ff!=0))
			hp_value_in =hp_value - hp_hit_in;
			//if ((mm<4'd8)&&(mm!=0))
			npc_value_in = npc_value - npc_hit_in;
		end
  end


  always_comb begin
		is_win1=1'b0;
		is_win2=1'b0;
		if (hp_value<=0)
			is_win2 = 1'b1;
		if (npc_value<=0)
			is_win1 = 1'b1;
	end	
endmodule
