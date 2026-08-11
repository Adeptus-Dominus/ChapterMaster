/// @self Asset.GMObject.obj_creation
function scr_livery_setup() {
    add_draw_return_values();
    draw_set_font(cjk_font(fnt_40k_30b));
    draw_set_halign(fa_center);
    draw_set_alpha(1);
    draw_set_color(CM_GREEN_COLOR);

    obj_cursor.image_index = 0;

    draw_text_color_simple(800, 80, chapter_name, CM_GREEN_COLOR);

    var preview_box = {
        x1: 444,
        y1: 252,
        w: 167,
        h: 232,
    };
    preview_box.x2 = preview_box.x1 + preview_box.w;
    preview_box.y2 = preview_box.y1 + preview_box.h;
    colour_selection_options.update({x1: preview_box.x1 + 20, y1: 200});
    colour_selection_options.draw();

    livery_picker.draw_base();

    var company_radio = buttons.company_liveries_choice;
    company_radio.draw_title = false;

    draw_set_halign(fa_left);
    draw_text_transformed(580, 118, "Battle Cry:", 0.6, 0.6, 0);
    draw_set_font(cjk_font(fnt_40k_14b));
    battle_cry = text_bars.battle_cry.draw(battle_cry);

    draw_rectangle(445, 200, 1125, 202, 0);

    draw_set_font(cjk_font(fnt_40k_30b));

    if (colour_selection_options.current_selection == 0) {
        var _col_areas = livery_picker.colours_radio;
        _col_areas.current_selection = -1;
        _col_areas.update({x1: colour_selection_options.x1, y1: colour_selection_options.y2, max_width: 200});
        _col_areas.draw();
        if (_col_areas.changed) {
            livery_picker.new_colour_pick(_col_areas.selection_val("area_id"));
        }
    } else if (colour_selection_options.current_selection == 1) {
        var _updater = draw_unit_buttons([500, preview_box.y1 - 10], "Update Sprite");
        if (scr_hit(_updater)) {
            tooltip_draw("Click to Update Marine colour picker with Colour settings, warning this will overide Existing colour selections");
        }

        if (point_and_click(_updater)) {
            var struct_cols = {
                main_color: main_color,
                secondary_color: secondary_color,
                main_trim: main_trim,
                right_pauldron: right_pauldron,
                left_pauldron: left_pauldron,
                lens_color: lens_color,
                weapon_color: weapon_color,
            };
            livery_picker.set_default_armour(struct_cols, col_special);
        }

        for (var i = 0; i < array_length(bulk_buttons); i++) {
            if (bulk_buttons[i].draw(custom == eCHAPTER_TYPE.CUSTOM)) {
                instance_destroy(obj_creation_popup);
                var _data = {
                    target_role : i + 1,
                    type : ePOPUP_TYPE.LIVERYPICK,
                    colour_area : "",
                    title : bulk_buttons[i].label
                }
                instance_create_depth(0, 0, -55, obj_creation_popup, _data);
            }
        }

        bulk_armour_pattern.draw();
        col_special = bulk_armour_pattern.current_selection;
    } else {
        for (var i = 0; i < array_length(complex_livery_buttons); i++) {
            var _button = complex_livery_buttons[i];

            if (_button.draw()) {
                instance_destroy(obj_creation_popup);
                var _data = {
                    target_role : _button.role_id,
                    type : ePOPUP_TYPE.LIVERYPICK,
                    colour_area : _button.area,
                }
                instance_create_depth(0, 0, -55,obj_creation_popup, _data);
            }
        }
        advanced_helmet_livery.draw();
        complex_depth_selection = advanced_helmet_livery.current_selection;
    }

    draw_rectangle(844, 204, 846, 740, 0);
    draw_set_font(cjk_font(fnt_40k_14b));
    draw_set_halign(fa_left);
    var spacing = 30;
    var xxx = 862;
    var yyy = 255 - spacing;

    livery_selection_options.update({x1: 862, y1: 200, max_width: 800});

    var _prev_val = variable_clone(livery_selection_options.current_selection);

    if (colour_selection_options.current_selection != 2) {
        livery_selection_options.draw();
    }

    var _update_sprite = false;
    if (livery_selection_options.changed) {
        var _new_val = livery_selection_options.current_selection;
        _update_sprite = true;
        livery_picker.swap_role_set(_prev_val, _new_val);
    }

    var _livery_type = livery_selection_options.current_selection;

    if (colour_selection_options.current_selection != 2 && !_update_sprite) {
        if (_livery_type == 1) {
            roles_radio.update({x1: 882, y1: livery_selection_options.y2 + 20,allow_changes:custom == eCHAPTER_TYPE.CUSTOM});
            roles_radio.draw();
            if (roles_radio.changed) {
                livery_picker.swap_role_set(1, 1);
            }
        } else if (_livery_type == 2) {
            company_radio.update({max_width: 350, x1: 862, y1: livery_selection_options.y2 + 20, allow_changes: true});
            company_radio.draw();
            if (company_radio.changed) {
                livery_picker.swap_role_set(2, 2);
            }
        }
    } else {
        complex_livery_radio.draw();
        if (complex_livery_radio.changed) {
            set_complex_livery_buttons();
        }
    }

    draw_set_font(cjk_font(fnt_40k_30b));
    draw_set_halign(fa_center);
    if (_livery_type != 2) {
        var liv_string = $"Full Livery \n{livery_picker.role_set == 0 ? "default" : player_role_data[livery_picker.role_set].role}";
        draw_text(160, 100, liv_string);
    } else {
        draw_text(160, 100, "Company Livery");
    }

    draw_set_font(cjk_font(fnt_40k_14b));
    draw_set_halign(fa_left);
    right_data_slate.inside_method = function() {
        var _cultures = buttons.culture_styles;
        _cultures.x1 = right_data_slate.XX + 30;
        _cultures.y1 = right_data_slate.YY + 80;
        _cultures.max_width = right_data_slate.width - 120;
        _cultures.draw();
    };

    right_data_slate.draw(1210, 5, 0.45, 1);
    pop_draw_return_values();
}

