module hp_ram_matrix(
		input logic [31:0] read_address,
		input logic [31:0] offset_hp,
		input Clk,
		output logic  [3:0]data_Out
);

logic [3:0] f1 [0:49999];
logic [3:0] f2 [0:49999];
logic [3:0] f3 [0:49999];
logic [3:0] f7 [0:49999];
logic [3:0] f8 [0:49999];
logic [3:0] down [0:49999];
logic [3:0] jump [0:49999];
logic [3:0] kicked [0:49999];

initial
begin
	 $readmemh("hp_txt/fp1new.txt", f1);
	 $readmemh("hp_txt/fp2new.txt", f2);
	 $readmemh("hp_txt/fp3new.txt", f3);
	 $readmemh("hp_txt/fp7new.txt", f7);
	 $readmemh("hp_txt/fp8new.txt", f8);
	 $readmemh("hp_txt/downnew.txt", down);
	 $readmemh("hp_txt/jumpnew.txt", jump);
	 $readmemh("hp_txt/kickednew.txt", kicked);
end


always_ff @ (posedge Clk) begin
	
	//	mem[write_address] <= data_In;
	case(offset_hp)
	
		 32'h00000:data_Out<= f1[read_address];
		 32'hC350:data_Out<= f2[read_address];
		 32'h186A0:data_Out<= f3[read_address];
		 32'h249F9:data_Out<= f7[read_address];
		 32'h30D40:data_Out<= f8[read_address];
		 32'h3D090:data_Out<= down[read_address];
		 32'h493E0:data_Out<= jump[read_address];
		 32'h55730:data_Out<= kicked[read_address];
		
		default:
			data_Out<= f1[read_address];//read the 32-bit address
	endcase
	
end
endmodule



module npc_ram_matrix(
		input logic [31:0] read_address,
		input logic [31:0] offset_npc,
		input Clk,
		output logic  [3:0]data_Out
);

logic [3:0] stand [0:49999];
logic [3:0] walk1 [0:49999];
logic [3:0] walk2 [0:49999];
logic [3:0] fist1 [0:49999];
logic [3:0] fist2 [0:49999];
logic [3:0] down [0:49999];
logic [3:0] jump [0:49999];
logic [3:0] kicked [0:49999];

initial
begin
	 $readmemh("yuki_1/npc_standnew.txt", stand);
	 $readmemh("yuki_1/npc_walk1new.txt", walk1);
	 $readmemh("yuki_1/npc_walk2new.txt", walk2);
	 $readmemh("yuki_1/npc_fist1new.txt", fist1);
	 $readmemh("yuki_1/npc_fist2new.txt", fist2);
	 $readmemh("yuki_1/npc_downnew.txt", down);
	 $readmemh("yuki_1/npc_jumpnew.txt", jump);
	 $readmemh("yuki_1/npc_kickednew.txt", kicked);
end


always_ff @ (posedge Clk) begin
	
	//	mem[write_address] <= data_In;
	case(offset_npc)
	
		 32'h668A0:data_Out<= stand[read_address];
		 32'h72BF0:data_Out<=  walk1[read_address];
		 32'h7EF40:data_Out<= walk2[read_address];
		 32'h8B290:data_Out<= fist1[read_address];
		 32'h975E0:data_Out<= fist2[read_address];
		 32'hA3930:data_Out<= down[read_address];
		 32'hAFC80:data_Out<= jump[read_address];
		 32'hBBFD0:data_Out<= kicked[read_address];
		
		default:
			data_Out<= stand[read_address];//read the 32-bit address
	endcase
	
end
endmodule

module hp_beat_matrix(
						input logic [31:0] read_address,
						input Clk,
						output logic  [3:0]data_Out
						);
						
	logic [3:0]  beat [0:19999];
	initial
	begin
		$readmemh("hp_txt/beatnew.txt", beat);
	end
	
	always_ff @(posedge Clk) begin
		data_Out<=beat[read_address];
	end
	endmodule
	

module npc_beat_matrix(
						input logic [31:0] read_address,
						input Clk,
						output logic  [3:0]data_Out
						);
						
	logic [3:0]  beat [0:19999];
	initial
	begin
		$readmemh("yuki/npc_beatnew.txt", beat);
	end
	
	always_ff @(posedge Clk) begin
		data_Out<=beat[read_address];
	end
	endmodule
