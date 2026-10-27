
function intro_to_diplomacy(faction_enum) {
    var _new_diag = "intro";
    if (faction_enum != 4) {
        if (obj_controller.known[faction_enum] == 1) {
            obj_controller.known[faction_engaged] = 2;
            faction_justmet = 1;
        } else if (obj_controller.known[faction_enum] >= 2) {
            _new_diag = "hello";
        }
    } else {
        if (obj_controller.known[eFACTION.INQUISITION] == 1) {
            obj_controller.known[faction_engaged] = 2;
            faction_justmet = 1;
            obj_controller.last_mission = turn + 1;
        } else if (obj_controller.known[eFACTION.INQUISITION] == 3) {
            obj_controller.known[faction_enum] = 4;
            faction_justmet = 1;
            obj_controller.last_mission = turn + 1;
        } else if (obj_controller.known[faction_enum] >= 4) {
            _new_diag = "hello";
        }
    }
    scr_dialogue(_new_diag);
}

/// @self Struct.DiplomacyHandler
function exit_diplomacy_dialogue() {
    menu_lock = false;
    if (global.audio_manager.current_context == CONTEXT_DIPLOMACY) {
        global.audio_manager.play_playlist(CONTEXT_SECTOR, 2000);
    }

    var _close_diplomacy = true;
    if (complex_event && instance_exists(obj_temp_meeting)) {
        complex_event = false;
        with (obj_temp_meeting) {
            instance_destroy();
        }
        if (instance_exists(obj_turn_end)) {
            obj_turn_end.alarm[1] = 1;
        }
    }

    if (trading_artifact != 0) {
        clear_diplo_choices();
        cooldown = 8;
        if (trading_artifact == 2 && instance_exists(obj_ground_mission)) {
            with (obj_ground_mission) {
                receive_artifact_in_discussion();
            }
        }
        trading_artifact = 0;
        with (obj_ground_mission) {
            instance_destroy();
        }
        with (obj_popup) {
            instance_destroy();
        }
    }

    if (force_goodbye == 5) {
        clear_diplo_choices();
    }

    if ((liscensing == 2) && (repair_ships == 0)) {
        cooldown = 8;
        var cru = instance_create(mouse_x, mouse_y, obj_crusade);
        cru.owner = faction_engaged;
        cru.placing = true;
        exit_all = 0;
        liscensing = 0;
        if (!zoomed) {
            scr_zoom();
        }
    }

    if (exit_all != 0) {
        exit_all = 0;
    }
    if ((diplo_last == "artifact_thanks") && (force_goodbye != 0)) {
        scr_toggle_lib();
        _close_diplomacy = false;
    } else if (diplo_last == "stc_thanks") {
        scr_toggle_armamentarium();
        _close_diplomacy = false;
    }
    // Exits back to faction_engaged thing
    if (audience == 0) {
        cooldown = 8;
        faction_engaged = 0;
        force_goodbye = 0;
        clear_diplo_choices();
        _close_diplomacy = false;
    }
    // No need to check for next audience
    if ((audience > 0) && instance_exists(obj_turn_end)) {
        if (complex_event == false) {
            obj_turn_end.alarm[1] = 1;
        }
        if (complex_event) {
            // TODO
        }
    }
    if (_close_diplomacy) {
        scr_toggle_diplomacy();
    }
}

/// @self Struct.DiplomacyHandler
function draw_diplomacy_diplo_text() {
    if (string_length(diplo_text_displayed) < string_length(diplo_text)) {
        diplo_char += 2;
        diplo_text_displayed = string_copy(diplo_text, 0, diplo_char);
    }
    if (diplo_text_alpha < 1) {
        diplo_text_alpha += 0.05;
    }
    draw_set_font(cjk_font(fnt_40k_14));
    draw_set_alpha(diplo_text_alpha);
    draw_set_color(CM_GREEN_COLOR);
    draw_set_halign(fa_left);
    draw_text_ext(352, 209, string_hash_to_newline(string(diplo_text_displayed)), -1, 536);
    draw_set_halign(fa_center);
    draw_line(429, 710, 800, 710);
}

