/// @mixin obj_controller
function scr_ui_advisors() {

    var xx, yy, blurp, eta, va;
    var romanNumerals;
    romanNumerals = scr_roman_numerals();

    xx = __view_get(e__VW.XView, 0) + 0;
    yy = __view_get(e__VW.YView, 0) + 0;
    blurp = "";
    eta = 0;

    // This script draws all of the ADVISOR screens

    // ** Fleet **
    if (menu = 16) {
        scr_fleet_advisor();
    }


    // ** Apothecarium **
    if (menu = 11) {
        scr_apothecarium();
    }

    // ** Reclusium **
    if ((menu = 12) or(menu = 12.1)) {
        draw_sprite(spr_rock_bg, 0, xx, yy);

        draw_set_alpha(0.75);
        draw_set_color(0);
        draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 0);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        draw_rectangle(xx + 326 + 16, yy + 66, xx + 887 + 16, yy + 818, 1);
        draw_line(xx + 326 + 16, yy + 426, xx + 887 + 16, yy + 426);

        draw_set_alpha(0.75);
        draw_set_color(0);
        draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 0);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 1);

        if (menu_adept = 0) {
            // draw_sprite(spr_advisors,2,xx+16,yy+43);
            if(struct_exists(obj_ini.custom_advisors, "chaplain")){
                scr_image("advisor/splash", obj_ini.custom_advisors.chaplain, xx + 16, yy + 43, 310, 828);
            } else {
                scr_image("advisor/splash", 3, xx + 16, yy + 43, 310, 828);
            }
            // if (global.chapter_name = "Space Wolves") then scr_image("advisor", 11, xx + 16, yy + 43, 310, 828);
            // draw_sprite(spr_advisors,11,xx+16,yy+16);
            draw_set_halign(fa_left);
            draw_set_color(c_gray);
            draw_set_font(fnt_40k_30b);
            draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline("Reclusium"), 1, 1, 0);
            draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Master of Sanctity " + string(obj_ini.name[0, 2])), 0.6, 0.6, 0);
        }
        if (menu_adept = 1) {
            // draw_sprite(spr_advisors,0,xx+16,yy+43);
            scr_image("advisor/splash", 1, xx + 16, yy + 43, 310, 828);
            draw_set_halign(fa_left);
            draw_set_color(c_gray);
            draw_set_font(fnt_40k_30b);
            draw_text_transformed(xx + 336 + 16, yy + 66, string_hash_to_newline("Reclusium"), 1, 1, 0);
            draw_text_transformed(xx + 336 + 16, yy + 100, string_hash_to_newline("Adept " + string(obj_controller.adept_name)), 0.6, 0.6, 0);
        }

        draw_set_font(fnt_40k_14);
        draw_set_alpha(1);
        draw_set_color(c_gray);
        if (temp[36] != "0") then blurp = "Sir!  You requested a report?  Currently, we have deployed " + string(temp[36]) + " " + string(obj_ini.role[100, 14]) + "s to watch over the health of our Battle-Brothers in the field.  We have an additional " + string(temp[37]) + " " + string(obj_ini.role[100, 14]) + "s who await only your order to carry the word to the troops.";
        if (temp[36] = "0") then blurp = "Sir!  You requested a report?  Currently, we have " + string(temp[37]) + " " + string(obj_ini.role[100, 14]) + "s who await only your order to carry the word to the troops.";
        // 
        if (global.chapter_name != "Space Wolves") and(global.chapter_name != "Iron Hands") {
            blurp += "##Currently, we are training additional " + string(obj_ini.role[100, 14]) + " at a ";
            var _recruit_rates = ARR_recruitment_rates;
            blurp += _recruit_rates[training_chaplain];
            if (training_chaplain>0 && training_chaplain <=6) {
                var training_points_values = ARR_chaplain_training_tiers;
                blurp += _recruit_rates[training_chaplain];
                eta = floor((47 - chaplain_points) / training_points_values[training_chaplain]) + 1;
            }
            // 
            blurp += " rate";
            if (training_chaplain > 0) then blurp += " and expect to see a new one in " + string(eta) + " month's time.";
            if (training_chaplain < 5) then blurp += "We can increase this rate, but it will require us to requisition additional facilities, as well as upkeep, Sir.";
            if (penitorium = 0) then blurp += "##Our men have been behaving as they should.  Not a single one is scheduled for corrective action of any type.";

            draw_set_font(fnt_40k_30b);
            draw_set_halign(fa_center);
            if (menu = 12) then draw_text_transformed(xx + 1262, yy + 70, string_hash_to_newline("Penitorium"), 0.6, 0.6, 0);
            if (menu = 12.1) then draw_text_transformed(xx + 1262, yy + 70, string_hash_to_newline("Scheduling Event"), 0.6, 0.6, 0);

            if (penitorium > 0) and(menu != 12.1) {
                draw_set_font(fnt_40k_14);
                draw_set_halign(fa_left);

                var behav = 0,
                    r_eta = 0,unit;

                for (var qp = 1; qp <= min(36, penitorium); qp++) {
                    unit = obj_ini.TTRPG[penit_co[qp]][penit_id[qp]];
                    if (unit.corruption > 0) then r_eta = round((unit.corruption * unit.corruption) / 50);
                    if (unit.corruption >= 90) then r_eta = "Never";
                    if (unit.corruption <= 0) then r_eta = "0";
                    draw_rectangle(xx + 947, yy + 100 + ((qp - 1) * 20), xx + 1577, yy + 100 + (qp * 20), 1);
                    draw_text(xx + 950, yy + 100 + ((qp - 1) * 20), string_hash_to_newline(unit.name_role()));
                    draw_text(xx + 1200, yy + 100 + ((qp - 1) * 20), string_hash_to_newline("ETA: " + string(r_eta)));
                    draw_text(xx + 1432, yy + 100 + ((qp - 1) * 20), string_hash_to_newline("[Execute]  [Release]"));
                }
            }
            draw_set_font(fnt_40k_14);
        }

        draw_set_font(fnt_40k_14);
        draw_set_alpha(1);
        draw_set_color(c_gray);

        if (menu_adept = 1) {
            blurp = "Your Chapter contains " + string(temp[36]) + " " + string(obj_ini.role[100, 14]) + "s.##";
            if (global.chapter_name != "Space Wolves") and(global.chapter_name != "Iron Hands") {
                blurp += "Training of further " + string(obj_ini.role[100, 14]) + "s";
                if (training_chaplain >= 0 && training_chaplain <= 6){
                    var _recruit_pace = ARR_recruitment_pace;
                    blurp += _recruit_pace[training_chaplain];
                }
                if (training_chaplain > 0) then blurp += "  The next " + string(obj_ini.role[100, 14]) + " is expected in " + string(eta) + " months.";
            }
        }

        draw_set_halign(fa_left);
        draw_text_ext(xx + 336 + 16, yy + 130, string_hash_to_newline(string(blurp)), -1, 536);

        draw_set_halign(fa_center);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_30b);
        draw_text_transformed(xx + 622, yy + 440, string_hash_to_newline("Chapter Revelry"), 0.6, 0.6, 0);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(fnt_40k_14);

        var blurp2 = "";
        // TODO rename fest_type and fest_scheduled into feast_type and feast_schedule and refactor scripts
        if (menu_adept = 0) {
            if (fest_scheduled = 0) {
                if (global.chapter_name != "Space Wolves") and(global.chapter_name != "Iron Hands") then blurp2 = "As our bolters are charged with death for the Emperor's enemies, our thoughts are charged with his wisdom.  As our bodies are armoured with Adamantium, our souls are protected with our loyalty- loyalty to Him, and loyalty to our brothers.  The bonds of this brotherhood are worth revering, even if a lull in duty invites doubt and heresy.  Should you wish to schedule a rousing event, or challenge, I will make it so.  Under the careful watch of our " + string(obj_ini.role[100, 14]) + "s, our brothers' spirits may be lifted.";
                if (global.chapter_name = "Space Wolves") then blurp2 = "";
                if (global.chapter_name = "Iron Hands") then blurp2 = "";
            }
            if (fest_scheduled = 1) {
                if (fest_type != "Chapter Relic") then blurp2 = "A " + string(fest_type) + " has been scheduled on ";
                if (fest_type = "Chapter Relic") then blurp2 = "Chapter Relic construction has been scheduled on ";

                if (fest_planet = 0) then blurp2 += string(obj_ini.ship[fest_sid]);
                if (fest_planet > 0) then blurp2 += string(fest_star) + " " + scr_roman(fest_wid);

                if (fest_honoring = 0) then blurp2 += ".  ";
                if (fest_honoring = 1) then blurp2 += " in your name.  ";
                // Specific company
                if (fest_honoring = 2) {
                    blurp2 += " in honor of the ";
                }
                if (fest_honoring = 3) {
                    blurp2 += " in honor of ";
                    blurp2 += string(obj_ini.role[fest_honor_co, fest_honor_id]) + " ";
                    blurp2 += string(obj_ini.name[fest_honor_co, fest_honor_id]) + " (" + romanNumerals[fest_honor_co] + " Company).  ";
                }
                if (fest_honoring = 4) { // faction
                    blurp2 += ", honoring ";
                }
                if (fest_honoring = 5) then blurp2 += ", giving praise to The Emperor.  ";
                if (fest_honoring = 6) then blurp2 += " to honor our chapter.  ";

                if (fest_lav <= 1) then blurp2 += "Very little requisiton has been set aside for the event";
                if (fest_lav = 2) then blurp2 += "A minor amount of requisition has been dedicated for the event";
                if (fest_lav = 3) then blurp2 += "Moderate expenses are being made for the event";
                if (fest_lav = 4) then blurp2 += "A great amount of requisiton is set aside for the event";
                if (fest_lav = 5) then blurp2 += "The event is set to be lavish and excessive, with maximum requisition spent";

                if (fest_repeats <= 1) then blurp2 += ".  It is set to run for " + string(fest_repeats) + " month.";
                if (fest_repeats > 1) then blurp2 += ".  It is set to run for " + string(fest_repeats) + " months.";

                if (fest_type = "Great Feast") {
                    if (fest_feature1 = 1) and(fest_feature2 + fest_feature3 = 0) then blurp2 += "  The feast will be made up entirely of a banquet.";
                    if (fest_feature1 = 1) and(fest_feature2 + fest_feature3 > 0) {
                        blurp2 += "  The feast will primarily be made up of a banquet, although ";
                        if (fest_feature2 + fest_feature3 = 2) then blurp2 += "drugs and alcohol will be present for those who wish to partake.";
                        if (fest_feature2 = 1) and(fest_feature3 = 0) then blurp2 += "alcohol will also be present.";
                        if (fest_feature2 = 0) and(fest_feature3 = 1) then blurp2 += "drugs will also be present.";
                    }
                    if (fest_feature1 = 0) {
                        if (fest_feature2 = 1) and(fest_feature3 = 0) then blurp2 = "  The feast will only be such in name, and actually primarily be composed of alcohol consumption and roudy behavior.";
                        if (fest_feature2 = 0) and(fest_feature3 = 1) then blurp2 = "  The feast will only be such in name, and actually primarily be composed of lines of drugs and roudy behavior.";
                    }
                }
                if (fest_type = "Tournament") {
                    if (fest_feature3 = 1) then blurp2 += "  Other Chapters have been invited to partake in the event, although it is not known who, if any, might show.";
                    if (fest_feature2 = 1) then blurp2 += "  Spectators are encouraged, with efforts made to keep attending simple.";
                }
                if (fest_type = "Deathmatch") {
                    if (fest_feature2 = 1) then blurp2 += "  Spectators are encouraged, with efforts made to keep attending simple.";
                    if (fest_feature3 = 1) then blurp2 += "  Smaller, similar deathmatches will be held for Imperial citizens who wish to partake.";
                }
                if (fest_type = "Chapter Relic") {
                    if (fest_feature1 = 1) then blurp2 += "  Our " + string(obj_ini.role[100, 16]) + "s aim to create a weapon.";
                    if (fest_feature2 = 1) then blurp2 += "  Our " + string(obj_ini.role[100, 16]) + "s aim to create a suit of armour.";
                    if (fest_feature3 = 1) then blurp2 += "  Our " + string(obj_ini.role[100, 16]) + "s aim to hone and strengthen an already existing relic.";
                }
                if (fest_type = "Imperial Mass") {
                    if (fest_feature2 = 1) then blurp2 += "  An Ecclesiarchy priest has been requested to lead the sermons.";
                    if (fest_feature3 = 1) then blurp2 += "  Adepta Sororita presence has been requested, to share in praising the Emperor.";
                }
                if (fest_type = "Chapter Sermon") {
                    if (fest_feature1 = 1) and(fest_feature2 + fest_feature3 = 0) then blurp2 += "  The Chapter Cult Sermon is pointedly sanctioned within the bounds of the Codex Astartes and Imperial tradition.";
                    if (fest_feature1 = 0) and(fest_feature2 + fest_feature3 = 0) then blurp2 += "  The Chapter Cult Sermon contains some radical or questionable practices, but such is allowed, as our traditions.";
                    if (fest_feature2 = 1) then blurp2 += "  Blood sacrifices are a primary focus with the sermon, celebrating martial prowess and our semi-divinity.";
                    if (fest_feature2 > 0) and(fest_feature3 = 1) then blurp2 += "  Drugs will also be present for the ceremony.";
                    if (fest_feature2 = 0) and(fest_feature3 > 1) then blurp2 += "  Mind-altering drugs will be a primary focus of the sermon.";
                }
                if (fest_type = "Triumphal March") {
                    if (fest_feature1 = 1) then blurp2 += "  Local Imperials will be required to attend our march- those that attempt to avoid our revelry are clearly heretics and will be dealt with as such.";
                    if (fest_feature2 = 1) then blurp2 += "  Cadences and battle cries will honor our closest allies, giving them due credit where it is needed.";
                    if (fest_feature3 = 1) then blurp2 += "  Bloody trophies of our conquests will be brandished to the populance.";
                }
            }
        }

        draw_text_ext(xx + 336 + 16, yy + 477, string_hash_to_newline(string(blurp2)), -1, 536);

        // draw_set_alpha(1);if (obj_controller.gene_seed<=0) or (obj_ini.zygote=1) then draw_set_alpha(0.5);

