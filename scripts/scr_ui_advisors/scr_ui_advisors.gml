/// @self Asset.GMObject.obj_controller
function scr_ui_advisors() {
    var romanNumerals = scr_roman_numerals();
    var xx = camera_get_view_x(view_camera[0]);
    var yy = camera_get_view_y(view_camera[0]);
    var blurp = "";
    var eta = 0;

    // This script draws all of the ADVISOR screens
    // *** Fleet advisor was here ***

    // ** Fleet **
    if (menu == eMENU.FLEET) {
        scr_fleet_advisor();
    }

    // ** Librarium **
    else if (menu == eMENU.LIBRARIUM) {
        scr_librarium();
    }

    // ** Recruiting **
    else if (menu == eMENU.RECRUITING) {
        scr_draw_recruit_advisor();
    }

    // ** Armamentarium **
    else if (menu == eMENU.ARMAMENTARIUM) {}

    // ** Apothecarium **
    else if (menu == eMENU.APOTHECARION) {
        scr_apothecarium();
    }

    // ** Reclusium **
    else if (menu == eMENU.RECLUSIAM) {
        scr_ui_reclusiam();
    }
// ** Festivals **
    if (menu == eMENU.FESTIVAL) {
        var _checkbox_sprite_index = 0;
        draw_set_font(cjk_font(fnt_40k_14b));
        draw_set_color(c_gray);
        draw_text_transformed(xx + 1262, yy + 70, localize("Scheduling Event"), 0.6, 0.6, 0);
        draw_text_transformed(xx + 962, yy + 126, localize("Event Type: "), 1, 1, 0);
        draw_text_transformed(xx + 962, yy + 185, localize("Event Location: "), 1, 1, 0);
        draw_text_transformed(xx + 962, yy + 266, localize("Grandoise: "), 1, 1, 0);
        draw_text_transformed(xx + 962, yy + 324, localize("Features: "), 1, 1, 0);
        draw_text_transformed(xx + 962, yy + 379, localize("Display: "), 1, 1, 0);

        draw_text_transformed(xx + 962, yy + 434, localize("Repeat: "), 1, 1, 0);
        draw_text_transformed(xx + 1225, yy + 434, localize("Honoring: "), 1, 1, 0);

        draw_text_transformed(xx + 962, yy + 527, localize("Attendees: "), 1, 1, 0);
        draw_text_transformed(xx + 1246, yy + 527, localize("Public: "), 1, 1, 0);

        draw_set_font(cjk_font(fnt_40k_14));

        // Attendees
        if (fest_attend != "") {
            draw_text_ext(xx + 962, yy + 550, string_hash_to_newline(string(fest_attend)), -1, 612);
        }

        // Location type
        if (fest_planet != 1) {
            _checkbox_sprite_index = 1;
        }
        if (fest_planet == 1) {
            _checkbox_sprite_index = 2;
        }

        var cx = xx + 990;
        var cy = yy + 212;

        draw_text(cx, cy, string_hash_to_newline(localize("Planet")));

        cx -= 35;
        cy -= 4;

        draw_sprite(spr_creation_check, _checkbox_sprite_index + 1, cx, cy);
        draw_set_alpha(1);
        if ((scr_hit(cx, cy, cx + 32, cy + 32) == true) && mouse_button_clicked() && (dropdown_open == 0)) {
            var onceh = 0;
            if ((onceh == 0) && (fest_planet == 0)) {
                onceh = 1;
                fest_planet = 1;
                fest_sid = -1;
                fest_wid = 0;
                fest_star = "";
                with (obj_dropdown_sel) {
                    if (target == "event_loc") {
                        option[1] = "";
                    }
                }
            }
        }
        if (fest_planet == 1) {
            _checkbox_sprite_index = 1;
        }
        if (fest_planet == 0) {
            _checkbox_sprite_index = 2;
        }
        if (fest_type == "Triumphal March") {
            draw_set_alpha(0.5);
        }

        cx = xx + 1100;
        cy = yy + 212;

        draw_text(cx, cy, string_hash_to_newline(localize("Ship")));

        cx -= 35;
        cy -= 4;

        draw_sprite(spr_creation_check, _checkbox_sprite_index + 1, cx, cy);
        draw_set_alpha(1);

        if ((scr_hit(cx, cy, cx + 32, cy + 32) == true) && mouse_button_clicked() && (dropdown_open == 0)) {
            var onceh = 0;
            if ((onceh == 0) && (fest_planet == 1) && (fest_type != "Triumphal March")) {
                onceh = 1;
                fest_planet = 0;
                fest_sid = -1;
                fest_wid = 0;
                fest_star = "";
                with (obj_dropdown_sel) {
                    if (target == "event_loc") {
                        option[1] = "";
                    }
                }
            }
        }
        draw_set_alpha(1);

        // Features
        var fet_text = "", fet_scale = 1;

        if (fest_type == "Great Feast") {
            fet_text = "Banquet";
        }
        if (fest_type == "Tournament") {
            fet_text = "Internal";
        }
        if (fest_type == "Deathmatch") {
            fet_text = "Chapter Only";
        }
        if (fest_type == "Chapter Relic") {
            fet_text = "Create Wargear";
        }
        if (fest_type == "Chapter Sermon") {
            fet_text = "Sanctioned";
        }
        if (fest_type == "Imperial Mass") {
            fet_text = "Local";
            fet_scale = 1;
        }
        if (fest_type == "Triumphal March") {
            fet_text = "Mandatory Attendance";
            fet_scale = 0.7;
        }

        if (fest_feature1 == 0) {
            _checkbox_sprite_index = 1;
        }
        if (fest_feature1 == 1) {
            _checkbox_sprite_index = 2;
        }

        cx = xx + 1090;
        cy = yy + 326;

        draw_text_transformed(cx, cy, string_hash_to_newline(localize(fet_text)), fet_scale, 1, 0);

        cx -= 35;
        cy -= 4;

        draw_sprite(spr_creation_check, _checkbox_sprite_index + 1, cx, cy);
        draw_set_alpha(1);
        if ((scr_hit(cx, cy, cx + 32, cy + 32) == true) && mouse_button_clicked() && (dropdown_open == 0)) {
            var onceh = 0;
            if ((fest_type == "Tournament") || (fest_type == "Deathmatch")) {
                onceh = 1;
            }
            if ((onceh == 0) && (fest_feature1 == 0)) {
                onceh = 1;
                fest_feature1 = 1;
            }
            if ((onceh == 0) && (fest_feature1 == 1) && (fest_type != "Chapter Relic")) {
                onceh = 1;
                fest_feature1 = 0;
            }
            if ((fest_type == "Chapter Relic") && (fest_feature1 == 1)) {
                fest_feature3 = 0;
                fest_feature2 = 0;
            }
        }
        if ((fest_type == "Tournament" || fest_type == "Deathmatch") && (fest_feature1 == 0)) {
            fest_feature1 = 1;
        }

        if (fest_type == "Great Feast") {
            fet_text = "Alcohol";
        }
        if (fest_type == "Tournament") {
            fet_text = "Spectators";
        }
        if (fest_type == "Deathmatch") {
            fet_text = "Spectators";
        }
        if (fest_type == "Chapter Relic") {
            fet_text = "Create Armour";
        }
        if (fest_type == "Imperial Mass") {
            fet_text = "Request Ecclesiarchy";
            fet_scale = 0.75;
        }
        if (fest_type == "Chapter Sermon") {
            fet_text = "Blood Sacrifices";
            fet_scale = 0.75;
        }
        if (fest_type == "Triumphal March") {
            fet_text = "Honor to Allies";
            fet_scale = 0.75;
        }

        if (fest_feature2 == 0) {
            _checkbox_sprite_index = 1;
        }
        if (fest_feature2 == 1) {
            _checkbox_sprite_index = 2;
        }
        if ((fest_type == "Imperial Mass") && (known[5] == 0)) {
            draw_set_alpha(0.5);
        }

        cx = xx + 1250;
        cy = yy + 326;

        draw_text_transformed(cx, cy, string_hash_to_newline(localize(fet_text)), fet_scale, 1, 0);
        cx -= 35;
        cy -= 4;
        draw_sprite(spr_creation_check, _checkbox_sprite_index + 1, cx, cy);
        draw_set_alpha(1);
        if ((scr_hit(cx, cy, cx + 32, cy + 32) == true) && mouse_button_clicked() && (dropdown_open == 0)) {
            var onceh = 0;
            if ((fest_type == "Imperial Mass") && (known[5] == 0)) {
                onceh = 1;
            }
            if ((onceh == 0) && (fest_feature2 == 0)) {
                onceh = 1;
                fest_feature2 = 1;
            }
            if ((onceh == 0) && (fest_feature2 == 1) && (fest_type != "Chapter Relic")) {
                onceh = 1;
                fest_feature2 = 0;
            }
            if ((fest_type == "Chapter Relic") && (fest_feature2 == 1)) {
                fest_feature1 = 0;
                fest_feature3 = 0;
            }
        }

        if (fest_type == "Great Feast") {
            fet_text = "Drugs";
        }
        if (fest_type == "Chapter Relic") {
            fet_text = "Upgrade Existing";
        }
        if (fest_type == "Chapter Sermon") {
            fet_text = "Drugs";
        }
        if (fest_type == "Tournament") {
            fet_text = "Invite Other Chapters";
            fet_scale = 0.75;
        }
        if (fest_type == "Deathmatch") {
            fet_text = "Allow Other Competitors";
            fet_scale = 0.7;
        }
        if (fest_type == "Imperial Mass") {
            fet_text = "Request Sororitas";
            fet_scale = 0.75;
        }
        if (fest_type == "Triumphal March") {
            fet_text = "Brandish Bloody Trophies";
            fet_scale = 0.6;
        }

        if (fest_feature3 == 0) {
            _checkbox_sprite_index = 1;
        }
        if (fest_feature3 == 1) {
            _checkbox_sprite_index = 2;
        }
        if ((fest_type == "Imperial Mass") && (known[5] == 0)) {
            draw_set_alpha(0.5);
        }

        cx = xx + 1388 + 22;
        cy = yy + 326;

        draw_text_transformed(cx, cy, string_hash_to_newline(localize(fet_text)), fet_scale, 1, 0);
        cx -= 35;
        cy -= 4;
        draw_sprite(spr_creation_check, _checkbox_sprite_index + 1, cx, cy);
        draw_set_alpha(1);
        if ((scr_hit(cx, cy, cx + 32, cy + 32) == true) && mouse_button_clicked() && (dropdown_open == 0)) {
            var onceh = 0;
            if ((fest_type == "Imperial Mass") && (known[5] == 0)) {
                onceh = 1;
            }
            if ((onceh == 0) && (fest_feature3 == 0)) {
                onceh = 1;
                fest_feature3 = 1;
            }
            if ((onceh == 0) && (fest_feature3 == 1) && (fest_type != "Chapter Relic")) {
                onceh = 1;
                fest_feature3 = 0;
            }
            if ((fest_type == "Chapter Relic") && (fest_feature3 == 1)) {
                fest_feature1 = 0;
                fest_feature2 = 0;
            }
        }

        // Always at least one feature
        if ((fest_type != "Triumphal March") && (fest_type != "Chapter Sermon")) {
            if ((fest_feature1 == 0) && (fest_feature2 == 0) && (fest_feature3 == 0)) {
                fest_feature1 = 1;
            }
        }

        // TODO Attendants
        if ((fest_attend == "") && ((fest_wid > 0) || (fest_sid > 0))) {
            // determine attendants
        }

        draw_set_font(cjk_font(fnt_40k_14));

        var doable = true;
        if (requisition < fest_cost) {
            doable = false;
        }
        if ((fest_wid == 0) && (fest_sid == -1)) {
            doable = false;
        }

        // Accept
        draw_set_halign(fa_left);
        draw_set_alpha(1);
        draw_set_color(c_gray);

        if (doable == false) {
            draw_set_alpha(0.5);
        }

        draw_rectangle(xx + 1302, yy + 780, xx + 1433, yy + 805, 0);
        draw_set_alpha(1);
        draw_set_color(c_black);
        draw_text(xx + 1305, yy + 784, string_hash_to_newline(localize("Schedule")));

        draw_sprite_ext(spr_requisition, 0, xx + 1374, yy + 787, 1, 1, 0, c_white, 1);
        draw_set_color(c_blue);

        if (requisition < fest_cost) {
            draw_set_color(c_red);
        }
        draw_text(xx + 1388, yy + 784, string_hash_to_newline(string(fest_cost)));
        if ((scr_hit(xx + 1302, yy + 780, xx + 1423, yy + 805) == true) && (doable == true)) {
            draw_set_color(c_white);
            draw_set_alpha(0.2);
            draw_rectangle(xx + 1302, yy + 780, xx + 1433, yy + 805, 0);

            if (mouse_button_clicked()) {
                requisition -= fest_cost;
                fest_scheduled = 1;
                menu = eMENU.RECLUSIAM;
                with (obj_dropdown_sel) {
                    instance_destroy();
                }
                if (fest_repeats == 0) {
                    fest_repeats = 1;
                }
            }
        }

        // Cancel
        draw_set_halign(fa_center);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        draw_rectangle(xx + 1132, yy + 780, xx + 1253, yy + 805, 0);
        draw_set_color(c_black);
        draw_text(xx + 1192, yy + 783, string_hash_to_newline(localize("Cancel")));
        if (scr_hit(xx + 1132, yy + 780, xx + 1253, yy + 805) == true) {
            draw_set_color(c_white);
            draw_set_alpha(0.2);
            draw_rectangle(xx + 1132, yy + 780, xx + 1253, yy + 805, 0);
            if (mouse_button_clicked()) {
                fest_type = "";
                fest_sid = -1;
                fest_wid = 0;
                fest_planet = 0;
                fest_star = "";
                fest_lav = 0;
                fest_locals = 0;
                fest_feature1 = 0;
                fest_feature2 = 0;
                fest_attend = "";
                fest_feature3 = 0;
                fest_display = -1;
                fest_repeats = 0;
                fest_warp = 0;
                menu = eMENU.RECLUSIAM;
                with (obj_dropdown_sel) {
                    instance_destroy();
                }
            }
        }
        draw_set_halign(fa_left);
        draw_set_alpha(1);
    }

    // ** Chapter Master **
    if (menu == eMENU.CHAPTER_MASTER) {
        draw_set_color(0);
        draw_sprite(spr_rock_bg, 0, xx, yy);
        draw_sprite(spr_master_splash, 0, xx, yy);

        draw_rectangle(xx + 213, yy + 25, xx + 622, yy + 78, 0);

        draw_set_halign(fa_center);
        draw_set_color(CM_GREEN_COLOR);
        draw_line(xx + 213, yy, xx + 213, yy + 640);
        draw_rectangle(xx + 213, yy + 25, xx + 622, yy + 78, 1);

        draw_set_color(0);
        draw_rectangle(xx + 217, yy + 82, xx + 617, yy + 188, 0);
        draw_rectangle(xx + 217, yy + 199, xx + 617, yy + 367, 0);
        draw_rectangle(xx + 217, yy + 380, xx + 617, yy + 411, 0);

        draw_set_color(CM_GREEN_COLOR);
        draw_rectangle(xx + 217, yy + 82, xx + 617, yy + 188, 1);
        draw_rectangle(xx + 217, yy + 199, xx + 617, yy + 367, 1);
        draw_rectangle(xx + 217, yy + 380, xx + 617, yy + 411, 1);

        draw_set_font(cjk_font(fnt_large));
        draw_text_transformed(xx + 410, yy + 29, localize(obj_ini.player_role_data[eROLE.CHAPTERMASTER].role), 0.5, 0.5, 0);

        draw_set_font(cjk_font(fnt_fancy));
        draw_text_transformed(xx + 410, yy + 40, string_hash_to_newline(string(obj_ini.master_name)), 1.5, 1.5, 0);
        draw_set_font(cjk_font(fnt_small));
        draw_set_halign(fa_left);

        var eqp = "", tempe = "";

        draw_text(xx + 222, yy + 83, localize("Equipment:"));
        draw_text(xx + 222.5, yy + 83.5, localize("Equipment:"));

        draw_set_font(cjk_font(fnt_tiny));
        draw_text_ext(xx + 222, yy + 99, string_hash_to_newline(string(eqp)), -1, 396);

        draw_set_font(cjk_font(fnt_small));
        draw_text(xx + 222, yy + 200, localize("Kills:"));
        draw_text(xx + 222.5, yy + 200.5, localize("Kills:"));

        // draw_text_ext(xx + 222, yy + 216, string_hash_to_newline(string(tot_ki)), -1, 396);
        var _unit = fetch_unit([0, 1]);
        if (is_struct(_unit)) {
            if (_unit.ship_location == -1) {
                draw_text(xx + 222, yy + 380, string_hash_to_newline(localize("Current Location: {0} {1}#Health: {2}%", [_unit.location_string, _unit.planet_location, _unit.hp()])));
            } else if (_unit.ship_location > -1) {
                draw_text(xx + 222, yy + 380, string_hash_to_newline(localize("Current Location: Onboard {0}#Health: {1}%", [obj_ini.ship[_unit.ship_location], _unit.hp()])));
            }
        }

        draw_text(xx + 222.5, yy + 380.5, string_hash_to_newline(localize("Current Location:#Health:")));

        draw_sprite(spr_arrow, 0, xx + 217, yy + 32);
    }
    // ** Welcome Screens **
    if (menu >= eMENU.WELCOME_SCREEN1 && menu <= eMENU.WELCOME_SCREEN4) {
        draw_sprite(spr_welcome_bg, 0, xx, yy);
        scr_image("advisor/splash", 1, xx + 16, yy + 16, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(0);
        draw_set_font(cjk_font(fnt_40k_14));

        if (menu == eMENU.WELCOME_SCREEN1) {
            draw_text_ext(xx + 370, yy + 72, string_hash_to_newline(string(temp[65])), -1, 660);
        }
        if (menu == eMENU.WELCOME_SCREEN2) {
            draw_text_ext(xx + 370, yy + 72, string_hash_to_newline(string(temp[66])), -1, 660);
        }
        if (menu == eMENU.WELCOME_SCREEN3) {
            draw_text_ext(xx + 370, yy + 72, string_hash_to_newline(string(temp[67])), -1, 660);
        }
        if (menu == eMENU.WELCOME_SCREEN4) {
            draw_text_ext(xx + 370, yy + 72, string_hash_to_newline(string(temp[68])), -1, 660);
        }
        draw_set_halign(fa_center);
        draw_text(xx + 702, yy + 695, localize("{0} (Press Any Key)", [menu - 2]));
        draw_set_halign(fa_left);
    }

    // ** Chapter Management **
    if ((menu == eMENU.MANAGE) && (managing == 0)) {
        draw_set_alpha(1);
        draw_sprite(spr_rock_bg, 0, xx, yy);
        draw_set_font(cjk_font(fnt_40k_30b));
        draw_set_halign(fa_center);
        draw_set_color(c_gray);
        draw_text(xx + 800, yy + 74, localize("{0} Chapter Organization", [global.chapter_name]));
    }
}
