module HP (
	input Clk,
			Reset,
			frame_clk,
			f2_on,
			f1_on,
			
	//input logic [7:0] keycode,
	input logic w_on, a_on, s_on, d_on,f_on,
	input logic [8:0] hp_hit,
	input logic [9:0] DrawX, DrawY,
	input reg [9:0] NPC_X,
	input logic is_NPCBeat,
	input logic [9:0] NPC_X_Pos,
	output logic [31:0] HP_SRAM_ADDR,
	output logic is_HP,
	output logic is_f,
	output logic [3:0] data_hp,
	output logic HP_face_d,
	output  logic[9:0]  HP_X_Pos, HP_Y_Pos,
	output logic test_beat_hp
	);
	// screen size 640 480
	parameter [9:0] HP_X_Start = 10'd480;  // Center position on the X axis
   parameter [9:0] HP_Y_Start = 10'd300;
	parameter [9:0] HP_SIZE_X = 10'd100;
	parameter [9:0] HP_SIZE_Y = 10'd125;
	parameter [9:0] X_Step=10'd2;
	parameter [9:0] Y_Step=10'd2;
	parameter [9:0] X_MIN=10'd0;
	parameter [9:0] X_MAX=10'd639;
	parameter [9:0] Y_MIN=10'd0;
	parameter [9:0] Y_MAX=10'd479;
	parameter [9:0] jump_high=10'd80;
		
	//--------------------load memory-----------------//
	logic [9:0] HP_X_Motion,HP_Y_Motion;
	
   logic [9:0] HP_X_Pos_in,  HP_Y_Pos_in,HP_X_Motion_in,HP_Y_Motion_in;
	logic [31:0]read_address_hp;
	
	
	
	
	logic [31:0] offset_hp;
	//logic is_f_in;
	logic HP_face_d_in,is_f_in;
	
	logic [3:0] counterL,counterL_in;
	logic [3:0] counterR,counterR_in;
	logic [4:0] counterU,counterU_in;
	logic [3:0] counterD,counterD_in;
	
	logic [2:0] counterF,counterF_in;
	
	
	logic [3:0] choose,choose_in;
	
	//logic [31:0] offset,offset_in;
	
	logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
  
