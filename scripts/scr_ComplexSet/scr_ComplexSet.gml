
function ComplexSet() constructor{
    static add_to_area = function(area, add_sprite){
        if (!struct_exists(self, area)){
            self[$ area] = sprite_duplicate(add_sprite);
        } else {
            sprite_merge(self[$ area], add_sprite);
        }
    }

    static replace_area = function(area, add_sprite){
        if (struct_exists(self, area)){
            sprite_delete(self[$area]);
        }
        self[$ area] = sprite_duplicate(add_sprite);
    }

    static remove_area = function(area){
        if (struct_exists(self, area)){
            sprite_delete(self[$area]);
            struct_remove(self, area);
        }
    }

    static add_group = function(group){
        var _areas = struct_get_names(group);
        for (var i=0;i<array_length(_areas); i++){
            var _area = _areas[i];
            add_to_area(_area, group[$_area]);
        }
    }

    static add_relative_to_status = function(area, add_sprite, status_level, variant, unit){
    	var _roles = obj_ini.role[100];
    	var tiers = [
    		["Chapter Master"],
    		["Forge Master", "Master of Sanctity","Master of the Apothecarion",string("Chief {0}",_roles[eROLE.Librarian])],
    		[_roles[eROLE.Captain]],
    		[_roles[eROLE.HonourGuard]],
    		[_roles[eROLE.Ancient], _roles[eROLE.Champion]],
    		[_roles[eROLE.VeteranSergeant], _roles[eROLE.Terminator]],
    		[_roles[eROLE.Veteran], _roles[eROLE.Sergeant],_roles[eROLE.Chaplain],_roles[eROLE.Apothecary],_roles[eROLE.Techmarine],_roles[eROLE.Librarian]],
    		["Codiciery", "Lexicanum",_roles[eROLE.Tactical],_roles[eROLE.Assault],_roles[eROLE.Devastator]],
    		[_roles[eROLE.Scout],]
    	];

    	var _unit_tier = 8;
    	if (_unit_tier==8){
	    	for (var i=0;i<array_length(tiers);i++){
	    		var tier = tiers[i];
	    		if (array_contains(tier, unit.role())){
	    			_unit_tier = i;
	    		}
	    	}
	    }
    	if (_unit_tier<=status_level){
    		add_to_area(area, add_sprite);
    	} else {
    		var variation_tier = (_unit_tier - status_level)+1;
    		if (variant%variation_tier == 0){
    			add_to_area(area, add_sprite);
    		}
    	}
    }

    static draw_cloaks = function(unit,x_offset,y_offset){
        var type = unit.get_body_data("type","cloak");
        if (type != "none") {
            var _cloaks = {
                "scale":spr_cloak_scale,
                "pelt":spr_cloak_fur,
                "cloth":spr_cloak_cloth,
            }
            if (struct_exists(_cloaks, type)){
                var _draw_sprite  = _cloaks[$ type];
                var _shader_set_multiply_blend = function(_r, _g, _b) {
                    shader_set(shd_multiply_blend);
                    shader_set_uniform_f(shader_get_uniform(shd_multiply_blend, "u_Color"), _r, _g, _b);
                };          
                _shader_set_multiply_blend(127, 107, 89);
                var choice = unit.get_body_data("variant","cloak")%sprite_get_number(_draw_sprite);
                draw_sprite(_draw_sprite,choice,x_offset,y_offset);
                if (_draw_sprite == spr_cloak_cloth) {
                    _shader_set_multiply_blend(obj_controller.trim_colour_replace[0]*255, obj_controller.trim_colour_replace[1]*255, obj_controller.trim_colour_replace[2]*255);
                    var choice = unit.get_body_data("image_0","cloak")%sprite_get_number(spr_cloak_image_0);
                    draw_sprite(spr_cloak_image_0,choice,x_offset,y_offset);
                    var choice = unit.get_body_data("image_1","cloak")%sprite_get_number(spr_cloak_image_1);
                    draw_sprite(spr_cloak_image_1,choice,x_offset,y_offset);
                }
                shader_reset();
            }
            
        }
        shader_set(full_livery_shader);
    }

    static draw_head = function(unit, x_surface_offset,y_surface_offset){
        var choice;
        if (struct_exists(self, "head")){
            if (struct_exists(self, "crest")){
                choice = unit.get_body_data("crest_variation","head")%sprite_get_number(crest);
                draw_sprite(self.crest,choice,x_surface_offset,y_surface_offset);
            }
            var choice = unit.get_body_data("variation","head")%sprite_get_number(head);
            draw_sprite(head,choice,x_surface_offset,y_surface_offset);
            
            if (struct_exists(self, "forehead")){
                choice = unit.get_body_data("forehead_variation","head")%sprite_get_number(forehead);
                draw_sprite(forehead,choice,x_surface_offset,y_surface_offset);
            } 
            if (struct_exists(self, "mouth_variants")){
                choice = unit.get_body_data("variant","jaw")%sprite_get_number(mouth_variants);
                draw_sprite(mouth_variants,choice,x_surface_offset,y_surface_offset);
            }
            if (struct_exists(self, "left_eye")){
                choice = unit.get_body_data("variant","left_eye")%sprite_get_number(left_eye);
                draw_sprite(left_eye,choice,x_surface_offset,y_surface_offset);
            }
            if (struct_exists(self, "right_eye")){
                choice = unit.get_body_data("variant","right_eye")%sprite_get_number(right_eye);
                draw_sprite(right_eye,choice,x_surface_offset,y_surface_offset);
            }
            if  (struct_exists(self, "crown")){
                var choice = unit.get_body_data("crown_variation","head")%sprite_get_number(crown);
                draw_sprite(crown,choice,x_surface_offset,y_surface_offset);                                
            }                                                                                 
        }
    }

    static complex_helms = function(data,unit){
        set_complex_shader_area(["eye_lense"], data.helm_lens);
        if (data.helm_pattern == 0){
            set_complex_shader_area(["left_head", "right_head","left_muzzle", "right_muzzle"], data.helm_secondary);

        } else if (data.helm_pattern == 2){
            set_complex_shader_area(["left_head", "right_head"], data.helm_primary);
            set_complex_shader_area(["left_muzzle", "right_muzzle"], data.helm_secondary);
        } else if (data.helm_pattern==1 || data.helm_pattern == 3){
            var _surface_width = sprite_get_width(head);
            var _surface_height = sprite_get_height(head);
            var _head_surface = surface_create(_surface_width, 60);
            var _decoration_surface = surface_create(_surface_width, 60);
            shader_reset();
            surface_set_target(_head_surface);
            draw_head(unit, 0, 0);
            surface_reset_target();
            
            remove_area("mouth_variants");
            remove_area("crest");
            remove_area("forehead");

            shader_set(helm_shader);
            surface_set_target(_decoration_surface);
            shader_set_uniform_f_array(shader_get_uniform(helm_shader, "replace_colour"), get_shader_array(data.helm_secondary));
            draw_sprite(spr_helm_stripe, data.helm_pattern==1?0:1, 0, 0);
            surface_reset_target();
            shader_reset();

            var _swaps = [
                make_colour_rgb(0, 0, 128),
                make_colour_rgb(0, 0, 255),
                make_colour_rgb(128, 64, 255),
                make_colour_rgb(64, 128, 255),
            ];
            blend_mode_custom(_decoration_surface,_head_surface,_swaps);

            head = sprite_create_from_surface(_head_surface, 0, 0, _surface_width, 60, false, false, 0, 0);
            surface_free(_head_surface);
            surface_free(_decoration_surface);
            shader_set(full_livery_shader);
            set_complex_shader_area(["left_head", "right_head","left_muzzle", "right_muzzle"], data.helm_primary);
        }
    }

}

