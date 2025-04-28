draw_size = column_size * obj_ncombat.battlefield_scale;

if (draw_size > 0){
    draw_set_alpha(1);
    draw_set_color(column_draw_colour);

    if (instance_exists(obj_centerline)){
        centerline_offset=x-obj_centerline.x;
    }

    x1 = pos + (centerline_offset * 2);
    y1 = 450 - (draw_size / 2);
    x2 = pos + (centerline_offset * 2) + 10;
    y2 = 450 + (draw_size / 2);

    if (is_mouse_over()) {
        draw_set_alpha(0.8);
    }

    draw_rectangle(x1, y1, x2, y2, 0);

    if (is_mouse_over()) {
        if (unit_count() != unit_count_old) {
            unit_count_old = unit_count();
            var _counts_array = [];
            var _names_array = [];
            var _types_array = [];
    
            for (var i = 0, l = array_length(unit_squads); i < l; i++){
                var _unit_squad = unit_squads[i];
                array_push(_names_array, _unit_squad.display_name);
                array_push(_counts_array, _unit_squad.member_count);
            }
    
            composition_string = arrays_to_string_with_counts(_names_array, _counts_array, true);
        }

        draw_block_composition(x1, composition_string);
    }

    draw_block_fadein();
}
