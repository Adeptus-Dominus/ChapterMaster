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
        button1 = "";
        button2 = "";
        button3 = "";
        button4 = "";

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

                    // Keep the planet view open when interacting with the planetary-regions panel
                    // or the construction box beneath it (covers the whole right column region).
                    if (closes && (planet_region_count(target, obj_controller.selecting_planet) > 1)) {
                        var _rp_h = 30 + (planet_region_count(target, obj_controller.selecting_planet) * 46) + 12;
                        if (scr_hit(340 + main_data_slate.width, 160, 340 + main_data_slate.width + 300, 160 + _rp_h + 8 + 480)) {
                            closes = false;
                        }
                    }
                }
                var shutters = [
                    shutter_1,
                    shutter_2,
                    shutter_3,
                    shutter_4
                ];
                for (var i = 0; i < 4; i++) {
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
            var is_enemy = false;
            if ((obj_controller.faction_status[eFACTION.IMPERIUM] != "War" && p_data.current_owner > 5) || (obj_controller.faction_status[eFACTION.IMPERIUM] == "War" && p_data.at_war(0, 1, 1) && p_data.player_disposition <= 50)) {
                is_enemy = true;
            }

            if (p_data.planet > 0) {
                if (target.present_fleet[1] == 0) {
                    if (p_data.player_forces > 0) {
                        if (is_enemy) {
                            button1 = "Attack";
                            if (p_data.population || p_data.has_feature(eP_FEATURES.FUNGAL_BLOOM) || p_data.has_feature(eP_FEATURES.ORKSTRONGHOLD)) {
                                button2 = "Purge";
                            }
                        }
                    }
                }
                if (target.present_fleet[1] > 0) {
                    if (is_enemy) {
                        button1 = "Attack";
                        button2 = "Raid";
                        button3 = "Bombard";
                    } else {
                        button1 = "Attack";
                        // Raid while an enemy force is present, so invaders on an
                        // imperial or unowned world can be struck proactively. Purge
                        // used to overwrite Raid the moment the world had any
                        // population, which made a landed-but-not-yet-winning enemy
                        // unraidable. Purge returns once the world is clear of enemies.
                        if (p_data.xenos_and_heretics() > 0) {
                            button2 = "Raid";
                            // Dead worlds have no friendly population to shield, so
                            // orbital bombardment of the enemy force is offered here.
                            // Dead worlds never register as enemy-owned, so this else
                            // branch is the only one they reach and it never set
                            // Bombard, which is why it was missing on dead enemy worlds.
                            if (p_data.planet_type == "Dead") {
                                button3 = "Bombard";
                            }
                        } else if (p_data.population || p_data.has_feature(eP_FEATURES.FUNGAL_BLOOM) || p_data.has_feature(eP_FEATURES.ORKSTRONGHOLD)) {
                            // Population OR a leftover ork infestation feature makes the
                            // world purgeable: Cleanse by Fire scours a Fungal Bloom even
                            // on a depopulated world the Imperium has just reclaimed, so a
                            // cleared-but-still-blooming world is not left unpurgeable.
                            button2 = "Purge";
                        } else {
                            button2 = "Raid";
                        }
                    }

                    if (torpedo > 0) {
                        var pfleet = instance_nearest(x, y, obj_p_fleet);
                        if (instance_exists(pfleet) && (point_distance(pfleet.x, pfleet.y, target.x, target.y) <= 40) && (pfleet.action == "")) {
                            if ((pfleet.capital_number + pfleet.frigate_number > 0) && (button4 == "")) {
                                button4 = "Cyclonic Torpedo";
                            }
                        }
                    }
                }
            }
            var planet_upgrades = target.p_upgrades[obj_controller.selecting_planet];
            if (((p_data.planet_type == "Dead") || (array_length(p_data.upgrades) > 0)) && ((target.present_fleet[1] > 0) || (target.p_player[obj_controller.selecting_planet] > 0))) {
                if ((array_length(p_data.features) == 0) || (array_length(planet_upgrades) > 0)) {
                    chock = !p_data.xenos_and_heretics();
                    if (chock == 1) {
                        if (p_data.has_upgrade(eP_FEATURES.SECRET_BASE)) {
                            button1 = "Base";
                        } else if (p_data.has_upgrade(eP_FEATURES.ARSENAL)) {
                            button1 = "Arsenal";
                        } else if (p_data.has_upgrade(eP_FEATURES.GENE_VAULT)) {
                            button1 = "Gene-Vault";
                        } else if (array_length(p_data.upgrades) == 0) {
                            button1 = "Build";
                        }
                        if (array_contains(["Build", "Gene-Vault", "Arsenal", "Base"], button1)) {
                            button2 = "";
                            button3 = "";
                            button4 = "";
                            button5 = "";
                        }
                    }
                }
            }

            if (obj_controller.recruiting_worlds_bought > 0 && !p_data.at_war()) {
                if (!p_data.has_feature(eP_FEATURES.RECRUITING_WORLD) && p_data.planet_type != "Dead" && !target.space_hulk) {
                    button4 = "+Recruiting";
                }
            }
            if (target.space_hulk) {
                // Space hulks are RAID-only (plus orbital Bombard); you cannot mount a full
                // ground Attack on one, matching upstream. The fork draws button1..button4,
                // so set THOSE (the old `buttons` array here was dead code and let button1's
                // earlier "Attack" leak through).
                if (target.present_fleet[1] > 0) {
                    button1 = "Raid";
                    button2 = "Bombard";
                    button3 = "";
                    button4 = "";
                    button5 = "";
                } else {
                    button1 = "";
                    button2 = "";
                    button3 = "";
                    button4 = "";
                    button5 = "";
                }
            }
            buttons_selected = true;
        }

        // When a new multi-region planet is selected, default its right-column view to the
        // Planetary Regions panel: it pops up on click and stays until you click off (or until you
        // open Population/Garrison, which persist for that planet). Single-region planets keep their
        // existing default. Feature panels (from jump-to navigation) are left untouched.
        if (obj_controller.selecting_planet != region_view_planet) {
            region_view_planet = obj_controller.selecting_planet;
            // A new planet closes any open garrison drill-down from the previous one.
            region_force_open = false;
            region_force_view = -1;
            region_force_faction = -1;
            region_force_player = false;
            if ((obj_controller.selecting_planet > 0) && (planet_region_count(target, obj_controller.selecting_planet) > 1)) {
                population = false;
                garrison = "";
            }
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
                    var defence_data = determine_pdf_defence(target.p_pdf[cur_planet], garrison, target.p_fortified[cur_planet], 0, target.p_guardsmen[cur_planet]);
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
        } else if ((obj_controller.selecting_planet > 0) && (planet_region_count(target, obj_controller.selecting_planet) > 1)) {
            // Right column is otherwise idle: show the planetary-regions overlay (Sector Governor).
            // Click an outlying region to set the conquest focus; steers which region falls first
            // and which region an assault lands on. See draw_regions_panel in scr_region_functions.
            draw_regions_panel(target, obj_controller.selecting_planet, 340 + main_data_slate.width, 160);
            // Construction box directly beneath it: build holos for the focused region.
            var _rp_h = 30 + (planet_region_count(target, obj_controller.selecting_planet) * 46) + 12;
            draw_region_construction_panel(target, obj_controller.selecting_planet, 340 + main_data_slate.width, 160 + _rp_h + 8);
        }
        if (obj_controller.selecting_planet > 0) {
            main_data_slate.draw(344, 160, slate_draw_scale, slate_draw_scale + 0.1);
        }
        // Force drill-down panel (planet- or region-level): opened from the slate's "Imperial Forces"
        // line (view = -1) or a region row's "Forces" label (view = region index). Drawn far-right so
        // it clears both the slate and the regions/construction column; its close [x] dismisses it.
        if ((obj_controller.selecting_planet > 0) && region_force_open) {
            var _force_data;
            if (region_force_player && (region_force_view >= 0) && (region_force_view < planet_region_count(target, obj_controller.selecting_planet))) {
                _force_data = region_player_force_breakdown(target, obj_controller.selecting_planet, region_force_view);
            } else if (region_force_faction >= 0) {
                _force_data = planet_faction_force_breakdown(target, obj_controller.selecting_planet, region_force_faction);
            } else if ((region_force_view >= 0) && (region_force_view < planet_region_count(target, obj_controller.selecting_planet))) {
                _force_data = region_force_breakdown(target, obj_controller.selecting_planet, region_force_view);
            } else {
                _force_data = planet_force_breakdown(target, obj_controller.selecting_planet);
            }
            if (draw_force_panel(_force_data, 340 + main_data_slate.width + 308, 160)) {
                region_force_open = false;
                region_force_view = -1;
                region_force_player = false;
            }
        }
        // Deploy Guard auxilia: offer the 4th slot when guard-carrying ships orbit this world.
        if ((button4 == "") && (obj_controller.selecting_planet > 0) && (player_guardsmen_at(target.name) > 0)) {
            button4 = "Deploy Guard";
        }
        var current_button = "";
        var shutter_x = main_data_slate.XX - 165;
        var shutter_y = 296 + 165;
        if (!debug) {
            // Every planet action explains itself on hover (the shutter class has
            // always rendered tooltips; they were simply never set).
            shutter_1.tooltip = planet_action_tooltip(button1);
            shutter_2.tooltip = planet_action_tooltip(button2);
            shutter_3.tooltip = planet_action_tooltip(button3);
            shutter_4.tooltip = planet_action_tooltip(button4);
            if (shutter_1.draw_shutter(shutter_x, shutter_y, button1, 0.5, true)) {
                current_button = button1;
            }
            if (shutter_2.draw_shutter(shutter_x, shutter_y + 47, button2, 0.5, true)) {
                current_button = button2;
            }
            if (shutter_3.draw_shutter(shutter_x, shutter_y + (47 * 2), button3, 0.5, true)) {
                current_button = button3;
            }
            if (shutter_4.draw_shutter(shutter_x, shutter_y + (47 * 3), button4, 0.5, true)) {
                current_button = button4;
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
            } else if (current_button == "Raid") {
                // Per-ship gate, matching Attack: a raid deploys troops from ships just
                // like an assault, so it is allowed while any carrying ship at this star
                // still has support uses left this turn (SHIP_ASSAULTS_PER_TURN, i.e. 2),
                // or while local forces do. Replaces the old fleet-wide gate
                // (fleet.acted <= 1) that blocked the whole fleet after two raids
                // regardless of how many ships were involved.
                if (can_ground_deploy(target, obj_controller.selecting_planet)) {
                    // feather ignore once GM2064
                    instance_create_layer(x, y, layer_get_all()[0], obj_drop_select, {p_target: target, planet_number: obj_controller.selecting_planet, sh_target: instance_nearest(x, y, obj_p_fleet), purge: 0});
                } else {
                    // Blocked actions say why instead of silently doing nothing (players
                    // assumed the game broke when clicks had no effect).
                    scr_popup("Raid", "Every ship and local force at this world has already supported the maximum number of raids and assaults this turn.", "");
                }
            } else if (current_button == "Attack") {
                var _allow_attack = true;
                var _targ = !target.present_fleet[1] ? noone : instance_nearest(x, y, obj_p_fleet);
                // Ship assault economy: the old fleet-wide gate (acted >= 2) is
                // replaced for ground assaults. An attack is possible while any
                // carrying ship at this star still has support uses left this turn,
                // or while planetside forces do and can fight without ship support.
                // Local-only attacks (no fleet present) were previously ungated
                // entirely; they now respect the planet's local exhaustion. Raid,
                // Purge, and Bombard keep their fleet-level gates.
                var _ship_available = false;
                if (instance_exists(_targ)) {
                    var _gate_ships = get_player_ships(target.name);
                    for (var _gs = 0; _gs < array_length(_gate_ships); _gs++) {
                        if ((obj_ini.ship_carrying[_gate_ships[_gs]] > 0) && (ship_assaults_used(_gate_ships[_gs]) < ORBITAL_ASSAULTS_PER_TURN)) {
                            _ship_available = true;
                            break;
                        }
                    }
                }
                var _local_available = (p_data.player_forces > 0) && (local_assaults_used(target, obj_controller.selecting_planet) < GROUND_ASSAULTS_PER_TURN);
                if (!_ship_available && !_local_available) {
                    _allow_attack = false;
                    scr_popup("Ground Assault", "Your forces at this world have already supported the maximum number of ground assaults this turn.", "");
                }
                // Positional siege (gun-world): you cannot free-strike any region. Until a
                // force has landed you may only assault the safe landing zone; once landed you
                // may assault any region that BORDERS one you already hold (adjacency graph).
                var _og_focus = region_focus_get(target, obj_controller.selecting_planet);
                if (_allow_attack && !region_can_assault_index(target, obj_controller.selecting_planet, _og_focus)) {
                    _allow_attack = false;
                    var _og_front = region_ground_front(target, obj_controller.selecting_planet);
                    var _focus_r = region_get(target, obj_controller.selecting_planet, _og_focus);
                    if (_og_front < 0) {
                        var _safe_r = region_get(target, obj_controller.selecting_planet, planet_safe_landing_region(target, obj_controller.selecting_planet));
                        var _safe_nm = is_struct(_safe_r) ? _safe_r.name : "the outer approaches";
                        scr_popup("Orbital Gun Array", $"The capital's guns command the approaches. You must make planetfall at {_safe_nm} (the farthest zone) before you can push inland. Select that region, or bombard it to clear the way.", "");
                    } else if (is_struct(_focus_r) && (_focus_r.owner == eFACTION.PLAYER)) {
                        scr_popup("Ground Advance", "You already hold that region. Select an adjacent enemy region to push into.", "");
                    } else {
                        scr_popup("Ground Advance", "Your forces can only strike a region bordering one they already hold. Select a region adjacent to your front line.", "");
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
                    // Purges run on their OWN per-fleet budget (PURGES_PER_FLEET_TURN),
                    // independent of the assault economy. The old gate read the
                    // fleet-wide acted counter that every assault ticks, so two attacks
                    // anywhere locked the whole fleet out of purging: exactly when
                    // cleansing matters most.
                    var _pdone = variable_instance_exists(_targ, "purges_done") ? _targ.purges_done : 0;
                    if (_pdone >= PURGES_PER_FLEET_TURN) {
                        _allow_attack = false;
                        // Blocked actions say why instead of silently doing nothing.
                        scr_popup("Purge", $"This fleet has already conducted its {PURGES_PER_FLEET_TURN} purges this turn.", "");
                    }
                }
                if (_allow_attack) {
                    // feather ignore once GM2064
                    instance_create_layer(x, y, layer_get_all()[0], obj_drop_select, {p_target: target, planet_number: obj_controller.selecting_planet, sh_target: _targ, purge: 1});
                }
            } else if (current_button == "Bombard") {
                // Per-ship gate: orbital bombardment is one per ship per turn and
                // consumes that ship's whole support allowance, so it needs a ship at
                // this star that has done nothing else this turn. Replaces the old
                // fleet-wide gate (fleet.acted > 0) that let the whole fleet bombard
                // only once regardless of ship count.
                if (get_fresh_bombard_ship(target.name) == -1) {
                    // Blocked actions say why instead of a dead click.
                    scr_popup("Bombardment", "No ship in orbit is free to bombard this turn. Each ship can bombard once per turn, and a ship that has already raided or supported an assault cannot.", "");
                } else {
                    instance_create(x, y, obj_bomb_select);
                    if (instance_exists(obj_bomb_select)) {
                        obj_bomb_select.p_target = target;
                        obj_bomb_select.sh_target = instance_nearest(x, y, obj_p_fleet);
                        obj_bomb_select.p_data = p_data;
                    }
                }
            } else if (current_button == "Deploy Guard") {
                var _n = deploy_guardsmen(target.name, obj_controller.selecting_planet);
                scr_popup("Imperial Guard", "Deployed " + string(_n) + " Guard onto " + planet_numeral_name(obj_controller.selecting_planet, target) + ".", "");
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
                            if (button1 == "+Recruiting") {
                                button1 = "";
                            }
                            if (button2 == "+Recruiting") {
                                button2 = "";
                            }
                            if (button3 == "+Recruiting") {
                                button3 = "";
                            }
                            if (button4 == "+Recruiting") {
                                button4 = "";
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
