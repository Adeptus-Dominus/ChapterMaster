

function meet_faction_head(_faction, _dialogue = "intro", _audience_data = {}, _handler_settings = {}){
    scr_toggle_diplomacy();
    with (obj_controller.diplo_helper){
        move_data_to_current_scope(_handler_settings);
        setup_faction_head_meeting(_faction, _dialogue, _audience_data);
        audience = true;
    }
}

function meet_character(_character){
    scr_toggle_diplomacy();
    with (obj_controller.diplo_helper){
        character_diplomacy = _character;
        setup_faction_head_meeting(_faction, _dialogue, _audience_data);
    }    
}
function DiplomacyHandler() constructor {
    set_up_diplomacy_buttons();
    trading = false;
    faction_engaged = eFACTION.NONE;
    force_goodbye = true;
    faction_justmet = false;
    audience = false;
    audience_data = {};
    diplo_options = [];
    diplomacy_pathway = "";
    diplo_text = "";
    diplo_text_displayed = "";
    diplo_last = "";
    diplo_char = 0;
    diplo_text_alpha = 0;

    diag_variables = {};

    static clear_diplo_choices = function() {
        obj_controller.diplo_helper.diplo_options = [];
    }

    static __setup_dialogue_variables(){
        diag_variables = {
            faction_leader: faction_leader[faction_engaged],
            sector: obj_ini.sector_name,
            relationship: rela,
            annoyed: annoyed[faction_engaged],
            turns_ignored: turns_ignored[faction_engaged],
            chapter_name: global.chapter_name,
            master_name: obj_ini.master_name,
            faction_status: obj_controller.faction_status[faction_engaged],
        };
    }
    static setup_faction_head_meeting = function(_faction, _dialogue = "intro", _audience_data = {}){
        self.audience_data = _audience_data;
        faction_engaged = _faction;
        if ((faction_engaged == eFACTION.CHAOS) && (obj_controller.faction_gender[eFACTION.CHAOS] == 2)) {
            global.audio_manager.play_playlist(CONTEXT_DIPLOMACY, 60);
        }
        __setup_dialogue_variables();

        if (string_count("intro", _dialogue) > 0) {
            obj_controller.known[faction_engaged] = 2;
            faction_justmet = 1;
            if (faction_engaged == 6) {
                scr_dialogue("intro1");
            }
            scr_dialogue(_dialogue);
        } else {
            scr_dialogue(_dialogue);
        }
    }

    static  draw_character_diplomacy_base_page = function() {
        menu_lock = true;
        if (!audience && !valid_diplomacy_options()) {
            with (diplo_buttons) {
                trade.draw();
                demand.draw();
                discuss.draw();
                alliance.draw();
                denounce.draw();
                praise.draw();
                declare_war.draw_shutter(praise.x1, alliance.y2, localize("WAR"), 0.4);
            }
        } else {
            if (!valid_diplomacy_options()) {
                diplo_buttons.denounce.draw();
                diplo_buttons.praise.draw();
            }
        }
        if (!valid_diplomacy_options() || force_goodbye) {
            diplo_buttons.exit_button.draw();
        }
    }


    static __main_faction_head_diplomacy = function(){
        draw_diplomacy_diplo_text();
        if (trading) {
            if ((faction_engaged > eFACTION.PLAYER) && is_struct(trade_attempt)) {
                try {
                    trade_attempt.draw_trade_screen();
                } catch (_exception) {
                    ERROR_HANDLER.handle_exception(_exception);
                    delete trade_attempt;
                    trading = false;
                }
            }
        } else if (faction_engaged != eFACTION.CHAOS + 0.1) {
            draw_character_diplomacy_base_page();
        }
    }

    static step() = function(){
        if (faction_engaged == 0) {
            if (trading_artifact != 0) {
                with (obj_ground_mission) {
                    instance_destroy();
                }
                trading_artifact = 0;
            }
        }

        if ((trading_artifact == eFACTION.NONE) && (!trading) && (!trading_artifact) && (faction_justmet) && (!questing) && (!trading_demand) && (complex_event == false)) {
            clear_diplo_choices();
        }     
    }
    static draw_gui = function(){
        add_draw_return_values();
        // Draw GUI event: coordinates are GUI-space, so no camera offsets
        var xx = 6;
        var yy = 0;
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var show_stuff = false;
        var warning = 0;

        // This script draws all of the faction_engaged stuff, up to and including trading.

        draw_set_alpha(1);
        draw_set_color(c_black);
        draw_rectangle(xx, yy, xx + 1600, yy + 900, 0);
        draw_set_alpha(0.5);
        draw_sprite(spr_rock_bg, 0, xx, yy);
        draw_set_alpha(1);
        try {
            if (faction_engaged > eFACTION.NONE) {
                // Diplomacy - Speaking
                var _daemon = false;
                if ((faction_engaged > eFACTION.CHAOS) && (faction_engaged < 11)) {
                    _daemon = true;
                }
                if (faction_engaged == eFACTION.CHAOS + 0.1) {
                    _daemon = true;
                    scr_image("diplomacy_daemon", 0, xx + 16, yy + 43, 310, 828);
                    show_stuff = false;
                    if (point_in_rectangle(_mx, _my, 360, 143, 884, 180)) {
                        warning = 1;
                    }
                }

                if (!_daemon) {
                    if (faction_engaged != eFACTION.ELDAR) {
                        scr_image("faction_engaged/splash", faction_engaged, xx + 16, yy + 43, 310, 828);
                    }
                    if ((faction_engaged != eFACTION.ELDAR) || ((faction_engaged == eFACTION.ELDAR) && (faction_gender[eFACTION.ELDAR] == 1))) {
                        scr_image("faction_engaged/splash", faction_engaged, xx + 16, yy + 16, 310, 828);
                    }
                    if ((faction_engaged == eFACTION.ELDAR) && (faction_gender[eFACTION.ELDAR] == 2)) {
                        scr_image("faction_engaged/splash", 11, xx + 16, yy + 16, 310, 828);
                    }
                    if ((faction_engaged == eFACTION.CHAOS) && (faction_gender[eFACTION.CHAOS] == 2)) {
                        scr_image("faction_engaged/splash", 12, xx + 16, yy + 43, 310, 828);
                    }
                }

                draw_set_halign(fa_center);
                draw_set_color(CM_GREEN_COLOR);
                draw_set_font(cjk_font(fnt_40k_30b));

                var _diplomacy_faction_name = "";
                var _diplomacy_faction_alligience = " (Imperium)";
                var _disposition_rating = "";

                if (faction_engaged >= 6) {
                    _diplomacy_faction_alligience = "";
                }

                _diplomacy_faction_name = global.faction_names[faction_engaged];

                draw_text_transformed(xx + 622, yy + 66, _diplomacy_faction_name, 1, 1, 0);

                if (_daemon) {
                    draw_text_transformed(xx + 622, yy + 104, localize("The Emmmisary"), 0.6, 0.6, 0);
                    show_stuff = true;
                } else {
                    draw_text_transformed(xx + 622, yy + 104, localize("{0} {1} {2}", [localize(faction_title[faction_engaged]), faction_leader[faction_engaged], localize(_diplomacy_faction_alligience)]), 0.6, 0.6, 0);
                }

                draw_set_font(cjk_font(fnt_40k_14));
                if (!_daemon) {
                    _disposition_rating = localize("Disposition: {0} ({1})", [localize(faction_disposition_rating_string(faction_engaged)), disposition[faction_engaged]]);
                    draw_text(xx + 622, yy + 144, _disposition_rating);
                    scr_draw_rainbow(xx + 366, yy + 165, xx + 871, yy + 175, (disposition[faction_engaged] / 200) + 0.5);
                }
                draw_set_color(c_gray);
                draw_rectangle(xx + 366, yy + 165, xx + 871, yy + 175, 1);

                show_stuff = true;
                _main_slate.draw_with_dimensions();
                if (warning == 1 || faction_engaged >= 6) {
                    var warn = localize("Consorting with heretics will cause your disposition with the Imperium to plummet.");
                    if (array_contains(global.xenos_factions, faction_engaged)) {
                        warn = localize("Consorting with xenos will cause your disposition with the Imperium to lower.");
                    }

                    draw_set_halign(fa_left);

                    draw_rectangle(_mx - 2, _my + 20, _mx + 2 + string_width_ext(warn, -1, 600), _my + 24 + string_height_ext(warn, -1, 600), 0);
                    draw_set_color(CM_GREEN_COLOR);
                    draw_rectangle(_mx - 2, _my + 20, _mx + 2 + string_width_ext(warn, -1, 600), _my + 24 + string_height_ext(warn, -1, 600), 1);
                    draw_text_ext(_mx, _my + 22, warn, -1, 600);
                }
                __main_faction_head_diplomacy();
            } else if (faction_engaged == -1) {
                if (is_struct(character_diplomacy)) {
                    draw_character_diplomacy();
                }
            } else {
                // Main Diplomacy screen

                draw_set_color(CM_GREEN_COLOR);
                draw_set_font(cjk_font(fnt_40k_30b));
                draw_set_halign(fa_center);
                draw_text(xx + 800, yy + 74, string_hash_to_newline(localize("Diplomacy")));

                xx += 55;
                yy -= 20;

                diplo_persons.imperium.draw_shutter(xx + 31, yy + 281, false, 1.5, known[eFACTION.IMPERIUM] > 0.7 || global.cheat_debug);

                diplo_persons.mechanicus.draw_shutter(xx + 31, yy + 417, false, 1.5, known[eFACTION.MECHANICUS] > 0.7 || global.cheat_debug);

                diplo_persons.inquisition.draw_shutter(xx + 31, yy + 553, false, 1.5, known[eFACTION.INQUISITION] > 0.7 || global.cheat_debug);

                diplo_persons.sisters.draw_shutter(xx + 31, yy + 689, false, 1.5, known[eFACTION.ECCLESIARCHY] > 0.7 || global.cheat_debug);

                diplo_persons.eldar.draw_shutter(xx + 1041, yy + 281, false, 1.5, known[eFACTION.ELDAR] > 0.7 || global.cheat_debug);

                diplo_persons.ork.draw_shutter(xx + 1041, yy + 417, false, 1.5, known[eFACTION.ORK] > 0.7 || global.cheat_debug);

                diplo_persons.tau.draw_shutter(xx + 1041, yy + 553, false, 1.5, known[eFACTION.TAU] > 0.7 || global.cheat_debug);

                diplo_persons.chaos.draw_shutter(xx + 1041, yy + 689, false, 1.5, known[eFACTION.CHAOS] > 0.7 || global.cheat_debug);

                scr_image("symbol", 0, xx + 138, yy + 174, 217, 107);
                scr_image("symbol", 1, xx + 525, yy + 174, 109, 54);
                scr_image("symbol", 2, xx + 1147, yy + 174, 217, 107);

                if (CHAOS_EMISSARY_ENABLED) {
                    //draw the meet chaos button
                    draw_set_font(cjk_font(fnt_40k_14b));
                    draw_set_halign(fa_left);
                    draw_set_color(CM_GREEN_COLOR);
                    draw_rectangle(xx + 688, yy + 240, xx + 1028, yy + 281, 0);
                    draw_set_color(c_black);
                    draw_text_transformed(xx + 688, yy + 241, localize("Meet Chaos Emissary"), 0.7, 0.7, 0);
                    //color blending stuff if hovering over the meeting chaos icon
                    if (point_in_rectangle(_mx, _my, xx + 688, yy + 240, xx + 1028, yy + 281)) {
                        draw_set_alpha(0.2);
                        draw_rectangle(xx + 688, yy + 240, xx + 1028, yy + 281, 0);
                        draw_set_alpha(1);
                    }
                }
            }
            xx = 0;
            yy = 0;

            var _main_slate = diplo_buttons.main_slate;
            _main_slate.XX = xx + 328;
            _main_slate.YY = yy + 175;
            _main_slate.height = 545;

            if (faction_engaged == -1) {
                if (!is_struct(character_diplomacy)) {
                    faction_engaged = 0;
                }
            }


            basic_diplomacy_screen();
        } catch (_exception) {
            ERROR_HANDLER.handle_exception(_exception);
            obj_controller.menu = eMENU.DEFAULT;
            obj_controller.menu_lock = false;
        }
        pop_draw_return_values();
        if (mouse_button_clicked() && (!trading) && valid_diplomacy_options()) {
            if (!force_goodbye) {
                exit;
            }
            // Want to check to see if the deal went fine here
            if (trading_artifact != 0) {
                obj_controller.click2 = 1;
                clear_diplo_choices();
                menu = eMENU.DEFAULT;
                with (obj_popup) {
                    instance_destroy();
                }
                if (trading_artifact != 2) {
                    with (obj_ground_mission) {
                        instance_destroy();
                    }
                }
                if (trading_artifact == 2 && instance_exists(obj_ground_mission)) {
                    with (obj_ground_mission) {
                        receive_artifact_in_discussion();
                    }
                }
                exit;
            }
            
        }
        if (CHAOS_EMISSARY_ENABLED && (faction_engaged == eFACTION.NONE)) {
            xx += 55;
            yy -= 20;
            // Daemon emmissary
            if (point_in_rectangle(mouse_x, mouse_y, xx + 688, yy + 181, xx + 1028, yy + 281)) {
                diplomacy = 10.1;
                diplomacy_pathway = "intro";
                scr_dialogue(diplomacy_pathway);
                cooldown = 1;
            }
        }
    }
}

