function in_camera_view(rect) {
    var x1 = camera_get_view_x(view_camera[0]);
    var y1 = camera_get_view_y(view_camera[0]);
    var w = x1 + camera_get_view_width(view_camera[0]);
    var h = y1 + camera_get_view_height(view_camera[0]);
    return rectangle_in_rectangle(rect[0], rect[1], rect[2], rect[3], x1, y1, w, h);
}

/// @self Id.Instance.obj_controller
function main_map_move_keys() {
    var view_w = camera_get_view_width(view_camera[0]);
    var view_h = camera_get_view_height(view_camera[0]);
    var x_limits = 0;
    var y_limits = 0;
    if (((menu == eMENU.DEFAULT || menu == eMENU.TURN_END) && formating == 0) || instance_exists(obj_fleet)) {
        var spd = 12 * obj_controller.scale_mod; // player move speed on campaign map
        if (!instances_exist_any([obj_ingame_menu, obj_ncombat])) {
            if (keyboard_check(vk_shift)) {
                spd *= 3;
            } // shift down, increase speed
            var view_x = camera_get_view_x(view_camera[0]) + 2;
            var view_y = camera_get_view_y(view_camera[0]) + 2;

            if ((keyboard_check(vk_left) || (mouse_x <= view_x + (view_w * 0.02)) || keyboard_check(ord("A"))) && (x > x_limits)) {
                var rel_view = view_w > global.default_view_width ? global.default_view_width / 2 : view_w / 2;
                x = (x > view_x + rel_view) ? view_x + rel_view : x;
                x -= spd;
                camera_moved_this_turn = true;
            }
            if ((keyboard_check(vk_right) || (mouse_x >= view_x + (view_w * 0.98)) || keyboard_check(ord("D"))) && (x < (room_width - x_limits))) {
                var rel_view = view_w > global.default_view_width ? global.default_view_width / 2 : view_w / 2;
                x = (x < view_x + view_w - rel_view) ? view_x + view_w - rel_view : x;
                x += spd;
                camera_moved_this_turn = true;
            }
            if ((keyboard_check(vk_up) || (mouse_y <= view_y + (view_h * 0.02)) || keyboard_check(ord("W"))) && (y > y_limits)) {
                var rel_view = view_h > global.default_view_height ? global.default_view_height / 2 : view_h / 2;
                y = (y > view_y + rel_view) ? view_y + rel_view : y;
                y -= spd;
                camera_moved_this_turn = true;
            }
            if ((keyboard_check(vk_down) || (mouse_y >= view_y + (view_h * 0.98)) || keyboard_check(ord("S"))) && (y < room_height - y_limits)) {
                var rel_view = view_h > global.default_view_height ? global.default_view_height / 2 : view_h / 2;
                y = (y < view_y + view_h - rel_view) ? view_y + view_h - rel_view : y;
                y += spd;
                camera_moved_this_turn = true;
            }
            if (array_length(location_viewer.travel_target) > 0) {
                camera_moved_this_turn = true;
            }
        }
    }

    x = clamp(x, x_limits, room_width);
    y = clamp(y, y_limits, room_height);
}

function scr_map_scale() {
    return global.default_view_width / camera_get_view_width(view_camera[0]);
}

