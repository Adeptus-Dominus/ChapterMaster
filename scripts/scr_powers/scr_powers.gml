#macro ARR_power_discipline_list ["default", "biomancy", "pyromancy","telekinesis","rune_magic"]

global.disciplines_data = json_to_gamemaker(working_directory + "\\data\\psychic_disciplines.json", json_parse);
global.powers_data = json_to_gamemaker(working_directory + "\\data\\psychic_powers.json", json_parse);

// TODO: refactor this, maybe into multiple functions;
// TODO: add proper support for power_modifiers;
// God help the next person who will read this function;
/// Function to get requested data from the powers_data structure
/// @param power_name - The name of the power (e.g., "Minor Smite")
/// @param data_name - The specific data attribute you want (e.g., "type", "range", "flavour_text")
/// @returns The requested data, or undefined if not found
function get_power_data(power_name, data_name) {
    // Check if the power exists in the global.powers_data
    if (struct_exists(global.powers_data, power_name)) {
        var _power_object = global.powers_data[$ power_name];
        // Check if the data exists for that power
        if (struct_exists(_power_object, data_name)) {
            var _data_content = _power_object[$ data_name];
            if (data_name == "flavour_text") {
                var _flavour_text = [];
                var _text_option_names = struct_get_names(_data_content);
                for (var i = 0; i < array_length(_text_option_names); i++) {
                    var _text_option_name = _text_option_names[i];
                    var _text_option = _data_content[$ _text_option_name];
                    if (struct_exists(_text_option, "conditions")) {
                        var _conditions_array = _text_option[$ "conditions"];
                        var _conditions_satisfied = true;
                        for (var p = 0; p < array_length(_conditions_array); p++) {
                            var _condition_struct = _conditions_array[p];
                            var _condition_type = _condition_struct[$ "type"];
                            var _condition_value = _condition_struct[$ "value"];
                            var _condition_satisfied = power_condition_check(_condition_type, _condition_value);
                            if (!_condition_satisfied) {
                                _conditions_satisfied = false;
                                break;
                            }
                        }
                        if (_conditions_satisfied) {
                            _flavour_text = array_concat(_flavour_text, _text_option[$ "text"]);
                        }
                    } else {
                        _flavour_text = array_concat(_flavour_text, _text_option[$ "text"]);
                    }
                }
                _flavour_text = array_random_element(_flavour_text);
                return _flavour_text;
            } else {
                return _data_content;
            }
        }
    }
    return;
}

function power_condition_check(condition, value) {
    try {
        switch(condition) {
            case "advantage":
                return scr_has_adv(value);
                break;
            case "disadvantage":
                return scr_has_disadv(value);
                break;
            case "enemy_type":
                return obj_ncombat.enemy == value;
                break;
            case "allies_more_than":
                return obj_ncombat.player_forces > value;
                break;
            default:
                show_debug_message($"Condition type was not found!");
                log_error("Condition type was not found!");
                return false;
                break;
        }
    } catch (_exception) {
        return false;
        handle_exception(_exception);
    }
}

/// @mixin
function player_select_powers() {
    if (race[100, 17] != 0) {
        var _powers = ARR_power_discipline_list;
        var _disp_index = array_get_index(_powers, discipline);
        if (_disp_index == -1) {
            discipline = _powers[0];
            _disp_index = 0;
        }

        draw_text_transformed(460, 665, "Psychic Discipline", 0.6, 0.6, 0);
        if (scr_hit(445, 665, 620, 690)) {
            tooltip = "Psychic Discipline";
            tooltip2 = "The Psychic Discipline that your psykers will use by default.";
        }

        var fug = string_delete(discipline, 2, string_length(discipline));
        var fug2 = string_delete(discipline, 1, 1);
        draw_text_transformed(513, 697, string_hash_to_newline(string_upper(fug) + string(fug2)), 0.5, 0.5, 0);

        var psy_info = "";
        if (discipline == "default") {
            psy_info = "-Psychic Blasts and Barriers";
        }
        if (discipline == "biomancy") {
            psy_info = "-Manipulates Biology to Buff or Heal";
        }
        if (discipline == "pyromancy") {
            psy_info = "-Unleashes Blasts and Walls of Flame";
        }
        if (discipline == "telekinesis") {
            psy_info = "-Manipulates Gravity to Throw or Shield";
        }
        if (discipline == "rune_magic") {
            psy_info = "-Summons Deadly Elements and Feral Spirits";
        }
        draw_text_transformed(533, 729, string_hash_to_newline(string(psy_info)), 0.5, 0.5, 0);

        if (custom < 2) {
            draw_set_alpha(0.5);
        }
        if (custom == 2) {
            draw_sprite_stretched(spr_creation_arrow, 0, 437, 688, 32, 32);
        }
        if (custom == 2) {
            draw_sprite_stretched(spr_creation_arrow, 1, 475, 688, 32, 32);
        }
        draw_set_alpha(1);
        if ((mouse_left >= 1) && (cooldown <= 0) && (custom > 1)) {
            if (scr_hit(437, 688, 437 + 32, 688 + 32)) {
                _disp_index = _disp_index == 0 ? array_length(_powers) - 1 : _disp_index - 1;
            } else if (scr_hit(475, 688, 475 + 32, 688 + 32)) {
                _disp_index = _disp_index >= array_length(_powers) - 1 ? 0 : _disp_index + 1;
            }
        }
        discipline = _powers[_disp_index];
    }
}

