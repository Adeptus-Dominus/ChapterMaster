/// @param {String|Array<String>} style
/// @return {Bool}
function scr_has_style(style) {
    var result = false;
    if (!is_array(style)) {
        try {
            if (instance_exists(obj_creation)) {
                result = array_contains(obj_creation.buttons.culture_styles.selections(), style);
            } else {
                result = array_contains(obj_ini.culture_styles, style);
            }
        } catch (_exception) {
            ERROR_HANDLER.handle_exception(_exception);
            result = false;
        }
    } else {
        for (var i = 0; i < array_length(style); i++) {
            result = scr_has_style(style[i]);
            if (result) {
                break;
            }
        }
    }
    return result;
}

/// @param {Array<Real>} data
/// @return {Bool}
function valid_sprite_transform_data(data) {
    return is_array(data) && array_length(data) == 4;
}

/// @desc Returns a transform array that can be used in a shader to align the UVs of _spr2 with _spr1 (takes cropping into account)
/// @param {Asset.GMSprite} _spr1 The sprite align the UVs to
/// @param {Real} _subimg1 The sprite subimage to align the UVs to
/// @param {Asset.GMSprite} _spr2 The sprite with UVs that will be aligned
/// @param {Real} _subimg2 The sprite subimage with UVs that will be aligned
/// @return {Array<Real>}
function sprite_get_uvs_transformed(_spr1, _subimg1, _spr2, _subimg2) {
    //Get the uvs of the sprites
    var _uv1 = sprite_get_uvs(_spr1, _subimg1);
    var _uv2 = sprite_get_uvs(_spr2, _subimg2);

    //Naming convention for variables
    //_{uv}_{value}_{coordinate_space}

    //Get the sprite normalized values for the left and top cropping
    var _uv1_crop_left_sprite_total = _uv1[4] / sprite_get_width(_spr1);
    var _uv1_crop_top_sprite_total = _uv1[5] / sprite_get_height(_spr1);
    var _uv2_crop_left_sprite_total = _uv2[4] / sprite_get_width(_spr2);
    var _uv2_crop_top_sprite_total = _uv2[5] / sprite_get_height(_spr2);
    //These are the left and top crop values as a percentage of the uncropped sprite size

    //Get the sprite size relative to the texture page
    var _uv1_width_texture_page = _uv1[2] - _uv1[0];
    var _uv1_height_texture_page = _uv1[3] - _uv1[1];
    var _uv2_width_texture_page = _uv2[2] - _uv2[0];
    var _uv2_height_texture_page = _uv2[3] - _uv2[1];
    //These are the width and height values of the uncropped sprite sizes relative to the texture page
    //Get the cropped size by subtracting the x1 from the x2 (texture page size)
    //Scale it by the cropped value relative to the uncropped value

    //Get the uncropped sizes on the texture page
    var _uv1_uncropped_width_texture_page = _uv1_width_texture_page / _uv1[6];
    var _uv1_uncropped_height_texture_page = _uv1_height_texture_page / _uv1[7];
    var _uv2_uncropped_width_texture_page = _uv2_width_texture_page / _uv2[6];
    var _uv2_uncropped_height_texture_page = _uv2_height_texture_page / _uv2[7];

    //Get the uncropped coordinates relative to the texture page
    var _uv1_x_texture_page = _uv1[0] - (_uv1_uncropped_width_texture_page * _uv1_crop_left_sprite_total);
    var _uv1_y_texture_page = _uv1[1] - (_uv1_uncropped_height_texture_page * _uv1_crop_top_sprite_total);
    var _uv2_x_texture_page = _uv2[0] - (_uv2_uncropped_width_texture_page * _uv2_crop_left_sprite_total);
    var _uv2_y_texture_page = _uv2[1] - (_uv2_uncropped_height_texture_page * _uv2_crop_top_sprite_total);
    //Get the x&y values by taking the cropped texture page coordinates and subtracting them by the crop amount(cropped sprite percentage) multiplied by the total sprite size(in the texture page)

    //Get the positional offsets
    var _x_scale = _uv2_uncropped_width_texture_page / _uv1_uncropped_width_texture_page;
    var _y_scale = _uv2_uncropped_height_texture_page / _uv1_uncropped_height_texture_page;

    var _x_offset = _uv2_x_texture_page - _uv1_x_texture_page * _x_scale;
    var _y_offset = _uv2_y_texture_page - _uv1_y_texture_page * _y_scale;
    //The script should return a value that transforms uv2 to match uv1 by addition and multiplication
    //It is also inversely applicable to transform uv1 to uv2 by subtraction and division

    //Pack the values into an array and return it
    return [
        _x_offset,
        _y_offset,
        _x_scale,
        _y_scale,
    ];
}