always_ff @ (posedge Clk)
  begin
      if ((Reset)||(f1_on)||(f2_on))
      begin
          HP_X_Pos <= HP_X_Start;
          HP_Y_Pos <= HP_Y_Start;
			 HP_X_Motion <= 10'd0;
          //HP_Y_Motion <= 10'd0;
			 
			choose<=3'b000;
				
			counterL<=4'b0;
			counterR<=4'b0;
			counterD<=4'b0;
			counterU<=5'b0;
			
			counterF<=4'b0;
		
			HP_face_d<=1'b1;
			is_f<=1'b0;
      end
      else
      begin
         HP_X_Pos <= HP_X_Pos_in;
         HP_Y_Pos <= HP_Y_Pos_in;
			HP_X_Motion <= HP_X_Motion_in;
         HP_Y_Motion <= HP_Y_Motion_in;
			
			choose<=choose_in;
			counterL<=counterL_in;
			counterR<=counterR_in;
			counterD<=counterD_in;
			counterU<=counterU_in;
			counterF<=counterF_in;
			
			HP_face_d<=HP_face_d_in;
			is_f<=is_f_in;
      end
  end
  
	always_comb
  begin
      // By default, keep motion and position unchanged
      HP_X_Pos_in = HP_X_Pos;
      HP_Y_Pos_in = HP_Y_Pos;
      HP_X_Motion_in = HP_X_Motion;
      HP_Y_Motion_in = HP_Y_Motion;
		
		choose_in=choose;
		counterL_in=counterL;
		counterF_in=counterF;
		counterR_in=counterR;
		counterD_in=counterD;
		counterU_in=counterU;
		HP_face_d_in=HP_face_d;
		is_f_in=is_f;
		
      if (frame_clk_rising_edge)
      begin
				if (a_on) //A left
							begin
									is_f_in=1'd0;
									counterL_in=counterL+4'd1;
									HP_face_d_in=1'b1; 
							if (counterL_in<4'd8)
									choose_in=3'b010;
							else
									choose_in=3'b001;
									
							if ( HP_X_Pos <= X_MIN + HP_SIZE_X ) // Ball is at the top edge, BOUNCE!
							begin
									HP_X_Motion_in = 10'd0;
									HP_Y_Motion_in = 10'd0;
							end
							else
							begin	
									HP_Y_Motion_in =10'd0;
									HP_X_Motion_in = ((~X_Step) + 1'b1);
							end
							end
					else if (d_on)
							begin 
									is_f_in=1'd0;
									counterR_in=counterR+4'd1;
									HP_face_d_in=1'b0;  //right 0
							if (counterR_in<4'd8)
									choose_in=3'b010;
							else
									choose_in=3'b001;
							if( HP_X_Pos + HP_SIZE_X >= X_MAX ) // Ball is at the bottom edge, BOUNCE!
							begin
								HP_X_Motion_in = 10'd0;  // 2's complement.  
								HP_Y_Motion_in = 10'd0;
							end
							else begin
									HP_Y_Motion_in =10'd0;
									HP_X_Motion_in = X_Step;
								end
							end
							
					else if (s_on)
							begin 
									is_f_in=1'd0;
									HP_Y_Motion_in =10'd0;
									choose_in=3'b101;
							
							end
					else if (w_on)
							begin 
								is_f_in=1'd0;
								counterU_in=counterU+5'd1;	
							if (counterU_in<5'd16)begin
									choose_in=4'b110;
									HP_Y_Motion_in =(~jump_high)+10'b1;
									end
							else	begin
									choose_in=3'b000;
									HP_Y_Motion_in = 10'd0;
									end
							end
				

	
					else if (f_on) begin //fist
							
							counterF_in=counterF+3'd1;
							HP_X_Motion_in = 10'd0;    
							HP_Y_Motion_in = 10'd0;
							if (counterF_in<3'd4) begin
								choose_in=3'b100;
								is_f_in=1'd1;
								end
							else
							begin
								is_f_in=1'd0;
								choose_in=3'b011;
							end
							end
					else if ((hp_hit)&&(NPC_X_Pos<HP_X_Pos))
						begin
							HP_X_Motion_in=10'd8;
							if( HP_X_Pos + HP_SIZE_X >= X_MAX ) // Ball is at the bottom edge, BOUNCE!
								HP_X_Motion_in = 10'd0;  // 2's complement.  
						end
					else if ((hp_hit)&&(NPC_X_Pos>HP_X_Pos))
						begin
							HP_X_Motion_in=~(10'd8)+10'd1;
							if ( HP_X_Pos <= X_MIN + HP_SIZE_X ) // Ball is at the top edge, BOUNCE!
									HP_X_Motion_in = 10'd0;
						end
					else begin
							is_f_in=1'd0;
							HP_X_Motion_in =10'd0;
							HP_Y_Motion_in =10'd0;
							choose_in=3'b000;
							if (HP_Y_Pos>10'd300)
								HP_Y_Motion_in=~(10'd300-HP_Y_Pos)+10'd1;
							end
			
				
          // Update the ball's position with its motion
          HP_X_Pos_in = HP_X_Pos+HP_X_Motion_in ;
          HP_Y_Pos_in = HP_Y_Start+HP_Y_Motion_in ;
		
		end
end
	reg [4:0] mm;
	
	always @(posedge frame_clk) 
		begin
	if ((Reset)||(hp_hit==0)||(f1_on)||(f2_on))
			mm<=5'd0;
	//updates flip flop, current state is the only one
	else
    begin
			
			mm <= mm+5'd1;
	end
		
	end 
	
	always_comb begin
		//test_beat_hp=1'd0;
		if ((hp_hit!=0) && (mm !=0)&& (mm< 5'd16))//|| ((((NPC_X+10'd10)>=HP_X_Pos &&(NPC_X-10'd10)<=HP_X_Pos))//&&(is_NPCBeat)))
			begin
				//test_beat_hp=1'd1;
				offset_hp= 32'h55730;					//32'h55730
			end
			
		else begin
		case(choose)
		3'b000:offset_hp=	32'h00000;//stand				//
		3'b001:offset_hp= 32'hC350;//walk left		//
		3'b010:offset_hp=	32'h186A0;						//
		3'b011:offset_hp= 32'h249F9;//fist				//
		3'b100:offset_hp= 32'h30D40;						//
		3'b101:offset_hp= 32'h3D090;//down				//
		3'b110:offset_hp= 32'h493E0;//jump				//
		
		default: offset_hp=32'h000;							
		endcase
		end
	end
	
	//always_comb begin
	//		HP_X_Pos=HP_X_Pos_in;
	//	if ((hp_hit)&&(HP_face_d==1'b1))
	//		HP_X_Pos=HP_X_Pos+10'd50;
	//	if ((hp_hit)&&(HP_face_d==1'b0))
	//		HP_X_Pos=HP_X_Pos-10'd50;	
	//end
	
	
	always_comb begin
		is_HP = 1'b0;
		HP_SRAM_ADDR=32'h0;
		read_address_hp=32'd0;
		if (DrawX<=(HP_X_Pos+10'd99)&& DrawX>=(HP_X_Pos-10'd100)&& DrawY<=(HP_Y_Pos+10'd124)&& DrawY>=(HP_Y_Pos-10'd125))begin
					if (HP_face_d==1'b1)
						begin
							read_address_hp=DrawX-HP_X_Pos+19'd100 + (DrawY-HP_Y_Pos+125)*19'd200;
							HP_SRAM_ADDR= DrawX-HP_X_Pos+19'd100 + (DrawY-HP_Y_Pos+125)*19'd200 +offset_hp;
						end
					else
						begin
							read_address_hp=-DrawX+HP_X_Pos+19'd100 + (DrawY-HP_Y_Pos+125)*19'd200;
							HP_SRAM_ADDR=-DrawX+HP_X_Pos+19'd100 + (DrawY-HP_Y_Pos+125)*19'd200+offset_hp;
						end
					is_HP = 1'b1;
		end
	end
	
	hp_ram_matrix hp_ram(
				.read_address(read_address_hp),
				.offset_hp,
				.Clk,
				.data_Out(data_hp),
				);	
	
endmodule