/// @mixin
function scr_powers(power_set, power_index, target_unit, unit_id) {
    // power_set: letter
    // power_index: number
    // target_unit: target
    // unit_id: marine_id

    // This is a stand-alone script that determines powers based on the POWERS variable,
    // executes them, and applies the effect and flavor.  All in one.  Because I eventually
    // got better at this sort of thing.

    // This is called in context of a obj_pnunit

    var unit = unit_struct[unit_id];
    if (!is_struct(unit)) {
        exit;
    }
    if (unit.name() == "") {
        exit;
    }

    var power_name = "";
    var target_type = "";
    var weapon_one = unit.get_weapon_one_data();
    var weapon_two = unit.get_weapon_two_data();
    var gear = unit.gear();
    // show_debug_message(power_set);
    var psy_discipline = convert_power_letter(power_set);
    var flavour_text1 = "";
    var flavour_text3 = "";
    var flavour_text_4 = "";
    var binders_adv = scr_has_adv("Daemon Binders");
    var has_hood = gear == "Psychic Hood";
    var using_tome = false;
    var tome_discipline = "";
    var tome_roll = irandom_range(1, 100);
    var tome_perils_chance = 0;
    var tome_perils_strength = 0;
    var tome_slot = 0;
    var tome_tags = "";

    //TODO: Maybe move into a separate function;
    // In here check if have tome
    if (unit.weapon_one() == "Tome" || unit.weapon_two() == "Tome") {
        if (unit.weapon_one() == "Tome") {
            tome_tags += marine_wep1[unit_id];
        }
        if (unit.weapon_two() == "Tome") {
            tome_tags += marine_wep2[unit_id];
        }

        tome_discipline = get_tome_discipline(tome_tags);
    }

    //TODO: Move into a separate function;
    var selected_discipline = psy_discipline;
    if (tome_discipline != "" && tome_roll <= 50) {
        selected_discipline = tome_discipline;
        using_tome = true;
    }

    //TODO: Move into a separate function;
    var disciplines_array = struct_get_names(global.disciplines_data);
    for (var i = 0; i < array_length(disciplines_array); i++) {
        if (disciplines_array[i] == selected_discipline) {
            var powers_array = global.disciplines_data[$ disciplines_array[i]].powers;
            if (using_tome) {
                power_index = irandom(array_length(powers_array));
                tome_perils_chance = global.disciplines_data[$ disciplines_array[i]].perils_chance;
                tome_perils_strength = global.disciplines_data[$ disciplines_array[i]].perils_strength;
            }
            // show_debug_message($"powers_array: {powers_array}");
            // show_debug_message($"power_index: {power_index}");
            power_name = powers_array[power_index];
        }
    }

    // Change cases here
    if (power_name == "Machine Curse") {
        with (obj_enunit) {
            if (veh > 0) {
                instance_create(x, y, obj_temp3);
            }
        }
        if (instance_number(obj_temp3) == 0) {
            power_name = "Smite";
        }
        if (obj_ncombat.enemy == 9) {
            power_name = "Smite";
        }
        with (obj_temp3) {
            instance_destroy();
        }
    }

    // show_message(string(power_name));
    //

    // Chaos powers here

    var p_type = get_power_data(power_name, "type");
    var p_rang = get_power_data(power_name, "range");
    var p_tar = get_power_data(power_name, "target_type");
    var p_spli = get_power_data(power_name, "max_kills");
    var p_att = get_power_data(power_name, "power");
    var p_arp = get_power_data(power_name, "armor_piercing");
    var p_duration = get_power_data(power_name, "duration");
    var p_flavour_text = get_power_data(power_name, "flavour_text");
    var p_sorcery = get_power_data(power_name, "sorcery");

    //TODO: this should be refactored;
    if (p_sorcery != undefined && p_sorcery > 0) {
        if ((obj_ncombat.sorcery_seen < 2) && (obj_ncombat.present_inquisitor == 1)) {
            obj_ncombat.sorcery_seen = 1;
        }
    }
    
    if ((power_name == "Kamehameha") && (obj_ncombat.big_boom == 3)) {
        power_name = "Imperator Maior";
    }

    // if (power_name="Vortex of Doom"){p_type="attack";p_rang=5;p_tar=3;p_spli=1;p_att=800;p_arp=800;p_duration=0;
    //     p_flavour_text="- a hole between real and warp space is torn open with deadly effect.  ";
    // }

    //TODO: Move into a separate function;
    var has_force_weapon = false;
    if (is_struct(weapon_one)) {
        if (weapon_one.has_tag("force")) {
            has_force_weapon = true;
        }
    }
    if (is_struct(weapon_two)) {
        if (weapon_two.has_tag("force")) {
            has_force_weapon = true;
        }
    }


    if (has_force_weapon) {
        if (unit.weapon_one() == "Force Staff" || unit.weapon_two() == "Force Staff") {
            if (p_att > 0) {
                p_att = round(p_att) * 2;
            }
            if (p_rang > 0) {
                p_rang = round(p_rang) * 1.5;
            }
        } else {
            if (p_att > 0) {
                p_att = round(p_att) * 1.25;
            }
            if (p_rang > 0) {
                p_rang = round(p_rang) * 1.25;
            }
        }
    }

    if ((binders_adv == true) && (p_type == "attack")) {
        if (p_att > 0) {
            p_att = round(p_att) * 1.15;
        }
        // if (p_arp>0) then p_arp=round(p_arp)*1.15;
        if (p_rang > 0) {
            p_rang = round(p_rang) * 1.2;
        }
    }

    if (marine_type[unit_id] == "Chapter Master") {
        if (unit.has_trait("paragon")) {
            if (p_att > 0) {
                p_att = round(p_att) * 1.25;
            }
            // if (p_arp>0) then p_arp=round(p_arp)*1.25;
            if (p_rang > 0) {
                p_rang = round(p_rang) * 1.25;
            }
        }
    }

    flavour_text1 = $"{unit.name_role()} casts '{power_name}'";
    if ((tome_discipline != "") && (tome_roll <= 33) && (power_name != "Imperator Maior") && (power_name != "Kamehameha")) {
        flavour_text1 = unit.name_role();
        if (string_char_at(flavour_text1, string_length(flavour_text1)) == "s") {
            flavour_text1 += "' tome ";
        }
        if (string_char_at(flavour_text1, string_length(flavour_text1)) != "s") {
            flavour_text1 += "'s tome ";
        }
        flavour_text1 += "confers knowledge upon him.  He casts '" + string(power_name) + "'";

        if (tome_perils_chance > 0) {
            if ((tome_roll <= 10) && (tome_perils_chance == 1)) {
                unit.corruption += choose(1, 2);
            }
            if ((tome_roll <= 20) && (tome_perils_chance > 1)) {
                unit.corruption += choose(3, 4, 5);
            }
        }
    }

    if (power_name == "Kamehameha") {
        flavour_text1 = unit.name_role() + " ";
    }
    if (power_name == "Imperator Maior") {
        flavour_text1 = unit.name_role() + " casts '" + string(power_name) + "'";
    }

    //TODO: Perhaps separate perils calculations into a separate function;
    var good = 0, good2 = 0, perils_chance = 1, perils_roll = irandom_range(1, 100), perils_strength = irandom_range(1, 100);

    perils_strength += tome_perils_strength;
    if (scr_has_disadv("Warp Touched")) {
        perils_chance += 0.25;
        perils_strength += 25;
    }
    if (scr_has_disadv("Shitty Luck")) {
        perils_chance += 0.25;
        perils_strength += 25;
    }
    perils_strength -= marine_exp[unit_id] * 0.25;

    perils_chance += tome_perils_chance;
    perils_chance += obj_ncombat.global_perils;
    perils_chance -= marine_exp[unit_id] * 0.002;

    if (binders_adv) {
        // I hope you like demons
        perils_chance -= 0.5;
        perils_strength += 40;
        if (perils_strength <= 47) {
            perils_strength = 48;
        }
    }

    if (has_hood) {
        perils_chance *= 0.75;
        perils_strength *= 0.75;
    }

    perils_strength = max(perils_strength, 15);
    perils_chance = max(perils_chance, 0.05);

    // show_debug_message("Peril of the Warp Chance: " + string(perils_chance));
    // show_debug_message("Roll: " + string(perils_roll));
    // show_debug_message("Peril of the Warp Strength: " + string(perils_strength));

    if (perils_roll <= perils_chance) {
        if (obj_ncombat.sorcery_seen == 1) {
            obj_ncombat.sorcery_seen = 0;
        }
        p_type = "perils";
        flavour_text3 = "";

        flavour_text1 = $"{unit.name_role()} suffers Perils of the Warp!  ";
        p_flavour_text = scr_perils_table(perils_strength, unit, psy_discipline, power_name, unit_id, tome_discipline);

        if (unit.hp() < 0) {
            //TODO create is_dead function to remove repeats of this log
            if (marine_dead[unit_id] == 0) {
                marine_dead[unit_id] = 1;
                obj_ncombat.player_forces -= 1;
            }

            // Track the lost unit
            var existing_index = array_get_index(lost, marine_type[unit_id]);
            if (existing_index != -1) {
                lost_num[existing_index] += 1;
            } else {
                array_push(lost, marine_type[unit_id]);
                array_push(lost_num, 1);
            }

            // Update unit counts
            var armour_data = unit.get_armour_data();
            var is_dread = false;
            if (is_struct(armour_data)) {
                is_dread = armour_data.has_tag("dreadnought");
            }
            if (is_dread) {
                dreads -= 1;
            } else {
                men -= 1;
            }

            // Trigger red thirst
            if (obj_ncombat.red_thirst == 1 && marine_type[unit_id] != "Death Company") {
                obj_ncombat.red_thirst = 2;
            }
        }

        obj_ncombat.messages += 1;
        obj_ncombat.message[obj_ncombat.messages] = flavour_text1 + p_flavour_text + flavour_text3;
        // if (target_unit.dudes_vehicle[targeh]=1) then obj_ncombat.message_sz[obj_ncombat.messages]=(casualties*10)+(0.5-(obj_ncombat.messages/100));
        obj_ncombat.message_sz[obj_ncombat.messages] = 999 + (0.5 - (obj_ncombat.messages / 100));
        obj_ncombat.message_priority[obj_ncombat.messages] = 0;
    }

    if (obj_ncombat.sorcery_seen == 1) {
        obj_ncombat.sorcery_seen = 2;
    }

    // determine target here

    if ((p_type == "buff") || (power_name == "Kamehameha")) {
        var marine_index;
        var _random_marine_list = [];
        for (var i = 0; i < array_length(unit_struct); i++) {
            array_push(_random_marine_list, i);
        }
        _random_marine_list = array_shuffle(_random_marine_list);

        if ((power_name == "Force Dome") || (power_name == "Stormbringer")) {
            var buf = 9;
            for (var i = 0; i < array_length(_random_marine_list); i++) {
                if (buf <= 0) {
                    break;
                }
                marine_index = _random_marine_list[i];
                if ((!marine_dead[marine_index]) && (!marine_mshield[marine_index])) {
                    buf -= 1;
                    marine_mshield[marine_index] = 2;
                }
            }
        }

        if (power_name == "Quickening") {
            if (marine_quick[unit_id] < 3) {
                marine_quick[unit_id] = 3;
            }
        }
        if (power_name == "Might of the Ancients") {
            if (marine_might[unit_id] < 3) {
                marine_might[unit_id] = 3;
            }
        }

        if (power_name == "Fiery Form") {
            if (marine_fiery[unit_id] < 3) {
                marine_fiery[unit_id] = 3;
            }
        }
        if (power_name == "Fire Shield") {
            var buf = 9;
            for (var i = 0; i < array_length(_random_marine_list); i++) {
                if (buf <= 0) {
                    break;
                }
                marine_index = _random_marine_list[i];
                if ((!marine_dead[marine_index]) && (!marine_fshield[marine_index])) {
                    buf -= 1;
                    marine_fshield[marine_index] = 2;
                }
            }
        }

        if (power_name == "Iron Arm") {
            marine_iron[unit_id] += 1;
        }
        if (power_name == "Endurance") {
            var buf = 5;
            h = 0;
            for (var i = 0; i < array_length(_random_marine_list); i++) {
                if (buf <= 0) {
                    break;
                }
                marine_index = _random_marine_list[i];
                if (!marine_dead[marine_index]) {
                    var _buff_unit = unit_struct[marine_index];
                    if (_buff_unit.hp() < _buff_unit.max_health()) {
                        buf -= 1;
                        _buff_unit.add_or_sub_health(20);
                    }
                }
            }
        }
        if (power_name == "Hysterical Frenzy") {
            var buf = 5;
            h = 0;
            for (var i = 0; i < array_length(_random_marine_list); i++) {
                if (buf <= 0) {
                    break;
                }
                marine_index = _random_marine_list[i];
                if ((!marine_dead[marine_index]) && (marine_attack[marine_index] < 2.5)) {
                    buf -= 1;
                    marine_attack[marine_index] += 1.5;
                    marine_defense[marine_index] -= 0.15;
                }
            }
        }
        if (power_name == "Regenerate") {
            unit.add_or_sub_health(choose(2, 3, 4) * 5);
            if (unit.hp() > unit.max_health()) {
                unit.update_health(unit.max_health());
            }
        }

        if (power_name == "Telekinetic Dome") {
            if (marine_dome[unit_id] < 3) {
                marine_dome[unit_id] = 3;
            }
        }
        if (power_name == "Spatial Distortion") {
            if (marine_spatial[unit_id] < 3) {
                marine_spatial[unit_id] = 3;
            }
        }

        /*obj_ncombat.newline=string(flavour_text1)+string(p_flavour_text)+string(flavour_text3);
					obj_ncombat.newline_color="blue";
					with(obj_ncombat){scr_newtext();}*/

        obj_ncombat.messages += 1;
        obj_ncombat.message[obj_ncombat.messages] = flavour_text1 + p_flavour_text + flavour_text3;
        // if (target_unit.dudes_vehicle[targeh]=1) then obj_ncombat.message_sz[obj_ncombat.messages]=(casualties*10)+(0.5-(obj_ncombat.messages/100));
        obj_ncombat.message_sz[obj_ncombat.messages] = 0.5 - (obj_ncombat.messages / 100);
        obj_ncombat.message_priority[obj_ncombat.messages] = 0;

        if (power_name == "Kamehameha") {
            obj_ncombat.message_priority[obj_ncombat.messages] = 135;
            obj_ncombat.message_sz[obj_ncombat.messages] = 300 - (obj_ncombat.messages / 100);
        }
        // obj_ncombat.alarm[3]=2;
    }

    var shot_web;
    shot_web = 1;
    if ((p_type == "attack") && (power_name == "Imperator Maior")) {
        shot_web = 3;
    }

    if (shot_web > 1) {
        obj_ncombat.messages += 1;
        obj_ncombat.message[obj_ncombat.messages] = flavour_text1 + p_flavour_text;
        obj_ncombat.message_priority[obj_ncombat.messages] = 136;
        obj_ncombat.message_sz[obj_ncombat.messages] = 2500;
    }

    flavour_text_4 = "";

    repeat (shot_web) {
        if (shot_web > 1) {
            flavour_text3 = "";
        }

        if (p_type == "attack") {
            if (good == 0) {
                repeat (10) {
                    if ((good2 == 0) && instance_exists(obj_enunit)) {
                        target_unit = instance_nearest(x, y, obj_enunit);
                        var s;
                        s = 0;

                        repeat (20) {
                            if (point_distance(x, y, target_unit.x, target_unit.y) < (p_rang * 10)) {
                                if ((p_tar == 3) && (good == 0)) {
                                    s += 1;
                                    if ((target_unit.dudes_hp[s] > 0) && (dudes_vehicle[s] == 0)) {
                                        good = s;
                                    }
                                }
                                if ((p_tar == 4) && (good == 0)) {
                                    s += 1;
                                    if ((target_unit.dudes_hp[s] > 0) && (dudes_vehicle[s] == 1)) {
                                        good = s;
                                    }
                                }
                            }
                        }
                        if (good == 0) {
                            instance_deactivate_object(target_unit);
                        }
                        if (good != 0) {
                            good2 = good;
                        }
                    }
                }

                var onk;
                onk = 0;
                if ((p_tar == 3) && (good == 0) && (good2 == 0) && (p_arp > 0) && (onk == 0)) {
                    p_tar = 4;
                    onk = 1;
                }
                if ((p_tar == 4) && (good == 0) && (good2 == 0) && (p_att > 0) && (onk == 0)) {
                    p_tar = 3;
                    onk = 1;
                }

                instance_activate_object(obj_enunit);

                repeat (10) {
                    if ((good2 == 0) && instance_exists(obj_enunit)) {
                        target_unit = instance_nearest(x, y, obj_enunit);
                        var s;
                        s = 0;

                        repeat (20) {
                            if (point_distance(x, y, target_unit.x, target_unit.y) < (p_rang * 10)) {
                                if ((p_tar == 3) && (good == 0)) {
                                    s += 1;
                                    if ((target_unit.dudes_hp[s] > 0) && (dudes_vehicle[s] == 0)) {
                                        good = s;
                                    }
                                }
                                if ((p_tar == 4) && (good == 0)) {
                                    s += 1;
                                    if ((target_unit.dudes_hp[s] > 0) && (dudes_vehicle[s] == 1)) {
                                        good = s;
                                    }
                                }
                            }
                        }
                        if (good == 0) {
                            instance_deactivate_object(target_unit);
                        }
                        if (good != 0) {
                            good2 = good;
                        }
                    }
                }

                instance_activate_object(obj_enunit);
            }

            // show_message(string(flavour_text1)+string(p_flavour_text)+"#"+string(target_unit));

            if (good2 > 0) {
                var damage_type, stap;
                damage_type = "att";
                stap = 0;

                damage_type = "att";
                if ((p_arp > 0) && (p_att >= 100)) {
                    damage_type = "arp";
                }

                // if (p_tar=3) then damage_type="att";
                // if (p_tar=4) then damage_type="arp";

                if ((damage_type == "att") && (stap == 0) && instance_exists(target_unit) && (target_unit.dudes_num[good2] > 0)) {
                    var a, b, c, eac;
                    eac = target_unit.dudes_ac[good2];
                    a = p_att; // Average damage

                    // b=a-target_unit.dudes_ac[good2];// Average after armour

                    if (target_unit.dudes_vehicle[good2] == 0) {
                        if (p_arp == 1) {
                            eac = 0;
                        }
                        if (p_arp == -1) {
                            eac = eac * 6;
                        }
                    }
                    if (target_unit.dudes_vehicle[good2] == 1) {
                        if (p_arp == -1) {
                            eac = a;
                        }
                        if (p_arp == 0) {
                            eac = eac * 6;
                        }
                        if (p_arp == -1) {
                            eac = a;
                        }
                    }
                    b = a - eac;
                    if (b <= 0) {
                        b = 0;
                    }

                    c = b * 1; // New damage

                    if (target_unit.dudes_hp[good2] == 0) {
                        show_message(power_name);
                        show_message("Getting a 0 health error for target " + string(target_unit) + ", dudes " + string(good2));
                        show_message("Dudes: " + string(target_unit.dudes[good2]) + ", Number: " + string(target_unit.dudes_num[good2]));
                        show_message("Damage: " + string(c));
                        show_message(string(target_unit.dudes_hp[good2]));
                    }

                    var casualties, ponies, onceh;
                    onceh = 0;
                    ponies = 0;
                    if (p_spli == 0) {
                        casualties = min(floor(c / target_unit.dudes_hp[good2]), 1);
                    }
                    if (p_spli != 0) {
                        casualties = floor(c / target_unit.dudes_hp[good2]);
                    }

                    ponies = target_unit.dudes_num[good2];
                    if ((target_unit.dudes_num[good2] == 1) && ((target_unit.dudes_hp[good2] - c) <= 0)) {
                        casualties = 1;
                    }

                    if (target_unit.dudes_num[good2] - casualties < 0) {
                        casualties = ponies;
                    }
                    if (casualties < 0) {
                        casualties = 0;
                    }

                    if ((target_unit.dudes_num[good2] == 1) && (c > 0)) {
                        target_unit.dudes_hp[good2] -= c;
                    } // Need special flavor here for just damaging

                    if (casualties > 1) {
                        flavour_text3 = string(casualties) + " " + string(target_unit.dudes[good2]) + " are killed.";
                    }
                    if (casualties == 1) {
                        flavour_text3 = "A " + string(target_unit.dudes[good2]) + " is killed.";
                    }
                    if (casualties == 0) {
                        flavour_text3 = "The " + string(target_unit.dudes[good2]) + " survives the attack.";
                    }

                    if (casualties > 0) {
                        var duhs;
                        duhs = target_unit.dudes[good2];
                        if ((obj_ncombat.battle_special == "WL10_reveal") || (obj_ncombat.battle_special == "WL10_later")) {
                            if (duhs == "Veteran Chaos Terminator") {
                                obj_ncombat.chaos_angry += casualties * 2;
                            }
                            if (duhs == "Veteran Chaos Chosen") {
                                obj_ncombat.chaos_angry += casualties;
                            }
                            if (duhs == "Greater Daemon of Slaanesh") {
                                obj_ncombat.chaos_angry += casualties * 5;
                            }
                            if (duhs == "Greater Daemon of Tzeentch") {
                                obj_ncombat.chaos_angry += casualties * 5;
                            }
                        }
                    }

                    obj_ncombat.messages += 1;
                    obj_ncombat.message[obj_ncombat.messages] = flavour_text1 + p_flavour_text + flavour_text3;
                    if (shot_web > 1) {
                        obj_ncombat.message[obj_ncombat.messages] = flavour_text3;
                    }

                    obj_ncombat.message_sz[obj_ncombat.messages] = casualties + 1;
                    // if (target_unit.dudes_vehicle[targeh]=1) then obj_ncombat.message_sz[obj_ncombat.messages]=(casualties*10)+(0.5-(obj_ncombat.messages/100));
                    // else{obj_ncombat.message_sz[obj_ncombat.messages]=(casualties)+(0.5-(obj_ncombat.messages/100));}
                    obj_ncombat.message_priority[obj_ncombat.messages] = 0;
                    if (shot_web > 1) {
                        obj_ncombat.message_priority[obj_ncombat.messages] = 135;
                        obj_ncombat.message_sz[obj_ncombat.messages] = 2000 + obj_ncombat.messages;
                    }

                    // obj_ncombat.alarm[3]=2;

                    if (casualties >= 1) {
                        target_unit.dudes_num[good2] -= casualties;
                        obj_ncombat.enemy_forces -= casualties;
                    }
                }

                if ((damage_type == "arp") && (stap == 0) && instance_exists(target_unit) && (target_unit.dudes_num[good2] > 0)) {
                    var a, b, c, eac;
                    eac = target_unit.dudes_ac[good2];
                    a = p_att; // Average damage
                    // b=a-target_unit.dudes_ac[good2];// Average after armour

                    if (target_unit.dudes_vehicle[good2] == 0) {
                        if (p_arp == 1) {
                            eac = 0;
                        }
                        if (p_arp == -1) {
                            eac = eac * 6;
                        }
                    }
                    if (target_unit.dudes_vehicle[good2] == 1) {
                        if (p_arp == -1) {
                            eac = a;
                        }
                        if (p_arp == 0) {
                            eac = eac * 6;
                        }
                        if (p_arp == -1) {
                            eac = a;
                        }
                    }
                    b = a - eac;
                    if (b <= 0) {
                        b = 0;
                    }

                    c = b * 1; // New damage

                    if (target_unit.dudes_hp[good2] == 0) {
                        show_message(power_name);
                        show_message("Getting a 0 health error for target " + string(target_unit) + ", dudes " + string(good2));
                        show_message("Dudes: " + string(target_unit.dudes[good2]) + ", Number: " + string(target_unit.dudes_num[good2]));
                        show_message("Damage: " + string(c));
                        show_message(string(target_unit.dudes_hp[good2]));
                    }

                    var casualties, ponies, onceh;
                    onceh = 0;
                    ponies = 0;
                    if (p_spli == 0) {
                        casualties = min(floor(c / target_unit.dudes_hp[good2]), 1);
                    }
                    if (p_spli != 0) {
                        casualties = floor(c / target_unit.dudes_hp[good2]);
                    }

                    ponies = target_unit.dudes_num[good2];
                    if ((target_unit.dudes_num[good2] == 1) && ((target_unit.dudes_hp[good2] - c) <= 0)) {
                        casualties = 1;
                    }

                    if (target_unit.dudes_num[good2] - casualties < 0) {
                        casualties = ponies;
                    }
                    if (casualties < 0) {
                        casualties = 0;
                    }

                    if ((target_unit.dudes_num[good2] == 1) && (c > 0)) {
                        target_unit.dudes_hp[good2] -= c;
                    } // Need special flavor here for just damaging

                    if (casualties > 1) {
                        flavour_text3 = string(casualties) + " " + string(target_unit.dudes[good2]) + " are destroyed.";
                    }
                    if (casualties == 1) {
                        flavour_text3 = "A " + string(target_unit.dudes[good2]) + " is destroyed.";
                    }
                    if (casualties == 0) {
                        flavour_text3 = "The " + string(target_unit.dudes[good2]) + " survives the attack.";
                    }

                    /*obj_ncombat.newline=string(flavour_text1)+string(p_flavour_text)+string(flavour_text3);
					obj_ncombat.newline_color="blue";
					with(obj_ncombat){scr_newtext();}*/

                    if (casualties > 0) {
                        var duhs;
                        duhs = target_unit.dudes[good2];
                        if ((obj_ncombat.battle_special == "WL10_reveal") || (obj_ncombat.battle_special == "WL10_later")) {
                            if (duhs == "Veteran Chaos Terminator") {
                                obj_ncombat.chaos_angry += casualties * 2;
                            }
                            if (duhs == "Veteran Chaos Chosen") {
                                obj_ncombat.chaos_angry += casualties;
                            }
                            if (duhs == "Greater Daemon of Slaanesh") {
                                obj_ncombat.chaos_angry += casualties * 5;
                            }
                            if (duhs == "Greater Daemon of Tzeentch") {
                                obj_ncombat.chaos_angry += casualties * 5;
                            }
                        }
                    }

                    obj_ncombat.messages += 1;
                    obj_ncombat.message[obj_ncombat.messages] = flavour_text1 + p_flavour_text + flavour_text3;
                    if (shot_web > 1) {
                        obj_ncombat.message[obj_ncombat.messages] = flavour_text3;
                    }

                    obj_ncombat.message_sz[obj_ncombat.messages] = casualties + 1;
                    // if (target_unit.dudes_vehicle[targeh]=1) then obj_ncombat.message_sz[obj_ncombat.messages]=(casualties*10)+(0.5-(obj_ncombat.messages/100));
                    // else{obj_ncombat.message_sz[obj_ncombat.messages]=(casualties)+(0.5-(obj_ncombat.messages/100));}
                    obj_ncombat.message_priority[obj_ncombat.messages] = 0;
                    if (shot_web > 1) {
                        obj_ncombat.message_priority[obj_ncombat.messages] = 135;
                        obj_ncombat.message_sz[obj_ncombat.messages] = 2000 + obj_ncombat.messages;
                    }
                    // obj_ncombat.alarm[3]=2;

                    if (casualties >= 1) {
                        target_unit.dudes_num[good2] -= casualties;
                        obj_ncombat.enemy_forces -= casualties;
                    }
                }

                if (stap == 0) {
                    with (target_unit) {
                        var j, good, open;
                        j = 0;
                        good = 0;
                        open = 0;
                        repeat (20) {
                            j += 1;
                            if (dudes_num[j] <= 0) {
                                dudes[j] = "";
                                dudes_special[j] = "";
                                dudes_num[j] = 0;
                                dudes_ac[j] = 0;
                                dudes_hp[j] = 0;
                                dudes_vehicle[j] = 0;
                                dudes_damage[j] = 0;
                            }
                            if ((dudes[j] == "") && (dudes[j + 1] != "")) {
                                dudes[j] = dudes[j + 1];
                                dudes_special[j] = dudes_special[j + 1];
                                dudes_num[j] = dudes_num[j + 1];
                                dudes_ac[j] = dudes_ac[j + 1];
                                dudes_hp[j] = dudes_hp[j + 1];
                                dudes_vehicle[j] = dudes_vehicle[j + 1];
                                dudes_damage[j] = dudes_damage[j + 1];

                                dudes[j + 1] = "";
                                dudes_special[j + 1] = "";
                                dudes_num[j + 1] = 0;
                                dudes_ac[j + 1] = 0;
                                dudes_hp[j + 1] = 0;
                                dudes_vehicle[j + 1] = 0;
                                dudes_damage[j + 1] = 0;
                            }
                        }
                        j = 0;
                    }
                }
                if ((target_unit.men + target_unit.veh + target_unit.medi == 0) && (target_unit.owner != 1)) {
                    with (target_unit) {
                        instance_destroy();
                    }
                }
            }
        }
    } // End repeat

    obj_ncombat.alarm[3] = 5;
}

