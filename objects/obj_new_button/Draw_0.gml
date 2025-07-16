
draw_set_alpha(1);

var xx,yy;
xx=x;yy=y;
if (follow_control=true) and (instance_exists(obj_controller)){
    xx+=__view_get( e__VW.XView, 0 );
    yy+=__view_get( e__VW.YView, 0 );
}


if (button_id=1) then draw_sprite_ext(spr_ui_but_1,0,x,y,scaling,scaling,0,c_white,1);
if (button_id=2) then draw_sprite_ext(spr_ui_but_2,0,x,y,scaling,scaling,0,c_white,1);
if (button_id=3) then draw_sprite_ext(spr_ui_but_3,0,x,y,scaling,scaling,0,c_white,1);
if (button_id=4) then draw_sprite_ext(spr_ui_but_4,0,x,y,scaling,scaling,0,c_white,1);


draw_set_blend_mode(bm_add);
// draw_set_alpha(highlight*2);
if (button_id=1) and (highlight>0) then draw_sprite_ext(spr_ui_hov_1,0,x,y,scaling,scaling,0,c_white,highlight*2);
if (button_id=2) and (highlight>0) then draw_sprite_ext(spr_ui_hov_2,0,x,y,scaling,scaling,0,c_white,highlight*2);
if (button_id=3) and (highlight>0) then draw_sprite_ext(spr_ui_hov_3,0,x,y,scaling,scaling,0,c_white,highlight*2);
if (button_id=4) and (highlight>0) then draw_sprite_ext(spr_ui_hov_4,0,x,y,scaling,scaling,0,c_white,highlight*2);
draw_set_blend_mode(bm_normal);
// draw_set_alpha(1);


draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_font(fnt_cul_14);
draw_text_transformed(xx+((sprite_width/2)*scaling),yy+((sprite_height/5)*scaling),string_hash_to_newline(button_text),scaling,scaling,0);





draw_set_alpha(0.15);
if (line>0) and (button_id<=2){
    var l_hei,l_why;l_hei=37*scaling;l_why=0;if (line>131*scaling){l_hei=(171*scaling)-line;l_why=min(line-(133*scaling),11*(scaling));}
    // draw_line(line+xx,yy+1+l_why,xx+line+(34*scaling),yy+(37*scaling));
    draw_line(line+xx,yy+1+l_why,xx+line,yy+(37*scaling));
    // draw_line(line+xx+(34*scaling),yy+1+l_why,xx+line+(34*scaling),yy+(37*scaling));
}
/*
if (line>0) and (button_id<=2){
    var l_hei,l_why;l_hei=37*scaling;l_why=0;if (line>131*scaling){l_hei=(171-line)*scaling;l_why=min(line-133,11)*scaling;}
    // draw_line(line+xx,yy+1+l_why,xx+line+(34*scaling),yy+(37*scaling));
    draw_line(line+xx+(34*scaling),yy+1+l_why,xx+line+(34*scaling),yy+(37*scaling));
}*/
if (line>0) and (button_id=3){
    var l_hei,l_why;l_hei=37*scaling;l_why=0;if (line>101*scaling){l_hei=(141-line)*scaling;l_why=min(line-103,11)*scaling;}
    draw_line(xx+line,yy+1+l_why,xx+line,yy+(37)*scaling);
}
if (line>0) and (button_id=4){
    var l_hei,l_why;l_hei=37*scaling;l_why=0;if (line>94*scaling){l_hei=(134-line)*scaling;l_why=min(line-96,11)*scaling;}
    draw_line(xx+line,yy+(10*scaling)+1,xx+line,yy+((10+37)*scaling)-l_why);
}
draw_set_alpha(1);

// draw_set_color(c_red);
// draw_text(x+300,y,highlight);

/* */
/*  */
