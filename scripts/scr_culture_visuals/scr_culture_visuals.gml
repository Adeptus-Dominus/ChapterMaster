function load_visual_sets() {
    var _vis_set_directory = working_directory + "/main/visual_sets";
    if (directory_exists(_vis_set_directory)) {
        var _file_buffer = buffer_load($"{_vis_set_directory}/use_sets.json");
        if (_file_buffer == -1) {
            throw "Could not open file";
        }
        var _json_string = buffer_read(_file_buffer, buffer_string);
        buffer_delete(_file_buffer);
        var _raw_data = json_parse(_json_string);
        if (!is_array(_raw_data)) {
            throw "use_sets.json File Wrong Format";
        }
        for (var i = 0; i < array_length(_raw_data); i++) {
            var _sepcific_vis_set = $"{_vis_set_directory}/{_raw_data[i]}";
            // LOGGER.debug(_raw_data[i]);
            if (directory_exists(_sepcific_vis_set)) {
                // LOGGER.debug(_raw_data[i]);
                var _data_buffer = buffer_load($"{_sepcific_vis_set}/data.json");
                if (_data_buffer == -1) {
                    buffer_delete(_data_buffer);
                    continue;
                } else {
                    var _data_string = buffer_read(_data_buffer, buffer_string);
                    buffer_delete(_data_buffer);
                    var _data_set = json_parse(_data_string);
                    load_vis_set_to_global(_sepcific_vis_set, _data_set);
                }
            }
        }
    }

    set_up_visual_overides();

    load_symbol_sets(global.chapter_symbols, "chapter_symbols", ["pauldron", "knees"]);
    load_symbol_sets(global.role_markings, "role_markings", ["pauldron", "knees"]);
}

function load_symbol_sets(global_area, main_key, sub_sets) {
    var _cons_directory = working_directory + $"/main/{main_key}";
    if (directory_exists(_cons_directory)) {
        // LOGGER.debug($"{_cons_directory}")
        var _file_buffer = buffer_load($"{_cons_directory}/load_sets.json");
        if (_file_buffer == -1) {
            throw false;
        }
        var _json_string = buffer_read(_file_buffer, buffer_string);
        buffer_delete(_file_buffer);
        var _raw_data = json_parse(_json_string);
        if (!is_array(_raw_data)) {
            throw "use_sets.json File Wrong Format";
        }
        var _sprite_double_surface = surface_create(200, 200);
        for (var i = 0; i < array_length(_raw_data); i++) {
            var _sepcific_vis_set = $"{_cons_directory}/{_raw_data[i]}";
            if (directory_exists(_sepcific_vis_set)) {
                for (var s = 0; s < array_length(sub_sets); s++) {
                    var _sub = sub_sets[s];
                    var sub_direct = $"{_sepcific_vis_set}/{_sub}.png";
                    load_new_icon(_sprite_double_surface, sub_direct, global_area[$ _sub], _raw_data[i]);
                }
            }
        }
        surface_clear_and_free(_sprite_double_surface);
    }
}

function load_new_icon(new_sprite_surface, path, add_place, key) {
    if (file_exists(path)) {
        var _new_sprite = sprite_add(path, 1, 0, 0, 0, 0);
        var _width = sprite_get_width(_new_sprite);
        var _height = sprite_get_height(_new_sprite);
        surface_resize(new_sprite_surface, _width, _height);
        surface_set_target(new_sprite_surface);
        draw_clear_alpha(c_black, 0);
        draw_sprite_ext(_new_sprite, 0, _width, 0, -1, 1, 0, c_white, 1);
        surface_reset_target();
        sprite_add_from_surface(_new_sprite, new_sprite_surface, 0, 0, _width, _height, 1, 0);
        add_place[$ key] = _new_sprite;
    }
}

global.chapter_symbols = {
    pauldron: {
        mantis_warriors: spr_mantis_warriors_icon,
    },
    knees: {},
};

global.role_markings = {
    pauldron: {},
    knees: {},
};
global.squad_markings = {
    pauldron: {},
    knees: {},
};
global.company_markings = {
    pauldron: {},
    knees: {},
};

