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
        // Hardening: never index formation_possible without checking it is non-empty and the
        // index is in range. A drifted or stale formation_current (e.g. across a load) would
        // otherwise crash the whole drop screen on draw.
        var _formation_str = "Formation: -";
        if (array_length(formation_possible) > 0) {
            formation_current = clamp(formation_current, 0, array_length(formation_possible) - 1);
            _formation_str = $"Formation: {obj_controller.bat_formation[formation_possible[formation_current]]}";
        }
        // Upstream renamed this button to btn_formation in obj_drop_select Create_0;
        // the old name here crashed the whole attack screen on draw.
        btn_formation.x1 = x2 - 40 - (string_width(_formation_str) + 4);
        btn_formation.y1 = y1 + 80;
        btn_formation.update({str1: _formation_str});
        btn_formation.draw();
        if (btn_formation.clicked()) {
            if (array_length(formation_possible) > 0) {
                formation_current++;
                if (formation_current >= array_length(formation_possible)) {
                    formation_current = 0;
                }
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
        // Local force exhaustion: planetside forces also support at most
        // SHIP_ASSAULTS_PER_TURN ground assaults per turn, closing the loop of
        // deploying troops to the surface and attacking endlessly for free. When
        // spent, the button locks red like an exhausted ship. Attacks only.
        var _locals_spent = (attack == 1) && (local_assaults_used(p_target, planet_number) >= SHIP_ASSAULTS_PER_TURN);
        if (_locals_spent) {
            if (_local_button.active) {
                _local_button.active = false;
                roster.update_roster();
            }
            _local_button.text_color = c_red;
            _local_button.button_color = c_red;
            _local_button.tooltip = "This planet's forces have already supported the maximum number of ground assaults this turn.";
        }
        _local_button.x1 = _buttons_x;
        _local_button.y1 = _buttons_y;
        _local_button.update();
        _local_button.draw();
        if (_local_button.clicked()) {
            if (_locals_spent) {
                _local_button.active = false;
            }
            roster.update_roster();
        }
    }

    _buttons_y += 30;

    // Ship assault economy: assault-exhausted ships are drawn locked and red (see
    // scr_roster). ToggleButton clicks and Select All still flip their active flag,
    // so force locked ships back off here before the selection is consumed.
    for (var _ls = 0; _ls < array_length(roster.ships); _ls++) {
        var _ls_btn = roster.ships[_ls];
        if (variable_struct_exists(_ls_btn, "assault_locked") && _ls_btn.assault_locked && _ls_btn.active) {
            _ls_btn.active = false;
            roster.ship_multi_selector.changed = true;
        }
    }

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
        // Ported from upstream: without this declaration, attacking a world with no
        // enemy forces left (race_quantity 0) skips the only assignment below and the
        // string_width read throws "not set before reading it".
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

        btn_target.x1 = x2 - 50 - (string_width(_target_str));
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

        // Target SECTOR selector: which planetary region the assault lands on. Cycles the planet's
        // conquest focus (shared with the system-view regions panel). Only on multi-region worlds.
        if (planet_region_count(p_target, planet_number) > 1) {
            var _seci = region_focus_get(p_target, planet_number);
            var _secr = region_get(p_target, planet_number, _seci);
            var _forti_n = ["None", "Sparse", "Light", "Moderate", "Heavy", "Major", "Extreme"];
            var _sector_str = $"Sector: {_secr.name} ({region_faction_name(_secr.owner)}, Fort {_forti_n[clamp(_secr.fortification, 0, 6)]}, Def {_secr.defences})";
            // Drawn directly (not via InteractiveButton, whose width-based text padding pushes a
            // wide label to the box bottom): a centred box with the text centred both ways inside it.
            // Click cycles the conquest focus (shared with the system-view regions panel).
            draw_set_font(fnt_40k_14);
            var _ssw = string_width(_sector_str);
            var _ssh = string_height(_sector_str);
            var _ssx1 = x3 - (_ssw / 2) - 8;
            var _ssy1 = y1 + 150;
            var _ssx2 = x3 + (_ssw / 2) + 8;
            var _ssy2 = _ssy1 + _ssh + 8;
            draw_set_color(CM_GREEN_COLOR);
            draw_rectangle(_ssx1, _ssy1, _ssx2, _ssy2, true);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(x3, (_ssy1 + _ssy2) / 2, _sector_str);
            draw_set_halign(fa_left);
            draw_set_valign(fa_top);
            if (scr_hit(_ssx1, _ssy1, _ssx2, _ssy2) && mouse_button_clicked()) {
                region_focus_set(p_target, planet_number, (_seci + 1) mod planet_region_count(p_target, planet_number));
            }
        }
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

    // Behead the Warboss (§16f): only in the raid screen, and only when this world actually has an Ork
    // Warboss present. A decapitation strike — kills the boss (a non-duel death), throwing the clans into a
    // succession scramble or civil war. Spends the fleet's action, like a raid.
    if ((purge == eDROP_TYPE.RAIDATTACK) && planet_feature_bool(p_target.p_feature[planet_number], eP_FEATURES.ORKWARBOSS)) {
        btn_behead.x1 = btn_back.x1;
        btn_behead.y1 = btn_back.y1 - 45;
        btn_behead.active = true;
        btn_behead.update();
        btn_behead.draw();
        if (btn_behead.clicked()) {
            if (sh_target != noone) { sh_target.acted += 1; }
            var _bh_res = ork_decapitation_strike(p_target, planet_number);
            scr_popup("Decapitation Strike", _bh_res.text, "waaagh");
            menu = 0;
            purge = 0;
            instance_destroy();
        }
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

            // Hardening: resolve the chosen formation through a single bounds-checked read so a
            // bad formation_current cannot crash the drop launch. Falls back to formation 0 when
            // no formations are available.
            var _chosen_form = 0;
            if (array_length(formation_possible) > 0) {
                _chosen_form = formation_possible[clamp(formation_current, 0, array_length(formation_possible) - 1)];
            }

            if (attack == 1) {
                obj_controller.last_attack_form = _chosen_form;
            }
            if (attack == 0) {
                obj_controller.last_raid_form = _chosen_form;
            }

            // The fleet action tick used to run AFTER instance_deactivate_all, writing
            // to a deactivated instance by id. Whether that write lands is
            // runtime-dependent, and the tester's repro (unlimited raids from a
            // stationary fleet, third raid never blocked) matches it silently failing
            // in the compiled build: acted never climbed, so the raid gate
            // (acted <= 1) always passed. Ticked before deactivation instead, with a
            // proof line for the session log.
            if (sh_target != noone) {
                sh_target.acted += 1;
                LOGGER.info($"DROP LAUNCH {((attack == 1) ? "attack" : "raid")}: fleet acted now {sh_target.acted}");
            }

            instance_deactivate_all(true);
            instance_activate_object(obj_controller);
            instance_activate_object(obj_ini);
            instance_activate_object(obj_drop_select);

            // Ship assault economy: each distinct ship contributing units to this
            // ground deployment spends one support use this turn (SHIP_ASSAULTS_PER_TURN
            // max). This now covers raids as well as attacks (both are RAIDATTACK drops
            // that land troops from ships), so a raid is gated per ship like an assault
            // rather than by the fleet-wide acted counter. fleet.acted above still ticks
            // for movement and the unconverted purge gate. Local planetside forces
            // (ship id -1) cost nothing here; they spend a local use just below.
            if (purge == eDROP_TYPE.RAIDATTACK) {
                var _spent_ships = [];
                var _local_participated = false;
                for (var _su = 0; _su < array_length(roster.selected_units); _su++) {
                    var _sel = roster.selected_units[_su];
                    var _sel_ship = is_struct(_sel) ? _sel.ship_location : obj_ini.veh_lid[_sel[0]][_sel[1]];
                    if (_sel_ship > -1) {
                        if (!array_contains(_spent_ships, _sel_ship)) {
                            array_push(_spent_ships, _sel_ship);
                            var _drop_kind = (attack == 1) ? "assault" : "raid";
                            ship_action_spend(_sel_ship, _drop_kind);
                            LOGGER.info($"{string_upper(_drop_kind)} SPEND ship {_sel_ship}: uses now {ship_action_used(_sel_ship, _drop_kind)}/{SHIP_ASSAULTS_PER_TURN}");
                        }
                    } else {
                        _local_participated = true;
                    }
                }
                // Planetside forces joining the assault spend one of the planet's
                // local support uses, so troops cannot be dropped onto the surface
                // and used for unlimited free attacks.
                if (_local_participated) {
                    local_assault_spend(p_target, planet_number);
                }
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
            obj_ncombat.formation_set = _chosen_form;
            obj_ncombat.defending = false;
            obj_ncombat.local_forces = roster.local_button.active;

            // (Imperial Guard assault bring-along disabled for now: the player-side
            //  battlefield unit needs real per-model data, so this is being rebuilt.
            //  Until then we do not touch the embarked Guard, so attacks cost nothing.)
            obj_ncombat.player_attack_guard = 0;

            // Note: the region the player is pushing into is derived by the conquest overlay
            // (region_assault_target / regions_sync), which handles per-region defence resistance
            // and consume-on-capture without touching the fragile combat core. The tactical
            // obj_ncombat fortification system assumes the PLAYER is the defender, so it is left
            // alone here; making the battle screen itself region-aware is the deferred Option B.

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
                necrons
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

            // Cleanse by Fire ALSO scours a Fungal Bloom if one has taken root here (§16h): the same
            // promethium that burns out heretics and xenos torches the Ork spore-bed — removes the bloom
            // feature and most of the greenskin horde. (Behead's old standalone "Cleanse" button was removed.)
            if ((purge == eDROP_TYPE.PURGEFIRE) && _p_data.has_feature(eP_FEATURES.FUNGAL_BLOOM)) {
                var _cleanse_res = ork_cleanse_bloom(p_target, planet_number);
                scr_popup("Cleanse by Fire", _cleanse_res.text, "");
            }

            // Bombardment grinds down the TARGETED sector's own defences (region-level), matching the
            // sector shown/selected on the bombard screen. Guarded so old saves / no-region worlds
            // are untouched.
            if ((purge == eDROP_TYPE.PURGEBOMBARD) && variable_instance_exists(p_target, "p_regions")) {
                var _bombsec = region_focus_get(p_target, planet_number);
                var _bombrgn = region_get(p_target, planet_number, _bombsec);
                _bombrgn.fortification = max(0, _bombrgn.fortification - 1);
                if (_bombrgn.defences > 0) {
                    _bombrgn.defences = max(0, _bombrgn.defences - 1);
                }
            }
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
        if (menu == 0) {
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
                    "Assassinate Governor ({0})"
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

                // Target SECTOR for the bombardment (the region whose defences it grinds down).
                if (planet_region_count(p_target, planet_number) > 1) {
                    var _bseci = region_focus_get(p_target, planet_number);
                    var _bsecr = region_get(p_target, planet_number, _bseci);
                    var _bforti_n = ["None", "Sparse", "Light", "Moderate", "Heavy", "Major", "Extreme"];
                    var _bsector_str = $"Sector: {_bsecr.name} ({region_faction_name(_bsecr.owner)}, Fort {_bforti_n[clamp(_bsecr.fortification, 0, 6)]}, Def {_bsecr.defences})";
                    // Drawn directly (centred both ways), below the purge option buttons.
                    draw_set_font(fnt_40k_14);
                    var _bcx = x2 + 230;
                    var _bsw = string_width(_bsector_str);
                    var _bsh = string_height(_bsector_str);
                    var _bsx1 = _bcx - (_bsw / 2) - 8;
                    var _bsy1 = y2 + 340;
                    var _bsx2 = _bcx + (_bsw / 2) + 8;
                    var _bsy2 = _bsy1 + _bsh + 8;
                    draw_set_color(CM_GREEN_COLOR);
                    draw_rectangle(_bsx1, _bsy1, _bsx2, _bsy2, true);
                    draw_set_halign(fa_center);
                    draw_set_valign(fa_middle);
                    draw_text(_bcx, (_bsy1 + _bsy2) / 2, _bsector_str);
                    draw_set_halign(fa_left);
                    draw_set_valign(fa_top);
                    if (scr_hit(_bsx1, _bsy1, _bsx2, _bsy2) && mouse_button_clicked()) {
                        region_focus_set(p_target, planet_number, (_bseci + 1) mod planet_region_count(p_target, planet_number));
                    }
                }

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
