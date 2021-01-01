module Page_FSM(
		input Clk,Reset,
		input f1_on,f2_on,enter_on, 
		input is_win1,is_win2,
		output logic is_start,is_play,is_end1,is_end2, two_player
);

enum logic [3:0] {start_page, 
						
						fight_page_one, 
						fight_page_two,
						win1_page,
						win2_page}curr_state,next_state;

always_ff@(posedge Clk)
begin
		if (Reset)
			curr_state<=start_page;
		else
			curr_state<=next_state;

end

always_comb
begin
		next_state=curr_state;
		unique case(curr_state)	
				//start_page:									//check the difference between enter and kp-enter
				start_page: begin
								if (f1_on)//press enter to start the game 
									next_state=fight_page_one;
								if (f2_on)
									next_state=fight_page_two;
								end
				fight_page_one: begin
								if (is_win1==1)
									next_state=win1_page;
								if (is_win2==1)
									next_state=win2_page;
								end
				fight_page_two: begin
								if (is_win1==1)
									next_state=win1_page;
								if (is_win2==1)
									next_state=win2_page;
								end
								
				win1_page: if (enter_on)//press ESC to restart this game
									next_state=start_page;
				win2_page: if (enter_on)
									next_state=start_page;
							
		endcase
		
		case (curr_state)
				start_page:begin
					is_start=1'b1;
					is_play=1'b0;
					is_end1=1'b0;
					is_end2=1'b0;
					two_player=1'b0;
				end
				
				fight_page_one:begin
					is_start=1'b0;
					is_play=1'b1;
					is_end1=1'b0;
					is_end2=1'b0;
					
					two_player=1'b0;
				end
				
				fight_page_two:begin
					is_start=1'b0;
					is_play=1'b1;
					is_end1=1'b0;
					is_end2=1'b0;
					two_player=1'b1;
				end
				
				win1_page:begin
					is_start=1'b0;
					is_play=1'b0;
					is_end1=1'b1;
					is_end2=1'b0;
					two_player=1'b0;
				end
				
				win2_page:begin
					is_start=1'b0;
					is_play=1'b0;
					is_end1=1'b0;
					is_end2=1'b1;
					two_player=1'b0;
				end
				
				default:begin
					is_start=1'b1;
					is_play=1'b0;
					is_end1=1'b0;
					is_end2=1'b0;
					two_player=1'b0;
				end
			endcase
		end
endmodule
					
			
							