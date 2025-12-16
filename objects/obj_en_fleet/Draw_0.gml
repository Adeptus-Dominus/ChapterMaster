
if ((obj_controller.menu != MENU.Default) || !instance_exists(obj_star)){
    exit;
}


var scale = obj_controller.scale_mod;


/*if (owner = eFACTION.Eldar) and (instance_exists(orbiting)) and (obj_controller.is_test_map=true){
    draw_set_color(c_red);
    draw_line_width(x,y,orbiting.x,orbiting.y,1);
}*/


var draw_icon = false;
if (!point_in_rectangle(x, y, 0, 0, room_width, room_height) || !image_alpha){
    exit;
}

var coords = [0,0];
var near_star = instance_nearest(x,y, obj_star);
if (x==near_star.x && y==near_star.y){
    var coords = fleet_star_draw_offsets();
}

image_index = min(image_index,9)

var _scale_x_pos = x+(coords[0]*scale);
var _scale_y_pos = y+(coords[1]*scale);

var _m_dist=point_distance(mouse_x,mouse_y,_scale_x_pos,(_scale_y_pos));

var _is_zoom = obj_controller.zoomed;

var _within = _m_dist<=16*scale && !_is_zoom && !instance_exists(obj_ingame_menu);


add_draw_return_values();
if (_is_zoom){
    var faction_colour = global.star_name_colors[owner];
    draw_set_color(faction_colour);
    
    if (owner == eFACTION.Imperium) and (navy=0) then draw_set_alpha(0.5);
    draw_circle(x,y,12,0);
    draw_set_alpha(1);
    if (_m_dist<=16) and (!instance_exists(obj_ingame_menu)) then _within=1;
}

// if (obj_controller.selected!=0) and (selected=1) then _within=1;

if (obj_controller.selecting_planet>0 && _within){
    _within = scr_void_click();
}
if (action != ""){
    draw_set_halign(fa_left);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_line_width(x,y,action_x,action_y,1);
    // 
    draw_set_font(fnt_40k_14b);
    var _tex_scale = obj_controller.zoomed ?2:1;
    draw_text_transformed(x+12,y,$"ETA {action_eta}",_tex_scale,_tex_scale,0);
}


switch(owner){
    case eFACTION.Ork:
        var _has_warboss =false;
          if (fleet_has_cargo("ork_warboss")){
            draw_icon = true;
            _has_warboss = true;
        }
        break;
}
var _reset = false;

if (last_turn_image_check != obj_controller.turn){
    _reset = true;

}

if (ds_map_exists(global.en_fleet_sprites, uid)){
    if (_reset){
        ds_map_delete_sprite(global.en_fleet_sprites, uid);
    }
} else {
    _reset = true;
}

if (_reset){
    add_draw_return_values();
    var _fleet_image_surface = surface_create(128, 64);
    surface_set_target(_fleet_image_surface);
    var faction_colour = global.star_name_colors[owner];
    var _xx = 24;
    var _yy = 24;
    draw_set_color(faction_colour);
    draw_set_alpha(0.5);
    draw_circle(_xx,_yy,12,0);
    draw_set_alpha(1);
    if (navy && owner == eFACTION.Imperium){
        draw_set_color(global.star_name_colors[eFACTION.Mechanicus]);
        draw_circle_with_outline_width();
        draw_circle_with_outline_width(_xx,_yy,12,0.3);
    }

    if (draw_icon){
        draw_sprite_ext(spr_faction_icons, owner,_xx-32,_yy-32,1,1,0,c_white,1)
    }
    draw_sprite_ext(sprite_index,image_index,_xx,_yy,1,1,0,c_white,1);

    surface_reset_target();
    
    var _new_sprite = sprite_create_from_surface(_fleet_image_surface, 0, 0, surface_get_width(_fleet_image_surface), surface_get_height(_fleet_image_surface), false, false, 0, 0);

    ds_map_set(global.en_fleet_sprites, uid, _new_sprite);
    surface_clear_and_free(_fleet_image_surface);
    last_turn_image_check = obj_controller.turn;
    pop_draw_return_values();
}

var fleet_descript="";
if (_within || selected>0){
    draw_set_color(CM_GREEN_COLOR);
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_center);
    
    var fleet_descript="";
    if (owner  = eFACTION.Player) then fleet_descript="Renegade Fleet";
    if (owner = eFACTION.Imperium){
        if (navy=1){
            fleet_descript="Imperial Navy";
        }else{
            fleet_descript="Defense Fleet";
        }
    }
    if (navy=0){
        if (owner = eFACTION.Imperium){
            if (fleet_has_cargo("colonize")){
                fleet_descript="Imperial Colonists"
            } else if ((trade_goods!="") and (trade_goods!="merge")){
                fleet_descript="Trade Fleet";
            }
        }
    }
    // if (navy=1) then fleet_descript=string(trade_goods)+" ("+string(guardsmen_unloaded)+"/"+string(guardsmen_ratio)+")";
    switch(owner){
        case eFACTION.Mechanicus:
            fleet_descript="Mechanicus Fleet";
            break;
        case eFACTION.Inquisition:
            fleet_descript="Inquisitor Ship";
            break;
        case eFACTION.Eldar:
            fleet_descript="Eldar Fleet";
            break; 
        case eFACTION.Ork:
            fleet_descript="Ork Fleet";
            if (_has_warboss){
                var _warboss = cargo_data.ork_warboss;
                fleet_descript += $"\nWarboss {_warboss.name}"
            }
            break; 
        case eFACTION.Tau:
            fleet_descript="Tau Fleet";
            break;
        case eFACTION.Tyranids:
            fleet_descript="Hive Fleet";
            break;
        case eFACTION.Chaos:
            fleet_descript="Heretic Fleet";
            if (fleet_has_cargo("warband") || fleet_has_cargo("csm")){
                fleet_descript=string(obj_controller.faction_leader[eFACTION.Chaos])+"'s Fleet";
                if (string_count("s's Fleet",fleet_descript)>0) then fleet_descript=string_replace(fleet_descript,"s's Fleet","s' Fleet");                
            }
            break; 
        case eFACTION.Necrons:
            fleet_descript="Necron Fleet";
            break;                                                                                   
    }

    // if (owner = eFACTION.Imperium) and (navy=1){fleet_descript=string(capital_max_imp[1]+frigate_max_imp[1]+escort_max_imp[1]);}
    
    if (global.cheat_debug=true){
        fleet_descript+=$"C{capital_number}|F{frigate_number}|E{escort_number}";
    }
    
    // fleet_descript=string(capital_number)+"|"+string(frigate_number)+"|"+string(escort_number);
    // fleet_descript+="|"+string(trade_goods);
    
    draw_set_halign(fa_left);
}

var _sprite = ds_map_find_value(global.en_fleet_sprites, uid)
draw_sprite_ext(_sprite, 0,  _scale_x_pos-(24*scale) , _scale_y_pos-(24*scale), scale, scale, 1, c_white, 1);

if (fleet_descript!="" && _within){
    tooltip_draw(fleet_descript);
    draw_circle(_scale_x_pos,_scale_y_pos,12*scale,0);
} 


if (instance_exists(target)){
    draw_set_color(c_red);
    draw_set_alpha(0.5);
    draw_line(x,y,target.x,target.y);
    draw_set_alpha(1);
}

pop_draw_return_values();

/* */
/*  */
