enum eDROP_TYPE {
    RAIDATTACK = 0,
    PURGESELECT,
    PURGEBOMBARD,
    PURGEFIRE,
    PURGESELECTIVE,
    PURGEASSASSINATE,
}

/// @self Asset.GMObject.obj_drop_select
function drop_select_unit_selection() {
    w = 720;
    h = 580;
    // Center of the screen
    var _x_center = main_slate.XX;
    var _y_center = main_slate.YY;
    var x1 = _x_center;
    var y1 = _y_center;
    var x2 = x1 + w;
    var y2 = y1 + h;
    var x3 = (x1 + x2) / 2;

    if (purge == eDROP_TYPE.RAIDATTACK) {
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_left);
        draw_set_color(CM_GREEN_COLOR);
        var attack_type = attack ? "Attacking" : "Raiding";
        draw_text_transformed(x1 + 40, y1 + 38, $"{attack_type} ({planet_numeral_name(planet_number, p_target)} )", 0.6, 0.6, 0);
        var _offset = x1 + 40;
        draw_set_font(fnt_40k_14);
        for (var i = 0; i < array_length(roster.company_buttons); i++) {
            var _button = roster.company_buttons[i];
            _button.x1 = _offset;
            _button.y1 = y1 + 70;
            _button.update();
            _button.draw();
            if (_button.company_present) {
                if (_button.clicked()) {
                    roster.update_roster();
                }
            }
            _offset += _button.w + 8;
        }

        // Planet icon here
        // draw_rectangle(xx+1084,yy+215,xx+1142,yy+273,0);

        // Formation
        var _formation_str = $"Formation: {obj_controller.bat_formation[formation_possible[formation_current]]}";
        btn_formation.x1 = x2 - 50 - string_width(_formation_str);
        btn_formation.y1 = y1 + 80;
        btn_formation.button_color = CM_GREEN_COLOR;
        btn_formation.text_color = CM_GREEN_COLOR;
        btn_formation.update({str1: _formation_str});
        btn_formation.draw();
        if (btn_formation.clicked()) {
            formation_current++;
            if (formation_current >= array_length(formation_possible)) {
                formation_current = 0;
            }
        }

        // Ships Are Up, Fuck Me
        draw_set_color(CM_GREEN_COLOR);
        draw_text(x1 + 40, 273, "Available Forces:");
    }

    var _buttons_x = x1 + 40;
    var _buttons_y = 299;

    roster.select_all_ships.update({x1: x1 + 200, y1: 273});
    if (roster.select_all_ships.draw()) {
        roster.ship_multi_selector.select_all();
    }

    // Local force button;
    if (purge != eDROP_TYPE.PURGEBOMBARD) {
        var _local_button = roster.local_button;
        _local_button.x1 = _buttons_x;
        _local_button.y1 = _buttons_y;
        _local_button.update();
        _local_button.draw();
        if (_local_button.clicked()) {
            roster.update_roster();
        }
    }

    _buttons_y += 30;

    // Ship buttons;
    if (roster.ship_multi_selector.changed) {
        roster.update_roster();
    }
    roster.ship_multi_selector.update({x1: _buttons_x, y1: _buttons_y});
    roster.ship_multi_selector.draw();

    draw_set_font(fnt_40k_14);
    draw_set_color(CM_GREEN_COLOR);
    draw_set_alpha(1);
    draw_set_halign(fa_left);

    // Unit types buttons;
    var _squads_box = {
        header: "Selected Squads:",
        x1: x1 + 40,
        y1: y2 - 220,
    };
    draw_text(_squads_box.x1, _squads_box.y1, _squads_box.header);
    var _x_offset = 0;
    var _row = 0;
    var loop_cycle = array_length(roster.squad_buttons);
    if (array_length(roster.vehicle_buttons) > 0) {
        loop_cycle += array_length(roster.vehicle_buttons);
    }
    var _squad_length = array_length(roster.squad_buttons);
    var _button;
    for (var i = 0; i < loop_cycle; i++) {
        if (i < _squad_length) {
            _button = roster.squad_buttons[i];
        } else {
            _button = roster.vehicle_buttons[i - _squad_length];
        }

        if (_x_offset + _button.w > 590) {
            _row++;
            _x_offset = 0;
        }
        _button.x1 = _squads_box.x1 + _x_offset;
        _button.y1 = (_squads_box.y1 + string_height(_squads_box.header) + 10) + _row * 28;
        _button.update();
        _button.draw();

        if (_button.clicked()) {
            roster.update_roster();
        }

        _x_offset += _button.w + 10;
    }

    // Target
    var race_quantity = 0;
    if (purge == eDROP_TYPE.RAIDATTACK) {
        var target_race = "";
        var target_threat = "";
        var _target_str = "No Target";

        if (attacking >= 5 && attacking <= 13) {
            race_quantity = race_quantities[attacking - 4];
            target_race = races[attacking - 4];
        }

        if (race_quantity >= 1 && race_quantity <= 6) {
            target_threat = threat_levels[race_quantity];
        } else if (race_quantity >= 6) {
            target_threat = threat_levels[6];
        }

        if (race_quantity != 0) {
            _target_str = $"{target_race} ({target_threat})";
        }

        btn_target.x1 = x2 - 50 - string_width(_target_str);
        btn_target.y1 = btn_formation.y2 + 10;
        btn_target.button_color = CM_GREEN_COLOR;
        btn_target.text_color = CM_GREEN_COLOR;
        btn_target.update({str1: _target_str});
        btn_target.draw();
        btn_target.active = force_present[1] != 0;

        if (btn_target.clicked()) {
            var _current_i = 0;
            for (var i = 1; i <= 20; i++) {
                if (force_present[i] == attacking) {
                    _current_i = i;
                    break;
                }
            }
            for (var i = _current_i + 1; i <= 20; i++) {
                if (force_present[i] != 0) {
                    attacking = force_present[i];
                    break;
                }
            }
            if (attacking == force_present[_current_i]) {
                for (var i = 1; i <= 20; i++) {
                    if (force_present[i] != 0) {
                        attacking = force_present[i];
                        break;
                    }
                }
            }
        }

        draw_sprite(spr_faction_icons, attacking, x2 - 100, y1 + 20);
    }

    // Back / Purge buttons
    btn_back.x1 = x3 - 100;
    btn_back.y1 = y2 - 60;
    btn_back.update();
    btn_back.draw();
    if (btn_back.clicked()) {
        menu = 0;
        purge = 0;
        instance_destroy();
    }

    // Attack / Raid buttons
    btn_attack.x1 = btn_back.x1 + btn_attack.width + 10;
    btn_attack.y1 = btn_back.y1;
    if (purge == eDROP_TYPE.RAIDATTACK) {
        btn_attack.str1 = (attack) ? "ATTACK!" : "RAID!";
        btn_attack.active = roster.selected_count() > 0 && race_quantity > 0;
    } else if (purge > 1) {
        btn_attack.str1 = "PURGE";
        btn_attack.active = roster.selected_count() > 0;
    }
    btn_attack.update();
    btn_attack.draw();
    if (btn_attack.clicked()) {
        if (purge == 0) {
            combating = 1; // Start battle here

            if (attack == 1) {
                obj_controller.last_attack_form = formation_possible[formation_current];
            }
            if (attack == 0) {
                obj_controller.last_raid_form = formation_possible[formation_current];
            }

            instance_deactivate_all(true);
            instance_activate_object(obj_controller);
            instance_activate_object(obj_ini);
            instance_activate_object(obj_drop_select);

            // 135 ; temporary balancing
            if (sh_target != noone) {
                sh_target.acted += 1;
            }

            if ((attacking == 10) || (attacking == 11)) {
                remove_planet_problem(planet_number, "meeting", p_target);
                remove_planet_problem(planet_number, "meeting_trap", p_target);
            }

            instance_create(0, 0, obj_ncombat);
            obj_ncombat.battle_object = p_target;
            obj_ncombat.battle_loc = p_target.name;
            obj_ncombat.battle_id = planet_number;
            obj_ncombat.dropping = 1 - attack;
            obj_ncombat.attacking = attack;
            obj_ncombat.enemy = attacking;
            obj_ncombat.formation_set = formation_possible[formation_current];
            obj_ncombat.defending = false;
            obj_ncombat.local_forces = roster.local_button.active;

            var _planet = obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id];
            if (obj_ncombat.battle_object.space_hulk == 1) {
                obj_ncombat.battle_special = "space_hulk";
            }
            if ((planet_feature_bool(_planet, eP_FEATURES.WARLORD6) == 1) && (obj_ncombat.enemy == eFACTION.ELDAR) && (obj_controller.faction_defeated[6] == 0)) {
                obj_ncombat.leader = 1;
            }
            if ((obj_ncombat.enemy == eFACTION.ORK) && (obj_controller.faction_defeated[7] <= 0)) {
                if (planet_feature_bool(_planet, eP_FEATURES.ORKWARBOSS)) {
                    obj_ncombat.leader = 1;
                    obj_ncombat.Warlord = _planet[search_planet_features(_planet, eP_FEATURES.ORKWARBOSS)[0]];
                }
            }

            if ((obj_ncombat.enemy == eFACTION.TYRANIDS) && (obj_ncombat.battle_object.space_hulk == 0)) {
                if (has_problem_planet(planet_number, "tyranid_org", p_target)) {
                    obj_ncombat.battle_special = "tyranid_org";
                }
            }

            if (obj_ncombat.enemy == eFACTION.HERETICS) {
                if (planet_feature_bool(obj_ncombat.battle_object.p_feature[obj_ncombat.battle_id], eP_FEATURES.CHAOSWARBAND) == 1) {
                    obj_ncombat.battle_special = "ChaosWarband";
                    obj_ncombat.leader = 1;
                }
            }

            var _threats = [
                0,
                0,
                0,
                0,
                0,
                sisters,
                eldar,
                ork,
                tau,
                tyranids,
                traitors,
                chaos,
                demons,
                necrons,
            ];
            if (obj_ncombat.enemy >= eFACTION.ECCLESIARCHY && obj_ncombat.enemy <= eFACTION.NECRONS) {
                obj_ncombat.threat = _threats[obj_ncombat.enemy];
            }

            if (obj_ncombat.enemy == eFACTION.TAU) {
                var eth = scr_quest(4, "ethereal_capture", 8, 0);
                if ((eth > 0) && (obj_ncombat.battle_object.p_owner[obj_ncombat.battle_id] == eFACTION.TAU)) {
                    var rolli;
                    rolli = irandom_range(1, 100);
                    if ((obj_ncombat.threat == 6) && (rolli <= 80)) {
                        obj_ncombat.ethereal = 1;
                    }
                    if ((obj_ncombat.threat == 5) && (rolli <= 65)) {
                        obj_ncombat.ethereal = 1;
                    }
                    if ((obj_ncombat.threat == 4) && (rolli <= 50)) {
                        obj_ncombat.ethereal = 1;
                    }
                    if ((obj_ncombat.threat == 3) && (rolli <= 35)) {
                        obj_ncombat.ethereal = 1;
                    }
                }
            }

            if ((obj_ncombat.threat > 1) && (obj_ncombat.battle_special != "ChaosWarband") && (attack == 0)) {
                obj_ncombat.threat -= 1;
            }
            if (obj_ncombat.threat < 1) {
                obj_ncombat.threat = 1;
            }
            if ((obj_ncombat.enemy == eFACTION.CHAOS) && (obj_ncombat.battle_object.p_type[obj_ncombat.battle_id] == "Daemon")) {
                obj_ncombat.threat = 7;
            }

            var _battle_place = obj_ncombat.battle_object;
            var _battle_sub_loc = obj_ncombat.battle_id;
            var _chaos_lord_jump_possible = attacking == 0 || attacking == 10 || attacking == 11;
            var _no_know_chaos = _battle_place.p_traitors[_battle_sub_loc] == 0 && _battle_place.p_chaos[_battle_sub_loc] == 0;

            var _chaos_warlord_present = planet_feature_bool(_battle_place.p_feature[obj_ncombat.battle_id], eP_FEATURES.WARLORD10);

            var _chaos_popup_turn_reached = obj_controller.turn >= obj_controller.chaos_turn;

            var _chaos_unknown = (obj_controller.known[eFACTION.CHAOS] == 0) && (obj_controller.faction_gender[10] == 1);

            if (_chaos_lord_jump_possible && _no_know_chaos) {
                if (_chaos_popup_turn_reached && _chaos_warlord_present) {
                    if (_chaos_unknown) {
                        var pop;
                        pop = instance_create(0, 0, obj_popup);
                        pop.image = "chaos_symbol";
                        pop.title = "Concealed Heresy";
                        pop.text = $"Your astartes set out and begin to cleanse {planet_numeral_name(_battle_sub_loc, _battle_place)} of possible heresy.  The general populace appears to be devout in their faith, but a disturbing trend appears- the odd citizen cursing your forces, frothing at the mouth, and screaming out heresy most foul.  One week into the cleansing a large hostile force is detected approaching and encircling your forces.";
                        cancel_combat();
                        combating = 0;
                        instance_activate_all();
                        exit;
                    }
                    if (obj_controller.known[eFACTION.CHAOS] >= 2 && obj_controller.faction_gender[10] == 1) {
                        with (obj_drop_select) {
                            obj_ncombat.enemy = eFACTION.HERETICS;
                            obj_ncombat.threat = 0;
                            cancel_combat();
                            combating = 0;
                            instance_destroy();
                            instance_activate_all();
                            exit;
                        }
                    }
                }
            }

            scr_battle_allies();
            setup_battle_formations();
            roster.add_to_battle();
        } else if (purge > 1) {
            draw_set_alpha(0.2);
            draw_rectangle(954, 556, 1043, 579, 0);
            draw_set_alpha(1);
            var _purge_score = 0;
            if (purge == eDROP_TYPE.PURGEBOMBARD) {
                _purge_score = roster.purge_bombard_score();
            }

            if (purge >= eDROP_TYPE.PURGEFIRE) {
                _purge_score = roster.selected_count();
            }

            var _p_data = p_target.system_datas[planet_number];

            _p_data.refresh_data();

            _p_data.purge(purge, _purge_score);
        }
    }
}

