

enum eBASE_TYPES {
    LAIR,
}

enum ePLAYERFEATURESTATUS {
    UNCONTESTED,
    CONTESTED,
    UNOCCUPIED,
    DERELICT,
    DAMAGED,
    DESTROYED
}


function PlayerForge() constructor {
    constructions = [];
    size = 1;
    techs_working = 0;
    f_type = eP_FEATURES.FORGE;
    vehicle_hanger = 0;
}


function PlayerUpgrade (_feature_type = eP_FEATURES.SECRET_BASE, _other_data = {}): PlanetFeature(_feature_type, _other_data) constructor {
    switch (f_type) {
        case eP_FEATURES.ARSENAL:
            planet_display = "Arsenal";
            break;
        case eP_FEATURES.GENE_VAULT:
            planet_display = "Gene Vault";
            break;
    }
    inquis_hidden = 1;
    player_hidden = 0;
    gene_banks = false;
    built = !struct_exists(_other_data, "built") ? obj_controller.turn + 3: _other_data.built;
}

function FortressMonastery (_feature_type = eP_FEATURES.MONASTERY, _other_data = {}): PlayerUpgrade(_feature_type, _other_data) constructor {
    planet_display = "Fortress Monastery";
    player_hidden = 0;
    forge = 0;
    inquis_hidden = 0;
    built = !struct_exists(_other_data, "built") ? 0 : _other_data.built;
    if (!struct_exists(_other_data, "name")){
        name = global.name_generator.GenerateFromSet("imperial_ship");
    } else {
        name = _other_data.name;
    }
    status = ePLAYERFEATURESTATUS.UNCONTESTED;

    static undamaged_states = [ePLAYERFEATURESTATUS.UNCONTESTED, ePLAYERFEATURESTATUS.CONTESTED, ePLAYERFEATURESTATUS,UNOCCUPIED];
    static damaged_states = [ePLAYERFEATURESTATUS.DERELICT, ePLAYERFEATURESTATUS.DAMAGED, ePLAYERFEATURESTATUS.DESTROYED];
    static player_controlled_states = [ePLAYERFEATURESTATUS.UNCONTESTED, ePLAYERFEATURESTATUS.CONTESTED];
    static player_controlled = function(){
        return array_contains(player_controlled, status);
    }
    static raided = function(){
        if (array_contains(undamaged_states, status)){
            status = damaged_states[0];
        } else if (array_contains(damaged_states, status)){
            if (status < ePLAYERFEATURESTATUS.DESTROYED){
                status++;
            }
        }
    }
}

