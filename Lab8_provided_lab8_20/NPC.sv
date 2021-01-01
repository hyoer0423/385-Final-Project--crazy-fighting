module NPC (
   //input keycode,
	input Clk,
			Reset,
			frame_clk,
			//is_play,
	input [31:0] n,p,q,
	input [9:0]HP_X_Pos, HP_Y_Pos,
	input logic [8:0] npc_hit,
	input logic [9:0] DrawX, DrawY,
	input logic two_player,
	input logic j_on,k_on,l_on,i_on,h_on,f1_on,f2_on,
	input reg [9:0] HP_X,
	input logic is_HPBeat,
	output logic [31:0] NPC_SRAM_ADDR,
	output logic is_NPC,
	output logic [9:0] NPC_X_Pos,
	output logic is_NPC_fist,
	output logic NPC_face_d,
	output logic [3:0] data_npc,
	output logic test_beat_npc
	);
	// screen size
	parameter [9:0] NPC_X_Start = 10'd160;  // Center position on the X axis
   parameter [9:0] NPC_Y_Start = 10'd300;
	parameter [9:0] NPC_SIZE_X = 10'd100;
	parameter [9:0] NPC_SIZE_Y = 10'd125;
	parameter [9:0] X_Step=10'd3;
	parameter [9:0] Y_Step=10'd3;
	parameter [9:0] X_MIN=10'd0;
	parameter [9:0] X_MAX=10'd639;
	parameter [9:0] Y_MIN=10'd0;
	parameter [9:0] Y_MAX=10'd479;
	parameter [9:0] jump_high=10'd80;
	
	//--------------------load memory-----------------//
	logic [9:0] NPC_Y_Pos,NPC_X_Motion,NPC_Y_Motion;
   logic [9:0] NPC_X_Pos_in,  NPC_Y_Pos_in,NPC_X_Motion_in,NPC_Y_Motion_in;
	
	logic is_NPC_fist_in;
	logic NPC_face_d_in;
	logic j_onn,k_onn,l_onn,i_onn,h_onn;
	logic j_onn_in,k_onn_in,l_onn_in,i_onn_in,h_onn_in;
	logic j_on_in,k_on_in,l_on_in,i_on_in,h_on_in;
	logic j_onnn,k_onnn,l_onnn,i_onnn,h_onnn;
	logic [3:0] counterL,counterL_in;
	logic [3:0] counterR,counterR_in;
	logic [4:0] counterU,counterU_in;
	logic [3:0] counterD,counterD_in;
	logic [9:0] counterK,counterK_in;
	logic [2:0] counterF,counterF_in;
	logic [2:0] choose,choose_in;
	
	logic [31:0] offset_npc;
	
	//logic [7:0] keycode_auto,keycode_auto_in;
	
	logic frame_clk_delayed, frame_clk_rising_edge;
	
	 
	logic m,t,f,c;
	logic [31:0]read_address_npc;

	
	always_comb 
	begin
	if (n <90)
		m=1'b1;
	else
		m=1'b0;
	end 
	
	always_comb
		begin
	if( (30<p )&&(p<60))
	begin
		t=1'b1*m;
		c=1'b0;
		f=1'b0;
	end
	else if (p<30)
	begin
		t=1'b0;
		c=1'b1*m;
		f=1'b0;
	end
	else
	begin
		t=1'b0;
		c=1'b0;
		f=1'b1*m;
	end
	end	
	 logic se;
enum logic [3:0] {A, B,C,D}   curr_state, next_state; 
	reg [7:0] ff;
	always_ff @(posedge frame_clk) 	
	
	//updates flip flop, current state is the only one
    begin
	 if ((Reset)||(f1_on)||(f2_on))
	 begin
	 ff<=0;
	 l_onn<=0;
	 j_onn<=0;
	 k_onn<=0;
	 i_onn<=0;
	 h_onn<=0;
	end
	else
	 begin
	 ff <= ff+1'd1;
		l_onn<=l_onn_in;
				j_onn<=j_onn_in;
			   k_onn<=k_onn_in;
				i_onn<=i_onn_in;
			   h_onn<=h_onn_in;	 
        
	end			
    end

    // Assign outputs based on state
	always_comb
    begin
      l_onn_in=l_onn;
		j_onn_in=j_onn;
		k_onn_in=k_onn;
		i_onn_in=i_onn;
		h_onn_in=h_onn;
	if  (npc_hit>0)
	//input logic Reset_m,