function get_complex_set(set = eARMOUR_SET.MK7){
    var set_pieces = new ComplexSet();

    if (!array_contains([eARMOUR_SET.Indomitus, eARMOUR_SET.Tartaros], set)) {
        set_pieces.add_group({
            right_pauldron : spr_gothic_numbers_right_pauldron,
            left_knee : spr_numeral_left_knee
        })
    }

    if (set == eARMOUR_SET.MK7){
        set_pieces.add_group({
            armour : spr_mk7_complex,
            left_arm : spr_mk7_left_arm,
            right_arm : spr_mk7_right_arm,
            left_trim : spr_mk7_left_trim,
            right_trim : spr_mk7_right_trim,
            mouth_variants : spr_mk7_mouth_variants,
            thorax_variants : spr_mk7_thorax_variants,
            chest_variants : spr_mk7_chest_variants,
            leg_variants : spr_mk7_leg_variants,
            backpack : spr_mk7_complex_backpack,
            head : spr_mk7_head_variants,
        });       
    }else if (set == eARMOUR_SET.MK6){
        set_pieces.add_group({
            armour: spr_mk6_complex,
            backpack: spr_mk6_complex_backpack,
            left_arm: spr_mk6_left_arm,
            right_arm: spr_mk6_right_arm,
            left_trim :spr_mk7_left_trim,
            right_trim: spr_mk7_right_trim,
            mouth_variants : spr_mk6_mouth_variants,
            head : spr_mk6_head_variants,
        });
    }else if (set == eARMOUR_SET.MK5){
        set_pieces.add_group({
            armour: spr_mk5_complex,
            backpack: spr_mk5_complex_backpack,
            left_arm: spr_mk5_left_arm,
            right_arm: spr_mk5_right_arm,
            left_trim :spr_mk7_left_trim,
            right_trim: spr_mk7_right_trim,
            head : spr_mk5_head_variants,
        });        
    }else if (set == eARMOUR_SET.MK4){
        set_pieces.add_group({
            chest_variants: spr_mk4_chest_variants,
            armour: spr_mk4_complex,
            backpack: spr_mk4_complex_backpack,
            left_arm :spr_mk4_left_arm,
            leg_variants: spr_mk4_leg_variants,
            right_arm: spr_mk4_right_arm,
            left_trim: spr_mk4_left_trim,
            right_trim: spr_mk4_right_trim,
            mouth_variants: spr_mk4_mouth_variants,
            head : spr_mk4_head_variants,
        });                 
    }else if (set == eARMOUR_SET.MK3){
        set_pieces.add_group({
            armour : spr_mk3_complex,
            backpack : spr_mk3_complex_backpack,
            left_arm : spr_mk3_left_arm,
            right_arm : spr_mk3_right_arm ,   
            head : spr_mk3_head_variants, 
            left_leg : spr_mk3_left_leg_variants,
            right_leg : spr_mk3_right_leg_variants           
        });    
    }else if (set == eARMOUR_SET.MK8){
        set_pieces.add_group({
            armour : spr_mk7_complex,
            backpack : spr_mk7_complex_backpack,
            left_arm : spr_mk7_left_arm,
            right_arm : spr_mk7_right_arm,
            left_trim : spr_mk7_left_trim,
            right_trim : spr_mk7_right_trim,
            mouth_variants : spr_mk7_mouth_variants,
            thorax_variants : spr_mk7_thorax_variants,
            chest_variants : spr_mk7_chest_variants,
            leg_variants : spr_mk7_leg_variants,
            gorget : spr_mk8_gorget,
            head : spr_mk7_head_variants,
        });
    }else if (set == eARMOUR_SET.Indomitus){
         set_pieces.add_group({
            armour : spr_indomitus_complex,
            left_arm : spr_indomitus_left_arm,
            right_arm : spr_indomitus_right_arm,
            backpack : spr_indomitus_backpack_variants,
            chest_variants : spr_indomitus_chest_variants,
            leg_variants : spr_indomitus_leg_variants,
            head : spr_indomitus_head_variants         
        });                         
    }else if (set == eARMOUR_SET.Tartaros){
            set_pieces.add_group({
            armour : spr_tartaros_complex,
            left_arm : spr_tartaros_left_arm,
            right_arm : spr_tartaros_right_arm, 
            right_leg : spr_tartaros_right_leg,
            left_leg : spr_tartaros_left_leg,
            chest_variants : spr_tartaros_chest,
            gorget : spr_tartaros_gorget,
            mouth_variants : spr_tartaros_faceplate,
            head : spr_tartaros_head_variants,
            left_trim : spr_tartaros_left_trim,
            right_trim : spr_tartaros_right_trim,

        });                
    }

    return set_pieces;
}


