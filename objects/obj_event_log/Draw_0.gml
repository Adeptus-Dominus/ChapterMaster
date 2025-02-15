var __b__;
__b__ = action_if_variable(help, 0, 0);
if (__b__) {
    var bad = 1;
    if (instance_exists(obj_controller)) {
        if (obj_controller.menu = 17) {
            bad = 0;
        }
    }
    if (bad = 0) {
        var ent;
        var xx = __view_get(e__VW.XView, 0) + 0;
        var yy = __view_get(e__VW.YView, 0) + 0;
        draw_set_alpha(1);
        draw_set_color(0);
        draw_rectangle(xx, yy, xx + 1600, yy + 900, 0);
        draw_set_alpha(0.5);
        draw_sprite(spr_rock_bg, 0, xx, yy);
        draw_set_alpha(1);
        draw_set_color(c_gray); // 38144
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_text(xx + 800, yy + 74, string(global.chapter_name) + " Event Log");
        draw_set_halign(fa_left);
        var t = 0,
            p = -1,
            cur_event;
        var ent = array_length(event);
        draw_set_color(38144);
        if (ent == 0) {
            draw_text(xx + 25, yy + 120, "No entries logged.");
        } else {
            p = -1;
            draw_set_font(fnt_40k_14);
            draw_set_alpha(0.8);
            for (var t=top - 1; t<ent; t++){
                p++;
                cur_event = event[t];
                if (cur_event.text != "") { // 1554
                    set_alert_draw_colour(cur_event.colour);
                    draw_text_ext(xx + 25, yy + 120 + (p * 26), $"{cur_event.date}  (Turn {cur_event.turn}) - {cur_event.text}", -1, 1554);
                    if (cur_event.event_target != "none") {
                        if (point_and_click(draw_unit_buttons([xx + 1400, yy + 120 + (p * 26)], "View", [1, 1], c_green, , fnt_40k_14b, 1,true))) {
                            var view_star = star_by_name(cur_event.event_target);
                            if (view_star != "none") {
                                obj_controller.menu = 0;
                                obj_controller.hide_banner = 0;
                                obj_controller.x = view_star.x;
                                obj_controller.y = view_star.y;
                            }
                        }
                    }
                }
            }
        }
        var x1, y1, x2, y2, scrolly, chunk_size, my, y5;
        x1 = xx + 1557;
        y1 = yy + 117;
        x2 = xx + 1583;
        y2 = yy + 823;
        draw_rectangle(x1, y1, x2, y2, 1);
        cubey = 30;
        scrolly = (y2 - y1) + 12; // The maximum amount of moving around that the cube does
        my = max(1, ent - 24); // The maximum number of scroll chunks
        chunk_size = scrolly / (my);
        y5 = (top - 1) * chunk_size;
        draw_rectangle(x1, y1 + y5, x2, y1 + y5 + cubey, 0);
    }
    draw_set_alpha(1);
}

