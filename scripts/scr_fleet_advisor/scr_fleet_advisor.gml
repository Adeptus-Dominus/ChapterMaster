/// @self Asset.GMObject.obj_controller
function scr_fleet_advisor() {
    //TODO swap this xx yy stuff out for a surface
    var xx = camera_get_view_x(view_camera[0]);
    var yy = camera_get_view_y(view_camera[0]);
    draw_sprite(spr_rock_bg, 0, xx, yy);
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(xx + 342, yy + 66, xx + 903, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 342, yy + 66, xx + 903, yy + 818, 1);
    draw_line(xx + 342, yy + 426, xx + 903, yy + 426);
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 1);

    var ini = instance_find(obj_ini, 0);
    if (ini == noone) {
        return;
    }
    var cn = id;

    var _blurp = "";

    if (menu_adept == 0) {
        if (struct_exists(ini.custom_advisors, "admiral")) {
            scr_image("advisor/splash", ini.custom_advisors.admiral, xx + 16, yy + 43, 310, 828);
        } else {
            scr_image("advisor/splash", 7, xx + 16, yy + 43, 310, 828);
        }
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(cjk_font(fnt_40k_30b));
        draw_text_transformed(xx + 352, yy + 66, localize("Flagship Bridge"), 1, 1, 0);
        draw_text_transformed(xx + 352, yy + 100, localize("Master of the Fleet {0}", [ini.lord_admiral_name]), 0.6, 0.6, 0);
        draw_set_font(cjk_font(fnt_40k_14));
        _blurp = localize("Greetings, Chapter Master.\n\nYou requested a report?  Our fleet contains ");
    }
    if (menu_adept == 1) {
        scr_image("advisor/splash", 1, xx + 16, yy + 43, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(cjk_font(fnt_40k_30b));
        draw_text_transformed(xx + 352, yy + 40, localize("Flagship Bridge"), 1, 1, 0);
        draw_text_transformed(xx + 352, yy + 100, localize("Adept {0}", [cn.adept_name]), 0.6, 0.6, 0);
        draw_set_font(cjk_font(fnt_40k_14));
        _blurp = localize("Your fleet contains ");
    }

    _blurp += localize("{0} Capital Ships, ", [string(temp[37])]);
    _blurp += localize("{0} Frigates, and ", [string(temp[38])]);
    _blurp += localize("{0} Escorts", [string(temp[39])]);

    var _hull_normalized = real(temp[41]);

    if (_hull_normalized >= 1) {
        _blurp += localize(", none of which are damaged.");
    } else if (_hull_normalized < 1) {
        _blurp += localize(".  Our most damaged vessel is the {0} - it has {1}% Hull Integrity.", [temp[40], string(min(99, round(_hull_normalized * 100)))]);
    }

    var _crippled_ships = real(temp[42]);

    if (_crippled_ships == 2) {
        _blurp += localize("  Two of our ships are highly damaged.  You may wish to purchase a Repair License from the Sector Governerner.");
    } else if (_crippled_ships > 2) {
        _blurp += localize("  Several of our ships are highly damaged.  It is advisable that you purchase a Repair License from the Sector Governer.");
    }

    _blurp += localize("\n\nHere are the current positions of our ships and their contents:");

    if (menu_adept == 1) {
        _blurp = string_replace(_blurp, "Our", "Your");
        _blurp = string_replace(_blurp, " our", " your");
        _blurp = string_replace(_blurp, "We", "You");
    }

    draw_text_ext(xx + 352, yy + 130, _blurp, -1, 536);

    draw_set_font(cjk_font(fnt_40k_30b));
    draw_set_halign(fa_center);
    draw_text_transformed(xx + 1262, yy + 40, localize("Fleet"), 0.6, 0.6, 0);

    draw_set_font(cjk_font(fnt_40k_14));
    draw_set_halign(fa_left);

    // TODO: Probably a good idea to turn this whole interactive list/sheet generating logic into a constructor, that can be reused on many screens.
    // I have no passion for this atm.
    if (instance_exists(cn)) {
        var _columns = {
            name: {
                w: 176,
                text: localize("Name"),
                h_align: fa_left,
            },
            class: {
                w: 154,
                text: localize("Class"),
                h_align: fa_left,
            },
            location: {
                w: 130,
                text: localize("Location"),
                h_align: fa_left,
            },
            hp: {
                w: 44,
                text: localize("HP"),
                h_align: fa_right,
            },
            carrying: {
                w: 84,
                text: localize("Carrying"),
                h_align: fa_right,
            },
        };

        var _column_x = xx + 953;
        var _header_offset = 80;
        var _columns_array = [
            "name",
            "class",
            "location",
            "hp",
            "carrying",
        ];

        for (var i = 0; i < array_length(_columns_array); i++) {
            with (_columns[$ _columns_array[i]]) {
                x1 = _column_x;
                _column_x += w;
                x2 = x1 + w;
                y1 = yy + _header_offset;
                header_y = y1 - 2;
                switch (h_align) {
                    case fa_right:
                        header_x = x2;
                        break;
                    case fa_center:
                        header_x = (x1 + x2) / 2;
                        break;
                    case fa_left:
                    default:
                        header_x = x1;
                        break;
                }
                draw_set_halign(h_align);
                draw_text(header_x, header_y, text);
            }
        }
        draw_set_halign(fa_left);

        var _row_height = 20;
        var _row_gap = 2;
        for (var i = ship_current; i < ship_current + 34; i++) {
            if (i >= array_length(ini.ship)) {
                continue;
            }
            if (ini.ship[i] != "") {
                var _row_y = _columns[$ "name"].y1 + _row_height + (i * (_row_height + _row_gap));
                draw_rectangle(xx + 950, _row_y, xx + 1546, _row_y + _row_height, 1);

                var _goto_button = {
                    x1: _columns.location.x1 - 20,
                    y1: _row_y + 4,
                    sprite: spr_view_small,
                    click: function() {
                        return point_and_click([x1, y1, x2, y2]);
                    },
                };
                with (_goto_button) {
                    w = sprite_get_width(sprite);
                    h = sprite_get_height(sprite);
                    x2 = x1 + w;
                    y2 = y1 + h;
                    draw_sprite(sprite, 0, x1, y1);
                }

                with (_columns) {
                    name.contents = string_truncate(ini.ship[i], _columns.name.w - 6);
                    class.contents = localize(ini.ship_class[i]);
                    location.contents = ini.ship_location[i];
                    hp.contents = $"{round(ini.ship_hp[i] / ini.ship_maxhp[i] * 100)}%";
                    carrying.contents = $"{ini.ship_carrying[i]}/{ini.ship_capacity[i]}";
                }

                for (var g = 0; g < array_length(_columns_array); g++) {
                    with (_columns[$ _columns_array[g]]) {
                        draw_set_halign(h_align);
                        switch (h_align) {
                            case fa_right:
                                draw_text(x2, _row_y, contents);
                                break;
                            case fa_center:
                                draw_text((x1 + x2) / 2, _row_y, contents);
                                break;
                            case fa_left:
                            default:
                                draw_text(x1, _row_y, contents);
                                break;
                        }
                    }
                }

                if (scr_hit(xx + 950, _row_y, xx + 1546, _row_y + _row_height)) {
                    if (cn.temp[101] != ini.ship[i]) {
                        cn.temp[101] = ini.ship[i];
                        cn.temp[102] = ini.ship_class[i];

                        cn.temp[103] = string(ini.ship_hp[i]);
                        cn.temp[104] = string(ini.ship_maxhp[i]);
                        cn.temp[105] = string(ini.ship_shields[i] * 100);

                        cn.temp[106] = string(ini.ship_speed[i]);

                        cn.temp[107] = string(ini.ship_front_armour[i]);
                        cn.temp[108] = string(ini.ship_other_armour[i]);

                        cn.temp[109] = string(ini.ship_turrets[i]);

                        var facing_length = array_length(ini.ship_wep_facing[i]);
                        var wep_length = array_length(ini.ship_wep[i]);
                        var max_weapons = min(facing_length, wep_length, 5);

                        for (var s = 1; s < max_weapons; s++) {
                            cn.temp[110 + ((s - 1) * 2)] = ini.ship_wep[i][s];
                            cn.temp[110 + ((s - 1) * 2) + 1] = ini.ship_wep_facing[i][s];
                        }

                        cn.temp[118] = $"{ini.ship_carrying[i]}/{ini.ship_capacity[i]}";
                        cn.temp[119] = "";
                        if (ini.ship_carrying[i] > 0) {
                            cn.temp[119] = scr_ship_occupants(i);
                        }
                    }
                    tooltip_draw(localize("Carrying ({0}): {1}", [cn.temp[118], cn.temp[119]]));
                    if (_goto_button.click()) {
                        with (obj_p_fleet) {
                            var _fleet_ships = fleet_full_ship_array();
                            if (array_contains(_fleet_ships, i)) {
                                cn.x = x;
                                cn.y = y;
                                cn.menu = 0;
                                with (obj_fleet_show) {
                                    instance_destroy();
                                }
                                instance_create(x, y, obj_fleet_show);
                            }
                        }
                    }
                }
            }
        }

        if (cn.temp[101] != "") {
            draw_set_font(cjk_font(fnt_40k_30b));
            draw_set_halign(fa_center);
            draw_text_transformed(xx + 622, yy + 434, cn.temp[101], 0.75, 0.75, 0);
            draw_text_transformed(xx + 622, yy + 464, localize(cn.temp[102]), 0.5, 0.5, 0);

            draw_set_color(c_gray);
            draw_rectangle(xx + 488, yy + 492, xx + 756, yy + 634, 1);
            var ships = [
                "Battle Barge",
                "Strike Cruiser",
                "Gladius",
                "Hunter",
            ];
            var ship_im = 0;
            for (var i = 0; i < array_length(ships); i++) {
                if (cn.temp[102] == ships[i]) {
                    ship_im = i;
                    break;
                }
            }
            draw_set_color(c_white);
            draw_sprite(spr_ship_back_white, ship_im, xx + 488, yy + 492);

            draw_set_color(c_gray);
            draw_set_font(cjk_font(fnt_40k_14));
            draw_set_halign(fa_left);

            draw_text(xx + 383, yy + 655, localize("Health: {0}/{1}", [cn.temp[103], cn.temp[104]]));
            draw_text(xx + 588, yy + 655, localize("Shields: {0}", [cn.temp[105]]));
            draw_text(xx + 768, yy + 655, localize("Armour: {0},{1}", [cn.temp[107], cn.temp[108]]));

            draw_text(xx + 495, yy + 675, localize("Speed: {0}", [cn.temp[106]]));
            draw_text(xx + 680, yy + 675, localize("Turrets: {0}", [cn.temp[109]]));

            if (cn.temp[110] != "") {
                draw_text(xx + 383, yy + 705, localize("-{0} ({1})", [localize(cn.temp[110]), cn.temp[111]]));
            }
            if (cn.temp[112] != "") {
                draw_text(xx + 383, yy + 725, localize("-{0} ({1})", [localize(cn.temp[112]), cn.temp[113]]));
            }
            if (cn.temp[114] != "") {
                draw_text(xx + 383, yy + 745, localize("-{0} ({1})", [localize(cn.temp[114]), cn.temp[115]]));
            }
            if (cn.temp[116] != "") {
                draw_text(xx + 383, yy + 765, localize("-{0} ({1})", [localize(cn.temp[116]), cn.temp[117]]));
            }

            draw_set_font(cjk_font(fnt_40k_12));
            draw_set_font(cjk_font(fnt_40k_14));
        }
    }
    // 31 wide
    scr_scrollbar(1550, 100, 1577, 818, 34, ship_max, ship_current);
}
