
if (obj_controller.zoomed=0) then draw_sprite(spr_space_bg,0,(obj_controller.x/8)-48,(obj_controller.y/8)-48);
if (obj_controller.zoomed=1) then draw_sprite(spr_space_bg,0,0,0);

exit;

draw_set_color(CM_GREEN_COLOR);
draw_set_font(fnt_menu);

//if (zoomed=0){
//    draw_text(__view_get( e__VW.XView, 0 )+0,__view_get( e__VW.YView, 0 )+0,string_hash_to_newline("Morale: High"));
//    draw_text(__view_get( e__VW.XView, 0 )+1,__view_get( e__VW.YView, 0 )+0,string_hash_to_newline("Morale:"));
    
//    draw_text(__view_get( e__VW.XView, 0 )+0,__view_get( e__VW.YView, 0 )+16,string_hash_to_newline("Ships Remaining: "+string(instance_number(obj_p_ship))));
//    draw_text(__view_get( e__VW.XView, 0 )+1,__view_get( e__VW.YView, 0 )+16,string_hash_to_newline("Ships Remaining:"));
    
//    draw_text(__view_get( e__VW.XView, 0 )+0,__view_get( e__VW.YView, 0 )+32,string_hash_to_newline("Thunderhawks: "+string(instance_number(obj_p_th))));
//    draw_text(__view_get( e__VW.XView, 0 )+1,__view_get( e__VW.YView, 0 )+32,string_hash_to_newline("Thunderhawks:"));
//}

//if (zoomed=1){
//    draw_text_transformed(0,0,string_hash_to_newline("Morale: High"),2,2,0);
//    draw_text_transformed(2,0,string_hash_to_newline("Morale:"),2,2,0);
    
//    draw_text_transformed(0,32,string_hash_to_newline("Ships Remaining: "+string(instance_number(obj_p_ship))),2,2,0);
//    draw_text_transformed(2,32,string_hash_to_newline("Ships Remaining:"),2,2,0);
    
//    draw_text_transformed(0,64,string_hash_to_newline("Thunderhawk: "+string(instance_number(obj_p_th))),2,2,0);
//    draw_text_transformed(2,64,string_hash_to_newline("Thunderhawk:"),2,2,0);
//}
