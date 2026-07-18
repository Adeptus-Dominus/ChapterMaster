if (instances_exist_any([obj_bomb_select, obj_drop_select, obj_popup])) {
    exit;
}

if (obj_controller.zoomed == 1) {
    exit;
}
if (!instance_exists(target)) {
    exit;
}
if (obj_controller.menu == 60) {
    exit;
}

add_draw_return_values();
draw_set_font(fnt_40k_14b);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(0);

try {
    if (loading == 1) {
        obj_controller.selecting_planet = 0;
        buttons = [];

        if (instance_exists(target)) {
            if (target.space_hulk == 1) {
                pop_draw_return_values();
                exit;
            }
        }
    }
    if (obj_controller.selecting_planet > target.planets) {
        obj_controller.selecting_planet = 0;
    }
    var click_accepted = (!obj_controller.menu) && (!obj_controller.zoomed) && (!instance_exists(obj_bomb_select)) && (!instance_exists(obj_drop_select));
    if (click_accepted && (!debug || !debug_slate.entered())) {
        if (mouse_button_clicked(, 0)) {
            var mouse_consts = return_mouse_consts();
            var sta1 = instance_nearest(mouse_consts[0], mouse_consts[1], obj_star);
            var sta2 = point_distance(mouse_consts[0], mouse_consts[1], sta1.x, sta1.y);
            var closes = true;
            if (sta2 > 15) {
                if (scr_hit(27, 165, 300, 165 + 294)) {
                    closes = false;
                } else if (obj_controller.selecting_planet > 0) {
                    closes = !main_data_slate.entered();
                    if (closes) {
                        if (is_struct(garrison) || population) {
                            closes = !garrison_data_slate.entered();
                        }
                    }

                    if (!is_string(feature)) {
                        if (feature.main_slate.entered()) {
                            closes = false;
                        }
                    }
                }
                for (var i = 0; i < array_length(shutters); i++) {
                    var shutter_button = shutters[i];
                    if (shutter_button.hit()) {
                        closes = false;
                        break;
                    }
                }
                if (closes) {
                    cooldown = 0;
                    obj_controller.sel_system_x = 0;
                    obj_controller.sel_system_y = 0;
                    obj_controller.selecting_planet = 0;
                    obj_controller.popup = 0;
                    instance_destroy();
                }
            }
        }
    }

    var _standard_star = !target.craftworld && !target.space_hulk;

    if (_standard_star) {
        draw_sprite(spr_star_screen, target.planets, 27, 165);
        draw_sprite_ext(target.sprite_index, target.image_index, 77, 287, 1.25, 1.25, 0, c_white, 1);
    } else if (target.craftworld) {
        draw_sprite(spr_star_screen, 5, 27, 165);
    } else if (target.space_hulk) {
        draw_sprite_ext(target.sprite_index, target.image_index, 77, 287, 1.25, 1.25, 0, c_white, 1);
    }

    var _screen_height = sprite_get_height(spr_star_screen);
    var _screen_width = sprite_get_width(spr_star_screen);

    //TODO bottle these into a constructor for re-use
    draw_sprite_ext(spr_servo_left_arm, 0, 27 + _screen_width, 165 + _screen_height / 3, 2, 2, 0, c_white, 1);
    draw_sprite_ext(spr_servo_right_arm, 0, 27, 165 + _screen_height / 3, 2, 2, 0, c_white, 1);
    draw_sprite_ext(spr_servo_skull_head, 0, 27 + _screen_width / 2, 165, 2, 2, 0, c_white, 1);

    var system_string = $"{target.name} System";

    draw_set_color(target.owner == eFACTION.PLAYER ? c_blue : 0);

    if (_standard_star) {
        draw_text_transformed(184, 180, system_string, 1, 1, 0);
        draw_set_color(global.star_name_colors[target.owner]);
        draw_text_transformed(184, 180, system_string, 1, 1, 0);
    }

    if (global.cheat_debug && obj_controller.selecting_planet && !loading) {
        draw_planet_debug_options();
    }

    if (obj_controller.menu == eMENU.DEFAULT && !debug) {
        if (manage_units_button.draw(has_player_forces)) {
            var _viewer = obj_controller.location_viewer;
            _viewer.update_garrison_log();
            var _unit_dispersement = _viewer.garrison_log;
            var _sys_name = target.name;
            if (struct_exists(_unit_dispersement, target.name)) {
                group_selection(_unit_dispersement[$ _sys_name].units, {purpose: $"{target.name} Management", purpose_code: "manage", number: 0, system: target.id, feature: "none", planet: 0, selections: []});
                instance_destroy();
                pop_draw_return_values();
                exit;
            }
        }
    }

    if (loading != 0) {
        draw_set_font(fnt_40k_14);
        draw_set_color(CM_GREEN_COLOR);
        draw_text(184, 202, "Select Destination");
    }

    //the draw and click on planets logic
    if (!debug) {
        planet_selection_action();
    }

    draw_set_font(fnt_40k_14b);

    var _planet = obj_controller.selecting_planet;
    if (_planet != 0) {
        if (p_data.planet != _planet) {
            p_data = target.get_planet_data(_planet);
        }

        // Buttons that are available
        if (!buttons_selected) {
            buttons = [];

            if (p_data.planet > 0) {
                if (target.present_fleet[1] > 0) {
                    if (p_data.has_any_force()) {
                        array_push(buttons, "Attack", "Raid", "Bombard");
                    }

                    if (p_data.population > 0) {
                        array_push(buttons, "Purge");
                    }

                    if (torpedo > 0) {
                        var pfleet = instance_nearest(x, y, obj_p_fleet);
                        if (instance_exists(pfleet) && (point_distance(pfleet.x, pfleet.y, target.x, target.y) <= 40) && (pfleet.action == "")) {
                            if (pfleet.capital_number + pfleet.frigate_number > 0) {
                                array_push(buttons, "Cyclonic Torpedo");
                            }
                        }
                    }
                } else if (p_data.player_forces > 0) {
                    if (p_data.has_any_force()) {
                        array_push(buttons, "Attack");
                    }

                    if (p_data.population > 0) {
                        array_push(buttons, "Purge");
                    }
                }
            }
            var planet_upgrades = target.p_upgrades[obj_controller.selecting_planet];
            if (((p_data.planet_type == "Dead") || (array_length(p_data.upgrades) > 0)) && ((target.present_fleet[1] > 0) || (target.p_player[obj_controller.selecting_planet] > 0))) {
                if ((array_length(p_data.features) == 0) || (array_length(planet_upgrades) > 0)) {
                    if (!p_data.has_enemy_force()) {
                        buttons = [];
                        if (array_length(p_data.upgrades) == 0) {
                            array_push(buttons, "Build");
                        } else if (p_data.has_upgrade(eP_FEATURES.SECRET_BASE)) {
                            array_push(buttons, "Base");
                        } else if (p_data.has_upgrade(eP_FEATURES.ARSENAL)) {
                            array_push(buttons, "Arsenal");
                        } else if (p_data.has_upgrade(eP_FEATURES.GENE_VAULT)) {
                            array_push(buttons, "Gene-Vault");
                        }
                    }
                }
            }

            if (obj_controller.recruiting_worlds_bought > 0 && !p_data.at_war()) {
                if (!p_data.has_feature(eP_FEATURES.RECRUITING_WORLD) && p_data.planet_type != "Dead" && !target.space_hulk) {
                    array_push(buttons, "+Recruiting");
                }
            }
            if (target.space_hulk) {
                if (target.present_fleet[1] > 0) {
                    buttons = [
                        "Raid",
                        "Bombard",
                    ];
                }
            }

            while (array_length(shutters) < array_length(buttons)) {
                array_push(shutters, new ShutterButton());
            }

            while (array_length(shutters) > array_length(buttons)) {
                array_delete(shutters, array_length(shutters) - 1, 1);
            }

            buttons_selected = true;
        }

        main_data_slate.inside_method = function() {
            p_data.planet_info_screen();
        };
        var slate_draw_scale = 420 / 850;
        if (feature != "") {
            if (is_struct(feature)) {
                feature.draw_planet_features(344 + main_data_slate.width - 4, 165);
                if (feature.remove) {
                    feature = "";
                } else if (feature.destroy) {
                    feature = "";
                    instance_destroy();
                    pop_draw_return_values();
                    exit;
                }
            }
        } else if (garrison != "" && !population && garrison.planet == obj_controller.selecting_planet) {
            if (garrison.garrison_force) {
                draw_set_font(fnt_40k_14);

                garrison_data_slate.sub_title = $"Garrison Leader {garrison.garrison_leader.name_role()}";
                garrison_data_slate.body_text = garrison.garrison_report();

                garrison_data_slate.inside_method = function() {
                    garrison_data_slate.title = "Garrison Report";
                    draw_set_color(c_gray);
                    var xx = garrison_data_slate.XX;
                    var yy = garrison_data_slate.YY;
                    var cur_planet = obj_controller.selecting_planet;
                    var half_way = yy + garrison_data_slate.height / 2;
                    draw_set_halign(fa_left);
                    draw_line(xx + 10, half_way, garrison_data_slate.width - 10, half_way);
                    var defence_data = determine_pdf_defence(target.p_pdf[cur_planet], garrison, target.p_fortified[cur_planet]);
                    var defence_string = $"Planetary Defence : {defence_data[0]}";
                    draw_text(xx + 20, half_way, defence_string);
                    if (scr_hit(xx + 20, half_way + 10, xx + 20 + string_width(defence_string), half_way + 10 + 20)) {
                        tooltip_draw(defence_data[1], 400);
                    }

                    var _dispo_change = garrison.dispo_change;
                    if (_dispo_change > 55) {
                        draw_text(xx + 20, half_way + 30, $"Garrison Disposition Effect : Positive");
                    } else if (_dispo_change > 44 || _dispo_change == 0) {
                        draw_text(xx + 20, half_way + 30, $"Garrison Disposition Effect : Neutral");
                    } else {
                        draw_text(xx + 20, half_way + 30, $"Garrison Disposition Effect : Negative");
                    }
                };
                garrison_data_slate.draw(340 + main_data_slate.width, 160, 0.6, 0.6);
            }
        } else if (population) {
            garrison_data_slate.title = "Population Report";
            garrison_data_slate.inside_method = function() {
                p_data.draw_planet_population_controls();
            };
            garrison_data_slate.draw(344 + main_data_slate.width - 4, 160, 0.6, 0.6);
        }
        if (obj_controller.selecting_planet > 0) {
            main_data_slate.draw(344, 160, slate_draw_scale, slate_draw_scale + 0.1);
        }
        var current_button = "";
        var shutter_x = main_data_slate.XX - 165;
        var shutter_y = 296 + 165;
        if (!debug) {
            for (var i = 0; i < array_length(buttons); i++) {
                if (shutters[i].draw_shutter(shutter_x, shutter_y + (47 * i), buttons[i], 0.5, true)) {
                    current_button = buttons[i];
                }
            }
        }
        if (current_button != "") {
            if (array_contains(["Build", "Base", "Arsenal", "Gene-Vault"], current_button)) {
                var building = instance_create(x, y, obj_temp_build);
                building.target = target;
                building.planet = obj_controller.selecting_planet;
                building.lair = p_data.has_upgrade(eP_FEATURES.SECRET_BASE);
                if (p_data.has_upgrade(eP_FEATURES.ARSENAL)) {
                    building.arsenal = 1;
                }
                if (p_data.has_upgrade(eP_FEATURES.GENE_VAULT)) {
                    building.gene_vault = 1;
                }
                obj_controller.temp[104] = string(scr_master_loc());
                obj_controller.menu = 60;
                with (obj_star_select) {
                    instance_destroy();
                }
            } else if (current_button == "Raid" && instance_nearest(x, y, obj_p_fleet).acted <= 1) {
                // feather ignore once GM2064
                instance_create_layer(x, y, layer_get_all()[0], obj_drop_select, {p_target: target, planet_number: obj_controller.selecting_planet, sh_target: instance_nearest(x, y, obj_p_fleet), purge: 0});
            } else if (current_button == "Attack") {
                var _allow_attack = true;
                var _targ = !target.present_fleet[1] ? noone : instance_nearest(x, y, obj_p_fleet);
                if (instance_exists(_targ)) {
                    if (_targ.acted >= 2) {
                        _allow_attack = false;
                    }
                }
                if (_allow_attack) {
                    // feather ignore once GM2064
                    instance_create_layer(x, y, layer_get_all()[0], obj_drop_select, {p_target: target, planet_number: obj_controller.selecting_planet, attack: true, sh_target: _targ, purge: 0});
                }
            } else if (current_button == "Purge") {
                var _allow_attack = true;
                var _targ = !target.present_fleet[1] ? noone : instance_nearest(x, y, obj_p_fleet);
                if (instance_exists(_targ)) {
                    if (_targ.acted >= 2) {
                        _allow_attack = false;
                    }
                }
                if (_allow_attack) {
                    // feather ignore once GM2064
                    instance_create_layer(x, y, layer_get_all()[0], obj_drop_select, {p_target: target, planet_number: obj_controller.selecting_planet, sh_target: _targ, purge: 1});
                }
            } else if (current_button == "Bombard") {
                instance_create(x, y, obj_bomb_select);
                if (instance_exists(obj_bomb_select)) {
                    obj_bomb_select.p_target = target;
                    obj_bomb_select.sh_target = instance_nearest(x, y, obj_p_fleet);
                    obj_bomb_select.p_data = p_data;
                    if (instance_nearest(x, y, obj_p_fleet).acted > 0) {
                        with (obj_bomb_select) {
                            instance_destroy();
                        }
                    }
                }
            } else if (current_button == "+Recruiting") {
                if (obj_controller.recruiting_worlds_bought > 0 && p_data.current_owner <= 5 && !p_data.at_war()) {
                    if (!p_data.has_feature(eP_FEATURES.RECRUITING_WORLD)) {
                        if (obj_controller.faction_status[eFACTION.IMPERIUM] == "War") {
                            obj_controller.recruiting_worlds_bought -= 1;
                        }
                        array_push(target.p_feature[obj_controller.selecting_planet], new NewPlanetFeature(eP_FEATURES.RECRUITING_WORLD));

                        if (obj_controller.selecting_planet) {
                            obj_controller.recruiting_worlds += planet_numeral_name(obj_controller.selecting_planet, target);
                        }
                        if (obj_controller.recruiting_worlds_bought == 0) {
                            var _idx = array_get_index(buttons, "+Recruiting");
                            if (_idx > -1) {
                                array_delete(buttons, _idx, 1);
                            }
                        }
                        // popup?
                    }
                }
            } else if (current_button == "Cyclonic Torpedo") {
                scr_destroy_planet(2);
            }
        }
    }

    if (target != 0) {
        if ((player_fleet > 0) && (imperial_fleet + mechanicus_fleet + inquisitor_fleet + eldar_fleet + ork_fleet + tau_fleet + heretic_fleet > 0)) {
            draw_set_color(0);
            draw_set_alpha(0.75);
            draw_rectangle(37, 413, 270, 452, 0);
            draw_set_alpha(1);

            draw_set_halign(fa_left);

            draw_set_color(0);
            draw_set_font(fnt_40k_14b);
            draw_text(37, 413, "Select Fleet Combat");

            draw_set_color(CM_GREEN_COLOR);
            draw_set_font(fnt_40k_14b);
            draw_text(37.5, 413.5, "Select Fleet Combat");

            var x3 = 49, y3 = 441;

            for (var i = 1; i <= 7; i++) {
                if (en_fleet[i] > 0) {
                    scr_image("ui/force", en_fleet[i], x3 - 16, y3 - 16, 32, 32);
                    x3 += 64;
                }
            }
        }
    }

    pop_draw_return_values();
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
    instance_destroy();
}