/// @self Struct.DiplomacyHandler
function set_up_diplomacy_buttons() {
    diplo_buttons = {};
    audience_data = {};
    set_up_diplomacy_persons();
    //Trade button setup
    diplo_buttons.trade = new UnitButtonObject({
        x1: 400,
        y1: 720,
        label: "Trade",
        bind_scope: id,
        style: "pixel",
    });
    diplo_buttons.trade.bind_method = function() {
        if ((obj_controller.audience == 0) && (obj_controller.force_goodbye == 0)) {
            open_trade_screen();
        }
    };

    //Demand button setup
    diplo_buttons.demand = new UnitButtonObject({
        x1: 600,
        y1: 720,
        label: "Demand",
        bind_scope: id,
        style: "pixel",
    });
    diplo_buttons.demand.bind_method = function() {
        if ((obj_controller.audience == 0) && (obj_controller.force_goodbye == 0)) {
            obj_controller.cooldown = 8;
            obj_controller.click2 = 1;
            obj_controller.trading_demand = obj_controller.faction_engaged;
            scr_dialogue("trading_demand");
        }
    };

    //Discuss button setup
    diplo_buttons.discuss = new UnitButtonObject({
        x1: 800,
        y1: 720,
        label: "Discuss",
        tooltip: "Unfinished",
        bind_scope: id,
        style: "pixel",
    });

    //denounce button setup
    diplo_buttons.denounce = new UnitButtonObject({
        x1: 400,
        y1: diplo_buttons.trade.y2,
        label: "Denounce",
        bind_scope: id,
        style: "pixel",
    });

    diplo_buttons.denounce.bind_method = function() {
        if (obj_controller.diplo_last != "denounced") {
            scr_dialogue("denounced");
            obj_controller.cooldown = 8;
            obj_controller.click2 = 1;
        }
    };

    diplo_buttons.praise = new UnitButtonObject({
        x1: 600,
        y1: diplo_buttons.trade.y2,
        label: "Praise",
        bind_scope: id,
        style: "pixel",
    });

    diplo_buttons.praise.bind_method = function() {
        if (obj_controller.diplo_last != "praised") {
            scr_dialogue("praised");
            obj_controller.cooldown = 8;
            obj_controller.click2 = 1;
        }
    };

    diplo_buttons.alliance = new UnitButtonObject({
        x1: 800,
        y1: diplo_buttons.trade.y2,
        label: "Propose\nAlliance",
        bind_scope: id,
        style: "pixel",
    });

    diplo_buttons.alliance.bind_method = function() {
        if (obj_controller.diplo_last != "propose_alliance") {
            obj_controller.cooldown = 8;
            obj_controller.click2 = 1;
            scr_dialogue("propose_alliance");
        }
    };

    diplo_buttons.exit_button = new UnitButtonObject({
        x1: 818,
        y1: 795,
        label: "Exit",
        bind_scope: id,
        color: CM_RED_COLOR,
    });

    diplo_buttons.exit_button.bind_method = exit_diplomacy_dialogue;

    diplo_buttons.declare_war = new ShutterButton();
    var _war = diplo_buttons.declare_war;
    _war.XX = 640;
    _war.YY = diplo_buttons.alliance.y2;
    _war.label = localize("DECLARE WAR");
    _war.tooltip = localize("Unfinished");
    _war.color = CM_RED_COLOR;
    _war.cover_text = "Declare War";
    _war.bind_scope = id;

    diplo_buttons.main_slate = new DataSlate();
    diplo_buttons.main_slate.width = 570;
    diplo_buttons.main_slate.height = 854;
    diplo_buttons.main_slate.set_width = true;
    diplo_buttons.main_slate.style = "decorated";
    set_up_rpgcharacter_diplomacy();
}

/// @self Asset.DiplomacyHandler
function set_up_rpgcharacter_diplomacy() {
    diplo_buttons.meet_slate = new DataSlate();
    with (diplo_buttons.meet_slate) {
        width = 572;
        height = 188;
        XX = 0;
        YY = 712;
        set_width = true;
        style = "plain";
    }
    diplo_buttons.cm_slate = new DataSlate();
    with (diplo_buttons.cm_slate) {
        width = 572;
        height = 188;
        XX = 1031;
        YY = 712;
        set_width = true;
        style = "plain";
    }
}

