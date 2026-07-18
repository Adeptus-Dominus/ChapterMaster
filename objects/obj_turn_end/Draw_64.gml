draw_set_font(fnt_40k_14b);
draw_set_halign(fa_left);
draw_set_color(CM_GREEN_COLOR);

if ((alerts > 0) && (popups_end == 1)) {
    for (var i = 1; i <= alerts; i++) {
        set_alert_draw_colour(alert_color[i]);
        draw_set_alpha(min(1, alert_alpha[i]));
        draw_text(32, 46 + (i * 20), string_hash_to_newline(string(alert_txt[i])));
    }
}

draw_set_alpha(1);
draw_set_font(fnt_small);
draw_set_halign(fa_left);
draw_set_color(255);

if (obj_controller.force_scroll == 1) {
    exit;
}

if (combating > 0) {
    exit;
}
if (obj_controller.audience > 0) {
    exit;
}

if ((show == 0) && (current_popup == 0)) {
    draw_sprite(spr_loading, image_index, 23, 73);
}

if ((show > 0) && (current_battle <= battles)) {
    var xxx = 535;
    var yyy = 200;
    var i = current_battle;

    draw_sprite(spr_purge_panel, 0, xxx, yyy);
    if (battle_world[i] == 0) {
        scr_image("attacked", 1, xxx + 12, yyy + 54, 254, 174);
    }
    if (battle_world[i] > 0) {
        scr_image("attacked", 0, xxx + 12, yyy + 54, 254, 174);
    }

    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_left);
    draw_set_color(c_gray);
    draw_text(xxx + 8, yyy + 13, string_hash_to_newline(string(i) + "/" + string(battles)));

    draw_set_halign(fa_center);
    draw_set_font(fnt_40k_30b);

    if (battle_world[i] > 0) {
        draw_text_transformed(xxx + 265, yyy + 11, string_hash_to_newline("Forces Attacked! (" + string(battle_location[i]) + " " + scr_roman(battle_world[i]) + ")"), 0.7, 0.7, 0);
    }
    if (battle_world[i] == 0) {
        draw_text_transformed(xxx + 265, yyy + 11, string_hash_to_newline("Fleet Attacked! (" + string(battle_location[i]) + " System)"), 0.7, 0.7, 0);
    }

    scr_image("ui/force", 1, xxx + 346, yyy + 54, 64, 64);

    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_left);

    if (battle_world[i] == 0) {
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_left);

        draw_text(xxx + 12, yyy + 237, "Enemy Fleets:");
        draw_text(xxx + 332, yyy + 237, "Allied Fleets:");

        if (string(strin[1]) == "1") {
            draw_text(xxx + 310, yyy + 118, string_hash_to_newline(string(strin[1]) + " Battleship (" + string(strin[4]) + "% HP)"));
        }
        if (string(strin[2]) == "1") {
            draw_text(xxx + 310, yyy + 138, string_hash_to_newline(string(strin[2]) + " Frigate (" + string(strin[5]) + "% HP)"));
        }
        if (string(strin[3]) == "1") {
            draw_text(xxx + 310, yyy + 158, string_hash_to_newline(string(strin[3]) + " Escort (" + string(strin[6]) + "% HP)"));
        }
        if (string(strin[1]) != "1") {
            draw_text(xxx + 310, yyy + 118, string_hash_to_newline(string(strin[1]) + " Battleships (" + string(strin[4]) + "% HP)"));
        }
        if (string(strin[2]) != "1") {
            draw_text(xxx + 310, yyy + 138, string_hash_to_newline(string(strin[2]) + " Frigates (" + string(strin[5]) + "% HP)"));
        }
        if (string(strin[3]) != "1") {
            draw_text(xxx + 310, yyy + 158, string_hash_to_newline(string(strin[3]) + " Escorts (" + string(strin[6]) + "% HP)"));
        }

        draw_set_halign(fa_center);

        if (enemy_fleet[1] != 0) {
            scr_image("ui/force", enemy_fleet[1], xxx + 12, yyy + 237, 64, 64);
            var shw = "";
            if (ecap[1] == 1) {
                shw += string(ecap[1]) + " Battleship#";
            }
            if (ecap[1] != 1) {
                shw += string(ecap[1]) + " Battleships#";
            }
            if (efri[1] == 1) {
                shw += string(efri[1]) + " Frigate#";
            }
            if (efri[1] != 1) {
                shw += string(efri[1]) + " Frigates#";
            }
            if (eesc[1] == 1) {
                shw += string(eesc[1]) + " Escort#";
            }
            if (eesc[1] != 1) {
                shw += string(eesc[1]) + " Escorts#";
            }

            draw_text_transformed(xxx + 44, yyy + 286, string_hash_to_newline(shw), 0.7, 1, 0);
            draw_set_halign(fa_center);
            draw_set_font(fnt_40k_14b);
        }
        if (enemy_fleet[2] != 0) {
            scr_image("ui/force", enemy_fleet[2], xxx + 122, yyy + 237, 64, 64);
            var shw = "";
            if (ecap[2] == 1) {
                shw += string(ecap[2]) + " Battleship#";
            }
            if (ecap[2] != 1) {
                shw += string(ecap[2]) + " Battleships#";
            }
            if (efri[2] == 1) {
                shw += string(efri[2]) + " Frigate#";
            }
            if (efri[2] != 1) {
                shw += string(efri[2]) + " Frigates#";
            }
            if (eesc[2] == 1) {
                shw += string(eesc[2]) + " Escort#";
            }
            if (eesc[2] != 1) {
                shw += string(eesc[2]) + " Escorts#";
            }

            draw_text_transformed(xxx + 154, yyy + 286, string_hash_to_newline(shw), 0.7, 1, 0);
            draw_set_halign(fa_center);
            draw_set_font(fnt_40k_14b);
        }
        if (enemy_fleet[3] != 0) {
            scr_image("ui/force", enemy_fleet[3], xxx + 232, yyy + 237, 64, 64);
            var shw = "";
            if (ecap[3] == 1) {
                shw += string(ecap[3]) + " Battleship#";
            }
            if (ecap[3] != 1) {
                shw += string(ecap[3]) + " Battleships#";
            }
            if (efri[3] == 1) {
                shw += string(efri[3]) + " Frigate#";
            }
            if (efri[3] != 1) {
                shw += string(efri[3]) + " Frigates#";
            }
            if (eesc[3] == 1) {
                shw += string(eesc[3]) + " Escort#";
            }
            if (eesc[3] != 1) {
                shw += string(eesc[3]) + " Escorts#";
            }

            draw_text_transformed(xxx + 264, yyy + 286, string_hash_to_newline(shw), 0.7, 1, 0);
            draw_set_halign(fa_center);
            draw_set_font(fnt_40k_14b);
        }

        if (allied_fleet[1] != 0) {
            scr_image("ui/force", allied_fleet[1], xxx + 342, yyy + 237, 64, 64);
            var shw = "";
            if (acap[1] == 1) {
                shw += string(acap[1]) + " Battleship#";
            }
            if (acap[1] != 1) {
                shw += string(acap[1]) + " Battleships#";
            }
            if (afri[1] == 1) {
                shw += string(afri[1]) + " Frigate#";
            }
            if (afri[1] != 1) {
                shw += string(afri[1]) + " Frigates#";
            }
            if (aesc[1] == 1) {
                shw += string(aesc[1]) + " Escort#";
            }
            if (aesc[1] != 1) {
                shw += string(aesc[1]) + " Escorts#";
            }

            draw_text_transformed(xxx + 374, yyy + 286, string_hash_to_newline(shw), 0.7, 1, 0);
            draw_set_halign(fa_center);
            draw_set_font(fnt_40k_14b);
        }
        if (allied_fleet[2] != 0) {
            scr_image("ui/force", allied_fleet[2], xxx + 452, yyy + 237, 64, 64);
            var shw = "";
            if (acap[2] == 1) {
                shw += string(acap[2]) + " Battleship#";
            }
            if (acap[2] != 1) {
                shw += string(acap[2]) + " Battleships#";
            }
            if (afri[2] == 1) {
                shw += string(afri[2]) + " Frigate#";
            }
            if (afri[2] != 1) {
                shw += string(afri[2]) + " Frigates#";
            }
            if (aesc[2] == 1) {
                shw += string(aesc[2]) + " Escort#";
            }
            if (aesc[2] != 1) {
                shw += string(aesc[2]) + " Escorts#";
            }

            draw_text_transformed(xxx + 484, yyy + 286, string_hash_to_newline(shw), 0.7, 1, 0);
            draw_set_halign(fa_center);
            draw_set_font(fnt_40k_14b);
        }

        draw_set_color(c_gray);
        draw_rectangle(xxx + 132, yyy + 354, xxx + 259, yyy + 389, 0);
        draw_set_color(0);
        draw_text_transformed(xxx + 195, yyy + 362, "Retreat", 1.1, 1.1, 0);
        if (scr_hit(xxx + 132, yyy + 354, xxx + 259, yyy + 389)) {
            draw_set_alpha(0.2);
            draw_rectangle(xxx + 132, yyy + 354, xxx + 259, yyy + 389, 0);
            draw_set_alpha(1);
        }

        draw_set_color(c_gray);
        draw_rectangle(xxx + 272, yyy + 354, xxx + 399, yyy + 389, 0);
        draw_set_color(0);
        draw_text_transformed(xxx + 335, yyy + 362, "Fight", 1.1, 1.1, 0);
        if (scr_hit(xxx + 272, yyy + 354, xxx + 399, yyy + 389)) {
            draw_set_alpha(0.2);
            draw_rectangle(xxx + 272, yyy + 354, xxx + 399, yyy + 389, 0);
            draw_set_alpha(1);
        }
    }

    if (battle_world[i] >= 1) {
        if (battle_opponent[i] <= 20) {
            draw_text(xxx + 310, yyy + 118, string_hash_to_newline(string(strin[1]) + " Marines"));
            draw_text(xxx + 310, yyy + 138, string_hash_to_newline(string(strin[2]) + " Vehicles"));
            if (strin[3] != "") {
                draw_text(xxx + 310, yyy + 158, string_hash_to_newline(string(strin[3]) + " Fortified"));
            } // Not / Barely / Lightly / Moderately / Highly / Maximally
        }

        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_left);

        draw_text(xxx + 12, yyy + 237, "Enemy Factions:");
        draw_text(xxx + 332, yyy + 237, "Allies:");

        draw_set_halign(fa_center);
        scr_image("ui/force", battle_opponent[i], xxx + 12, yyy + 257, 64, 64);
        draw_text_transformed(xxx + 44, yyy + 316, string_hash_to_newline(string(strin[4])), 0.75, 1, 0);
        draw_set_halign(fa_center);
        draw_set_font(fnt_40k_14b);

        draw_set_color(c_gray);
        draw_rectangle(xxx + 132, yyy + 354, xxx + 259, yyy + 389, 0);
        draw_set_color(0);
        draw_text_transformed(xxx + 195, yyy + 362, "Offensive", 1.1, 1.1, 0);
        if (scr_hit(xxx + 132, yyy + 354, xxx + 259, yyy + 389)) {
            draw_set_alpha(0.2);
            draw_rectangle(xxx + 132, yyy + 354, xxx + 259, yyy + 389, 0);
            draw_set_alpha(1);
        }

        draw_set_color(c_gray);
        draw_rectangle(xxx + 272, yyy + 354, xxx + 399, yyy + 389, 0);
        draw_set_color(0);
        draw_text_transformed(xxx + 335, yyy + 362, "Defensive", 1.1, 1.1, 0);
        if (scr_hit(xxx + 272, yyy + 354, xxx + 399, yyy + 389)) {
            draw_set_alpha(0.2);
            draw_rectangle(xxx + 272, yyy + 354, xxx + 399, yyy + 389, 0);
            draw_set_alpha(1);
        }
    }
}
