// TODO: a bunch of stuff in this file and related to it uses strings, replace them with constants;

#macro ARR_power_discipline_list ["default", "biomancy", "pyromancy","telekinesis","rune_magic"]

global.disciplines_data = json_to_gamemaker(working_directory + "\\data\\psychic_disciplines.json", json_parse);
global.powers_data = json_to_gamemaker(working_directory + "\\data\\psychic_powers.json", json_parse);

// God help the next person who will read this function;
/// Function to get requested data from the powers_data structure
/// @param _power_name - The name of the power (e.g., "Minor Smite")
/// @param _data_name - The specific data attribute you want (e.g., "type", "range", "flavour_text")
/// @returns The requested data, or undefined if not found
function get_power_data(_power_name, _data_name) {
    // Check if the power exists in the global.powers_data
    if (struct_exists(global.powers_data, _power_name)) {
        var _power_object = global.powers_data[$ _power_name];
        // Check if the data exists for that power
        if (struct_exists(_power_object, _data_name)) {
            var _data_content = _power_object[$ _data_name];
            if (_data_name == "flavour_text") {
                return get_flavour_text(_data_content);
            } else if (_data_name == "power_modifiers") {
                return get_power_modifiers(_data_content);
            } else {
                return _data_content;
            }
        } else {
            log_error("Requested data was not found!");
        }
    } else {
        log_error("Requested power was not found!");
    }
    return;
}

