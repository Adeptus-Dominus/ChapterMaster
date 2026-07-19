owner = 0;
target = 0;
escort = 0;
frigate = 0;
capital = 0;
selection_window = new DataSlate();
//TODO make this a built in part of the data_slate object
selection_window.currently_entered = false;
currently_entered = false;
fleet_minimized = false;
fleet_all = true;
screen_expansion = 20;
star_travel = [];

void_x = 0;
void_y = 0;
void_wid = 0;
void_hei = 0;
player_fleet = false;

helpful_navigator = new HelpfulPlaces();

/// @self Id.Instance.obj_fleet_select
selection_window.inside_method = function() {
    var mnz = 0;
    var xx = selection_window.XX;
    var yy = selection_window.YY;
    draw_set_font(fnt_40k_14);
    var center_draw = xx + (selection_window.width / 2);
    var width = selection_window.width;
    var height = selection_window.height;

    var lines = 0;
    var posi = -1;
    var colu = 1;
    var y3 = 60;
    var ty = 0;
    var name = "";
    var selection_box = "";
    var scale = 1;
    var void_h = 122;
    var shew = 0;
    var ship_health = 0;
    var escorts = escort;
    var frigates = frigate;
    var capitals = capital;

    var current_fleet = instance_nearest(x, y, obj_p_fleet);

    if (escorts > 0) {
        ty++;
    }

    if (frigates > 0) {
        ty++;
    }

    if (capitals > 0) {
        ty++;
    }

    draw_set_halign(fa_center);
    var ship_select = 0;
    var set = "capital";
    var fleet_sel = "[X]";
    if (!fleet_all) {
        fleet_sel = "[ ]";
    }

    var fleet_all_click = false;
    if (!fleet_minimized) {
        if (point_and_click(draw_unit_buttons([xx + width - 60, yy + 40], fleet_sel, [1, 1], c_red))) {
            fleet_all = fleet_all == 1 ? 0 : 1;
            fleet_all_click = true;
        }

        var math_string = (string_width("Manage Units") / 2) + 6;
        if (point_and_click(draw_unit_buttons([center_draw - math_string, yy + height - 50], "Manage Units", [1, 1], c_blue))) {
            var _fleet_array = fleet_full_ship_array(current_fleet);
            var _fleet_marines = collect_role_group("all", ["", 0, _fleet_array]);

            group_selection(_fleet_marines, {purpose: "Ship Management", purpose_code: "manage", number: 0, system: 0, ships: _fleet_array, feature: "none", planet: 0, selections: []});
        }
    }

    draw_set_halign(fa_center);
    var ship_type, current_ship, full_id;
    if (screen_expansion > 0) {
        for (var j = 0; j < (escorts + frigates + capitals); j++) {
            draw_set_color(c_gray);
            y3 += 20;
            if (y3 > height - 5) {
                break;
            }

            lines++;
            posi++;
            scale = 1;
            shew = 1;
            ship_health = 100;
            if (colu == 1) {
                void_h = min(void_h + 20, 560);
            }

            if (posi == 0) {
                if (mnz == 0) {
                    draw_text(center_draw, yy + y3, "=Capital Ships=");
                }

                y3 += 20;
                if (y3 > height - 50) {
                    break;
                }

                set = "capital";
            }

            if ((posi == capitals) && (frigates > 0)) {
                y3 += 20;
                if (y3 > height - 50) {
                    break;
                }

                if (mnz == 0) {
                    draw_text(center_draw, yy + y3, "=Frigates=");
                }

                y3 += 20;
                if (y3 > height - 50) {
                    break;
                }

                set = "frigate";
            }

            if ((posi == capitals + frigates) && (escorts > 0)) {
                y3 += 20;
                if (y3 > height - 50) {
                    break;
                }

                if (mnz == 0) {
                    draw_text(center_draw, yy + y3, "=Escorts=");
                }

                y3 += 20;
                if (y3 > height - 50) {
                    break;
                }

                set = "escort";
            }

            switch (set) {
                case "capital":
                    current_ship = posi;
                    if (current_ship < array_length(current_fleet.capital)) {
                        ship_type = current_fleet.capital;
                        ship_select = current_fleet.capital_sel[current_ship];
                        full_id = current_fleet.capital_num[current_ship];
                    }

                    break;
                case "frigate":
                    ship_type = current_fleet.frigate;
                    current_ship = posi - capitals;
                    if (current_ship < array_length(current_fleet.frigate)) {
                        ship_select = current_fleet.frigate_sel[current_ship];
                        full_id = current_fleet.frigate_num[current_ship];
                    }

                    break;
                case "escort":
                    ship_type = current_fleet.escort;
                    current_ship = posi - (capitals + frigates);
                    if (current_ship < array_length(current_fleet.escort)) {
                        ship_select = current_fleet.escort_sel[current_ship];
                        full_id = current_fleet.escort_num[current_ship];
                    }

                    break;
            }

            if (fleet_all_click) {
                ship_select = fleet_all;
            }

            if ((posi <= escorts + frigates + capitals) && is_array(ship_type) && current_ship < array_length(ship_type)) {
                name = ship_type[current_ship];
                if (string_width(name) * scale > 179) {
                    for (var i = 0; i < 9; i++) {
                        if (string_width(name) * scale > 179) {
                            scale -= 0.05;
                        }
                    }
                }

                if (scr_hit(xx + 10, yy + y3, xx + width - 10, yy + y3 + 18)) {
                    if (string_width(name) * scale > 135) {
                        for (var i = 0; i < 9; i++) {
                            if (string_width(name) * scale > 135) {
                                scale -= 0.05;
                            }
                        }
                    }

                    shew = 2;
                }

                if (point_and_click([xx + 10, yy + y3, xx + width - 10, yy + y3 + 18])) {
                    if (!(obj_controller.fest_scheduled > 0 && obj_controller.fest_sid == full_id)) {
                        if (ship_select == 1) {
                            ship_select = 0;
                        } else {
                            ship_select = 1;
                        }
                    }
                }

                if (obj_ini.ship_maxhp[full_id] > 0) {
                    ship_health = round((obj_ini.ship_hp[full_id] / obj_ini.ship_maxhp[full_id]) * 100);
                }

                if (ship_select == 0) {
                    selection_box = "[ ]";
                } else if (ship_select == 1) {
                    selection_box = "[x] ";
                }

                if (mnz == 0) {
                    draw_text(xx + width - 25, yy + y3, selection_box);
                    if (shew == 2) {
                        draw_text(xx + width - 60, yy + y3, $"{ship_health}%");
                    }
                }

                if ((ship_health <= 60) && (ship_health > 40)) {
                    draw_set_color(c_yellow);
                }

                if ((ship_health <= 40) && (ship_health > 20)) {
                    draw_set_color(c_orange);
                }

                if (ship_health <= 20) {
                    draw_set_color(c_red);
                }

                if (mnz == 0) {
                    draw_text_transformed(center_draw, yy + y3, name, scale, 1, 0);
                }

                draw_set_color(c_gray);
            }

            switch (set) {
                case "capital":
                    current_fleet.capital_sel[current_ship] = ship_select;
                    break;
                case "frigate":
                    current_fleet.frigate_sel[current_ship] = ship_select;
                    break;
                case "escort":
                    current_fleet.escort_sel[current_ship] = ship_select;
                    break;
            }
        }
    }

    selection_window.currently_entered = scr_hit([xx, yy, xx + width, yy + selection_window.height]) || helpful_navigator.entered();
};
