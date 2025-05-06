draw_size = column_size;

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
            composition_map.clear();
    
            for (var i = 0, l = array_length(units); i < l; i++){
                var _unit = units[i];
                composition_map.add($"{_unit.display_name}");
            }

            for (var i = 0, l = array_length(unit_squads); i < l; i++){
                var _unit_squad = unit_squads[i];
                composition_map.add($"{_unit_squad.display_name} Squad");
            }
    
            composition_string = composition_map.get_total_string();
        }

        draw_block_composition(x1, composition_string);
    }

    draw_block_fadein();
}
