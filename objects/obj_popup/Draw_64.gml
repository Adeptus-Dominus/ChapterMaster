// ** Promoting **
try {
    if (type == POPUP_TYPE.PROMOTION) {
        draw_popup_promotion();
    } else if (type == 5.1) {
        draw_popup_transfer();
    } else if (type == POPUP_TYPE.EQUIP) {
        draw_popup_equip();
    } else if (type == POPUP_TYPE.ITEM_GIFT) {
        draw_gift_items_popup();
    } else if (type == POPUP_TYPE.ARTIFACT_EQUIP) {
        equip_artifact_popup_draw();
    } else if (type == POPUP_TYPE.ADD_TAGS) {
        draw_tag_manager();
    } else {
        if (hide == true) {
            exit;
        }
        if (image == "debug") {
            size = 3;
        }

        if (instance_exists(obj_fleet)) {
            exit;
        }

        if (type == POPUP_TYPE.FLEET_MOVE) {
            draw_set_font(fnt_large);
            draw_set_halign(fa_center);
            draw_set_color(CM_GREEN_COLOR);

            if (!obj_controller.zoomed) {
                draw_text_transformed(__view_get(e__VW.XView, 0) + 320, __view_get(e__VW.YView, 0) + 60, "SELECT DESTINATION", 0.5, 0.5, 0);
            } else {
                draw_text_transformed(room_width / 2, 60 * 3, "SELECT DESTINATION", 1.5, 1.5, 0);
            }

            draw_set_halign(fa_left);
        } else if (type == 10) {
            target_comp += 1;
            draw_set_color(0);
            draw_set_alpha(target_comp / 60);
            draw_rectangle(0, 0, room_width, room_height, 0);
            draw_set_alpha(1);
            exit;
        }

        var zoom = 0;
        if (instance_exists(obj_controller)) {
            zoom = obj_controller.zoomed;
        }
        if (((zoom == 0) && (type <= 4)) || (type == 98)) {
            image_bot = 0;
            y_scale_mod = 1;

            popup_window_draw();

            if (image_wid > 0) {
                width -= image_wid + 10;
            }

            x1 = (1600 - sprite_width) / 2;
            y1 = (900 - sprite_height * y_scale_mod) / 2;

            draw_set_font(fnt_40k_14b);
            draw_set_halign(fa_center);
            draw_set_color(CM_GREEN_COLOR);

            if (fancy_title == 1) {
                draw_set_font(fnt_fancy);
                if (type == 1) {
                    draw_set_color(255);
                }
            }
            draw_text_transformed(x1 + (sprite_width / 2), y1 + (sprite_height * 0.07), string_hash_to_newline(string(title)), 1.1, 1.1, 0);
            // draw_text(xx+320.5,yy+123.5,string(title));

            draw_set_font(fnt_40k_14);
            draw_set_halign(fa_left);
            draw_set_color(CM_GREEN_COLOR);

            if (instance_exists(obj_turn_end)) {
                if (obj_turn_end.popups > 0) {
                    draw_text(x1 + 20, y1 + (sprite_height * 0.07), $"{obj_turn_end.current_popup}/{obj_turn_end.popups}");
                }
            }
            if (image == "debug") {
                draw_text_ext(x1 + 20, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, sprite_width - 40);
            } else if (image == "") {
                if (size == 1) {
                    draw_text_ext(x1 + 5, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, width);
                }
                if (size != 1) {
                    draw_text_ext(x1 + 25, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, width);
                }
                str_h = string_height_ext(string_hash_to_newline(string(text)), -1, width) + (sprite_height * 0.18);
            } else if (image != "") {
                if (size == 1) {
                    draw_text_ext(x1 + 15 + image_wid, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, width);
                }
                if (size != 1) {
                    draw_text_ext(x1 + 35 + image_wid, y1 + (sprite_height * 0.18), string_hash_to_newline(string(text)), -1, width);
                }
                str_h = string_height_ext(string_hash_to_newline(string(text)), -1, width) + (sprite_height * 0.18);
            }

            // if (image!="") then draw_text_ext(x1+126+150,y1+152,string(text),-1,384-150);
            // if (text2!="") then draw_text_ext(x1+126,y1+309,string(text2),-1,384);
            // TODO change this into an array in a function (like romanNumerals does in here)
            var img = default_popup_image_index();

            if ((img != -1) && (image != "") && (image_wid > 0)) {
                var sh = 999;
                if (size == 1) {
                    sh = 24;
                    scr_image("popup", img, x1 + 5, y1 + sh + 24, image_wid, image_hei);
                }
                if (size >= 2) {
                    sh = 24;
                    scr_image("popup", img, x1 + 25, y1 + sh + 24, image_wid, image_hei);
                }

                image_bot = (sprite_height * 0.07) + image_hei + 5;
            }

            try {
                draw_popup_options();
            } catch (_exception) {
                handle_exception(_exception);
                popup_default_close();
            }
        }

        if (type == "duel") {}
    }
} catch (_exception) {
    instance_destroy();
    handle_exception(_exception);
}