function relationship_hostility_matrix(faction) {
    var _rela = "neutral";
    var _disp = disposition[faction];
    with (obj_controller) {
        if (_disp >= 60) {
            _rela = "friendly";
        }
        if ((_disp < 60) && (_disp >= 20)) {
            _rela = "neutral";
        }
        if (_disp < 20) {
            _rela = "hostile";
        }
        if (faction_engaged == 6) {
            if (_disp >= 60) {
                _rela = "friendly";
            }
            if ((_disp < 60) && (_disp >= 0)) {
                _rela = "neutral";
            }
            if (_disp < 0) {
                _rela = "hostile";
            }
        }

        if (faction_engaged == 8) {
            if (_disp >= 40) {
                _rela = "friendly";
            }
            if ((_disp < 40) && (_disp >= -15)) {
                _rela = "neutral";
            }
            if (_disp < -15) {
                _rela = "hostile";
            }
        }
    }
    return _rela;
}

function alter_disposition(faction, alter_value, return_string = false) {
    chap_data = obj_ini.chapter_data;

    alter_value = chap_data.calc_final_disp_value(faction, alter_value);

    obj_controller.disposition[faction] += alter_value;

    if (return_string) {
        return $"{global.faction_names[faction]} : {string_plus_minus(alter_value)}{alter_value}";
    }
}

