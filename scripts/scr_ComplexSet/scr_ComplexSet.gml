function scr_has_style(style) {
	var result = false;
	if (!is_array(style)) {
		try {
			var result;
			if (instance_exists(obj_creation)) {
				result = array_contains(obj_creation.buttons.culture_styles.selections(), style);
			} else {
				result = array_contains(obj_ini.culture_styles, style);
			}
		} catch (_exception) {
			handle_exception(_exception);
			result = false;
		}
	} else {
		for (var i = 0; i < array_length(style); i++) {
			var _specific = scr_has_style(style[i]);
			if (_specific) {
				return _specific;
			}
		}
	}
	return result;

	// var adv_count = array_length(obj_ini.adv);
	// for(var i = 0; i < adv_count; i++){
	//  if(obj_ini.adv[i] == advantage){
	//      return true;
	//  }
	// }
	// return false;
}

///@func sprite_get_uvs_transformed(sprite1, subimg1, sprite2, subimg2)
///@desc Returns a transform array that can be used in a shader to align the UVs of sprite2 with sprite1 (takes cropping into account)
///@param spr1 {Sprite} The sprite align the UVs to
///@param subimg1 {real} The sprite subimage to align the UVs to
///@param spr2 {Sprite} The sprite with UVs that will be aligned
///@param subimg1 {real} The sprite subimage with UVs that will be aligned
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
	return [_x_offset, _y_offset, _x_scale, _y_scale];
}