/// @self Asset.DiplomacyHandler
function set_up_diplomacy_persons() {
    diplo_persons = {};
    diplo_persons.imperium = new ShutterButton();
    var _imp = diplo_persons.imperium;
    _imp.image = obj_controller.known[eFACTION.IMPERIUM] || global.cheat_debug ? 3 : 4;
    _imp._faction_enum = eFACTION.IMPERIUM;

    diplo_persons.mechanicus = new ShutterButton();
    var _mechs = diplo_persons.mechanicus;
    _mechs.image = obj_controller.known[eFACTION.MECHANICUS] || global.cheat_debug ? 5 : 6;
    _mechs._faction_enum = eFACTION.MECHANICUS;

    diplo_persons.inquisition = new ShutterButton();
    var _inquis = diplo_persons.inquisition;
    _inquis.image = obj_controller.known[eFACTION.INQUISITION] || global.cheat_debug ? 7 : 8;
    _inquis._faction_enum = eFACTION.INQUISITION;

    diplo_persons.sisters = new ShutterButton();
    var _sisters = diplo_persons.sisters;
    _sisters.image = obj_controller.known[eFACTION.ECCLESIARCHY] || global.cheat_debug ? 9 : 10;
    _sisters._faction_enum = eFACTION.ECCLESIARCHY;

    diplo_persons.eldar = new ShutterButton();
    var _eldar = diplo_persons.eldar;
    if (faction_gender[eFACTION.ELDAR] == 1) {
        _eldar.image = obj_controller.known[eFACTION.ELDAR] || global.cheat_debug ? 9 : 10;
    } else {
        _eldar.image = obj_controller.known[eFACTION.ELDAR] || global.cheat_debug ? 21 : 22;
    }
    _eldar._faction_enum = eFACTION.ELDAR;

    diplo_persons.ork = new ShutterButton();
    var _orks = diplo_persons.ork;
    _orks.image = obj_controller.known[eFACTION.ORK] || global.cheat_debug ? 13 : 14;
    _orks._faction_enum = eFACTION.ORK;

    diplo_persons.tau = new ShutterButton();
    var _tau = diplo_persons.tau;
    _tau.image = obj_controller.known[eFACTION.TAU] || global.cheat_debug ? 15 : 16;
    _tau._faction_enum = eFACTION.TAU;

    diplo_persons.chaos = new ShutterButton();
    var imm = 19;
    if (obj_controller.known[eFACTION.CHAOS] > 0 && faction_gender[eFACTION.CHAOS] == 2) {
        imm = 27;
    }
    if (obj_controller.known[eFACTION.CHAOS] < 1 && faction_gender[eFACTION.CHAOS] == 1) {
        imm = 20;
    }
    if (obj_controller.known[eFACTION.CHAOS] < 1 && faction_gender[eFACTION.CHAOS] == 2) {
        imm = 28;
    }
    var _chaos = diplo_persons.chaos;
    _chaos.image = imm;
    _chaos._faction_enum = eFACTION.CHAOS;

    var _shutters = [
        _imp,
        _mechs,
        _inquis,
        _sisters,
        _eldar,
        _orks,
        _tau,
        _chaos,
    ];

    for (var i = 0; i < array_length(_shutters); i++) {
        var _button = _shutters[i];
        with (_button) {
            management_buttons = {
                audience: new UnitButtonObject({
                    style: "pixel",
                    label: "Request Audience",
                }),
                ignore: new UnitButtonObject({
                    style: "pixel",
                    label: "Ignore",
                }),
                unignore: new UnitButtonObject({
                    style: "pixel",
                    label: "Unignore",
                    tooltip: "Click here or press B to Toggle Unit Biography.",
                }),
                screen_slate: new DataSlate(),
            };
            var _screen_slate = management_buttons.screen_slate;
            _screen_slate.XX = XX + 10;
            _screen_slate.YY = YY + 141;
            _screen_slate.set_width = true;
            _screen_slate.style = "plain";
            _screen_slate.width = 153;
            _screen_slate.height = 135;
            _screen_slate.inside_method = function() {
                scr_image("diplomacy/icons", image, XX + 10, YY + 10, 153, 135);
            };
            cover_text = obj_controller.faction[_faction_enum];
            inside_method = function() {
                var yy = YY;
                var xx = XX;
                draw_set_font(cjk_font(fnt_40k_14b));
                draw_set_halign(fa_left);
                draw_text(xx + 169, yy + 35, localize(obj_controller.faction[_faction_enum]));
                management_buttons.screen_slate.draw_with_dimensions(xx + 5, yy + 5);
                draw_set_font(cjk_font(fnt_40k_14));
                draw_set_halign(fa_right);
                draw_text_transformed(xx + 420, yy + 20, localize(obj_controller.faction_status[_faction_enum]), 0.7, 0.7, 0);
                draw_set_halign(fa_left);
                var txt = "????";
                if (obj_controller.known[_faction_enum] > 0) {
                    txt = localize("{0} {1}", [localize(obj_controller.faction_title[_faction_enum]), obj_controller.faction_leader[_faction_enum]]);
                }
                draw_text_transformed(xx + 169, yy + 50, txt, 0.7, 0.7, 0);
                draw_text_transformed(xx + 169, yy + 65, localize("Disposition: {0}", [obj_controller.disposition[_faction_enum]]), 0.7, 0.7, 0);
                scr_draw_rainbow(xx + 250, yy + 66, xx + 400, yy + 76, (obj_controller.disposition[_faction_enum] / 200) + 0.5);

                if (((obj_controller.known[_faction_enum] > 0.7) && (obj_controller.faction_defeated[_faction_enum] == 0)) || global.cheat_debug) {
                    var _audience = management_buttons.audience;
                    _audience.update({x1: xx + 169, y1: yy + 85});
                    _audience.bind_method = function() {
                        if ((obj_controller.known[_faction_enum] != 0 || global.cheat_debug) && (obj_controller.turns_ignored[_faction_enum] == 0)) {
                            obj_controller.faction_engaged = _faction_enum;
                            intro_to_diplomacy(_faction_enum);
                        }
                    };
                    _audience.draw();
                    var _ignore_status = obj_controller.ignore[_faction_enum] < 1 ? management_buttons.ignore : management_buttons.unignore;

                    _ignore_status.update({x1: _audience.x2 + 1, y1: yy + 85});
                    _ignore_status.draw();
                }
            };
        }
    }
}

function faction_disposition_rating_string(faction_engaged) {
    with (obj_controller) {
        var _disposition_rating = "";
        if (disposition[faction_engaged] <= -20) {
            _disposition_rating = global.alliance_grades[0];
        } else {
            var _grade = clamp(floor((disposition[faction_engaged] + 39) / 20), 1, 7);
            _disposition_rating = global.alliance_grades[_grade];
        }
        return _disposition_rating;
    }
}