/// @param {Struct.TTRPG_stats} _unit
function ComplexSet(_unit) constructor {
    overides = {};
    subcomponents = {};
    unit_armour = _unit.armour();
    draw_unit = _unit;
    draw_helms = instance_exists(obj_creation) ? obj_creation.draw_helms : obj_controller.draw_helms;

    equipment_data = draw_unit.unit_equipment_data();
    current_texture_draws = {};
    _has_exceptions = false;
    exceptions = [];

    left_arm_data = [];

    right_arm_data = [];

    hand_scratchpads = [
        {
            total: 0,
            sources: [0],
            offsets: [0],
            source_frames: [0],
            flip_x: false,
        },
        {
            total: 0,
            sources: [0],
            offsets: [0],
            source_frames: [0],
            flip_x: true,
        },
    ];

    // Tracks sprites that ComplexSet owns (e.g. weapon duplicates) for cleanup
    owned_sprites = [];

    offsets = [];
    position_overides = {};
    shadow_set = {};

    blocked = [];
    banned = [];
    variation_map = {
        backpack: draw_unit.get_body_data("backpack_variation", "torso"),
        armour: draw_unit.get_body_data("armour_choice", "torso"),
        chest_variants: draw_unit.get_body_data("chest_variation", "torso"),
        thorax_variants: draw_unit.get_body_data("thorax_variation", "torso"),
        leg_variants: draw_unit.get_body_data("leg_variants", "left_leg"),
        left_leg: draw_unit.get_body_data("leg_variants", "left_leg"),
        right_leg: draw_unit.get_body_data("leg_variants", "right_leg"),
        left_shin: draw_unit.get_body_data("shin_variant", "left_leg"),
        right_shin: draw_unit.get_body_data("shin_variant", "right_leg"),
        left_knee: draw_unit.get_body_data("knee_variant", "left_leg"),
        right_knee: draw_unit.get_body_data("knee_variant", "right_leg"),
        left_trim: draw_unit.get_body_data("trim_variation", "left_arm"),
        right_trim: draw_unit.get_body_data("trim_variation", "right_arm"),
        left_arm: draw_unit.get_body_data("variation", "left_arm"),
        right_arm: draw_unit.get_body_data("variation", "right_arm"),
        gorget: draw_unit.get_body_data("variant", "throat"),
        right_pauldron_icons: draw_unit.get_body_data("pad_variation", "right_arm"),
        left_pauldron_icons: draw_unit.get_body_data("pad_variation", "left_arm"),
        right_pauldron_base: draw_unit.get_body_data("pad_variation", "right_arm"),
        left_pauldron_base: draw_unit.get_body_data("pad_variation", "left_arm"),
        right_pauldron_embeleshments: draw_unit.get_body_data("pad_variation", "right_arm"),
        left_pauldron_embeleshments: draw_unit.get_body_data("pad_variation", "left_arm"),
        right_pauldron_hangings: draw_unit.get_body_data("pad_variation", "right_arm"),
        left_pauldron_hangings: draw_unit.get_body_data("pad_variation", "left_arm"),
        left_personal_livery: draw_unit.get_body_data("personal_livery", "left_arm"),
        tabbard: draw_unit.get_body_data("tabbard_variation", "torso"),
        robe: draw_unit.get_body_data("tabbard_variation", "torso"),
        crest: draw_unit.get_body_data("crest_variation", "head"),
        head: draw_unit.get_body_data("variation", "head"),
        bare_head: draw_unit.get_body_data("variation", "head"),
        bare_neck: draw_unit.get_body_data("variation", "head"),
        bare_eyes: draw_unit.get_body_data("variation", "head"),
        mouth_variants: draw_unit.get_body_data("variant", "jaw"),
        left_eye: draw_unit.get_body_data("variant", "left_eye"),
        right_eye: draw_unit.get_body_data("variant", "right_eye"),
        crown: draw_unit.get_body_data("crown_variation", "head"),
        forehead: draw_unit.get_body_data("forehead_variation", "head"),
        backpack_decoration: draw_unit.get_body_data("backpack_decoration_variation", "torso"),
        belt: draw_unit.get_body_data("belt_variation", "torso"),
        cloak: draw_unit.get_body_data("variant", "cloak"),
        cloak_image: draw_unit.get_body_data("image_0", "cloak"),
        cloak_trim: draw_unit.get_body_data("image_1", "cloak"),
        backpack_augment: draw_unit.get_body_data("backpack_augment_variation", "torso"),
        chest_fastening: draw_unit.get_body_data("chest_fastening", "torso"),
        left_weapon: draw_unit.get_body_data("weapon_variation", "left_arm"),
        right_weapon: draw_unit.get_body_data("weapon_variation", "right_arm"),
        necklace: draw_unit.get_body_data("hanging_variant", "throat"),
        foreground_item: draw_unit.get_body_data("variant", "throat"),
    };

    component_final_draw_x = 0;
    component_final_draw_y = 0;
    shadow_enabled = false;
    component_map_choice = 0;

    use_shadow_uniform = shader_get_uniform(full_livery_shader, "use_shadow");
    shadow_transform_uniform = shader_get_uniform(full_livery_shader, "In_Shadow_Transform");

    shadow_sampler = shader_get_sampler_index(full_livery_shader, "shadow_texture");
    armour_shadow_sampler = shader_get_sampler_index(armour_texture, "shadow_texture");
    armour_texture_sampler = shader_get_sampler_index(armour_texture, "armour_texture");

    texture_blend_uniform = shader_get_uniform(armour_texture, "blend");
    texture_blend_colour_uniform = shader_get_uniform(armour_texture, "blend_colour");
    texture_replace_col_uniform = shader_get_uniform(armour_texture, "replace_colour");

    texture_use_shadow_uniform = shader_get_uniform(armour_texture, "use_shadow");
    texture_shadow_transform_uniform = shader_get_uniform(armour_texture, "In_Shadow_Transform");
    texture_mask_transform = shader_get_uniform(armour_texture, "mask_transform");

    if (!surface_exists(global.base_component_surface)) {
        global.base_component_surface = surface_create(600, 600);
    }

    static mk7_bits = {
        armour: spr_mk7_complex,
        left_trim: spr_mk7_left_trim,
        right_trim: spr_mk7_right_trim,
        mouth_variants: spr_mk7_mouth_variants,
        thorax_variants: spr_mk7_thorax_variants,
        head: spr_mk7_head_variants,
        right_knee: spr_mk7_complex_knees,
    };

    static weapon_preset_data = {
        "shield": {
            arm_type: 2,
            ui_spec: true,
        },
        "ranged_twohand": {
            ui_spec: true,
            ui_twoh: true,
        },
        "normal_ranged": {
            arm_type: 1,
        },
        "terminator_ranged": {
            arm_type: 1,
            hand_type: 0,
        },
        "terminator_fist": {
            arm_type: 1,
            ui_spec: true,
        },
        "melee_onehand": {
            hand_on_top: true,
        },
        "melee_twohand": {
            ui_spec: true,
            single_left_right_profile: true,
            hand_type: 2,
            hand_on_top: true,
        },
    };

    static skin_tones = {
        standard: [
            [
                1.0,
                218.0 / 255.0,
                179.0 / 255.0,
            ],
            [
                1.0,
                192.0 / 255.0,
                134.0 / 255.0,
            ],
            [
                252.0 / 255.0,
                206.0 / 255.0,
                159.0 / 255.0,
            ],
            [
                254.0 / 255.0,
                206.0 / 255.0,
                163.0 / 255.0,
            ],
            [
                255.0 / 255.0,
                221.0 / 255.0,
                191.0 / 255.0,
            ],
            [
                230.0 / 255.0,
                177.0 / 255.0,
                131.0 / 255.0,
            ],
            [
                255.0 / 255.0,
                205.0 / 255.0,
                163.0 / 255.0,
            ],
            [
                57.0 / 255.0,
                37.0 / 255.0,
                17.0 / 255.0,
            ],
        ],
        coal: [
            34.0 / 255.0,
            34.0 / 255.0,
            34.0 / 255.0,
        ],
    };

    static head_draw_order = [
        "crest",
        "head",
        "forehead",
        "mouth_variants",
        "left_eye",
        "right_eye",
        "crown",
    ];

    /// @param {Any} exception_key
    /// @return {Bool}
    static check_exception = function(exception_key) {
        if (_has_exceptions) {
            var array_position = array_find_value(exceptions, exception_key);
            if (array_position > -1) {
                array_delete(exceptions, array_position, 1);
                if (array_length(exceptions)) {
                    return true;
                } else {
                    return false;
                }
            } else {
                return false;
            }
        } else {
            return false;
        }
    };

    /// @param {Struct} mod_item
    /// @return {Bool}
    static base_modulars_checks = function(mod_item) {
        _has_exceptions = false;
        var _mod = mod_item;
        exceptions = [];

        // Keys that are mandatory / pass-through data, not optional pass-fail checks.
        var _non_check_keys = [
            "position", "shadows", "overides", "subcomponents", "body_types",
            "offsets", "body_parts", "prevent_others", "assign_by_rank",
        ];
        var _mod_keys = struct_get_names(_mod);
        var _remaining_checks = array_length(_mod_keys);
        for (var nk = 0; nk < array_length(_non_check_keys); nk++) {
            if (struct_exists(_mod, _non_check_keys[nk])) {
                _remaining_checks--;
            }
        }

        // ---------------- MANDATORY CHECKS (always run, never gated) ----------------

        if (struct_exists(_mod, "position")) {
            if (array_contains(blocked, _mod.position)) {
                return false;
            }
        } else {
            _mod.position = "";
        }

        if (!struct_exists(_mod, "body_types")) {
            _mod.body_types = [0, 1, 2];
        }
        if (!array_contains(_mod.body_types, armour_type)) {
            if (!check_exception("body_types")) {
                return false;
            }
        }

        _overides = "none";
        if (struct_exists(_mod, "overides")) {
            _overides = {
                overides: _mod.overides,
            };
        }

        if (struct_exists(_mod, "subcomponents")) {
            _sub_comps = _mod.subcomponents;
        }

        if (struct_exists(_mod, "shadows")) {
            _shadows = _mod.shadows;
        }

        if (struct_exists(_mod, "offsets")) {
            var _x = 0;
            var _y = 0;
            if (struct_exists(_mod.offsets, unit_armour)) {
                var _offset = _mod.offsets[$ unit_armour];
                if (struct_exists(_offset, "x")) {
                    _x += _offset.x;
                }
                if (struct_exists(_offset, "y")) {
                    _y += _offset.y;
                }
            }
            if (_x != 0 || _y != 0) {
                if (_overides == "none") {
                    _overides = {
                        offsets: [_x, _y],
                    };
                } else {
                    _overides.offsets = [_x, _y];
                }
            }
        }

        if (struct_exists(_mod, "body_parts")) {
            var _bp_viable = true;
            var _body_areas = struct_get_names(_mod.body_parts);
            for (var b = 0; b < array_length(_body_areas); b++) {
                var _area = _body_areas[b];
                if (!struct_exists(draw_unit.body[$ _area], _mod.body_parts[$ _area])) {
                    _bp_viable = false;
                    break;
                }
            }
            if (!_bp_viable) {
                if (!check_exception("body_parts")) {
                    return false;
                }
            }
        }

        if (struct_exists(_mod, "prevent_others")) {
            replace_area(_mod.position, _mod.sprite, _overides, _sub_comps, _shadows);
            array_push(blocked, _mod.position);
            if (struct_exists(_mod, "ban")) {
                for (var b = 0; b < array_length(_mod.ban); b++) {
                    if (!array_contains(banned, _mod.ban[b])) {
                        array_push(banned, _mod.ban[b]);
                    }
                }
            }

            return false;
        }

        if (struct_exists(_mod, "assign_by_rank")) {
            var _area = _mod.position;
            var _status_level = _mod.assign_by_rank;
            var _roles = active_roles();
            var tiers = [
                ["Chapter Master"],
                [
                    "Forge Master",
                    "Master of Sanctity",
                    "Master of the Apothecarion",
                    $"Chief {_roles[eROLE.LIBRARIAN]}",
                ],
                [
                    _roles[eROLE.CAPTAIN],
                    _roles[eROLE.HONOURGUARD],
                ],
                [_roles[eROLE.CHAMPION]],
                [
                    _roles[eROLE.ANCIENT],
                    _roles[eROLE.VETERANSERGEANT],
                ],
                [_roles[eROLE.TERMINATOR]],
                [
                    _roles[eROLE.VETERAN],
                    _roles[eROLE.SERGEANT],
                    _roles[eROLE.CHAPLAIN],
                    _roles[eROLE.APOTHECARY],
                    _roles[eROLE.TECHMARINE],
                    _roles[eROLE.LIBRARIAN],
                ],
                [
                    "Codiciery",
                    "Lexicanum",
                    _roles[eROLE.TACTICAL],
                    _roles[eROLE.ASSAULT],
                    _roles[eROLE.DEVASTATOR],
                ],
                [_roles[eROLE.SCOUT]],
            ];

            var _unit_tier = 8;
            if (_unit_tier == 8) {
                for (var t = 0; t < array_length(tiers); t++) {
                    var tier = tiers[t];
                    if (array_contains(tier, draw_unit.role())) {
                        _unit_tier = t;
                    }
                }
            }
            if (_unit_tier >= _status_level) {
                var variation_tier = (_unit_tier - _status_level) + 1;
                if (!struct_exists(variation_map, _area) || variation_map[$ _area] % variation_tier != 0) {
                    return false;
                }
            }
        }

        // Nothing optional left to check - short circuit immediately.
        if (_remaining_checks <= 0) {
            return true;
        }

        // ---------------- OPTIONAL CHECKS (gated, self-terminating) ----------------

        var _max_sat = 100;
        var _control_max_sat = false;
        if (struct_exists(_mod, "max_saturation")) {
            _remaining_checks--;
            _control_max_sat = true;
            _max_sat = _mod.max_saturation;
        }

        if (struct_exists(_mod, "allow_either")) {
            _remaining_checks--;
            _has_exceptions = true;
            exceptions = variable_clone(_mod.allow_either);
            if (_remaining_checks <= 0) return true;
        }

        if (struct_exists(_mod, "exp")) {
            _remaining_checks--;
            var _exp_data = _mod.exp;
            var _min = 0;
            if (struct_exists(_exp_data, "min")) {
                _min = _exp_data.min;
                if (draw_unit.experience < _exp_data.min) {
                    if (!check_exception("min_exp")) {
                        return false;
                    }
                }
            }
            if (struct_exists(_exp_data, "scale")) {
                var _m_exp = _exp_data.exp_scale_max;
                var _increment_count = max(1, floor(_mod.max_saturation / 5));
                var _increments = (_m_exp - _min) / _increment_count;
                var _sat_roof = _mod.max_saturation;
                var _unit_exp = draw_unit.experience;

                if (_unit_exp >= _m_exp) {
                    spawn_chance = _mod.max_saturation;
                } else {
                    var calc_exp = max(0, _unit_exp - _min);
                    var _increment = floor(calc_exp / _increments);
                    _max_sat = clamp(_increment * 5, 0, _mod.max_saturation);
                }
            }
            if (_remaining_checks <= 0 && !_control_max_sat) return true;
        }

        if (_control_max_sat) {
            if (struct_exists(variation_map, _mod.position)) {
                if (variation_map[$ _mod.position] >= _max_sat) {
                    if (!check_exception("max_saturation")) {
                        return false;
                    }
                }
            }
            if (_remaining_checks <= 0) return true;
        }

        if (struct_exists(_mod, "role_type")) {
            _remaining_checks--;
            var _viable = false;
            for (var a = 0; a < array_length(_mod.role_type); a++) {
                var _r_t = _mod.role_type[a];
                _viable = draw_unit.IsSpecialist(_r_t);
                if (_viable) {
                    break;
                }
            }
            if (!_viable) {
                if (!check_exception("role_type")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }
        if (struct_exists(_mod, "roles")) {
            _remaining_checks--;
            if (!array_contains(_mod.roles, draw_unit.role())) {
                if (!check_exception("roles")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }
        if (struct_exists(_mod, "cultures")) {
            _remaining_checks--;
            if (!scr_has_style(_mod.cultures)) {
                if (!check_exception("cultures")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }
        if (struct_exists(_mod, "company")) {
            _remaining_checks--;
            if (!array_contains(_mod.company, draw_unit.company)) {
                if (!check_exception("company")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }

        if (struct_exists(_mod, "armours")) {
            _remaining_checks--;
            if (!array_contains(_mod.armours, unit_armour)) {
                if (!check_exception("armours")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }
        if (struct_exists(_mod, "armours_exclude")) {
            _remaining_checks--;
            if (array_contains(_mod.armours_exclude, unit_armour)) {
                if (!check_exception("armours_exclude")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }
        if (struct_exists(_mod, "chapter_adv")) {
            _remaining_checks--;
            var _viable = false;
            for (var a = 0; a < array_length(_mod.chapter_adv); a++) {
                var _adv = _mod.chapter_adv[a];
                _viable = scr_has_adv(_adv);
                if (_viable) {
                    break;
                }
            }
            if (!_viable) {
                if (!check_exception("chapter_adv")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }
        if (struct_exists(_mod, "chapter_disadv")) {
            _remaining_checks--;
            var _viable = false;
            for (var a = 0; a < array_length(_mod.chapter_disadv); a++) {
                var _disadv = _mod.chapter_disadv[a];
                _viable = scr_has_disadv(_disadv);
                if (_viable) {
                    break;
                }
            }
            if (!_viable) {
                if (!check_exception("chapter_disadv")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }
        if (struct_exists(_mod, "stats")) {
            _remaining_checks--;
            if (!stat_valuator(_mod.stats, draw_unit)) {
                if (!check_exception("stats")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }
        if (struct_exists(_mod, "equipped")) {
            _remaining_checks--;
            if (!draw_unit.has_equipped(_mod.equipped)) {
                if (!check_exception("equipped")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }

        if (struct_exists(_mod, "traits")) {
            _remaining_checks--;
            var _viable = false;
            for (var a = 0; a < array_length(_mod.traits); a++) {
                var _trait = _mod.traits[a];
                _viable = draw_unit.has_trait(_trait);
                if (_viable) {
                    break;
                }
            }
            if (!_viable) {
                if (!check_exception("traits")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }


        if (struct_exists(_mod, "equipment_has_tag")) {
            _remaining_checks--;
            var _viable = false;
            var _tag_check_areas = struct_get_names(_mod.equipment_has_tag);
            for (var i = 0; i < array_length(_tag_check_areas); i++) {
                var _area = _tag_check_areas[i];

                if (!array_contains(equipment_data.present_items, _area)) {
                    continue;
                }

                var _item = equipment_data.get_item(_area);
                var _tag = _mod.equipment_has_tag[$ _area];

                _viable = _item.has_tag(_tag);

                if (_viable) {
                    break;
                }
            }
            if (!_viable) {
                if (!check_exception("equipment_has_tag")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }

        var _is_weapon = _mod.position == "weapon";
        if (!_is_weapon && struct_exists(_mod, "min_quality")) {
            _remaining_checks--;
            var _viable = false;
            var _quality_check_areas = struct_get_names(_mod.min_quality);
            for (var i = 0; i < array_length(_quality_check_areas); i++) {
                var _area = _quality_check_areas[i];
                if (!array_contains(equipment_data.present_items, _area)) {
                    break;
                }
                var _item = equipment_data.get_item(_area);

                _viable = compare_qualities(_item.quality, _mod.min_quality[$ _area], "more");
                if (_viable) {
                    break;
                }
            }
            if (!_viable) {
                if (!check_exception("min_quality")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }

        if (!_is_weapon && struct_exists(_mod, "max_quality")) {
            _remaining_checks--;
            var _viable = false;
            var _quality_check_areas = struct_get_names(_mod.max_quality);
            for (var i = 0; i < array_length(_quality_check_areas); i++) {
                var _area = _quality_check_areas[i];
                if (!array_contains(equipment_data.present_items, _area)) {
                    break;
                }
                var _item = equipment_data.get_item(_area);

                _viable = compare_qualities(_item.quality, _mod.max_quality[$ _area], "less");
                if (_viable) {
                    break;
                }
            }
            if (!_viable) {
                if (!check_exception("max_quality")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }

        if (struct_exists(_mod, "chapter")) {
            _remaining_checks--;
            var chap_name = instance_exists(obj_creation) ? obj_creation.chapter_name : global.chapter_name;
            if (chap_name != _mod.chapter) {
                if (!check_exception("chapter")) {
                    return false;
                }
            }
            if (_remaining_checks <= 0) return true;
        }

        return true;
    };
    /// @param {Array<Struct>} modulars
    /// @param {String} position
    static assign_modulars = function(modulars = global.modular_drawing_items, position = "", replace_by_default = false) {
        try {
            for (var i = 0; i < array_length(modulars); i++) {
                _sub_comps = "none";
                _shadows = "none";
                var _mod = modulars[i];
                if (position != "") {
                    _mod.position = position;
                }
                var _allowed = base_modulars_checks(_mod);

                if (!_allowed) {
                    continue;
                }
                if (_mod.position != "") {
                    if (_mod.position == "weapon") {
                        var _weapon_map = _mod.weapon_map;
                        var _weapon_one = equipment_data.get_item("wep1");
                        var _weapon_two = equipment_data.get_item("wep2");

                        var _quality_ok = function(_item, _mod) {
                            if (struct_exists(_mod, "min_quality")) {
                                if (!compare_qualities(_item.quality, _mod.min_quality, "more")) {
                                    return false;
                                }
                            }
                            if (struct_exists(_mod, "max_quality")) {
                                if (!compare_qualities(_item.quality, _mod.max_quality, "less")) {
                                    return false;
                                }
                            }
                            return true;
                        };

                        if (_weapon_one.name == _weapon_map && _quality_ok(_weapon_one, _mod)) {
                            array_push(right_arm_data, _mod.weapon_data);
                        }

                        if (_weapon_two.name == _weapon_map && _quality_ok(_weapon_two, _mod)) {
                            array_push(left_arm_data, _mod.weapon_data);
                        }
                    } else {
                        if (replace_by_default){
                            replace_area(_mod.position, _mod.sprite, _overides, _sub_comps, _shadows);
                        } else {
                            add_to_area(_mod.position, _mod.sprite, _overides, _sub_comps, _shadows);
                        }
                        
                    }
                }
                if (struct_exists(_mod, "prevent_others")) {
                    replace_area(_mod.position, _mod.sprite, _overides, _sub_comps, _shadows);
                    array_push(blocked, _mod.position);
                    if (struct_exists(_mod, "ban")) {
                        for (var b = 0; b < array_length(_mod.ban); b++) {
                            if (!array_contains(banned, _mod.ban[b])) {
                                array_push(banned, _mod.ban[b]);
                            }
                        }
                    }
                }
            }
        } catch (_exception) {
            ERROR_HANDLER.handle_exception(_exception);
        }
    };

    /// @param {String} component_name
    /// @param {Real} choice
    static check_component_overides = function(component_name, choice) {
        if (!struct_exists(overides, component_name)) {
            return false;
        }

        var _overide_set = overides[$ component_name];
        for (var i = 0; i < array_length(_overide_set); i++) {
            var _spec_over = _overide_set[i];
            if (_spec_over[0] <= choice && _spec_over[1] > choice) {
                var _override_data = _spec_over[2];
                if (struct_exists(_override_data, "overides")) {
                    _override_areas = struct_get_names(_override_data.overides);
                    var _overs = _override_data.overides;
                    for (var j = 0; j < array_length(_override_areas); j++) {
                        var _area = _override_areas[j]
                        var _override_packet = _overs[$ _area];
                        _override_packet = is_struct(_override_packet) ? _override_packet : {sprite : _override_packet};
                        assign_modulars([_override_packet], _area, true);
                    }
                }
                if (struct_exists(_override_data, "offsets")) {
                    var _offsets = _override_data.offsets;
                    component_final_draw_x += _offsets[0];
                    component_final_draw_y += _offsets[1];
                }
                break;
            }
        }
  
    };

    /// @desc Resolves a global frame choice for an area into (source_sprite, local_frame)
    /// @param {String} _area_name
    /// @param {Real} _global_choice
    /// @return {Struct|Undefined}
    static resolve_area = function(_area_name, _global_choice) {
        if (!struct_exists(self, _area_name)) {
            return;
        }

        var _area_data = self[$ _area_name];
        if (is_struct(_area_data)) {
            // Composite area with source references
            var _total = _area_data.total;
            var _choice = _global_choice % _total;
            for (var i = 0; i < array_length(_area_data.sources); i++) {
                if (_choice < _area_data.offsets[i] + _area_data.source_frames[i]) {
                    return {
                        sprite: _area_data.sources[i],
                        frame: _choice - _area_data.offsets[i],
                    };
                }
            }

            return;
        }

        // Raw sprite ID (complex_helms head, or backward compat)
        if (!sprite_exists(_area_data)) {
            return;
        }

        return {
            sprite: _area_data,
            frame: _global_choice % sprite_get_number(_area_data),
        };
    };

    /// @desc Gets the total number of frames for an area
    /// @param {String} area_name
    /// @return {Real}
    static area_total_frames = function(area_name) {
        if (!struct_exists(self, area_name)) {
            return 0;
        }

        var _area_data = self[$ area_name];
        if (is_struct(_area_data)) {
            return _area_data.total;
        }

        if (sprite_exists(_area_data)) {
            return sprite_get_number(_area_data);
        }

        return 0;
    };

    /// @param {String} component_name
    /// @param {Real} choice
    /// @param {Asset.GMSprite} resolved_sprite
    /// @param {Real} resolved_frame
    static set_component_shadow_packs = function(component_name, choice, resolved_sprite, resolved_frame) {
        if (struct_exists(shadow_set, component_name)) {
            var _shadow_set = shadow_set[$ component_name];
            for (var i = 0; i < array_length(_shadow_set); i++) {
                var _spec_shadow = _shadow_set[i];
                if (_spec_shadow[0] <= choice && _spec_shadow[1] > choice) {
                    var _shadow_item = _spec_shadow[2];
                    var _final_shadow_index = choice - _spec_shadow[0];
                    set_draw_shadows(resolved_sprite, resolved_frame, _shadow_item, _final_shadow_index);
					break;
                }
            }
        }
    };

    static set_draw_shadows = function(sprite, resolved_frame, _shadow_item, _final_shadow_index){
        // Compute UV transform for this shadow texture
        if (!sprite_exists(sprite) || !sprite_exists(_shadow_item)) {
            exit;
        }

        var _shadow_transform_data = sprite_get_uvs_transformed(sprite, resolved_frame, _shadow_item, _final_shadow_index);

        if (valid_sprite_transform_data(_shadow_transform_data)) {
            shader_set_uniform_f_array(shadow_transform_uniform, _shadow_transform_data);

            shader_set_uniform_f_array(texture_shadow_transform_uniform, _shadow_transform_data);
        }

        // Bind shadow texture
        var _shadow_tex = sprite_get_texture(_shadow_item, _final_shadow_index);
        texture_set_stage(shadow_sampler, _shadow_tex);
        texture_set_stage(armour_shadow_sampler, _shadow_tex);

        // Trigger the draw to apply shadow (shader mixes it)
        //draw_sprite(_sprite, _choice ?? 0, component_final_draw_x, component_final_draw_y);

        shadow_enabled = true;        
    }

/// @param {String} component_name
    /// @param {Real} choice
    static handle_component_subcomponents = function(component_name, choice, flip_x = false, component_map_choice = 3) {
        if (struct_exists(subcomponents, component_name)) {
            var _component_set;
            var _subcomponents_found = false;
            var _component_bulk_set = subcomponents[$ component_name];
            for (var i = 0; i < array_length(_component_bulk_set); i++) {
                var _spec_over = _component_bulk_set[i];
                if (_spec_over[0] <= choice && _spec_over[1] > choice) {
                    _subcomponents_found = true;
                    _component_set = _spec_over[2];
                }
            }
            if (_subcomponents_found) {
                evaluate_sub_components(_component_set, component_map_choice, flip_x);
            }
        }
    };

    /// @param {Array<Array>} _component_set
    /// @param {Real} component_map_choice
    /// @param {Bool} flip_x
    static evaluate_sub_components = function(_component_set, component_map_choice, flip_x) {
        for (var i = 0; i < array_length(_component_set); i++) {
            shadow_enabled = false;
            var _subcomponents = _component_set[i];

            var _sub_choice = (component_map_choice * 1315423911) & $7FFFFFFF;
            var _total_options = 0;
            for (var s = 0; s < array_length(_subcomponents); s++) {
                _total_options += sprite_get_number(_subcomponents[s].sprite);
            }
            if (_total_options > 0) {
                var _sub_choice_final = _sub_choice % _total_options;
                var _choice_count = 0;
                for (var s = 0; s < array_length(_subcomponents); s++) {
                    var _final_component = _subcomponents[s];
                    var _sprite = _final_component.sprite;
                    if (_sub_choice_final >= _choice_count && _sub_choice_final < _choice_count + sprite_get_number(_sprite)) {
                        var _final_index = _sub_choice_final - _choice_count ?? 0;
                        if (struct_exists(_final_component, "shadows")) {
                            set_draw_shadows(_sprite, _final_index, _final_component.shadows, _final_index);
                        }
                        shader_set_uniform_i(use_shadow_uniform, shadow_enabled);
                        if (flip_x) {
                            draw_sprite_flipped(_sprite, _sub_choice_final - _choice_count ?? 0, component_final_draw_x, component_final_draw_y);
                        } else {
                            draw_sprite(_sprite, _sub_choice_final - _choice_count ?? 0, component_final_draw_x, component_final_draw_y);
                        }
                        break;
                    } else {
                        _choice_count += sprite_get_number(_sprite);
                    }
                }
            }
        }
    };

    /// @param {Asset.GMSprite} resolved_sprite
    /// @param {Real} resolved_choice
    /// @param {String} component_name
    /// @param {Bool} flip_x
    static draw_component_with_textures = function(resolved_sprite, resolved_choice, component_name, flip_x = false) {
        var _return_surface = surface_get_target();
        surface_reset_target();
        shader_reset();

        surface_set_target(global.base_component_surface);
        draw_clear_alpha(c_black, 0);

        shader_set(armour_texture);
        shader_set_uniform_i(texture_use_shadow_uniform, shadow_enabled);
        set_component_shadow_packs(component_name, resolved_original_choice, resolved_sprite, resolved_choice);

        var _tex_names = struct_get_names(current_texture_draws);
        for (var i = 0; i < array_length(_tex_names); i++) {
            var _tex_name = _tex_names[i];
            var _tex_data = current_texture_draws[$ _tex_name];

            var tex_frame = 0;
            if (component_name == "left_pauldron_base") {
                tex_frame = 1;
            }

            var tex_texture = sprite_get_texture(_tex_data.texture, tex_frame);

            //TODO fix texture colour blending
            /*var _blend = 0;
			if (struct_exists(_tex_data, "blend")) {
				_blend = 1;
			}


			shader_set_uniform_i(texture_blend_uniform, _blend);

			if (_blend) {
				shader_set_uniform_f_array(texture_blend_colour_uniform, _tex_data.blend);
			}
			*/

            for (var t = 0; t < array_length(_tex_data.areas); t++) {
                var _mask_transform_data = sprite_get_uvs_transformed(resolved_sprite, resolved_choice, _tex_data.texture, tex_frame);
                if (!valid_sprite_transform_data(_mask_transform_data)) {
                    continue;
                }
                shader_set_uniform_f_array(texture_mask_transform, _mask_transform_data);
                texture_set_stage(armour_texture_sampler, tex_texture);
                shader_set_uniform_f_array(texture_replace_col_uniform, _tex_data.areas[t]);

                if (flip_x) {
                    draw_sprite_flipped(resolved_sprite, resolved_choice, component_final_draw_x, component_final_draw_y);
                } else {
                    draw_sprite(resolved_sprite, resolved_choice, component_final_draw_x, component_final_draw_y);
                }
            }
        }

        surface_reset_target();
        surface_set_target(_return_surface);
        shader_reset();

        shader_set(full_livery_shader);
        set_component_shadow_packs(component_name, resolved_original_choice, resolved_sprite, resolved_choice);

        if (flip_x) {
            draw_sprite_flipped(resolved_sprite, resolved_choice ?? 0, component_final_draw_x, component_final_draw_y);
        } else {
            draw_sprite(resolved_sprite, resolved_choice ?? 0, component_final_draw_x, component_final_draw_y);
        }
        draw_surface(global.base_component_surface, 0, 0);
    };

    /// @desc Main function
    /// @param {String} component_name
    /// @param {Struct} texture_draws
    /// @param {Real} choice_lock
    static draw_component = function(component_name, texture_draws = undefined, choice_lock = -1) {
        texture_draws ??= {};
        if (array_contains(banned, component_name)) {
            return;
        }
        if (struct_exists(self, component_name)) {
            shadow_enabled = false;
            current_texture_draws = texture_draws;

            component_final_draw_x = x_surface_offset;
            component_final_draw_y = y_surface_offset;

            var _choice = 0;
            var component_map_choice = 3;
            if (struct_exists(variation_map, component_name) && choice_lock == -1) {
                component_map_choice = variation_map[$ component_name];
                _choice = component_map_choice % area_total_frames(component_name);
            } else if (choice_lock > -1) {
                _choice = choice_lock;
            }

            // Resolve to (source_sprite, local_frame)
            var _resolved = resolve_area(component_name, _choice);
            if (!is_struct(_resolved) || !sprite_exists(_resolved.sprite)) {
                return;
            }

            resolved_original_choice = _choice;

            check_component_overides(component_name, _choice);
            set_component_shadow_packs(component_name, _choice, _resolved.sprite, _resolved.frame);

            shader_set_uniform_i(use_shadow_uniform, shadow_enabled);

            var _flip_x = false;
            var _component_data = self[$ component_name];
            if (is_struct(_component_data) && struct_exists(_component_data, "flip_x") && _component_data.flip_x) {
                _flip_x = true;
            }

            var _tex_names = struct_get_names(texture_draws);
            if (_flip_x && array_length(_tex_names) == 0) {
                draw_sprite_flipped(_resolved.sprite, _resolved.frame ?? 0, component_final_draw_x, component_final_draw_y);
            } else if (array_length(_tex_names) > 0) {
                draw_component_with_textures(_resolved.sprite, _resolved.frame, component_name, _flip_x);
            } else {
                draw_sprite(_resolved.sprite, _resolved.frame ?? 0, component_final_draw_x, component_final_draw_y);
            }

            handle_component_subcomponents(component_name, _choice, _flip_x, component_map_choice);
        }
    };

    /// @param {Struct} texture_draws
    static draw_unit_arms = function(texture_draws = undefined) {
        texture_draws ??= {};
        var _bionic_options = [];
        if (array_contains([eARMOUR_TYPE.NORMAL, eARMOUR_TYPE.TERMINATOR, eARMOUR_TYPE.SCOUT], armour_type)) {
            for (var _right_left = 0; _right_left <= 1; _right_left++) {
                var _arm_data = arms_data[_right_left];
                var _variant = _arm_data.arm_type;
                if (_variant == 0 && _arm_data.sprite != 0) {
                    continue;
                }

                var _arm_string = _right_left == 0 ? "right_arm" : "left_arm";
                var _bionic_arm = draw_unit.get_body_data("bionic", _arm_string);
                var _bio = [];
                if (eARMOUR_TYPE.TERMINATOR == armour_type) {
                    if (_variant == 2) {
                        _bio = [
                            spr_terminator_complex_arms_upper_right,
                            spr_terminator_complex_arms_upper_left,
                        ];
                    } else if (_variant == 3) {
                        _bio = [
                            spr_terminator_complex_arm_hidden_right,
                            spr_terminator_complex_arm_hidden_left,
                        ];
                    }
                } else {
                    if (_variant == 2 || _variant == 3) {
                        continue;
                    }
                }
                if (_bionic_arm && !array_length(_bio)) {
                    if (armour_type == eARMOUR_TYPE.NORMAL) {
                        _bio = [
                            spr_bionic_right_arm,
                            spr_bionic_left_arm,
                        ];
                    } else if (armour_type == eARMOUR_TYPE.TERMINATOR) {
                        _bio = [
                            spr_indomitus_right_arm_bionic,
                            spr_indomitus_left_arm_bionic,
                        ];
                    }
                }
                if (array_length(_bio)) {
                    replace_area(_arm_string, _bio[_right_left]);
                }
                draw_component(_arm_string, texture_draws);
            }
        }
    };

    /// @param {Real} right_left
    /// @param {Struct} texture_draws
    static draw_unit_hands = function(right_left, texture_draws = undefined) {
        texture_draws ??= {};
        var _arm_data = arms_data[right_left];
        if (_arm_data.arm_type == 1) {
            return;
        }
        var _hand = _arm_data.hand_type;

        if (armour_type != eARMOUR_TYPE.NONE) {
            var offset_x = x_surface_offset;
            var offset_y = y_surface_offset;
            var _hand_spr = spr_pa_hands;
            switch (armour_type) {
                case eARMOUR_TYPE.TERMINATOR:
                    _hand_spr = spr_terminator_hands;
                    break;
                case eARMOUR_TYPE.SCOUT:
                    _hand_spr = spr_pa_hands;
                    offset_y += 11;
                    offset_x += _arm_data.ui_xmod;
                    break;
                default:
                case eARMOUR_TYPE.NORMAL:
                    _hand_spr = spr_pa_hands;
                    break;
            }
            if (_hand > 0) {
                var _spr_index = (_hand - 1) * 2;
                var _hand_string = right_left == 0 ? "right_hand" : "left_hand";
                var _old_x = x_surface_offset;
                var _old_y = y_surface_offset;
                x_surface_offset = offset_x;
                y_surface_offset = offset_y;

                var _old_hand_struct = struct_exists(self, _hand_string) ? self[$ _hand_string] : undefined;

                var _scratchpad = hand_scratchpads[right_left];
                var _num_frames = sprite_get_number(_hand_spr);
                _scratchpad.total = _num_frames;
                _scratchpad.sources[0] = _hand_spr;
                _scratchpad.source_frames[0] = _num_frames;
                _scratchpad.flip_x = right_left == 1;

                self[$ _hand_string] = _scratchpad;
                draw_component(_hand_string, texture_draws, _spr_index);

                if (_old_hand_struct == undefined) {
                    struct_remove(self, _hand_string);
                } else {
                    self[$ _hand_string] = _old_hand_struct;
                }
                x_surface_offset = _old_x;
                y_surface_offset = _old_y;
            }
            // Draw bionic hands
            if (_hand == 1) {
                if (armour_type == eARMOUR_TYPE.NORMAL && !hide_bionics && struct_exists(body[$ (right_left == 0 ? "right_arm" : "left_arm")], "bionic")) {
                    var bionic_hand = body[$ (right_left == 0 ? "right_arm" : "left_arm")][$ "bionic"];
                    var bionic_spr_index = bionic_hand.variant * 2;
                    var _bionic_hand_string = right_left == 0 ? "right_hand" : "left_hand";
                    var _old_x = x_surface_offset;
                    var _old_y = y_surface_offset;
                    x_surface_offset = offset_x;
                    y_surface_offset = offset_y;

                    var _old_bionic_struct = struct_exists(self, _bionic_hand_string) ? self[$ _bionic_hand_string] : undefined;

                    var _scratchpad = hand_scratchpads[right_left];
                    var _num_frames = sprite_get_number(spr_bionics_hand);
                    _scratchpad.total = _num_frames;
                    _scratchpad.sources[0] = spr_bionics_hand;
                    _scratchpad.source_frames[0] = _num_frames;
                    _scratchpad.flip_x = right_left == 1;

                    self[$ _bionic_hand_string] = _scratchpad;
                    draw_component(_bionic_hand_string, texture_draws, bionic_spr_index);

                    if (_old_bionic_struct == undefined) {
                        struct_remove(self, _bionic_hand_string);
                    } else {
                        self[$ _bionic_hand_string] = _old_bionic_struct;
                    }
                    x_surface_offset = _old_x;
                    y_surface_offset = _old_y;
                }
            }
        }
    };

    /// @param {Struct} texture_draws
    static draw_weapon_and_hands = function(texture_draws = undefined) {
        texture_draws ??= {};
        //if (armour_type == eARMOUR_TYPE.DREADNOUGHT) {
        //    if ((weapon_right.sprite != 0) && sprite_exists(weapon_right.sprite)) {
        //        draw_sprite(weapon_right.sprite, 0, x_surface_offset + weapon_right.ui_xmod, y_surface_offset + weapon_right.ui_ymod);
        //    }
        //    if ((weapon_left.sprite != 0) && sprite_exists(weapon_left.sprite)) {
        //        draw_sprite(weapon_left.sprite, 1, x_surface_offset + weapon_left.ui_xmod, y_surface_offset + weapon_left.ui_ymod);
        //     }
        //    exit;
        //  }
        // Draw hands bellow the weapon sprite;
        if (!weapon_right.ui_twoh && !weapon_left.ui_twoh) {
            for (var i = 0; i <= 1; i++) {
                var _arm_data = arms_data[i];
                if (!_arm_data.hand_on_top) {
                    draw_unit_hands(i, texture_draws);
                }
            }
        }

        // // Draw weapons

        if (!weapon_right.single_left_right_profile) {
            if ((weapon_right.sprite != 0) && sprite_exists(weapon_right.sprite)) {
                if ((weapon_right.ui_twoh == false && weapon_left.ui_twoh == false) || weapon_right.ui_twoh == true) {
                    draw_weapon(weapon_right, "right_weapon", 0, texture_draws);
                }
            }
        } else {
            if ((weapon_right.sprite != 0) && sprite_exists(weapon_right.sprite)) {
                draw_weapon(weapon_right, "right_weapon", -1, texture_draws);
            }
        }

        if (!weapon_left.single_left_right_profile) {
            if ((weapon_left.sprite != 0) && sprite_exists(weapon_left.sprite) && (weapon_right.ui_twoh == false)) {
                draw_weapon(weapon_left, "left_weapon", 1, texture_draws);
            }
        } else {
            if ((weapon_left.sprite != 0) && sprite_exists(weapon_left.sprite) && (weapon_right.ui_twoh == false)) {
                weapon_left.flip_x = true;
                draw_weapon(weapon_left, "left_weapon", -1, texture_draws);
            }
        }
        if (!weapon_right.ui_twoh && !weapon_left.ui_twoh) {
            for (var i = 0; i <= 1; i++) {
                var _arm_data = arms_data[i];
                if (_arm_data.hand_on_top) {
                    draw_unit_hands(i, texture_draws);
                }
            }
        }
    };

    /// @param {Struct} weapon
    /// @param {String} position
    /// @param {Real} choice_lock
    /// @param {Struct} texture_draws
    static draw_weapon = function(weapon, position, choice_lock = -1, texture_draws = undefined) {
        texture_draws ??= {};
        x_surface_offset += weapon.ui_xmod;
        y_surface_offset += weapon.ui_ymod;

        var _subs = struct_exists(weapon, "subcomponents") ? weapon.subcomponents : "none";

        var _shadows = struct_exists(weapon, "shadows") ? weapon.shadows : "none";

        add_to_area(position, weapon.sprite, "none", _subs, _shadows);

        if (struct_exists(self, position)) {
            var _component_data = self[$ position];
            if (is_struct(_component_data)) {
                _component_data.flip_x = struct_exists(weapon, "flip_x") && weapon.flip_x;
            }
        }

        draw_component(position, texture_draws, choice_lock);

        x_surface_offset -= weapon.ui_xmod;
        y_surface_offset -= weapon.ui_ymod;
    };

    static draw = function() {
        var _final_surface = surface_get_target();
        surface_reset_target();
        var prep_surface = surface_create(600, 600);
        surface_set_target(prep_surface);

        var _texture_draws = setup_complex_livery_shader(draw_unit.role(), draw_unit);

        draw_cloaks();

        if (array_length(left_arm_data)) {
            weapon_left = variable_clone(left_arm_data[variation_map.left_weapon % array_length(left_arm_data)]);
        } else {
            weapon_left = {};
        }
        if (array_length(right_arm_data)) {
            weapon_right = variable_clone(right_arm_data[variation_map.right_weapon % array_length(right_arm_data)]);
        } else {
            weapon_right = {};
        }

        arms_data = [
            weapon_right,
            weapon_left,
        ];
        for (var i = 0; i <= 1; i++) {
            var _arm = arms_data[i];
            var _wep = i == 0 ? draw_unit.weapon_one() : draw_unit.weapon_two();
            if (struct_exists(_arm, "display_type")) {
                if (struct_exists(weapon_preset_data, _arm.display_type)) {
                    var _preset = weapon_preset_data[$ _arm.display_type];
                    var _preset_keys = struct_get_names(_preset);
                    for (var s = 0; s < array_length(_preset_keys); s++) {
                        var _set = _preset_keys[s];
                        _arm[$ _set] = _preset[$ _set];
                    }
                }
            }
            var _defaults = [
                "hand_on_top",
                "ui_xmod",
                "ui_ymod",
                "hand_type",
                "arm_type",
                "ui_weapon",
                "single_left_right_profile",
                "ui_twoh",
                "ui_spec",
                "sprite",
                "display_type",
            ];
            for (var s = 0; s < array_length(_defaults); s++) {
                if (!struct_exists(_arm, _defaults[s])) {
                    _arm[$ _defaults[s]] = 0;
                }
            }
            if (armour_type == eARMOUR_TYPE.TERMINATOR && !array_contains(["terminator_ranged", "terminator_melee", "terminator_fist"], _arm.display_type)) {
                _arm.ui_ymod -= 20;
                if (_arm.display_type == "normal_ranged") {
                    if (_arm.single_left_right_profile) {
                        _arm.ui_xmod += 24;
                    } else {
                        _arm.ui_xmod -= 24;
                    }
                    _arm.ui_ymod += 24;
                }
                if (_arm.display_type == "melee_onehand" && _wep != "Company Standard") {
                    if (!_arm.hand_type) {
                        _arm.arm_type = 2;
                        _arm.hand_type = 2;
                    }
                    _arm.ui_xmod -= 14;
                    _arm.ui_ymod += 23;
                }

                if (_arm.display_type == "melee_twohand") {
                    weapon_right.arm_type = 2;
                    weapon_left.arm_type = 2;
                    weapon_right.hand_type = 3;
                    weapon_left.hand_type = 4;
                    _arm.ui_ymod += 25;
                }

                if (_arm.display_type == "ranged_twohand") {
                    weapon_right.arm_type = 2;
                    weapon_left.arm_type = 2;
                    weapon_right.hand_type = 0;
                    weapon_left.hand_type = 0;
                    _arm.ui_ymod += 15;
                }
            } else if (armour_type == eARMOUR_TYPE.SCOUT) {
                _arm.ui_xmod += 4;
                _arm.ui_ymod += 11;
            }
        }
        draw_unit_arms(_texture_draws);
        var _complex_helm = false;
        var _unit_role = draw_unit.role();
        var _role = active_roles();
        var _comp_helms = instance_exists(obj_creation) ? obj_creation.complex_livery_data : obj_ini.complex_livery_data;
        if (_unit_role == _role[eROLE.SERGEANT]) {
            _complex_helm = _comp_helms.sgt;
        } else if (_unit_role == _role[eROLE.VETERANSERGEANT]) {
            _complex_helm = _comp_helms.vet_sgt;
        } else if (_unit_role == _role[eROLE.CAPTAIN]) {
            _complex_helm = _comp_helms.captain;
        } else if (_unit_role == _role[eROLE.VETERAN] || (_unit_role == _role[eROLE.TERMINATOR] && draw_unit.company == 1)) {
            _complex_helm = _comp_helms.veteran;
        } else if (struct_exists(_comp_helms, "all_others")) {
            // there's probably room to improve this but consecrators demand the stripe
            _complex_helm = _comp_helms.all_others;
        }
        if (is_struct(_complex_helm) && struct_exists(self, "head") && draw_helms) {
            complex_helms(_complex_helm);
        }

        var _draw_order = [
            "backpack",
            "backpack_augment",
            "backpack_decoration",
            "armour",
            "thorax_variants",
            "chest_variants",
            "chest_fastening",
            "leg_variants",
            "left_leg",
            "left_shin",
            "right_leg",
            "right_shin",
            "knees",
            "left_knee",
            "right_knee",
            "head",
            "gorget",
            "necklace",
            "left_pauldron_base",
            "right_pauldron_base",
            "left_trim",
            "right_trim",
            "right_pauldron_icons",
            "left_pauldron_icons",
            "right_pauldron_embeleshments",
            "left_pauldron_embeleshments",
            "right_pauldron_hangings",
            "left_pauldron_hangings",
            "tabbard",
            "robe",
            "belt",
            "left_personal_livery",
            "foreground_item",
        ];

        if (unit_armour == "MK4 Maximus" || unit_armour == "MK3 Iron Armour") {
            _draw_order = [
                "backpack",
                "backpack_augment",
                "backpack_decoration",
                "armour",
                "thorax_variants",
                "leg_variants",
                "left_leg",
                "left_shin",
                "right_leg",
                "right_shin",
                "left_knee",
                "right_knee",
                "tabbard",
                "robe",
                "belt",
                "chest_variants",
                "chest_fastening",
                "head",
                "gorget",
                "necklace",
                "left_pauldron_base",
                "right_pauldron_base",
                "left_trim",
                "right_trim",
                "right_pauldron_icons",
                "left_pauldron_icons",
                "right_pauldron_embeleshments",
                "left_pauldron_embeleshments",
                "right_pauldron_hangings",
                "left_pauldron_hangings",
                "left_personal_livery",
                "foreground_item",
            ];
        }

        for (var i = 0; i < array_length(_draw_order); i++) {
            if (_draw_order[i] == "head") {
                draw_head(_texture_draws);
            } else {
                draw_component(_draw_order[i], _texture_draws);
            }
        }
        purity_seals_and_hangings();
        draw_weapon_and_hands(_texture_draws);

        shader_reset();
        surface_reset_target();
        if (!surface_exists(prep_surface) || !surface_exists(_final_surface)) {
            draw_sprite(spr_none, 0, 0, 0);
            if (surface_exists(prep_surface)) {
                surface_clear_and_free(prep_surface);
            }
            exit;
        }
        surface_set_target(_final_surface);
        draw_surface(prep_surface, 0, 0);
        surface_clear_and_free(prep_surface);
        shader_set(full_livery_shader);
    };

    static purity_seals_and_hangings = function() {
        //purity seals/decorations
        //TODO imprvoe this logic to be more extendable

        if (armour_type == eARMOUR_TYPE.NORMAL || armour_type == eARMOUR_TYPE.TERMINATOR) {
            var _body = draw_unit.body;
            var _torso_data = _body[$ "torso"];
            var _exp = draw_unit.experience;
            var _x_offset = x_surface_offset + (armour_type == eARMOUR_TYPE.NORMAL ? 0 : -7);
            var _y_offset = y_surface_offset + (armour_type == eARMOUR_TYPE.NORMAL ? 0 : -38);
            if (struct_exists(_torso_data, "purity_seal")) {
                var _torso_purity_seals = _torso_data[$ "purity_seal"];
                var positions = [
                    [
                        117,
                        115,
                    ],
                    [
                        51,
                        139,
                    ],
                    [
                        131,
                        136,
                    ],
                ];
                if (armour_type == eARMOUR_TYPE.NORMAL) {
                    positions = [
                        [
                            60,
                            88,
                        ],
                        [
                            90,
                            84,
                        ],
                        [
                            104,
                            64,
                        ],
                    ];
                }
                for (var i = 0; i < array_length(_torso_purity_seals); i++) {
                    if (i >= array_length(positions)) {
                        continue;
                    }
                    if ((_torso_purity_seals[i] + _exp) > 100) {
                        var _resolved = resolve_area("purity_seals", _torso_purity_seals[i]);
                        if (is_struct(_resolved) && sprite_exists(_resolved.sprite)) {
                            draw_sprite(_resolved.sprite, _resolved.frame, _x_offset + positions[i][0], _y_offset + positions[i][1]);
                        }
                    }
                }
            }

            if (struct_exists(_body[$ "left_arm"], "purity_seal")) {
                var _arm_seals = _body[$ "left_arm"][$ "purity_seal"];
                var positions = [
                    [
                        163,
                        92,
                    ],
                    [
                        148,
                        94,
                    ],
                    [
                        126,
                        84,
                    ],
                ];
                if (armour_type == eARMOUR_TYPE.NORMAL) {
                    positions = [
                        [
                            135,
                            69,
                        ],
                        [
                            121,
                            73,
                        ],
                    ];
                }
                for (var i = 0; i < array_length(_arm_seals); i++) {
                    if (i >= array_length(positions)) {
                        continue;
                    }
                    if ((_arm_seals[i] + _exp) > 100) {
                        var _resolved = resolve_area("purity_seals", _arm_seals[i]);
                        if (is_struct(_resolved) && sprite_exists(_resolved.sprite)) {
                            draw_sprite(_resolved.sprite, _resolved.frame, _x_offset + positions[i][0], _y_offset + positions[i][1]);
                        }
                    }
                }
            }

            if (struct_exists(_body[$ "right_arm"], "purity_seal")) {
                var _arm_seals = _body[$ "right_arm"][$ "purity_seal"];
                var positions = [
                    [
                        11,
                        91,
                    ],
                    [
                        39,
                        90,
                    ],
                    [
                        66,
                        86,
                    ],
                ];
                if (armour_type == eARMOUR_TYPE.NORMAL) {
                    positions = [
                        [
                            44,
                            76,
                        ],
                        [
                            30,
                            71,
                        ],
                        [
                            16,
                            69,
                        ],
                    ];
                }
                for (var i = 0; i < array_length(_arm_seals); i++) {
                    if (i >= array_length(positions)) {
                        continue;
                    }
                    if ((_arm_seals[i] + _exp) > 100) {
                        var _resolved = resolve_area("purity_seals", _arm_seals[i]);
                        if (is_struct(_resolved) && sprite_exists(_resolved.sprite)) {
                            draw_sprite(_resolved.sprite, _resolved.frame, _x_offset + positions[i][0], _y_offset + positions[i][1]);
                        }
                    }
                }
            }
        }
    };

    static base_armour = function() {
        armour_type = eARMOUR_TYPE.NORMAL;
        switch (unit_armour) {
            case "MK7 Aquila":
            case "Artificer Armour":
                add_group(mk7_bits);
                armour_type = eARMOUR_TYPE.NORMAL;
                break;
            case "MK6 Corvus":
                add_group({left_trim: spr_mk7_left_trim, right_trim: spr_mk7_right_trim, mouth_variants: spr_mk6_mouth_variants, head: spr_mk6_head_variants});
                armour_type = eARMOUR_TYPE.NORMAL;
                break;
            case "MK5 Heresy":
                add_group({armour: spr_mk5_complex, backpack: spr_mk5_complex_backpack, left_trim: spr_mk7_left_trim, right_trim: spr_mk7_right_trim, head: spr_mk5_head_variants, chest_variants: spr_mk5_chest_variants, knees: spr_mk7_complex_knees});
                armour_type = eARMOUR_TYPE.NORMAL;
                break;
            case "MK4 Maximus":
                add_group({chest_variants: spr_mk4_chest_variants, leg_variants: spr_mk4_leg_variants, mouth_variants: spr_mk4_mouth_variants, head: spr_mk4_head_variants});
                armour_type = eARMOUR_TYPE.NORMAL;
                break;
            case "MK3 Iron Armour":
                armour_type = eARMOUR_TYPE.NORMAL;
                break;
            case "MK8 Errant":
                add_group(mk7_bits);
                armour_type = eARMOUR_TYPE.NORMAL;
                break;
            case "Terminator Armour":
                add_group({backpack: spr_indomitus_backpack_variants, chest_variants: spr_indomitus_chest_variants, belt: spr_indomitus_belt});
                armour_type = eARMOUR_TYPE.TERMINATOR;
                break;
            case "Tartaros":
                add_group({mouth_variants: spr_tartaros_faceplate});
                armour_type = eARMOUR_TYPE.TERMINATOR;
                break;
            case "Cataphractii":
                add_group({head: spr_cata_head, belt: spr_cata_belt, gorget: spr_cata_gorget});
                armour_type = eARMOUR_TYPE.TERMINATOR;
                break;
            case "Dreadnought":
                armour_type = eARMOUR_TYPE.DREADNOUGHT;
                break;
            case "Contemptor Dreadnought":
                add_group({armour: spr_contemptor_chasis_colors, head: spr_contemptor_head_colors});
                armour_type = eARMOUR_TYPE.DREADNOUGHT;
                break;
            case "Scout Armour":
                add_group({armour: spr_scout_complex, left_arm: spr_scout_left, right_arm: spr_scout_right});
                armour_type = eARMOUR_TYPE.SCOUT;
                break;
            default:
                add_group(mk7_bits);
                break;
        }
        var type = draw_unit.get_body_data("type", "cloak");
        if (type != "none" && armour_type != eARMOUR_TYPE.SCOUT) {
            static _cloaks = {
                "scale": spr_cloak_scale,
                "pelt": spr_cloak_fur,
                "cloth": spr_cloak_cloth,
            };
            if (struct_exists(_cloaks, type)) {
                add_to_area("cloak", _cloaks[$ type]);
                add_to_area("cloak_image", spr_cloak_image_1);
                add_to_area("cloak_trim", spr_cloak_image_0);
            }
        }
        assign_modulars();
        var wep_opts = format_weapon_visuals(draw_unit.weapon_one());
        if (array_length(wep_opts)) {
            assign_modulars(wep_opts, "weapon");
        }
        if (draw_unit.weapon_one() != draw_unit.weapon_two()) {
            wep_opts = format_weapon_visuals(draw_unit.weapon_two());
            if (array_length(wep_opts)) {
                assign_modulars(wep_opts, "weapon");
            }
        }
    };

    base_armour();

    static draw_cloaks = function() {
        var _shader_set_multiply_blend = function(_r, _g, _b) {
            shader_set(shd_multiply_blend);
            shader_set_uniform_f(shader_get_uniform(shd_multiply_blend, "u_Color"), _r, _g, _b);
        };
        _shader_set_multiply_blend(127, 107, 89);
        draw_component("cloak");

        draw_component("cloak_image");
        draw_component("cloak_trim");

        shader_reset();
        shader_set(full_livery_shader);
    };

    /// @desc Add a sprite reference to an area without duplicating or merging pixel data.
    /// Stores source references in a composite struct. At draw time, resolve_area()
    /// maps a global frame choice to the correct source sprite + local frame.
    /// @param {String} area Area name
    /// @param {Asset.GMSprite} add_sprite Source sprite to add (not duplicated — we store the reference!)
    /// @param {Struct} overide_data Override data for this sprite's frame range
    /// @param {Struct} sub_components Sub-component data for this sprite's frame range
    /// @param {Asset.GMSprite} shadow Shadow data for this sprite's frame range
    static add_to_area = function(area, add_sprite, overide_data = "none", sub_components = "none", shadow = "none") {
        if (!sprite_exists(add_sprite)) {
            return;
        }
        var _overide_start = 0;
        var _add_sprite_length = sprite_get_number(add_sprite);
        if (!struct_exists(self, area)) {
            self[$ area] = {
                sources: [add_sprite],
                offsets: [0],
                source_frames: [_add_sprite_length],
                total: _add_sprite_length,
            };
        } else {
            var _existing_data = self[$ area];
            if (is_struct(_existing_data)) {
                _overide_start = _existing_data.total;
                array_push(_existing_data.sources, add_sprite);
                array_push(_existing_data.offsets, _overide_start);
                array_push(_existing_data.source_frames, _add_sprite_length);
                _existing_data.total += _add_sprite_length;
            } else {
                if (sprite_exists(_existing_data)) {
                    _overide_start = sprite_get_number(_existing_data);
                    self[$ area] = {
                        sources: [
                            _existing_data,
                            add_sprite,
                        ],
                        offsets: [
                            0,
                            _overide_start,
                        ],
                        source_frames: [
                            sprite_get_number(_existing_data),
                            _add_sprite_length,
                        ],
                        total: _overide_start + _add_sprite_length,
                    };
                } else {
                    self[$ area] = {
                        sources: [add_sprite],
                        offsets: [0],
                        source_frames: [_add_sprite_length],
                        total: _add_sprite_length,
                    };
                }
            }
        }

        if (overide_data != "none") {
            add_overide(area, _overide_start, _add_sprite_length, overide_data);
        }
        if (sub_components != "none") {
            add_sub_components(area, _overide_start, _add_sprite_length, sub_components);
        }
        if (shadow != "none" && sprite_exists(shadow)) {
            add_shadow_set(area, _overide_start, _add_sprite_length, shadow);
        }
    };

    /// @param {String} area
    /// @param {Real} _offset_start
    /// @param {Real} sprite_length
    /// @param {Struct} overide_data
    static add_offsets = function(area, _offset_start, sprite_length, overide_data) {};

    /// @param {String} area
    /// @param {Real} _overide_start
    /// @param {Real} sprite_length
    /// @param {Struct} overide_data
    static add_overide = function(area, _overide_start, sprite_length, overide_data) {
        if (!struct_exists(overides, area)) {
            overides[$ area] = [];
        }
        array_push(overides[$ area], [_overide_start, _overide_start + sprite_length, overide_data]);
    };

    /// @param {String} area
    /// @param {Real} _shadow_set_start
    /// @param {Real} sprite_length
    /// @param {Asset.GMSprite} shadow
    static add_shadow_set = function(area, _shadow_set_start, sprite_length, shadow) {
        if (!struct_exists(shadow_set, area)) {
            shadow_set[$ area] = [];
        }
        array_push(shadow_set[$ area], [_shadow_set_start, _shadow_set_start + sprite_length, shadow]);
    };

    /// @param {String} area
    /// @param {Real} _overide_start
    /// @param {Real} sprite_length
    /// @param {Struct} sub_components
    static add_sub_components = function(area, _overide_start, sprite_length, sub_components) {
        if (!struct_exists(subcomponents, area)) {
            subcomponents[$ area] = [];
        }
        var _accepted_subs = [];
        for (var i = 0; i < array_length(sub_components); i++) {
            var _subs = sub_components[i];
            var _sub_items = [];
            for (var s = 0; s < array_length(_subs); s++) {
                var _subby = _subs[s];
                if (is_struct(_subby)) {
                    var _allow = base_modulars_checks(_subby);
                    if (_allow) {
                        array_push(_sub_items, _subby);
                    }
                } else {
                    array_push(_sub_items, {sprite:_subby});
                } 
            }
            if (array_length(_sub_items)) {
                array_push(_accepted_subs, _sub_items);
            }
        }
        if (array_length(_accepted_subs)){
            array_push(subcomponents[$ area], [_overide_start, _overide_start + sprite_length, _accepted_subs]);
        }
    };

    /// @param {String} area
    /// @param {Asset.GMSprite} add_sprite
    /// @param {Struct} overide_data
    /// @param {Struct} sub_components
    /// @param {Asset.GMSprite} shadow
    static replace_area = function(area, add_sprite, overide_data = "none", sub_components = "none", shadow = "none") {
        remove_area(area);
        add_to_area(area, add_sprite, overide_data, sub_components, shadow);
    };

    /// @param {String} area
    static remove_area = function(area) {
        if (struct_exists(self, area)) {
            struct_remove(self, area);
            if (struct_exists(overides, area)) {
                struct_remove(overides, area);
            }
            if (struct_exists(subcomponents, area)) {
                struct_remove(subcomponents, area);
            }
            if (struct_exists(shadow_set, area)) {
                struct_remove(shadow_set, area);
            }
        }
    };

    /// @param {Struct} group
    static add_group = function(group) {
        var _areas = struct_get_names(group);
        for (var i = 0; i < array_length(_areas); i++) {
            var _area = _areas[i];
            add_to_area(_area, group[$ _area]);
        }
    };

    /// @param {Struct} texture_draws
    static draw_head = function(texture_draws = {}) {
        if (draw_helms) {
            if (struct_exists(self, "head")) {
                for (var i = 0; i < array_length(head_draw_order); i++) {
                    draw_component(head_draw_order[i], texture_draws);
                }
            }
        } else {
            shader_set(skin_tone_shader);

            var _skin_colour = skin_tones.standard[variation_map.bare_head % array_length(skin_tones.standard)];
            shader_set_uniform_f_array(shader_get_uniform(skin_tone_shader, "skin"), _skin_colour);

            draw_component("bare_neck", texture_draws);
            draw_component("bare_head", texture_draws);
            draw_component("bare_eyes", texture_draws);

            shader_set(full_livery_shader);
        }
    };

    /// @param {Struct} data
    static complex_helms = function(data) {
        var _head_resolved = resolve_area("head", variation_map.head % area_total_frames("head"));
        if (!is_struct(_head_resolved) || !sprite_exists(_head_resolved.sprite)) {
            return;
        }

        set_complex_shader_area(["eye_lense"], data.helm_lens);
        if (data.helm_pattern == 0) {
            set_complex_shader_area(["left_head", "right_head", "left_muzzle", "right_muzzle"], data.helm_primary);
        } else if (data.helm_pattern == 2) {
            set_complex_shader_area(["left_head", "right_head"], data.helm_primary);
            set_complex_shader_area(["left_muzzle", "right_muzzle"], data.helm_secondary);
        } else if (data.helm_pattern == 1 || data.helm_pattern == 3) {
            var _surface_width = sprite_get_width(_head_resolved.sprite);
            var _surface_height = sprite_get_height(_head_resolved.sprite);
            var _head_surface = surface_create(_surface_width, 60);
            surface_set_target(_head_surface);
            var _temp = [
                x_surface_offset,
                y_surface_offset,
            ];
            x_surface_offset = 0;
            y_surface_offset = 0;
            set_complex_shader_area(["left_head", "right_head", "left_muzzle", "right_muzzle"], data.helm_primary);

            var _obj = instance_exists(obj_controller) ? obj_controller : obj_creation;
            var _blend = [
                _obj.col_r[data.helm_secondary] / 255,
                _obj.col_g[data.helm_secondary] / 255,
                _obj.col_b[data.helm_secondary] / 255,
            ];

            draw_head({"head_stripe": {texture: spr_helm_stripe, areas: [[0, 0, 128 / 255], [0, 0, 255 / 255], [128 / 255, 64 / 255, 255 / 255], [64 / 255, 128 / 255, 255 / 255]], blend: _blend}});
            x_surface_offset = _temp[0];
            y_surface_offset = _temp[1];

            remove_area("mouth_variants");
            remove_area("crest");
            remove_area("forehead");
            remove_area("left_eye");
            remove_area("right_eye");
            remove_area("crown");

            surface_reset_target();

            var _new_head = sprite_create_from_surface(_head_surface, 0, 0, _surface_width, 60, false, false, 0, 0);
            surface_clear_and_free(_head_surface);
            shader_set(full_livery_shader);
            array_push(owned_sprites, _new_head);
            self[$ "head"] = _new_head;
        }
    };

    /// @desc Cleans up owned sprites (weapon duplicates, generated sprites). Does NOT delete original asset sprites.
    static destroy_images = function() {
        for (var i = 0; i < array_length(owned_sprites); i++) {
            if (sprite_exists(owned_sprites[i])) {
                sprite_delete(owned_sprites[i]);
            }
        }

        owned_sprites = [];
    };
}