function alter_dispositions(alterations, return_strings = false) {
    var _string;
    var _strings = [];
    for (var i = 0; i < array_length(alterations); i++) {
        _string = alter_disposition(alterations[i][0], alterations[i][1], return_strings);
        if (return_strings) {
            array_push(_strings, _string);
        }
    }

    if (return_strings) {
        return _strings;
    }
}

function clear_diplo_choices() {
    obj_controller.diplo_helper.diplo_options = [];
}

function valid_diplomacy_options() {
    var _valid = false;
    var _options_count = array_length(obj_controller.diplo_helper.diplo_options);

    if (_options_count == 0) {
        return _valid;
    }

    for (var i = _options_count - 1; i >= 0; i--) {
        var _opt = obj_controller.diplo_helper.diplo_options[i];
        LOGGER.debug(_opt);
        if (struct_exists(_opt, "option_text") && _opt.option_text != "") {
            _valid = true;
        } else {
            array_delete(obj_controller.diplo_helper.diplo_options, i, 1);
        }
    }

    return _valid;
}

function add_diplomacy_option(option = {}) {
    if (!struct_exists(option, "goto")) {
        option.goto = "";
    }
    if (!struct_exists(option, "key")) {
        option.key = option.option_text;
    }
    var _button = new UnitButtonObject(option);
    _button.style = "pixel";
    _button.label = option.option_text;
    array_push(obj_controller.diplo_helper.diplo_options, _button);
}

