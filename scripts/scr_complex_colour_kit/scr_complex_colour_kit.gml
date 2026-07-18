function coord_relevative_positions(coords, xx, yy) {
    return [
        coords[0] + xx,
        coords[1] + yy,
        coords[2] + xx,
        coords[3] + yy,
    ];
}

function move_location_relative(coords, relative_move_x, relative_move_y) {
    for (var i = 0; i < array_length(coords); i++) {
        if (i % 2 == 0) {
            coords[i] += relative_move_x;
        } else {
            coords[i] += relative_move_y;
        }
    }
    return coords;
}

enum eMARINE_ICONS {
    NONE,
    COMPANY,
    CHAPTER,
    SQUAD,
    ROLE,
}

function get_marine_icon_set(key) {
    var sprite_set = false;
    if (key == eMARINE_ICONS.CHAPTER) {
        sprite_set = global.chapter_symbols;
    } else if (key == eMARINE_ICONS.ROLE) {
        sprite_set = global.role_markings;
    } else if (key == eMARINE_ICONS.SQUAD) {
        sprite_set = global.squad_markings;
    } else if (key == eMARINE_ICONS.COMPANY) {
        sprite_set = global.company_markings;
    }
    return variable_clone(sprite_set);
}

function setup_complex_livery_shader(setup_role, unit = "none") {
    shader_reset();
    shader_set(full_livery_shader);

    var _in_creation = instance_exists(obj_creation);
    var data_set = {};
    var _is_unit = unit != "none";
    if (_in_creation) {
        data_set = variable_clone(obj_creation.livery_picker.map_colour);
        if (obj_creation.livery_selection_options.current_selection == 2) {
            var _base = obj_creation.full_liveries[0];
            var _component_names = struct_get_names(_base);
            for (var i = 0; i < array_length(_component_names); i++) {
                var _component = _component_names[i];
                if (!struct_exists(data_set, _component_names[i])) {
                    data_set[$ _component] = _base[$ _component];
                }
                if (data_set[$ _component] == -1) {
                    data_set[$ _component] = _base[$ _component];
                }
            }
        }
    } else {
        var _full_liveries = obj_ini.full_liveries;
        var _roles = obj_ini.role[100];
        data_set = obj_ini.full_liveries[0];
        if (is_specialist(setup_role, SPECIALISTS_LIBRARIANS)) {
            data_set = _full_liveries[eROLE.LIBRARIAN];
        } else if (is_specialist(setup_role, SPECIALISTS_HEADS)) {
            if (is_specialist(setup_role, SPECIALISTS_APOTHECARIES)) {
                data_set = _full_liveries[eROLE.APOTHECARY];
            } else if (is_specialist(setup_role, SPECIALISTS_TECHS)) {
                data_set = _full_liveries[eROLE.TECHMARINE];
            } else if (is_specialist(setup_role, SPECIALISTS_CHAPLAINS)) {
                data_set = _full_liveries[eROLE.CHAPLAIN];
            }
        } else {
            for (var i = 0; i <= 20; i++) {
                if (_roles[i] == setup_role) {
                    data_set = _full_liveries[i];
                    break;
                }
            }
        }
        if (_is_unit) {
            data_set = variable_clone(data_set);
            var _company_livery = obj_ini.company_liveries[unit.company];
            var _comp_names = struct_get_names(_company_livery);
            for (var i = 0; i < array_length(_comp_names); i++) {
                var _name = _comp_names[i];
                if (_name == "is_changed") {
                    continue;
                }
                if (_company_livery[$ _name] != -1) {
                    data_set[$ _name] = _company_livery[$ _name];
                }
            }
        }
    }
    if (_is_unit) {
        var _names = struct_get_names(unit.personal_livery);
        for (var i = 0; i < array_length(_names); i++) {
            var _area = _names[i];
            data_set[$ _area] = unit.personal_livery[$ _area];
        }
    }

    var spot_names = struct_get_names(data_set);
    var cloth_col = [
        201.0 / 255.0,
        178.0 / 255.0,
        147.0 / 255.0,
    ];
    if (unit != "none") {
        var cloth_variation = unit.body.torso.cloth.variation;

        if (cloth_variation > 10) {
            var _distinct_colours = [];
            for (var i = 0; i < array_length(spot_names); i++) {
                if (spot_names[i] == "eye_lense" || spot_names[i] == "is_changed") {
                    continue;
                }
                var _colour = data_set[$ spot_names[i]];
                if (_colour == -1 || is_array(_colour)) {
                    continue;
                }
                if (!array_contains(_distinct_colours, _colour)) {
                    array_push(_distinct_colours, _colour);
                }
            }
            var _choice = 0;
            if (array_length(_distinct_colours)) {
                _choice = cloth_variation % array_length(_distinct_colours);
                set_complex_shader_area(["robes_colour_replace"], _distinct_colours[_choice]);
            } else {
                shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, "robes_colour_replace"), cloth_col);
            }
        } else {
            shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, "robes_colour_replace"), cloth_col);
        }
    } else {
        shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, "robes_colour_replace"), cloth_col);
    }
    var _textures = {};

    static complex_colour_swaps = {
        left_head: [
            0,
            0,
            128 / 255,
        ],
        right_backpack: [
            181 / 255,
            0,
            255 / 255,
        ],
        left_backpack: [
            104 / 255,
            0,
            168 / 255,
        ],
        right_head: [
            0,
            0,
            1,
        ],
        left_muzzle: [
            128 / 255,
            64 / 255,
            1,
        ],
        right_muzzle: [
            64 / 255,
            128 / 255,
            1,
        ],
        eye_lense: [
            0,
            1,
            0,
        ],
        right_chest: [
            1,
            20 / 255,
            147 / 255,
        ],
        left_chest: [
            128 / 255,
            0,
            128 / 255,
        ],
        right_thorax: [
            0,
            0.75,
            0,
        ],
        left_thorax: [
            0,
            0,
            0.75,
        ],
        right_trim: [
            0,
            128 / 255,
            128 / 255,
        ],
        left_trim: [
            1,
            128 / 255,
            0,
        ],
        metallic_trim: [
            135 / 255,
            130 / 255,
            188 / 255,
        ],
        right_pauldron: [
            1,
            1,
            1,
        ],
        left_pauldron: [
            1,
            1,
            0,
        ],
        right_leg_upper: [
            0,
            128 / 255,
            0,
        ],
        left_leg_upper: [
            255 / 255,
            112 / 255,
            170 / 255,
        ],
        left_leg_knee: [
            1,
            0,
            0,
        ],
        left_leg_lower: [
            128 / 255,
            0,
            0,
        ],
        right_leg_knee: [
            214 / 255,
            194 / 255,
            255 / 255,
        ],
        right_leg_lower: [
            165 / 255,
            84 / 255,
            24 / 255,
        ],
        right_arm: [
            138 / 255,
            218 / 255,
            140 / 255,
        ],
        right_hand: [
            46 / 255,
            169 / 255,
            151 / 255,
        ],
        left_arm: [
            1,
            230 / 255,
            140 / 255,
        ],
        left_hand: [
            1,
            160 / 255,
            112 / 255,
        ],
        company_marks: [
            128 / 255,
            128 / 255,
            0,
        ],
        weapon_primary: [
            0,
            1,
            1,
        ],
        weapon_secondary: [
            1,
            0,
            1,
        ],
    };

    var colours_instance = instance_exists(obj_creation) ? obj_creation : obj_controller;
    var _position_count = array_length(spot_names);
    for (var i = 0; i < _position_count; i++) {
        var _colour_position = spot_names[i];

        var _colour = variable_clone(data_set[$ _colour_position]);

        if (!is_array(_colour)) {
            set_complex_shader_area(_colour_position, _colour);
        } else {
            if (_colour[0] == "texture") {
                if (struct_exists(global.textures, _colour[1])) {
                    var _name = _colour[1];
                    if (!struct_exists(_textures, _name)) {
                        _textures[$ _name] = {
                            texture: global.textures[$ _colour[1]],
                            areas: [complex_colour_swaps[$ _colour_position]],
                        };
                    } else {
                        var _tex_data = _textures[$ _name];
                        array_push(_tex_data.areas, complex_colour_swaps[$ _colour_position]);
                    }
                }
            } else if (_colour[0] == "icon") {
                var _data = _colour[1];
                var sub_key = "";
                var main_key = "";
                var _tex_set = false;
                if (array_contains(["right_pauldron", "left_pauldron"], _colour_position)) {
                    sub_key = "pauldron";
                } else if (array_contains(["right_leg_knee", "left_leg_knee"], _colour_position)) {
                    sub_key = "knees";
                }
                main_key = get_marine_icon_set(_data.type);
                if (sub_key != "" && is_struct(main_key)) {
                    _tex_set = variable_clone(main_key[$ sub_key]);
                }
                if (is_struct(_tex_set)) {
                    if (struct_exists(_tex_set, _data.icon)) {
                        var _name = _data.icon;
                        if (!struct_exists(_textures, _name)) {
                            _textures[$ _name] = {
                                texture: _tex_set[$ _name],
                                areas: [complex_colour_swaps[$ _colour_position]],
                            };
                        } else {
                            var _tex_data = _textures[$ _name];
                            array_push(_tex_data.areas, complex_colour_swaps[$ _colour_position]);
                        }
                    }
                }
                set_complex_shader_area(_colour_position, _data.colour);
            }
        }
    }

    return _textures;
}

