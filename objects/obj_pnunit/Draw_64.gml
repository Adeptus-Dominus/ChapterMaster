draw_size = column_size;

if (draw_size > 0){
    draw_set_alpha(1);
    draw_set_color(c_red);

    if (veh_type[1]=="Defenses"){
        draw_size=0;
        if (instance_exists(obj_nfort)) then draw_size=400;
        draw_set_color(c_gray);
    }

    x1 = pos;
    y1 = 450 - (draw_size / 2);
    x2 = pos + 10;
    y2 = 450 + (draw_size / 2);

    if (is_mouse_over()) {
        draw_set_alpha(0.8);
    }

    draw_rectangle(x1, y1, x2, y2, 0);

    if (is_mouse_over()) {
        if (unit_count != unit_count_old) {
            unit_count_old = unit_count;
            composition_string = block_composition_string();
        }
        draw_block_composition(x1, composition_string);
    }

    draw_block_fadein()
}