function load_vis_set_to_global(directory, data) {
    for (var i = 0; i < array_length(data); i++) {
        var _sprite_item = data[i];
        // LOGGER.debug(_sprite_item);

        if (directory_exists(directory + $"/{_sprite_item.name}")) {
            var _sprite_direct = directory + $"/{_sprite_item.name}";
            var _new_sprite = undefined;

            // --- MAIN SPRITE LOADING ---
            if (file_exists($"{_sprite_direct}/1.png")) {
                _new_sprite = sprite_add(_sprite_direct + "/1.png", 1, 0, 0, 0, 0);
                var s = 2;
                while (file_exists(_sprite_direct + $"/{s}.png")) {
                    var _merge_sprite = sprite_add(_sprite_direct + $"/{s}.png", 1, 0, 0, 0, 0);
                    if (_merge_sprite == -1) {
                        sprite_delete(_new_sprite);
                        continue;
                    }
                    s++;
                    sprite_merge(_new_sprite, _merge_sprite);
                    sprite_delete(_merge_sprite);
                }
            }

            // --- SHADOW SPRITE LOADING ---
            var _new_shadow = -1;
            if (file_exists($"{_sprite_direct}/shadow1.png")) {
                _new_shadow = sprite_add(_sprite_direct + "/shadow1.png", 1, 0, 0, 0, 0);
                var sh = 2;
                while (file_exists(_sprite_direct + $"/shadow{sh}.png")) {
                    var _merge_shadow = sprite_add(_sprite_direct + $"/shadow{sh}.png", 1, 0, 0, 0, 0);
                    if (_merge_shadow == -1) {
                        sprite_delete(_new_shadow);
                        continue;
                    }
                    sh++;
                    sprite_merge(_new_shadow, _merge_shadow);
                    sprite_delete(_merge_shadow);
                }
            }

            // --- APPLY TO DATA ---
            var _s_data = _sprite_item.data;
            if (struct_exists(_s_data, "offset")) {
                sprite_set_offset(_new_sprite, _s_data.offset.x, _s_data.offset.y);
                if (_new_shadow != -1) {
                    sprite_set_offset(_new_shadow, _s_data.offset.x, _s_data.offset.y);
                }
            }

            _s_data.name = _sprite_item.name;
            _s_data.sprite = _new_sprite;
            if (_new_shadow != -1) {
                _s_data.shadows = _new_shadow;
            }

            // --- ORGANIZE INTO GLOBALS ---
            if (_s_data.position == "weapon") {
                var _weapon_vis = global.weapon_visual_data;
                struct_remove(_s_data, "position");

                if (struct_exists(_weapon_vis, _s_data.base_weapon)) {
                    array_push(_weapon_vis[$ _s_data.base_weapon].variants, _s_data);
                } else {
                    _weapon_vis[$ _s_data.base_weapon] = {
                        base: _s_data,
                        variants: [
                            {
                                sprite: _s_data.sprite,
                                shadow: _s_data.shadow,
                            }
                        ],
                    };
                    struct_remove(_weapon_vis[$ _s_data.base_weapon].base, "base_weapon");
                }
            } else {
                array_push(global.modular_drawing_items, _s_data);
            }
        }
    }
}