function get_tome_discipline(tome_tags) {
    try {
        var discipline_names = struct_get_names(global.disciplines_data);
        for (var i = 0; i < array_length(discipline_names); i++) {
            var discipline_name = discipline_names[i];
            var discipline_struct = global.disciplines_data[$ discipline_name];
            if (struct_exists(discipline_struct, "tags")) {
                var discipline_tags = discipline_struct[$ "tags"];
                for (var p = 0; p < array_length(discipline_tags); p++) {
                    var discipline_tag = discipline_tags[p];
                    if (string_count(discipline_tag, tome_tags) > 0) {
                        return discipline_name;
                    }
                }
            }
        }
        log_error("no matching discipline was found.")
        return "";
    } catch (_exception) {
        return "";
        handle_exception(_exception);
    }
}

function convert_power_letter(power_code) {
    try {
        var power_letter = string_char_at(power_code, 1);
        var matched_discipline = "";
    
        var discipline_names = struct_get_names(global.disciplines_data);
        for (var i = 0; i < array_length(discipline_names); i++) {
            var discipline_name = discipline_names[i];
            var discipline_struct = global.disciplines_data[$ discipline_name];
            if (struct_exists(discipline_struct, "letter")) {
                var discipline_letter = discipline_struct[$ "letter"];
                if (power_letter == discipline_letter) {
                    matched_discipline = discipline_name;
                    return discipline_name;
                }
            }
        }
        log_error("no matching discipline was found.")
        return "";
    } catch (_exception) {
        return "";
        handle_exception(_exception);
    }
}