function ComplexSet(_unit) constructor {
	overides = {};
	unit_armour = _unit.armour();
	unit = _unit;
	draw_helms = instance_exists(obj_creation) ? obj_creation.draw_helms : obj_controller.draw_helms;
	//draw_helms = false;
	static mk7_bits = {
		armour: spr_mk7_complex,
		backpack: spr_mk7_complex_backpack,
		left_arm: spr_mk7_left_arm,
		right_arm: spr_mk7_right_arm,
		left_trim: spr_mk7_left_trim,
		right_trim: spr_mk7_right_trim,
		mouth_variants: spr_mk7_mouth_variants,
		thorax_variants: spr_mk7_thorax_variants,
		chest_variants: spr_mk7_chest_variants,
		leg_variants: spr_mk7_leg_variants,
		head: spr_mk7_head_variants,
		knees: spr_mk7_complex_knees
	};

	_are_exceptions = false;
	exceptions = [];

	static check_exception = function(exception_key) {
		if (_are_exceptions) {
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

	left_arm_data = [];

	right_arm_data = [];

	static assign_modulars = function(modulars = global.modular_drawing_items, position = false) {
		var _mod = {};

		try {
			for (var i = 0; i < array_length(modulars); i++) {
				_are_exceptions = false;
				_mod = modulars[i];
				exceptions = [];
				if (array_contains(blocked, _mod.position)) {
					return "blocked";
				}

				if (struct_exists(_mod, "allow_either")) {
					_are_exceptions = true;
					exceptions = [];
					for (var m = 0; m < array_length(_mod.allow_either); m++) {
						array_push(exceptions, _mod.allow_either[m]);
					}
				}
				if (struct_exists(_mod, "max_saturation")) {
					var _max_sat = _mod.max_saturation;
				}
				if (struct_exists(_mod, "exp")) {
					var _exp_data = _mod.exp;
					var _min = 0;
					if (struct_exists(_exp_data, "min")) {
						_min = _exp_data.min;
						if (unit.experience < _exp_data.min) {
							if (!check_exception("min_exp")) {
								continue;
							}
						}
					}
					if (struct_exists(_exp_data, "scale")) {
						var _m_exp = _exp_data.exp_scale_max;
						var _increment_count = _mod.max_saturation / 5;
						var _increments = (_m_exp - _min) / _increment_count;
						var _sat_roof = _mod.max_saturation;
						var _mar_exp = unit.experience;

						if (_mar_exp >= _m_exp) {
							spawn_chance = _mod.max_saturation;
						} else {
							var calc_exp = _mar_exp - _min;
							var _inc_point = floor(_mar_exp / _increments);
							_max_sat = _inc_point * 5;
						}
					}
				}
				if (struct_exists(_mod, "max_saturation")) {
					if (struct_exists(variation_map, _mod.position)) {
						if (variation_map[$ _mod.position] >= _max_sat) {
							if (!check_exception("max_saturation")) {
								continue;
							}
						}
					}
				}
				if (!struct_exists(_mod, "body_types")) {
					_mod.body_types = [0, 1, 2];
				}

				if (!array_contains(_mod.body_types, armour_type)) {
					if (!check_exception("body_types")) {
						continue;
					}
				}

				if (struct_exists(_mod, "role_type")) {
					var _viable = false;
					for (var a = 0; a < array_length(_mod.role_type); a++) {
						var _r_t = _mod.role_type[a];
						_viable = unit.IsSpecialist(_r_t);
						if (_viable) {
							break;
						}
					}
					if (!_viable) {
						if (!check_exception("chapter_adv")) {
							continue;
						}
						if (!check_exception("chapter_disadv")) {
							continue;
						}
					}
				}
				if (struct_exists(_mod, "roles")) {
					if (!array_contains(_mod.roles, unit.role())) {
						if (!check_exception("roles")) {
							continue;
						}
					}
				}
				if (struct_exists(_mod, "cultures")) {
					if (!scr_has_style(_mod.cultures)) {
						if (!check_exception("cultures")) {
							continue;
						}
					}
				}
				if (struct_exists(_mod, "company")) {
					if (!array_contains(_mod.company, unit.company)) {
						if (!check_exception("company")) {
							continue;
						}
					}
				}
				if (struct_exists(_mod, "armours")) {
					if (!array_contains(_mod.armours, unit_armour)) {
						if (!check_exception("armours")) {
							continue;
						}
					}
				}
				if (struct_exists(_mod, "armours_exclude")) {
					if (array_contains(_mod.armours_exclude, unit_armour)) {
						if (!check_exception("armours_exclude")) {
							continue;
						}
					}
				}
				if (struct_exists(_mod, "chapter_adv")) {
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
							continue;
						}
					}
				}
				if (struct_exists(_mod, "chapter_disadv")) {
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
							continue;
						}
					}
				}
				if (struct_exists(_mod, "stats")) {
					if (!stat_valuator(_mod.stats, unit)) {
						if (!check_exception("stats")) {
							continue;
						}
					}
				}
				if (struct_exists(_mod, "equipped")) {
					if (!unit.has_equipped(_mod.equipped)) {
						if (!check_exception("equipped")) {
							continue;
						}
					}
				}

				if (struct_exists(_mod, "traits")) {
					var _viable = false;
					for (var a = 0; a < array_length(_mod.traits); a++) {
						var _trait = _mod.traits[a];
						_viable = unit.has_trait(_trait);
						if (_viable) {
							break;
						}
					}
					if (!_viable) {
						if (!check_exception("traits")) {
							continue;
						}
					}
				}
				if (struct_exists(_mod, "chapter")) {
					var chap_name = instance_exists(obj_creation) ? obj_creation.chapter_name : global.chapter_name;
					if (chap_name != _mod.chapter) {
						if (!check_exception("chapter")) {
							continue;
						}
					}
				}

				var _overides = "none";
				if (struct_exists(_mod, "overides")) {
					_overides = _mod.overides;
				}
				if (struct_exists(_mod, "prevent_others")) {
					replace_area(_mod.position, _mod.sprite, _overides);
					array_push(blocked, _mod.position);
					if (struct_exists(_mod, "ban")) {
						for (var b = 0; b < array_length(_mod.ban); b++) {
							if (!array_contains(banned, _mod.ban[b])) {
								array_push(banned, _mod.ban[b]);
							}
						}
					}
				}
				if (struct_exists(_mod, "assign_by_rank")) {
					var _area = _mod.position;
					var _status_level = _mod.assign_by_rank;
					var _roles = active_roles();
					var tiers = [
						["Chapter Master"],
						["Forge Master", "Master of Sanctity", "Master of the Apothecarion", string("Chief {0}", _roles[eROLE.Librarian])],
						[_roles[eROLE.Captain], _roles[eROLE.HonourGuard]],
						[_roles[eROLE.Champion]],
						[_roles[eROLE.Ancient], _roles[eROLE.VeteranSergeant]],
						[_roles[eROLE.Terminator]],
						[_roles[eROLE.Veteran], _roles[eROLE.Sergeant], _roles[eROLE.Chaplain], _roles[eROLE.Apothecary], _roles[eROLE.Techmarine], _roles[eROLE.Librarian]],
						["Codiciery", "Lexicanum", _roles[eROLE.Tactical], _roles[eROLE.Assault], _roles[eROLE.Devastator]],
						[_roles[eROLE.Scout]]
					];

					var _unit_tier = 8;
					if (_unit_tier == 8) {
						for (var t = 0; t < array_length(tiers); t++) {
							var tier = tiers[t];
							if (array_contains(tier, unit.role())) {
								_unit_tier = t;
							}
						}
					}
					if (_unit_tier >= _status_level) {
						var variation_tier = (_unit_tier - _status_level) + 1;
						if (variation_map[$ _area] % variation_tier != 0) {
							continue;
						}
					}
				}

				if (position != false) {
					if (position == "weapon") {
						var _weapon_map = _mod.weapon_map;
						if (unit.weapon_one() == _weapon_map) {
							array_push(right_arm_data, _mod.weapon_data);
						}
						if (unit.weapon_two() == _weapon_map) {
							array_push(left_arm_data, _mod.weapon_data);
						}
					}
				} else {
					add_to_area(_mod.position, _mod.sprite, _overides);
				}
			}
		}
	};

	blocked = [];
	banned = [];
	variation_map = {
		backpack: unit.get_body_data("backpack_variation", "torso"),
		armour: unit.get_body_data("armour_choice", "torso"),
		chest_variants: unit.get_body_data("chest_variation", "torso"),
		thorax_variants: unit.get_body_data("thorax_variation", "torso"),
		leg_variants: unit.get_body_data("leg_variants", "left_leg"),
		left_leg: unit.get_body_data("leg_variants", "left_leg"),
		right_leg: unit.get_body_data("leg_variants", "right_leg"),
		left_shin: unit.get_body_data("shin_variant", "left_leg"),
		right_shin: unit.get_body_data("shin_variant", "right_leg"),
		left_knee: unit.get_body_data("knee_variant", "left_leg"),
		right_knee: unit.get_body_data("knee_variant", "right_leg"),
		left_trim: unit.get_body_data("trim_variation", "left_arm"),
		right_trim: unit.get_body_data("trim_variation", "right_arm"),
		left_arm: unit.get_body_data("variation", "left_arm"),
		right_arm: unit.get_body_data("variation", "right_arm"),
		gorget: unit.get_body_data("variant", "throat"),
		right_pauldron_icons: unit.get_body_data("pad_variation", "right_arm"),
		left_pauldron_icons: unit.get_body_data("pad_variation", "left_arm"),
		right_pauldron_base: unit.get_body_data("pad_variation", "right_arm"),
		left_pauldron_base: unit.get_body_data("pad_variation", "left_arm"),
		right_pauldron_embeleshments: unit.get_body_data("pad_variation", "right_arm"),
		left_pauldron_embeleshments: unit.get_body_data("pad_variation", "left_arm"),
		right_pauldron_hangings: unit.get_body_data("pad_variation", "right_arm"),
		left_pauldron_hangings: unit.get_body_data("pad_variation", "left_arm"),
		left_personal_livery: unit.get_body_data("personal_livery", "left_arm"),
		tabbard: unit.get_body_data("tabbard_variation", "torso"),
		robe: unit.get_body_data("tabbard_variation", "torso"),
		crest: unit.get_body_data("crest_variation", "head"),
		head: unit.get_body_data("variation", "head"),
		bare_head: unit.get_body_data("variation", "head"),
		bare_neck: unit.get_body_data("variation", "head"),
		bare_eyes: unit.get_body_data("variation", "head"),
		mouth_variants: unit.get_body_data("variant", "jaw"),
		left_eye: unit.get_body_data("variant", "left_eye"),
		right_eye: unit.get_body_data("variant", "right_eye"),
		crown: unit.get_body_data("crown_variation", "head"),
		forehead: unit.get_body_data("forehead_variation", "head"),
		backpack_decoration: unit.get_body_data("backpack_decoration_variation", "torso"),
		belt: unit.get_body_data("belt_variation", "torso"),
		cloak: unit.get_body_data("variant", "cloak"),
		cloak_image: unit.get_body_data("image_0", "cloak"),
		cloak_trim: unit.get_body_data("image_1", "cloak"),
		backpack_augment: unit.get_body_data("backpack_augment_variation", "torso"),
		chest_fastening: unit.get_body_data("chest_fastening", "torso"),
		left_weapon: unit.get_body_data("weapon_variation", "left_arm"),
		right_weapon: unit.get_body_data("weapon_variation", "right_arm")
	};

	static draw_component = function(component_name, texture_draws = {}) {
		if (array_contains(banned, component_name)) {
			return "banned component";
		}
		if (struct_exists(self, component_name)) {
			var _sprite = self[$ component_name];
			if (sprite_exists(_sprite)) {
				var choice = 0;
				if (struct_exists(variation_map, component_name)) {
					var choice = variation_map[$ component_name] % sprite_get_number(_sprite);
				}
				if (struct_exists(overides, component_name)) {
					var _overide_set = overides[$ component_name];
					for (var i = 0; i < array_length(_overide_set); i++) {
						var _spec_over = _overide_set[i];
						if (_spec_over[0] <= choice && _spec_over[1] > choice) {
							var _override_areas = struct_get_names(_spec_over[2]);
							for (var j = 0; j < array_length(_override_areas); j++) {
								replace_area(_override_areas[j], _spec_over[2][$ _override_areas[j]]);
							}
						}
					}
				}
				var _tex_names = struct_get_names(texture_draws);
				if (array_length(_tex_names)) {
					var _return_surface = surface_get_target();
					surface_reset_target();
					shader_reset();

					var base_component_surface = surface_create(600, 600);
					surface_set_target(base_component_surface);
					shader_set(armour_texture);
					for (var i = 0; i < array_length(_tex_names); i++) {
						var _tex_data = texture_draws[$ _tex_names[i]];

						tex_frame = 0;
						if (component_name == "left_pauldron_base") {
							tex_frame = 1;
						}

						var mask_transform_data = sprite_get_uvs_transformed(_sprite, choice, _tex_data.texture, tex_frame);

						var mask_transform = shader_get_uniform(armour_texture, "mask_transform");
						shader_set_uniform_f_array(mask_transform, mask_transform_data);

						var tex_texture = sprite_get_texture(_tex_data.texture, tex_frame);
						if (struct_exists(_tex_data, "blend")) {
							var _blend = 1;
						} else {
							_blend = 0;
						}
						shader_set_uniform_i(shader_get_uniform(armour_texture, "blend"), _blend);
						if (_blend) {
							shader_set_uniform_f_array(shader_get_uniform(armour_texture, "blend_colour"), _tex_data.blend);
						}
						for (var t = 0; t < array_length(_tex_data.areas); t++) {
							var armour_sampler = shader_get_sampler_index(armour_texture, "armour_texture");
							texture_set_stage(armour_sampler, tex_texture);
							// show_debug_message($"{_tex_data.areas[t]}");
							var _replace_col = shader_get_uniform(armour_texture, "replace_colour");
							shader_set_uniform_f_array(_replace_col, _tex_data.areas[t]);
							draw_sprite(_sprite, choice ?? 0, x_surface_offset, y_surface_offset);
						}
					}
					surface_reset_target();
					surface_set_target(_return_surface);
					shader_set(full_livery_shader);
					draw_sprite(_sprite, choice ?? 0, x_surface_offset, y_surface_offset);
					draw_surface(base_component_surface, 0, 0);
					surface_reset_target();
					surface_clear_and_free(base_component_surface);

					surface_set_target(_return_surface);
				} else {
					draw_sprite(_sprite, choice ?? 0, x_surface_offset, y_surface_offset);
				}
				//sprite_delete(_sprite);
			}
		}
	};

	static draw_unit_arms = function() {
		var _bionic_options = [];
		if (array_contains([ArmourType.Normal, ArmourType.Terminator, ArmourType.Scout], armour_type)) {
			for (var _right_left = 0; _right_left <= 1; _right_left++) {
				var _arm_data = arms_data[_right_left];
				var _variant = _arm_data.arm_type;
				if (_variant == 0 && _arm_data.sprite != 0) {
					continue;
				}

				var _arm_string = _right_left == 0 ? "right_arm" : "left_arm";
				var _bionic_arm = unit.get_body_data("bionic", _arm_string);
				_bio = [];
				if (ArmourType.Terminator == armour_type) {
					if (_variant == 2) {
						_bio = [spr_terminator_complex_arms_upper_right, spr_terminator_complex_arms_upper_left];
					} else if (_variant == 3) {
						_bio = [spr_terminator_complex_arm_hidden_right, spr_terminator_complex_arm_hidden_left];
					}
				} else {
                    if (_variant == 2 || _variant == 3){
                        continue;
                    }
                }
				if (_bionic_arm && !array_length(_bio)) {
					if (armour_type == ArmourType.Normal) {
						var _bio = [spr_bionic_right_arm, spr_bionic_left_arm];
					} else if (armour_type == ArmourType.Terminator) {
						_bio = [spr_indomitus_right_arm_bionic, spr_indomitus_left_arm_bionic];
					}
				}
				if (array_length(_bio)) {
					replace_area(_arm_string, _bio[_right_left]);
				}
				draw_component(_arm_string);
			}
		}
	};

	static draw_unit_hands = function(right_left) {
		var _arm_data = arms_data[right_left];
		if (_arm_data.arm_type == 1) {
			return;
		}
		var _hand = _arm_data.hand_type;

		if (armour_type != ArmourType.None) {
			var offset_x = x_surface_offset;
			var offset_y = y_surface_offset;
			switch (armour_type) {
				case ArmourType.Terminator:
					var _hand_spr = spr_terminator_hands;
					break;
				case ArmourType.Scout:
					var _hand_spr = spr_pa_hands;
					offset_y += 11;
					offset_x += _arm_data.ui_xmod;
					break;
				default:
				case ArmourType.Normal:
					var _hand_spr = spr_pa_hands;
					break;
			}
			if (_hand > 0) {
				var _spr_index = (_hand - 1) * 2;
				if (right_left == 1) {
					draw_sprite_flipped(_hand_spr, _spr_index, offset_x, offset_y);
				} else {
					draw_sprite(_hand_spr, _spr_index, offset_x, offset_y);
				}
			}
			// Draw bionic hands
			if (_hand == 1) {
				if (armour_type == ArmourType.Normal && !hide_bionics && struct_exists(body[$(right_left == 0 ? "right_arm" : "left_arm")], "bionic")) {
					var bionic_hand = body[$(right_left == 0 ? "right_arm" : "left_arm")][$ "bionic"];
					var bionic_spr_index = bionic_hand.variant * 2;
					if (right_left == 1) {
						draw_sprite_flipped(spr_bionics_hand, 0, offset_x, offset_y);
					} else {
						draw_sprite(spr_bionics_hand, 0, offset_x, offset_y);
					}
				}
			}
		}
	};

	static draw_weapon_and_hands = function() {
		// Draw hands bellow the weapon sprite;
		if (!weapon_right.ui_twoh && !weapon_left.ui_twoh) {
			for (var i = 0; i <= 1; i++) {
				var _arm_data = arms_data[i];
				if (!_arm_data.hand_on_top) {
					draw_unit_hands(i);
				}
			}
		}

		// // Draw weapons

		if (!weapon_right.new_weapon_draw) {
			if ((weapon_right.sprite != 0) && sprite_exists(weapon_right.sprite)) {
				if (weapon_right.ui_twoh == false && weapon_left.ui_twoh == false) {
					draw_sprite(weapon_right.sprite, 0, x_surface_offset + weapon_right.ui_xmod, y_surface_offset + weapon_right.ui_ymod);
				}
				if (weapon_right.ui_twoh == true) {
					draw_sprite(weapon_right.sprite, 0, x_surface_offset + weapon_right.ui_xmod, y_surface_offset + weapon_right.ui_ymod);
					/*if (ui_force_both == true) {
					    draw_sprite(weapon_right.sprite, 0, x_surface_offset + weapon_right.ui_xmod, y_surface_offset + weapon_right.ui_ymod);
					}*/
				}
			}
		} else {
			if ((weapon_right.sprite != 0) && sprite_exists(weapon_right.sprite)) {
				draw_sprite(weapon_right.sprite, 0, x_surface_offset + weapon_right.ui_xmod, y_surface_offset + weapon_right.ui_ymod);
			}
		}

		if (!weapon_left.new_weapon_draw) {
			if ((weapon_left.sprite != 0) && sprite_exists(weapon_left.sprite) && (weapon_right.ui_twoh == false)) {
				if (weapon_left.ui_spec == false) {
					draw_sprite(weapon_left.sprite, 1, x_surface_offset + weapon_left.ui_xmod, y_surface_offset + weapon_left.ui_ymod);
				} else if (weapon_left.ui_spec == true) {
					draw_sprite(weapon_left.sprite, 1, x_surface_offset + weapon_left.ui_xmod, y_surface_offset + weapon_left.ui_ymod);
				}
			}
		} else {
			if ((weapon_left.sprite != 0) && sprite_exists(weapon_left.sprite) && (weapon_right.ui_twoh == false)) {
				draw_sprite_flipped(weapon_left.sprite, 0, x_surface_offset + weapon_left.ui_xmod, y_surface_offset + weapon_left.ui_ymod);
			}
		}
		if (!weapon_right.ui_twoh && !weapon_left.ui_twoh) {
			for (var i = 0; i <= 1; i++) {
				var _arm_data = arms_data[i];
				if (_arm_data.hand_on_top) {
					draw_unit_hands(i);
				}
			}
		}

		// Draw hands above the weapon sprite;
	};

	static weapon_preset_data = {
		"shield": {
			arm_type: 2,
			ui_spec: true
		},
		"ranged_twohand": {
			ui_spec: true,
			ui_twoh: true
		},
		"normal_ranged": {
			arm_type: 1
		},
		"terminator_ranged": {
			arm_type: 1,
			hand_type: 0
		},
		"terminator_fist": {
			arm_type: 1,
			ui_spec: true
		},
		"melee_onehand": {
			hand_on_top: true
		},
		"melee_twohand": {
			ui_spec: true,
			new_weapon_draw: true,
			hand_type: 2,
			hand_on_top: true
		}
	};

	static draw = function() {
		var _final_surface = surface_get_target();
		surface_reset_target();
		var prep_surface = surface_create(600, 600);
		surface_set_target(prep_surface);

		var texture_draws = setup_complex_livery_shader(unit.role(), unit);
		draw_cloaks();
		//draw_unit_arms(x_surface_offset, y_surface_offset, armour_type, specialist_colours, hide_bionics, complex_set);

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

		arms_data = [weapon_right, weapon_left];
		for (var i = 0; i <= 1; i++) {
			var _arm = arms_data[i];
			var _wep = i == 0 ? unit.weapon_one() : unit.weapon_two();
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
			var _defualts = [
                "hand_on_top",
                "ui_xmod",
                "ui_ymod",
                "hand_type",
                "arm_type",
                "ui_weapon",
                "new_weapon_draw",
                "ui_twoh",
                "ui_spec",
                "sprite",
                "display_type"
            ];
			for (var s = 0; s < array_length(_defualts); s++) {
				if (!struct_exists(_arm, _defualts[s])) {
					_arm[$ _defualts[s]] = 0;
				}
			}
			if (armour_type == ArmourType.Terminator && !array_contains(["terminator_ranged", "terminator_melee", "terminator_fist"], _arm.display_type)) {
				_arm.ui_ymod -= 20;
				if (_arm.display_type == "normal_ranged") {
					if (_arm.new_weapon_draw) {
						_arm.ui_xmod += 24;
					} else {
						_arm.ui_xmod -= 24;
					}
					_arm.ui_ymod += 24;
				}
				if (_arm.display_type == "melee_onehand" && _wep != "Company Standard" ) {
                    if (!_arm.hand_type){
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
			} else if (armour_type == ArmourType.Scout) {
				_arm.ui_xmod += 4;
				_arm.ui_ymod += 11;
			}
		}
		draw_unit_arms();
		var _complex_helm = false;
		var unit_role = unit.role();
		var _role = active_roles();
		var _comp_helms = instance_exists(obj_creation) ? obj_creation.complex_livery_data : obj_ini.complex_livery_data;
		if (unit_role == _role[eROLE.Sergeant]) {
			_complex_helm = _comp_helms.sgt;
		} else if (unit_role == _role[eROLE.VeteranSergeant]) {
			_complex_helm = _comp_helms.vet_sgt;
		} else if (unit_role == _role[eROLE.Captain]) {
			_complex_helm = _comp_helms.captain;
		} else if (unit_role == _role[eROLE.Veteran] || (unit_role == _role[eROLE.Terminator] && unit.company == 1)) {
			_complex_helm = _comp_helms.veteran;
		}
		if (is_struct(_complex_helm) && struct_exists(self, "head") && draw_helms) {
			complex_helms(_complex_helm);
		}

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
                "left_personal_livery"
            ];
		} else {
			_draw_order = [
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
                "left_personal_livery"
            ];
		}
		for (var i = 0; i < array_length(_draw_order); i++) {
			if (_draw_order[i] == "head") {
				draw_head(texture_draws);
			} else {
				draw_component(_draw_order[i], texture_draws);
			}
		}
		purity_seals_and_hangings();
		draw_weapon_and_hands();

		delete texture_draws;

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

		if (armour_type == ArmourType.Normal || armour_type == ArmourType.Terminator) {
			var _body = unit.body;
			var _torso_data = _body[$ "torso"];
			var _exp = unit.experience;
			var _x_offset = x_surface_offset + (armour_type == ArmourType.Normal ? 0 : -7);
			var _y_offset = y_surface_offset + (armour_type == ArmourType.Normal ? 0 : -38);
			if (struct_exists(_torso_data, "purity_seal")) {
				var _torso_purity_seals = _torso_data[$ "purity_seal"];
				if (armour_type == ArmourType.Normal) {
					var positions = [
						[60, 88],
						[90, 84],
						[104, 64]
					];
				} else {
					var positions = [
						[117, 115],
						[51, 139],
						[131, 136]
					];
				}
				for (var i = 0; i < array_length(_torso_purity_seals); i++) {
					if (i >= array_length(positions)) {
						continue;
					}
					if ((_torso_purity_seals[i] + _exp) > 100) {
						draw_sprite(purity_seals, _torso_purity_seals[i], _x_offset + positions[i][0], _y_offset + positions[i][1]);
					}
				}
			}
			if (struct_exists(_body[$ "left_arm"], "purity_seal")) {
				var _arm_seals = _body[$ "left_arm"][$ "purity_seal"];
				if (armour_type == ArmourType.Normal) {
					var positions = [
						[135, 69],
						[121, 73]
					];
				} else {
					var positions = [
						[163, 92],
						[148, 94],
						[126, 84]
					];
				}
				for (var i = 0; i < array_length(_arm_seals); i++) {
					if (i >= array_length(positions)) {
						continue;
					}
					if ((_arm_seals[i] + _exp) > 100) {
						draw_sprite(purity_seals, _arm_seals[i], _x_offset + positions[i][0], _y_offset + positions[i][1]);
					}
				}
			}
			if (struct_exists(_body[$ "right_arm"], "purity_seal")) {
				var _arm_seals = _body[$ "right_arm"][$ "purity_seal"];
				if (armour_type == ArmourType.Normal) {
					var positions = [
						[44, 76],
						[30, 71],
						[16, 69]
					];
				} else {
					var positions = [
						[11, 91],
						[39, 90],
						[66, 86]
					];
				}
				for (var i = 0; i < array_length(_arm_seals); i++) {
					if (i >= array_length(positions)) {
						continue;
					}
					if ((_arm_seals[i] + _exp) > 100) {
						draw_sprite(purity_seals, _arm_seals[i], _x_offset + positions[i][0], _y_offset + positions[i][1]);
					}
				}
			}
		}
	};

	static base_armour = function() {
		armour_type = ArmourType.Normal;
		switch (unit_armour) {
			case "MK7 Aquila":
			case "Artificer Armour":
				add_group(mk7_bits);
				armour_type = ArmourType.Normal;
				break;
			case "MK6 Corvus":
				add_group({
					armour: spr_mk6_complex,
					backpack: spr_mk6_complex_backpack,
					left_arm: spr_mk6_left_arm,
					right_arm: spr_mk6_right_arm,
					left_trim: spr_mk7_left_trim,
					right_trim: spr_mk7_right_trim,
					mouth_variants: spr_mk6_mouth_variants,
					head: spr_mk6_head_variants
				});
				armour_type = ArmourType.Normal;
				break;
			case "MK5 Heresy":
				add_group({
					armour: spr_mk5_complex,
					backpack: spr_mk5_complex_backpack,
					left_arm: spr_mk5_left_arm,
					right_arm: spr_mk5_right_arm,
					left_trim: spr_mk7_left_trim,
					right_trim: spr_mk7_right_trim,
					head: spr_mk5_head_variants,
					chest_variants: spr_mk5_chest_variants,
					knees: spr_mk7_complex_knees
				});
				armour_type = ArmourType.Normal;
				/*if (scr_has_style("Prussian")){
				    add_to_area("chest_variants", spr_mk7_prussia_chest);
				}*/
				break;
			case "MK4 Maximus":
				add_group({
					chest_variants: spr_mk4_chest_variants,
					armour: spr_mk4_complex,
					backpack: spr_mk4_complex_backpack,
					left_arm: spr_mk4_left_arm,
					leg_variants: spr_mk4_leg_variants,
					right_arm: spr_mk4_right_arm,
					left_trim: spr_mk4_left_trim,
					right_trim: spr_mk4_right_trim,
					mouth_variants: spr_mk4_mouth_variants,
					head: spr_mk4_head_variants
				});
				armour_type = ArmourType.Normal;
				break;
			case "MK3 Iron Armour":
				add_group({
					armour: spr_mk3_complex,
					backpack: spr_mk3_complex_backpack,
					left_arm: spr_mk3_left_arm,
					right_arm: spr_mk3_right_arm,
					head: spr_mk3_head_variants,
					left_leg: spr_mk3_left_leg_variants,
					right_leg: spr_mk3_right_leg_variants,
					mouth_variants: spr_mk3_mouth,
					forehead: spr_mk3_forehead_variants,
					belt: spr_mk3_belt
				});
				armour_type = ArmourType.Normal;
				break;
			case "MK8 Errant":
				add_group(mk7_bits);
				add_to_area("gorget", spr_mk8_gorget);
				armour_type = ArmourType.Normal;
				break;
			case "Terminator Armour":
				add_group({
					armour: spr_indomitus_complex,
					left_arm: spr_indomitus_left_arm,
					right_arm: spr_indomitus_right_arm,
					backpack: spr_indomitus_backpack_variants,
					chest_variants: spr_indomitus_chest_variants,
					leg_variants: spr_indomitus_leg_variants,
					head: spr_indomitus_head_variants,
					belt: spr_indomitus_belt
				});
				armour_type = ArmourType.Terminator;
				break;
			case "Tartaros":
				add_group({
					armour: spr_tartaros_complex,
					left_arm: spr_tartaros_left_arm,
					right_arm: spr_tartaros_right_arm,
					right_leg: spr_tartaros_right_leg,
					left_leg: spr_tartaros_left_leg,
					chest_variants: spr_tartaros_chest,
					gorget: spr_tartaros_gorget,
					mouth_variants: spr_tartaros_faceplate,
					head: spr_tartaros_head_variants,
					left_trim: spr_tartaros_left_trim,
					right_trim: spr_tartaros_right_trim
				});
				armour_type = ArmourType.Terminator;
				break;
			case "Dreadnought":
				add_group({
					armour: spr_dreadnought_complex
				});
				armour_type = ArmourType.Dreadnought;
				break;
			case "Scout Armour":
				add_group({
					armour: spr_scout_complex,
					left_arm: spr_scout_left,
					right_arm: spr_scout_right
				});
				armour_type = ArmourType.Scout;
				break;
			default:
				add_group(mk7_bits);
				break;
		}
		var type = unit.get_body_data("type", "cloak");
		if (type != "none" && armour_type != ArmourType.Scout) {
			static _cloaks = {
				"scale": spr_cloak_scale,
				"pelt": spr_cloak_fur,
				"cloth": spr_cloak_cloth
			};
			if (struct_exists(_cloaks, type)) {
				add_to_area("cloak", _cloaks[$ type]);
				add_to_area("cloak_image", spr_cloak_image_1);
				add_to_area("cloak_trim", spr_cloak_image_0);
			}
		}
		assign_modulars();
		var wep_opts = format_weapon_visuals(unit.weapon_one());
		if (array_length(wep_opts)) {
			assign_modulars(wep_opts, "weapon");
		}
		if (unit.weapon_one() != unit.weapon_two()) {
			var wep_opts = format_weapon_visuals(unit.weapon_two());
			if (array_length(wep_opts)) {
				assign_modulars(wep_opts, "weapon");
			}
		}
	};

	if (unit.IsSpecialist(SPECIALISTS_TECHS)) {
		if (array_contains(["MK5 Heresy", "MK6 Corvus", "MK7 Aquila", "MK8 Errant", "Artificer Armour"], unit_armour)) {
			if (unit.has_trait("tinkerer")) {
				add_group({
					"armour": spr_techmarine_complex,
					"right_trim": spr_techmarine_right_trim,
					"left_trim": spr_techmarine_left_trim,
					"leg_variants": spr_techmarine_left_leg,
					"leg_variants": spr_techmarine_right_leg,
					"head": spr_techmarine_head,
					"chest_variants": spr_techmarine_chest,
					"mouth_variants": spr_tech_face_plate
				});
			}
		}
	}

	static draw_cloaks = function() {
		var _shader_set_multiply_blend = function(_r, _g, _b) {
			shader_set(shd_multiply_blend);
			shader_set_uniform_f(shader_get_uniform(shd_multiply_blend, "u_Color"), _r, _g, _b);
		};
		_shader_set_multiply_blend(127, 107, 89);
		draw_component("cloak");

		//_shader_set_multiply_blend(obj_controller.trim_colour_replace[0]*255, obj_controller.trim_colour_replace[1]*255, obj_controller.trim_colour_replace[2]*255);
		draw_component("cloak_image");
		draw_component("cloak_trim");

		shader_reset();
		shader_set(full_livery_shader);
	};

	static add_to_area = function(area, add_sprite, overide_data = "none") {
		if (sprite_exists(add_sprite)) {
			var _add_sprite_length = sprite_get_number(add_sprite);
			if (!struct_exists(self, area)) {
				self[$ area] = sprite_duplicate(add_sprite);
				var _overide_start = 0;
			} else {
				var _overide_start = sprite_get_number(self[$ area]);
				sprite_merge(self[$ area], add_sprite);
			}
			if (overide_data != "none") {
				add_overide(area, _overide_start, _add_sprite_length, overide_data);
			}
		}
	};

	static add_overide = function(area, _overide_start, sprite_length, overide_data) {
		if (!struct_exists(overides, area)) {
			overides[$ area] = [];
		}
		array_push(overides[$ area], [_overide_start, _overide_start + sprite_length, overide_data]);
	};

	static replace_area = function(area, add_sprite, overide_data = "none") {
		if (struct_exists(self, area)) {
			sprite_delete(self[$ area]);
			if (struct_exists(overides, area)) {
				struct_remove(overides, area);
			}
		}
		self[$ area] = sprite_duplicate(add_sprite);
		if (overide_data != "none") {
			add_overide(area, 0, sprite_get_number(self[$ area]), overide_data);
		}
	};

	static remove_area = function(area) {
		if (struct_exists(self, area)) {
			sprite_delete(self[$ area]);
			struct_remove(self, area);
			if (struct_exists(overides, area)) {
				struct_remove(overides, area);
			}
		}
	};

	static add_group = function(group) {
		var _areas = struct_get_names(group);
		for (var i = 0; i < array_length(_areas); i++) {
			var _area = _areas[i];
			add_to_area(_area, group[$ _area]);
		}
	};

	position_overides = {};

	static skin_tones = {
		standard: [
			[1.0, 218.0 / 255.0, 179.0 / 255.0],
			[1.0, 192.0 / 255.0, 134.0 / 255.0],
			[252.0 / 255.0, 206.0 / 255.0, 159.0 / 255.0],
			[254.0 / 255.0, 206.0 / 255.0, 163.0 / 255.0],
			[255.0 / 255.0, 221.0 / 255.0, 191.0 / 255.0],
			[230.0 / 255.0, 177.0 / 255.0, 131.0 / 255.0],
			[255.0 / 255.0, 205.0 / 255.0, 163.0 / 255.0],
			[57.0 / 255.0, 37.0 / 255.0, 17.0 / 255.0]
		],
		coal: [34.0 / 255.0, 34.0 / 255.0, 34.0 / 255.0]
	};

	static draw_head = function(texture_draws = {}) {
		if (draw_helms) {
			if (struct_exists(self, "head")) {
				draw_component("crest", texture_draws);
				draw_component("head", texture_draws);
				draw_component("forehead", texture_draws);
				draw_component("mouth_variants", texture_draws);
				draw_component("left_eye", texture_draws);
				draw_component("right_eye", texture_draws);
				draw_component("crown", texture_draws);
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

	static complex_helms = function(data) {
		set_complex_shader_area(["eye_lense"], data.helm_lens);
		if (data.helm_pattern == 0) {
			set_complex_shader_area(["left_head", "right_head", "left_muzzle", "right_muzzle"], data.helm_primary);
		} else if (data.helm_pattern == 2) {
			set_complex_shader_area(["left_head", "right_head"], data.helm_primary);
			set_complex_shader_area(["left_muzzle", "right_muzzle"], data.helm_secondary);
		} else if (data.helm_pattern == 1 || data.helm_pattern == 3) {
			var _surface_width = sprite_get_width(head);
			var _surface_height = sprite_get_height(head);
			var _head_surface = surface_create(_surface_width, 60);
			//var _decoration_surface = surface_create(_surface_width, 60);
			surface_set_target(_head_surface);
			var _temp = [x_surface_offset, y_surface_offset];
			x_surface_offset = 0;
			y_surface_offset = 0;
			set_complex_shader_area(["left_head", "right_head", "left_muzzle", "right_muzzle"], data.helm_primary);
			if (instance_exists(obj_controller)) {
				var _blend = [obj_controller.col_r[data.helm_secondary] / 255, obj_controller.col_g[data.helm_secondary] / 255, obj_controller.col_b[data.helm_secondary] / 255];
			} else {
				var _blend = [obj_creation.col_r[data.helm_secondary] / 255, obj_creation.col_g[data.helm_secondary] / 255, obj_creation.col_b[data.helm_secondary] / 255];
			}

			draw_head({
				"head_stripe": {
					texture: spr_helm_stripe,
					areas: [
						[0, 0, 128 / 255],
						[0, 0, 255 / 255],
						[128 / 255, 64 / 255, 255 / 255],
						[64 / 255, 128 / 255, 255 / 255]
					],
					blend: _blend
				}
			});
			x_surface_offset = _temp[0];
			y_surface_offset = _temp[1];

			remove_area("mouth_variants");
			remove_area("crest");
			remove_area("forehead");
			remove_area("left_eye");
			remove_area("right_eye");
			remove_area("crown");

			//shader_set(helm_shader);
			//surface_set_target(_decoration_surface);
			//shader_set_uniform_f_array(shader_get_uniform(helm_shader, "replace_colour"), get_shader_array(data.helm_secondary));
			//draw_sprite(spr_helm_stripe, data.helm_pattern==1?0:1, 0, 0);
			surface_reset_target();

			if (sprite_exists(head)) {
				sprite_delete(head);
			}

			head = sprite_create_from_surface(_head_surface, 0, 0, _surface_width, 60, false, false, 0, 0);
			surface_clear_and_free(_head_surface);
			shader_set(full_livery_shader);
		}
	};

	base_armour();
}