function set_up_visual_overides() {
    var _mods = global.modular_drawing_items;
    static flip_components = {
        "right_leg": "left_leg",
        "left_leg": "right_leg",
        "right_shin": "left_shin",
        "left_shin": "right_shin",
        "right_knee": "left_knee",
        "left_knee": "right_knee",
        "right_trim": "left_trim",
        "left_trim": "right_trim",
        "right_arm": "left_arm",
        "left_arm": "right_arm",
        "right_pauldron_icons": "left_pauldron_icons",
        "left_pauldron_icons": "right_pauldron_icons",
        "right_pauldron_base": "left_pauldron_base",
        "left_pauldron_base": "right_pauldron_base",
        "right_pauldron_embeleshments": "left_pauldron_embeleshments",
        "left_pauldron_embeleshments": "right_pauldron_embeleshments",
        "right_pauldron_hangings": "left_pauldron_hangings",
        "left_pauldron_hangings": "right_pauldron_hangings",
        "right_eye": "left_eye",
        "left_eye": "right_eye",
        "right_weapon": "left_weapon",
        "left_weapon": "right_weapon",
    };

    for (var i = 0; i < array_length(_mods); i++) {
        var _item = _mods[i];
        if (struct_exists(_item, "overides")) {
            var _overide_areas = struct_get_names(_item.overides);
            for (var o = 0; o < array_length(_overide_areas); o++) {
                var _overide = _item.overides[$ _overide_areas[o]];
                if (is_string(_overide)) {
                    var _found_sprite = false;
                    for (var s = 0; s < array_length(_mods); s++) {
                        if (struct_exists(_mods[s], "name")) {
                            if (_mods[s].name == _overide) {
                                _item.overides[$ _overide_areas[o]] = _mods[s].sprite;
                                _found_sprite = true;
                                break;
                            }
                        }
                    }
                    if (!_found_sprite) {
                        struct_remove(_item.overides, _overide_areas[o]);
                    }
                }
            }
        }
        /*subs have the format "subcomponents" : [
            [crusader_neckpiece],
        ]*/
        if (struct_exists(_item, "subcomponents")) {
            var _subs = _item.subcomponents;
            for (var s = 0; s < array_length(_subs); s++) {
                var _sub_group = _subs[s];
                for (var g = array_length(_sub_group) - 1; g >= 0; g--) {
                    var _found_sprite = false;
                    var _subimg = _sub_group[g];
                    if (!is_string(_subimg)) {
                        if (!sprite_exists(_subimg)) {
                            array_delete(_sub_group, g, 1);
                        }
                        continue;
                    }
                    if (_subimg == "blank") {
                        _item.subcomponents[s][g] = spr_blank;
                        _found_sprite = true;
                    } else {
                        for (var m = 0; m < array_length(_mods); m++) {
                            if (struct_exists(_mods[m], "name")) {
                                if (_mods[m].name == _subimg) {
                                    _item.subcomponents[s][g] = _mods[m].sprite;
                                    _found_sprite = true;
                                    break;
                                }
                            }
                        }
                    }
                    if (!_found_sprite) {
                        array_delete(_item.subcomponents[s], g, 1);
                    }
                }
            }
        }
        if (struct_exists(_item, "cultures")) {
            var _cultures = _item.cultures;
            // LOGGER.debug($"{array_length(_cultures)}");
            for (var s = 0; s < array_length(_cultures); s++) {
                var _culture = _cultures[s];
                if (!array_contains(global.culture_styles, _culture)) {
                    array_push(global.culture_styles, _culture);
                }
            }
        }
    }

    var _new_mods = [];
    for (var i = 0; i < array_length(_mods); i++) {
        var _mod = _mods[i];
        if (struct_exists(_mod, "flip") && struct_exists(flip_components, _mod.position)) {
            var _flip_mod = variable_clone(_mod);
            _flip_mod.position = flip_components[$ _flip_mod.position];
            if (struct_exists(_flip_mod, "prevent_others")) {
                if (struct_exists(_flip_mod, "ban")) {
                    for (var b = 0; b < array_length(_flip_mod.ban); b++) {
                        var _ban_pos = _flip_mod.ban[b];
                        if (struct_exists(flip_components, _ban_pos)) {
                            _flip_mod.ban[b] = flip_components[$ _ban_pos];
                        }
                    }
                }
            }
            if (struct_exists(_flip_mod, "overides")) {
                var _overides_name = struct_get_names(_flip_mod.overides);
                for (var o = 0; o < array_length(_overides_name); o++) {
                    if (struct_exists(flip_components, _overides_name[o])) {
                        var _flip = flip_components[$ _overides_name[o]];
                        _flip_mod.overides[$ _flip] = variable_clone(_mod.overides[$ _overides_name[o]]);

                        struct_remove(_flip_mod.overides, _overides_name[o]);
                    }
                }
            }
            shader_set(right_left_swap_shader);

            _flip_mod.sprite = return_sprite_mirrored(_mod.sprite, false);
            //sprite_set_offset(_flip_mod.sprite,sprite_get_xoffset(_mod.sprite),sprite_get_yoffset(_mod.sprite));

            if (struct_exists(_flip_mod, "subcomponents")) {
                var _subs = _mod.subcomponents;
                for (var s = 0; s < array_length(_subs); s++) {
                    for (var ss = 0; ss < array_length(_subs[s]); ss++) {
                        if (sprite_exists(_subs[s][ss])) {
                            _flip_mod.subcomponents[s][ss] = return_sprite_mirrored(_subs[s][ss], false);
                        }
                    }
                }
            }
            shader_reset();
            if (struct_exists(_flip_mod, "shadows")) {
                _flip_mod.shadows = return_sprite_mirrored(_mod.shadows, false);
            }
            array_push(_new_mods, _flip_mod);
        }
    }

    for (var i = 0; i < array_length(_new_mods); i++) {
        array_push(_mods, _new_mods[i]);
    }
}

