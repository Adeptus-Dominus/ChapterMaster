//TODO: a bunch of stuff in this file and related to it uses strings, replace them with constants;

#macro PSY_DISCIPLINES_STARTING ["default", "biomancy", "pyromancy","telekinesis","rune_magic"]

#macro PSY_PERILS_CHANCE_BASE 1
#macro PSY_PERILS_CHANCE_MIN 0.5
#macro PSY_PERILS_CHANCE_LOW 0.5

#macro PSY_PERILS_STR_BASE 1
#macro PSY_PERILS_STR_LOW 10
#macro PSY_PERILS_STR_MED 20

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
        } else {
            _discipline_object = global.disciplines_data[$ "example"];
            var _data_content = _discipline_object[$ _data_name];
        }
        return _data_content;
    } else {
        log_error("Requested discipline was not found!");
    }
    return;
}

/// Function to get requested data from the powers_data structure
/// @param _power_id - The name of the power (e.g., "minor_smite")
/// @param _data_name - The specific data attribute you want (e.g., "type", "range", "flavour_text")
/// @returns The requested data, or undefined if not found
function get_power_data(_power_id, _data_name = "") {
    // Check if the power exists in the global.powers_data
    if (struct_exists(global.powers_data, _power_id)) {
        var _power_object = global.powers_data[$ _power_id];

        // Check if the data exists for that power
        if (_data_name == "") {
            return _power_object;
        } else if (struct_exists(_power_object, _data_name)) {
            var _data_content = _power_object[$ _data_name];
        } else {
            _power_object = global.powers_data[$ "example"];
            var _data_content = _power_object[$ _data_name];
        }

        if (_data_name == "flavour_text") {
            return get_flavour_text(_data_content);
        } else if (_data_name == "power_modifiers") {
            return get_power_modifiers(_data_content);
        } else {
            return _data_content;
        }
    } else {
        log_error("Requested power was not found!");
    }

    return;
}

//TODO: get_flavour_text and get_power_modifiers can probably be combined into one function, due to high level of code duplication;
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
        switch (condition) {
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
        var _starting_powers = PSY_DISCIPLINES_STARTING;
        var _discipline_index = array_get_index(_starting_powers, discipline);
        if (_discipline_index == -1) {
            discipline = _starting_powers[0];
            _discipline_index = 0;
        }

        draw_set_halign(fa_left);
        var _title_01 = "Psychic Discipline";
        draw_text_transformed(440, 660, _title_01, 0.6, 0.6, 0);
        if (scr_hit(440, 660, 440 + string_width(_title_01) * 0.6, 690)) {
            tooltip = _title_01;
            tooltip2 = "The Psychic Discipline that your psykers will use by default.";
        }

        var _discipline_name = get_discipline_data(discipline, "name");
        draw_text_transformed(520, 697, _discipline_name, 0.5, 0.5, 0);

        var _psy_info = get_discipline_data(discipline, "description");
        draw_text_transformed(440, 729, _psy_info, 0.5, 0.5, 0);

        if (custom == 2) {
            draw_sprite_stretched(spr_creation_arrow, 0, 437, 688, 32, 32);
            draw_sprite_stretched(spr_creation_arrow, 1, 475, 688, 32, 32);
            if (point_and_click([437, 688, 437 + 32, 688 + 32])) {
                _discipline_index = _discipline_index == 0 ? array_length(_starting_powers) - 1 : _discipline_index - 1;
            } else if (point_and_click([475, 688, 475 + 32, 688 + 32])) {
                _discipline_index = _discipline_index >= array_length(_starting_powers) - 1 ? 0 : _discipline_index + 1;
            }
        }

        discipline = _starting_powers[_discipline_index];
    }
}