// TODO: get_flavour_text and get_power_modifiers can probably be combined into one function, due to high level of code duplication;
/// Helper function that processes flavour text with conditions
/// @param _flavour_text_data - The flavour text data structure
/// @returns A randomly chosen flavour text that meets conditions
function get_flavour_text(_flavour_text_data) {
    var _flavour_text = [];
    var _text_option_names = struct_get_names(_flavour_text_data);
    
    for (var i = 0; i < array_length(_text_option_names); i++) {
        var _text_option_name = _text_option_names[i];
        var _text_option = _flavour_text_data[$ _text_option_name];
        
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
    
    return array_random_element(_flavour_text);
}

/// Helper function that calculates the total value of all applicable power modifiers
/// @param _modifiers_data - The power modifiers data structure
/// @returns The sum of all modifier values that meet their conditions
function get_power_modifiers(_modifiers_data) {
    var _total_modifier = 0;
    var _modifier_names = struct_get_names(_modifiers_data);
    
    for (var i = 0; i < array_length(_modifier_names); i++) {
        var _modifier_name = _modifier_names[i];
        var _modifier = _modifiers_data[$ _modifier_name];
        var _should_apply = true;
        
        if (struct_exists(_modifier, "conditions")) {
            var _conditions_array = _modifier[$ "conditions"];
            
            for (var p = 0; p < array_length(_conditions_array); p++) {
                var _condition_struct = _conditions_array[p];
                var _condition_type = _condition_struct[$ "type"];
                var _condition_value = _condition_struct[$ "value"];
                
                if (!power_condition_check(_condition_type, _condition_value)) {
                    _should_apply = false;
                    break;
                }
            }
        }
        
        if (_should_apply && struct_exists(_modifier, "value")) {
            _total_modifier += _modifier[$ "value"];
        }
    }
    
    return _total_modifier;
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
        handle_exception(_exception);
        return false;
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

        var discipline_first_letter = string_delete(discipline, 2, string_length(discipline));  
        var discipline_suffix = string_delete(discipline, 1, 1);  
        draw_text_transformed(513, 697, string_hash_to_newline(string_upper(discipline_first_letter) + string(discipline_suffix)), 0.5, 0.5, 0);  

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

function get_tome_discipline(_tome_tags) {
    try {
        var discipline_names = struct_get_names(global.disciplines_data);
        for (var i = 0; i < array_length(discipline_names); i++) {
            var discipline_name = discipline_names[i];
            var discipline_struct = global.disciplines_data[$ discipline_name];
            if (struct_exists(discipline_struct, "tags")) {
                var discipline_tags = discipline_struct[$ "tags"];
                for (var p = 0; p < array_length(discipline_tags); p++) {
                    var discipline_tag = discipline_tags[p];
                    if (string_count(discipline_tag, _tome_tags) > 0) {
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

function get_perils_chance(_unit, _tome_perils_chance) {
    var _perils_chance = 1;
    var _unit_exp = _unit.experience;
    var _unit_gear = _unit.gear();

    if (scr_has_disadv("Warp Touched")) {
        _perils_chance += 0.25;
    }
    if (scr_has_disadv("Shitty Luck")) {
        _perils_chance += 0.25;
    }

    _perils_chance += _tome_perils_chance;
    _perils_chance += obj_ncombat.global_perils;
    _perils_chance -= _unit_exp * 0.002;

    if (scr_has_adv("Daemon Binders")) {
        // I hope you like demons
        _perils_chance -= 0.5;
    }

    if (_unit_gear == "Psychic Hood") {
        _perils_chance *= 0.75;
    }

    _perils_chance = max(_perils_chance, 0.05);
    
    // show_debug_message("Peril of the Warp Chance: " + string(_perils_chance));
    return _perils_chance;
}

function get_perils_strength(_unit, _tome_perils_strength) {
    var _perils_strength = 1;
    var _unit_exp = _unit.experience;
    var _unit_gear = _unit.gear();

    _perils_strength += _tome_perils_strength;
    if (scr_has_disadv("Warp Touched")) {
        _perils_strength += 25;
    }
    if (scr_has_disadv("Shitty Luck")) {
        _perils_strength += 25;
    }
    _perils_strength -= _unit_exp * 0.25;


    if (scr_has_adv("Daemon Binders")) {
        // I hope you like demons
        _perils_strength += 40;
        if (_perils_strength <= 47) {
            _perils_strength = 48;
        }
    }

    if (_unit_gear == "Psychic Hood") {
        _perils_strength *= 0.75;
    }

    _perils_strength = max(_perils_strength, 15);
    
    // show_debug_message("Peril of the Warp Strength: " + string(perils_strength));
    return _perils_strength;
}

// TODO: All tome logic has to be reworked;
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

    var _unit = unit_struct[unit_id];
    if (!is_struct(_unit)) {
        exit;
    }
    if (_unit.name() == "") {
        exit;
    }

    var _power_name = "";
    var _unit_weapon_one_data = _unit.get_weapon_one_data();
    var _unit_weapon_two_data = _unit.get_weapon_two_data();
    var _unit_gear = _unit.gear();
    var _psy_discipline = convert_power_letter(power_set);
    var _cast_flavour_text = "";
    var _casualties_flavour_text = "";
    var _using_tome = false;
    var _tome_discipline = "";
    var _tome_roll = irandom_range(1, 100);
    var _tome_perils_chance = 0;
    var _tome_perils_strength = 0;
    var _unit_role = _unit.role();
    var _unit_exp = _unit.experience;
    var _battle_log_message = "";
    var _battle_log_priority = 0;

    //TODO: Maybe move into a separate function;
    // In here check if have tome
    if (_unit_weapon_one_data == "Tome" || _unit_weapon_two_data == "Tome") {
        var _tome_tags = "";
        if (_unit_weapon_one_data == "Tome") {
            _tome_tags += marine_wep1[unit_id];
        }
        if (_unit_weapon_two_data == "Tome") {
            _tome_tags += marine_wep2[unit_id];
        }
        _tome_discipline = get_tome_discipline(_tome_tags);
    }

    //TODO: Move into a separate function;
    var selected_discipline = _psy_discipline;
    if (_tome_discipline != "" && _tome_roll <= 50) {
        selected_discipline = _tome_discipline;
        _using_tome = true;
    }

    //TODO: Move into a separate function;
    var disciplines_array = struct_get_names(global.disciplines_data);
    for (var i = 0; i < array_length(disciplines_array); i++) {
        if (disciplines_array[i] == selected_discipline) {
            var powers_array = global.disciplines_data[$ disciplines_array[i]].powers;
            if (_using_tome) {
                power_index = irandom(array_length(powers_array));
                _tome_perils_chance = global.disciplines_data[$ disciplines_array[i]].perils_chance;
                _tome_perils_strength = global.disciplines_data[$ disciplines_array[i]].perils_strength;
            }
            // show_debug_message($"powers_array: {powers_array}");
            // show_debug_message($"power_index: {power_index}");
            _power_name = powers_array[power_index];
        }
    }

    // Change cases here
    if (_power_name == "Machine Curse") {
        with (obj_enunit) {
            if (veh > 0) {
                instance_create(x, y, obj_temp3);
            }
        }
        if (instance_number(obj_temp3) == 0) {
            _power_name = "Smite";
        }
        if (obj_ncombat.enemy == 9) {
            _power_name = "Smite";
        }
        with (obj_temp3) {
            instance_destroy();
        }
    }

    // show_message(string(_power_name));
    //

    // Chaos powers here

    var _power_type = get_power_data(_power_name, "type");
    var _power_range = get_power_data(_power_name, "range");
    var _power_target_type = get_power_data(_power_name, "target_type");
    var _power_max_kills = get_power_data(_power_name, "max_kills");
    var _power_magnitude = get_power_data(_power_name, "magnitude");
    var _power_armour_piercing = get_power_data(_power_name, "armour_piercing");
    var _power_duration = get_power_data(_power_name, "duration");
    var _power_flavour_text = get_power_data(_power_name, "flavour_text");
    var _power_sourcery = get_power_data(_power_name, "sorcery");

    //TODO: this should be refactored;
    if (_power_sourcery != undefined && _power_sourcery > 0) {
        if ((obj_ncombat.sorcery_seen < 2) && (obj_ncombat.present_inquisitor == 1)) {
            obj_ncombat.sorcery_seen = 1;
        }
    }
    
    if ((_power_name == "Kamehameha") && (obj_ncombat.big_boom == 3)) {
        _power_name = "Imperator Maior";
    }

    // if (_power_name="Vortex of Doom"){_power_type="attack";_power_range=5;_power_target_type=3;_power_max_kills=1;_power_magnitude=800;_power_armour_piercing=800;_power_duration=0;
    //     _power_flavour_text="- a hole between real and warp space is torn open with deadly effect.  ";
    // }

    //TODO: Move into a separate function;
    var has_force_weapon = false;
    if (is_struct(_unit_weapon_one_data)) {
        if (_unit_weapon_one_data.has_tag("force")) {
            has_force_weapon = true;
        }
    }
    if (is_struct(_unit_weapon_two_data)) {
        if (_unit_weapon_two_data.has_tag("force")) {
            has_force_weapon = true;
        }
    }


    if (has_force_weapon) {
        if (_unit_weapon_one_data == "Force Staff" || _unit_weapon_two_data == "Force Staff") {
            if (_power_magnitude > 0) {
                _power_magnitude = round(_power_magnitude) * 2;
            }
            if (_power_range > 0) {
                _power_range = round(_power_range) * 1.5;
            }
        } else {
            if (_power_magnitude > 0) {
                _power_magnitude = round(_power_magnitude) * 1.25;
            }
            if (_power_range > 0) {
                _power_range = round(_power_range) * 1.25;
            }
        }
    }

    if ((scr_has_adv("Daemon Binders")) && (_power_type == "attack")) {
        if (_power_magnitude > 0) {
            _power_magnitude = round(_power_magnitude) * 1.15;
        }
        // if (_power_armour_piercing>0) then _power_armour_piercing=round(_power_armour_piercing)*1.15;
        if (_power_range > 0) {
            _power_range = round(_power_range) * 1.2;
        }
    }

    if (_unit_role == "Chapter Master") {
        if (_unit.has_trait("paragon")) {
            if (_power_magnitude > 0) {
                _power_magnitude = round(_power_magnitude) * 1.25;
            }
            // if (_power_armour_piercing>0) then _power_armour_piercing=round(_power_armour_piercing)*1.25;
            if (_power_range > 0) {
                _power_range = round(_power_range) * 1.25;
            }
        }
    }

    // Some tome shit;
    _cast_flavour_text = $"{_unit.name_role()} casts '{_power_name}'";
    if ((_tome_discipline != "") && (_tome_roll <= 33) && (_power_name != "Imperator Maior") && (_power_name != "Kamehameha")) {
        _cast_flavour_text = _unit.name_role();
        if (string_char_at(_cast_flavour_text, string_length(_cast_flavour_text)) == "s") {
            _cast_flavour_text += "' tome ";
        }
        if (string_char_at(_cast_flavour_text, string_length(_cast_flavour_text)) != "s") {
            _cast_flavour_text += "'s tome ";
        }
        _cast_flavour_text += "confers knowledge upon him.  He casts '" + string(_power_name) + "'";

        if (_tome_perils_chance > 0) {
            if ((_tome_roll <= 10) && (_tome_perils_chance == 1)) {
                _unit.corruption += choose(1, 2);
            }
            if ((_tome_roll <= 20) && (_tome_perils_chance > 1)) {
                _unit.corruption += choose(3, 4, 5);
            }
        }
    }

    if (_power_name == "Kamehameha") {
        _cast_flavour_text = _unit.name_role() + " ";
    }
    if (_power_name == "Imperator Maior") {
        _cast_flavour_text = _unit.name_role() + " casts '" + string(_power_name) + "'";
    }

    //TODO: Perhaps separate perils calculations into a separate function;
    var perils_chance = get_perils_chance(_unit, _tome_perils_chance);
    var perils_roll = irandom_range(1, 100);
    var perils_strength = get_perils_strength(_unit, _tome_perils_strength);

    // show_debug_message("Roll: " + string(perils_roll));

    if (perils_roll <= perils_chance) {
        if (obj_ncombat.sorcery_seen == 1) {
            obj_ncombat.sorcery_seen = 0;
        }
        _power_type = "perils";

        _cast_flavour_text = $"{_unit.name_role()} suffers Perils of the Warp!  ";
        _power_flavour_text = scr_perils_table(perils_strength, _unit, _psy_discipline, _power_name, unit_id, _tome_discipline);

        if (_unit.hp() < 0) {
            //TODO create is_dead function to remove repeats of this log
            if (marine_dead[unit_id] == 0) {
                marine_dead[unit_id] = 1;
                obj_ncombat.player_forces -= 1;
            }

            // Track the lost unit
            var existing_index = array_get_index(lost, _unit_role);
            if (existing_index != -1) {
                lost_num[existing_index] += 1;
            } else {
                array_push(lost, _unit_role);
                array_push(lost_num, 1);
            }

            // Update unit counts
            var armour_data = _unit.get_armour_data();
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
            if (obj_ncombat.red_thirst == 1 && _unit_role != "Death Company") {
                obj_ncombat.red_thirst = 2;
            }
        }

        _battle_log_message = _cast_flavour_text + _power_flavour_text;
        add_battle_log_message(_battle_log_message, 999, 135);
    }

    if (obj_ncombat.sorcery_seen == 1) {
        obj_ncombat.sorcery_seen = 2;
    }

    // determine target here

    if ((_power_type == "buff") || (_power_name == "Kamehameha")) {
        var marine_index;
        var _random_marine_list = [];
        for (var i = 0; i < array_length(unit_struct); i++) {
            array_push(_random_marine_list, i);
        }
        _random_marine_list = array_shuffle(_random_marine_list);

        if ((_power_name == "Force Dome") || (_power_name == "Stormbringer")) {
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

        if (_power_name == "Quickening") {
            if (marine_quick[unit_id] < 3) {
                marine_quick[unit_id] = 3;
            }
        }
        if (_power_name == "Might of the Ancients") {
            if (marine_might[unit_id] < 3) {
                marine_might[unit_id] = 3;
            }
        }

        if (_power_name == "Fiery Form") {
            if (marine_fiery[unit_id] < 3) {
                marine_fiery[unit_id] = 3;
            }
        }
        if (_power_name == "Fire Shield") {
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

        if (_power_name == "Iron Arm") {
            marine_iron[unit_id] += 1;
        }
        if (_power_name == "Endurance") {
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
        if (_power_name == "Hysterical Frenzy") {
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
        if (_power_name == "Regenerate") {
            _unit.add_or_sub_health(choose(2, 3, 4) * 5);
            if (_unit.hp() > _unit.max_health()) {
                _unit.update_health(_unit.max_health());
            }
        }

        if (_power_name == "Telekinetic Dome") {
            if (marine_dome[unit_id] < 3) {
                marine_dome[unit_id] = 3;
            }
        }
        if (_power_name == "Spatial Distortion") {
            if (marine_spatial[unit_id] < 3) {
                marine_spatial[unit_id] = 3;
            }
        }

        _battle_log_message = _cast_flavour_text + _power_flavour_text;
        add_battle_log_message(_battle_log_message, 999, 135);
    }

    // TODO: separate the code bellow into a separate function;
    // Actually cast powers here;
    var good = 0;
    var good2 = 0;
    var _cast_count = 1;

    if ((_power_type == "attack") && (_power_name == "Imperator Maior")) {
        _cast_count = 3;
        _battle_log_message = _cast_flavour_text + _power_flavour_text;
        add_battle_log_message(_battle_log_message, 999, 135);
    }

    repeat (_cast_count) {
        if (_cast_count > 1) {
            _casualties_flavour_text = "";
        }

        if (_power_type == "attack") {
            if (good == 0) {
                repeat (10) {
                    if ((good2 == 0) && instance_exists(obj_enunit)) {
                        target_unit = instance_nearest(x, y, obj_enunit);
                        var s;
                        s = 0;

                        repeat (20) {
                            if (point_distance(x, y, target_unit.x, target_unit.y) < (_power_range * 10)) {
                                if ((_power_target_type == 3) && (good == 0)) {
                                    s += 1;
                                    if ((target_unit.dudes_hp[s] > 0) && (dudes_vehicle[s] == 0)) {
                                        good = s;
                                    }
                                }
                                if ((_power_target_type == 4) && (good == 0)) {
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
                if ((_power_target_type == 3) && (good == 0) && (good2 == 0) && (_power_armour_piercing > 0) && (onk == 0)) {
                    _power_target_type = 4;
                    onk = 1;
                }
                if ((_power_target_type == 4) && (good == 0) && (good2 == 0) && (_power_magnitude > 0) && (onk == 0)) {
                    _power_target_type = 3;
                    onk = 1;
                }

                instance_activate_object(obj_enunit);

                repeat (10) {
                    if ((good2 == 0) && instance_exists(obj_enunit)) {
                        target_unit = instance_nearest(x, y, obj_enunit);
                        var s;
                        s = 0;

                        repeat (20) {
                            if (point_distance(x, y, target_unit.x, target_unit.y) < (_power_range * 10)) {
                                if ((_power_target_type == 3) && (good == 0)) {
                                    s += 1;
                                    if ((target_unit.dudes_hp[s] > 0) && (dudes_vehicle[s] == 0)) {
                                        good = s;
                                    }
                                }
                                if ((_power_target_type == 4) && (good == 0)) {
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

            if (good2 > 0) {
                var damage_type, stap;
                damage_type = "att";
                stap = 0;

                damage_type = "att";
                if ((_power_armour_piercing > 0) && (_power_magnitude >= 100)) {
                    damage_type = "arp";
                }

                // if (_power_target_type=3) then damage_type="att";
                // if (_power_target_type=4) then damage_type="arp";

                if ((damage_type == "att") && (stap == 0) && instance_exists(target_unit) && (target_unit.dudes_num[good2] > 0)) {
                    var a, b, c, eac;
                    eac = target_unit.dudes_ac[good2];
                    a = _power_magnitude; // Average damage

                    // b=a-target_unit.dudes_ac[good2];// Average after armour

                    if (target_unit.dudes_vehicle[good2] == 0) {
                        if (_power_armour_piercing == 1) {
                            eac = 0;
                        }
                        if (_power_armour_piercing == -1) {
                            eac = eac * 6;
                        }
                    }
                    if (target_unit.dudes_vehicle[good2] == 1) {
                        if (_power_armour_piercing == -1) {
                            eac = a;
                        }
                        if (_power_armour_piercing == 0) {
                            eac = eac * 6;
                        }
                        if (_power_armour_piercing == -1) {
                            eac = a;
                        }
                    }
                    b = a - eac;
                    if (b <= 0) {
                        b = 0;
                    }

                    c = b * 1; // New damage

                    if (target_unit.dudes_hp[good2] == 0) {
                        show_message(_power_name);
                        show_message("Getting a 0 health error for target " + string(target_unit) + ", dudes " + string(good2));
                        show_message("Dudes: " + string(target_unit.dudes[good2]) + ", Number: " + string(target_unit.dudes_num[good2]));
                        show_message("Damage: " + string(c));
                        show_message(string(target_unit.dudes_hp[good2]));
                    }

                    var _casualties, ponies, onceh;
                    onceh = 0;
                    ponies = 0;
                    if (_power_max_kills == 0) {
                        _casualties = min(floor(c / target_unit.dudes_hp[good2]), 1);
                    }
                    if (_power_max_kills != 0) {
                        _casualties = floor(c / target_unit.dudes_hp[good2]);
                    }

                    ponies = target_unit.dudes_num[good2];
                    if ((target_unit.dudes_num[good2] == 1) && ((target_unit.dudes_hp[good2] - c) <= 0)) {
                        _casualties = 1;
                    }

                    if (target_unit.dudes_num[good2] - _casualties < 0) {
                        _casualties = ponies;
                    }
                    if (_casualties < 0) {
                        _casualties = 0;
                    }

                    if ((target_unit.dudes_num[good2] == 1) && (c > 0)) {
                        target_unit.dudes_hp[good2] -= c;
                    } // Need special flavor here for just damaging

                    if (_casualties > 1) {
                        _casualties_flavour_text = $" {_casualties} {target_unit.dudes[good2]} are killed.";
                    } else if (_casualties == 1) {
                        _casualties_flavour_text = $" A {target_unit.dudes[good2]} is killed.";
                    } else {
                        _casualties_flavour_text = $" The {target_unit.dudes[good2]} survives the attack.";
                    }

                    if (_casualties > 0) {
                        var duhs;
                        duhs = target_unit.dudes[good2];
                        if ((obj_ncombat.battle_special == "WL10_reveal") || (obj_ncombat.battle_special == "WL10_later")) {
                            if (duhs == "Veteran Chaos Terminator") {
                                obj_ncombat.chaos_angry += _casualties * 2;
                            }
                            if (duhs == "Veteran Chaos Chosen") {
                                obj_ncombat.chaos_angry += _casualties;
                            }
                            if (duhs == "Greater Daemon of Slaanesh") {
                                obj_ncombat.chaos_angry += _casualties * 5;
                            }
                            if (duhs == "Greater Daemon of Tzeentch") {
                                obj_ncombat.chaos_angry += _casualties * 5;
                            }
                        }
                    }

                    _battle_log_message = _cast_flavour_text + _power_flavour_text  + _casualties_flavour_text;
                    _battle_log_priority = _casualties * 10;
                    add_battle_log_message(_battle_log_message, _battle_log_priority, 135);

                    if (_casualties >= 1) {
                        target_unit.dudes_num[good2] -= _casualties;
                        obj_ncombat.enemy_forces -= _casualties;
                    }
                }

                if ((damage_type == "arp") && (stap == 0) && instance_exists(target_unit) && (target_unit.dudes_num[good2] > 0)) {
                    var a, b, c, eac;
                    eac = target_unit.dudes_ac[good2];
                    a = _power_magnitude; // Average damage
                    // b=a-target_unit.dudes_ac[good2];// Average after armour

                    if (target_unit.dudes_vehicle[good2] == 0) {
                        if (_power_armour_piercing == 1) {
                            eac = 0;
                        }
                        if (_power_armour_piercing == -1) {
                            eac = eac * 6;
                        }
                    }
                    if (target_unit.dudes_vehicle[good2] == 1) {
                        if (_power_armour_piercing == -1) {
                            eac = a;
                        }
                        if (_power_armour_piercing == 0) {
                            eac = eac * 6;
                        }
                        if (_power_armour_piercing == -1) {
                            eac = a;
                        }
                    }
                    b = a - eac;
                    if (b <= 0) {
                        b = 0;
                    }

                    c = b * 1; // New damage

                    if (target_unit.dudes_hp[good2] == 0) {
                        show_message(_power_name);
                        show_message("Getting a 0 health error for target " + string(target_unit) + ", dudes " + string(good2));
                        show_message("Dudes: " + string(target_unit.dudes[good2]) + ", Number: " + string(target_unit.dudes_num[good2]));
                        show_message("Damage: " + string(c));
                        show_message(string(target_unit.dudes_hp[good2]));
                    }

                    var _casualties, ponies, onceh;
                    onceh = 0;
                    ponies = 0;
                    if (_power_max_kills == 0) {
                        _casualties = min(floor(c / target_unit.dudes_hp[good2]), 1);
                    }
                    if (_power_max_kills != 0) {
                        _casualties = floor(c / target_unit.dudes_hp[good2]);
                    }

                    ponies = target_unit.dudes_num[good2];
                    if ((target_unit.dudes_num[good2] == 1) && ((target_unit.dudes_hp[good2] - c) <= 0)) {
                        _casualties = 1;
                    }

                    if (target_unit.dudes_num[good2] - _casualties < 0) {
                        _casualties = ponies;
                    }
                    if (_casualties < 0) {
                        _casualties = 0;
                    }

                    if ((target_unit.dudes_num[good2] == 1) && (c > 0)) {
                        target_unit.dudes_hp[good2] -= c;
                    } // TODO: Need special flavor here for just damaging

                    if (_casualties > 1) {
                        _casualties_flavour_text = $" {_casualties} {target_unit.dudes[good2]} are destroyed.";
                    } else if (_casualties == 1) {
                        _casualties_flavour_text = $" A {target_unit.dudes[good2]} is destroyed.";
                    } else {
                        _casualties_flavour_text = $" The {target_unit.dudes[good2]} survives the attack.";
                    }

                    if (_casualties > 0) {
                        var duhs;
                        duhs = target_unit.dudes[good2];
                        if ((obj_ncombat.battle_special == "WL10_reveal") || (obj_ncombat.battle_special == "WL10_later")) {
                            if (duhs == "Veteran Chaos Terminator") {
                                obj_ncombat.chaos_angry += _casualties * 2;
                            }
                            if (duhs == "Veteran Chaos Chosen") {
                                obj_ncombat.chaos_angry += _casualties;
                            }
                            if (duhs == "Greater Daemon of Slaanesh") {
                                obj_ncombat.chaos_angry += _casualties * 5;
                            }
                            if (duhs == "Greater Daemon of Tzeentch") {
                                obj_ncombat.chaos_angry += _casualties * 5;
                            }
                        }
                    }

                    _battle_log_message = _cast_flavour_text + _power_flavour_text + _casualties_flavour_text;
                    _battle_log_priority = _casualties * 100;
                    add_battle_log_message(_battle_log_message, _battle_log_priority, 135);

                    if (_casualties >= 1) {
                        target_unit.dudes_num[good2] -= _casualties;
                        obj_ncombat.enemy_forces -= _casualties;
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

    display_battle_log_message();
}
