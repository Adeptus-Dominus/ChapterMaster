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

    static draw_cloaks = function(unit,x_offset,y_offset){
        var type = unit.get_body_data("type","cloak");
        if (type != spr_none) {
		    var _shader_set_multiply_blend = function(_r, _g, _b) {
		        shader_set(shd_multiply_blend);
		        shader_set_uniform_f(shader_get_uniform(shd_multiply_blend, "u_Color"), _r, _g, _b);
		    };        	
            _shader_set_multiply_blend(127, 107, 89);
            var choice = unit.get_body_data("variant","cloak")%sprite_get_number(type);
            draw_sprite(type,choice,x_offset,y_offset);
            if (type == spr_cloak_cloth) {
                _shader_set_multiply_blend(obj_controller.trim_colour_replace[0]*255, obj_controller.trim_colour_replace[1]*255, obj_controller.trim_colour_replace[2]*255);
                var choice = unit.get_body_data("image_0","cloak")%sprite_get_number(spr_cloak_image_0);
                draw_sprite(spr_cloak_image_0,choice,x_offset,y_offset);
                var choice = unit.get_body_data("image_1","cloak")%sprite_get_number(spr_cloak_image_1);
                draw_sprite(spr_cloak_image_1,choice,x_offset,y_offset);
            }
            shader_reset();
            
        }
        shader_set(full_livery_shader);
    }

    static complex_helms = function(data,choice){

        set_complex_shader_area(["eye_lense"], data.helm_lens);
        if (data.helm_pattern == 0){
            set_complex_shader_area(["left_head", "right_head","left_muzzle", "right_muzzle"], data.helm_secondary);

        } else if (data.helm_pattern == 2){
            set_complex_shader_area(["left_head", "right_head"], data.helm_primary);
            set_complex_shader_area(["left_muzzle", "right_muzzle"], data.helm_secondary);
        } else if (data.helm_pattern==1 || data.helm_pattern == 3){
            set_complex_shader_area(["left_head", "right_head","left_muzzle", "right_muzzle"], data.helm_primary);
            var _surface_width = sprite_get_width(head)
            var _surface_height = sprite_get_height(head)
            var _head_surface = surface_create(_surface_width, 60);
            var _decoration_surface = surface_create(_surface_width, 60);
            shader_reset();
            surface_set_target(_head_surface);
            draw_sprite(head, choice, 0, 0);
            surface_reset_target();

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

    // Loop through each pixel
    for (var _x = 60; _x < 110; _x++) {
        for (var _y = 0; _y < _surface_height; _y++) {
            // Get the destination pixel color

            var col = surface_getpixel_ext(destination_surface, _x, _y)
            var _alpha = (col >> 24) & 255;
            if (_alpha<200) then continue;
            var dest_color = surface_getpixel(destination_surface, _x, _y);

            var scource_alpha = (surface_getpixel_ext(source_surface, _x, _y) >>24 &255);
            if (_alpha<200) then continue;
            // Extract RGB components
            var dest_r = color_get_red(dest_color);
            var dest_g = color_get_green(dest_color);
            var dest_b = color_get_blue(dest_color);
            
            // Check if destination color matches allowed colors
            var is_allowed = false;
            for (var i = 0; i < array_length(allowed_cross_colours); i++) {
                var allowed_color = allowed_cross_colours[i];
                if (dest_r == color_get_red(allowed_color) &&
                    dest_g == color_get_green(allowed_color) &&
                    dest_b == color_get_blue(allowed_color)) {
                    is_allowed = true;
                    break;
                }
            }
            
            // Get the source pixel
            var src_color = surface_getpixel(source_surface, _x, _y);
            var src_r = color_get_red(src_color);
            var src_g = color_get_green(src_color);
            var src_b = color_get_blue(src_color);
            
            // Apply the blending logic
            if (is_allowed){
                var final_color = make_color_rgb(src_r, src_g, src_b);
                // Draw the blended pixel
                draw_set_color(final_color);
                draw_point(_x, _y);                
            }
            
        }
    }

    // Reset the target
    surface_reset_target();
}