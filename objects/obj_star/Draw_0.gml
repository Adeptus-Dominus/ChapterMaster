// Draws the system name and color codes it based on ownership
if (p_type[1]="Craftworld") and (obj_controller.known[eFACTION.Eldar]=0){
    draw_set_alpha(0);
    draw_set_color(255);
    draw_circle(old_x,old_y,5,0);
    draw_set_alpha(1);
    exit;
}

var show=name;

if (global.cheat_debug=true) then show=string(name)+"#"+string(p_problem[1,1])+":"+string(p_timer[1,1])+"#"+string(p_problem[1,2])+":"+string(p_timer[1,2])+"#"+string(p_problem[1,3])+":"+string(p_timer[1,3]);
scale = min(camera_get_view_width(view_camera[0])/global.default_view_width, 2.4);
draw_set_color(c_white);
draw_set_alpha(0.25);

if (!craftworld) and (vision==1) then draw_sprite_ext(sprite_index,image_index,x,y,1*scale,1*scale,0,c_white,1)
if (craftworld) then draw_sprite_ext(spr_craftworld,0,x,y,1*scale,1*scale,point_direction(x,y,room_width/2,room_height/2)+90,c_white,1);
if (space_hulk) then draw_sprite_ext(spr_star_hulk,0,x,y,1*scale,1*scale,0,c_white,1);

if (storm>0) then draw_sprite_ext(spr_warp_storm,storm_image,x,y,0.75*scale,0.75*scale,0,c_white,1);

//ad hoc way of determining whether stuff is in view or not...needs work

draw_set_halign(fa_center);
draw_set_font(fnt_cul_14);
draw_set_alpha(1);


if (global.load == -1 && (obj_controller.zoomed || in_camera_view(star_box_shape()))) {
    
    if (garrison){
        draw_sprite(spr_new_resource,3,x-30,y+15);
        if (scr_hit(x-40,y+10,x-10,y+35)){
            tooltip_draw("Marine Garrison in system");
        }
    }
    if (point_in_rectangle(mouse_x, mouse_y,x-128,y, x+128, y+80) && obj_controller.zoomed){
        scale *= 1.5;
    }
    var _reset = false;
    if (stored_owner != owner){
        _reset = true;
    }

    if (ds_map_exists(global.star_sprites, name)){
        var _old_sprite = ds_map_find_value(global.star_sprites, name);
        if (sprite_exists(_old_sprite)){
            if (_reset){
                sprite_delete(_old_sprite);
            }
        } else {
            _reset = true;
        }
        if (_reset){
            ds_map_delete(global.star_sprites, name);
        }
    } else {
        _reset = true;
    }
    if (_reset){
        star_tag_surface = surface_create(256, 128);
        var xx=64;
        var yy=0;
        surface_set_target(star_tag_surface);
        var panel_width = string_width(name) + 60;
        if (owner != eFACTION.Player ){
            var _faction_index = owner;
            var faction_colour = global.star_name_colors[_faction_index];
            draw_sprite_general(spr_p_name_bg, 0, 0, 0, string_width(name) + 60, 32, xx-(panel_width/2), yy+30, 1, 1, 0, faction_colour, faction_colour, faction_colour, faction_colour, 1);
            draw_sprite_ext(spr_faction_icons,_faction_index,xx+(panel_width/2)-30,yy+25, 0.60, 0.60, 0, c_white, 1);
        } else {
            scr_shader_initialize();
            var main_color = make_colour_from_array(obj_controller.body_colour_replace);
            var right_pauldron = make_colour_from_array(obj_controller.pauldron_colour_replace);
            draw_sprite_general(spr_p_name_bg, 0, 0, 0, string_width(name) + 60, 32, xx-(panel_width/2), yy+30, 1, 1, 0, main_color, main_color, right_pauldron, right_pauldron, 1);
            var faction_sprite = global.chapter_icon.sprite;
            draw_sprite_ext(faction_sprite,0,xx+(panel_width/2)-30,yy+30, 0.2, 0.2, 0, c_white, 1);
            //context.set_vertical_gradient(main_color, right_pauldron);
            //draw_text_ext_transformed_color(gx + xoffset,gy + yoffset,text,sep,owner.width,xscale,yscale,angle ,col1, col2, col3, col4, alpha);
        }
        draw_set_color(c_white);
        draw_text(xx, yy+33, name)
        surface_reset_target();
        stored_owner = owner;
        var _new_sprite = sprite_create_from_surface(star_tag_surface, 0, 0, surface_get_width(star_tag_surface), surface_get_height(star_tag_surface), false, false, 0, 0);
        ds_map_set(global.star_sprites, name, _new_sprite);
        surface_clear_and_free(star_tag_surface)
    } 
    var _sprite = ds_map_find_value(global.star_sprites, name)
    draw_sprite_ext(_sprite, 0,  x-(64*scale), y, scale, scale, 1, c_white, 1);
}
draw_set_valign(fa_top)