//output logic can
			begin
			if (NPC_X_Pos>HP_X_Pos)
				begin
				se=1'b1;
				l_on_in=1'b0;
				j_on_in=1'b1;
				k_on_in=1'b0;
				i_on_in=1'b0;
				h_on_in=1'b0;
				//is_ff=1'b1;
				end
			else
				begin
				se=1'b1;
				l_on_in=1'b1;
				j_on_in=1'b0;
				k_on_in=1'b0;
				i_on_in=1'b0;
				h_on_in=1'b0;
				//is_ff=1'b1;
				end
			end
	
	else if ( NPC_X_Pos <= X_MIN + NPC_SIZE_X )
				begin
				se=1'b1;
						l_on_in=1'b1;
						j_on_in=1'b0;
						 k_on_in=1'b0;
						 i_on_in=1'b0;
						 h_on_in=1'b0;
				end		 
	else if ( NPC_X_Pos + NPC_SIZE_X >= X_MAX )// Ball is at the bottom edge, BOUNCE!
					begin
					se=1'b1;
						l_on_in=1'b0;
						j_on_in=1'b1;
						 k_on_in=1'b0;
						 i_on_in=1'b0;
						 h_on_in=1'b0;
					end	
	  
	 
		 	//required because I haven't enumerated all possibilities below
    else if     ((NPC_X_Pos-HP_X_Pos<=10'd150 )&&(-NPC_X_Pos+HP_X_Pos<=10'd150 ))
				begin
				se=1'b1;
				l_on_in=1'b0;
				j_on_in=1'b0;
				k_on_in=1'b0;
			   i_on_in=1'b0;
			   h_on_in=1'b1;
				end
	
			
	 else		
		  // Assign outputs based on ‘state’
        if (ff==8'd0)
	         begin
				se=1'b1;
				if (NPC_X_Pos>=HP_X_Pos+10'd200)//
					begin
					l_on_in=1'b1;
					j_on_in=1'b0;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b0;
					end	
				else if (NPC_X_Pos<=HP_X_Pos-10'd200)//
					begin
					l_on_in=1'b0;
					j_on_in=1'b1;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b0;
					end
				else 
					begin
					l_on_in=1'b0;
					j_on_in=1'b0;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b1*f;
					end
				end
		else if (ff<8'd90)
			begin
				  se=1'b0;
				  	l_on_in=1'b0;
					j_on_in=1'b0;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b1;
			end
				
		else if (ff==8'd90)
			begin
			se=1'b1;
				if ( NPC_X_Pos <= X_MIN + NPC_SIZE_X )
				begin
						l_on_in=1'b1;
						j_on_in=1'b0;
						 k_on_in=1'b0;
						 i_on_in=1'b0;
						 h_on_in=1'b0;
				end		 
				else if ( NPC_X_Pos + NPC_SIZE_X >= X_MAX )// Ball is at the bottom edge, BOUNCE!
					begin
						l_on_in=1'b0;
						j_on_in=1'b1;
						 k_on_in=1'b0;
						 i_on_in=1'b0;
						 h_on_in=1'b0;
					end	
				else if (NPC_X_Pos>=HP_X_Pos+10'd200)//
					begin
					l_on_in=1'b1;
					j_on_in=1'b0;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b0;
					end	
				else if (NPC_X_Pos<=HP_X_Pos-10'd200)//
					begin
					l_on_in=1'b0;
					j_on_in=1'b1;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b0;
					end
				else 
					begin
					l_on_in=1'b0;
					j_on_in=1'b0;
					k_on_in=1'b1*f;
					i_on_in=1'b0;
					h_on_in=1'b0;
					end
				end
			
		else if (ff<8'd180)
				
				begin
				  se=1'b0;
				  	l_on_in=1'b0;
					j_on_in=1'b0;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b1;
				end
		else if (ff==8'd180)
				 begin
				se=1'b1;
				if (NPC_X_Pos>=HP_X_Pos+10'd200)//
					begin
					l_on_in=1'b1;
					j_on_in=1'b0;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b0;
					end	
				else if (NPC_X_Pos<=HP_X_Pos-10'd200)//
					begin
					l_on_in=1'b0;
					j_on_in=1'b1;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b0;
					end
				else 
					begin
					l_on_in=1'b0;
					j_on_in=1'b0;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b1;
					end
				end
		else if (ff<8'd210)
			begin
			se=1'b1;
				 if (NPC_X_Pos>=HP_X_Pos+10'd200)//
					begin
					l_on_in=1'b1;
					j_on_in=1'b0;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b0;
					end	
				else if (NPC_X_Pos<=HP_X_Pos-10'd200)//
					begin
					l_on_in=1'b0;
					j_on_in=1'b1;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b0;
					end
				else 
					begin
					l_on_in=1'b0;
					j_on_in=1'b0;
					k_on_in=1'b0;
					i_on_in=1'b1*f;
					h_on_in=1'b0;
					end
				end
			
		else 	
			begin
			
				   se=1'b1;
				  	l_on_in=1'b0;
					j_on_in=1'b0;
					k_on_in=1'b0;
					i_on_in=1'b0;
					h_on_in=1'b0;
				end
				
			
					l_onn_in=(l_onn)*(1'd1-se)+se*l_on_in;
					j_onn_in=se*(j_on_in)+j_onn*(1'd1-se);
					k_onn_in=se*(k_on_in)+k_onn*(1'd1-se);
					i_onn_in=se*(i_on_in)+i_onn*(1'd1-se);
					h_onn_in=se*(h_on_in)+h_onn*(1'd1-se);
						
			
			
			end
				
assign l_onnn=two_player*(l_on)+(1'd1-two_player)*l_onn;
assign k_onnn=two_player*(k_on)+(1'd1-two_player)*k_onn;
assign j_onnn=two_player*(j_on)+(1'd1-two_player)*j_onn;     
assign i_onnn=two_player*(i_on)+(1'd1-two_player)*i_onn;
assign h_onnn=two_player*(h_on)+(1'd1-two_player)*h_onn;
always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
always_ff @ (posedge Clk)
  begin
      if ((Reset)||(f1_on)||(f2_on))
      begin
		
          NPC_X_Pos <= NPC_X_Start;
          NPC_Y_Pos <= NPC_Y_Start;
			 NPC_X_Motion <= 10'd0;
          NPC_Y_Motion <= 10'd0;
			 NPC_face_d<=1'b0;
			 
			 choose<=3'b000;
				
			counterL<=4'b0;
			counterR<=4'b0;
			counterD<=4'b0;
			counterU<=5'b0;
			
			counterF<=3'b0;
		
			NPC_face_d<=1'b0;
			is_NPC_fist<=1'b0;
			
			 //keycode_auto <= 8'd0;
			 counterK<=4'b0;
          
      end
      else
      begin
		
         NPC_X_Pos <= NPC_X_Pos_in;
         NPC_Y_Pos <= NPC_Y_Pos_in;
		   NPC_X_Motion <= NPC_X_Motion_in;
         NPC_Y_Motion <= NPC_Y_Motion_in;
			
			choose<=choose_in;
			counterL<=counterL_in;
			counterR<=counterR_in;
			counterD<=counterD_in;
			counterU<=counterU_in;
			counterF<=counterF_in;
			
			NPC_face_d<=NPC_face_d_in;
			is_NPC_fist<=is_NPC_fist_in;
			
			//keycode_auto <= keycode_auto_in;
			counterK<=counterK_in;
      end
  end
  
	always_comb
   begin
      // By default, keep motion and position unchanged
      NPC_X_Pos_in = NPC_X_Pos;
      NPC_Y_Pos_in = NPC_Y_Pos;
      NPC_X_Motion_in = NPC_X_Motion;
      NPC_Y_Motion_in = NPC_Y_Motion;
		
		
		choose_in=choose;
		counterL_in=counterL;
		counterF_in=counterF;
		counterR_in=counterR;
		counterD_in=counterD;
		counterU_in=counterU;
		NPC_face_d_in=NPC_face_d;
		is_NPC_fist_in=is_NPC_fist;
		
		//keycode_auto_in =keycode_auto;       
	  counterK_in=counterK;
      // Update position and motion only at rising edge of frame clock
      if (frame_clk_rising_edge)
     //begin
		//		counterK_in=counterK+10'd1;
		//	 if (( NPC_X_Pos <= X_MIN + NPC_SIZE_X )&& (counterK_in<10'd512))
		//		// Ball is at the top edge, BOUNCE!
		//	 //right15
		//					 
		//	else if (( NPC_X_Pos + NPC_SIZE_X >= X_MAX )&& (counterK_in<10'd512))// Ball is at the bottom edge, BOUNCE!
		//				
		//	else if ((NPC_X_Pos>=HP_X_Pos+10'd200)&& (counterK_in<10'd512))
		//				   
		//	else if ((NPC_X_Pos<=HP_X_Pos-10'd200)&& (counterK_in<10'd512))
		//					
		//	else if  (counterK_in==10'd0)
		//			begin
		//				if (NPC_X_Pos<=HP_X_Pos)
		//					
		//					
		//				else 
		//					
		//			end	
		//	 if (counterK_in<10'd512)
		//			 
		//			 
		//			 
		//   else
		//			
			 begin
				if (j_onnn) //A left
							begin
							 is_NPC_fist_in=1'd0;
									counterL_in=counterL+4'd1;
									NPC_face_d_in=1'b1; 
							if (counterL_in<4'd8)
									choose_in=3'b010;
							else
									choose_in=3'b001;
									
							if ( NPC_X_Pos <= X_MIN + NPC_SIZE_X ) // Ball is at the top edge, BOUNCE!
							begin
									NPC_X_Motion_in = 10'd0;
									NPC_Y_Motion_in = 10'd0;
							end
							else
							begin	
									NPC_Y_Motion_in =10'd0;
									NPC_X_Motion_in = ((~X_Step) + 1'b1);
							end
							end
				else if (l_onnn)
							begin 
									is_NPC_fist_in=1'd0;
									counterR_in=counterR+4'd1;
									NPC_face_d_in=1'b0;  //right 0
							if (counterR_in<4'd8)
									choose_in=3'b010;
							else
									choose_in=3'b001;
							if( NPC_X_Pos + NPC_SIZE_X >= X_MAX ) // Ball is at the bottom edge, BOUNCE!
							begin
								NPC_X_Motion_in = 10'd0;  // 2's complement.  
								NPC_Y_Motion_in = 10'd0;
							end
							else begin
									NPC_Y_Motion_in =10'd0;
									NPC_X_Motion_in = X_Step;
								end
							end
							
					else if (k_onnn)
							begin 
									is_NPC_fist_in=1'd0;
									NPC_Y_Motion_in =10'd0;
									choose_in=3'b101;
							
							end
					else if (i_onnn)
							begin 
								is_NPC_fist_in=1'd0;
								counterU_in=counterU+5'd1;	
							if (counterU_in<5'd16)begin
									choose_in=4'b110;
									NPC_Y_Motion_in =(~jump_high)+10'b1;
									end
							else	begin
									choose_in=3'b000;
									NPC_Y_Motion_in = 10'd0;
									end
							end
				

	
					else if (h_onnn) begin //fist
							
							counterF_in=counterF+3'd1;
							NPC_X_Motion_in = 10'd0;    
							NPC_Y_Motion_in = 10'd0;
							if (counterF_in<3'd4) begin
								choose_in=3'b100;
								is_NPC_fist_in=1'd1;
								end
							else
							begin
								is_NPC_fist_in=1'd0;
								choose_in=3'b011;
							end
							end
					else if ((npc_hit)&&(HP_X_Pos<NPC_X_Pos))
						begin
							NPC_X_Motion_in=10'd8;
							if( NPC_X_Pos + NPC_SIZE_X >= X_MAX ) // Ball is at the bottom edge, BOUNCE!
								NPC_X_Motion_in = 10'd0;  // 2's complement.  
							
						end
					else if ((npc_hit)&&(HP_X_Pos>NPC_X_Pos))
						begin
							NPC_X_Motion_in=~(10'd8)+10'd1;
							if ( NPC_X_Pos <= X_MIN + NPC_SIZE_X ) // Ball is at the top edge, BOUNCE!
									NPC_X_Motion_in = 10'd0;
							
						end
					else 
							begin
							is_NPC_fist_in=1'd0;
							NPC_X_Motion_in =10'd0;
							NPC_Y_Motion_in =10'd0;
							choose_in=3'b000;
							if (HP_Y_Pos>10'd300)
								NPC_Y_Motion_in=~(10'd300-NPC_Y_Pos)+10'd1;
							end
					
			
				
          // Update the ball's position with its motion
         NPC_X_Pos_in = NPC_X_Pos+NPC_X_Motion_in ;
         NPC_Y_Pos_in = NPC_Y_Start+NPC_Y_Motion_in ;
		
		end
end	

	reg [4:0] mm;
	always @(posedge frame_clk) 	

	//updates flip flop, current state is the only one
    begin
	 if ((Reset)||(npc_hit==0)||(f1_on)||(f2_on))
	  mm<=5'd0;
	  else
	  begin
			
			mm <= mm+5'd1;
	end 
	end
	always_comb begin
		//test_beat_npc=1'd0;
		if  ((npc_hit!=0) && (mm<5'd16) && (mm!=0))//||(((HP_X+10'd10)>=NPC_X_Pos) &&((HP_X-10'd10)<=NPC_X_Pos)&&(is_Beat_HP)))
			begin
			//test_beat_npc=1'd1;
			offset_npc=32'hBBFD0;
			end
		else begin
		case(choose)
		3'b000:offset_npc=32'h668A0;//stand
		3'b001:offset_npc=32'h72BF0;//walk left
		3'b010:offset_npc=32'h7EF40;
		3'b011:offset_npc=32'h8B290;//fist
		3'b100:offset_npc=32'h975E0;
		3'b101:offset_npc=32'hA3930;
		3'b110:offset_npc=32'hAFC80;
		                  
		default: offset_npc=32'h668A0;
		endcase
		end
		end
	npc_ram_matrix npc_ram_matrix(
				.read_address(read_address_npc),
				.offset_npc(offset_npc),
				.Clk,
				.data_Out(data_npc),
				);	
	
	//always_comb begin
	//		NPC_X_Pos=NPC_X_Pos_in;
	//	if ((npc_hit)&&(NPC_face_d==1'b1))
	//		NPC_X_Pos=NPC_X_Pos+10'd50;
	//	if ((npc_hit)&&(NPC_face_d==1'b0))
	//		NPC_X_Pos=NPC_X_Pos-10'd50;	
	//end
	
	always_comb begin
		is_NPC = 1'b0;
		NPC_SRAM_ADDR=32'h0;
		read_address_npc=32'd0;
		if (DrawX<=(NPC_X_Pos+10'd99)&& DrawX>=(NPC_X_Pos-10'd100)&& DrawY<=(NPC_Y_Pos+10'd124)&& DrawY>=(NPC_Y_Pos-10'd125))
		begin
					//read_address = DrawX-(HP_X_Pos-19'd25) + (DrawY-(HP_Y_Pos-19'd25))*19'd200;
					if (NPC_face_d==1'b1)
						begin
						read_address_npc=DrawX-NPC_X_Pos+19'd100 + (DrawY-NPC_Y_Pos+125)*19'd200;//+offset_npc;
						NPC_SRAM_ADDR= DrawX-NPC_X_Pos+19'd100 + (DrawY-NPC_Y_Pos+125)*19'd200+offset_npc;
						end
					else
						begin
						read_address_npc=-DrawX+NPC_X_Pos+19'd100 + (DrawY-NPC_Y_Pos+125)*19'd200;//+offset_npc;
						NPC_SRAM_ADDR=-DrawX+NPC_X_Pos+19'd100 + (DrawY-NPC_Y_Pos+125)*19'd200+offset_npc;
						end
				is_NPC = 1'b1;
				end
	end
	
endmodule