function get_tome_discipline(_tome_tags) {
    try {
        var discipline_names = struct_get_names(global.disciplines_data);
        for (var i = 0; i < array_length(discipline_names); i++) {
            var _discipline_name = discipline_names[i];
            var discipline_struct = global.disciplines_data[$ _discipline_name];
            if (struct_exists(discipline_struct, "tags")) {
                var discipline_tags = discipline_struct[$ "tags"];
                for (var p = 0; p < array_length(discipline_tags); p++) {
                    var discipline_tag = discipline_tags[p];
                    if (string_count(discipline_tag, _tome_tags) > 0) {
                        return _discipline_name;
                    }
                }
            }
        }
        log_error("no matching discipline was found.");
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
            var _discipline_name = discipline_names[i];
            var discipline_struct = global.disciplines_data[$ _discipline_name];
            if (struct_exists(discipline_struct, "letter")) {
                var discipline_letter = discipline_struct[$ "letter"];
                if (power_letter == discipline_letter) {
                    matched_discipline = _discipline_name;
                    return _discipline_name;
                }
            }
        }
        log_error("no matching discipline was found.");
        return "";
    } catch (_exception) {
        return "";
        handle_exception(_exception);
    }
}

function perils_test(_unit, _tome_perils_chance) {
    var _roll_1d100 = roll_dice(1, 100, "high");
    var _perils_threshold = PSY_PERILS_CHANCE_BASE;

    _perils_threshold += _tome_perils_chance;
    _perils_threshold += obj_ncombat.global_perils;

    if (_unit.has_trait("warp_touched")) {
        _perils_threshold += PSY_PERILS_CHANCE_LOW;
    }
    if (scr_has_adv("Daemon Binders")) {
        _perils_threshold -= PSY_PERILS_CHANCE_LOW;
    }

    _perils_threshold = max(_perils_threshold, PSY_PERILS_CHANCE_MIN);

    return _roll_1d100 <= _perils_threshold;
}

function roll_perils_strength(_unit, _tome_perils_strength) {
    var _perils_strength = roll_dice(1, 100, "low");

    _perils_strength += _tome_perils_strength;

    if (_unit.has_trait("warp_touched")) {
        _perils_strength += PSY_PERILS_STR_LOW;
    }
    if (scr_has_adv("Daemon Binders")) {
        // I hope you like demons
        _perils_strength += PSY_PERILS_STR_MED;
    }

    _perils_strength = max(_perils_strength, PSY_PERILS_STR_BASE);

    return _perils_strength;
}

/// @function process_tome_mechanics
/// @param {struct} _unit - The unit structure
/// @param {real} _unit_id - The caster's ID
/// @returns {struct} Tome-related data and modifiers
function process_tome_mechanics(_unit, _unit_id) {
    var _result = {has_tome: false, discipline: "", powers: [], perils_chance: 0, perils_strength: 0, using_tome: false, cast_flavour_text: ""};

    var _unit_weapon_one_data = _unit.get_weapon_one_data();
    var _unit_weapon_two_data = _unit.get_weapon_two_data();

    if (_unit_weapon_one_data == "Tome" || _unit_weapon_two_data == "Tome") {
        _result.has_tome = true;

        var _tome_tags = "";
        if (_unit_weapon_one_data == "Tome") {
            _tome_tags += marine_wep1[_unit_id];
        }
        if (_unit_weapon_two_data == "Tome") {
            _tome_tags += marine_wep2[_unit_id];
        }
        _result.discipline = get_tome_discipline(_tome_tags);

        // Determine if tome is used and apply effects
        var _tome_roll = roll_dice(1, 100);
        if (_result.discipline != "" && _tome_roll > 50) {
            _result.using_tome = true;

            if (struct_exists(global.disciplines_data, _result.discipline)) {
                _result.perils_chance = get_discipline_data(_result.discipline, "perils_chance");
                _result.perils_strength = get_discipline_data(_result.discipline, "perils_strength");
                _result.powers = get_discipline_data(_result.discipline, "powers");
            }

            // Generate flavor text for tome usage
            _result.cast_flavour_text = $"{_unit.name_role()}' tome confers knowledge upon them.";

            // Apply corruption based on perils chance
            if (_result.perils_chance > 0) {
                if ((_tome_roll > 90) && (_result.perils_chance > 0)) {
                    _unit.corruption += roll_personal_dice(1, 6, "low", _unit);
                }
            }
        }
    }

    return _result;
}