/// @desc Opens the trade screen for the current faction_engaged faction.
/// @returns {undefined}
function open_trade_screen() {
    trading = 1;
    scr_dialogue("open_trade");
    cooldown = 8;
    click2 = 1;
    trade_attempt = new TradeAttempt(faction_engaged);
}

/// @desc Leaves the artifact negotiation and cleans up the associated objects.
/// @returns {undefined}
function leave_artifact_negotiation() {
    with (obj_ground_mission) {
        instance_destroy();
    }
}

function basic_diplomacy_screen() {
    var _y_offset = 0;
    if (trading == 0 && valid_diplomacy_options()) {
        if (!force_goodbye) {
            draw_set_halign(fa_center);

            var opts = array_length(diplo_options);
            if (opts == 4) {
                _y_offset -= 30;
            }
            if (opts == 2) {
                _y_offset += 30;
            }
            if (opts == 1) {
                _y_offset += 60;
            }

            option_selections = [];
            var diplo_pressed = -1;
            for (var slot = 0; slot < opts; slot++) {
                var _opt = diplo_options[slot];

                _opt.update({x1: 354, y1: 694 + _y_offset});

                if (_opt.draw()) {
                    diplo_pressed = slot;
                }

                _y_offset += 30;
            }
            if (diplo_pressed > -1) {
                evaluate_chosen_diplomacy_option(diplo_pressed);
            }
        }
        if ((menu == eMENU.faction_engaged) && (faction_engaged == 10.1)) {
            scr_emmisary_diplomacy_routes();
        }
    }
}

