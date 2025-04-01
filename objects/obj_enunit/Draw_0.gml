draw_size = min(400, column_size);

if (draw_size > 0){
    draw_set_alpha(1);
    draw_set_color(global.star_name_colors[obj_ncombat.enemy]);

    if (instance_exists(obj_centerline)){
        centerline_offset=x-obj_centerline.x;
    }

    x1 = pos + (centerline_offset * 2);
    y1 = 450 - (draw_size / 2);
    x2 = pos + (centerline_offset * 2) + 10;
    y2 = 450 + (draw_size / 2);

    if (hit()) {
        draw_set_alpha(0.8);
    }

    draw_rectangle(x1, y1, x2, y2, 0);

    if (hit()) {
        if (unit_count != unit_count_old) {
            unit_count_old = unit_count;
            if (obj_ncombat.enemy!=1){
                composition_string += block_composition_string();
            } else {
                var variety, variety_num, stop, sofar, compl, vas;
                stop = 0;
                variety = [];
                variety_num = [];
                sofar = 0;
                compl = "";
                vas = "";
        
                var variety_len = array_length(variety);
                for (var q = 0; q < variety_len; q++) {
                    variety[q] = "";
                    variety_num[q] = 0;
                }
                var dudes_len = array_length(dudes);
                for (var q = 0; q < dudes_len; q++) {
                    if (dudes[q] != "") and(string_count(string(dudes[q]) + "|", compl) = 0) {
                        compl += string(dudes[q]) + "|";
                        variety[sofar] = dudes[q];
                        variety_num[sofar] = 0;
                        sofar += 1;
                    }
                }
                var dudes_len = array_length(dudes);
                for (var q = 0; q < dudes_len; q++) {
                    if (dudes[q] != "") {
                        var variety_len = array_length(variety);
                        for (var i = 0; i < variety_len; i++) {
                            if (dudes[q] = variety[i]) then variety_num[i] += dudes_num[q];
                        }
                    }
        
                }
                stop = 0;
                var variety_num_len = array_length(variety_num);
                for (var i = 0; i < variety_num_len; i++) {
                    if (stop = 0) {
                        if (variety_num[i] > 0) and(variety_num[i + 1] > 0) then composition_string += string(variety_num[i]) + "x " + string(variety[i]) + ", ";
                        if (variety_num[i] > 0) and(variety_num[i + 1] <= 0) {
                            composition_string += string(variety_num[i]) + "x " + string(variety[i]) + ".  ";
                            stop = 1;
                        }
                    }
                }
            } 
        }

        draw_block_composition(x1, composition_string);
    }

    draw_block_fadein();
}
