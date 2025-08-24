var __b__;
__b__ = action_if_variable(name, "", 0);
if !__b__
{
{
draw_set_font(fnt_info);
draw_set_halign(fa_center);

// 135;
/*if (action="broadside"){
    draw_set_color(c_blue);if (instance_exists(target_l)) then draw_line(x,y,target_l.x,target_l.y);
    draw_set_color(c_red);if (instance_exists(target_r)) then draw_line(x,y,target_r.x,target_r.y);
}draw_set_color(CM_GREEN_COLOR);*/


draw_set_alpha(1);
if (point_distance(x, y, mouse_x, mouse_y)< 50){
    for (var i=0;i<array_length(weapons);i++){
        var _wep = weapons[i];
        _wep.draw_weapon_firing_arc(c_red);
    }
}
if (lightning>01) and (instance_exists(target)){
    draw_set_color(c_lime);
    lightning-=1;
    scr_bolt(x,y,target.x,target.y,0);
}
if (whip>0) and (instance_exists(target)){
    draw_set_color(c_lime);
    whip-=1;
    scr_bolt(x,y,target.x,target.y,0);
    scr_bolt(x-1,y+1,target.x-1,target.y+1,0);
}

draw_set_color(CM_GREEN_COLOR);

if (class!="Battlekroozer"){
    draw_self();
} else {
    draw_sprite_ext(sprite_index,0,x,y,0.85,0.85,direction,c_white,1);
}

draw_ship_heathshields();
if (owner != eFACTION.Tau){
    if (shields<=0){
        if (obj_controller.zoomed=0){if (maxhp!=0) then draw_text(x,y-(sprite_height/2),string_hash_to_newline(string(floor((hp/maxhp)*100))+"%"));}
        if (obj_controller.zoomed=1){if (maxhp!=0) then draw_text_transformed(x,y-sprite_height,string_hash_to_newline(string(floor((hp/maxhp)*100))+"%"),2,2,0);}
    }

    if (shields>0){
    draw_set_color(c_white);
    if (obj_controller.zoomed=0){if (maxhp!=0) then draw_text(x,y-(sprite_height/2),string_hash_to_newline(string(floor((shields/maxshields)*100))+"%"));}
    if (obj_controller.zoomed=1){if (maxhp!=0) then draw_text_transformed(x,y-sprite_height,string_hash_to_newline(string(floor((shields/maxshields)*100))+"%"),2,2,0);}
    }
}

else if (owner = eFACTION.Tau){
    if (shields<=0){
    if (obj_controller.zoomed=0){if (maxhp!=0) then draw_text(x,y-(sprite_width/2),string_hash_to_newline(string(floor((hp/maxhp)*100))+"%"));}
    if (obj_controller.zoomed=1){if (maxhp!=0) then draw_text_transformed(x,y-sprite_width,string_hash_to_newline(string(floor((hp/maxhp)*100))+"%"),2,2,0);}
    }
    
    if (shields>0){
    draw_set_color(c_white);
    if (obj_controller.zoomed=0){if (maxhp!=0) then draw_text(x,y-(sprite_width/2),string_hash_to_newline(string(floor((shields/maxshields)*100))+"%"));}
    if (obj_controller.zoomed=1){if (maxhp!=0) then draw_text_transformed(x,y-sprite_width,string_hash_to_newline(string(floor((shields/maxshields)*100))+"%"),2,2,0);}
    }
}

/* */
}
}
/*  */