function DummyMarine() constructor {
    static update = function() {
        delete body;
        body = generate_marine_body();
        add_purity_seal_markers();
    };

    personal_livery = {};
    if (obj_creation.chapter_name == "Deathwatch") {
        personal_livery.right_pauldron = irandom(30);
    }
    update();
    static distribute_traits = scr_marine_trait_spawning;
    base_group = "astartes";
    static alter_equipment = alter_unit_equipment;
    static stat_display = scr_draw_unit_stat_data;
    static draw_unit_image = scr_draw_unit_image;
    static display_wepaons = scr_ui_display_weapons;
    static unit_profile_text = scr_unit_detail_text;
    static has_equipped = unit_has_equipped;
    static get_body_data = scr_get_body_data;
    traits = [];
    company = irandom_range(1, 10);

    static name_role = function() {
        return "jeff";
    };

    static role = function() {
        with (obj_creation) {
            if (obj_creation.livery_selection_options.current_selection == 2) {
                return role[100][livery_picker.role_set > 0 ? livery_picker.role_set : eROLE.TACTICAL];
            } else {
                return role[100][eROLE.TACTICAL];
            }
        }
    };

    static weapon_one = function() {
        with (obj_creation) {
            return wep1[100][livery_picker.role_set > 0 ? livery_picker.role_set : eROLE.TACTICAL];
        }
    };

    static race = function() {
        return "1";
    };

    static weapon_two = function() {
        with (obj_creation) {
            return wep2[100][livery_picker.role_set > 0 ? livery_picker.role_set : eROLE.TACTICAL];
        }
    };

    last_armour = "MK7 Aquila";

    static armour = function() {
        var armours = global.list_basic_power_armour;
        var _last_armour = last_armour;
        var _armour = "";
        with (obj_creation) {
            if (!livery_picker.freeze_armour) {
                _armour = armour[100][livery_picker.role_set > 0 ? livery_picker.role_set : eROLE.TACTICAL];
                if (array_contains(armours, _armour) || _armour == STR_ANY_POWER_ARMOUR) {
                    _armour = array_random_element(armours);
                } else if (array_contains(global.list_terminator_armour, _armour) || _armour == STR_ANY_POWER_ARMOUR) {
                    _armour = array_random_element(global.list_terminator_armour);
                }
                if (_armour == "Power Armour") {
                    _armour = "MK7 Aquila";
                }
            } else {
                _armour = _last_armour;
            }
            if (obj_creation.livery_selection_options.current_selection == 2) {
                if (!array_contains(armours, _armour)) {
                    _armour = "MK7 Aquila";
                }
            }
        }
        last_armour = _armour;
        return _armour;
    };

    static gear = function() {
        with (obj_creation) {
            return gear[100][livery_picker.role_set > 0 ? livery_picker.role_set : eROLE.TACTICAL];
        }
    };

    static mobility_item = function() {
        with (obj_creation) {
            return mobi[100][livery_picker.role_set > 0 ? livery_picker.role_set : eROLE.TACTICAL];
        }
    };

    static IsSpecialist = function(search_type = SPECIALISTS_STANDARD, include_trainee = false, include_heads = true) {
        return is_specialist(role(), search_type, include_trainee, include_heads);
    };

    static has_trait = marine_has_trait;

    static is_dreadnought = function() {
        var _arm_data = gear_weapon_data("armour", last_armour);
        if (is_struct(_arm_data)) {
            if (_arm_data.has_tag("dreadnought")) {
                return true;
            }
        }
        return false;
    };

    experience = 120;

    //get equipment data methods by deafult they garb all equipment data and return an equipment struct e.g new EquipmentStruct(item_data, core_type,quality="none")
    static get_armour_data = function(type = "all") {
        return gear_weapon_data("armour", armour(), type, false);
    };

    static get_gear_data = function(type = "all") {
        return gear_weapon_data("gear", gear(), type, false);
    };

    static get_mobility_data = function(type = "all") {
        return gear_weapon_data("mobility", mobility_item(), type, false);
    };

    static get_weapon_one_data = function(type = "all") {
        return gear_weapon_data("weapon", weapon_one(), type, false);
    };

    static get_weapon_two_data = function(type = "all") {
        return gear_weapon_data("weapon", weapon_two(), type, false);
    };

    static equipment_has_tag = function(tag, area) {
        var tags = [];
        switch (area) {
            case "wep1":
                tags = get_weapon_one_data("tags");
                break;
            case "wep2":
                tags = get_weapon_two_data("tags");
                break;
            case "mobi":
                tags = get_mobility_data("tags");
                break;
            case "armour":
                tags = get_armour_data("tags");
                break;
            case "gear":
                tags = get_gear_data("tags");
                break;
        }
        if (!is_array(tags) || array_length(tags) == 0) {
            return false;
        } else {
            return array_contains(tags, tag);
        }
    };
}

function scr_get_body_data(body_item_key, body_slot = "none") {
    if (body_slot != "none") {
        if (struct_exists(body, body_slot)) {
            if (struct_exists(body[$ body_slot], body_item_key)) {
                return body[$ body_slot][$ body_item_key];
            } else {
                return false;
            }
        } else {
            return "invalid body area";
        }
    } else {
        var item_key_map = {};
        var body_part_area_keys;
        var _body_parts = global.unit_body_parts;
        for (var i = 0; i < array_length(_body_parts); i++) {
            //search all body parts
            body_area = body[$ _body_parts[i]];
            body_part_area_keys = struct_get_names(body_area);
            for (var b = 0; b < array_length(body_part_area_keys); b++) {
                if (body_part_area_keys[b] == body_item_key) {
                    item_key_map[$ _body_parts[i]] = body_area[$ body_item_key];
                }
            }
        }
        return item_key_map;
    }
}

function generate_marine_body() {
    var _body = {
        "left_leg": {
            leg_variants: irandom(100),
            shin_variant: irandom(100),
            knee_variant: irandom(100),
        },
        "right_leg": {
            leg_variants: irandom(100),
            shin_variant: irandom(100),
            knee_variant: irandom(100),
        },
        "torso": {
            cloth: {
                variation: irandom(100),
            },
            tabbard_variation: irandom(100),
            armour_choice: irandom(100),
            variation: irandom(10),
            backpack_variation: irandom(100),
            backpack_decoration_variation: irandom(100),
            backpack_augment_variation: irandom(100),
            thorax_variation: irandom(100),
            chest_variation: irandom(100),
            belt_variation: irandom(100),
            chest_fastening: irandom(100),
        },
        "left_arm": {
            trim_variation: irandom(100),
            personal_livery: irandom(100),
            pad_variation: irandom(100),
            variation: irandom(100),
            weapon_variation: irandom(100),
        },
        "right_arm": {
            trim_variation: irandom(100),
            personal_livery: irandom(100),
            pad_variation: irandom(100),
            variation: irandom(100),
            weapon_variation: irandom(100),
        },
        "left_eye": {
            variant: irandom(100),
        },
        "right_eye": {
            variant: irandom(100),
        },
        "throat": {
            variant: irandom(100),
            hanging_variant: irandom(100),
        },
        "jaw": {
            variant: irandom(100),
        },
        "head": {
            variation: irandom(100),
            crest_variation: irandom(100),
            forehead_variation: irandom(100),
            crown_variation: irandom(100),
        },
        "cloak": {
            type: "none",
            variant: irandom(100),
        },
    };
    return _body;
}

