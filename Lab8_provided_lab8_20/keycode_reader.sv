module keycode_reader(
 
input logic [31:0] keycode,
 
output logic w_on, a_on, s_on, d_on,f_on,h_on, j_on, k_on,l_on,i_on,f1_on,f2_on, enter_on, esc_on,p_on,q_on
 
);
 
assign w_on = (keycode[31:24] == 8'h1A |
 
keycode[23:16] == 8'h1A |
 
keycode[15: 8] == 8'h1A |
 
keycode[ 7: 0] == 8'h1A);
 
assign a_on = (keycode[31:24] == 8'h04 |
 
keycode[23:16] == 8'h04 |
 
keycode[15: 8] == 8'h04 |
 
keycode[ 7: 0] == 8'h04);

assign s_on = (keycode[31:24] == 8'd22 |
 
keycode[23:16] == 8'd22 |
 
keycode[15: 8] == 8'd22 |
 
keycode[ 7: 0] == 8'd22);
 
assign d_on = (keycode[31:24] == 8'd07 |
 
keycode[23:16] == 8'd07 |
 
keycode[15: 8] == 8'd07 |
 
keycode[ 7: 0] == 8'd07);
 
assign i_on = (keycode[31:24] == 8'd12 |
 
keycode[23:16] == 8'd12 |
 
keycode[15: 8] == 8'd12 |
 
keycode[ 7: 0] == 8'd12);
 
assign j_on = (keycode[31:24] == 8'd13 |
 
keycode[23:16] == 8'd13 |
 
keycode[15: 8] == 8'd13 |
 
keycode[ 7: 0] == 8'd13);
 
assign k_on = (keycode[31:24] == 8'd14 |
 
keycode[23:16] == 8'd14 |
 
keycode[15: 8] == 8'd14 |
 
keycode[ 7: 0] == 8'd14);
 
assign l_on = (keycode[31:24] == 8'd15 |
 
keycode[23:16] == 8'd15 |
 
keycode[15: 8] == 8'd15 |
 
keycode[ 7: 0] == 8'd15);

assign f_on = (keycode[31:24] == 8'd09 |
 
keycode[23:16] == 8'd09 |
 
keycode[15: 8] == 8'd09 |
 
keycode[ 7: 0] == 8'd09);

assign h_on = (keycode[31:24] == 8'd11 |
 
keycode[23:16] == 8'd11 |
 
keycode[15: 8] == 8'd11 |
 
keycode[ 7: 0] == 8'd11);
 
assign f1_on = (keycode[31:24] == 8'd58 |
 
keycode[23:16] == 8'd58 |
 
keycode[15: 8] == 8'd58 |
 
keycode[ 7: 0] == 8'd58);
 
assign f2_on = (keycode[31:24] == 8'd59 |
 
keycode[23:16] == 8'd59 |
 
keycode[15: 8] == 8'd59 |
 
keycode[ 7: 0] == 8'd59);
 
assign enter_on = (keycode[31:24] == 8'd40 |
 
keycode[23:16] == 8'd40 |
 
keycode[15: 8] == 8'd40 |
 
keycode[ 7: 0] == 8'd40);

assign esc_on = (keycode[31:24] == 8'd41 |
 
keycode[23:16] == 8'd41 |
 
keycode[15: 8] == 8'd41 |
 
keycode[ 7: 0] == 8'd41);

assign p_on = (keycode[31:24] == 8'd19 |
 
keycode[23:16] == 8'd19 |
 
keycode[15: 8] == 8'd19 |
 
keycode[ 7: 0] == 8'd19);

assign q_on = (keycode[31:24] == 8'd20 |
 
keycode[23:16] == 8'd20 |
 
keycode[15: 8] == 8'd20 |
 
keycode[ 7: 0] == 8'd20);

endmodule
 