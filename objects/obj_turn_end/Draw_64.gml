/// @description Insert description here
// You can write your code in this editor



var i=0;


draw_set_font(fnt_40k_14b);
draw_set_halign(fa_left);
draw_set_color(38144);

if (alerts>0) and (popups_end=1){
	
    repeat(alerts){
        i+=1;
        set_alert_draw_colour(alert_color[i]);
        draw_set_alpha(min(1,alert_alpha[i]));
        
        if (obj_controller.zoomed=0){
            draw_text(32,+46+(i*20),string_hash_to_newline(string(alert_txt[i])));
            // draw_text(view_xview[0]+16.5,view_yview[0]+40.5+(i*12),string(alert_txt[i]));
        }
        /*if (obj_controller.zoomed=1){
            draw_text_transformed(80,80+(i*24),string(alert_txt[i]),2,2,0);
            draw_text_transformed(81,81+(i*24),string(alert_txt[i]),2,2,0);
        }*/
        
        if (obj_controller.zoomed=1){
            draw_text_transformed(32,92+(i*40),string_hash_to_newline(string(alert_txt[i])),2,2,0);
            // draw_text_transformed(122,122+(i*36),string(alert_txt[i]),3,3,0);
        }
    }
}

draw_set_alpha(1);