function add_purity_seal_markers() {
    if (irandom(3) == 0) {
        body[$ "torso"][$ "purity_seal"] = [
            irandom(100),
            irandom(100),
            irandom(100),
            irandom(100)
        ];
    }
    if (irandom(3) == 0) {
        body[$ "left_arm"][$ "purity_seal"] = [
            irandom(100),
            irandom(100),
            irandom(100),
            irandom(100)
        ];
    }
    if (irandom(3) == 0) {
        body[$ "right_arm"][$ "purity_seal"] = [
            irandom(100),
            irandom(100),
            irandom(100),
            irandom(100)
        ];
    }
    if (irandom(3) == 0) {
        body[$ "left_leg"][$ "purity_seal"] = [
            irandom(100),
            irandom(100),
            irandom(100),
            irandom(100)
        ];
    }
    if (irandom(3) == 0) {
        body[$ "right_leg"][$ "purity_seal"] = [
            irandom(100),
            irandom(100),
            irandom(100),
            irandom(100)
        ];
    }
}

function format_weapon_visuals(weapon_name) {
    var _weapon_visual_data = {};
    if (struct_exists(global.weapon_visual_data, weapon_name)) {
        _weapon_visual_data = global.weapon_visual_data[$ weapon_name];
    } else {
        return [];
    }
    var base_data = variable_clone(_weapon_visual_data.base);
    base_data.weapon_map = weapon_name;
    base_data.position = "weapon";
    var return_options = [];
    for (var i = 0; i < array_length(_weapon_visual_data.variants); i++) {
        var _variant = _weapon_visual_data.variants[i];
        var new_obj = variable_clone(base_data);
        var variant_keys = struct_get_names(_variant);
        var sprite = _variant.sprite;
        for (var k = 0; k < array_length(variant_keys); k++) {
            var key = variant_keys[k];
            if (key != "weapon_data" && key != "sprite") {
                new_obj[$ key] = _variant[$ key];
            } else if (key == "weapon_data") {
                if (struct_exists(_variant, "weapon_data")) {
                    var data_names = struct_get_names(_variant.weapon_data);
                    for (var n = 0; n < array_length(data_names); n++) {
                        var _name = data_names[n];
                        new_obj.weapon_data[$ _name] = _variant.weapon_data[$ _name];
                    }
                }
            }
            new_obj.weapon_data.sprite = _variant.sprite;
            if (struct_exists(_variant, "subcomponents")) {
                new_obj.weapon_data.subcomponents = _variant.subcomponents;
            }
            if (struct_exists(_variant, "shadows")) {
                new_obj.weapon_data.shadows = _variant.shadows;
            }
        }
        array_push(return_options, new_obj);
    }
    return return_options;
}

