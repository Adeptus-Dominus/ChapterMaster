function scr_ui_reclusiam(){
    var romanNumerals = scr_roman_numerals();
    var xx = camera_get_view_x(view_camera[0]);
    var yy = camera_get_view_y(view_camera[0]);
    var blurp = "";
    var eta = 0;
    draw_sprite(spr_rock_bg, 0, xx, yy);

    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 342, yy + 66, xx + 903, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 342, yy + 66, xx + 903, yy + 818, 1);
    draw_line(xx + 342, yy + 426, xx + 903, yy + 426);

    draw_set_alpha(0.75);
    draw_set_color(0);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 0);
    draw_set_alpha(1);
    draw_set_color(c_gray);
    draw_rectangle(xx + 945, yy + 66, xx + 1580, yy + 818, 1);

    var _head = get_department_head(eCHAPTER_DEPARTMENTS.CHAP);

    var _has_head = is_struct(_head);
    if (_has_head) {
        if (struct_exists(obj_ini.custom_advisors, "chaplain")) {
            scr_image("advisor/splash", obj_ini.custom_advisors.chaplain, xx + 16, yy + 43, 310, 828);
        } else {
            scr_image("advisor/splash", 3, xx + 16, yy + 43, 310, 828);
        }
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(cjk_font(fnt_40k_30b));
        draw_text_transformed(xx + 336 + 16, yy + 66, localize("Reclusium"), 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, localized_name_role(_head), 0.6, 0.6, 0);
    } else {
        scr_image("advisor/splash", 1, xx + 16, yy + 43, 310, 828);
        draw_set_halign(fa_left);
        draw_set_color(c_gray);
        draw_set_font(cjk_font(fnt_40k_30b));
        draw_text_transformed(xx + 336 + 16, yy + 66, localize("Reclusium"), 1, 1, 0);
        draw_text_transformed(xx + 336 + 16, yy + 100, localize("Adept {0}", [obj_controller.adept_name]), 0.6, 0.6, 0);
    }

    draw_set_font(cjk_font(fnt_40k_14));
    draw_set_alpha(1);
    draw_set_color(c_gray);
    var _active_roles = active_roles();
    var _chap_role = reclusiam_vars.chaplain_role;
    var _chap_count = reclusiam_vars.chapter_chaplains.number();
    penitorium = array_length(jailed_marines);
    if (_chap_count > 0) {
        blurp = localize("Sir!  You requested a report?  Currently, we have deployed {0} {1}s to watch over the health of our Battle-Brothers in the field.  We have an additional {2} {1}s who await only your order to carry the word to the troops.", [_chap_count, localize(_chap_role), 0]);
    }
    if (_chap_count == 0) {
        blurp = localize("Sir!  You requested a report?  Currently, we have {0} {1}s who await only your order to carry the word to the troops.", [0, localize(_chap_role)]);
    }
    if (!scr_has_adv_any(["Tech-Cult Religion", "Spiritual Healers"])) {
        blurp += localize("##Currently, we are training additional {0} at a ", [localize(_chap_role)]);
        var _recruit_rates = global.recruitment_rates;
        blurp += localize(_recruit_rates[training_chaplain]);
        if (training_chaplain > 0 && training_chaplain <= 6) {
            var training_points_values = global.chaplain_training_tiers;
            eta = floor((47 - chaplain_points) / training_points_values[training_chaplain]) + 1;
        }
        blurp += localize(" rate");
        if (training_chaplain > 0) {
            blurp += localize(" and expect to see a new one in {0} month's time.", [eta]);
        }
        if (training_chaplain < 5) {
            blurp += localize("We can increase this rate, but it will require us to requisition additional facilities, as well as upkeep, Sir.");
        }
        if (penitorium == 0) {
            blurp += localize("##Our men have been behaving as they should.  Not a single one is scheduled for corrective action of any type.");
        }
    }

    draw_set_font(cjk_font(fnt_40k_30b));
    draw_set_halign(fa_center);
    draw_text_transformed(xx + 1262, yy + 70, localize("Penitorium"), 0.6, 0.6, 0);

    if (penitorium > 0) {
        draw_set_font(cjk_font(fnt_40k_14));
        draw_set_halign(fa_left);

        var _stop = min(35, penitorium);
        for (var qp = 0; qp < _stop; qp++) {
            var _unit = jailed_marines[qp];
            if (!is_struct(_unit)) {
                continue;
            }
            var r_eta = "";
            if (_unit.corruption > 0) {
                r_eta = string(round((_unit.corruption * _unit.corruption) / 50));
                if (_unit.corruption >= 90) {
                    r_eta = localize("Never");
                }
            } else if (_unit.corruption <= 0) {
                r_eta = "0";
            }
            var _y = 100 + (qp * 20)
            draw_rectangle(xx + 947, yy +  (_y), xx + 1577, yy +  _y, 1);
            draw_text(xx + 950, yy +  (_y), localized_name_role(_unit));
            draw_text(xx + 1200, yy +  (_y), localize("ETA: {0}", [r_eta]));
            var _delete_entry = false;
            var _execute_button = draw_unit_buttons([xx + 1432, yy +  _y],"[Execute]", [0.6, 0.6], c_red);
            if (point_and_click(_execute_button)){
                if (_unit.role() == obj_ini.player_role_data[eROLE.CHAPTERMASTER].role) {
                    alarm[7] = 5;
                    global.defeat = 3;
                }
                _unit.kill();
                _delete_entry = true;           
            }

            var _release_button = draw_unit_buttons([_execute_button[2], _execute_button[1]],"[Release]", [0.6, 0.6], CM_GREEN_COLOR);
    
            if (point_and_click(_release_button)){
                _unit.god_status -= 10;
                _delete_entry = true;                         
            }
            if (_delete_entry){
                array_delete(jailed_marines, qp, 1);
                qp--;
                _stop--;
            }

        }
    }
    draw_set_font(cjk_font(fnt_40k_14));


    draw_set_font(cjk_font(fnt_40k_14));
    draw_set_alpha(1);
    draw_set_color(c_gray);

    if (menu_adept == 1) {
        blurp = localize("Your Chapter contains {0} {1}s.##", [_chap_count, localize(_chap_role)]);
        if (!scr_has_adv_any(["Tech-Cult Religion", "Spiritual Healers"])) {
            blurp += localize("Training of further {0}s", [localize(_chap_role)]);
            if (training_chaplain >= 0 && training_chaplain <= 6) {
                var _recruit_pace = global.recruitment_pace_descriptions;
                blurp += localize(_recruit_pace[training_chaplain]);
            }
            if (training_chaplain > 0) {
                blurp += localize("  The next {0} is expected in {1} months.", [localize(_chap_role), eta]);
            }
        }
    }

    draw_set_halign(fa_left);
    draw_text_ext(xx + 336 + 16, yy + 130, string_hash_to_newline(string(blurp)), -1, 536);

    draw_set_halign(fa_center);
    draw_set_color(c_gray);
    draw_set_font(cjk_font(fnt_40k_30b));
    draw_text_transformed(xx + 622, yy + 440, localize("Chapter Revelry"), 0.6, 0.6, 0);
    draw_set_halign(fa_left);
    draw_set_color(c_gray);
    draw_set_font(cjk_font(fnt_40k_14));

    var blurp2 = "";
    // TODO rename fest_type and fest_scheduled into feast_type and feast_schedule and refactor scripts
    if (menu_adept == 0) {
        if (fest_scheduled == 0) {
            if (!scr_has_adv_any(["Tech-Cult Religion", "Spiritual Healers"])) {
                blurp2 = localize("As our bolters are charged with death for the Emperor's enemies, our thoughts are charged with his wisdom.  As our bodies are armoured with Adamantium, our souls are protected with our loyalty- loyalty to Him, and loyalty to our brothers.  The bonds of this brotherhood are worth revering, even if a lull in duty invites doubt and heresy.  Should you wish to schedule a rousing event, or challenge, I will make it so.  Under the careful watch of our {0}s, our brothers' spirits may be lifted.", [localize(_chap_role)]);
            }
            if (reclusiam_vars.spiritual_healers) {
                blurp2 = "";
            }
            if (global.chapter_name == "Iron Hands") {
                blurp2 = "";
            }
        }
        if (fest_scheduled == 1) {
            if (fest_type != "Chapter Relic") {
                blurp2 = localize("A {0} has been scheduled on ", [localize(fest_type)]);
            }
            if (fest_type == "Chapter Relic") {
                blurp2 = localize("Chapter Relic construction has been scheduled on ");
            }

            if (fest_planet == 0) {
                blurp2 += string(obj_ini.ship[fest_sid]);
            }
            if (fest_planet > 0) {
                blurp2 += string(fest_star) + " " + scr_roman(fest_wid);
            }

            if (fest_honoring == 0) {
                blurp2 += localize(".  ");
            }
            if (fest_honoring == 1) {
                blurp2 += localize(" in your name.  ");
            }
            // Specific company
            if (fest_honoring == 2) {
                blurp2 += localize(" in honor of the ");
            }
            if (fest_honoring == 3) {
                blurp2 += localize(" in honor of ");
                var _unit = fetch_unit([fest_honor_co, fest_honor_id]);
                blurp2 += $"{localize(_unit.role())} ";
                blurp2 += localize("{0} {1} Company).  ", [_unit.name(), romanNumerals[fest_honor_co]]);
            }
            if (fest_honoring == 4) {
                // faction
                blurp2 += localize(", honoring ");
            }
            if (fest_honoring == 5) {
                blurp2 += localize(", giving praise to The Emperor.  ");
            }
            if (fest_honoring == 6) {
                blurp2 += localize(" to honor our chapter.  ");
            }

            if (fest_lav <= 1) {
                blurp2 += localize("Very little requisiton has been set aside for the event");
            }
            if (fest_lav == 2) {
                blurp2 += localize("A minor amount of requisition has been dedicated for the event");
            }
            if (fest_lav == 3) {
                blurp2 += localize("Moderate expenses are being made for the event");
            }
            if (fest_lav == 4) {
                blurp2 += localize("A great amount of requisiton is set aside for the event");
            }
            if (fest_lav == 5) {
                blurp2 += localize("The event is set to be lavish and excessive, with maximum requisition spent");
            }

            if (fest_repeats <= 1) {
                blurp2 += localize(".  It is set to run for {0} month.", [fest_repeats]);
            }
            if (fest_repeats > 1) {
                blurp2 += localize(".  It is set to run for {0} months.", [fest_repeats]);
            }

            if (fest_type == "Great Feast") {
                if ((fest_feature1 == 1) && (fest_feature2 + fest_feature3 == 0)) {
                    blurp2 += localize("  The feast will be made up entirely of a banquet.");
                }
                if ((fest_feature1 == 1) && (fest_feature2 + fest_feature3 > 0)) {
                    blurp2 += localize("  The feast will primarily be made up of a banquet, although ");
                    if (fest_feature2 + fest_feature3 == 2) {
                        blurp2 += localize("drugs and alcohol will be present for those who wish to partake.");
                    }
                    if ((fest_feature2 == 1) && (fest_feature3 == 0)) {
                        blurp2 += localize("alcohol will also be present.");
                    }
                    if ((fest_feature2 == 0) && (fest_feature3 == 1)) {
                        blurp2 += localize("drugs will also be present.");
                    }
                }
                if (fest_feature1 == 0) {
                    if ((fest_feature2 == 1) && (fest_feature3 == 0)) {
                        blurp2 = localize("  The feast will only be such in name, and actually primarily be composed of alcohol consumption and roudy behavior.");
                    }
                    if ((fest_feature2 == 0) && (fest_feature3 == 1)) {
                        blurp2 = localize("  The feast will only be such in name, and actually primarily be composed of lines of drugs and roudy behavior.");
                    }
                }
            }
            if (fest_type == "Tournament") {
                if (fest_feature3 == 1) {
                    blurp2 += localize("  Other Chapters have been invited to partake in the event, although it is not known who, if any, might show.");
                }
                if (fest_feature2 == 1) {
                    blurp2 += localize("  Spectators are encouraged, with efforts made to keep attending simple.");
                }
            }
            if (fest_type == "Deathmatch") {
                if (fest_feature2 == 1) {
                    blurp2 += localize("  Spectators are encouraged, with efforts made to keep attending simple.");
                }
                if (fest_feature3 == 1) {
                    blurp2 += localize("  Smaller, similar deathmatches will be held for Imperial citizens who wish to partake.");
                }
            }
            if (fest_type == "Chapter Relic") {
                if (fest_feature1 == 1) {
                    blurp2 += localize("  Our {0}s aim to create a weapon.", [localize(obj_ini.player_role_data[eROLE.TECHMARINE].role)]);
                }
                if (fest_feature2 == 1) {
                    blurp2 += localize("  Our {0}s aim to create a suit of armour.", [localize(obj_ini.player_role_data[eROLE.TECHMARINE].role)]);
                }
                if (fest_feature3 == 1) {
                    blurp2 += localize("  Our {0}s aim to hone and strengthen an already existing relic.", [localize(obj_ini.player_role_data[eROLE.TECHMARINE].role)]);
                }
            }
            if (fest_type == "Imperial Mass") {
                if (fest_feature2 == 1) {
                    blurp2 += localize("  An Ecclesiarchy priest has been requested to lead the sermons.");
                }
                if (fest_feature3 == 1) {
                    blurp2 += localize("  Adepta Sororita presence has been requested, to share in praising the Emperor.");
                }
            }
            if (fest_type == "Chapter Sermon") {
                if ((fest_feature1 == 1) && (fest_feature2 + fest_feature3 == 0)) {
                    blurp2 += localize("  The Chapter Cult Sermon is pointedly sanctioned within the bounds of the Codex Astartes and Imperial tradition.");
                }
                if ((fest_feature1 == 0) && (fest_feature2 + fest_feature3 == 0)) {
                    blurp2 += localize("  The Chapter Cult Sermon contains some radical or questionable practices, but such is allowed, as our traditions.");
                }
                if (fest_feature2 == 1) {
                    blurp2 += localize("  Blood sacrifices are a primary focus with the sermon, celebrating martial prowess and our semi-divinity.");
                }
                if ((fest_feature2 > 0) && (fest_feature3 == 1)) {
                    blurp2 += localize("  Drugs will also be present for the ceremony.");
                }
                if ((fest_feature2 == 0) && (fest_feature3 > 1)) {
                    blurp2 += localize("  Mind-altering drugs will be a primary focus of the sermon.");
                }
            }
            if (fest_type == "Triumphal March") {
                if (fest_feature1 == 1) {
                    blurp2 += localize("  Local Imperials will be required to attend our march- those that attempt to avoid our revelry are clearly heretics and will be dealt with as such.");
                }
                if (fest_feature2 == 1) {
                    blurp2 += localize("  Cadences and battle cries will honor our closest allies, giving them due credit where it is needed.");
                }
                if (fest_feature3 == 1) {
                    blurp2 += localize("  Bloody trophies of our conquests will be brandished to the populance.");
                }
            }
        }
    }

    draw_text_ext(xx + 336 + 16, yy + 477, string_hash_to_newline(string(blurp2)), -1, 536);

    draw_set_alpha(1);
    draw_set_font(cjk_font(fnt_40k_14));
}

    