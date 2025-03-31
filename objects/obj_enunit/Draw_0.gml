draw_size = min(400, column_size);

if (draw_size > 0){
    draw_set_alpha(1);
    draw_set_color(c_maroon);
    if (obj_ncombat.enemy=2) then draw_set_color(8307806);
    if (obj_ncombat.enemy=3) then draw_set_color(16512);
    if (obj_ncombat.enemy=5) then draw_set_color(c_silver);
    if (obj_ncombat.enemy=6) then draw_set_color(33023);
    if (obj_ncombat.enemy=7) then draw_set_color(38144);
    if (obj_ncombat.enemy=8) then draw_set_color(117758);
    if (obj_ncombat.enemy=9) then draw_set_color(7492269);
    if (obj_ncombat.enemy=10) then draw_set_color(c_purple);
    if (obj_ncombat.enemy=13) then draw_set_color(65408);

    if (instance_exists(obj_centerline)){
        centerline_offset=x-obj_centerline.x;
    }

    var _hit = scr_hit(pos+(centerline_offset*2),450-(draw_size/2),pos+(centerline_offset*2)+10,450+(draw_size/2)) && obj_ncombat.fadein<=0;
    if (_hit) {
        draw_set_alpha(0.8);
    }
    draw_rectangle(pos+(centerline_offset*2),450-(draw_size/2),pos+(centerline_offset*2)+10,450+(draw_size/2),0);

    if (_hit) {
        if (unit_count != unit_count_old) {
            unit_count_old = unit_count;
            if (obj_ncombat.enemy!=1){
                composition_string += string_unit_composition();
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

        draw_set_alpha(1);
        draw_set_color(38144);
        draw_line_width(pos+(centerline_offset*2)+5,450,817,685, 2);
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
