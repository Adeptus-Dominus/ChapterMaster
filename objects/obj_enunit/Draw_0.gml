draw_size = min(BATTLE_SEG_MAX, column_size);

if (draw_size > 0) {
    draw_set_alpha(1);
    draw_set_color(column_draw_colour);

    if (instance_exists(obj_centerline)) {
        centerline_offset = x - obj_centerline.x;
    }

    x1 = pos + (centerline_offset * 2);
    x2 = pos + (centerline_offset * 2) + 10;

    // Formation segments sharing a column draw stacked with small gaps instead of on top
    // of each other, so every segment of an enemy line stays visible and individually
    // hoverable (hit() reads these y1/y2). Mirrors obj_pnunit's stacking exactly,
    // including the compression that keeps a tall stack inside the field frame. A column
    // holding one segment reduces to the old centred layout.
    var _seg_gap = 6;
    var _col_x = x;
    var _self_id = id;
    var _stack_total = 0;
    var _stack_before = 0;
    with (obj_enunit) {
        if (x == _col_x) {
            var _seg = min(BATTLE_SEG_MAX, column_size);
            if (_seg > 0) {
                _stack_total += _seg + _seg_gap;
                if (id < _self_id) {
                    _stack_before += _seg + _seg_gap;
                }
            }
        }
    }
    _stack_total -= _seg_gap;
    var _fit = (_stack_total > BATTLE_FIELD_H) ? (BATTLE_FIELD_H / _stack_total) : 1;
    draw_size *= _fit;
    y1 = BATTLE_FIELD_CY - ((_stack_total * _fit) / 2) + (_stack_before * _fit);
    y2 = y1 + draw_size;

    if (hit()) {
        draw_set_alpha(0.8);
    }

    draw_rectangle(x1, y1, x2, y2, 0);

    if (hit()) {
        if (unit_count != unit_count_old) {
            unit_count_old = unit_count;
            if (obj_ncombat.enemy != eFACTION.PLAYER) {
                composition_string = block_composition_string();
            } else {
                var variety = [];
                var variety_num = [];
                var sofar = 0;
                var compl = "";

                var variety_len = array_length(variety);
                for (var q = 0; q < variety_len; q++) {
                    variety[q] = "";
                    variety_num[q] = 0;
                }

                var dudes_len = array_length(dudes);
                for (var q = 0; q < dudes_len; q++) {
                    if ((dudes[q] != "") && (string_count(string(dudes[q]) + "|", compl) == 0)) {
                        compl += string(dudes[q]) + "|";
                        variety[sofar] = dudes[q];
                        variety_num[sofar] = 0;
                        sofar += 1;
                    }
                }

                dudes_len = array_length(dudes);
                for (var q = 0; q < dudes_len; q++) {
                    if (dudes[q] != "") {
                        variety_len = array_length(variety);
                        for (var i = 0; i < variety_len; i++) {
                            if (dudes[q] == variety[i]) {
                                variety_num[i] += dudes_num[q];
                            }
                        }
                    }
                }

                composition_string = arrays_to_string_with_counts(variety, variety_num, true);
            }
        }

        // Name the segment above its roster so the player can tell which formation a
        // stacked bar is before ordering fire at it.
        var _seg_label = (formation_type != "") ? $"{enemy_formation_display_name(formation_type)}\n" : "";
        draw_block_composition(x1, _seg_label + composition_string);
    }

    draw_block_fadein();
}
