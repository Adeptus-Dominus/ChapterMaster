/// @function scr_ui_tooltip()
/// @category UI
/// @description Handles tooltip logics around the main play screen
function scr_ui_tooltip() {
    if ((selected != noone) && (!instance_exists(selected))) {
        selected = noone;
    }
    if (zoomed != 0) {
        exit;
    }

    // The resource bar and banner draw on the GUI layer (Draw_64, fixed 1600x900 design
    // space), but these hover rects were anchored to the CAMERA VIEW: identical at the
    // default framing, drifting apart at any wheel zoom. Zoomed out, the banner's Turn
    // rect slid under the top-left bar and the gene-seed rect slid over the Forge Points
    // box (the wrong-tooltip report), and the true rects shrank off their boxes ("hard
    // to mouse over"). Test in GUI space (scr_hit force_gui) so the rects sit on the
    // pixels the bar actually occupies at every zoom.
    var tooltip = "";

    // Requisition income tooltip
    if (scr_hit(5, 10, 137, 38, true)) {
        tooltip = "Requisition Points";
        tooltip += string("#Base Income: {0}{1}", income_base > 0 ? "+" : "", income_base);
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
        if (income_regions != 0) {
            tooltip += string("#Planetary Industry: {0}{1}", income_regions > 0 ? "+" : "", income_regions);
        }

        if (tooltip != "") {
            tooltip_draw(tooltip);
        }
    }

    // Current Loyalty tooltip
    if (scr_hit(247, 10, 328, 38, true)) {
        for (var i = 1; i <= 20; i++) {
            if (loyal_num[i] > 1) {
                tooltip += string(loyal[i]) + ": -" + string(loyal_num[i]) + "#";
            }
        }

        if (tooltip != "") {
            tooltip_draw(tooltip);
        } else {
            tooltip_draw("Loyalty");
        }
    }

    // Stored Gene-Seed tooltip
    if (scr_hit(373, 10, 443, 38, true)) {
        tooltip = "Gene-Seed#" + obj_controller.apothecary_string;
        tooltip_draw(tooltip);
    }
    // Current Astartes tooltip
    if (scr_hit(478, 3, 552, 38, true)) {
        tooltip = "Astartes (Normal/Command)#" + string(obj_controller.marines);
        tooltip_draw(tooltip);
    }
    // Turn tooltip
    if ((menu == eMENU.DEFAULT) && (diplomacy <= 0)) {
        if (scr_hit(1435, 40, 1580, 267, true)) {
            tooltip = $"Turn :{obj_controller.turn}";
            tooltip_draw(tooltip);
        }
    }
    // Forge Points income tooltip
    if (scr_hit(153, 10, 241, 38, true)) {
        tooltip_draw(obj_controller.forge_string);
    }

    // Penitence/Blood Debt tooltip
    if (scr_hit(923, 10, 1060, 38, true) && (penitent == 1)) {
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
