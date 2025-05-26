var __b__;
__b__ = action_if_variable(name, "", 0);
if !__b__
{
{
if (selected=1 || point_distance(x, y, mouse_x, mouse_y) < 50){
    draw_set_color(38144);
    draw_circle(x,y,(sprite_width/2),1);
    draw_circle(x,y,(sprite_width/2)-1,1);
    draw_circle(x,y,(sprite_width/2)+1,1);
    
    if (boarders>0){
        draw_set_color(c_red);
        draw_set_alpha(0.3);
        draw_circle(x,y,400,1);
        
        
        if (instance_exists(obj_en_ship)){
            var e=instance_nearest(mouse_x,mouse_y,obj_en_ship);
            if (point_distance(mouse_x,mouse_y,e.x,e.y)<=32){
                obj_cursor.board=1;
            }
            if (point_distance(mouse_x,mouse_y,e.x,e.y)>32){
                obj_cursor.board=0;
                obj_cursor.image_alpha=1;
            }
        }
    }
    
    draw_set_alpha(1);
    for (var i=0;i<array_length(weapons);i++){
        var _wep = weapons[i];
        _wep.draw_weapon_firing_arc();
    }

    if (draw_targets != false){
        location_target.draw(draw_targets[0],draw_targets[1]);
    }
}

shader_set(Ship_shader);
shader_set_uniform_f_array(shader_get_uniform(Ship_shader, "main_colour"), ship_colour);
//draw_sprite(sprite_index, 0, x, y);
draw_self();


shader_reset();
draw_set_color(38144);
draw_set_font(fnt_info);
draw_set_halign(fa_center);


if (boarders>0){
    // draw_sprite(spr_force_icon,0,x-16,y+12);
    scr_image("ui/force",1,x-16-32,y+12-32,64,64);
    
    draw_set_color(0);
    draw_text(x-16,y+12,string(boarders));
    draw_text(x-16-1,y+12-1,string(boarders));
    draw_text(x-16+1,y+12+1,string(boarders));
    draw_text(x-16+1,y+12,string(boarders));
    draw_set_color(c_white);
    draw_text(x-16,y+12,string(boarders));
}
draw_set_color(38144);
draw_ship_heathshields()

if (master_present!=0) then draw_sprite_ext(spr_popup_select,0,x,y,2,2,0,c_white,1);

}
}