/*         if (menu = 12.1) or(fest_sid + fest_wid > 0) then draw_set_alpha(0.25);
        draw_set_color(c_gray);
        draw_rectangle(xx + 560, yy + 780, xx + 682, yy + 805, 0);
        draw_set_alpha(1);
        draw_set_color(c_black);
        draw_text(xx + 567, yy + 783, string_hash_to_newline("Schedule Event"));

        if (menu != 12.1) and(fest_sid + fest_wid = 0) and(mouse_x >= xx + 560) and(mouse_y >= yy + 780) and(mouse_x < xx + 682) and(mouse_y < yy + 805) {
            draw_set_alpha(0.2);
            draw_set_color(c_gray);
            draw_rectangle(xx + 560, yy + 780, xx + 682, yy + 805, 0);

            if (mouse_left = 1) and(cooldown <= 0) {
                menu = 12.1;
                var dro = 0;
                dro = instance_create(xx + 1064, yy + 124, obj_dropdown_sel);
                dro.target = "event_type";
                dro = instance_create(xx + 1100, yy + 183, obj_dropdown_sel);
                dro.target = "event_loc";
                dro.width = 186;
                dro = instance_create(xx + 1088, yy + 264, obj_dropdown_sel);
                dro.target = "event_lavish";
                dro = instance_create(xx + 1041, yy + 377, obj_dropdown_sel);
                dro.target = "event_display";
                dro = instance_create(xx + 1041, yy + 433, obj_dropdown_sel);
                dro.target = "event_repeat";
                dro = instance_create(xx + 1325, yy + 433, obj_dropdown_sel);
                dro.target = "event_honor";

                dro = instance_create(xx + 1325, yy + 525, obj_dropdown_sel);
                dro.target = "event_public";

                fest_type = "Great Feast";
                fest_star = "";
                fest_sid = 0;
                fest_wid = 0;

                fest_planet = (obj_ini.fleet_type == ePlayerBase.home_world) ? 1 : -1;

                fest_lav = 0;
                fest_locals = 0;
                fest_feature1 = 1;
                fest_feature2 = 0;
                fest_feature3 = 0;
                fest_display = 0;
                fest_repeats = 1;

            }
        } */
        draw_set_alpha(1);
        draw_set_font(fnt_40k_14);

        if (menu = 12.1) {
            var che, cx, cy;
            draw_set_font(fnt_40k_14b);
            draw_set_color(c_gray);
            draw_text_transformed(xx + 962, yy + 126, string_hash_to_newline("Event Type: "), 1, 1, 0);
            draw_text_transformed(xx + 962, yy + 185, string_hash_to_newline("Event Location: "), 1, 1, 0);
            draw_text_transformed(xx + 962, yy + 266, string_hash_to_newline("Grandoise: "), 1, 1, 0);
            draw_text_transformed(xx + 962, yy + 324, string_hash_to_newline("Features: "), 1, 1, 0);
            draw_text_transformed(xx + 962, yy + 379, string_hash_to_newline("Display: "), 1, 1, 0);

            draw_text_transformed(xx + 962, yy + 434, string_hash_to_newline("Repeat: "), 1, 1, 0);
            draw_text_transformed(xx + 1225, yy + 434, string_hash_to_newline("Honoring: "), 1, 1, 0);

            draw_text_transformed(xx + 962, yy + 527, string_hash_to_newline("Attendees: "), 1, 1, 0);
            draw_text_transformed(xx + 1246, yy + 527, string_hash_to_newline("Public: "), 1, 1, 0);

            draw_set_font(fnt_40k_14);

            // Attendees
            if (fest_attend != "") then draw_text_ext(xx + 962, yy + 550, string_hash_to_newline(string(fest_attend)), -1, 612);

            // Location type
            if (fest_planet != 1) then che = 1;
            if (fest_planet = 1) then che = 2;

            cx = xx + 990;
            cy = yy + 212;

            draw_text(cx, cy, string_hash_to_newline("Planet"));

            cx -= 35;
            cy -= 4;

            draw_sprite(spr_creation_check, che + 1, cx, cy);
            draw_set_alpha(1);
            // if (scr_hit(cx+31,cy,cx+260,cy+20)=true){tool1="Planet";tool2="Allows the use of vehicles, and bikes, but prevents this formation from being used during Raids.";}
            if (scr_hit(cx, cy, cx + 32, cy + 32) = true) and(mouse_left = 1) and(cooldown <= 0) and(dropdown_open = 0) {
                var onceh = 0;
                cooldown = 8000;
                if (onceh = 0) and((fest_planet = 0)) {
                    onceh = 1;
                    fest_planet = 1;
                    fest_sid = 0;
                    fest_wid = 0;
                    fest_star = "";
                    with(obj_dropdown_sel) {
                        if (target = "event_loc") then option[1] = "";
                    }
                }
            }
            if (fest_planet = 1) then che = 1;
            if (fest_planet = 0) then che = 2;
            if (fest_type = "Triumphal March") then draw_set_alpha(0.5);

            cx = xx + 1100;
            cy = yy + 212;

            draw_text(cx, cy, string_hash_to_newline("Ship"));

            cx -= 35;
            cy -= 4;

            draw_sprite(spr_creation_check, che + 1, cx, cy);
            draw_set_alpha(1);

            // if (scr_hit(cx+31,cy,cx+260,cy+20)=true){tool1="Planet";tool2="Allows the use of vehicles, and bikes, but prevents this formation from being used during Raids.";}
            if (scr_hit(cx, cy, cx + 32, cy + 32) = true) and(mouse_left = 1) and(cooldown <= 0) and(dropdown_open = 0) {
                var onceh = 0;
                cooldown = 8000;
                if (onceh = 0) and(fest_planet = 1) and(fest_type != "Triumphal March") {
                    onceh = 1;
                    fest_planet = 0;
                    fest_sid = 0;
                    fest_wid = 0;
                    fest_star = "";
                    with(obj_dropdown_sel) {
                        if (target = "event_loc") then option[1] = "";
                    }
                }
            }
            draw_set_alpha(1);

            // Features
            var fet_text = "",
                fet_scale = 1;

            if (fest_type = "Great Feast") then fet_text = "Banquet";
            if (fest_type = "Tournament") then fet_text = "Internal";
            if (fest_type = "Deathmatch") then fet_text = "Chapter Only";
            if (fest_type = "Chapter Relic") then fet_text = "Create Wargear";
            if (fest_type = "Chapter Sermon") then fet_text = "Sanctioned";
            if (fest_type = "Imperial Mass") {
                fet_text = "Local";
                fet_scale = 1;
            }
            if (fest_type = "Triumphal March") {
                fet_text = "Mandatory Attendance";
                fet_scale = 0.7;
            }

            if (fest_feature1 = 0) then che = 1;
            if (fest_feature1 = 1) then che = 2;

            cx = xx + 1068 + 22;
            cy = yy + 326;

            draw_text_transformed(cx, cy, string_hash_to_newline(string(fet_text)), fet_scale, 1, 0);

            cx -= 35;
            cy -= 4;

            draw_sprite(spr_creation_check, che + 1, cx, cy);
            draw_set_alpha(1);
            // if (scr_hit(cx+31,cy,cx+260,cy+20)=true){tool1="Planet";tool2="Allows the use of vehicles, and bikes, but prevents this formation from being used during Raids.";}
            if (scr_hit(cx, cy, cx + 32, cy + 32) = true) and(mouse_left = 1) and(cooldown <= 0) and(dropdown_open = 0) {
                var onceh = 0;
                cooldown = 8000;
                if (fest_type = "Tournament") or(fest_type = "Deathmatch") then onceh = 1;
                if (onceh = 0) and(fest_feature1 = 0) {
                    onceh = 1;
                    fest_feature1 = 1;
                }
                if (onceh = 0) and(fest_feature1 = 1) and(fest_type != "Chapter Relic") {
                    onceh = 1;
                    fest_feature1 = 0;
                }
                if (fest_type = "Chapter Relic") and(fest_feature1 = 1) {
                    fest_feature3 = 0;
                    fest_feature2 = 0;
                }
            }
            if (fest_type = "Tournament") or(fest_type = "Deathmatch") and(fest_feature1 = 0) then fest_feature1 = 1;

            if (fest_type = "Great Feast") then fet_text = "Alcohol";
            if (fest_type = "Tournament") then fet_text = "Spectators";
            if (fest_type = "Deathmatch") then fet_text = "Spectators";
            if (fest_type = "Chapter Relic") then fet_text = "Create Armour";
            if (fest_type = "Imperial Mass") {
                fet_text = "Request Ecclesiarchy";
                fet_scale = 0.75;
            }
            if (fest_type = "Chapter Sermon") {
                fet_text = "Blood Sacrifices";
                fet_scale = 0.75;
            }
            if (fest_type = "Triumphal March") {
                fet_text = "Honor to Allies";
                fet_scale = 0.75;
            }

            if (fest_feature2 = 0) then che = 1;
            if (fest_feature2 = 1) then che = 2;
            if (fest_type = "Imperial Mass") and(known[5] = 0) then draw_set_alpha(0.5);

            cx = xx + 1228 + 22;
            cy = yy + 326;

            draw_text_transformed(cx, cy, string_hash_to_newline(string(fet_text)), fet_scale, 1, 0);
            cx -= 35;
            cy -= 4;
            draw_sprite(spr_creation_check, che + 1, cx, cy);
            draw_set_alpha(1);
            // if (scr_hit(cx+31,cy,cx+260,cy+20)=true){tool1="Planet";tool2="Allows the use of vehicles, and bikes, but prevents this formation from being used during Raids.";}
            if (scr_hit(cx, cy, cx + 32, cy + 32) = true) and(mouse_left = 1) and(cooldown <= 0) and(dropdown_open = 0) {
                var onceh = 0;
                cooldown = 8000;
                if (fest_type = "Imperial Mass") and(known[5] = 0) then onceh = 1;
                if (onceh = 0) and(fest_feature2 = 0) {
                    onceh = 1;
                    fest_feature2 = 1;
                }
                if (onceh = 0) and(fest_feature2 = 1) and(fest_type != "Chapter Relic") {
                    onceh = 1;
                    fest_feature2 = 0;
                }
                if (fest_type = "Chapter Relic") and(fest_feature2 = 1) {
                    fest_feature1 = 0;
                    fest_feature3 = 0;
                }
            }

            if (fest_type = "Great Feast") then fet_text = "Drugs";
            if (fest_type = "Chapter Relic") then fet_text = "Upgrade Existing";
            if (fest_type = "Chapter Sermon") then fet_text = "Drugs";
            if (fest_type = "Tournament") {
                fet_text = "Invite Other Chapters";
                fet_scale = 0.75;
            }
            if (fest_type = "Deathmatch") {
                fet_text = "Allow Other Competitors";
                fet_scale = 0.7;
            }
            if (fest_type = "Imperial Mass") {
                fet_text = "Request Sororitas";
                fet_scale = 0.75;
            }
            if (fest_type = "Triumphal March") {
                fet_text = "Brandish Bloody Trophies";
                fet_scale = 0.6;
            }

            if (fest_feature3 = 0) then che = 1;
            if (fest_feature3 = 1) then che = 2;
            if (fest_type = "Imperial Mass") and(known[5] = 0) then draw_set_alpha(0.5);

            cx = xx + 1388 + 22;
            cy = yy + 326;

            draw_text_transformed(cx, cy, string_hash_to_newline(string(fet_text)), fet_scale, 1, 0);
            cx -= 35;
            cy -= 4;
            draw_sprite(spr_creation_check, che + 1, cx, cy);
            draw_set_alpha(1);
            // if (scr_hit(cx+31,cy,cx+260,cy+20)=true){tool1="Planet";tool2="Allows the use of vehicles, and bikes, but prevents this formation from being used during Raids.";}
            if (scr_hit(cx, cy, cx + 32, cy + 32) = true) and(mouse_left = 1) and(cooldown <= 0) and(dropdown_open = 0) {
                var onceh = 0;
                cooldown = 8000;
                if (fest_type = "Imperial Mass") and(known[5] = 0) then onceh = 1;
                if (onceh = 0) and(fest_feature3 = 0) {
                    onceh = 1;
                    fest_feature3 = 1;
                }
                if (onceh = 0) and(fest_feature3 = 1) and(fest_type != "Chapter Relic") {
                    onceh = 1;
                    fest_feature3 = 0;
                }
                if (fest_type = "Chapter Relic") and(fest_feature3 = 1) {
                    fest_feature1 = 0;
                    fest_feature2 = 0;
                }
            }

            // Always at least one feature
            if (fest_type != "Triumphal March") and(fest_type != "Chapter Sermon") {
                if (fest_feature1 = 0) and(fest_feature2 = 0) and(fest_feature3 = 0) then fest_feature1 = 1;
            }

            // TODO Attendants 
            if (fest_attend = "") and((fest_wid > 0) or(fest_sid > 0)) {
                // determine attendants
            }

            draw_set_font(fnt_40k_14);

            var doable;
            doable = true;
            if (requisition < fest_cost) then doable = false;
            if (fest_wid = 0) and(fest_sid = 0) then doable = false;

            // Accept
            draw_set_halign(fa_left);
            draw_set_alpha(1);
            draw_set_color(c_gray);

            if (doable = false) then draw_set_alpha(0.5);

            draw_rectangle(xx + 1302, yy + 780, xx + 1433, yy + 805, 0);
            draw_set_alpha(1);
            draw_set_color(c_black);
            draw_text(xx + 1305, yy + 784, string_hash_to_newline("Schedule"));

            draw_sprite_ext(spr_requisition, 0, xx + 1374, yy + 787, 1, 1, 0, c_white, 1);
            draw_set_color(c_blue);
            // draw_set_color(16291875);

            if (requisition < fest_cost) then draw_set_color(c_red);
            draw_text(xx + 1388, yy + 784, string_hash_to_newline(string(fest_cost)));
            if (scr_hit(xx + 1302, yy + 780, xx + 1423, yy + 805) = true) and(doable = true) {
                draw_set_color(c_white);
                draw_set_alpha(0.2);
                draw_rectangle(xx + 1302, yy + 780, xx + 1433, yy + 805, 0);

                if (mouse_left = 1) and(cooldown <= 0) {
                    requisition -= fest_cost;
                    fest_scheduled = 1;
                    cooldown = 6000;
                    menu = 12;
                    with(obj_dropdown_sel) {
                        instance_destroy();
                    }
                    if (fest_repeats = 0) then fest_repeats = 1;
                    if (fest_display > 0) then fest_display_tags = obj_ini.artifact_tags[fest_display];

                    // show_message(string(fest_display));
                    // show_message(string(fest_display_tags));

                }
            }

            // Cancel
            draw_set_halign(fa_center);
            draw_set_alpha(1);
            draw_set_color(c_gray);
            draw_rectangle(xx + 1132, yy + 780, xx + 1253, yy + 805, 0);
            draw_set_color(c_black);
            draw_text(xx + 1192, yy + 783, string_hash_to_newline("Cancel"));
            if (scr_hit(xx + 1132, yy + 780, xx + 1253, yy + 805) = true) {
                draw_set_color(c_white);
                draw_set_alpha(0.2);
                draw_rectangle(xx + 1132, yy + 780, xx + 1253, yy + 805, 0);
                if (mouse_left = 1) and(cooldown <= 0) {
                    cooldown = 20;
                    fest_type = "";
                    fest_sid = 0;
                    fest_wid = 0;
                    fest_planet = 0;
                    fest_star = "";
                    fest_lav = 0;
                    fest_locals = 0;
                    fest_feature1 = 0;
                    fest_feature2 = 0;
                    fest_attend = "";
                    fest_feature3 = 0;
                    fest_display = 0;
                    fest_repeats = 0;
                    fest_warp = 0;
                    menu = 12;
                    with(obj_dropdown_sel) {
                        instance_destroy();
                    }
                }
            }
            draw_set_halign(fa_left);
            draw_set_alpha(1);
        }
    }

    // ** Librarium **
    if (menu == 13) {
       scr_librarium();
    }

    // ** Armamentarium **
    else if (menu == 14) {
        scr_draw_armentarium();
    }else  if (menu == 15) {// **recruiting**
        scr_draw_recruit_advisor();
    }

    // *** Fleet advisor was here ***

    // ** Chapter Master **
    if (menu = 50) {
        draw_set_color(0);
        draw_sprite(spr_solid_bg, 0, xx, yy);
        draw_sprite(spr_master_splash, 0, xx, yy);

        draw_rectangle(xx + 213, yy + 25, xx + 622, yy + 78, 0);

        draw_set_halign(fa_center);
        draw_set_color(38144);
        draw_line(xx + 213, yy, xx + 213, yy + 640);
        draw_rectangle(xx + 213, yy + 25, xx + 622, yy + 78, 1);

        draw_set_color(0);
        draw_rectangle(xx + 217, yy + 82, xx + 617, yy + 188, 0);
        draw_rectangle(xx + 217, yy + 199, xx + 617, yy + 367, 0);
        draw_rectangle(xx + 217, yy + 380, xx + 617, yy + 411, 0);

        draw_set_color(38144);
        draw_rectangle(xx + 217, yy + 82, xx + 617, yy + 188, 1);
        draw_rectangle(xx + 217, yy + 199, xx + 617, yy + 367, 1);
        draw_rectangle(xx + 217, yy + 380, xx + 617, yy + 411, 1);

        draw_set_font(fnt_large);
        draw_text_transformed(xx + 410, yy + 29, "Chapter Master", 0.5, 0.5, 0);

        draw_set_font(fnt_fancy);
        draw_text_transformed(xx + 410, yy + 40, string_hash_to_newline(string(obj_ini.master_name)), 1.5, 1.5, 0);
        draw_set_font(fnt_small);
        draw_set_halign(fa_left);

        var eqp = "",
            tempe = "";
			
        draw_text(xx + 222, yy + 83, "Equipment:");
        draw_text(xx + 222.5, yy + 83.5, "Equipment:");

        draw_set_font(fnt_tiny);
        draw_text_ext(xx + 222, yy + 99, string_hash_to_newline(string(eqp)), -1, 396);

        draw_set_font(fnt_small);
        draw_text(xx + 222, yy + 200, "Kills:");
        draw_text(xx + 222.5, yy + 200.5, "Kills:");


        draw_text_ext(xx + 222, yy + 216, string_hash_to_newline(string(tot_ki)), -1, 396);
        var unit = fetch_unit([0,1]);
        if (unit.ship_location == -1) then draw_text(xx + 222, yy + 380, string_hash_to_newline("Current Location: " + string(obj_ini.loc[0, 1]) + " " + string(unit.planet_location) + "#Health: " + unit.hp() + "%"));
        if (unit.ship_location>-1) then draw_text(xx + 222, yy + 380, string_hash_to_newline($"Current Location: Onboard {obj_ini.ship[unit.ship_location]}#Health: {unit.hp()}%"));
        draw_text(xx + 222.5, yy + 380.5, string_hash_to_newline("Current Location:#Health:"));

        draw_sprite(spr_arrow, 0, xx + 217, yy + 32);
    }

    // ** Welcome menu **
    if (menu >= 500 && menu <= 510) {
        draw_sprite(spr_welcome_bg, 0, xx, yy);
        // draw_sprite(spr_advisors,0,xx+16,yy+16);
        scr_image("advisor/splash", 1, xx + 16, yy + 16, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(0);
        draw_set_font(fnt_40k_14);

        if (menu = 500) then draw_text_ext(xx + 370, yy + 72, string_hash_to_newline(string(temp[65])), -1, 660);
        if (menu = 501) then draw_text_ext(xx + 370, yy + 72, string_hash_to_newline(string(temp[66])), -1, 660);
        if (menu = 502) then draw_text_ext(xx + 370, yy + 72, string_hash_to_newline(string(temp[67])), -1, 660);
        if (menu = 503) then draw_text_ext(xx + 370, yy + 72, string_hash_to_newline(string(temp[68])), -1, 660);
        draw_set_halign(fa_center);
        draw_text(xx + 702, yy + 695, $"{menu - 499} (Press Any Key)");
        draw_set_halign(fa_left);

    }

    if (menu = 1) and(managing = 0) {
        draw_set_alpha(1);
        draw_sprite(spr_rock_bg, 0, xx, yy);
        draw_set_font(fnt_40k_30b);
        draw_set_halign(fa_center);
        draw_set_color(c_gray);
        draw_text(xx + 800, yy + 74, string_hash_to_newline(string(global.chapter_name) + " Chapter Organization"));
    }
}