__b__ = action_if_variable(help, 1, 0);
if (__b__) {
    var xx, yy;
    xx = __view_get(e__VW.XView, 0);
    yy = __view_get(e__VW.YView, 0);
    draw_set_color(0);
    draw_set_alpha(0.75);
    draw_rectangle(0, 0, room_width, room_height, 0);
    draw_set_alpha(1);
    draw_sprite(spr_help_panel, 0, xx, yy);
    if (scr_hit(xx + 1104, yy + 72, xx + 1137, yy + 105) = false) {
        draw_sprite(spr_help_exit, 0, xx + 1104, yy + 72);
    }
    if (scr_hit(xx + 1104, yy + 72, xx + 1137, yy + 105) = true) {
        draw_sprite(spr_help_exit, 1, xx + 1104, yy + 72);
        if (obj_controller.mouse_left = 1) and(obj_controller.cooldown <= 0) {
            with(obj_controller) {
                menu = 0;
                onceh = 1;
                cooldown = 8000;
                click = 1;
                hide_banner = 0;
            }
            help = 0;
        }
    }
    var t, x1, y1;
    x1 = 0;
    y1 = 0;
    t = 0;
    draw_set_color(c_black);
    draw_rectangle(xx + 466, yy + 136, xx + 644, yy + 166, 0);
    draw_set_color(c_gray);
    draw_rectangle(xx + 466 + 1, yy + 136 + 1, xx + 644 - 1, yy + 166 - 1, 1);
    draw_rectangle(xx + 466 + 2, yy + 136 + 2, xx + 644 - 2, yy + 166 - 2, 1);
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    draw_text(xx + 466 + 4, yy + 136 + 6, string_hash_to_newline("Topics"));
    x1 = xx + 466;
    y1 = yy + 166;
    repeat(20) {
        t += 1;
        if (topics[t] != "") {
            draw_set_color(c_gray);
            draw_set_alpha(0.75);
            if (topic = topics[t]) {
                draw_set_alpha(1);
            }
            draw_text(x1 + 2, y1 + 2, string_hash_to_newline(string(topics[t])));
            if (scr_hit(x1, y1, x1 + 198, y1 + 22) = true) {
                draw_set_alpha(0.2);
                draw_rectangle(x1, y1, x1 + 198, y1 + 22, 0);
                draw_set_alpha(1);
                if (obj_controller.mouse_left = 1) and(obj_controller.cooldown <= 0) {
                    obj_controller.cooldown = 8000;
                    topic = topics[t];
                    ini_open("main\\help.ini");
                    info = ini_read_string(string(t), "info", "");
                    strategy = ini_read_string(string(t), "strategy", "");
                    main_info = ini_read_string(string(t), "main_info", "");
                    related[1] = ini_read_string(string(t), "related_1", "");
                    related[2] = ini_read_string(string(t), "related_2", "");
                    related[3] = ini_read_string(string(t), "related_3", "");
                    ini_close();
                }
            }
            y1 += 24;
        }
    }
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_set_halign(fa_center);
    // draw_rectangle(xx+664,yy+148,xx+805,yy+316,0);
    if (topic != "") {
        draw_set_font(fnt_40k_14b);
        draw_text_transformed(xx + 897, yy + 131, string_hash_to_newline(string(topic)), 1.25, 1.25, 0);
        draw_set_halign(fa_left);
        if (info != "") {
            draw_text(xx + 663, yy + 177, string_hash_to_newline("Game Info:"));
        }
        draw_set_font(fnt_40k_14);
        var p1, y2;
        y2 = 0;
        p1 = string(info);
        if (info != "") {
            draw_text_ext(xx + 663, yy + 197, string_hash_to_newline(string(p1)), -1, 469);
        }
        if (info = "") {
            y2 -= 40;
        }
        if (strategy != "") {
            y2 += string_height_ext(string_hash_to_newline(string(p1)), -1, 469) + 20;
            y2 += 20;
            p1 = string(strategy);
            draw_set_font(fnt_40k_14b);
            draw_text(xx + 663, yy + 177 + y2, string_hash_to_newline("Strategy:"));
            draw_set_font(fnt_40k_14);
            y2 += 20;
            draw_text_ext(xx + 663, yy + 177 + y2, string_hash_to_newline(string(p1)), -1, 469);
        }
        if (main_info != "") {
            y2 += string_height_ext(string_hash_to_newline(string(p1)), -1, 469) + 20;
            p1 = string(main_info);
            draw_set_font(fnt_40k_14b);
            draw_text(xx + 663, yy + 177 + y2, string_hash_to_newline("Info:"));
            draw_set_font(fnt_40k_14);
            y2 += 20;
            draw_text_ext(xx + 663, yy + 177 + y2, string_hash_to_newline(string(p1)), -1, 469);
        }
        if (related[1] != "") {
            y2 += string_height_ext(string_hash_to_newline(string(p1)), -1, 469) + 20;
            p1 = "";
            if (related[1] != "") {
                p1 += string(related[1]);
            }
            if (related[2] != "") {
                p1 += ", " + string(related[2]);
            }
            if (related[3] != "") {
                p1 += ", " + string(related[3]);
            }
            p1 += ".";
            draw_set_font(fnt_40k_14b);
            draw_text(xx + 663, yy + 177 + y2, string_hash_to_newline("See Also:"));
            draw_set_font(fnt_40k_14);
            y2 += 20;
            draw_text_ext(xx + 663, yy + 177 + y2, string_hash_to_newline(string(p1)), -1, 469);
        }
    }
}
