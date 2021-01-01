module blood(
	input logic [9:0] DrawX, DrawY,
	input logic [8:0] blood_value_hp,blood_value_npc,//if npc give negative blood va
	output logic  b_color
);

	parameter [9:0] blood_Xhp_end = 10'd600; 
   parameter [9:0] blood_Xnpc_Start = 10'd40;  
	parameter [9:0] blood_Y_Start = 10'd40;
	parameter [9:0] blood_SIZE_X = 10'd200;
	parameter [9:0] blood_SIZE_Y = 10'd25;
	always_comb begin
	//is_blood=1'd0;
	b_color=1'd0;
	if ((DrawX>=blood_Xnpc_Start) && (DrawX<=blood_Xnpc_Start+blood_SIZE_X) && (DrawY<=blood_Y_Start+blood_SIZE_Y)&& (DrawY>=blood_Y_Start))
	 begin
		//is_blood=1'b1;
		if (DrawX>=blood_Xnpc_Start+blood_value_npc)
			//grey
			b_color=1'd0;
		else
			//red
			b_color=1'd1;
	 end
	if ((DrawX<=blood_Xhp_end) && (DrawX>=blood_Xhp_end-blood_SIZE_X)&& (DrawY<=blood_Y_Start+blood_SIZE_Y)&& (DrawY>=blood_Y_Start))
	begin
		//is_blood=1'b1;
		if (DrawX<=blood_Xhp_end-blood_value_hp)
			//grey
			b_color=1'd0;
		else
			//red
			b_color=1'd1;
	 end	
	 end
	 endmodule
	 