function get_shader_colour_from_arrays(colour) {
    var colours_instance = instance_exists(obj_creation) ? obj_creation : obj_controller;
    var colour_set = [
        0,
        0,
        0,
    ];
    try {
        colour_set = [
            colours_instance.col_r[colour] / 255,
            colours_instance.col_g[colour] / 255,
            colours_instance.col_b[colour] / 255,
        ];
    } catch (_exception) {
        ERROR_HANDLER.assert_popup(_exception);
    }

    return colour_set;
}

function set_complex_shader_area(area, colour) {
    if (is_array(area)) {
        for (var i = 0; i < array_length(area); i++) {
            var small_area = area[i];
            colour_set = get_shader_colour_from_arrays(colour);
            shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, small_area), colour_set);
        }
    } else {
        colour_set = get_shader_colour_from_arrays(colour);
        shader_set_uniform_f_array(shader_get_uniform(full_livery_shader, area), colour_set);
    }
}

global.textures = {
    "Hazzards": spr_hazzard_texture,
    "Checks": spr_checker_texture,
    "flora_camo": spr_flora_camo_texture,
    "red_scale": spr_red_scale_texture,
    "smallchecks": spr_checker_texture_small,
    "clearchecks": spr_clear_checker,
    "Checks4": spr_hazzard_texture,
    "Checks5": spr_checker_texture,
};
