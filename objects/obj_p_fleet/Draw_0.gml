
if (!instance_exists(obj_star)) then exit;

if (instance_exists(orbiting)) and (obj_controller.is_test_map=true){
    draw_set_color(c_red);
    draw_line_width(x,y,orbiting.x,orbiting.y,1);
}
var scale = obj_controller.scale_mod;

if (x<0) or (x>room_width) or (y<0) or (y>room_height) then exit;
if (image_alpha=0) then exit;

var coords = [0,0];

var near_star = instance_nearest(x,y, obj_star);
if (x==near_star.x && y==near_star.y){
    var coords = [24,-24];
}

var within=false;
var m_dist=point_distance(mouse_x,mouse_y,x+(coords[0]*scale),y+((coords[1])*scale+(12*scale)));

if (obj_controller.zoomed=0){
    if (m_dist<=(16*scale)) then within=1;
}
if (obj_controller.zoomed=1){
    within = true;
    if (m_dist<=24){
        within=1;      
    } 
}

var select_instance = instance_exists(obj_fleet_select);
if (!select_instance) then selected=0;
if ( !keyboard_check(vk_shift)){
    if (within){
        if (mouse_check_button_pressed(mb_left) && obj_controller.menu==0 && !selected){
            alarm[3]=1;
        }  
    } else (mouse_check_button_pressed(mb_left)){
        if (selected){
            if (select_instance){
                if (instance_exists(obj_fleet_select.player_fleet)){
                    if !(obj_fleet_select.player_fleet.id == self.id && !obj_fleet_select.currently_entered){
                        selected=0;
                    }
                }
            }
        } else {
            selected=0;
        }
    }
}
// if (obj_controller.selected!=0) and (selected=1) then within=1;

if (obj_controller.selecting_planet>0){
    if (mouse_x>=__view_get( e__VW.XView, 0 )+529) and (mouse_y>=__view_get( e__VW.YView, 0 )+234) and (mouse_x<__view_get( e__VW.XView, 0 )+611) and (mouse_y<__view_get( e__VW.YView, 0 )+249){
        if (instance_exists(obj_star_select)){if (obj_star_select.button1!="") then within=0;}
    }
    if (mouse_x>=__view_get( e__VW.XView, 0 )+529) and (mouse_y>=__view_get( e__VW.YView, 0 )+234+16) and (mouse_x<__view_get( e__VW.XView, 0 )+611) and (mouse_y<__view_get( e__VW.YView, 0 )+249+16){
        if (instance_exists(obj_star_select)){if (obj_star_select.button2!="") then within=0;}
    }
    if (mouse_x>=__view_get( e__VW.XView, 0 )+529) and (mouse_y>=__view_get( e__VW.YView, 0 )+234+32) and (mouse_x<__view_get( e__VW.XView, 0 )+611) and (mouse_y<__view_get( e__VW.YView, 0 )+249+32){
        if (instance_exists(obj_star_select)){if (obj_star_select.button3!="") then within=0;}
    }
}

var line_width = obj_controller.zoomed ? 6:1;
var line_width = sqr(scale);
var text_size = sqr(scale);

if (action!=""){
    draw_set_halign(fa_left);draw_set_alpha(1);
    draw_set_color(c_white);
    draw_line_width(x,y,action_x,action_y,line_width);
    // 
    draw_set_font(fnt_40k_14b);

    draw_text_transformed(x+12,y,string_hash_to_newline("ETA "+string(action_eta)),text_size,text_size,0);
    if (array_length(complex_route)>0){
        var next_loc = instance_nearest(action_x,action_y, obj_star);
        for (var i=0;i<array_length(complex_route);i++){
            var target_loc = star_by_name(complex_route[i]);
            draw_set_color(c_blue);
            draw_set_alpha(1);            
            draw_line_dashed(next_loc.x,next_loc.y,target_loc.x,target_loc.y,16,line_width);
            next_loc = star_by_name(complex_route[i]);
        }
    }
}


if (within=1) or (selected>0){
    var ppp;
    if (owner  = eFACTION.Player) then ppp=global.chapter_name;
    if (capital_number=1) and (frigate_number=0) and (escort_number=0) then ppp=capital[0];
    if (capital_number=0) and (frigate_number=1) and (escort_number=0) then ppp=frigate[0];
    if (capital_number=0) and (frigate_number=0) and (escort_number=1) then ppp=escort[0];
    // ppp=acted;
    // 
    draw_set_color(38144);
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_center);
    if (obj_controller.zoomed) then draw_text_transformed(x,y-48,string_hash_to_newline(ppp),text_size,text_size,0);// was 1.4
    draw_set_halign(fa_left);

    draw_circle(x+(coords[0]*scale),y+(coords[1]*scale),12*scale,0);
} else {
    draw_set_color(global.star_name_colors[eFACTION.Player]);
    draw_set_alpha(0.5);
    draw_circle(x+(coords[0]*scale),y+(coords[1]*scale),12*scale,0);
    draw_set_alpha(1);
}

// if (is_orbiting()){
//     orbiting = instance_nearest(x,y ,obj_star);
//     var draw_x = x - orbiting.x;
//     var draw_y = y - orbiting.y;
// }



draw_sprite_ext(sprite_index,image_index,x+(coords[0]*scale),y+(coords[1]*scale),1*scale,1*scale,0,c_white,1);

// draw_sprite_ext(sprite_index,image_index,(draw_x*scale),(draw_y*scale),1*scale,1*scale,0,c_white,1)








