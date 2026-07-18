if (!instance_exists(obj_star)) {
    exit;
}

if (instance_exists(orbiting) && (obj_controller.is_test_map == true)) {
    draw_set_color(c_red);
    draw_line_width(x, y, orbiting.x, orbiting.y, 1);
}
var scale = obj_controller.scale_mod;

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
    coords = [
        24,
        -24,
    ];
}

var within = false;
var m_dist = point_distance(mouse_x, mouse_y, x + (coords[0] * scale), y + (coords[1] * scale + (12 * scale)));

if (obj_controller.zoomed == 0) {
    if (m_dist <= (16 * scale)) {
        within = 1;
    }
}
if (obj_controller.zoomed == 1) {
    within = true;
    if (m_dist <= 24) {
        within = 1;
    }
}

var select_instance = instance_exists(obj_fleet_select);
if (!select_instance) {
    selected = 0;
}
if (!keyboard_check(vk_shift)) {
    if (within) {
        if (mouse_check_button_pressed(mb_left) && obj_controller.menu == eMENU.DEFAULT && !selected) {
            alarm[3] = 1;
        }
    } else {
        mouse_check_button_pressed(mb_left);
    }
    if (selected) {
        if (select_instance) {
            if (instance_exists(obj_fleet_select.player_fleet)) {
                if (!(obj_fleet_select.player_fleet.id == self.id && !obj_fleet_select.currently_entered)) {
                    selected = 0;
                }
            }
        }
    }
}

if (obj_controller.selecting_planet > 0 && instance_exists(obj_star_select)) {
    var _btn_count = array_length(obj_star_select.buttons);
    for (var i = 0; i < _btn_count; i++) {
        if ((mouse_x >= camera_get_view_x(view_camera[0]) + 529) && (mouse_y >= camera_get_view_y(view_camera[0]) + 234 + (16 * i)) && (mouse_x < camera_get_view_x(view_camera[0]) + 611) && (mouse_y < camera_get_view_y(view_camera[0]) + 249 + (16 * i))) {
            within = 0;
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

    if (array_length(complex_route) > 0) {
        var next_loc = instance_nearest(action_x, action_y, obj_star);
        for (var i = 0; i < array_length(complex_route); i++) {
            var target_loc = find_star_by_name(complex_route[i]);
            draw_set_color(c_blue);
            draw_set_alpha(1);
            draw_line_dashed(next_loc.x, next_loc.y, target_loc.x, target_loc.y, 16, line_width);
            next_loc = find_star_by_name(complex_route[i]);
        }
    }
}

if ((within == 1) || (selected > 0)) {
    var ppp;
    if (owner == eFACTION.PLAYER) {
        ppp = global.chapter_name;
    }
    if ((capital_number == 1) && (frigate_number == 0) && (escort_number == 0)) {
        ppp = capital[0];
    }
    if ((capital_number == 0) && (frigate_number == 1) && (escort_number == 0)) {
        ppp = frigate[0];
    }
    if ((capital_number == 0) && (frigate_number == 0) && (escort_number == 1)) {
        ppp = escort[0];
    }
    draw_set_color(CM_GREEN_COLOR);
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_center);
    if (obj_controller.zoomed) {
        draw_text_transformed(x, y - 48, string_hash_to_newline(ppp), text_size, text_size, 0);
    } // was 1.4
    draw_set_halign(fa_left);

    draw_circle(x + (coords[0] * scale), y + (coords[1] * scale), 12 * scale, 0);
} else {
    draw_set_color(global.star_name_colors[eFACTION.PLAYER]);
    draw_set_alpha(0.5);
    draw_circle(x + (coords[0] * scale), y + (coords[1] * scale), 12 * scale, 0);
    draw_set_alpha(1);
}

draw_set_color(c_white);
draw_sprite_ext(sprite_index, image_index, x + (coords[0] * scale), y + (coords[1] * scale), 1 * scale, 1 * scale, 0, c_white, 1);
