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

main_slate.inside_method = function(){
    if (show>0 && current_battle<=battles && current_battle>-1){
        var xxx=main_slate.XX;
        var yyy=main_slate.YY;
        var i=current_battle;
        
        // if (battle_world[i]=-50) then draw_sprite(spr_attacked,1,xxx+12,yyy+54);
        // if (battle_world[i]>0) then draw_sprite(spr_attacked,0,xxx+12,yyy+54);
        var _img = battle_world[i]==-50;
        scr_image("attacked",_img,xxx+12,yyy+54,254,174);
        
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_text(xxx+8,yyy+13,$"{i}/{battles}");
        
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_30b);
        
        if (battle_world[i]>0) then draw_text_transformed(xxx+265,yyy+11,$"Forces Attacked! ({battle_location[i]} {scr_roman(battle_world[i])})",0.7,0.7,0);
        if (battle_world[i]=-50) then draw_text_transformed(xxx+265,yyy+11,$"Fleet Attacked! ({battle_location[i]} System)",0.7,0.7,0);
        
        scr_image("ui/force",1,xxx+378-32,yyy+86-32,64,64);
        // draw_sprite(spr_force_icon,1,xxx+378,yyy+86);
        
        draw_set_font(fnt_40k_14);
        draw_set_halign(fa_left);
        if (battle_world[current_battle]<0){
            draw_player_fleet_combat_options();
        }   else if (battle_world[i]>=1){
           draw_player_ground_combat_options();
        }
    }
    draw_set_alpha(1);
}

if (show>0 && current_battle<=battles && current_battle>-1 ){
    main_slate.draw_with_dimensions(535, 200, 530, 400);
}