function drop_select_draw() {
    with (obj_drop_select) {
        if (purge != eDROP_TYPE.PURGESELECT) {
            drop_select_unit_selection();
        }

        // Purge shit happens bellow;
        // God, save us;
        if (menu == eMENU.DEFAULT) {
            if (purge == 1) {} else if (purge >= 2) {
                draw_set_halign(fa_center);
                draw_set_font(fnt_40k_30b);

                // 2 is bombardment

                var x2 = 535;
                var y2 = 200;

                draw_set_halign(fa_left);
                draw_set_color(c_gray);
                var _purge_strings = [
                    "Bombard Purging {0}",
                    "Fire Cleansing {0}",
                    "Selective Purging {0}",
                    "Assassinate Governor ({0})",
                ];
                var _planet_string = planet_numeral_name(planet_number, p_target);
                draw_text_transformed(x2 + 14, y2 + 12, string(_purge_strings[purge - 2], _planet_string), 0.6, 0.6, 0);

                // Disposition here
                var pp = planet_number;

                var succession = has_problem_planet(pp, "succession", p_target);

                if (((p_target.dispo[pp] >= 0) && (p_target.p_owner[pp] <= eFACTION.ECCLESIARCHY) && (p_target.p_population[pp] > 0)) && (!succession)) {
                    var wack = 0;
                    draw_set_color(c_blue);
                    draw_rectangle(x2 + 12, y2 + 53, x2 + 12 + max(0, (min(100, p_target.dispo[pp]) * 4.37)), y2 + 71, 0);
                }
                draw_set_color(c_gray);
                draw_rectangle(x2 + 12, y2 + 53, x2 + 449, y2 + 71, 1);
                draw_set_color(c_white);

                draw_set_font(fnt_40k_14b);
                draw_set_halign(fa_center);
                if (!succession) {
                    if ((p_target.dispo[pp] >= 0) && (p_target.p_first[pp] <= eFACTION.ECCLESIARCHY) && (p_target.p_owner[pp] <= eFACTION.ECCLESIARCHY) && (p_target.p_population[pp] > 0)) {
                        draw_text(x2 + 231, y2 + 54, string_hash_to_newline("Disposition: " + string(min(100, p_target.dispo[pp])) + "/100"));
                    }
                    if ((p_target.dispo[pp] > -30) && (p_target.dispo[pp] < 0) && (p_target.p_owner[pp] <= eFACTION.ECCLESIARCHY) && (p_target.p_population[pp] > 0)) {
                        draw_text(x2 + 231, y2 + 54, string_hash_to_newline("Disposition: ???/100"));
                    }
                    if (((p_target.dispo[pp] >= 0) && (p_target.p_first[pp] <= eFACTION.ECCLESIARCHY) && (p_target.p_owner[pp] > eFACTION.ECCLESIARCHY)) || (p_target.p_population[pp] <= 0)) {
                        draw_text(x2 + 231, y2 + 54, string_hash_to_newline("-------------"));
                    }
                    if (p_target.dispo[pp] <= -3000) {
                        draw_text(x2 + 231, y2 + 54, "Chapter Rule");
                    }
                }
                if (succession == 1) {
                    draw_text(x2 + 231, y2 + 54, "War of Succession");
                }

                draw_set_color(c_gray);
                draw_set_font(fnt_40k_14);
                draw_set_halign(fa_left);

                // Planet icon here
                draw_rectangle(x2 + 459, y2 + 14, x2 + 516, y2 + 71, 0);

                draw_set_font(fnt_40k_14);
                draw_set_color(c_gray);
                draw_set_alpha(1);

                var smin, smax;
                var w;
                w = -1;
                smin = 0;
                smax = 0;

                //draw_text(x2 + 14, y2 + 352, string_hash_to_newline("Selection: " + string(smin) + "/" + string(smax)));
            }
        }
    }
}