function WarpLane(_star_1, _star_2, _grade) constructor {
    star_1 = _star_1;
    star_2 = _star_2;
    x1 = star_1.x;
    x2 = star_2.x;
    y1 = star_1.y;
    y2 = star_2.y;
    in_view = true;
    grade = _grade;
    handler = obj_ini.sector_handler.warp_lanes;
    line_alpha = 0.4;
    static count = 0;
    count++;
    index = count;
    line_x_travel = 0;
    line_y_travel = 0;
    last_map_scale = 0;

    static calc_in_view = function() {
        in_view = star_1.in_view || star_2.in_view;
    };

    static draw_basic_lane = function() {
        draw_set_alpha(line_alpha);
        draw_line_width(x1, y1, x2, y2, handler.line_width);
        draw_set_alpha(1);
    };

    static warp_route_tooltip = "Major warp route to {0} (x4 travel speed for warp capable crafts)\n\nHold Shift and click Left Mouse Button to see destination.";

    static major_warp_route_hit_box = function(star = 1) {
        var _dest_star = star == 1 ? star_2 : star_1;
        var _hover_star = star == 1 ? star_1 : star_2;

        var _warp_center = {
            x1: star == 1 ? _hover_star.x + line_x_travel : _hover_star.x - line_x_travel,
            y1: star == 1 ? _hover_star.y + line_y_travel : _hover_star.y - line_y_travel,
        };

        for (var s = 0; s < grade; s++) {
            draw_set_alpha(line_alpha);
            draw_line_width(_hover_star.x, _hover_star.y, _warp_center.x1, _warp_center.y1, handler.line_width);
            draw_set_alpha(1);
        }
        if (!_hover_star.in_view) {
            exit;
        }
        draw_sprite_centered(spr_warp_storm, handler.warp_image + index, _warp_center.x1, _warp_center.y1, 0.75, 0.75, 0, c_white, 1);

        var _hit_box = [
            _warp_center.x1 - (handler.warp_width / 2),
            _warp_center.y1 - (handler.warp_height / 2),
            _warp_center.x1 + (handler.warp_width / 2),
            _warp_center.y1 + (handler.warp_height / 2),
        ];

        if (scr_hit(_hit_box)) {
            //TODO centralise this for efficiency so it's only run once at the beggingin of step sequence
            var _star_overlap = false;
            with (obj_star) {
                if (point_distance(mouse_x, mouse_y, x, y) < 20) {
                    _star_overlap = true;
                    break;
                }
            }

            if (!_star_overlap) {
                if (handler.allow_tooltips) {
                    tooltip_draw(string(warp_route_tooltip, _dest_star.name));
                }

                if (mouse_check_button_pressed(mb_left) && keyboard_check(vk_shift)) {
                    set_map_pan_to_loc(_dest_star);
                }
            }
        }
    };

    static update_draw_distance_from_star = function() {
        var _direction_x = x2 - x1;
        var _direction_y = y2 - y1;
        var _forward = _direction_x >= 0 ? 1 : -1;
        var _downward = _direction_y >= 0 ? 1 : -1;
        var _total_dist = 80;
        var _pythag_dist = sqr(_total_dist);
        var _sum = (_direction_x * _forward) + (_direction_y * _downward);
        var _x_ratio = _direction_x * _forward / _sum;
        var _y_ratio = _direction_y * _downward / _sum;
        line_x_travel = sqrt(_pythag_dist * _x_ratio) * _forward;
        line_y_travel = sqrt(_pythag_dist * _y_ratio) * _downward;
        last_map_scale = obj_controller.map_scale;
    };

    static draw_major_warp_route = function() {
        draw_set_color(c_yellow);
        //TODO abstract code as a ratio distance function
        if (last_map_scale != obj_controller.map_scale) {
            update_draw_distance_from_star();
        }

        major_warp_route_hit_box();
        major_warp_route_hit_box(2);
    };

    static draw = function() {
        if (grade < 4) {
            draw_basic_lane();
        } else if (grade == 4) {
            draw_major_warp_route();
        }
    };
}

function WarpLaneHandler() constructor {
    routes = [];
    static current_seed = global.game_seed;
    static warp_image = -1;
    static warp_width = sprite_get_width(spr_warp_storm) * 0.75;
    static warp_height = sprite_get_height(spr_warp_storm) * 0.75;
    static line_width = 0;
    static line_alpha = 0.4;

    allow_tooltips = true;

    static calc_warp_lanes = function() {
        current_seed = global.game_seed;
        routes = [];
        var _star_degrade_list = [];
        var _total_stars = instance_number(obj_star);
        for (var i = 0; i < _total_stars; i++) {
            array_push(_star_degrade_list, i);
        }
        for (var i = 0; i < _total_stars; i++) {
            var _cur_star = instance_find(obj_star, _star_degrade_list[i]);
            var _this_star = _cur_star.id;

            if (array_length(_cur_star.warp_lanes) > 0) {
                for (var s = 0; s < _total_stars; s++) {
                    if (s == i) {
                        continue;
                    }
                    var _check_star = instance_find(obj_star, _star_degrade_list[s]);
                    var _connection = determine_warp_join(_check_star.id, _this_star);
                    if (_connection) {
                        array_push(routes, new WarpLane(_check_star, _this_star, _connection));
                    }
                }
            }
            array_delete(_star_degrade_list, i, 1);
            _total_stars--;
            i--;
        }
    };

    static draw = function() {
        line_width = 2 * obj_controller.scale_mod;
        warp_image += 0.5;
        if (warp_image == 58) {
            warp_image = 0;
        }
        allow_tooltips = !instance_exists(obj_star_select);

        if (allow_tooltips && instance_exists(obj_fleet_select)) {
            var mouse_consts = return_mouse_consts();

            allow_tooltips = !obj_fleet_select.currently_entered || (mouse_consts[0] - camera_get_view_x(view_camera[0]) > 300);
        }

        if (array_length(routes) == 0 || current_seed != global.game_seed) {
            calc_warp_lanes();
        }

        for (var i = 0; i < array_length(routes); i++) {
            draw_set_color(c_gray);
            var _route = routes[i];
            if (obj_controller.camera_moved_this_turn) {
                _route.calc_in_view();
            }
            if (!_route.in_view) {
                continue;
            }

            _route.draw();
        }
    };
}