/// blend_mode_custom(source_surface, destination_surface)
function blend_mode_custom(source_surface, destination_surface, allowed_cross_colours) {
    // Set the target for reading the destination surface
    surface_set_target(destination_surface);

    // Get surface size
    var _surface_width = surface_get_width(destination_surface);
    var _surface_height = surface_get_height(destination_surface);

    var allowed_colour_r=[];
    var allowed_colour_g=[];
    var allowed_colour_b=[];
    for (var i = 0; i < array_length(allowed_cross_colours); i++) {
        var allowed_color = allowed_cross_colours[i];
        array_push(allowed_colour_r, color_get_red(allowed_color));
        array_push(allowed_colour_g, color_get_green(allowed_color));
        array_push(allowed_colour_b, color_get_blue(allowed_color));
    }

    // Loop through each pixel
    for (var _y = 0; _y < _surface_height; _y++) {
        var had_colour_this_row = false;
        for (var _x = 75; _x < 90; _x++) {
            
            // Get the destination pixel color

            var col = surface_getpixel_ext(destination_surface, _x, _y)
            var _alpha = (col >> 24) & 255;
            if (_alpha<150){
                
                if (_x>=80){
                    break;
                };
                continue;
            } 
            var dest_color = surface_getpixel(destination_surface, _x, _y);

            var scource_alpha = (surface_getpixel_ext(source_surface, _x, _y) >>24 &255);
            if (scource_alpha<150){
                if (had_colour_this_row){
                    break;
                } else {
                    continue;
                }
            } else {
                had_colour_this_row = true;
            }
            // Extract RGB components
            var dest_r = color_get_red(dest_color);
            var dest_g = color_get_green(dest_color);
            var dest_b = color_get_blue(dest_color);
            
            // Check if destination color matches allowed colors
            var is_allowed = false;
            for (var i = 0; i < array_length(allowed_cross_colours); i++) {
                var allowed_color = allowed_cross_colours[i];
                if (dest_r!=allowed_colour_r[i]) then continue;
                if (dest_g!=allowed_colour_g[i]) then continue;
                if (dest_b!=allowed_colour_b[i]) then continue;
                is_allowed = true;
                break;
            }
            if (!is_allowed) then continue;
            
            // Get the source pixel
            var src_color = surface_getpixel(source_surface, _x, _y);
            var src_r = color_get_red(src_color);
            var src_g = color_get_green(src_color);
            var src_b = color_get_blue(src_color);
            
            // Apply the blending logic

            var final_color = make_color_rgb(src_r, src_g, src_b);
            // Draw the blended pixel
            draw_set_color(final_color);
            draw_point(_x, _y);                 
        }
    }

    // Reset the target
    surface_reset_target();
}