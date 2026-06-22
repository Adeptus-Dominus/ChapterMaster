draw_set_alpha(1);
if (options <= 1) {
    draw_set_alpha(0.5);
}
draw_set_color(c_gray);
draw_rectangle(x, y, x + width, y + height, 0);
draw_set_font(fnt_40k_14);
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_text(x + (width / 2), y + 2, string_hash_to_newline(string(option[option_selected])));

tooltip = "";
tooltip2 = "";

if ((scr_hit(x, y, x + width, y + height) == true) && (obj_controller.dropdown_open == 0)) {
    if (options > 1) {
        draw_set_alpha(0.2);
        draw_set_color(c_white);
        draw_rectangle(x, y, x + width, y + height, 0);
    }

    if (mouse_button_clicked() && (opened == 0) && (options > 1)) {
        opened = 1;
        obj_controller.dropdown_open = 1;
    }
    draw_set_alpha(1);

    if (option_selected > 0) {
        if (option[option_selected] != "") {
            tooltip = option[option_selected];
            if ((target == "event_display") && (option[option_selected] != "None")) {
                tooltip = option[option_selected];
                tooltip2 = fetch_artifact(option_id[option_selected]).description();
            }
            if ((target == "event_display") && (option[option_selected] == "None")) {
                tooltip = "Display";
                tooltip2 = "There is no Artifact set to be displayed at the event.";
            }
        }
    }
}

if (opened == 1) {
    var yyy = 24;
    var y5 = y;
    var hi = 24;

    for (var i = 1; i <= options; i++) {
        if ((i != option_selected) && (i <= options)) {
            y5 += hi;
            yyy += hi;

            draw_set_alpha(1);
            draw_set_color(c_gray);
            draw_rectangle(x, y5, x + width, y5 + hi, 0);
            draw_set_font(fnt_40k_14);
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_text(x + (width / 2), y5 + 2, string_hash_to_newline(string(option[i])));
            draw_rectangle(x, y5, x + width, y5 + hi, 1);

            if (scr_hit(x, y5, x + width, y5 + hi) == true) {
                draw_set_alpha(0.2);
                draw_set_color(c_white);
                draw_rectangle(x, y5, x + width, y5 + hi, 0);

                tooltip = option[i];
                if ((target == "event_display") && (option[i] != "None")) {
                    tooltip = option[i];
                    tooltip2 = fetch_artifact(option_id[i]).description();
                }
                if ((target == "event_display") && (option[i] == "None")) {
                    tooltip = "Display";
                    tooltip2 = "There is no Artifact set to be displayed at the event.";
                }

                if (mouse_button_clicked()) {
                    obj_controller.dropdown_open = 0;
                    opened = 0;

                    var no = false;
                    if ((target == "event_type") && (option[i] != "Great Feast")) {
                        no = true;
                    }
                    if (no == false) {
                        option_selected = i;
                    }

                    if ((target == "event_type") && (option[i] == "Great Feast")) {
                        obj_controller.fest_type = option[i];
                        with (obj_dropdown_sel) {
                            if (target == "event_public") {
                                option[1] = "";
                            }
                            obj_controller.fest_locals = 0;
                        }
                        with (obj_dropdown_sel) {
                            if (target == "event_repeat") {
                                option[1] = "";
                            }
                            obj_controller.fest_repeats = 1;
                        }
                        with (obj_dropdown_sel) {
                            if (target == "event_honor") {
                                option[1] = "";
                            }
                            obj_controller.fest_honor = 0;
                        }

                        if (obj_controller.fest_type == "Triumphal March") {
                            obj_controller.fest_planet = 1;
                            obj_controller.fest_sid = 0;
                            obj_controller.fest_wid = 0;
                            with (obj_dropdown_sel) {
                                if (target == "event_loc") {
                                    option[1] = "";
                                    option_selected = 1;
                                }
                            }
                        }

                        with (obj_controller) {
                            fest_cost = 0;
                            fest_lav = 0;
                            fest_locals = 0;
                            fest_feature1 = 1;
                            fest_feature2 = 0;
                            fest_feature3 = 0;
                            fest_display = 0;
                            fest_repeats = 1;
                        }
                    }
                    if (target == "event_display") {
                        obj_controller.fest_display = option_id[option_selected];
                    }
                    if (target == "event_public") {
                        obj_controller.fest_locals = i - 1;
                    }
                    if (target == "event_loc") {
                        if (obj_controller.fest_planet == 0) {
                            obj_controller.fest_sid = option_id[i];
                            obj_controller.fest_wid = 0;
                            if (option_id[i] > 0) {
                                if ((obj_controller.fest_warp == 0) && (obj_ini.ship_location[option_id[i]] == "Warp")) {
                                    obj_controller.fest_warp = 1;
                                }
                                if ((obj_controller.fest_warp == 1) && (obj_ini.ship_location[option_id[i]] != "Warp")) {
                                    obj_controller.fest_warp = 0;
                                }
                                obj_controller.fest_attend = scr_event_dudes(0, 0, "", option_id[i]);
                            }
                            if (option[i] == "None Selected") {
                                obj_controller.fest_sid = 0;
                                obj_controller.fest_attend = "";
                            }
                        }
                        if (obj_controller.fest_planet == 1) {
                            obj_controller.fest_wid = option_id[i];
                            obj_controller.fest_sid = 0;
                            obj_controller.fest_star = option_star[i];
                            if (option[i] != "None Selected") {
                                obj_controller.fest_attend = scr_event_dudes(0, 1, option_star[i], option_id[i]);
                            }
                            if (option[i] == "None Selected") {
                                obj_controller.fest_wid = 0;
                                obj_controller.fest_star = "";
                                obj_controller.fest_attend = "";
                            }
                        }
                    }
                    if (target == "event_lavish") {
                        obj_controller.fest_lav = i;
                    }
                    if (target == "event_repeat") {
                        if (i <= 4) {
                            obj_controller.fest_repeats = i;
                        }
                        if (i == 5) {
                            obj_controller.fest_repeats = 12;
                        }
                    }
                }
                draw_set_alpha(1);
            }
        }
    }

    if (mouse_button_clicked() && (scr_hit(x, y, x + width, y5 + yyy) == false)) {
        opened = 0;
        obj_controller.dropdown_open = 0;
    }
}

if (tooltip == "Great Feast") {
    tooltip2 = "Holds a massive feast and celebration for your astartes.";
}
if ((tooltip != "Great Feast") && (target == "event_type")) {
    tooltip2 = "(NOT COMPLETED YET)";
}

if ((tooltip != "") && (tooltip2 != "")) {
    draw_set_alpha(1);
    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_left);
    draw_set_color(c_black);
    draw_rectangle(mouse_x + 18, mouse_y + 20, mouse_x + string_width_ext(string_hash_to_newline(tooltip2), -1, 500) + 24, mouse_y + 44 + string_height_ext(string_hash_to_newline(tooltip2), -1, 500), 0);
    draw_set_color(c_gray);
    draw_rectangle(mouse_x + 18, mouse_y + 20, mouse_x + string_width_ext(string_hash_to_newline(tooltip2), -1, 500) + 24, mouse_y + 44 + string_height_ext(string_hash_to_newline(tooltip2), -1, 500), 1);
    draw_set_font(fnt_40k_14b);
    draw_text(mouse_x + 22, mouse_y + 22, string_hash_to_newline(string(tooltip)));
    draw_set_font(fnt_40k_14);
    draw_text_ext(mouse_x + 22, mouse_y + 42, string_hash_to_newline(string(tooltip2)), -1, 500);
}
