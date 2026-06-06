/// @function scr_ui_popup()
/// @category UI
/// @description Draws a (planetary(?) popup window
function scr_ui_popup() {
    // 48,48      over like 256, down to 480-128
    var xx = camera_get_view_x(view_camera[0]) + 25;
    var yy = camera_get_view_y(view_camera[0]) + 165;

    if (obj_controller.menu == 60) {

        add_draw_return_values();
        draw_sprite(spr_popup_large, 1, xx, yy);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);

        var planet_upgrades = obj_temp_build.target.p_upgrades[obj_controller.selecting_planet];
        var arsenal = 0;
        var gene_vault = 0;
        var secret_base = 0;
        var title = "";
        var description_text = "";

        if (planet_feature_bool(planet_upgrades, eP_FEATURES.SECRET_BASE) == 1) {
            secret_base = 1;
        }
        if (planet_feature_bool(planet_upgrades, eP_FEATURES.ARSENAL) == 1) {
            arsenal = 1;
        }
        if (planet_feature_bool(planet_upgrades, eP_FEATURES.GENE_VAULT) == 1) {
            gene_vault = 1;
        }

        var un_upgraded = gene_vault + arsenal + secret_base;

        if (obj_temp_build.isnew == 1) {
            title = "Secret Lair (" + string(obj_temp_build.target.name) + " " + scr_roman(obj_temp_build.planet) + ")";
            draw_text_transformed(xx + 312, yy + 10, string_hash_to_newline(title), 0.7, 0.7, 0);

            draw_set_font(fnt_40k_14b);
            draw_text(xx + 312, yy + 45, "Select a Secret Lair style.");
            draw_set_halign(fa_left);

            var styles = [
                {name: "Barbarian", description: "Heavy on leather, hides, and trophy body parts.", tag: "BRB"},
                {name: "Disco", description: "Rainbow colored dance floor and steel rafters.", tag: "DIS"},
                {name: "Feudal", description: "Lots of stone, metal filigree, and statues.", tag: "FEU"},
                {name: "Gothic", description: "Heavy on leather, hides, and trophy body parts.", tag: "GTH"},
                {name: "Mechanicus", description: "Grates, tubes, gears, and augmented reality.", tag: "MCH"},
                {name: "Prospero", description: "Marble or sandstone surfaces and gold filigree.", tag: "PRS"},
                {name: "Rave Club", description: "Large, open area with neon or strobe lights.", tag: "RAV"},
                {name: "Steel", description: "Stainless steel surfaces and water fountains.", tag: "STL"},
                {name: "Utilitarian", description: "Plaster or concrete surfaces with carpeting.", tag: "UTL"}
            ];

            var base_x1 = xx + 21;
            var base_x2 = base_x1 + 579;
            var base_y1 = yy + 88;
            var base_y2 = base_y1 + 18;
            var text_x1 = base_x1 + 2;
            var text_x2 = text_x1 + 100;

            for (var r = 0; r < array_length(styles); r++) {
                var style = styles[r];
                var y_offset = r * 30;

                draw_set_color(c_gray);
                draw_rectangle(base_x1, base_y1 + y_offset, base_x2, base_y2 + y_offset, 0);

                if (scr_hit(base_x1, base_y1 + y_offset, base_x2, base_y2 + y_offset) == true) {
                    draw_set_color(c_black);
                    draw_set_alpha(0.2);
                    draw_rectangle(base_x1, base_y1 + y_offset, base_x2, base_y2 + y_offset, 0);
                    draw_set_alpha(1);

                    if (mouse_button_clicked()) {
                        var base_options = {style: style.tag};
                        obj_temp_build.isnew = 0;
                        array_push(planet_upgrades, new NewPlanetFeature(eP_FEATURES.SECRET_BASE, base_options));
                    }
                }

                draw_set_color(c_black);
                draw_set_font(fnt_40k_14b);
                draw_text_transformed(text_x1, base_y1 + 2 + y_offset, string_hash_to_newline(style.name), 1, 0.8, 0);
                draw_set_font(fnt_40k_14);
                draw_text_transformed(text_x2, base_y1 + 2 + y_offset, string_hash_to_newline(style.description), 1, 0.8, 0);
            }
        }

        if (un_upgraded == 0) {
            title = "Build (" + string(obj_temp_build.target.name) + " " + scr_roman(obj_temp_build.planet) + ")";
        } else if (un_upgraded != 0) {
            if (secret_base != 0) {
                title = "Secret Lair (" + string(obj_temp_build.target.name) + " " + scr_roman(obj_temp_build.planet) + ")";
            }
            if (arsenal != 0) {
                title = "Secret Arsenal (" + string(obj_temp_build.target.name) + " " + scr_roman(obj_temp_build.planet) + ")";
            }
            if (gene_vault != 0) {
                title = "Secret Gene-Vault (" + string(obj_temp_build.target.name) + " " + scr_roman(obj_temp_build.planet) + ")";
            }
        }

        draw_text_transformed(xx + 312, yy + 10, string_hash_to_newline(title), 0.7, 0.7, 0);

        draw_set_halign(fa_left);

        if (secret_base > 0) {
            var search_list = search_planet_features(planet_upgrades, eP_FEATURES.SECRET_BASE);
            if (array_length(search_list) > 0) {
                description_text = "";
                var secret = true;
                secret_base = planet_upgrades[search_list[0]];
                if (secret_base.built > obj_controller.turn) {
                    draw_set_font(fnt_40k_14b);
                    draw_text(xx + 21, yy + 65, string_hash_to_newline($"This feature will be constructed in {secret_base.built - obj_controller.turn} months."));
                } else if (secret_base.built <= obj_controller.turn) {
                    if (secret_base.inquis_hidden != 1) {
                        secret = false;
                    }

                    var tooltip_title = "";
                    var tooltip_desc = "";
                    var cost = 0;
                    for (var r = 1; r < 13; r++) {
                        var button_alpha = 1;
                        switch (r) {
                            case 1:
                                if (secret_base.forge > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 1000;
                                tooltip_title = "Forge";
                                tooltip_desc = "A modest, less elaborate forge able to employ a handful of Astartes or Techpriest.";
                                break;
                            case 2:
                                if (secret_base.hippo > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 1000;
                                tooltip_title = "Hippodrome";
                                tooltip_desc = "A moderate sized garage fit to hold, service, and display vehicles.";
                                break;
                            case 3:
                                if (secret_base.beastarium > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 1000;
                                tooltip_title = "Beastarium";
                                tooltip_desc = "An enclosure with simulated greenery and foilage meant to hold beasts.";
                                break;
                            case 4:
                                if (secret_base.torture > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 500;
                                tooltip_title = "Torture Chamber";
                                tooltip_desc = "Only the best for the best.  A room full of torture tools and devices.";
                                break;
                            case 5:
                                if (secret_base.narcotics > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 500;
                                tooltip_title = "Narcotics";
                                tooltip_desc = "Several boxes worth of Obscura, Black Lethe, Kyxa... line it up.";
                                break;
                            case 6:
                                if (secret_base.relic > 0) {
                                    button_alpha = 1;
                                }
                                cost = 500;
                                tooltip_title = "Relic Room";
                                tooltip_desc = "A room meant for displaying trophies.  May be purchased successive times.";
                                break;
                            case 7:
                                if (secret_base.cookery > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 250;
                                tooltip_title = "Cookery";
                                tooltip_desc = "A larger, well-stocked cookery, complete with a number of Imperial Chef servants.";
                                break;
                            case 8:
                                if (secret_base.vox > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 250;
                                tooltip_title = "Vox Casters";
                                tooltip_desc = "All the bass one could ever imaginably need.";
                                break;
                            case 9:
                                if (secret_base.librarium > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 250;
                                tooltip_title = "Librarium";
                                tooltip_desc = "A study fit to hold a staggering amount of tomes and scrolls.";
                                break;
                            case 10:
                                if (secret_base.throne > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 250;
                                tooltip_title = "Throne";
                                tooltip_desc = "A massive, ego boosting throne.";
                                break;
                            case 11:
                                if (secret_base.stasis > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 200;
                                tooltip_title = "Stasis Pods";
                                tooltip_desc = "Though they start empty, you may capture and display your foes in these.";
                                break;
                            case 12:
                                if (secret_base.swimming > 0) {
                                    button_alpha = 0.33;
                                }
                                cost = 100;
                                tooltip_title = "Swimming Pool";
                                tooltip_desc = "A large body of water meant for excersize or relaxation.";
                                break;
                        }

                        draw_set_font(fnt_40k_14);
                        draw_set_alpha(button_alpha);
                        draw_set_color(c_gray);
                        draw_rectangle(xx + 494, yy + 12 + ((r - 1) * 22), xx + 614, yy + 32 + ((r - 1) * 22), 0);
                        draw_set_color(c_black);
                        draw_text_transformed(xx + 496, yy + 14 + ((r - 1) * 22), string_hash_to_newline(string(tooltip_title)), 1, 0.9, 0);
                        draw_set_alpha(1);

                        if (scr_hit(xx + 494, yy + 12 + ((r - 1) * 22), xx + 614, yy + 32 + ((r - 1) * 22)) == true) {
                            if (button_alpha <= 0.33) {
                                draw_set_alpha(0.1);
                            }
                            if (button_alpha > 0.33) {
                                draw_set_alpha(0.2);
                            }
                            draw_set_color(c_black);
                            draw_rectangle(xx + 494, yy + 12 + ((r - 1) * 22), xx + 614, yy + 32 + ((r - 1) * 22), 0);
                            draw_set_alpha(1);
                            if (mouse_button_clicked() && (obj_controller.requisition >= cost) && (button_alpha != 0.33)) {
                                obj_controller.requisition -= cost;
                                switch (r) {
                                    case 1:
                                        secret_base.forge = 1;
                                        secret_base.forge_data = new PlayerForge();
                                        break;
                                    case 2:
                                        secret_base.hippo = 1;
                                        break;
                                    case 3:
                                        secret_base.beastarium = 1;
                                        break;
                                    case 4:
                                        secret_base.torture = 1;
                                        break;
                                    case 5:
                                        secret_base.narcotics = 1;
                                        break;
                                    case 6:
                                        secret_base.relic = 1;
                                        break;
                                    case 7:
                                        secret_base.cookery = 1;
                                        break;
                                    case 8:
                                        secret_base.vox = 1;
                                        break;
                                    case 9:
                                        secret_base.librarium = 1;
                                        break;
                                    case 10:
                                        secret_base.throne = 1;
                                        break;
                                    case 11:
                                        secret_base.stasis = 1;
                                        break;
                                    case 12:
                                        secret_base.swimming = 1;
                                        break;
                                }
                            }
                        }
                    }

                    description_text = "Deep beneath the surface of " + string(obj_temp_build.target.name) + " " + scr_roman(obj_controller.selecting_planet) + " lays your ";
                    if (secret) {
                        description_text += "secret lair.  ";
                    } else if (!secret) {
                        description_text += "previously discovered lair.  ";
                    }

                    description_text += "It is massive";
                    switch (secret_base.style) {
                        case "BRB":
                            description_text += ", the walls decorated with animal hides and leather.  Among the copius body-trophies and bones are torches that hiss and spit.  ";
                            break;
                        case "DIS":
                            description_text += "- the main attraction is the rainbow-colored, lit up grid flooring which quickly change color.  Far overhead are metal rafters.  ";
                            break;
                        case "FEU":
                            description_text += ", the walls made up of sturdy blocks of stones.  It is heavily decorated with wooden furniture, banners, and medieval weaponry.  ";
                            break;
                        case "GTH":
                            description_text += ", the walls made up of lightly-dusty stone.  Mosaics and statues are abundant throughout, giving it that comfortable gothic feel.  ";
                            break;
                        case "MCH":
                            description_text += "- at a glance it appears decorated like a factory.  Those with a neural network see the lair as brightly colored and lit, full of knowledge, learning, and chapter iconography.  ";
                            break;
                        case "PRS":
                            description_text += ", the walls made up of polished sandstone or marble.  All throughout are chapter iconography and ancient symbols, wrought in gold.  ";
                            break;
                        case "RAV":
                            description_text += " but nearly pitch-black inside.  The only illumination is provided by loopy neon lux-casters, and strobes, which blast out light in random, flickering patterns.  ";
                            break;
                        case "STL":
                            description_text += ".  All of the surfaces are made up of highly polished stainless steel.  An occasional small water fountain or plant decorates the place.  ";
                            break;
                        case "UTL":
                            description_text += " and almost civilian looking in nature- the walls are up of simple concrete or plaster.  A thick carpet covers much of the floor.";
                            break;
                    }

                    if (secret_base.throne == 1) {
                        description_text += "  The center chamber is dominated by ";
                        if (obj_controller.temp[104] == string(obj_temp_build.target.name) + "." + string(obj_controller.selecting_planet)) {
                            description_text += "a massive throne, which you are currently seated upon.  ";
                        } else {
                            description_text += "a massive throne, though it is currently vacant.  ";
                        }
                    }
                    if ((secret_base.vox > 0) && (obj_temp_build.target.p_player[obj_controller.selecting_planet] > 0)) {
                        description_text += "Heretical music blasts from the vox-casters, shaking the walls.  ";
                    }
                    if (secret_base.narcotics > 0) {
                        description_text += "  Many of the tables have lines of white powder set on paper or bunches of needles.  Plastic straws lay close by.  ";
                    }
                    if (secret_base.cookery == 1) {
                        if (obj_temp_build.target.p_player[obj_controller.selecting_planet] > 0) {
                            description_text += "Imperial Chefs are currently bustling to and from the kitchen, cooking savory treats and food for those present.  ";
                        }
                        if (obj_temp_build.target.p_player[obj_controller.selecting_planet] == 0) {
                            description_text += "The Imperial Chefs are mostly idle, making use of the other rooms and facilities.  ";
                        }
                    }
                    switch (secret_base.stock) {
                        case 1:
                            description_text += "  One of the chambers is hollowed out to display war trophies and gear.  ";
                            break;
                        case 2:
                            description_text += "  One of the chambers holds war trophies from recent conquests.  ";
                            break;
                        case 3:
                            description_text += "  War trophies taken from several Xeno races are displayed in the Relic Room.  ";
                            break;
                        case 4:
                            description_text += "  Your Relic Room contains trophies and skulls, taken from every Xeno race.  ";
                            break;
                        case 5:
                            description_text += "  Your Relic Room contains trophies, skulls, and suits of armour taken from Xenos races.  ";
                            break;
                        case 6:
                            description_text += "  Your Relic Room contains wargear and suits of armour from all races, several Adeptus Astartes suits included.  ";
                            break;
                        case 7:
                            description_text += "  One of the chambers holds wargear and suits of armour from all races.  A suit of Terminator armour is included, half of the armour taken off to reveal the inner workings.";
                            break;
                        case 8:
                            description_text += "  Your Relic Room's trophies, skulls, and armours now spill out into the hallways, such is their number.  ";
                            break;
                        case 9:
                            description_text += "  Many of the xenos war trophies and suits of armour are placed around the Lair, filling out spare surfaces.  ";
                            break;
                        case 10:
                            description_text += "  In addition to the many war trophies your Relic Room also has small amounts of gold coins.  ";
                            break;
                        case 11:
                            description_text += "  In addition to the many war trophies your Relic Room also has small piles of gold coins and clutter.  ";
                            break;
                        case 12:
                            description_text += "  In addition to the many war trophies your Relic Room also has sizeable piles of gold.  ";
                            break;
                        case 13:
                            description_text += "  In addition to the many war trophies your Relic Room also has chests and cabinets full of gold.  ";
                            break;
                        case 14:
                            description_text += "  In addition to the many war trophies your Relic Room also has chests full to the brim of gold and many precious gems.  ";
                            break;
                        case 15:
                            description_text += "  War trophies, chests of gold, precious gems, your lair has it all.  ";
                            break;
                        case 16:
                            description_text += "  War trophies, chests of gold, precious gems, your lair has it all, and in abundance.  ";
                            break;
                        case 17:
                            description_text += "  The abundant gold and gem piles have begun to spill out into the hallway.  ";
                            break;
                        case 18:
                            description_text += "  The abundant gold and gems spill out into the hallway, your forces idly stepping across it.  ";
                            break;
                        case 19:
                            description_text += "  A sizeable portion of your lair is carelessly covered in gold coins, objects, and gems.  ";
                            break;
                        case 20:
                            description_text += "  Much of your lair is carelessly covered in gold coins, objects, and gems.  ";
                            break;
                        case 21:
                        case 22:
                        case 23:
                        case 24:
                            description_text += "  Your abundant wealth is evident in your lair- every surface and much of the floor smothered by gold or gems.  ";
                            break;
                        case 25:
                        case 26:
                        case 27:
                        case 28:
                        case 29:
                            description_text += "  Gold and gems are everywhere, occasionally attached to the walls and ceiling where able.  ";
                            break;
                        default:
                            if (secret_base.stock >= 30) {
                                description_text += "  Gold and gems are EVERYWHERE.  The main chamber in particular is a sea of gold and gems, especially deep at the corners.  In all it is nearly three feet deep.  Coins clink and settle as your forces walk through the room.  ";
                            }
                            break;
                    }
                    if (secret_base.forge > 0) {
                        description_text += "  Your lair has a forge, fit to be used by several astartes at once.  ";
                    }
                    if (secret_base.hippo > 0) {
                        description_text += "  Your lair has a hippodrome, or garage, that holds luxury vehicles.  ";
                    }
                    if (secret_base.torture > 0) {
                        description_text += "  One of the rooms is a well-stocked torture chamber.  ";
                    }
                    if (secret_base.librarium > 0) {
                        description_text += "  A large librarium makes up one of the wings, holding countless novels, books, scrolls, and documents on various topics.  ";
                    }
                    if (secret_base.beastarium > 0) {
                        description_text += "  Your lair has a beastarium, animals native to your homeworld living within.  ";
                    }
                    if (secret_base.swimming > 0) {
                        description_text += "  A large swimming pool with chapter-themed floaties is emplaced near the entrance.  ";
                    }
                    if (secret_base.stasis > 0) {
                        description_text += "  One of the chambers holds several stasis pods for display.  They are currently empty.  ";
                    }

                    draw_set_color(c_gray);
                    draw_set_font(fnt_40k_14);
                    draw_set_halign(fa_left);
                    draw_rectangle(xx + 12, yy + 45, xx + 486, yy + 378, 1);

                    var hh = 1;
                    for (var i = 0; i < 2; i++) {
                        if ((string_height_ext(string_hash_to_newline(string(description_text)), -1, 470) * hh) > 330) {
                            hh -= 0.1;
                        }
                    }
                    draw_text_ext_transformed(xx + 14, yy + 47, string_hash_to_newline(string(description_text)), -1, 470 * (2 + (hh * -1)), hh, hh, 0);

                    if (tooltip_title != "") {
                        draw_set_alpha(1);
                        draw_set_font(fnt_40k_14);
                        draw_set_halign(fa_left);
                        draw_set_color(c_black);
                        draw_rectangle(
                            mouse_x + 18,
                            mouse_y + 20,
                            mouse_x + string_width_ext(string_hash_to_newline(tooltip_desc), -1, 500) + 24,
                            mouse_y + 64 + string_height_ext(string_hash_to_newline(tooltip_desc), -1, 500),
                            0
                        );
                        draw_set_color(c_gray);
                        draw_rectangle(
                            mouse_x + 18,
                            mouse_y + 20,
                            mouse_x + string_width_ext(string_hash_to_newline(tooltip_desc), -1, 500) + 24,
                            mouse_y + 64 + string_height_ext(string_hash_to_newline(tooltip_desc), -1, 500),
                            1
                        );
                        draw_set_font(fnt_40k_14b);
                        draw_text(mouse_x + 22, mouse_y + 22, string_hash_to_newline(string(tooltip_title)));
                        draw_set_font(fnt_40k_14);
                        draw_text_ext(mouse_x + 22, mouse_y + 42, string_hash_to_newline(string(tooltip_desc)), -1, 500);

                        draw_set_color(#F89823);
                        if (obj_controller.requisition < cost) {
                            draw_set_color(c_red);
                        }
                        draw_sprite(spr_requisition, 0, mouse_x + 22, mouse_y + 45 + string_height_ext(string_hash_to_newline(tooltip_desc), -1, 500));
                        draw_text(mouse_x + 42, mouse_y + 42 + string_height_ext(string_hash_to_newline(tooltip_desc), -1, 500), string_hash_to_newline(string(cost)));
                    }
                }
            }
        }
        draw_set_font(fnt_40k_14b);
        description_text = "";
        if (planet_feature_bool(planet_upgrades, eP_FEATURES.ARSENAL) == 1) {
            arsenal = planet_upgrades[search_planet_features(planet_upgrades, eP_FEATURES.ARSENAL)[0]];
            if (arsenal.inquis_hidden == 1) {
                description_text = "A moderate sized secret Arsenal, this structure has ample holding area to store any number of artifacts and wargear.  Chaos and Daemonic items will be sent here by your Master of Relics, and due to the secret nature of its existance, the Inquisition will not find them during routine inspections.";
            }
            if (arsenal.inquis_hidden == 0) {
                description_text = "A moderate sized Arsenal, this structure has ample holding area to store any number of artifacts and wargear.  Since being discovered it may no longer hide Chaos and Daemonic wargear from routine Inquisition inspections.  You may wish to construct another Arsenal on a different planet.";
            }
        }
        if (planet_feature_bool(planet_upgrades, eP_FEATURES.GENE_VAULT) == 1) {
            gene_vault = planet_upgrades[search_planet_features(planet_upgrades, eP_FEATURES.GENE_VAULT)[0]];
            if (gene_vault.inquis_hidden == 1) {
                description_text = "A large facility with Gene-Vaults and additional spare rooms, this structure safely stores the majority of your Gene-Seed and is ran by servitors.  Due to its secret nature you may amass Gene-Seed and Test-Slave Incubators without fear of Inquisition reprisal or taking offense.";
            }
            if (gene_vault.inquis_hidden == 0) {
                description_text = "A large facility with Gene-Vaults and additional spare rooms, this structure safely stores the majority of your Gene-Seed and is ran by servitors.  Since being discovered all the contents are known to the Inquisition.  Your Gene-Seed remains protected but you may wish to build a new, secret one.";
            }
        }
        if ((arsenal != 0) || (gene_vault != 0)) {
            draw_text_ext(xx + 21, yy + 65, string_hash_to_newline(string(description_text)), -1, 595);
        }
        if (un_upgraded == 0 && obj_temp_build.isnew != 1) {
            draw_set_font(fnt_40k_14b);
            if (secret_base == 0) {
                draw_text(xx + 21, yy + 45, string_hash_to_newline("Lair"));
            }
            if (arsenal == 0) {
                draw_text(xx + 21, yy + 110, string_hash_to_newline("Arsenal"));
            }
            if (gene_vault == 0) {
                draw_text(xx + 21, yy + 175, string_hash_to_newline("Gene-Vault"));
            }
            draw_set_font(fnt_40k_14);

            draw_sprite(spr_requisition, 0, xx + 160, yy + 47);
            draw_set_color(#F89823);
            if (obj_controller.requisition < 1000) {
                draw_set_color(c_red);
            }
            draw_text(xx + 180, yy + 47, string_hash_to_newline("1000"));
            draw_set_color(c_gray);
            draw_text_ext(xx + 21, yy + 65, string_hash_to_newline("Customizable hideout that your forces may garrison into.  The Lair may be upgraded further."), -6, 600);
            draw_rectangle(xx + 300, yy + 45, xx + 400, yy + 65, 0);
            draw_set_halign(fa_center);
            draw_set_color(c_black);
            draw_text(xx + 350, yy + 47, string_hash_to_newline("Build"));
            draw_text(xx + 351, yy + 48, string_hash_to_newline("Build"));
            if (scr_hit(xx + 300, yy + 45, xx + 400, yy + 65) == true) {
                draw_set_alpha(0.2);
                draw_rectangle(xx + 300, yy + 45, xx + 400, yy + 65, 0);
                draw_set_alpha(1);

                if (mouse_button_clicked() && (obj_controller.requisition >= 1000)) {
                    obj_temp_build.isnew = 1;
                    obj_controller.requisition -= 1000;
                }
            }
            draw_set_halign(fa_left);

            draw_sprite(spr_requisition, 0, xx + 160, yy + 112);
            draw_set_color(#F89823);
            if (obj_controller.requisition < 1500) {
                draw_set_color(c_red);
            }
            draw_text(xx + 180, yy + 112, string_hash_to_newline("1500"));
            draw_set_color(c_gray);
            draw_text_ext(xx + 21, yy + 130, string_hash_to_newline("Hidden armoury that stores unused Chaos and Daemonic artifacts, preventing them from discovery."), -1, 600);
            draw_rectangle(xx + 300, yy + 110, xx + 400, yy + 130, 0);
            draw_set_halign(fa_center);
            draw_set_color(c_black);
            draw_text(xx + 350, yy + 112, string_hash_to_newline("Build"));
            draw_text(xx + 351, yy + 113, string_hash_to_newline("Build"));
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
            draw_set_color(#F89823);
            if (obj_controller.requisition < 4000) {
                draw_set_color(c_red);
            }
            draw_text(xx + 180, yy + 177, string_hash_to_newline("4000"));
            draw_set_color(c_gray);
            draw_text_ext(xx + 21, yy + 195, string_hash_to_newline("Hidden gene-vault that off-sources the majority of your Gene-Seed and Test-Slave Incubators."), -1, 600);
            draw_rectangle(xx + 300, yy + 175, xx + 400, yy + 195, 0);
            draw_set_halign(fa_center);
            draw_set_color(c_black);
            draw_text(xx + 350, yy + 177, string_hash_to_newline("Build"));
            draw_text(xx + 351, yy + 178, string_hash_to_newline("Build"));
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

        draw_set_font(fnt_40k_30b);
        draw_set_color(c_gray);
        draw_rectangle(xx + 312 - 60, yy + 388, xx + 312 + 60, yy + 420, 0);
        draw_set_halign(fa_center);
        draw_set_color(c_black);
        draw_text(xx + 312, yy + 388, string_hash_to_newline("Back"));
        if (scr_hit(xx + 312 - 60, yy + 388, xx + 312 + 60, yy + 420) == true) {
            draw_set_alpha(0.2);
            draw_rectangle(xx + 312 - 60, yy + 388, xx + 312 + 60, yy + 420, 0);
            draw_set_alpha(1);

            if (mouse_button_clicked()) {
                obj_controller.menu = 0;
            }
        }
        pop_draw_return_values();
    }

    if ((selected != 0) && (!instance_exists(selected))) {
        selected = 0;
    }

    xx = camera_get_view_x(view_camera[0]);
    yy = camera_get_view_y(view_camera[0]);

    if (zoomed == 0) {
        var tooltip = "";

        // Requisition income tooltip
        if (scr_hit(xx + 5, yy + 10, xx + 137, yy + 38)) {
            tooltip = "Requisition Points#";
            tooltip += string("Base Income: {0}{1}", income_base > 0 ? "+" : "", income_base);
            if (obj_ini.fleet_type == ePLAYER_BASE.HOME_WORLD) {
                if (income_home > 0) {
                    tooltip += string("#Fortress Monastery Bonus: +{0}", income_home);
                }
                if (income_forge > 0) {
                    tooltip += string("#Nearby Forge Worlds: +{0}", income_forge);
                }
                if (income_agri > 0) {
                    tooltip += string("#Nearby Agri Worlds: +{0}", income_agri);
                }
            }
            if (obj_ini.fleet_type != ePLAYER_BASE.HOME_WORLD) {
                tooltip += string("#Battle Barge Trade: {0}{1}", income_home > 0 ? "+" : "", income_home);
            }
            if (income_training != 0) {
                tooltip += string("#Specialist Training: {0}{1}", income_training > 0 ? "+" : "", income_training);
            }
            if (income_fleet != 0) {
                tooltip += string("#Fleet Maintenance: {0}{1}", income_fleet > 0 ? "+" : "", income_fleet);
            }
            if (income_tribute != 0) {
                tooltip += string("#Planet Tithes: {0}{1}", income_tribute > 0 ? "+" : "", income_tribute);
            }

            if (tooltip != "") {
                tooltip_draw(tooltip);
            }
        }

        // Current Loyalty tooltip
        if (scr_hit(xx + 247, yy + 10, xx + 328, yy + 38)) {
            for (var d = 1; d <= 20; d++) {
                if ((loyal_num[d] > 1)) {
                    tooltip += string(loyal[d]) + ": -" + string(loyal_num[d]) + "#";
                }
            }

            if (tooltip != "") {
                tooltip_draw(tooltip);
            } else {
                tooltip_draw("Loyalty");
            }
        }

        // Stored Gene-Seed tooltip
        if (scr_hit(xx + 373, yy + 10, xx + 443, yy + 38)) {
            tooltip = "Gene-Seed # " + obj_controller.apothecary_string;
            tooltip_draw(tooltip);
        }
        // Current Astartes tooltip
        if (scr_hit(xx + 478, yy + 3, xx + 552, yy + 38)) {
            tooltip = "Astartes (Normal/Command) # " + string(obj_controller.marines);
            tooltip_draw(tooltip);
        }
        // Turn tooltip
        if ((menu == 0) && (diplomacy <= 0)) {
            if (scr_hit(xx + 1435, yy + 40, xx + 1580, yy + 267)) {
                tooltip = $"Turn :{obj_controller.turn}";
                tooltip_draw(tooltip);
            }
        }
        // Forge Points income tooltip
        if (scr_hit(xx + 153, yy + 10, xx + 241, yy + 38)) {
            tooltip_draw(obj_controller.forge_string);
        }

        // Penitence/Blood Debt tooltip
        if (scr_hit(xx + 923, yy + 10, xx + 1060, yy + 38) && (penitent == 1)) {
            var bd_decay_rate = min(0, (((penitent_turn + 1) * (penitent_turn + 1)) - 512) * -1);

            if (obj_controller.blood_debt == 1) {
                tooltip = "Blood Spilled: " + string(penitent_current);
                tooltip += "#Blood Debt: " + string(penitent_max);
                tooltip += "#Decay Rate: " + string(bd_decay_rate);

                tooltip += "##Attacking enemies, Raiding enemies, and losing Astartes will lower your Chapter's Blood Debt.  Over time it decays.  Bombarding enemies will prevent decay.";
            }
            if (obj_controller.blood_debt == 0) {
                tooltip = "Current Penitence: " + string(penitent_current);
                tooltip += "#Required Penitence: " + string(penitent_max);

                tooltip += "##Penitence will be gained slowly over time.  After the timer runs out your Chapter will no longer be considered Penitent.";
            }

            if (tooltip != "") {
                tooltip_draw(tooltip);
            }
        }
    }
}
