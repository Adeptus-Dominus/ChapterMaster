/// @function scr_secret_lair_view()
/// @category UI
/// @description Displays information on secret lairs
function scr_secret_lair_view() {
    var xx = camera_get_view_x(view_camera[0]) + 25;
    var yy = camera_get_view_y(view_camera[0]) + 165;

    add_draw_return_values();
    draw_sprite(spr_popup_large, 1, xx, yy);
    draw_set_color(c_gray);
    draw_set_font(cjk_font(fnt_40k_30b));
    draw_set_halign(fa_center);

    var planet_upgrades = obj_temp_build.target.p_upgrades[obj_controller.selecting_planet];
    var arsenal = false;
    var gene_vault = false;
    var secret_base = false;
    var title = "";
    var lair_window_description_text = "";
    /// @type {Struct.NewPlanetFeature|undefined}
    var lair_struct = undefined;

    if (planet_feature_bool(planet_upgrades, eP_FEATURES.SECRET_BASE)) {
        secret_base = true;
    }

    if (planet_feature_bool(planet_upgrades, eP_FEATURES.ARSENAL)) {
        arsenal = true;
    }

    if (planet_feature_bool(planet_upgrades, eP_FEATURES.GENE_VAULT)) {
        gene_vault = true;
    }

    var lair_exists = gene_vault || arsenal || secret_base;

    if (obj_temp_build.isnew) {
        title = localize("Secret Lair ({0} {1})", [obj_temp_build.target.name, scr_roman(obj_temp_build.planet)]);
        draw_text_transformed(xx + 312, yy + 10, title, 0.7, 0.7, 0);

        draw_set_font(cjk_font(fnt_40k_14b));
        draw_text(xx + 312, yy + 45, localize("STR_LAIR_ROOM_SELECT_A_SECRET_LAIR_STYLE"));
        draw_set_halign(fa_left);

        var base_x1 = xx + 21;
        var base_x2 = base_x1 + 579;
        var base_y1 = yy + 88;
        var base_y2 = base_y1 + 18;
        var text_x1 = base_x1 + 2;
        var text_x2 = text_x1 + 100;

        for (var r = 0; r < array_length(obj_controller.lair_styles); r++) {
            var style = obj_controller.lair_styles[r];
            var y_offset = r * 30;

            draw_set_color(c_gray);
            draw_rectangle(base_x1, base_y1 + y_offset, base_x2, base_y2 + y_offset, 0);

            if (scr_hit(base_x1, base_y1 + y_offset, base_x2, base_y2 + y_offset) == true) {
                draw_set_color(c_black);
                draw_set_alpha(0.2);
                draw_rectangle(base_x1, base_y1 + y_offset, base_x2, base_y2 + y_offset, 0);
                draw_set_alpha(1);

                if (mouse_button_clicked()) {
                    var base_options = {
                        style: style.tag,
                    };
                    obj_temp_build.isnew = false;
                    array_push(planet_upgrades, new NewPlanetFeature(eP_FEATURES.SECRET_BASE, base_options));
                }
            }

            draw_set_color(c_black);
            draw_set_font(cjk_font(fnt_40k_14b));
            draw_text_transformed(text_x1, base_y1 + 2 + y_offset, localize(style.name), 1, 0.8, 0);
            draw_set_font(cjk_font(fnt_40k_14));
            draw_text_transformed(text_x2, base_y1 + 2 + y_offset, localize(style.description), 1, 0.8, 0);
        }
    }

    //TODO add a PlanetData object to obj_temp_build so that planet nae can be generated with PlanetData.name()
    if (!lair_exists) {
        title = localize("STR_LAIR_ROOM_BUILD", [obj_temp_build.target.name, scr_roman(obj_temp_build.planet)]);
    } else {
        if (secret_base) {
            title = localize("Secret Lair ({0} {1})", [obj_temp_build.target.name, scr_roman(obj_temp_build.planet)]);
        } else if (arsenal) {
            title = localize("Secret Arsenal ({0} {1})", [obj_temp_build.target.name, scr_roman(obj_temp_build.planet)]);
        } else if (gene_vault) {
            title = localize("Secret Gene-Vault ({0} {1})", [obj_temp_build.target.name, scr_roman(obj_temp_build.planet)]);
        }
    }

    draw_text_transformed(xx + 312, yy + 10, title, 0.7, 0.7, 0);

    draw_set_halign(fa_left);

    if (secret_base) {
        var search_list = search_planet_features(planet_upgrades, eP_FEATURES.SECRET_BASE);
        if (array_length(search_list) > 0) {
            lair_struct = planet_upgrades[search_list[0]];
            if (lair_struct.built > obj_controller.turn) {
                draw_set_font(cjk_font(fnt_40k_14b));
                draw_text(xx + 21, yy + 65, localize("This feature will be constructed in {0} months.", [lair_struct.built - obj_controller.turn]));
            } else if (lair_struct.built <= obj_controller.turn) {
                var button_label = "";
                var button_desc = "";
                var cost = 0;
                var button_x1 = xx + 494;
                var button_y1 = yy + 12;
                var button_x2 = xx + 614;
                var button_y2 = yy + 32;
                var button_padding = 2;

                for (var r = 1; r <= 12; r++) {
                    var button_alpha = 1;
                    switch (r) {
                        case 1:
                            if (lair_struct.forge) {
                                button_alpha = 0.33;
                            }

                            cost = 1000;
                            button_label = localize("Forge");
                            button_desc = localize("STR_LAIR_ROOM_FORGE_DESC");
                            break;
                        case 2:
                            if (lair_struct.hippo) {
                                button_alpha = 0.33;
                            }

                            cost = 1000;
                            button_label = localize("STR_LAIR_ROOM_HIPPODROME");
                            button_desc = localize("STR_LAIR_ROOM_HIPPODROME_DESC");
                            break;
                        case 3:
                            if (lair_struct.beastarium) {
                                button_alpha = 0.33;
                            }

                            cost = 1000;
                            button_label = localize("STR_LAIR_ROOM_BEASTARIUM");
                            button_desc = localize("STR_LAIR_ROOM_BEASTARIUM_DESC");
                            break;
                        case 4:
                            if (lair_struct.torture) {
                                button_alpha = 0.33;
                            }

                            cost = 500;
                            button_label = localize("STR_LAIR_ROOM_TORTURE");
                            button_desc = localize("STR_LAIR_ROOM_TORTURE_DESC");
                            break;
                        case 5:
                            if (lair_struct.narcotics) {
                                button_alpha = 0.33;
                            }

                            cost = 500;
                            button_label = localize("STR_LAIR_ROOM_NARCOTICS");
                            button_desc = localize("STR_LAIR_ROOM_NARCOTICS_DESC");
                            break;
                        case 6:
                            if (lair_struct.relic > 0) {
                                button_alpha = 0.33;
                            }

                            cost = 500;
                            button_label = localize("STR_LAIR_ROOM_RELIC");
                            button_desc = localize("STR_LAIR_ROOM_RELIC_DESC");
                            break;
                        case 7:
                            if (lair_struct.cookery) {
                                button_alpha = 0.33;
                            }

                            cost = 250;
                            button_label = localize("STR_LAIR_ROOM_COOKERY");
                            button_desc = localize("STR_LAIR_ROOM_COOKERY_DESC");
                            break;
                        case 8:
                            if (lair_struct.vox) {
                                button_alpha = 0.33;
                            }

                            cost = 250;
                            button_label = localize("STR_LAIR_ROOM_VOX");
                            button_desc = localize("STR_LAIR_ROOM_VOX_DESC");
                            break;
                        case 9:
                            if (lair_struct.librarium) {
                                button_alpha = 0.33;
                            }

                            cost = 250;
                            button_label = localize("Librarium");
                            button_desc = localize("STR_LAIR_ROOM_LIBRARIUM_DESC");
                            break;
                        case 10:
                            if (lair_struct.throne) {
                                button_alpha = 0.33;
                            }

                            cost = 250;
                            button_label = localize("STR_LAIR_ROOM_THRONE");
                            button_desc = localize("STR_LAIR_ROOM_THRONE_DESC");
                            break;
                        case 11:
                            if (lair_struct.stasis) {
                                button_alpha = 0.33;
                            }

                            cost = 200;
                            button_label = localize("STR_LAIR_ROOM_STASIS");
                            button_desc = localize("STR_LAIR_ROOM_STASIS_DESC");
                            break;
                        case 12:
                            if (lair_struct.swimming) {
                                button_alpha = 0.33;
                            }

                            cost = 100;
                            button_label = localize("STR_LAIR_ROOM_POOL");
                            button_desc = localize("STR_LAIR_ROOM_POOL_DESC");
                            break;
                    }

                    button_y1 = yy + 12 + ((r - 1) * 22);
                    button_y2 = yy + 32 + ((r - 1) * 22);

                    draw_set_font(cjk_font(fnt_40k_14));
                    draw_set_alpha(button_alpha);
                    draw_set_color(c_gray);
                    draw_rectangle(button_x1, button_y1, button_x2, button_y2, 0);
                    draw_set_color(c_black);
                    draw_text_transformed(button_x1 + button_padding, button_y1 + button_padding, button_label, 1, 0.9, 0);
                    draw_set_alpha(1);

                    if (scr_hit(button_x1, button_y1, button_x2, button_y2)) {
                        if (button_alpha <= 0.33) {
                            draw_set_alpha(0.1);
                        }

                        if (button_alpha > 0.33) {
                            draw_set_alpha(0.2);
                        }

                        draw_set_color(c_black);
                        draw_rectangle(button_x1, button_y1, button_x2, button_y2, 0);
                        draw_set_alpha(1);
                        if (mouse_button_clicked() && (obj_controller.requisition >= cost) && (button_alpha != 0.33)) {
                            obj_controller.requisition -= cost;
                            switch (r) {
                                case 1:
                                    lair_struct.forge = true;
                                    lair_struct.forge_data = new PlayerForge();
                                    break;
                                case 2:
                                    lair_struct.hippo = true;
                                    break;
                                case 3:
                                    lair_struct.beastarium = true;
                                    break;
                                case 4:
                                    lair_struct.torture = true;
                                    break;
                                case 5:
                                    lair_struct.narcotics = true;
                                    break;
                                case 6:
                                    lair_struct.relic += 1;
                                    break;
                                case 7:
                                    lair_struct.cookery = true;
                                    break;
                                case 8:
                                    lair_struct.vox = true;
                                    break;
                                case 9:
                                    lair_struct.librarium = true;
                                    break;
                                case 10:
                                    lair_struct.throne = true;
                                    break;
                                case 11:
                                    lair_struct.stasis = true;
                                    break;
                                case 12:
                                    lair_struct.swimming = true;
                                    break;
                            }
                        }
                    }
                }

                lair_window_description_text = localize("STR_LAIR_DESC_DEEP_BENEATH_THE", [obj_temp_build.target.name, scr_roman(obj_controller.selecting_planet)]);
                if (lair_struct.inquis_hidden == 1) {
                    lair_window_description_text += localize("secret lair.  ");
                } else {
                    lair_window_description_text += localize("previously discovered lair.  ");
                }

                lair_window_description_text += localize("STR_LAIR_DESC_MASSIVE");
                switch (lair_struct.style) {
                    case "BRB":
                        lair_window_description_text += localize("STR_LAIR_DESC_THE_WALLS_DECORATED");
                        break;
                    case "DIS":
                        lair_window_description_text += localize("STR_LAIR_DESC_THE_MAIN_ATTRACTION");
                        break;
                    case "FEU":
                        lair_window_description_text += localize("STR_LAIR_DESC_THE_WALLS_MADE");
                        break;
                    case "GTH":
                        lair_window_description_text += localize("STR_LAIR_DESC_THE_WALLS_MADE_2");
                        break;
                    case "MCH":
                        lair_window_description_text += localize("STR_LAIR_DESC_GLANCE_APPEARS_DECORATED");
                        break;
                    case "PRS":
                        lair_window_description_text += localize("STR_LAIR_DESC_THE_WALLS_MADE_3");
                        break;
                    case "RAV":
                        lair_window_description_text += localize("STR_LAIR_DESC_BUT_NEARLY_PITCH");
                        break;
                    case "STL":
                        lair_window_description_text += localize("STR_LAIR_DESC_ALL_THE_SURFACES");
                        break;
                    case "UTL":
                        lair_window_description_text += localize("STR_LAIR_DESC_AND_ALMOST_CIVILIAN");
                        break;
                }

                if (lair_struct.throne == 1) {
                    lair_window_description_text += localize("STR_LAIR_DESC_THE_CENTER_CHAMBER");
                    if (obj_controller.temp[104]) {
                        lair_window_description_text += localize("STR_LAIR_DESC_MASSIVE_THRONE_WHICH");
                    } else {
                        lair_window_description_text += localize("STR_LAIR_DESC_MASSIVE_THRONE_THOUGH");
                    }
                }

                if ((lair_struct.vox > 0) && (obj_temp_build.target.p_player[obj_controller.selecting_planet] > 0)) {
                    lair_window_description_text += localize("STR_LAIR_DESC_HERETICAL_MUSIC_BLASTS");
                }

                if (lair_struct.narcotics > 0) {
                    lair_window_description_text += localize("STR_LAIR_DESC_MANY_THE_TABLES");
                }

                if (lair_struct.cookery == 1) {
                    if (obj_temp_build.target.p_player[obj_controller.selecting_planet] > 0) {
                        lair_window_description_text += localize("STR_LAIR_DESC_IMPERIAL_CHEFS_ARE");
                    }

                    if (obj_temp_build.target.p_player[obj_controller.selecting_planet] == 0) {
                        lair_window_description_text += localize("STR_LAIR_DESC_THE_IMPERIAL_CHEFS");
                    }
                }

                switch (lair_struct.stock) {
                    case 1:
                        lair_window_description_text += localize("STR_LAIR_DESC_ONE_THE_CHAMBERS");
                        break;
                    case 2:
                        lair_window_description_text += localize("STR_LAIR_DESC_ONE_THE_CHAMBERS_2");
                        break;
                    case 3:
                        lair_window_description_text += localize("STR_LAIR_DESC_WAR_TROPHIES_TAKEN");
                        break;
                    case 4:
                        lair_window_description_text += localize("STR_LAIR_DESC_YOUR_RELIC_ROOM");
                        break;
                    case 5:
                        lair_window_description_text += localize("STR_LAIR_DESC_YOUR_RELIC_ROOM_2");
                        break;
                    case 6:
                        lair_window_description_text += localize("STR_LAIR_DESC_YOUR_RELIC_ROOM_3");
                        break;
                    case 7:
                        lair_window_description_text += localize("STR_LAIR_DESC_ONE_THE_CHAMBERS_3");
                        break;
                    case 8:
                        lair_window_description_text += localize("STR_LAIR_DESC_YOUR_RELIC_ROOM_4");
                        break;
                    case 9:
                        lair_window_description_text += localize("STR_LAIR_DESC_MANY_THE_XENOS");
                        break;
                    case 10:
                        lair_window_description_text += localize("STR_LAIR_DESC_ADDITION_THE_MANY");
                        break;
                    case 11:
                        lair_window_description_text += localize("STR_LAIR_DESC_ADDITION_THE_MANY_2");
                        break;
                    case 12:
                        lair_window_description_text += localize("STR_LAIR_DESC_ADDITION_THE_MANY_3");
                        break;
                    case 13:
                        lair_window_description_text += localize("STR_LAIR_DESC_ADDITION_THE_MANY_4");
                        break;
                    case 14:
                        lair_window_description_text += localize("STR_LAIR_DESC_ADDITION_THE_MANY_5");
                        break;
                    case 15:
                        lair_window_description_text += localize("STR_LAIR_DESC_WAR_TROPHIES_CHESTS");
                        break;
                    case 16:
                        lair_window_description_text += localize("STR_LAIR_DESC_WAR_TROPHIES_CHESTS_2");
                        break;
                    case 17:
                        lair_window_description_text += localize("STR_LAIR_DESC_THE_ABUNDANT_GOLD");
                        break;
                    case 18:
                        lair_window_description_text += localize("STR_LAIR_DESC_THE_ABUNDANT_GOLD_2");
                        break;
                    case 19:
                        lair_window_description_text += localize("STR_LAIR_DESC_SIZEABLE_PORTION_YOUR");
                        break;
                    case 20:
                        lair_window_description_text += localize("STR_LAIR_DESC_MUCH_YOUR_LAIR");
                        break;
                    case 21:
                    case 22:
                    case 23:
                    case 24:
                        lair_window_description_text += localize("STR_LAIR_DESC_YOUR_ABUNDANT_WEALTH");
                        break;
                    case 25:
                    case 26:
                    case 27:
                    case 28:
                    case 29:
                        lair_window_description_text += localize("STR_LAIR_DESC_GOLD_AND_GEMS");
                        break;
                    default:
                        if (lair_struct.stock >= 30) {
                            lair_window_description_text += localize("STR_LAIR_DESC_GOLD_AND_GEMS_2");
                        }

                        break;
                }

                if (lair_struct.forge > 0) {
                    lair_window_description_text += localize("STR_LAIR_DESC_YOUR_LAIR_HAS");
                }

                if (lair_struct.hippo > 0) {
                    lair_window_description_text += localize("STR_LAIR_DESC_YOUR_LAIR_HAS_2");
                }

                if (lair_struct.torture > 0) {
                    lair_window_description_text += localize("STR_LAIR_DESC_ONE_THE_ROOMS");
                }

                if (lair_struct.librarium > 0) {
                    lair_window_description_text += localize("STR_LAIR_DESC_LARGE_LIBRARIUM_MAKES");
                }

                if (lair_struct.beastarium > 0) {
                    lair_window_description_text += localize("STR_LAIR_DESC_YOUR_LAIR_HAS_3");
                }

                if (lair_struct.swimming > 0) {
                    lair_window_description_text += localize("STR_LAIR_DESC_LARGE_SWIMMING_POOL");
                }

                if (lair_struct.stasis > 0) {
                    lair_window_description_text += localize("STR_LAIR_DESC_ONE_THE_CHAMBERS_4");
                }

                button_x1 = xx + 12;
                button_y1 = yy + 45;

                draw_set_color(c_gray);
                draw_set_font(cjk_font(fnt_40k_14));
                draw_set_halign(fa_left);
                draw_rectangle(button_x1, yy + 45, xx + 486, yy + 378, 1);

                var hh = 1;
                var min_scale = 0.6;
                while ((string_height_ext(lair_window_description_text, -1, 470) * hh) > 330 && hh > min_scale) {
                    hh -= 0.1;
                }

                draw_text_ext_transformed(button_x1 + button_padding, button_y1 + button_padding, lair_window_description_text, -1, 470 * (2 + (hh * -1)), hh, hh, 0);

                // I know for a fact there is a better way to do this, and im sure this file could use another refactor, but oh my god im sick of it and it works and looks fine im done
                button_x1 = xx + 494;
                button_x2 = xx + 614;
                var tooltip_header = "";
                var tooltip_desc = "";
                var tooltip_rp_cost = 0;
                // Forge
                if (scr_hit(button_x1, yy + 12, button_x2, yy + 32)) {
                    // + ((1 - 1) * 22)
                    tooltip_rp_cost = 1000;
                    tooltip_header = localize("Forge");
                    tooltip_desc = localize("STR_LAIR_ROOM_FORGE_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Hippodrome
                if (scr_hit(button_x1, yy + 34, button_x2, yy + 54)) {
                    // + ((2 - 1) * 22)
                    tooltip_rp_cost = 1000;
                    tooltip_header = localize("STR_LAIR_ROOM_HIPPODROME");
                    tooltip_desc = localize("STR_LAIR_ROOM_HIPPODROME_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Beastarium
                if (scr_hit(button_x1, yy + 56, button_x2, yy + 76)) {
                    // + ((3 - 1) * 22)
                    tooltip_rp_cost = 1000;
                    tooltip_header = localize("STR_LAIR_ROOM_BEASTARIUM");
                    tooltip_desc = localize("STR_LAIR_ROOM_BEASTARIUM_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Torture Chamber
                if (scr_hit(button_x1, yy + 78, button_x2, yy + 98)) {
                    // + ((4 - 1) * 22)
                    tooltip_rp_cost = 500;
                    tooltip_header = localize("STR_LAIR_ROOM_TORTURE");
                    tooltip_desc = localize("STR_LAIR_ROOM_TORTURE_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Narcotics
                if (scr_hit(button_x1, yy + 100, button_x2, yy + 120)) {
                    // + ((5 - 1) * 22)
                    tooltip_rp_cost = 500;
                    tooltip_header = localize("STR_LAIR_ROOM_NARCOTICS");
                    tooltip_desc = localize("STR_LAIR_ROOM_NARCOTICS_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Relic Room
                if (scr_hit(button_x1, yy + 122, button_x2, yy + 142)) {
                    // + ((6 - 1) * 22)
                    tooltip_rp_cost = 500;
                    tooltip_header = localize("STR_LAIR_ROOM_RELIC");
                    tooltip_desc = localize("STR_LAIR_ROOM_RELIC_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Cookery
                if (scr_hit(button_x1, yy + 144, button_x2, yy + 164)) {
                    // + ((7 - 1) * 22)
                    tooltip_rp_cost = 250;
                    tooltip_header = localize("STR_LAIR_ROOM_COOKERY");
                    tooltip_desc = localize("STR_LAIR_ROOM_COOKERY_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Vox Casters
                if (scr_hit(button_x1, yy + 166, button_x2, yy + 186)) {
                    // + ((8 - 1) * 22)
                    tooltip_rp_cost = 250;
                    tooltip_header = localize("STR_LAIR_ROOM_VOX");
                    tooltip_desc = localize("STR_LAIR_ROOM_VOX_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Librarium
                if (scr_hit(button_x1, yy + 188, button_x2, yy + 206)) {
                    // + ((9 - 1) * 22)
                    tooltip_rp_cost = 250;
                    tooltip_header = localize("Librarium");
                    tooltip_desc = localize("STR_LAIR_ROOM_LIBRARIUM_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Throne
                if (scr_hit(button_x1, yy + 210, button_x2, yy + 228)) {
                    // + ((10 - 1) * 22)
                    tooltip_rp_cost = 250;
                    tooltip_header = localize("STR_LAIR_ROOM_THRONE");
                    tooltip_desc = localize("STR_LAIR_ROOM_THRONE_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Stasis Pods
                if (scr_hit(button_x1, yy + 232, button_x2, yy + 250)) {
                    // + ((11 - 1) * 22)
                    tooltip_rp_cost = 200;
                    tooltip_header = localize("STR_LAIR_ROOM_STASIS");
                    tooltip_desc = localize("STR_LAIR_ROOM_STASIS_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }

                // Swimming Pool
                if (scr_hit(button_x1, yy + 254, button_x2, yy + 272)) {
                    // + ((12 - 1) * 22)
                    tooltip_rp_cost = 100;
                    tooltip_header = localize("STR_LAIR_ROOM_POOL");
                    tooltip_desc = localize("STR_LAIR_ROOM_POOL_DESC");
                    tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("STR_LAIR_BUILDING_COST"), fnt_40k_12, tooltip_rp_cost);
                }
            }
        }
    }

    draw_set_font(cjk_font(fnt_40k_14b));
    lair_window_description_text = "";
    if (planet_feature_bool(planet_upgrades, eP_FEATURES.ARSENAL) == 1) {
        lair_struct = planet_upgrades[search_planet_features(planet_upgrades, eP_FEATURES.ARSENAL)[0]];
        if (lair_struct.inquis_hidden == 1) {
            lair_window_description_text = localize("STR_LAIR_BUILDING_MODERATE_SIZED_SECRET");
        } else {
            lair_window_description_text = localize("STR_LAIR_BUILDING_MODERATE_SIZED_ARSENAL");
        }
    }

    if (planet_feature_bool(planet_upgrades, eP_FEATURES.GENE_VAULT) == 1) {
        lair_struct = planet_upgrades[search_planet_features(planet_upgrades, eP_FEATURES.GENE_VAULT)[0]];
        if (lair_struct.inquis_hidden == 1) {
            lair_window_description_text = localize("STR_LAIR_BUILDING_LARGE_FACILITY_WITH");
        } else {
            lair_window_description_text = localize("STR_LAIR_BUILDING_LARGE_FACILITY_WITH_2");
        }
    }

    if (arsenal || gene_vault) {
        draw_text_ext(xx + 21, yy + 65, lair_window_description_text, -1, 595);
    }

    if (!lair_exists && !obj_temp_build.isnew) {
        draw_set_font(cjk_font(fnt_40k_14b));
        if (!secret_base) {
            draw_text(xx + 21, yy + 45, localize("Lair"));
        }

        if (!arsenal) {
            draw_text(xx + 21, yy + 110, localize("Arsenal"));
        }

        if (!gene_vault) {
            draw_text(xx + 21, yy + 175, localize("Gene-Vault"));
        }

        draw_set_font(cjk_font(fnt_40k_14));

        draw_sprite(spr_requisition, 0, xx + 160, yy + 47);
        if (obj_controller.requisition < 1000) {
            draw_set_color(c_red);
        } else {
            draw_set_color(COL_REQUISITION);
        }

        draw_text(xx + 180, yy + 47, "1000");
        draw_set_color(c_gray);
        draw_text_ext(xx + 21, yy + 65, localize("STR_LAIR_BUILDING_CUSTOMIZABLE_HIDEOUT_THAT"), -6, 600);
        draw_rectangle(xx + 300, yy + 45, xx + 400, yy + 65, 0);
        draw_set_halign(fa_center);
        draw_set_color(c_black);
        draw_text(xx + 350, yy + 47, localize("Build"));
        draw_text(xx + 351, yy + 48, localize("Build"));
        if (scr_hit(xx + 300, yy + 45, xx + 400, yy + 65)) {
            draw_set_alpha(0.2);
            draw_rectangle(xx + 300, yy + 45, xx + 400, yy + 65, 0);
            draw_set_alpha(1);

            if (mouse_button_clicked() && (obj_controller.requisition >= 1000)) {
                obj_temp_build.isnew = true;
                obj_controller.requisition -= 1000;
            }
        }

        draw_set_halign(fa_left);

        draw_sprite(spr_requisition, 0, xx + 160, yy + 112);
        if (obj_controller.requisition < 1500) {
            draw_set_color(c_red);
        } else {
            draw_set_color(COL_REQUISITION);
        }

        draw_text(xx + 180, yy + 112, "1500");
        draw_set_color(c_gray);
        draw_text_ext(xx + 21, yy + 130, localize("STR_LAIR_BUILDING_HIDDEN_ARMOURY_THAT"), -1, 600);
        draw_rectangle(xx + 300, yy + 110, xx + 400, yy + 130, 0);
        draw_set_halign(fa_center);
        draw_set_color(c_black);
        draw_text(xx + 350, yy + 112, localize("Build"));
        draw_text(xx + 351, yy + 113, localize("Build"));
        if (scr_hit(xx + 300, yy + 110, xx + 400, yy + 130)) {
            draw_set_alpha(0.2);
            draw_rectangle(xx + 300, yy + 110, xx + 400, yy + 130, 0);
            draw_set_alpha(1);

            if (mouse_button_clicked() && (obj_controller.requisition >= 1500)) {
                array_push(planet_upgrades, new NewPlanetFeature(eP_FEATURES.ARSENAL));
                obj_controller.requisition -= 1500;
            }
        }

        draw_set_halign(fa_left);

        draw_sprite(spr_requisition, 0, xx + 160, yy + 177);
        if (obj_controller.requisition < 4000) {
            draw_set_color(c_red);
        } else {
            draw_set_color(COL_REQUISITION);
        }

        draw_text(xx + 180, yy + 177, "4000");
        draw_set_color(c_gray);
        draw_text_ext(xx + 21, yy + 195, localize("STR_LAIR_BUILDING_HIDDEN_GENE_VAULT"), -1, 600);
        draw_rectangle(xx + 300, yy + 175, xx + 400, yy + 195, 0);
        draw_set_halign(fa_center);
        draw_set_color(c_black);
        draw_text(xx + 350, yy + 177, localize("Build"));
        draw_text(xx + 351, yy + 178, localize("Build"));
        if (scr_hit(xx + 300, yy + 175, xx + 400, yy + 195)) {
            draw_set_alpha(0.2);
            draw_rectangle(xx + 300, yy + 175, xx + 400, yy + 195, 0);
            draw_set_alpha(1);

            if (mouse_button_clicked() && (obj_controller.requisition >= 4000)) {
                array_push(planet_upgrades, new NewPlanetFeature(eP_FEATURES.GENE_VAULT));
                obj_controller.requisition -= 4000;
            }
        }

        draw_set_halign(fa_left);
    }

    draw_set_font(cjk_font(fnt_40k_30b));
    draw_set_color(c_gray);
    draw_rectangle(xx + 252, yy + 388, xx + 372, yy + 420, 0);
    draw_set_halign(fa_center);
    draw_set_color(c_black);
    draw_text(xx + 312, yy + 388, localize("Back"));
    if (scr_hit(xx + 252, yy + 388, xx + 372, yy + 420)) {
        draw_set_alpha(0.2);
        draw_rectangle(xx + 252, yy + 388, xx + 372, yy + 420, 0);
        draw_set_alpha(1);

        if (mouse_button_clicked()) {
            obj_controller.menu = eMENU.DEFAULT;
        }
    }

    pop_draw_return_values();
}
