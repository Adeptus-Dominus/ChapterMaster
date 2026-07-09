draw_size = min(400, column_size);

if (draw_size > 0) {
    draw_set_alpha(1);
    draw_set_color(c_red);

    if (instance_exists(obj_centerline)) {
        centerline_offset = x - obj_centerline.x;
    }

    if (veh_type[1] == "Defenses") {
        draw_size = 0;
        if (instance_exists(obj_nfort)) {
            draw_size = 400;
        }
        centerline_offset = 135;
        draw_set_color(c_gray);
    }

    x1 = pos + (centerline_offset * 2);
    x2 = pos + (centerline_offset * 2) + 10;

    var _stack_before = 0;
    if (veh_type[1] == "Defenses") {
        y1 = 450 - (draw_size / 2);
        y2 = 450 + (draw_size / 2);
    } else {
        // Formations sharing a column draw as stacked segments of one line, separated by
        // small gaps, instead of on top of each other, so each stays visible and
        // individually clickable (hit() reads these y1/y2). A block alone in its column
        // reduces exactly to the old centered-on-450 layout.
        var _seg_gap = 6;
        var _col_x = x;
        var _stack_total = 0;
        var _self_id = id;
        with (obj_pnunit) {
            if ((veh_type[1] != "Defenses") && (x == _col_x)) {
                var _seg = min(400, column_size);
                if (_seg > 0) {
                    _stack_total += _seg + _seg_gap;
                    if (id < _self_id) {
                        _stack_before += _seg + _seg_gap;
                    }
                }
            }
        }
        _stack_total -= _seg_gap;
        y1 = 450 - (_stack_total / 2) + _stack_before;
        y2 = y1 + draw_size;
    }

    if (hit()) {
        draw_set_alpha(0.8);
    }

    draw_rectangle(x1, y1, x2, y2, 0);

    // Order indicator (basic combat orders): a green chevron above advancing blocks,
    // an orange bar above holding ones, so each column's order reads at a glance.
    // The Defenses pseudo-block takes no orders and gets no marker.
    if ((move_order != "") && (veh_type[1] != "Defenses")) {
        draw_set_font(fnt_40k_14b);
        // Top segment keeps its floating marker; stacked lower segments draw theirs at
        // the segment's own top edge so markers never overlap the segment above.
        var _marker_y = (_stack_before == 0) ? (y1 - 20) : (y1 - 4);
        if (move_order == "advance") {
            draw_set_color(c_lime);
            draw_text(x1, _marker_y, ">");
        } else if (move_order == "retreat") {
            draw_set_color(c_yellow);
            draw_text(x1, _marker_y, "<");
        } else {
            draw_set_color(c_orange);
            draw_text(x1, _marker_y, "=");
        }
        draw_set_color(c_red);
    }

    if (hit()) {
        if (unit_count != unit_count_old) {
            unit_count_old = unit_count;
            composition_string = block_composition_string();
        }
        draw_block_composition(x1, composition_string);
    }

    draw_block_fadein();
}