function draw_character_diplomacy() {
    var _diplo_unit = character_diplomacy;
    if (_diplo_unit.allegiance == global.chapter_name) {
        var _specific_splash = 0;
        _diplomacy_faction_name = _diplo_unit.name_role();
        _diplo_unit.IsSpecialist(SPECIALISTS_HEADS);

        var _customs = obj_ini.custom_advisors;
        if (_diplo_unit.IsSpecialist(SPECIALISTS_APOTHECARIES)) {
            _specific_splash = struct_exists(_customs, "apothecary") ? _customs.apothecary : 2;
        } else if (_diplo_unit.IsSpecialist(SPECIALISTS_CHAPLAINS)) {
            _specific_splash = struct_exists(_customs, "chaplain") ? _customs.chaplain : 3;
        } else if (_diplo_unit.IsSpecialist(SPECIALISTS_LIBRARIANS)) {
            _specific_splash = struct_exists(_customs, "librarian") ? _customs.librarian : 4;
        } else if (_diplo_unit.IsSpecialist(SPECIALISTS_TECHS)) {
            _specific_splash = struct_exists(_customs, "forge_master") ? _customs.forge_master : 5;
        }
        scr_image("advisor/splash", _specific_splash, 16, 43, 310, 828);
    }

    var _main_slate = diplo_buttons.main_slate;
    var _meet = diplo_buttons.meet_slate;
    var _cm_slate = diplo_buttons.cm_slate;
    _meet.XX = 0;
    _meet.YY = 520;
    _meet.width = 520;

    _meet.inside_method = function() {
        var _diplo_unit = obj_controller.character_diplomacy;
        if (!variable_instance_exists(obj_controller, "diplo_image")) {
            obj_controller.diplo_image = _diplo_unit.draw_unit_image();
        }
        obj_controller.diplo_image.draw(210, 249, true, 1, 1, 0, CM_GREEN_COLOR, 1);
        _diplo_unit.stat_display(false, {x1: 10, y1: 520, w: 569, h: 303}, true);
        draw_sprite(spr_holo_pad, 0, 210, 520);
    };

    _meet.draw_with_dimensions();

    _main_slate.XX = _meet.XX + _meet.width;
    _main_slate.YY = 175;
    _main_slate.draw_with_dimensions();
    draw_diplomacy_diplo_text();
    draw_set_halign(fa_center);
    draw_text_transformed(622, 104, $"{_diplo_unit.name_role()}", 0.6, 0.6, 0);
    draw_set_halign(fa_left);

    _cm_slate.XX = _main_slate.XX + _main_slate.width;
    _cm_slate.YY = 520;
    _cm_slate.inside_method = function() {
        var _master = fetch_unit([0, 0]);
        if (!variable_instance_exists(obj_controller, "master_image")) {
            obj_controller.master_image = _master.draw_unit_image();
        }
        obj_controller.master_image.draw(1308, 249, true, 1, 1, 0, CM_GREEN_COLOR, 1);
        _master.stat_display(false, {x1: 1108, y1: 520, w: 569, h: 303}, true);
        draw_sprite(spr_holo_pad, 0, 1308, 520);
    };
    _cm_slate.draw_with_dimensions();

    basic_diplomacy_screen();
}

function evaluate_chosen_diplomacy_option(diplo_pressed) {
    var _opt = diplo_options[diplo_pressed];

    var _pressed_option = _opt.key;
    if (struct_exists(_opt, "choice_func")) {
        if (is_callable(_opt.choice_func)) {
            script_execute(_opt.choice_func);
        }
    }
    if (_opt.goto != "") {
        scr_dialogue(_opt.goto);
    }

    if (struct_exists(_opt, "is_exit") && _opt.is_exit) {
        exit_diplomacy_dialogue();
    }
}

function scr_diplomacy_hit(selection, new_path = undefined, complex_path = undefined) {
    if (array_length(option_selections) > selection) {
        if (point_and_click(option_selections[selection])) {
            if (!is_method(complex_path)) {
                diplomacy_pathway = new_path;
                scr_dialogue(diplomacy_pathway);
            } else {
                complex_path();
            }
        }
    } else {
        return false;
    }
}

