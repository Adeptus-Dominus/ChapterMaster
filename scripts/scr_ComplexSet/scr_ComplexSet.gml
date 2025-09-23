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

function valid_sprite_transform_data(data){
	return (is_array(data) && array_length(data) == 4)
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
	subcomponents = {};
	unit_armour = _unit.armour();
	unit = _unit;
	draw_helms = instance_exists(obj_creation) ? obj_creation.draw_helms : obj_controller.draw_helms;
	//draw_helms = false;
	static mk7_bits = {
		armour: spr_mk7_complex,
		left_arm: spr_mk7_left_arm,
		right_arm: spr_mk7_right_arm,
		left_trim: spr_mk7_left_trim,
		right_trim: spr_mk7_right_trim,
		mouth_variants: spr_mk7_mouth_variants,
		thorax_variants: spr_mk7_thorax_variants,
		chest_variants: spr_mk7_chest_variants,
		head: spr_mk7_head_variants,
		right_knee: spr_mk7_complex_knees
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

	static base_modulars_checks = function(mod_item){
		_are_exceptions = false;
		var _mod = mod_item;
		exceptions = [];

		if (array_contains(blocked, _mod.position)) {
			return false;
		}

		if (struct_exists(_mod, "allow_either")) {
			_are_exceptions = true;
			exceptions = variable_clone(_mod.allow_either);
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
						return false;
					}
				}
			}
			if (struct_exists(_exp_data, "scale")) {
				var _m_exp = _exp_data.exp_scale_max;
				var _increment_count = max(1, floor(_mod.max_saturation / 5));
				var _increments = (_m_exp - _min) / _increment_count;
				var _sat_roof = _mod.max_saturation;
				var _mar_exp = unit.experience;

				if (_mar_exp >= _m_exp) {
					spawn_chance = _mod.max_saturation;
				} else {
                    var calc_exp = max(0, _mar_exp - _min);
                    var _inc_point = floor(calc_exp / _increments);
                    _max_sat = clamp(_inc_point * 5, 0, _mod.max_saturation);
				}
			}
		}
		if (struct_exists(_mod, "max_saturation")) {
			if (struct_exists(variation_map, _mod.position)) {
				if (variation_map[$ _mod.position] >= _max_sat) {
					if (!check_exception("max_saturation")) {
						return false;
					}
				}
			}
		}
		if (!struct_exists(_mod, "body_types")) {
			_mod.body_types = [0, 1, 2];
		}

		if (!array_contains(_mod.body_types, armour_type)) {
			if (!check_exception("body_types")) {
				return false;
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
				if (!check_exception("role_type")) {
					return false;
				}
			}
		}
		if (struct_exists(_mod, "roles")) {
			if (!array_contains(_mod.roles, unit.role())) {
				if (!check_exception("roles")) {
					return false;
				}
			}
		}
		if (struct_exists(_mod, "cultures")) {
			if (!scr_has_style(_mod.cultures)) {
				if (!check_exception("cultures")) {
					return false;
				}
			}
		}
		if (struct_exists(_mod, "company")) {
			if (!array_contains(_mod.company, unit.company)) {
				if (!check_exception("company")) {
					return false;
				}
			}
		}
		if (struct_exists(_mod, "armours")) {
			if (!array_contains(_mod.armours, unit_armour)) {
				if (!check_exception("armours")) {
					return false;
				}
			}
		}
		if (struct_exists(_mod, "armours_exclude")) {
			if (array_contains(_mod.armours_exclude, unit_armour)) {
				if (!check_exception("armours_exclude")) {
					return false;
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
					return false;
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
					return false;
				}
			}
		}
		if (struct_exists(_mod, "stats")) {
			if (!stat_valuator(_mod.stats, unit)) {
				if (!check_exception("stats")) {
					return false;
				}
			}
		}
		if (struct_exists(_mod, "equipped")) {
			if (!unit.has_equipped(_mod.equipped)) {
				if (!check_exception("equipped")) {
					return false;
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
					return false;
				}
			}
		}

		if (struct_exists(_mod, "equipment_has_tag")) {
			var _viable = false;
			var _tag_check_areas = struct_get_names(_mod.equipment_has_tag);
			for (var i=0; i<array_length(_tag_check_areas);i++){
				var _area = _tag_check_areas[i];
				var _tag = _mod.equipment_has_tag[$_area];
				_viable = unit.equipment_has_tag(_tag,_area);
				if (_viable) {
					break;
				}				
			}
			if (!_viable) {
				if (!check_exception("equipment_has_tag")) {
					return false;
				}
			}
		}
		if (struct_exists(_mod, "chapter")) {
			var chap_name = instance_exists(obj_creation) ? obj_creation.chapter_name : global.chapter_name;
			if (chap_name != _mod.chapter) {
				if (!check_exception("chapter")) {
					return false;
				}
			}
		}

		_overides = "none";
		if (struct_exists(_mod, "overides")) {
			_overides = {overides:_mod.overides};
		}
		if (struct_exists(_mod, "offsets")){
			var _x = 0;
			var _y = 0;
			if (struct_exists(_mod.offsets,unit_armour)){
				var _offset = _mod.offsets[$ unit_armour];
				if (struct_exists(_offset,"x")){
					_x += _offset.x;
				}
				if (struct_exists(_offset,"y")){
					_y += _offset.y;
				}			
			}
			if (_x != 0 || _y !=0){
				if (_overides == "none"){
					_overides = {offsets:[_x, _y]};
				} else {
					_overides.offsets = [_x, _y]
				}
			}
		}

		if (struct_exists(_mod, "subcomponents")){
			_sub_comps = _mod.subcomponents;
		}

		if (struct_exists(_mod, "shadows")){
			_shadows = _mod.shadows;
		}

		if (struct_exists(_mod, "body_parts")){
			var _viable = true;
			var _body_areas = struct_get_names(_mod.body_parts);
			for (var b=0;b<array_length(_body_areas);b++){
				var _area =_body_areas[b];
				if (!struct_exists(unit.body[$ _area],_mod.body_parts[$ _area])){
					_viable = false;
					break;							
				}
			}
			if (!_viable){
				if (!check_exception("body_parts")) {
					return false;
				}
			}
		}

		if (struct_exists(_mod, "prevent_others")) {
			replace_area(_mod.position, _mod.sprite, _overides,_sub_comps);
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
				["Forge Master", "Master of Sanctity", "Master of the Apothecarion", $"Chief {_roles[eROLE.Librarian]}"],
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
				for (var t = 0; t < array_length(tiers); t++){
					var tier = tiers[t];
					if (array_contains(tier, unit.role())) {
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

		return true;	
	}
	static assign_modulars = function(modulars = global.modular_drawing_items, position = false) {
		var _mod = {};

		try {
			for (var i = 0; i < array_length(modulars); i++) {
				_sub_comps = "none";
				_shadows = "none";
				_mod = modulars[i];
				var _allowed = base_modulars_checks(_mod);

				if (!_allowed){
					continue;
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
					add_to_area(_mod.position, _mod.sprite, _overides, _sub_comps, _shadows);
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
		} catch(_exception){
 			handle_exception(_exception);
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
		right_weapon: unit.get_body_data("weapon_variation", "right_arm"),
		necklace : unit.get_body_data("hanging_variant", "throat"),
		foreground_item : unit.get_body_data("variant", "throat"),
	};




	component_final_draw_x = 0;
	component_final_draw_y = 0
	shadow_enabled = false;
	component_map_choice = 0;


	use_shadow_uniform = shader_get_uniform(full_livery_shader, "use_shadow");
	shadow_transform_uniform = shader_get_uniform(full_livery_shader, "shadow_transform");

	shadow_sampler = shader_get_sampler_index(full_livery_shader, "shadow_texture");
	armour_shadow_sampler = shader_get_sampler_index(armour_texture, "shadow_texture");
	armour_texture_sampler = shader_get_sampler_index(armour_texture, "armour_texture");

	texture_blend_uniform = shader_get_uniform(armour_texture, "blend");
	texture_blend_colour_uniform = shader_get_uniform(armour_texture, "blend_colour");
	static texture_replace_col_uniform = shader_get_uniform(armour_texture, "replace_colour");

	texture_use_shadow_uniform = shader_get_uniform(armour_texture, "use_shadow");
	texture_shadow_transform_uniform = shader_get_uniform(armour_texture, "shadow_transform");
	texture_mask_transform = shader_get_uniform(armour_texture, "mask_transform");

    if (!surface_exists(global.base_component_surface)) {
	    global.base_component_surface = surface_create(600,600);
	}

	static check_component_overides = function(component_name, choice){
		if (struct_exists(overides, component_name)) {
			var _overide_set = overides[$ component_name];
			for (var i = 0; i < array_length(_overide_set); i++) {
				var _spec_over = _overide_set[i];
				if (_spec_over[0] <= choice && _spec_over[1] > choice) {
					var _override_data = _spec_over[2];
					if (struct_exists(_override_data, "overides")){
						_override_areas = struct_get_names(_override_data.overides);
						var _overs = _override_data.overides;
						for (var j = 0; j < array_length(_override_areas); j++) {
							replace_area(_override_areas[j], _overs[$ _override_areas[j]]);
						}
					}
					if (struct_exists(_override_data, "offsets")){
						var _offsets = _override_data.offsets;
						component_final_draw_x += _offsets[0];
						component_final_draw_y += _offsets[1];
					}
					break;
				}
			}
		}
	}

	static set_component_shadow_packs = function(component_name, choice){
		if (struct_exists(shadow_set, component_name)) {
		    var _shadow_set = shadow_set[$ component_name];
		    for (var i = 0; i < array_length(_shadow_set); i++) {
		        var _spec_shadow = _shadow_set[i];
		        if (_spec_shadow[0] <= choice && _spec_shadow[1] > choice) {
		            var _shadow_item = _spec_shadow[2];
		            var _final_shadow_index = choice - _spec_shadow[0];
		            //show_debug_message($"final_index {_final_shadow_index}, {_spec_shadow[0]}, {_spec_shadow[1]}, {choice},{_shadow_item}");

		            var _sprite = self[$ component_name];
	                // Compute UV transform for this shadow texture
	                if (!sprite_exists(_sprite) || !sprite_exists(_shadow_item)){
	                	exit;
	                }
	                var _shadow_transform_data = sprite_get_uvs_transformed(_sprite, choice , _shadow_item, _final_shadow_index);

	                if (valid_sprite_transform_data(_shadow_transform_data)){
		                shader_set_uniform_f_array(shadow_transform_uniform, _shadow_transform_data);

						// Commented code, was causing a crash.
						// TODO find why upon chapter creation.
						// somewhere here an array goes out of bounds. Occurs upon creation and keeps happening in game, see bugs. To check on future
		                // shader_set_uniform_f_array(texture_shadow_transform_uniform, _shadow_transform_data);
	                }

	                // Bind shadow texture
	                var _shadow_tex = sprite_get_texture(_shadow_item, _final_shadow_index);
	                texture_set_stage(shadow_sampler, _shadow_tex);
	                texture_set_stage(armour_shadow_sampler, _shadow_tex);

	                // Trigger the draw to apply shadow (shader mixes it)
	                //draw_sprite(_sprite, _choice ?? 0, component_final_draw_x, component_final_draw_y);

	                shadow_enabled = 1;
	                break;
		        }
		    }
		}
	}

	static handle_component_subcomponents = function(component_name, choice){
		if (struct_exists(subcomponents, component_name)) {
			var _component_set
			var _subcomponents_found = false;
			var _component_bulk_set = subcomponents[$ component_name];
			for (var i = 0; i < array_length(_component_bulk_set); i++) {
				var _spec_over = _component_bulk_set[i];
				if (_spec_over[0] <= choice && _spec_over[1] > choice) {
					_subcomponents_found = true;
					_component_set = _spec_over[2];
				}
			}

			if (_subcomponents_found){
				for (var i = 0; i < array_length(_component_set); i++) {
					var _subcomponents = _component_set[i];
					var _sub_choice = (component_map_choice * 1315423911) & $7FFFFFFF;

					var _total_options = 0;
					for (var s=0;s<array_length(_subcomponents);s++){
						_total_options += sprite_get_number(_subcomponents[s]);
					}

					if (_total_options > 0){
						_sub_choice_final = _total_options == 1 ? 0 : _sub_choice % (_total_options+1);
						
						_choice_count = 0;
						for (var s=0; s<array_length(_subcomponents); s++){
							if (_sub_choice_final >= _choice_count && _sub_choice_final < _choice_count+sprite_get_number(_subcomponents[s])){
								draw_sprite(_subcomponents[s], _sub_choice_final-_choice_count ?? 0, component_final_draw_x, component_final_draw_y);
								break;
							} else {
								_choice_count += sprite_get_number(_subcomponents[s]);
							}
						}
					}
				}
			}
			//sprite_delete(_sprite);
		}
	}

	static draw_component_with_textures = function(_sprite, _choice, _tex_names, texture_draws, component_name) {
		var _return_surface = surface_get_target();
		surface_reset_target();
		shader_reset();

		surface_set_target(global.base_component_surface);
		draw_clear_alpha(c_white, 0);
		
		shader_set(armour_texture);
		shader_set_uniform_i(texture_use_shadow_uniform, shadow_enabled);
		set_component_shadow_packs(component_name, _choice);

		for (var i = 0; i < array_length(_tex_names); i++) {
			var _tex_data = texture_draws[$ _tex_names[i]];

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
				var _mask_transform_data = sprite_get_uvs_transformed(_sprite, _choice, _tex_data.texture, tex_frame);
				if (!valid_sprite_transform_data(_mask_transform_data)){
					continue;
				}
				shader_set_uniform_f_array(texture_mask_transform, _mask_transform_data);
				texture_set_stage(armour_texture_sampler, tex_texture);
				shader_set_uniform_f_array(texture_replace_col_uniform, _tex_data.areas[t]);

				draw_sprite(_sprite, _choice ?? 0, component_final_draw_x, component_final_draw_y);
			}
		}

		surface_reset_target();
		surface_set_target(_return_surface);
		shader_reset();

		shader_set(full_livery_shader);
		set_component_shadow_packs(component_name, _choice);

		draw_sprite(_sprite, _choice ?? 0, component_final_draw_x, component_final_draw_y);
		draw_surface(global.base_component_surface, 0, 0);
	};


	// Main function
	static draw_component = function(component_name, texture_draws = {}, choice_lock = -1) {
		if (array_contains(banned, component_name)) {
			return "banned component";
		}
		if (struct_exists(self, component_name)) {
			shadow_enabled = 0;
			var _sprite = self[$ component_name];
			if (!sprite_exists(_sprite)) {
				return "error failed no sprite found"
			}

			component_final_draw_x = x_surface_offset;
			component_final_draw_y = y_surface_offset;

			var _choice = 0;
			var component_map_choice = 3;
			if (struct_exists(variation_map, component_name) && choice_lock == -1) {
				component_map_choice = variation_map[$ component_name];
				_choice = component_map_choice % sprite_get_number(_sprite);
			}
			else if (choice_lock > -1){
				_choice = choice_lock
			}

			check_component_overides(component_name, _choice);
			set_component_shadow_packs(component_name, _choice);

			shader_set_uniform_i(use_shadow_uniform, shadow_enabled);

			var _tex_names = struct_get_names(texture_draws);

			if (array_length(_tex_names) > 0) {
				draw_component_with_textures(_sprite, _choice, _tex_names, texture_draws, component_name);
			} else {
				draw_sprite(_sprite, _choice ?? 0, component_final_draw_x, component_final_draw_y);
			}

			handle_component_subcomponents(component_name, _choice);
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
		if (armour_type == ArmourType.Dreadnought){
			if ((weapon_right.sprite != 0) && sprite_exists(weapon_right.sprite)) {
				draw_sprite(weapon_right.sprite, 0, x_surface_offset + weapon_right.ui_xmod, y_surface_offset + weapon_right.ui_ymod);
			}
			if ((weapon_left.sprite != 0) && sprite_exists(weapon_left.sprite)) {
				draw_sprite(weapon_left.sprite, 1, x_surface_offset + weapon_left.ui_xmod, y_surface_offset + weapon_left.ui_ymod);
			}
			exit;
		}
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
				if ((weapon_right.ui_twoh == false && weapon_left.ui_twoh == false) || weapon_right.ui_twoh == true) {
					draw_weapon(weapon_right,"right_weapon", 0);
				}
			}
		} else {
			if ((weapon_right.sprite != 0) && sprite_exists(weapon_right.sprite)) {
				draw_weapon(weapon_right,"right_weapon");
			}
		}

		if (!weapon_left.new_weapon_draw) {
			if ((weapon_left.sprite != 0) && sprite_exists(weapon_left.sprite) && (weapon_right.ui_twoh == false)) {
				draw_weapon(weapon_left,"left_weapon", 1);
			}
		} else {
			if ((weapon_left.sprite != 0) && sprite_exists(weapon_left.sprite) && (weapon_right.ui_twoh == false)) {
				weapon_left.sprite = return_sprite_mirrored(weapon_left.sprite);
				draw_weapon(weapon_left, "left_weapon")

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
		if ((weapon_right.sprite != 0) && sprite_exists(weapon_right.sprite)) {

			sprite_delete(weapon_right.sprite)
		}
		if ((weapon_left.sprite != 0) && sprite_exists(weapon_left.sprite)) {
			sprite_delete(weapon_left.sprite);
			
		}
	};

	static draw_weapon = function(weapon, position, choice_lock=-1){

		x_surface_offset += weapon.ui_xmod;
		y_surface_offset += weapon.ui_ymod;

		var _subs = struct_exists(weapon, "subcomponents") ? weapon.subcomponents : "none";

		var _shadows = struct_exists(weapon, "shadows") ? weapon.shadows : "none";

		//show_debug_message($" shadows {_shadows}");

		add_to_area(position, weapon.sprite, "none", _subs, _shadows);

		draw_component(position, {}, choice_lock);

		x_surface_offset -= weapon.ui_xmod;
		y_surface_offset -= weapon.ui_ymod;
	}


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

		var _texture_draws = setup_complex_livery_shader(unit.role(), unit);

		show_debug_message(_texture_draws);
		draw_cloaks();
		//draw_unit_arms(x_surface_offset, y_surface_offset, armour_type, specialist_colours, hide_bionics, complex_set);

		if (array_length(left_arm_data)) {
			weapon_left = variable_clone(left_arm_data[variation_map.left_weapon % array_length(left_arm_data)]);
			weapon_left.sprite = sprite_duplicate(weapon_left.sprite)
		} else {
			weapon_left = {};
		}
		if (array_length(right_arm_data)) {
			weapon_right = variable_clone(right_arm_data[variation_map.right_weapon % array_length(right_arm_data)]);
			weapon_right.sprite = sprite_duplicate(weapon_right.sprite)
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
			var _defaults = [
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
			for (var s = 0; s < array_length(_defaults); s++) {
				if (!struct_exists(_arm, _defaults[s])) {
					_arm[$ _defaults[s]] = 0;
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
		} else if (struct_exists(_comp_helms, "all_others")){
			// there's probably room to improve this but consecrators demand the stripe
			_complex_helm = _comp_helms.all_others;
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
		}
		for (var i = 0; i < array_length(_draw_order); i++) {
			if (_draw_order[i] == "head") {
				draw_head(_texture_draws);
			} else {
				draw_component(_draw_order[i], _texture_draws);
			}
		}
		purity_seals_and_hangings();
		draw_weapon_and_hands();

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
					left_knee: spr_mk3_left_knee,
					right_knee: spr_mk3_right_knee,
					mouth_variants: spr_mk3_mouth,
					forehead: spr_mk3_forehead_variants,
					belt: spr_mk3_belt
				});
				armour_type = ArmourType.Normal;
				break;
			case "MK8 Errant":
				add_group(mk7_bits);
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
			case "Cataphractii":
				add_group({
					head: spr_cata_head,
					belt : spr_cata_belt,
					gorget : spr_cata_gorget,
				});
				armour_type = ArmourType.Terminator;
				break;
			case "Dreadnought":
				add_group({
					armour: spr_dreadnought_complex
				});
				armour_type = ArmourType.Dreadnought;
				break;
			case "Contemptor Dreadnought":
				add_group({
					armour: spr_contemptor_chasis_colors,
					head: spr_contemptor_head_colors,
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

	static add_to_area = function(area, add_sprite, overide_data = "none", sub_components = "none", shadow = "none") {
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
			if (sub_components != "none") {
				add_sub_components(area, _overide_start, _add_sprite_length, sub_components);
			}
			if (shadow != "none" && sprite_exists(shadow)) {
				add_shadow_set(area, _overide_start, _add_sprite_length, shadow);
			}
		}
	};

	offsets=[];
	static add_offsets = function(area, _offset_start, sprite_length, overide_data){

	}

	static add_overide = function(area, _overide_start, sprite_length, overide_data) {
		if (!struct_exists(overides, area)) {
			overides[$ area] = [];
		}
		array_push(overides[$ area], [_overide_start, _overide_start + sprite_length, overide_data]);
	};

	shadow_set = {};

	static add_shadow_set = function(area, _shadow_set_start, sprite_length, shadow_data) {
		if (!struct_exists(shadow_set, area)) {
			shadow_set[$ area] = [];
		}
		array_push(shadow_set[$ area], [_shadow_set_start, _shadow_set_start + sprite_length, shadow_data]);
	};

	static add_sub_components = function(area, _overide_start, sprite_length, sub_components) {
		if (!struct_exists(subcomponents, area)) {
			subcomponents[$ area] = [];
		}
		var _accepted_subs = [];
		for (var i=0;i<array_length(sub_components);i++){
			var _subs = sub_components[i];
			var _sub_items = [];
			for (var s=0;s<array_length(_subs);s++){
				var _subby = _subs[s];
				if (is_struct(_subby)){
					var _allow = base_modulars_checks(_subby);
					if (_allow){
						array_push(_sub_items, _subby.sprite);
					}
				} else {
					array_push(_sub_items, _subby);
				}
			}
			if (array_length(_sub_items)){
				array_push(_accepted_subs, _sub_items);
			}
		}
		array_push(subcomponents[$ area], [_overide_start, _overide_start + sprite_length, _accepted_subs]);
	};

	static replace_area = function(area, add_sprite, overide_data = "none", sub_components = "none", shadow = "none") {
		remove_area(area);
		add_to_area(area, add_sprite, overide_data , sub_components)
	};

	static remove_area = function(area) {
		if (struct_exists(self, area)) {
			sprite_delete(self[$ area]);
			struct_remove(self, area);
			if (struct_exists(overides, area)) {
				struct_remove(overides, area);
			}
			if (struct_exists(subcomponents, area)) {
				struct_remove(subcomponents, area);
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

	static head_draw_order = [
	    "crest",
	    "head",
	    "forehead",
	    "mouth_variants",
	    "left_eye",
	    "right_eye",
	    "crown"
	];

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