function SecretBase (_feature_type = eP_FEATURES.SECRET_BASE, _other_data = {}): PlanetFeature(_feature_type, _other_data) constructor {
    base_type = eBASE_TYPES.LAIR;
    inquis_hidden = 1;
    planet_display = "Hidden Secret Base";
    player_hidden = 0;
    style = "UTL";
    if (struct_exists(_other_data, "style")) {
        style = _other_data[$ "style"];
    }
    built = obj_controller.turn + 3;
    forge = 0;
    hippo = 0;
    beastarium = 0;
    torture = 0;
    narcotics = 0;
    relic = 0;
    cookery = 0;
    vox = 0;
    librarium = 0;
    throne = 0;
    stasis = 0;
    swimming = 0;
    stock = 0;    
    static draw_base_info_page = function(_xx, _yy) {
        var button_label = "";
        var button_desc = "";
        var cost = 0;
        var button_x1 = _xx + 494;
        var button_y1 = _yy + 12;
        var button_x2 = _xx + 614;
        var button_y2 = _yy + 32;
        var button_padding = 2;
        var lair_window_description_text = "";

        for (var r = 1; r <= 12; r++) {
            var button_alpha = 1;
            switch (r) {
                case 1:
                    if (forge) {
                        button_alpha = 0.33;
                    }

                    cost = 1000;
                    button_label = localize("Forge");
                    button_desc = localize("A modest, less elaborate forge able to employ a handful of Astartes or Techpriest.");
                    break;
                case 2:
                    if (hippo) {
                        button_alpha = 0.33;
                    }

                    cost = 1000;
                    button_label = localize("Hippodrome");
                    button_desc = localize("A moderate sized garage fit to hold, service, and display vehicles.");
                    break;
                case 3:
                    if (beastarium) {
                        button_alpha = 0.33;
                    }

                    cost = 1000;
                    button_label = localize("Beastarium");
                    button_desc = localize("An enclosure with simulated greenery and foilage meant to hold beasts.");
                    break;
                case 4:
                    if (torture) {
                        button_alpha = 0.33;
                    }

                    cost = 500;
                    button_label = localize("Torture Chamber");
                    button_desc = localize("Only the best for the best.  A room full of torture tools and devices.");
                    break;
                case 5:
                    if (narcotics) {
                        button_alpha = 0.33;
                    }

                    cost = 500;
                    button_label = localize("Narcotics");
                    button_desc = localize("Several boxes worth of Obscura, Black Lethe, Kyxa... line it up.");
                    break;
                case 6:
                    if (relic > 0) {
                        button_alpha = 0.33;
                    }

                    cost = 500;
                    button_label = localize("Relic Room");
                    button_desc = localize("A room meant for displaying trophies.  May be purchased successive times.");
                    break;
                case 7:
                    if (cookery) {
                        button_alpha = 0.33;
                    }

                    cost = 250;
                    button_label = localize("Cookery");
                    button_desc = localize("A larger, well-stocked cookery, complete with a number of Imperial Chef servants.");
                    break;
                case 8:
                    if (vox) {
                        button_alpha = 0.33;
                    }

                    cost = 250;
                    button_label = localize("Vox Casters");
                    button_desc = localize("All the bass one could ever imaginably need.");
                    break;
                case 9:
                    if (librarium) {
                        button_alpha = 0.33;
                    }

                    cost = 250;
                    button_label = localize("Librarium");
                    button_desc = localize("A study fit to hold a staggering amount of tomes and scrolls.");
                    break;
                case 10:
                    if (throne) {
                        button_alpha = 0.33;
                    }

                    cost = 250;
                    button_label = localize("Throne");
                    button_desc = localize("A massive, ego boosting throne.");
                    break;
                case 11:
                    if (stasis) {
                        button_alpha = 0.33;
                    }

                    cost = 200;
                    button_label = localize("Stasis Pods");
                    button_desc = localize("Though they start empty, you may capture and display your foes in these.");
                    break;
                case 12:
                    if (swimming) {
                        button_alpha = 0.33;
                    }

                    cost = 100;
                    button_label = localize("Swimming Pool");
                    button_desc = localize("A large body of water meant for excersize or relaxation.");
                    break;
            }

            button_y1 = _yy + 12 + ((r - 1) * 22);
            button_y2 = _yy + 32 + ((r - 1) * 22);

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
                            forge = true;
                            forge_data = new PlayerForge();
                            break;
                        case 2:
                            hippo = true;
                            break;
                        case 3:
                            beastarium = true;
                            break;
                        case 4:
                            torture = true;
                            break;
                        case 5:
                            narcotics = true;
                            break;
                        case 6:
                            relic += 1;
                            break;
                        case 7:
                            cookery = true;
                            break;
                        case 8:
                            vox = true;
                            break;
                        case 9:
                            librarium = true;
                            break;
                        case 10:
                            throne = true;
                            break;
                        case 11:
                            stasis = true;
                            break;
                        case 12:
                            swimming = true;
                            break;
                    }
                }
            }
        }

        lair_window_description_text = localize("Deep beneath the surface of {0} {1} lays your ", [obj_temp_build.p_data.system.name, scr_roman(obj_temp_build.p_data.planet)]);
        if (inquis_hidden == 1) {
            lair_window_description_text += localize("secret lair.  ");
        } else {
            lair_window_description_text += localize("previously discovered lair.  ");
        }

        lair_window_description_text += localize("It is massive");
        switch (style) {
            case "BRB":
                lair_window_description_text += localize(", the walls decorated with animal hides and leather.  Among the copius body-trophies and bones are torches that hiss and spit.  ");
                break;
            case "DIS":
                lair_window_description_text += localize("- the main attraction is the rainbow-colored, lit up grid flooring which quickly change color.  Far overhead are metal rafters.  ");
                break;
            case "FEU":
                lair_window_description_text += localize(", the walls made up of sturdy blocks of stones.  It is heavily decorated with wooden furniture, banners, and medieval weaponry.  ");
                break;
            case "GTH":
                lair_window_description_text += localize(", the walls made up of lightly-dusty stone.  Mosaics and statues are abundant throughout, giving it that comfortable gothic feel.  ");
                break;
            case "MCH":
                lair_window_description_text += localize("- at a glance it appears decorated like a factory.  Those with a neural network see the lair as brightly colored and lit, full of knowledge, learning, and chapter iconography.  ");
                break;
            case "PRS":
                lair_window_description_text += localize(", the walls made up of polished sandstone or marble.  All throughout are chapter iconography and ancient symbols, wrought in gold.  ");
                break;
            case "RAV":
                lair_window_description_text += localize(" but nearly pitch-black inside.  The only illumination is provided by loopy neon lux-casters, and strobes, which blast out light in random, flickering patterns.  ");
                break;
            case "STL":
                lair_window_description_text += localize(".  All of the surfaces are made up of highly polished stainless steel.  An occasional small water fountain or plant decorates the place.  ");
                break;
            case "UTL":
                lair_window_description_text += localize(" and almost civilian looking in nature- the walls are up of simple concrete or plaster.  A thick carpet covers much of the floor.");
                break;
        }

        if (throne == 1) {
            lair_window_description_text += localize("  The center chamber is dominated by ");
            if (obj_controller.temp[104]) {
                lair_window_description_text += localize("a massive throne, which you are currently seated upon.  ");
            } else {
                lair_window_description_text += localize("a massive throne, though it is currently vacant.  ");
            }
        }

        if ((vox > 0) && (obj_temp_build.p_data.player_forces > 0)) {
            lair_window_description_text += localize("Heretical music blasts from the vox-casters, shaking the walls.  ");
        }

        if (narcotics > 0) {
            lair_window_description_text += localize("  Many of the tables have lines of white powder set on paper or bunches of needles.  Plastic straws lay close by.  ");
        }

        if (cookery == 1) {
            if (obj_temp_build.p_data.player_forces > 0) {
                lair_window_description_text += localize("Imperial Chefs are currently bustling to and from the kitchen, cooking savory treats and food for those present.  ");
            }

            if (obj_temp_build.p_data.player_forces == 0) {
                lair_window_description_text += localize("The Imperial Chefs are mostly idle, making use of the other rooms and facilities.  ");
            }
        }

        switch (stock) {
            case 1:
                lair_window_description_text += localize("  One of the chambers is hollowed out to display war trophies and gear.  ");
                break;
            case 2:
                lair_window_description_text += localize("  One of the chambers holds war trophies from recent conquests.  ");
                break;
            case 3:
                lair_window_description_text += localize("  War trophies taken from several Xeno races are displayed in the Relic Room.  ");
                break;
            case 4:
                lair_window_description_text += localize("  Your Relic Room contains trophies and skulls, taken from every Xeno race.  ");
                break;
            case 5:
                lair_window_description_text += localize("  Your Relic Room contains trophies, skulls, and suits of armour taken from Xenos races.  ");
                break;
            case 6:
                lair_window_description_text += localize("  Your Relic Room contains wargear and suits of armour from all races, several Adeptus Astartes suits included.  ");
                break;
            case 7:
                lair_window_description_text += localize("  One of the chambers holds wargear and suits of armour from all races.  A suit of Terminator armour is included, half of the armour taken off to reveal the inner workings.");
                break;
            case 8:
                lair_window_description_text += localize("  Your Relic Room's trophies, skulls, and armours now spill out into the hallways, such is their number.  ");
                break;
            case 9:
                lair_window_description_text += localize("  Many of the xenos war trophies and suits of armour are placed around the Lair, filling out spare surfaces.  ");
                break;
            case 10:
                lair_window_description_text += localize("  In addition to the many war trophies your Relic Room also has small amounts of gold coins.  ");
                break;
            case 11:
                lair_window_description_text += localize("  In addition to the many war trophies your Relic Room also has small piles of gold coins and clutter.  ");
                break;
            case 12:
                lair_window_description_text += localize("  In addition to the many war trophies your Relic Room also has sizeable piles of gold.  ");
                break;
            case 13:
                lair_window_description_text += localize("  In addition to the many war trophies your Relic Room also has chests and cabinets full of gold.  ");
                break;
            case 14:
                lair_window_description_text += localize("  In addition to the many war trophies your Relic Room also has chests full to the brim of gold and many precious gems.  ");
                break;
            case 15:
                lair_window_description_text += localize("  War trophies, chests of gold, precious gems, your lair has it all.  ");
                break;
            case 16:
                lair_window_description_text += localize("  War trophies, chests of gold, precious gems, your lair has it all, and in abundance.  ");
                break;
            case 17:
                lair_window_description_text += localize("  The abundant gold and gem piles have begun to spill out into the hallway.  ");
                break;
            case 18:
                lair_window_description_text += localize("  The abundant gold and gems spill out into the hallway, your forces idly stepping across it.  ");
                break;
            case 19:
                lair_window_description_text += localize("  A sizeable portion of your lair is carelessly covered in gold coins, objects, and gems.  ");
                break;
            case 20:
                lair_window_description_text += localize("  Much of your lair is carelessly covered in gold coins, objects, and gems.  ");
                break;
            case 21:
            case 22:
            case 23:
            case 24:
                lair_window_description_text += localize("  Your abundant wealth is evident in your lair- every surface and much of the floor smothered by gold or gems.  ");
                break;
            case 25:
            case 26:
            case 27:
            case 28:
            case 29:
                lair_window_description_text += localize("  Gold and gems are everywhere, occasionally attached to the walls and ceiling where able.  ");
                break;
            default:
                if (stock >= 30) {
                    lair_window_description_text += localize("  Gold and gems are EVERYWHERE.  The main chamber in particular is a sea of gold and gems, especially deep at the corners.  In all it is nearly three feet deep.  Coins clink and settle as your forces walk through the room.  ");
                }

                break;
        }

        if (forge > 0) {
            lair_window_description_text += localize("  Your lair has a forge, fit to be used by several astartes at once.  ");
        }

        if (hippo > 0) {
            lair_window_description_text += localize("  Your lair has a hippodrome, or garage, that holds luxury vehicles.  ");
        }

        if (torture > 0) {
            lair_window_description_text += localize("  One of the rooms is a well-stocked torture chamber.  ");
        }

        if (librarium > 0) {
            lair_window_description_text += localize("  A large librarium makes up one of the wings, holding countless novels, books, scrolls, and documents on various topics.  ");
        }

        if (beastarium > 0) {
            lair_window_description_text += localize("  Your lair has a beastarium, animals native to your homeworld living within.  ");
        }

        if (swimming > 0) {
            lair_window_description_text += localize("  A large swimming pool with chapter-themed floaties is emplaced near the entrance.  ");
        }

        if (stasis > 0) {
            lair_window_description_text += localize("  One of the chambers holds several stasis pods for display.  They are currently empty.  ");
        }

        button_x1 = _xx + 12;
        button_y1 = _yy + 45;

        draw_set_color(c_gray);
        draw_set_font(cjk_font(fnt_40k_14));
        draw_set_halign(fa_left);
        draw_rectangle(button_x1, _yy + 45, _xx + 486, _yy + 378, 1);

        var hh = 1;
        var min_scale = 0.6;
        while ((string_height_ext(lair_window_description_text, -1, 470) * hh) > 330 && hh > min_scale) {
            hh -= 0.1;
        }

        draw_text_ext_transformed(button_x1 + button_padding, button_y1 + button_padding, lair_window_description_text, -1, 470 * (2 + (hh * -1)), hh, hh, 0);

        // I know for a fact there is a better way to do this, and im sure this file could use another refactor, but oh my god im sick of it and it works and looks fine im done
        button_x1 = _xx + 494;
        button_x2 = _xx + 614;
        var tooltip_header = "";
        var tooltip_desc = "";
        var tooltip_rp_cost = 0;
        // Forge
        if (scr_hit(button_x1, _yy + 12, button_x2, _yy + 32)) {
            // + ((1 - 1) * 22)
            tooltip_rp_cost = 1000;
            tooltip_header = localize("Forge");
            tooltip_desc = localize("A modest, less elaborate forge able to employ a handful of Astartes or Techpriest.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Hippodrome
        if (scr_hit(button_x1, _yy + 34, button_x2, _yy + 54)) {
            // + ((2 - 1) * 22)
            tooltip_rp_cost = 1000;
            tooltip_header = localize("Hippodrome");
            tooltip_desc = localize("A moderate sized garage fit to hold, service, and display vehicles.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Beastarium
        if (scr_hit(button_x1, _yy + 56, button_x2, _yy + 76)) {
            // + ((3 - 1) * 22)
            tooltip_rp_cost = 1000;
            tooltip_header = localize("Beastarium");
            tooltip_desc = localize("An enclosure with simulated greenery and foilage meant to hold beasts.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Torture Chamber
        if (scr_hit(button_x1, _yy + 78, button_x2, _yy + 98)) {
            // + ((4 - 1) * 22)
            tooltip_rp_cost = 500;
            tooltip_header = localize("Torture Chamber");
            tooltip_desc = localize("Only the best for the best.  A room full of torture tools and devices.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Narcotics
        if (scr_hit(button_x1, _yy + 100, button_x2, _yy + 120)) {
            // + ((5 - 1) * 22)
            tooltip_rp_cost = 500;
            tooltip_header = localize("Narcotics");
            tooltip_desc = localize("Several boxes worth of Obscura, Black Lethe, Kyxa... line it up.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Relic Room
        if (scr_hit(button_x1, _yy + 122, button_x2, _yy + 142)) {
            // + ((6 - 1) * 22)
            tooltip_rp_cost = 500;
            tooltip_header = localize("Relic Room");
            tooltip_desc = localize("A room meant for displaying trophies.  May be purchased successive times.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Cookery
        if (scr_hit(button_x1, _yy + 144, button_x2, _yy + 164)) {
            // + ((7 - 1) * 22)
            tooltip_rp_cost = 250;
            tooltip_header = localize("Cookery");
            tooltip_desc = localize("A larger, well-stocked cookery, complete with a number of Imperial Chef servants.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Vox Casters
        if (scr_hit(button_x1, _yy + 166, button_x2, _yy + 186)) {
            // + ((8 - 1) * 22)
            tooltip_rp_cost = 250;
            tooltip_header = localize("Vox Casters");
            tooltip_desc = localize("All the bass one could ever imaginably need.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Librarium
        if (scr_hit(button_x1, _yy + 188, button_x2, _yy + 206)) {
            // + ((9 - 1) * 22)
            tooltip_rp_cost = 250;
            tooltip_header = localize("Librarium");
            tooltip_desc = localize("A study fit to hold a staggering amount of tomes and scrolls.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Throne
        if (scr_hit(button_x1, _yy + 210, button_x2, _yy + 228)) {
            // + ((10 - 1) * 22)
            tooltip_rp_cost = 250;
            tooltip_header = localize("Throne");
            tooltip_desc = localize("A massive, ego boosting throne.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Stasis Pods
        if (scr_hit(button_x1, _yy + 232, button_x2, _yy + 250)) {
            // + ((11 - 1) * 22)
            tooltip_rp_cost = 200;
            tooltip_header = localize("Stasis Pods");
            tooltip_desc = localize("Though they start empty, you may capture and display your foes in these.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }

        // Swimming Pool
        if (scr_hit(button_x1, _yy + 254, button_x2, _yy + 272)) {
            // + ((12 - 1) * 22)
            tooltip_rp_cost = 100;
            tooltip_header = localize("Swimming Pool");
            tooltip_desc = localize("A large body of water meant for excersize or relaxation.");
            tooltip_draw(tooltip_desc, 350, return_mouse_consts(), #50a076, fnt_40k_14, tooltip_header, fnt_40k_14b, false, localize("Cost:#"), fnt_40k_12, tooltip_rp_cost);
        }
    };
}


/// @desc Displays information on secret lairs.
/// @returns {Undefined}
function scr_secret_lair_view() {
    var xx = obj_temp_build.window_x;
    var yy = obj_temp_build.window_y;

    add_draw_return_values();
    draw_sprite(spr_popup_large, 1, xx, yy);
    draw_set_color(c_gray);
    draw_set_font(cjk_font(fnt_40k_30b));
    draw_set_halign(fa_center);

    var planet_upgrades = obj_temp_build.p_data.upgrades;
    var arsenal = obj_temp_build.arsenal;
    var gene_vault = obj_temp_build.gene_vault;
    var secret_base = obj_temp_build.secret_base;
    var lair_exists = obj_temp_build.lair_exists;
    var lair_window_description_text = "";
    /// @type {Struct.PlanetFeature|undefined}
    var lair_struct = undefined;

    if (obj_temp_build.isnew) {

        draw_set_font(cjk_font(fnt_40k_14b));
        draw_text(xx + 312, yy + 45, localize("Select a Secret Lair style."));
        draw_set_halign(fa_left);

        var base_x1 = xx + 21;
        var base_x2 = base_x1 + 579;
        var base_y1 = yy + 88;
        var base_y2 = base_y1 + 18;
        var text_x1 = base_x1 + 2;
        var text_x2 = text_x1 + 100;

        for (var r = 0; r < array_length(obj_temp_build.lair_styles); r++) {
            var style = obj_temp_build.lair_styles[r];
            var y_offset = r * 30;

            draw_set_color(c_gray);
            draw_rectangle(base_x1, base_y1 + y_offset, base_x2, base_y2 + y_offset, 0);

            if (scr_hit(base_x1, base_y1 + y_offset, base_x2, base_y2 + y_offset)) {
                draw_set_color(c_black);
                draw_set_alpha(0.2);
                draw_rectangle(base_x1, base_y1 + y_offset, base_x2, base_y2 + y_offset, 0);
                draw_set_alpha(1);

                if (mouse_button_clicked()) {
                    var base_options = {
                        style: style.tag,
                    };
                    obj_temp_build.isnew = false;
                    obj_temp_build.p_data.add_upgrade(eP_FEATURES.SECRET_BASE, base_options);
                    obj_temp_build.refresh();
                }
            }

            draw_set_color(c_black);
            draw_set_font(cjk_font(fnt_40k_14b));
            draw_text_transformed(text_x1, base_y1 + 2 + y_offset, localize(style.name), 1, 0.8, 0);
            draw_set_font(cjk_font(fnt_40k_14));
            draw_text_transformed(text_x2, base_y1 + 2 + y_offset, localize(style.description), 1, 0.8, 0);
        }
    }

    draw_text_transformed(xx + 312, yy + 10, obj_temp_build.title, 0.7, 0.7, 0);

    draw_set_halign(fa_left);

    if (secret_base) {
        var search_list = search_planet_features(planet_upgrades, eP_FEATURES.SECRET_BASE);
        if (array_length(search_list) > 0) {
            lair_struct = planet_upgrades[search_list[0]];
            if (lair_struct.built > obj_controller.turn) {
                draw_set_font(cjk_font(fnt_40k_14b));
                draw_text(xx + 21, yy + 65, localize("This feature will be constructed in {0} months.", [lair_struct.built - obj_controller.turn]));
            } else if (lair_struct.built <= obj_controller.turn) {
                lair_struct.draw_base_info_page(xx, yy);
            }
        }
    }

    draw_set_font(cjk_font(fnt_40k_14b));
    lair_window_description_text = "";
    if (arsenal) {
        lair_struct = planet_upgrades[search_planet_features(planet_upgrades, eP_FEATURES.ARSENAL)[0]];
        if (lair_struct.inquis_hidden == 1) {
            lair_window_description_text = localize("A moderate sized secret Arsenal, this structure has ample holding area to store any number of artifacts and wargear.  Chaos and Daemonic items will be sent here by your Master of Relics, and due to the secret nature of its existance, the Inquisition will not find them during routine inspections.");
        } else {
            lair_window_description_text = localize("A moderate sized Arsenal, this structure has ample holding area to store any number of artifacts and wargear.  Since being discovered it may no longer hide Chaos and Daemonic wargear from routine Inquisition inspections.  You may wish to construct another Arsenal on a different planet.");
        }
    }

    if (gene_vault) {
        lair_struct = planet_upgrades[search_planet_features(planet_upgrades, eP_FEATURES.GENE_VAULT)[0]];
        if (lair_struct.inquis_hidden == 1) {
            lair_window_description_text = localize("A large facility with Gene-Vaults and additional spare rooms, this structure safely stores the majority of your Gene-Seed and is ran by servitors.  Due to its secret nature you may amass Gene-Seed and Test-Slave Incubators without fear of Inquisition reprisal or taking offense.");
        } else {
            lair_window_description_text = localize("A large facility with Gene-Vaults and additional spare rooms, this structure safely stores the majority of your Gene-Seed and is ran by servitors.  Since being discovered all the contents are known to the Inquisition.  Your Gene-Seed remains protected but you may wish to build a new, secret one.");
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
        draw_set_color(c_gray);
        draw_text_ext(xx + 21, yy + 65, localize("Customizable hideout that your forces may garrison into.  The Lair may be upgraded further."), -6, 600);
        obj_temp_build.build_lair_button.draw();

        draw_set_color(c_gray);
        draw_text_ext(xx + 21, yy + 130, localize("Hidden armoury that stores unused Chaos and Daemonic artifacts, preventing them from discovery."), -1, 600);
        obj_temp_build.build_arsenal_button.draw();

        draw_set_color(c_gray);
        draw_text_ext(xx + 21, yy + 195, localize("Hidden gene-vault that off-sources the majority of your Gene-Seed and Test-Slave Incubators."), -1, 600);
        obj_temp_build.build_gene_vault_button.draw();
    }

    obj_temp_build.back_button.draw();

    pop_draw_return_values();
}