/// @function find_valid_target
/// @param {struct} _power_data - Data about the power being used
/// @returns {struct} The target information with column and index
function find_valid_target(_power_data) {
    var _result = {column: noone, index: -1};
    var _target_vehicles = _power_data.target_type == 2;

    // Create a priority queue for potential targets
    var _targets_queue = ds_priority_create();

    if (_power_data.type == "attack") {
        with (obj_enunit) {
            var _distance = point_distance(other.x, other.y, x, y) / 10;
            if (_distance <= _power_data.range) {
                ds_priority_add(_targets_queue, id, _distance);
            }
        }

        // Find closest valid target
        while (!ds_priority_empty(_targets_queue)) {
            var _potential_target = ds_priority_delete_min(_targets_queue);

            for (var i = 0; i < array_length(_potential_target.dudes); i++) {
                if (_potential_target.dudes_hp[i] > 0 && _potential_target.dudes_vehicle[i] == _target_vehicles) {
                    _result.column = _potential_target;
                    _result.index = i;
                    break;
                }
            }

            if (_result.index != -1) {
                break;
            }
        }
    } else {
        with (obj_pnunit) {
            var _distance = point_distance(other.x, other.y, x, y) / 10;
            if (_distance <= _power_data.range) {
                ds_priority_add(_targets_queue, id, _distance);
            }
        }

        // Find closest valid target
        while (!ds_priority_empty(_targets_queue)) {
            var _potential_target = ds_priority_delete_min(_targets_queue);

            if (!_target_vehicles) {
                for (var i = 0; i < array_length(_potential_target.unit_struct); i++) {
                    if (_potential_target.marine_dead[i] == 0) {
                        _result.column = _potential_target;
                        _result.index = i;
                        break;
                    }
                }
            } else {
                for (var i = 0; i < array_length(_potential_target.veh); i++) {
                    if (_potential_target.veh_hp[i] > 0) {
                        _result.column = _potential_target;
                        _result.index = i;
                        break;
                    }
                }
            }

            if (_result.index != -1) {
                break;
            }
        }
    }

    ds_priority_destroy(_targets_queue);
    return _result;
}