function create_complex_star_routes(player_star) {
    var north = [], east = [], west = [], south = [], central = [];
    with (obj_star) {
        var _home = id == player_star;
        if (_home) {
            if (obj_ini.home_warp_position == 0) {
                //isolated environment
                instance_deactivate_object(id);
                continue;
            }
        }
        var _allow_major = !_home || (obj_ini.home_warp_position == 2 && _home);
        if (_allow_major) {
            if (x < 700) {
                array_push(west, id);
            }
            if (y < 700) {
                array_push(north, id);
            }
            if (x > room_width - 700) {
                array_push(east, id);
            }
            if (y > room_height - 700) {
                array_push(south, id);
            }
            if ((x > 700) && (y > 700) && (x < room_width - 700) && (y < room_height - 700)) {
                array_push(central, id);
            }
        }

        var nearest_star = distance_removed_star(x, y, 1, true, true, false);
        if (determine_warp_join(nearest_star.id, self.id)) {
            array_push(warp_lanes, [distance_removed_star(x, y, 2, true, true, false).name, 1]);
        } else {
            array_push(warp_lanes, [nearest_star.name, 1]);
        }

        if (!irandom(8) || (id == player_star && obj_ini.home_warp_position == 2)) {
            array_push(warp_lanes, [distance_removed_star(x, y, irandom_range(3, 6), true, true, false).name, 1]);
        }
    }
    full_loci = [
        north,
        east,
        west,
        south,
        central,
    ];
    // here is where we set up the warp hubs
    var WarpHub, set, join_set, total_joins;
    for (var i = 0; i < array_length(full_loci); i++) {
        var player_hub_overide = false;
        if (irandom(1)) {
            if (obj_ini.home_warp_position != 2) {
                continue;
            } else {
                if (!array_contains(full_loci[i], player_star)) {
                    continue;
                } else {
                    player_hub_overide = true;
                }
            }
        } else {
            if (array_contains(full_loci[i], player_star)) {
                player_hub_overide = true;
            }
        }
        set = full_loci[i];
        if (array_length(set) == 0) {
            continue;
        }
        if (player_hub_overide) {
            for (var j = 0; j < array_length(set); j++) {
                if (set[j] == player_star) {
                    WarpHub = set[j];
                    break;
                }
            }
        } else {
            WarpHub = array_random_element(set);
        }
        total_joins = 0;
        for (var s = 0; s < array_length(full_loci); s++) {
            if (!irandom(1)) {
                continue;
            }
            join_set = full_loci[s];
            var set_count = array_length(join_set);
            if (s == i || set_count == 0) {
                continue;
            }
            join_star = array_random_element(join_set);
            array_push(WarpHub.warp_lanes, [join_star.name, 4]);
            total_joins++;
            if (total_joins > 3) {
                break;
            }
        }
    }
    instance_activate_object(obj_star);
}

function set_map_pan_to_loc(target) {
    with (obj_controller) {
        location_viewer.travel_target = [
            target.x,
            target.y,
        ];
        location_viewer.travel_increments = [
            (target.x - x) / 15,
            (target.y - y) / 15,
        ];
        location_viewer.travel_time = 0;
    }
}

function star_box_shape(star = noone) {
    var scale = obj_controller.map_scale;
    if (star == noone) {
        return [
            x - (60 * scale),
            y + (5 * scale),
            x + 60 * scale,
            y - 40 * scale,
        ];
    } else {
        with (star) {
            return [
                x - (60 * scale),
                y + (5 * scale),
                x + 60 * scale,
                y - 40 * scale,
            ];
        }
    }
}
