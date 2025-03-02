// TODO: a bunch of stuff in this file and related to it uses strings, replace them with constants;

#macro ARR_power_discipline_list ["default", "biomancy", "pyromancy","telekinesis","rune_magic"]

global.disciplines_data = json_to_gamemaker(working_directory + "\\data\\psychic_disciplines.json", json_parse);
global.powers_data = json_to_gamemaker(working_directory + "\\data\\psychic_powers.json", json_parse);

/// Function to get requested data from the disciplines_data structure
/// @param _discipline_name - The name of the discipline
/// @param _data_name - The specific data attribute you want
/// @returns The requested data, or undefined if not found
function get_discipline_data(_discipline_name, _data_name) {
    // Check if the power exists in the global.disciplines_data
    if (struct_exists(global.disciplines_data, _discipline_name)) {
        var _discipline_object = global.disciplines_data[$ _discipline_name];
        // Check if the data exists for that power
        if (struct_exists(_discipline_object, _data_name)) {
            var _data_content = _discipline_object[$ _data_name];
            return _data_content;
        } else {
            log_error("Requested data was not found!");
        }
    } else {
        log_error("Requested discipline was not found!");
    }
    return;
}

/// Function to get requested data from the powers_data structure
/// @param _power_name - The name of the power (e.g., "Minor Smite")
/// @param _data_name - The specific data attribute you want (e.g., "type", "range", "flavour_text")
/// @returns The requested data, or undefined if not found
function get_power_data(_power_name, _data_name = "") {
    // Check if the power exists in the global.powers_data
    if (struct_exists(global.powers_data, _power_name)) {
        var _power_object = global.powers_data[$ _power_name];
        // Check if the data exists for that power
        if (_data_name == "") {
            return _power_object;
        } else if (struct_exists(_power_object, _data_name)) {
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

        var psy_info = get_discipline_data(discipline, "description");

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

        if ((scr_click_left) && (custom > 1)) {
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
    
    //// show_debug_message("Peril of the Warp Chance: " + string(_perils_chance));
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
    
    //// show_debug_message("Peril of the Warp Strength: " + string(_perils_strength));
    return _perils_strength;
}

//TODO: All tome related logic in this file has to be reworked;
/*
This is a stand-alone script that determines powers based on the POWERS variable,
executes them, and applies the effect and flavor.  All in one.  Because I eventually
got better at this sort of thing.
This called in context of a obj_pnunit
*/
/// @param {string} discipline_letter - Letter of the discipline
/// @param {real} power_index - Index of the power in the powers array
/// @param {Asset.GMObject} target_column - Target column with units
/// @param {real} caster_id - ID of the caster.
/// @mixin
function scr_powers(discipline_letter, power_index, target_column, caster_id) {
    var _unit = unit_struct[caster_id];
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
    var _psy_discipline = convert_power_letter(discipline_letter);
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
    var _armour_data = _unit.get_armour_data();
    var _is_dread = false;
    if (is_struct(_armour_data)) {
        _is_dread = _armour_data.has_tag("dreadnought");
    }


    //TODO: Maybe move into a separate function;
    // In here check if have tome
    if (_unit_weapon_one_data == "Tome" || _unit_weapon_two_data == "Tome") {
        var _tome_tags = "";
        if (_unit_weapon_one_data == "Tome") {
            _tome_tags += marine_wep1[caster_id];
        }
        if (_unit_weapon_two_data == "Tome") {
            _tome_tags += marine_wep2[caster_id];
        }
        _tome_discipline = get_tome_discipline(_tome_tags);
    }

    //TODO: Move into a separate function;
    var _selected_discipline = _psy_discipline;
    if (_tome_discipline != "" && _tome_roll <= 50) {
        _selected_discipline = _tome_discipline;
        _using_tome = true;
    }

    //TODO: Move into a separate function;
    if (struct_exists(global.disciplines_data, _selected_discipline)) {
        var _powers_array = get_discipline_data(_selected_discipline, "powers");
        if (_using_tome) {
            power_index = irandom(array_length(_powers_array));
            _tome_perils_chance = get_discipline_data(_selected_discipline, "_perils_chance");
            _tome_perils_strength = get_discipline_data(_selected_discipline, "_perils_strength");
        }
        _power_name = _powers_array[power_index];
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

    //// show_message(string(_power_name));

    // Chaos powers here

    var _power_type = get_power_data(_power_name, "type");
    var _power_range = get_power_data(_power_name, "range");
    var _power_target_type = get_power_data(_power_name, "target_type");
    var _power_max_kills = get_power_data(_power_name, "max_kills");
    var _power_magnitude = get_power_data(_power_name, "magnitude");
    var _power_armour_piercing = get_power_data(_power_name, "armour_piercing");
    var _power_duration = get_power_data(_power_name, "duration");
    var _power_flavour_text = get_power_data(_power_name, "flavour_text");
    var _power_sorcery = get_power_data(_power_name, "sorcery");

    //TODO: this should be refactored;
    if (_power_sorcery != undefined && _power_sorcery > 0) {
        if ((obj_ncombat.sorcery_seen < 2) && (obj_ncombat.present_inquisitor == 1)) {
            obj_ncombat.sorcery_seen = 1;
        }
    }
    
    if ((_power_name == "Kamehameha") && (obj_ncombat.big_boom == 3)) {
        _power_name = "Imperator Maior";
    }

    //// if (_power_name="Vortex of Doom"){_power_type="attack";_power_range=5;_power_target_type=3;_power_max_kills=1;_power_magnitude=800;_power_armour_piercing=800;_power_duration=0;
    ////     _power_flavour_text="- a hole between real and warp space is torn _open with deadly effect.  ";
    //// }

    //TODO: Move into a separate function;
    var _has_force_weapon = false;
    if (is_struct(_unit_weapon_one_data)) {
        if (_unit_weapon_one_data.has_tag("force")) {
            _has_force_weapon = true;
        }
    }
    if (is_struct(_unit_weapon_two_data)) {
        if (_unit_weapon_two_data.has_tag("force")) {
            _has_force_weapon = true;
        }
    }


    if (_has_force_weapon) {
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
        //// if (_power_armour_piercing>0) then _power_armour_piercing=round(_power_armour_piercing)*1.15;
        if (_power_range > 0) {
            _power_range = round(_power_range) * 1.2;
        }
    }

    if (_unit_role == "Chapter Master") {
        if (_unit.has_trait("paragon")) {
            if (_power_magnitude > 0) {
                _power_magnitude = round(_power_magnitude) * 1.25;
            }
            //// if (_power_armour_piercing>0) then _power_armour_piercing=round(_power_armour_piercing)*1.25;
            if (_power_range > 0) {
                _power_range = round(_power_range) * 1.25;
            }
        }
    }

    _cast_flavour_text = $"{_unit.name_role()} casts '{_power_name}'";
    if ((_tome_discipline != "") && (_tome_roll <= 33) && (_power_name != "Imperator Maior") && (_power_name != "Kamehameha")) {
        _cast_flavour_text = _unit.name_role();
        if (string_char_at(_cast_flavour_text, string_length(_cast_flavour_text)) == "_s") {
            _cast_flavour_text += "' tome ";
        }
        if (string_char_at(_cast_flavour_text, string_length(_cast_flavour_text)) != "_s") {
            _cast_flavour_text += "'_s tome ";
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

    //TODO: Perhaps separate perils into a separate function;
    var _perils_chance = get_perils_chance(_unit, _tome_perils_chance);
    var _perils_roll = irandom_range(1, 100);
    var _perils_strength = get_perils_strength(_unit, _tome_perils_strength);

    //// show_debug_message("Roll: " + string(_perils_roll));

    if (_perils_roll <= _perils_chance) {
        if (obj_ncombat.sorcery_seen == 1) {
            obj_ncombat.sorcery_seen = 0;
        }
        _power_type = "perils";

        _cast_flavour_text = $"{_unit.name_role()} suffers Perils of the Warp!  ";
        _power_flavour_text = scr_perils_table(_perils_strength, _unit, _psy_discipline, _power_name, caster_id, _tome_discipline);

        if (_unit.hp() < 0) {
            //TODO create is_dead function to remove repeats of this log
            if (marine_dead[caster_id] == 0) {
                marine_dead[caster_id] = 1;
                obj_ncombat.player_forces -= 1;
            }

            // Track the lost unit
            var _existing_index = array_get_index(lost, _unit_role);
            if (_existing_index != -1) {
                lost_num[_existing_index] += 1;
            } else {
                array_push(lost, _unit_role);
                array_push(lost_num, 1);
            }

            // Update unit counts
            if (_is_dread) {
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

    //* Buff powers code
    if ((_power_type == "buff") || (_power_name == "Kamehameha")) {
        var _marine_index;
        var _random_marine_list = [];
        for (var i = 0; i < array_length(unit_struct); i++) {
            array_push(_random_marine_list, i);
        }
        _random_marine_list = array_shuffle(_random_marine_list);

        if ((_power_name == "Force Dome") || (_power_name == "Stormbringer")) {
            var _buff_casts = 9;
            for (var i = 0; i < array_length(_random_marine_list); i++) {
                if (_buff_casts <= 0) {
                    break;
                }
                _marine_index = _random_marine_list[i];
                if ((!marine_dead[_marine_index]) && (!marine_mshield[_marine_index])) {
                    _buff_casts -= 1;
                    marine_mshield[_marine_index] = 2;
                }
            }
        }

        if (_power_name == "Quickening") {
            if (marine_quick[caster_id] < 3) {
                marine_quick[caster_id] = 3;
            }
        }
        if (_power_name == "Might of the Ancients") {
            if (marine_might[caster_id] < 3) {
                marine_might[caster_id] = 3;
            }
        }

        if (_power_name == "Fiery Form") {
            if (marine_fiery[caster_id] < 3) {
                marine_fiery[caster_id] = 3;
            }
        }
        if (_power_name == "Fire Shield") {
            var _buff_casts = 9;
            for (var i = 0; i < array_length(_random_marine_list); i++) {
                if (_buff_casts <= 0) {
                    break;
                }
                _marine_index = _random_marine_list[i];
                if ((!marine_dead[_marine_index]) && (!marine_fshield[_marine_index])) {
                    _buff_casts -= 1;
                    marine_fshield[_marine_index] = 2;
                }
            }
        }

        if (_power_name == "Iron Arm") {
            marine_iron[caster_id] += 1;
        }
        if (_power_name == "Endurance") {
            var _buff_casts = 5;
            h = 0;
            for (var i = 0; i < array_length(_random_marine_list); i++) {
                if (_buff_casts <= 0) {
                    break;
                }
                _marine_index = _random_marine_list[i];
                if (!marine_dead[_marine_index]) {
                    var _buff_unit = unit_struct[_marine_index];
                    if (_buff_unit.hp() < _buff_unit.max_health()) {
                        _buff_casts -= 1;
                        _buff_unit.add_or_sub_health(20);
                    }
                }
            }
        }
        if (_power_name == "Hysterical Frenzy") {
            var _buff_casts = 5;
            h = 0;
            for (var i = 0; i < array_length(_random_marine_list); i++) {
                if (_buff_casts <= 0) {
                    break;
                }
                _marine_index = _random_marine_list[i];
                if ((!marine_dead[_marine_index]) && (marine_attack[_marine_index] < 2.5)) {
                    _buff_casts -= 1;
                    marine_attack[_marine_index] += 1.5;
                    marine_defense[_marine_index] -= 0.15;
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
            if (marine_dome[caster_id] < 3) {
                marine_dome[caster_id] = 3;
            }
        }
        if (_power_name == "Spatial Distortion") {
            if (marine_spatial[caster_id] < 3) {
                marine_spatial[caster_id] = 3;
            }
        }

        _battle_log_message = _cast_flavour_text + _power_flavour_text;
        add_battle_log_message(_battle_log_message, 999, 135);
    }

    // TODO: separate the code bellow into a separate function;
    //* Power cast code
    var _good = 0;
    var _target_index = 0;
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

        //* Pick the target
        if (_power_type == "attack") {
            if (_good == 0) {
                repeat (10) {
                    if ((_target_index == 0) && instance_exists(obj_enunit)) {
                        target_column = instance_nearest(x, y, obj_enunit);
                        var _s;
                        _s = 0;

                        repeat (20) {
                            if (point_distance(x, y, target_column.x, target_column.y) < (_power_range * 10)) {
                                if ((_power_target_type == 3) && (_good == 0)) {
                                    _s += 1;
                                    if ((target_column.dudes_hp[_s] > 0) && (dudes_vehicle[_s] == 0)) {
                                        _good = _s;
                                    }
                                }
                                if ((_power_target_type == 4) && (_good == 0)) {
                                    _s += 1;
                                    if ((target_column.dudes_hp[_s] > 0) && (dudes_vehicle[_s] == 1)) {
                                        _good = _s;
                                    }
                                }
                            }
                        }
                        if (_good == 0) {
                            instance_deactivate_object(target_column);
                        }
                        if (_good != 0) {
                            _target_index = _good;
                        }
                    }
                }

                var _onk;
                _onk = 0;
                if ((_power_target_type == 3) && (_good == 0) && (_target_index == 0) && (_power_armour_piercing > 0) && (_onk == 0)) {
                    _power_target_type = 4;
                    _onk = 1;
                }
                if ((_power_target_type == 4) && (_good == 0) && (_target_index == 0) && (_power_magnitude > 0) && (_onk == 0)) {
                    _power_target_type = 3;
                    _onk = 1;
                }

                instance_activate_object(obj_enunit);

                repeat (10) {
                    if ((_target_index == 0) && instance_exists(obj_enunit)) {
                        target_column = instance_nearest(x, y, obj_enunit);
                        var _s;
                        _s = 0;

                        repeat (20) {
                            if (point_distance(x, y, target_column.x, target_column.y) < (_power_range * 10)) {
                                if ((_power_target_type == 3) && (_good == 0)) {
                                    _s += 1;
                                    if ((target_column.dudes_hp[_s] > 0) && (dudes_vehicle[_s] == 0)) {
                                        _good = _s;
                                    }
                                }
                                if ((_power_target_type == 4) && (_good == 0)) {
                                    _s += 1;
                                    if ((target_column.dudes_hp[_s] > 0) && (dudes_vehicle[_s] == 1)) {
                                        _good = _s;
                                    }
                                }
                            }
                        }
                        if (_good == 0) {
                            instance_deactivate_object(target_column);
                        }
                        if (_good != 0) {
                            _target_index = _good;
                        }
                    }
                }

                instance_activate_object(obj_enunit);
            }

            //* Calculate damage
            if (_target_index > 0) {
                var _damage_type;
                if ((_power_armour_piercing > 0) && (_power_magnitude >= 100)) {
                    _damage_type = "arp";
                } else {
                    _damage_type = "att";
                }

                //// if (_power_target_type=3) then _damage_type="att";
                //// if (_power_target_type=4) then _damage_type="arp";

                if (instance_exists(target_column) && (target_column.dudes_num[_target_index] > 0)) {
                    // Set up variables for damage calculation
                    var _base_damage = _power_magnitude;
                    var _effective_armour = target_column.dudes_ac[_target_index];
                    var _is_vehicle = (target_column.dudes_vehicle[_target_index] == 1);
                    var _action_verb = _is_vehicle ? "destroyed" : "killed";
                    var _entity_health = target_column.dudes_hp[_target_index];
                    
                    // Calculate armour effectiveness based on target type and power'_s armour piercing
                    if (!_is_vehicle) { // Non-vehicle targets
                        if (_power_armour_piercing == 1) {
                            _effective_armour = 0; // Full penetration ignores armour
                        } else if (_power_armour_piercing == -1) {
                            _effective_armour *= 6; // Reduced effectiveness against armour
                        }
                    } else { // Vehicle targets
                        if (_power_armour_piercing == -1) {
                            _effective_armour = _base_damage; // Completely ineffective against vehicles
                        } else if (_power_armour_piercing == 0) {
                            _effective_armour *= 6; // Normal weapons struggle against vehicle armour
                        }
                    }
                    
                    // Calculate final damage after armour reduction
                    var _damage_after_armour = _base_damage - _effective_armour;
                    _damage_after_armour = max(0, _damage_after_armour); // Ensure damage isn't negative
                    var _final_damage = _damage_after_armour; // Apply any additional modifiers here if needed
                    
                    // Error checking for invalid health values
                    if (_entity_health <= 0) {
                        show_message(_power_name);
                        show_message("Getting a 0 health error for target " + string(target_column) + ", entity " + string(_target_index));
                        show_message("Entity type: " + string(target_column.dudes[_target_index]) + ", Number: " + string(target_column.dudes_num[_target_index]));
                        show_message("Damage: " + string(_final_damage));
                        show_message("Health: " + string(_entity_health));
                    }
                    
                    // Calculate casualties based on damage and health
                    var _total_entities = target_column.dudes_num[_target_index];
                    var _casualties = 0;
                    
                    if (_power_max_kills == 0) {
                        // Single target limit - at most one casualty
                        _casualties = min(floor(_final_damage / _entity_health), 1);
                    } else {
                        // Multi-target - can kill multiple entities
                        _casualties = floor(_final_damage / _entity_health);
                    }
                    
                    // Special case for last remaining entity
                    if ((_total_entities == 1) && ((_entity_health - _final_damage) <= 0)) {
                        _casualties = 1;
                    }
                    
                    // Cap casualties at available entities and ensure non-negative
                    _casualties = min(max(_casualties, 0), _total_entities);
                    
                    // Apply damage to last entity if it survives
                    if ((_total_entities == 1) && (_final_damage > 0) && (_casualties == 0)) {
                        target_column.dudes_hp[_target_index] -= _final_damage;
                    }
                    
                    // Generate appropriate flavour text based on outcome
                    if (_casualties > 1) {
                        _casualties_flavour_text = $" {_casualties} {target_column.dudes[_target_index]} are {_action_verb}.";
                    } else if (_casualties == 1) {
                        _casualties_flavour_text = $" A {target_column.dudes[_target_index]} is {_action_verb}.";
                    } else {
                        _casualties_flavour_text = $" The {target_column.dudes[_target_index]} survives the attack.";
                    }
                    
                    // Apply special battle effects for certain unit types
                    if (_casualties > 0) {
                        var _target_unit_type = target_column.dudes[_target_index];
                        if ((obj_ncombat.battle_special == "WL10_reveal") || (obj_ncombat.battle_special == "WL10_later")) {
                            // Adjust chaos anger based on unit type
                            if (_target_unit_type == "Veteran Chaos Terminator") {
                                obj_ncombat.chaos_angry += _casualties * 2;
                            } else if (_target_unit_type == "Veteran Chaos Chosen") {
                                obj_ncombat.chaos_angry += _casualties;
                            } else if (_target_unit_type == "Greater Daemon of Slaanesh" || _target_unit_type == "Greater Daemon of Tzeentch") {
                                obj_ncombat.chaos_angry += _casualties * 5;
                            }
                        }
                    }
                    
                    // Update unit counts after casualties are applied
                    if (_casualties >= 1) {
                        target_column.dudes_num[_target_index] -= _casualties;
                        obj_ncombat.enemy_forces -= _casualties;
                    }
                    
                    // Log battle message to combat feed
                    _battle_log_message = _cast_flavour_text + _power_flavour_text + _casualties_flavour_text;
                    _battle_log_priority = _casualties; // Higher casualties = higher priority messages
                    add_battle_log_message(_battle_log_message, _battle_log_priority, 135);
                }

                with (target_column) {
                    var j, _good, _open;
                    j = 0;
                    _good = 0;
                    _open = 0;
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
                if ((target_column.men + target_column.veh + target_column.medi == 0) && (target_column.owner != 1)) {
                    with (target_column) {
                        instance_destroy();
                    }
                }
            }
        }
    } // End repeat

    display_battle_log_message();
}