/// @self Asset.GMObject.obj_drop_select
function collect_local_units() {
    //
    // I think this script is used to count local forces. l_ meaning local.
    //
    ship_use[500] = 0;
    ship_max[500] = l_size;
    purge_d = ship_max[500];

    if (purge == 1) {
        if (sh_target != noone) {
            max_ships = sh_target.capital_number + sh_target.frigate_number + sh_target.escort_number;

            if (sh_target.acted >= 1) {
                instance_destroy();
            }

            var tump;
            tump = 0;

            var i, q, b;
            i = -1;
            q = -1;
            b = -1;
            repeat (sh_target.capital_number) {
                b += 1;
                if (sh_target.capital[b] != "") {
                    i += 1;
                    ship[i] = sh_target.capital[i];

                    ship_use[i] = 0;
                    tump = sh_target.capital_num[i];
                    ship_max[i] = obj_ini.ship_carrying[tump];
                    ship_ide[i] = tump;

                    ship_size[i] = 3;

                    purge_a += 3;
                    purge_b += ship_max[i];
                    purge_c += ship_max[i];
                    purge_d += ship_max[i];
                }
            }
            q = -1;
            repeat (sh_target.frigate_number) {
                q += 1;
                if (sh_target.frigate[q] != "") {
                    i += 1;
                    ship[i] = sh_target.frigate[q];

                    ship_use[i] = 0;
                    tump = sh_target.frigate_num[q];
                    ship_max[i] = obj_ini.ship_carrying[tump];
                    ship_ide[i] = tump;

                    ship_size[i] = 2;

                    purge_a += 1;
                    purge_b += ship_max[i];
                    purge_c += ship_max[i];
                    purge_d += ship_max[i];
                }
            }
            q = -1;
            repeat (sh_target.escort_number) {
                q += 1;
                if ((sh_target.escort[q] != "") && (obj_ini.ship_carrying[sh_target.escort_num[q]] > 0)) {
                    i += 1;
                    ship[i] = sh_target.escort[q];

                    ship_use[i] = 0;
                    tump = sh_target.escort_num[q];
                    ship_max[i] = obj_ini.ship_carrying[tump];
                    ship_ide[i] = tump;

                    ship_size[i] = 1;

                    purge_b += ship_max[i];
                    purge_c += ship_max[i];
                    purge_d += ship_max[i];
                }
            }
        }

        if (p_target.p_player[planet_number] > 0) {
            max_ships += 1;
        }
        var pp = planet_number;
        purge_d = p_target.p_type[pp] != "Dead";

        if (has_problem_planet(pp, "succession", p_target)) {
            purge_d = 0;
        }

        if (p_target.dispo[pp] < -2000) {
            purge_d = 0;
        }

        if ((planet_feature_bool(p_target.p_feature[pp], eP_FEATURES.MONASTERY) == 1) && (obj_controller.homeworld_rule != 1)) {
            purge_d = 0;
        }

        if (p_target.p_type[pp] == "Dead") {
            purge_d = 0;
        }
    }
}
