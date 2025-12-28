if ((obj_controller.menu != 0) || !instance_exists(obj_star)) {
    exit;
}
var scale = obj_controller.scale_mod;
if ((owner == eFACTION.Eldar) && instance_exists(orbiting) && (obj_controller.is_test_map == true)) {
    draw_set_color(c_red);
    draw_line_width(x, y, orbiting.x, orbiting.y, 1);
}
var draw_icon = false;
if ((x < 0) || (x > room_width) || (y < 0) || (y > room_height)) {
    exit;
}
if (image_alpha == 0) {
    exit;
}

var coords = [0, 0];
var near_star = instance_nearest(x, y, obj_star);
if (x == near_star.x && y == near_star.y) {
    var coords = fleet_star_draw_offsets();
}

if (image_index > 9) {
    image_index = 9;
}

var m_dist = point_distance(mouse_x, mouse_y, x + (coords[0] * scale), y + (coords[1] * scale + (12 * scale)));
var within = false;
if (!obj_controller.zoomed) {
    if ((m_dist <= 16 * scale) && (!instance_exists(obj_ingame_menu))) {
        within = 1;
    }
}
if (obj_controller.zoomed == 1) {
    var faction_colour = global.star_name_colors[owner];
    draw_set_color(faction_colour);

    if ((owner == eFACTION.Imperium) && (navy == 0)) {
        draw_set_alpha(0.5);
    }
    draw_circle(x, y, 12, 0);
    draw_set_alpha(1);
    if ((m_dist <= 16) && (!instance_exists(obj_ingame_menu))) {
        within = 1;
    }
}

// if (obj_controller.selected!=0) and (selected=1) then within=1;

if (obj_controller.selecting_planet > 0) {
    if ((mouse_x >= camera_get_view_x(view_camera[0]) + 529) && (mouse_y >= camera_get_view_y(view_camera[0]) + 234) && (mouse_x < camera_get_view_x(view_camera[0]) + 611) && (mouse_y < camera_get_view_y(view_camera[0]) + 249)) {
        if (instance_exists(obj_star_select)) {
            if (obj_star_select.button1 != "") {
                within = 0;
            }
        }
    }
    if ((mouse_x >= camera_get_view_x(view_camera[0]) + 529) && (mouse_y >= camera_get_view_y(view_camera[0]) + 234 + 16) && (mouse_x < camera_get_view_x(view_camera[0]) + 611) && (mouse_y < camera_get_view_y(view_camera[0]) + 249 + 16)) {
        if (instance_exists(obj_star_select)) {
            if (obj_star_select.button2 != "") {
                within = 0;
            }
        }
    }
    if ((mouse_x >= camera_get_view_x(view_camera[0]) + 529) && (mouse_y >= camera_get_view_y(view_camera[0]) + 234 + 32) && (mouse_x < camera_get_view_x(view_camera[0]) + 611) && (mouse_y < camera_get_view_y(view_camera[0]) + 249 + 32)) {
        if (instance_exists(obj_star_select)) {
            if (obj_star_select.button3 != "") {
                within = 0;
            }
        }
    }
}

if (action != "") {
    draw_set_halign(fa_left);
    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_line_width(x, y, action_x, action_y, 1);
    //
    draw_set_font(fnt_40k_14b);
    if (obj_controller.zoomed == 0) {
        draw_text_transformed(x + 12, y, string_hash_to_newline("ETA " + string(action_eta)), 1, 1, 0);
    }
    if (obj_controller.zoomed == 1) {
        draw_text_transformed(x + 24, y, string_hash_to_newline("ETA " + string(action_eta)), 2, 2, 0);
    } // was 1.4
}
switch (owner) {
    case eFACTION.Ork:
        var _has_warboss = false;
        if (fleet_has_cargo("ork_warboss")) {
            draw_icon = true;
            _has_warboss = true;
        }
}