global.weapon_visual_data = {
    //30k weapons
    //Volkite Pack
    "Volkite Charger": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_volkite_charger,
            }
        ],
    },
    "Volkite Serpenta": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_volkite_serpenta,
            }
        ],
    },
    "Volkite Caliver": {
        base: {
            weapon_data: {
                display_type: "ranged_twohand",
                single_left_right_profile: true,
            },
            body_types: [
                0,
                1
            ],
        },
        variants: [
            {
                sprite: spr_weapon_volkite_caliver,
            }
        ],
    },
    "Volkite Culverin": {
        base: {
            weapon_data: {
                display_type: "terminator_ranged",
            },
            body_types: [2],
        },
        variants: [
            {
                sprite: spr_weapon_volkite_culverin_term,
            },
            {
                weapon_data: {
                    display_type: "ranged_twohand",
                },
                sprite: spr_weapon_volkite_culverin,
                body_types: [
                    0,
                    1
                ],
            }
        ],
    },
    //Bolter Pack
    "Phobos Bolter": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_phobos_bolter,
            }
        ],
    },
    "Webber": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_webber,
                shadows: spr_weapon_webber_shadow,
            }
        ],
    },
    "Phobos Bolt Pistol": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_phobos_boltpis,
            }
        ],
    },
    "Mars Heavy Bolter": {
        base: {
            weapon_data: {
                display_type: "ranged_twohand",
                single_left_right_profile: true,
            },
            body_types: [
                0,
                1
            ],
        },
        variants: [
            {
                sprite: spr_weapon_mars_hbolt,
            }
        ],
    },
    "Tigris Combi Bolter": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_tigris_combi,
            }
        ],
    },
    //Plasma Pack
    "Ryza Plasma Gun": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_ryza_plasg,
            }
        ],
    },
    "Ryza Plasma Pistol": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_ryza_plasp,
            }
        ],
    },
    "Mars Plasma Cannon": {
        base: {
            weapon_data: {
                display_type: "ranged_twohand",
                single_left_right_profile: true,
            },
            body_types: [
                0,
                1
            ],
        },
        variants: [
            {
                sprite: spr_weapon_mars_plasc,
            }
        ],
    },
    //Melta Pack
    "Proteus Multi-Melta": {
        base: {
            weapon_data: {
                display_type: "ranged_twohand",
                single_left_right_profile: true,
            },
            body_types: [
                0,
                1
            ],
        },
        variants: [
            {
                sprite: spr_weapon_prot_mmlt,
            }
        ],
    },
    "Primus Melta Gun": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_prim_mltg,
            }
        ],
    },
    //Flamer Pack
    "Phaestos Flamer": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_ph_flmr,
            }
        ],
    },
    //melee pack
    "Power Scythe": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 2,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_powscythe,
            }
        ],
    },
    //Laser pack
    "Ryza Lascannon": {
        base: {
            weapon_data: {
                display_type: "ranged_twohand",
                single_left_right_profile: true,
            },
            body_types: [
                0,
                1
            ],
        },
        variants: [
            {
                sprite: spr_weapon_ryza_lasca,
            }
        ],
    },
    //misc pack
    "Cthon Autocannon": {
        base: {
            weapon_data: {
                display_type: "ranged_twohand",
                single_left_right_profile: true,
            },
            body_types: [
                0,
                1
            ],
        },
        variants: [
            {
                sprite: spr_weapon_cthon_autocannon,
            }
        ],
    },
    //40k weapons
    "Assault Cannon": {
        base: {
            weapon_data: {
                display_type: "terminator_ranged",
                arm_type: 1,
                hand_type: 0,
            },
            body_types: [2],
        },
        variants: [
            {
                sprite: spr_weapon_assca,
            },
            {
                sprite: spr_weapon_assca,
                body_types: [3],
                armours: ["Dreadnought"],
                single_left_right_profile: true,
            }
        ],
    },
    "Heavy Flamer": {
        base: {
            weapon_data: {
                arm_type: 1,
                hand_type: 0,
            },
            body_types: [2],
        },
        variants: [
            {
                sprite: spr_weapon_hflamer_term,
            },
            {
                weapon_data: {
                    display_type: "ranged_twohand",
                },
                sprite: spr_weapon_hflamer,
                body_types: [
                    0,
                    1
                ],
            }
        ],
    },
    "Lascannon": {
        base: {
            body_types: [
                0,
                1
            ],
            weapon_data: {
                display_type: "ranged_twohand",
            },
        },
        variants: [
            {
                sprite: spr_weapon_lasca,
            },
            {
                sprite: spr_dread_lascannon,
                body_types: [3],
                armours: ["Dreadnought"],
                single_left_right_profile: true,
            }
        ],
    },
    "Close Combat Weapon": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
            armours: ["Dreadnought"],
            single_left_right_profile: true,
        },
        variants: [
            {
                sprite: spr_dread_claw,
            },
            {
                sprite: spr_contemptor_CCW,
                armours: ["Contemptor Dreadnought"],
            }
        ],
    },
    "Twin Linked Heavy Bolter": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
        },
        variants: [
            {
                sprite: spr_dread_heavy_bolter,
            }
        ],
    },
    "Dreadnought Lightning Claw": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
        },
        variants: [
            {
                sprite: spr_dread_claw,
            }
        ],
    },
    "CCW Heavy Flamer": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
        },
        variants: [
            {
                sprite: spr_dread_claw,
            }
        ],
    },
    "Dreadnought Power Claw": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
        },
        variants: [
            {
                sprite: spr_dread_claw,
            }
        ],
    },
    "Inferno Cannon": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
        },
        variants: [
            {
                sprite: spr_dread_plasma_cannon,
            }
        ],
    },
    "Multi-Melta": {
        base: {
            body_types: [
                0,
                1
            ],
            weapon_data: {
                display_type: "ranged_twohand",
            },
        },
        variants: [
            {
                sprite: spr_weapon_mmelta,
            },
            {
                sprite: spr_dread_plasma_cannon,
                body_types: [3],
                armours: ["Dreadnought"],
                single_left_right_profile: true,
            }
        ],
    },
    "Twin Linked Lascannon": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
        },
        variants: [
            {
                sprite: spr_dread_lascannon,
            }
        ],
    },
    "Heavy Conversion Beam Projector": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
        },
        variants: [
            {
                sprite: spr_dread_plasma_cannon,
            }
        ],
    },
    "Twin-linked Volkite Culverins": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
        },
        variants: [
            {
                sprite: spr_Volkite_Culverins,
            }
        ],
    },
    "Heavy Conversion Beamer": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
        },
        variants: [
            {
                sprite: spr_Contemptor_Conversion_Beamer,
            }
        ],
    },
    "Kheres Assault Cannon": {
        base: {
            body_types: [3],
            weapon_data: {
                display_type: "dreadnought",
            },
        },
        variants: [
            {
                sprite: spr_Contemptor_assault_cannon,
            }
        ],
    },
    "Bolt Pistol": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_boltpis,
            }
        ],
    },
    "Infernus Pistol": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_inferno,
            }
        ],
    },
    "Bolter": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_bolter,
            }
        ],
    },
    "Storm Bolter": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_sbolter,
            }
        ],
    },
    "Plasma Gun": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_plasg,
            }
        ],
    },
    "Plasma Pistol": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_plasp,
            }
        ],
    },
    "Meltagun": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_melta,
            }
        ],
    },
    "Flamer": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_flamer,
            }
        ],
    },
    "Stalker Pattern Bolter": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_stalker,
            }
        ],
    },
    "Combiplasma": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_complas,
            }
        ],
    },
    "Combiflamer": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_comflamer,
            }
        ],
    },
    "Combigrav": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_comgrav,
            }
        ],
    },
    "Combimelta": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_commelta,
            }
        ],
    },
    "Grav-Pistol": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_grav_pistol,
            }
        ],
    },
    "Grav-Gun": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_grav_gun,
            }
        ],
    },
    "Hand Flamer": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_hand_flamer,
            }
        ],
    },
    "Missile Launcher": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_missile,
            },
            {
                sprite: spr_dread_missile,
                body_types: [3],
                armours: ["Dreadnought"],
                single_left_right_profile: true,
            }
        ],
    },
    "Plasma Cannon": {
        base: {
            weapon_data: {
                display_type: "terminator_ranged",
            },
            body_types: [2],
        },
        variants: [
            {
                sprite: spr_weapon_plasma_cannon_term,
            },
            {
                weapon_data: {
                    display_type: "ranged_twohand",
                },
                sprite: spr_weapon_plasc,
                body_types: [
                    0,
                    1
                ],
            },
            {
                sprite: spr_dread_plasma_cannon,
                body_types: [3],
                armours: ["Dreadnought"],
                single_left_right_profile: true,
            }
        ],
    },
    "Grav-Cannon": {
        base: {
            weapon_data: {
                display_type: "terminator_ranged",
            },
            body_types: [2],
        },
        variants: [
            {
                sprite: spr_weapon_plasma_cannon_term,
            },
            {
                weapon_data: {
                    display_type: "ranged_twohand",
                },
                sprite: spr_weapon_grav_cannon,
                body_types: [
                    0,
                    1
                ],
            }
        ],
    },
    "Power Fist": {
        base: {
            weapon_data: {
                display_type: "terminator_fist",
            },
            body_types: [2],
        },
        variants: [
            {
                sprite: spr_weapon_powfist4,
                shadows: spr_weapon_powfist4_shadows,
            },
            {
                sprite: spr_weapon_powfist,
                body_types: [
                    0,
                    1
                ],
                weapon_data: {
                    display_type: "normal_fist",
                },
            }
        ],
    },
    "Lightning Claw": {
        base: {
            weapon_data: {
                display_type: "terminator_fist",
            },
            body_types: [2],
        },
        variants: [
            {
                sprite: spr_weapon_lightning2,
                shadows: spr_weapon_lightning2_shadows,
            },
            {
                sprite: spr_weapon_lightning1,
                body_types: [
                    0,
                    1
                ],
                weapon_data: {
                    display_type: "normal_fist",
                },
            }
        ],
    },
    "Boltstorm Gauntlet": {
        base: {
            weapon_data: {
                display_type: "normal_fist",
                arm_type: 1,
            },
            body_types: [
                0,
                1
            ],
        },
        variants: [
            {
                sprite: spr_weapon_boltstorm_gauntlet_small,
            },
            {
                sprite: spr_weapon_boltstorm_gauntlet,
                shadows: spr_weapon_boltstorm_gauntlet_shadows,
                body_types: [2],
                weapon_data: {
                    display_type: "terminator_fist",
                },
            }
        ],
    },
    "Xenophase Blade": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 2,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_xenophase_blade_var1,
            }
        ],
    },
    "Chainfist": {
        base: {
            weapon_data: {
                display_type: "normal_fist",
                arm_type: 1,
            },
            body_types: [
                0,
                1
            ],
        },
        variants: [
            {
                sprite: spr_weapon_chainfist_small,
            },
            {
                sprite: spr_weapon_chainfist,
                shadows: spr_weapon_chainfist_shadows,
                weapon_data: {
                    display_type: "terminator_fist",
                },
                body_types: [2],
            }
        ],
    },
    "Assault Chainfist": {
        base: {
            weapon_data: {
                display_type: "normal_fist",
                arm_type: 1,
            },
            body_types: [
                0,
                1
            ],
        },
        variants: [
            {
                sprite: spr_weapon_chainfist_small,
            }
        ],
    },
    "Heavy Thunder Hammer": {
        base: {
            weapon_data: {
                display_type: "melee_twohand",
                hand_type: 0,
                ui_twoh: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_hthhammer,
            }
        ],
    },
    "Sniper Rifle": {
        base: {
            weapon_data: {
                display_type: "melee_twohand",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_sniper,
            }
        ],
    },
    "Autocannon": {
        base: {
            weapon_data: {
                display_type: "melee_twohand",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_autocannon2,
            },
            {
                sprite: spr_dread_autocannon,
                body_types: [3],
                armours: ["Dreadnought"],
                single_left_right_profile: true,
            }
        ],
    },
    "Storm Shield": {
        base: {
            weapon_data: {
                display_type: "shield",
            },
        },
        variants: [
            {
                sprite: spr_weapon_storm,
                weapon_data: {
                    single_left_right_profile: true,
                },
                subcomponents: [
                    [
                        spr_blank,
                        spr_weapon_storm_boss
                    ]
                ],
            },
            {
                sprite: spr_weapon_storm_complex,
                weapon_data: {
                    single_left_right_profile: true,
                },
                subcomponents: [
                    [
                        spr_blank,
                        spr_weapon_storm_primary_decoration
                    ],
                    [
                        spr_blank,
                        spr_weapon_storm_boss
                    ]
                ],
            },
            {
                sprite: spr_weapon_storm2,
            }
        ],
    },
    "Boarding Shield": {
        base: {
            weapon_data: {
                display_type: "shield",
            },
        },
        variants: [
            {
                sprite: spr_weapon_boarding,
            }
        ],
    },
    "Infernus Heavy Bolter": {
        base: {
            weapon_data: {
                display_type: "ranged_twohand",
            },
        },
        variants: [
            {
                sprite: spr_weapon_infernus_hbolt,
            }
        ],
    },
    "Heavy Bolter": {
        base: {
            weapon_data: {
                display_type: "ranged_twohand",
            },
        },
        variants: [
            {
                sprite: spr_weapon_hbolt,
            }
        ],
    },
    "Company Standard": {
        base: {
            weapon_data: {
                hand_on_top: true,
                display_type: "melee_onehand",
            },
        },
        variants: [
            {
                cultures: ["Knightly"],
                sprite: spr_da_standard,
            },
            {
                sprite: spr_weapon_standard2,
            }
        ],
    },
    "Chainsword": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 2,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_chsword,
            }
        ],
    },
    "Combat Knife": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 2,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_knife,
            }
        ],
    },
    "Power Sword": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 2,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_powswo,
                subcomponents: [
                    [
                        spr_blank,
                        spr_pow_sword_cross_guard
                    ],
                    [
                        spr_blank,
                        spr_pow_sword_blade_additions
                    ]
                ],
            },
            {
                cultures: ["Mongol"],
                sprite: spr_weapon_sword_turk,
            },
            {
                cultures: ["Mongol"],
                sprite: spr_weapon_sword_oriental,
            },
            {
                cultures: ["Alpha"],
                sprite: spr_weapoon_powso_flamberge,
            }
        ],
    },
    "Eviscerator": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 0,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_evisc,
            }
        ],
    },
    "Eldar Power Sword": {
        base: {
            weapon_data: {
                hand_on_top: true,
                display_type: "melee_onehand",
            },
        },
        variants: [
            {
                sprite: spr_weapon_eldsword,
            }
        ],
    },
    "Power Spear": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 2,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_powspear,
            }
        ],
    },
    "Thunder Hammer": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 2,
            },
        },
        variants: [
            {
                sprite: spr_weapon_thhammer,
            }
        ],
    },
    "Power Axe": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 3,
                arm_type: 3,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_powaxe,
            }
        ],
    },
    "Power Mace": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 3,
                arm_type: 3,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_powmace,
            }
        ],
    },
    "Mace of Absolution": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 3,
                arm_type: 3,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_mace_of_absolution,
            }
        ],
    },
    "Crozius Arcanum": {
        base: {
            weapon_data: {
                hand_on_top: true,
                display_type: "melee_onehand",
                hand_type: 3,
                arm_type: 3,
            },
        },
        variants: [
            {
                sprite: spr_weapon_crozarc,
            }
        ],
    },
    "Chainaxe": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 3,
                arm_type: 3,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_chaxe,
            }
        ],
    },
    "Force Staff": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 2,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_frcstaff,
            }
        ],
    },
    "Force Sword": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 2,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_frcsword,
            }
        ],
    },
    "Force Axe": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 3,
                arm_type: 3,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_frcaxe,
            }
        ],
    },
    "Relic Blade": {
        base: {
            weapon_data: {
                hand_on_top: true,
                display_type: "melee_onehand",
                hand_type: 3,
                arm_type: 3,
            },
        },
        variants: [
            {
                sprite: spr_weapon_relic_blade,
            }
        ],
    },
    "Wrist-Mounted Storm Bolter": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_sbolter,
            }
        ],
    },
    "Shotgun": {
        base: {
            weapon_data: {
                display_type: "normal_ranged",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_shotgun,
            }
        ],
    },
    "Omnissian Axe": {
        base: {
            weapon_data: {
                display_type: "melee_onehand",
                hand_type: 3,
                arm_type: 3,
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_omnissian_axe,
            }
        ],
    },
    "Deathwatch Sniper Rifle": {
        base: {
            weapon_data: {
                display_type: "melee_twohand",
                single_left_right_profile: true,
            },
        },
        variants: [
            {
                sprite: spr_weapon_sniper,
            }
        ],
    },
};
