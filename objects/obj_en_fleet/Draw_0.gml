if ((obj_controller.menu != eMENU.DEFAULT && obj_controller.menu != eMENU.TURN_END) || !instance_exists(obj_star)) {
    exit;
}
var scale = obj_controller.scale_mod;

if ((owner == eFACTION.ELDAR) && instance_exists(orbiting) && (obj_controller.is_test_map == true)) {
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

var coords = [
    0,
    0,
];
var near_star = instance_nearest(x, y, obj_star);
if (x == near_star.x && y == near_star.y) {
    coords = fleet_star_draw_offsets();
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

    if ((owner == eFACTION.IMPERIUM) && (navy == 0)) {
        draw_set_alpha(0.5);
    }
    draw_circle(x, y, 12, 0);
    draw_set_alpha(1);
    if ((m_dist <= 16) && (!instance_exists(obj_ingame_menu))) {
        within = 1;
    }
}

if (obj_controller.selecting_planet > 0) {
    if ((mouse_x >= camera_get_view_x(view_camera[0]) + 529) && (mouse_y >= camera_get_view_y(view_camera[0]) + 234) && (mouse_x < camera_get_view_x(view_camera[0]) + 611) && (mouse_y < camera_get_view_y(view_camera[0]) + 249)) {
        if (instance_exists(obj_star_select)) {
            if (array_length(obj_star_select.buttons) > 0) {
                within = 0;
            }
        }
    }
    if ((mouse_x >= camera_get_view_x(view_camera[0]) + 529) && (mouse_y >= camera_get_view_y(view_camera[0]) + 250) && (mouse_x < camera_get_view_x(view_camera[0]) + 611) && (mouse_y < camera_get_view_y(view_camera[0]) + 265)) {
        if (instance_exists(obj_star_select)) {
            if (array_length(obj_star_select.buttons) > 1) {
                within = 0;
            }
        }
    }
    if ((mouse_x >= camera_get_view_x(view_camera[0]) + 529) && (mouse_y >= camera_get_view_y(view_camera[0]) + 266) && (mouse_x < camera_get_view_x(view_camera[0]) + 611) && (mouse_y < camera_get_view_y(view_camera[0]) + 281)) {
        if (instance_exists(obj_star_select)) {
            if (array_length(obj_star_select.buttons) > 2) {
                within = 0;
            }
        }
    }
}

var line_width = 2 * scale;
var text_size = obj_controller.zoomed ? 2 * scale : scale;

if (action != "") {
    draw_set_halign(fa_left);
    draw_set_alpha(1);
    draw_set_color(CM_GREEN_COLOR);
    draw_line_width(x, y, action_x, action_y, line_width);
    draw_set_font(fnt_40k_14b);
    draw_text_transformed_outline(x + 12, y, $"ETA {action_eta}", text_size, text_size, 0);
}
var _has_warboss = false;
switch (owner) {
    case eFACTION.ORK:
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

    if (owner == eFACTION.PLAYER) {
        fleet_descript = "Renegade Fleet";
    }
    if (owner == eFACTION.IMPERIUM) {
        if (navy == 1) {
            fleet_descript = "Imperial Navy";
        } else {
            fleet_descript = "Defense Fleet";
        }
    }
    if (navy == 0) {
        if (owner == eFACTION.IMPERIUM) {
            if (fleet_has_cargo("colonize")) {
                fleet_descript = "Imperial Colonists";
            } else if ((trade_goods != "") && (trade_goods != "merge")) {
                fleet_descript = "Trade Fleet";
            }
        }
    }
    switch (owner) {
        case eFACTION.MECHANICUS:
            fleet_descript = "Mechanicus Fleet";
            break;
        case eFACTION.INQUISITION:
            fleet_descript = "Inquisitor Ship";
            break;
        case eFACTION.ELDAR:
            fleet_descript = "Eldar Fleet";
            break;
        case eFACTION.ORK:
            fleet_descript = "Ork Fleet";
            if (_has_warboss) {
                var _warboss = cargo_data.ork_warboss;
                fleet_descript += $"\nWarboss {_warboss.name}";
            }
            break;
        case eFACTION.TAU:
            fleet_descript = "Tau Fleet";
            break;
        case eFACTION.TYRANIDS:
            fleet_descript = "Hive Fleet";
            break;
        case eFACTION.CHAOS:
            fleet_descript = "Heretic Fleet";
            if (fleet_has_cargo("warband") || fleet_has_cargo("chaos")) {
                fleet_descript = string(obj_controller.faction_leader[eFACTION.CHAOS]) + "'s Fleet";
                if (string_count("s's Fleet", fleet_descript) > 0) {
                    fleet_descript = string_replace(fleet_descript, "s's Fleet", "s' Fleet");
                }
            }
            break;
        case eFACTION.NECRONS:
            fleet_descript = "Necron Fleet";
            break;
    }

    if (global.cheat_debug == true) {
        fleet_descript += "C" + string(capital_number) + "|F" + string(frigate_number) + "|E" + string(escort_number);
    }

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
    if (navy && owner == eFACTION.IMPERIUM) {
        draw_set_color(global.star_name_colors[eFACTION.MECHANICUS]);
        draw_circle(x + (coords[0] * scale), y + coords[1] * scale, 12 * scale, 1);
        draw_circle(x + (coords[0] * scale), y + coords[1] * scale, 12.1 * scale, 1);
        draw_circle(x + (coords[0] * scale), y + coords[1] * scale, 12.2 * scale, 1);
    }
}
if (draw_icon) {
    draw_sprite_ext(spr_faction_icons, owner, x + (coords[0] * scale) - (32 * scale), y + (coords[1] * scale) - (32 * scale), 1 * scale, 1 * scale, 0, c_white, 1);
}
draw_sprite_ext(sprite_index, image_index, x + (coords[0] * scale), y + (coords[1] * scale), 1 * scale, 1 * scale, 0, c_white, 1);

if (instance_exists(target)) {
    draw_set_color(c_red);
    draw_set_alpha(0.5);
    draw_line_width(x, y, target.x, target.y, line_width);
    draw_set_alpha(1);
}

draw_set_color(c_white);
