slate_panel.inside_method = function() {
    draw_set_color(#50a076);
    var cus = false;
    var draw_func;
    var sprx = 0;
    var spry = 0;
    var sprw = 0;
    var sprh = 0;

    switch (header) {
        case 3:
            panel_width = 177;
            panel_height = 200;
            break;
        case 2:
            panel_width = 175;
            panel_height = 200;
            break;
        case 1:
            panel_width = 150;
            panel_height = 380;
            break;
    }

    draw_set_halign(fa_center);

    if (scr_hit(x, y, x + panel_width, y + panel_height)) {
        draw_set_alpha(0.25);
        draw_rectangle(x, y, x + panel_width, y + panel_height, 0);
        draw_set_alpha(1);
    }

    if (header == 3) {
        slate_panel.draw_top_piece = false;
        draw_sprite_stretched(spr_master_title, 0, x, y - 2, panel_width + 2, 4);

        sprx = x + (panel_width / 2) - 50;
        spry = y - 10;
        sprw = 141 * 0.7;
        sprh = 141 * 0.7;

        if (sprite_exists(global.chapter_icon.sprite)) {
            draw_sprite_stretched(global.chapter_icon.sprite, 0, sprx, spry, sprw, sprh);
        } else {
            LOGGER.error($"{global.chapter_icon.name} chapter icon not found in any icon directory. Chapter icon will not render.");
        }
        draw_set_font(fnt_cul_14);
        draw_text(x + (panel_width / 2), y + 89, string_hash_to_newline(title));

        draw_lines(x + (panel_width / 2), y + 112, 20, false);
    } else if (header == 2) {
        slate_panel.draw_top_piece = false;
        draw_sprite_stretched(spr_company_title, company, x + 40, y - 2, panel_width - 80, 4);
        if (title == "ARMOURY") {
            draw_sprite_ext(spr_tech_area_pad, 0, x + (panel_width / 2) - ((0.3 * 180) / 2), y - 30, 0.3, 0.3, 0, c_white, 1);
        } else if (title == "APOTHECARIUM") {
            draw_sprite_ext(spr_apoth_area_pad, 0, x + (panel_width / 2) - ((0.3 * 180) / 2), y - 30, 0.3, 0.3, 0, c_white, 1);
        } else if (title == "RECLUSIUM") {
            draw_sprite_ext(spr_chap_area_pad, 0, x + (panel_width / 2) - ((0.3 * 180) / 2), y - 30, 0.3, 0.3, 0, c_white, 1);
        } else if (title == "LIBRARIUM") {
            draw_sprite_ext(spr_lib_area_pad, 0, x + (panel_width / 2) - ((0.3 * 180) / 2), y - 30, 0.3, 0.3, 0, c_white, 1);
        } else {
            sprx = x + (wid / 2) - 16;
            spry = y - 16;
            sprw = 141 * 0.23;
            sprh = 141 * 0.23;

            if (sprite_exists(global.chapter_icon.sprite)) {
                draw_sprite_stretched(global.chapter_icon.sprite, 0, sprx, spry, sprw, sprh);
            } else {
                LOGGER.error($"{global.chapter_icon.name} chapter icon not found in any icon directory. Chapter icon will not render.");
            }
        }
        draw_set_font(fnt_cul_14);
        draw_text(x + (panel_width / 2), y + 20, string_hash_to_newline(title));
        draw_set_font(fnt_40k_12);

        draw_lines(x + (panel_width / 2), y + 43, 20, false);
    } else if (header == 1) {
        draw_sprite_stretched(spr_master_title, 0, x, y - 2, panel_width + 2, 4);
        draw_set_font(fnt_cul_14);
        draw_text(x + (panel_width / 2), y + 30, string_hash_to_newline(title));
        draw_set_font(fnt_40k_12);

        draw_lines(x + (panel_width / 2), y + 53, 18, true);
    }
    draw_set_color(c_white);
};

var x_scale = panel_width / 850;
var y_scale = panel_height / 860;

try {
    slate_panel.draw(x, y, x_scale, y_scale);
    // draw_text(x+(panel_width/2),y-60,string(manage)+") "+string(line[0])+"#"+string(line[2])+"#"+string(line[3]));

    if (point_and_click([x, y, x + panel_width, y + panel_height])) {
        obj_controller.managing = manage;
        var new_manage = manage;
        with (obj_controller) {
            switch_view_company(new_manage);
        }
    }
} catch (_exception) {
    ERROR_HANDLER.handle_exception(_exception);
    scr_toggle_manage();
}