var fleet_descript = "";
if ((within == 1) || (selected > 0)) {
    draw_set_color(CM_GREEN_COLOR);
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_center);

    var fleet_descript = "";
    if (owner == eFACTION.Player) {
        fleet_descript = "Renegade Fleet";
    }
    if (owner == eFACTION.Imperium) {
        if (navy == 1) {
            fleet_descript = "Imperial Navy";
        } else {
            fleet_descript = "Defense Fleet";
        }
    }
    if (navy == 0) {
        if (owner == eFACTION.Imperium) {
            if (fleet_has_cargo("colonize")) {
                fleet_descript = "Imperial Colonists";
            } else if ((trade_goods != "") && (trade_goods != "merge")) {
                fleet_descript = "Trade Fleet";
            }
        }
    }
    // if (navy=1) then fleet_descript=string(trade_goods)+" ("+string(guardsmen_unloaded)+"/"+string(guardsmen_ratio)+")";
    switch (owner) {
        case eFACTION.Mechanicus:
            fleet_descript = "Mechanicus Fleet";
            break;
        case eFACTION.Inquisition:
            fleet_descript = "Inquisitor Ship";
            break;
        case eFACTION.Eldar:
            fleet_descript = "Eldar Fleet";
            break;
        case eFACTION.Ork:
            fleet_descript = "Ork Fleet";
            if (_has_warboss) {
                var _warboss = cargo_data.ork_warboss;
                fleet_descript += $"\nWarboss {_warboss.name}";
            }
            break;
        case eFACTION.Tau:
            fleet_descript = "Tau Fleet";
            break;
        case eFACTION.Tyranids:
            fleet_descript = "Hive Fleet";
            break;
        case eFACTION.Chaos:
            fleet_descript = "Heretic Fleet";
            if (fleet_has_cargo("warband") || fleet_has_cargo("csm")) {
                fleet_descript = string(obj_controller.faction_leader[eFACTION.Chaos]) + "'s Fleet";
                if (string_count("s's Fleet", fleet_descript) > 0) {
                    fleet_descript = string_replace(fleet_descript, "s's Fleet", "s' Fleet");
                }
            }
            break;
        case eFACTION.Necrons:
            fleet_descript = "Necron Fleet";
            break;
    }

    // if (owner = eFACTION.Imperium) and (navy=1){fleet_descript=string(capital_max_imp[1]+frigate_max_imp[1]+escort_max_imp[1]);}

    if (global.cheat_debug == true) {
        fleet_descript += "C" + string(capital_number) + "|F" + string(frigate_number) + "|E" + string(escort_number);
    }

    // fleet_descript=string(capital_number)+"|"+string(frigate_number)+"|"+string(escort_number);
    // fleet_descript+="|"+string(trade_goods);

    draw_set_halign(fa_left);
}

if (fleet_descript != "" && within) {
    tooltip_draw(fleet_descript);
    draw_circle(x + (coords[0] * scale), y + coords[1] * scale, 12 * scale, 0);
} else {
    var faction_colour = global.star_name_colors[owner];
    draw_set_color(faction_colour);
    draw_set_alpha(0.5);
    draw_circle(x + (coords[0] * scale), y + coords[1] * scale, 12 * scale, 0);
    draw_set_alpha(1);
    if (navy && owner == eFACTION.Imperium) {
        draw_set_color(global.star_name_colors[eFACTION.Mechanicus]);
        draw_circle(x + (coords[0] * scale), y + coords[1] * scale, 12 * scale, 1);
        draw_circle(x + (coords[0] * scale), y + coords[1] * scale, 12.1 * scale, 1);
        draw_circle(x + (coords[0] * scale), y + coords[1] * scale, 12.2 * scale, 1);
    }
}
if (draw_icon) {
    draw_sprite_ext(spr_faction_icons, owner, x + (coords[0] * scale) - (32 * scale), y + (coords[1] * scale) - (32 * scale), 1 * scale, 1 * scale, 0, c_white, 1);
}
draw_sprite_ext(sprite_index, image_index, x + (coords[0] * scale), y + (coords[1] * scale), 1 * scale, 1 * scale, 0, c_white, 1);

/*if (owner = eFACTION.Ork){
    draw_set_font(fnt_small);
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(x,y+32,string(escort_number)+"/"+string(frigate_number)+"/"+string(capital_number));
}*/

if (instance_exists(target)) {
    draw_set_color(c_red);
    draw_set_alpha(0.5);
    draw_line(x, y, target.x, target.y);
    draw_set_alpha(1);
}

/* */
/*  */