// ** faction_engaged Chaos talks **
function scr_emmisary_diplomacy_routes() {
    if (cooldown > 0) {
        exit;
    }
    if (diplomacy_pathway == "intro") {
        //TODO replace with methods more in line with rest of code base but this helps find bugs for now
        scr_diplomacy_hit(0, "gift");
        scr_diplomacy_hit(1, "daemon_scorn");
        scr_diplomacy_hit(2, "daemon_scorn");
    } else if (diplomacy_pathway == "gift") {
        scr_diplomacy_hit(0, "Khorne_path");
        scr_diplomacy_hit(1, "Nurgle_path");
        scr_diplomacy_hit(2, "Tzeentch_path");
        scr_diplomacy_hit(3, "Slaanesh_path");
    } else if (diplomacy_pathway == "Khorne_path") {
        scr_diplomacy_hit(0,, function() {
            //TODO central get cm choice_func
            cooldown = 8000;
            diplomacy_pathway = "sacrifice_lib";
            //grab a random librarian
            var lib = scr_random_marine(SPECIALISTS_LIBRARIANS, 0);
            if (lib != "none") {
                var chapter_master = fetch_unit([0, 1]);
                var dead_lib = fetch_unit([lib[0], lib[1]]);
                pop_up = instance_create(0, 0, obj_popup);
                pop_up.title = "Skull for the Skull Throne";
                pop_up.text = $"You summon {dead_lib.name_role()} to your personal chambers. Darting from the shadows you deftly strike his head from his shoulders. With the flesh removed from his skull you place the skull upon a hastily erected shrine.";
                pop_up.type = 98;
                pop_up.image = "chaos";
                dead_lib.kill();
                chapter_master.add_trait("blood_for_blood");
                chapter_master.edit_corruption(20);
            } else {
                diplomacy_pathway = "daemon_scorn";
            }
            scr_dialogue(diplomacy_pathway);
            force_goodbye = 1;
        });
        scr_diplomacy_hit(1,, function() {
            cooldown = 8000;
            diplomacy_pathway = "sacrifice_champ";
            var champ = scr_random_marine(obj_ini.player_role_data[eROLE.CHAMPION].role, 0);
            if (champ != "none") {
                var chapter_master = fetch_unit([0, 1]);
                chapter_master.add_trait("blood_for_blood");
                chapter_master.edit_corruption(20);
                var dead_champ = fetch_unit([champ[0], champ[1]]);
                //TODO make this into a real dual with consequences
                pop_up = instance_create(0, 0, obj_popup);
                pop_up.title = "Skull for the Skull Throne";
                pop_up.text = $"You summon {dead_champ.name_role()} to your personal chambers. Darting from the shadows towards {dead_champ.name()} who is a cunning warrior and reacts with precision to your attack, however eventually you prevail and strike him down. With the flesh removed from his skull you place it upon a hastily erected shrine.";
                pop_up.type = 98;
                pop_up.image = "chaos";
                dead_champ.kill();
            } else {
                diplomacy_pathway = "daemon_scorn";
            }
            scr_dialogue(diplomacy_pathway);
            force_goodbye = 1;
        });
        scr_diplomacy_hit(2,, function() {
            cooldown = 8000;
            diplomacy_pathway = "sacrifice_squad";
            var kill_squad, squad_found = false;
            var _squad_ids = get_squad_ids();
            for (var i = 0; i < array_length(_squad_ids); i++) {
                kill_squad = fetch_squad(_squad_ids[i]);
                if (kill_squad.type == "tactical_squad" && array_length(kill_squad.members) > 4) {
                    var chapter_master = fetch_unit([0, 1]);
                    chapter_master.add_trait("blood_for_blood");
                    chapter_master.edit_corruption(20);
                    kill_squad.kill_members();
                    with (obj_ini) {
                        scr_company_order(kill_squad.base_company);
                    }
                    squad_found = true;
                    break;
                }
            }
            if (!squad_found) {
                diplomacy_pathway = "daemon_scorn";
            }
            scr_dialogue(diplomacy_pathway);
            force_goodbye = 1;
        });
        scr_diplomacy_hit(3, "daemon_scorn");
    } else if (diplomacy_pathway == "Slaanesh_path") {
        scr_diplomacy_hit(0, "Slaanesh_arti");
        scr_diplomacy_hit(1, "daemon_scorn");
    } else if (diplomacy_pathway == "Nurgle_path") {
        scr_diplomacy_hit(0, "nurgle_gift");
        scr_diplomacy_hit(1, "daemon_scorn");
    } else if (diplomacy_pathway == "Tzeentch_path") {
        scr_diplomacy_hit(0, "Tzeentch_plan");
        scr_diplomacy_hit(1, "daemon_scorn");
    }
}
