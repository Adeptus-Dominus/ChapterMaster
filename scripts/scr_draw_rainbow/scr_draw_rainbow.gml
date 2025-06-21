function scr_draw_rainbow(x1, y1, x2, y2, colour_ratio) {


	// Draws a variable length and color rectangle based on a ratio of two variables

	with (obj_controller){
		var wid,rat;wid=x2-x1;rat=colour_ratio;


		if (menu!=20) or (diplomacy!=0){
		    if (colour_ratio<=0.15) then draw_set_color(c_red);
		    if (colour_ratio>=0.15) and (colour_ratio<=0.4) then draw_set_color(c_orange);
		    if (colour_ratio>=0.4) and (colour_ratio<=0.7) then draw_set_color(c_yellow);
		    if (colour_ratio>=0.7) then draw_set_color(c_green);
		}
		if (menu=20) and (diplomacy=0){
		    if (colour_ratio<=0.5) then draw_set_color(c_red);
		    if (colour_ratio>=0.5) and (colour_ratio<=0.65) then draw_set_color(c_orange);
		    if (colour_ratio>=0.65) and (colour_ratio<=0.85) then draw_set_color(c_yellow);
		    if (colour_ratio>=0.85) then draw_set_color(c_green);
		}
		if (rat>1) then rat=1;if (rat<-1) then rat=-1;
		draw_rectangle(x1,y1,x1+(wid*rat),y2,0);
		draw_set_color(c_gray);
		draw_rectangle(x1,y1,x2,y2,1);

	}
}