/// @desc Psychic powers execution mess. Called in the scope of obj_pnunit.
/// @param {real} caster_id - ID of the caster in the player column from obj_pnunit.
/// @mixin
function scr_powers(caster_id) {
    // Gather unit data
    var _unit = unit_struct[caster_id];
    if (!is_struct(_unit)) {
        exit;
    }
    if (_unit.name() == "") {
        exit;
    }

    var _unit_role = _unit.role();
    var _unit_exp = _unit.experience;
    var _unit_weapon_one_data = _unit.get_weapon_one_data();
    var _unit_weapon_two_data = _unit.get_weapon_two_data();
    var _unit_gear = _unit.get_gear_data();
    var _unit_armour = _unit.get_armour_data();
    if (is_struct(_unit_armour)) {
        var _is_dread = _unit_armour.has_tag("dreadnought");
    } else {
        var _is_dread = false;
    }

    var _psy_discipline = _unit.psy_discipline();
    var _selected_discipline = _psy_discipline;

    // Prepare the battlelog variables
    var _battle_log_message = "";
    var _battle_log_priority = 0;
    var _cast_flavour_text = "";
    var _casualties_flavour_text = "";

    // Decide what to cast
    var _power_id = "";
    var _known_powers = _unit.psy_powers_array();

    //TODO: All tome related logic in this file has to be reworked;
    var _tome_data = process_tome_mechanics(_unit, caster_id);
    if (_tome_data.using_tome) {
        _known_powers = _tome_data.powers;
        _selected_discipline = _tome_data.discipline;
    }

    // Buffs
    var buff_cast = false;
    var buff_roll = roll_dice(1, 100);
    var known_buff_powers = [];
    if (buff_roll >= 80) {
        // Try to pick a buff

        // Filter the buff powers that the unit knows
        for (var i = 0; i < array_length(_known_powers); i++) {
            var __power_type = get_power_data(_known_powers[i], "type");
            if (__power_type == "buff") {
                array_push(known_buff_powers, _known_powers[i]);
            }
        }

        if (array_length(known_buff_powers) > 0) {
            //TODO: Make buff power selection to depend on more stuff;
            _power_id = array_random_element(known_buff_powers);
            buff_cast = true;
        }
    }

    // Attack powers
    var known_attack_powers = [];
    if (!buff_cast) {
        // Pick an attack spell

        // Filter the attack powers that the unit knows
        for (var i = 0; i < array_length(_known_powers); i++) {
            var __power_type = get_power_data(_known_powers[i], "type");
            if (__power_type == "attack") {
                array_push(known_attack_powers, _known_powers[i]);
            }
        }

        if (array_length(known_attack_powers) > 0) {
            _power_id = array_random_element(known_attack_powers);
        }
    }

    // Ancient texts bellow
    if (_power_id == "machine_curse") {
        with (obj_enunit) {
            if (veh > 0) {
                instance_create(x, y, obj_temp3);
            }
        }
        if (instance_number(obj_temp3) == 0) {
            _power_id = "smite";
        }
        if (obj_ncombat.enemy == 9) {
            _power_id = "smite";
        }
        with (obj_temp3) {
            instance_destroy();
        }
    }

    // Gather the invocation stats (multiplier to power stats)
    var _equipment_psy_invocation = get_total_special_value(_unit, "psy_invocation") / 100;
    var _character_psy_invocation = (_unit_exp / 100) + (_unit.psionic / 10);
    var _total_psy_invocation = 1 + _equipment_psy_invocation + _character_psy_invocation;

    // Gather power data
    // var _power_struct = get_power_data(_power_id); // Not used atm
    var _power_data = get_power_data(_power_id);
    var _power_name = get_power_data(_power_id, "name");
    var _power_type = get_power_data(_power_id, "type");
    var _power_range = round(get_power_data(_power_id, "range") * _total_psy_invocation);
    var _power_target_type = get_power_data(_power_id, "target_type");
    var _power_max_kills = round(get_power_data(_power_id, "max_kills") * _total_psy_invocation);
    var _power_magnitude = get_power_data(_power_id, "magnitude") * _total_psy_invocation;
    var _power_armour_piercing = get_power_data(_power_id, "armour_piercing");
    // var _power_duration = get_power_data(_power_id, "duration"); // Not used atm
    var _power_flavour_text = get_power_data(_power_id, "flavour_text");
    var _heretical = get_discipline_data(_selected_discipline, "heretical");

    // Some stuff about the inquisition getting angry for using psy powers
    //TODO: this should be refactored;
    if (_heretical != undefined && _heretical) {
        if ((obj_ncombat.sorcery_seen < 2) && (obj_ncombat.present_inquisitor == 1)) {
            obj_ncombat.sorcery_seen = 2;
        }
    }

    // Psy focus and casting fail/success bellow
    //TODO: Move into a separate function;
    var _equipment_psy_focus = get_total_special_value(_unit, "psy_focus");

    var _cast_successful = false;
    var _cast_difficulty = 40; //TODO: Make this more dynamic;
    _cast_difficulty -= _unit_exp * 0.05;
    _cast_difficulty -= _equipment_psy_focus;
    _cast_difficulty -= _unit.wisdom * 0.4;

    if (roll_personal_dice(1, 100, "high", _unit) >= _cast_difficulty) {
        _cast_successful = true;
        _cast_flavour_text = $"{_unit.name_role()} casts '{_power_name}'";
    } else {
        _cast_flavour_text = $"{_unit.name_role()} failed to cast {_power_name}!";
        _battle_log_message = _cast_flavour_text;
        add_battle_log_message(_battle_log_message, 999, 137);
    }

    //* Buff powers casting code
    if (_power_type == "buff" && _cast_successful) {
        var _marine_index;
        var _marine_column;

        if ((_power_id == "force_dome") || (_power_id == "stormbringer")) {
            var _buff_casts = 8;
            repeat (_buff_casts) {
                var _target_data = find_valid_target(_power_data);
                _marine_index = _target_data.index;
                _marine_column = _target_data.column;
                if (_marine_index != -1) {
                    _marine_column.marine_mshield[_marine_index] = 2;
                }
            }
        } else if (_power_id == "quickening") {
            if (marine_quick[caster_id] < 3) {
                marine_quick[caster_id] = 3;
            }
        } else if (_power_id == "might_of_the_ancients") {
            if (marine_might[caster_id] < 3) {
                marine_might[caster_id] = 3;
            }
        } else if (_power_id == "fiery_form") {
            if (marine_fiery[caster_id] < 3) {
                marine_fiery[caster_id] = 3;
            }
        } else if (_power_id == "fire_shield") {
            var _buff_casts = 9;
            repeat (_buff_casts) {
                var _target_data = find_valid_target(_power_data);
                _marine_index = _target_data.index;
                _marine_column = _target_data.column;
                if (_marine_index != -1) {
                    _marine_column.marine_fshield[_marine_index] = 2;
                }
            }
        } else if (_power_id == "iron_arm") {
            marine_iron[caster_id] += 1;
        } else if (_power_id == "endurance") {
            var _buff_casts = 5;
            repeat (_buff_casts) {
                var _target_data = find_valid_target(_power_data);
                _marine_index = _target_data.index;
                _marine_column = _target_data.column;
                if (_marine_index != -1) {
                    _marine_column.unit_struct[_marine_index].add_or_sub_health(20);
                }
            }
        } else if (_power_id == "hysterical_frenzy") {
            var _buff_casts = 5;
            repeat (_buff_casts) {
                var _target_data = find_valid_target(_power_data);
                _marine_index = _target_data.index;
                _marine_column = _target_data.column;
                if (_marine_index != -1) {
                    marine_attack[_marine_index] += 1.5 * _total_psy_invocation;
                    marine_defense[_marine_index] -= 0.15 * _total_psy_invocation;
                }
            }
        } else if (_power_id == "regenerate") {
            _unit.add_or_sub_health(_power_magnitude * _total_psy_invocation);
        } else if (_power_id == "telekinetic_dome") {
            if (marine_dome[caster_id] < 3) {
                marine_dome[caster_id] = 3;
            }
        } else if (_power_id == "spatial_distortion") {
            if (marine_spatial[caster_id] < 3) {
                marine_spatial[caster_id] = 3;
            }
        }

        _battle_log_message = _cast_flavour_text + _power_flavour_text;
        add_battle_log_message(_battle_log_message, 999, 135);
    } else if (_power_type == "attack" && _cast_successful) {
        //* Attack power casting
        //TODO: separate the code bellow into a separate function;
        //TODO: Make target selection to happen before attack power selection;
        var _target_data = find_valid_target(_power_data);

        //* Calculate damage
        if (_target_data.index != -1 && instance_exists(_target_data.column) && (_target_data.column.dudes_num[_target_data.index] > 0)) {
            // Set up variables for damage calculation
            var _effective_armour = _target_data.column.dudes_ac[_target_data.index];
            var _target_is_vehicle = _target_data.column.dudes_vehicle[_target_data.index] == 1;
            var _destruction_verb = _target_is_vehicle ? "destroyed" : "killed";
            var _damage_verb = _target_is_vehicle ? "damaged" : "hurt";
            var _target_unit_health = _target_data.column.dudes_hp[_target_data.index];
            var _target_unit_name = _target_data.column.dudes[_target_data.index];
            var _target_unit_count = _target_data.column.dudes_num[_target_data.index];

            // Calculate armour effectiveness based on target type and power'_s armour piercing
            if (!_target_is_vehicle) {
                // Non-vehicle targets
                if (_power_armour_piercing == 1) {
                    _effective_armour = 0; // Full penetration ignores armour
                } else if (_power_armour_piercing == -1) {
                    _effective_armour *= 6; // Reduced effectiveness against armour
                }
            } else {
                // Vehicle targets
                if (_power_armour_piercing == -1) {
                    _effective_armour = _power_magnitude; // Completely ineffective against vehicles
                } else if (_power_armour_piercing == 0) {
                    _effective_armour *= 6; // Normal weapons struggle against vehicle armour
                }
            }

            // Calculate final damage after armour reduction
            var _damage_after_armour = _power_magnitude - _effective_armour;
            _damage_after_armour = max(0, _damage_after_armour); // Ensure damage isn't negative
            var _final_damage = _damage_after_armour; // Apply any additional modifiers here if needed

            // Calculate casualties based on damage and health
            var _casualties = 0;

            if (_power_max_kills == 0) {
                // Single target limit - at most one casualty
                _casualties = min(floor(_final_damage / _target_unit_health), 1);
            } else {
                // Multi-target - can kill multiple entities
                _casualties = floor(_final_damage / _target_unit_health);
            }

            // Cap casualties at available entities and ensure non-negative
            _casualties = min(max(_casualties, 0), _target_unit_count);

            // No casualties
            if (_casualties == 0) {
                // Apply damage if any
                if (_final_damage > 0) {
                    _target_data.column.dudes_hp[_target_data.index] -= _final_damage;
                    _casualties_flavour_text = $" The {_target_unit_name} survives the attack but is {_damage_verb}.";
                    // No damage
                } else {
                    _casualties_flavour_text = $" The {_target_unit_name} is unscratched.";
                }
                // Apply casualties
            } else {
                // Update unit counts
                _target_data.column.dudes_num[_target_data.index] -= _casualties;
                obj_ncombat.enemy_forces -= _casualties;

                // Apply special battle effects for certain unit types
                if ((obj_ncombat.battle_special == "WL10_reveal") || (obj_ncombat.battle_special == "WL10_later")) {
                    // Adjust chaos anger based on unit type
                    if (_target_unit_name == "Veteran Chaos Terminator") {
                        obj_ncombat.chaos_angry += _casualties * 2;
                    } else if (_target_unit_name == "Veteran Chaos Chosen") {
                        obj_ncombat.chaos_angry += _casualties;
                    } else if (_target_unit_name == "Greater Daemon of Slaanesh" || _target_unit_name == "Greater Daemon of Tzeentch") {
                        obj_ncombat.chaos_angry += _casualties * 5;
                    }
                }

                // Generate appropriate flavour text based on outcome
                if (_casualties > 1) {
                    _casualties_flavour_text = $" {_casualties} {_target_unit_name} are {_destruction_verb}.";
                } else if (_casualties == 1) {
                    _casualties_flavour_text = $" A {_target_unit_name} is {_destruction_verb}.";
                }

                // Process the enemy column after applying casualties
                compress_enemy_array(_target_data.column);
                destroy_empty_column(_target_data.column);

                // Log battle message to combat feed
                _battle_log_message = _cast_flavour_text + _power_flavour_text + _casualties_flavour_text;
                if (_casualties == 0) {
                    _battle_log_priority = _final_damage / 2; // Just to have some priority here, as they don't have the usual "shots fired"
                } else {
                    if (_target_is_vehicle) {
                        _battle_log_priority = _casualties * 12; // Vehicles are more juicy
                    } else {
                        _battle_log_priority = _casualties * 2; // More casualties = higher priority messages
                    }
                }
                add_battle_log_message(_battle_log_message, _battle_log_priority, 135);
            }
        }
    }

    //* Perils happen bellow
    //TODO: Perhaps separate perils into a separate function;
    var _perils_happened = perils_test(_unit, _tome_data.perils_chance);
    var _perils_strength = roll_perils_strength(_unit, _tome_data.perils_strength);

    if (_perils_happened) {
        _cast_flavour_text = $"{_unit.name_role()} suffers Perils of the Warp!  ";
        _power_flavour_text = scr_perils_table(_perils_strength, _unit, _selected_discipline, _power_id, caster_id, _tome_data.using_tome);

        // Check if marine is dead
        check_dead_marines(_unit, caster_id);

        _battle_log_message = _cast_flavour_text + _power_flavour_text;
        add_battle_log_message(_battle_log_message, 999, 137);
    }

    display_battle_log_message();
}
