draw_size = min(400, column_size);

if (draw_size > 0){
    draw_set_alpha(1);
    draw_set_color(c_red);

    if (instance_exists(obj_centerline)){
        centerline_offset=x-obj_centerline.x;
    }

    if (veh_type[1]=="Defenses"){
        draw_size=0;
        if (instance_exists(obj_nfort)) then draw_size=400;
        centerline_offset=135;
        draw_set_color(c_gray);
    }

    var _draw_coords = {
        x1: pos + (centerline_offset * 2),
        y1: 450 - (draw_size / 2),
        x2: pos + (centerline_offset * 2) + 10,
        y2: 450 + (draw_size / 2)
    };

    var _hit = scr_hit(_draw_coords.x1, _draw_coords.y1, _draw_coords.x2, _draw_coords.y2) && obj_ncombat.fadein <= 0;

    if (_hit) {
        draw_set_alpha(0.8);
    }
    draw_rectangle(_draw_coords.x1, _draw_coords.y1, _draw_coords.x2, _draw_coords.y2, 0);

    if (_hit) {
        if (unit_count != unit_count_old) {
            unit_count_old = unit_count;
            composition_string = string_unit_composition();
        }
        draw_set_alpha(1);
        draw_set_color(38144);
        draw_line_width(_draw_coords.x1+5,450,817,685, 2);
        draw_set_font(fnt_40k_14b);
        draw_text(817,688,"Row Composition:");
        draw_set_font(fnt_40k_14);
        draw_text_ext(817,710,composition_string,-1,758);   
    }

    if (obj_ncombat.fadein > 0) {
        draw_set_color(c_black);
        draw_set_alpha(obj_ncombat.fadein/30);
        draw_rectangle(822,239,1574,662,0);
        draw_set_alpha(1);
    }
}