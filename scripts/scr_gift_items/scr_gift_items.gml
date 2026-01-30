function draw_gift_items_popup() {
    draw_sprite(spr_planet_screen, 0, 231 + 314, 112);
    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_center);
    draw_set_color(c_gray);

    var inq_hide = 0;
    if (subtype == 0) {
        if (array_contains(obj_ini.artifact_tags[obj_controller.menu_artifact], "inq")) {
            if (array_contains(obj_controller.quest, "artifact_loan")) {
                inq_hide = 1;
            }
            if (array_contains(obj_controller.quest, "artifact_return")) {
                inq_hide = 2;
            }
        }
    }
    var iter = 0, spacer = 0;
    for (var i = 0; i < array_length(fac_buttons); i++) {
        var _button = fac_buttons[i];
        var _fac = _button.faction;
        if (_button.draw(obj_controller.known[_fac] >= 1)) {
            if (_fac == eFACTION.Inquisition) {
                if (inq_hide == 1) {
                    continue;
                }
            }
            giveto = _fac;
        }
    }
    draw_set_alpha(1);
    draw_set_color(CM_GREEN_COLOR);
    if (cancel_button.draw()) {
        instance_destroy();
        exit;
    }
    if (giveto > 0) {
        if (subtype == 0) {
            gift_artifact(giveto, true);
        } else if (subtype == 1) {
            gift_stc_fragment();
        }
    }
}

function gift_artifact(give_to, known = true) {
    if (known) {
        var arti_index = obj_controller.menu_artifact;
    } else {
        obj_controller.menu_artifact = scr_add_artifact("random", "minor");
    }

    var arti_index = obj_controller.menu_artifact;

    var artifact_struct = obj_ini.artifact_struct[arti_index];
    var cur_tags = obj_ini.artifact_tags[arti_index];

    // obj_controller.artifacts-=1; // this is done by delete_artifact() that is run later;

    obj_controller.cooldown = 10;
    if (obj_controller.menu_artifact > obj_controller.artifacts) {
        obj_controller.menu_artifact = obj_controller.artifacts;
    }

    scr_toggle_diplomacy();
    obj_controller.diplomacy = give_to;
    obj_controller.force_goodbye = -1;
    var the = "";

    if ((give_to != 7) && (give_to != 10)) {
        the = "the ";
    }

    var inq_hide = 0;

    if (array_contains(obj_ini.artifact_tags[obj_controller.menu_artifact], "inq")) {
        if (array_contains(obj_controller.quest, "artifact_loan")) {
            inq_hide = 1;
        }
        if (array_contains(obj_controller.quest, "artifact_return")) {
            inq_hide = 2;
        }
    }

    scr_event_log("", $"Artifact gifted to {the} {obj_controller.faction[give_to]}.");
    var is_daemon = artifact_struct.has_tag("daemonic");
    var is_chaos = artifact_struct.has_tag("chaos");
    if (inq_hide != 2) {
        with (obj_controller) {
            if ((!is_daemon) || ((diplomacy != 4) && (diplomacy != 5) && (diplomacy != 2))) {
                scr_dialogue("artifact_thanks");
            }
            if (is_daemon && ((diplomacy == 4) || (diplomacy == 5) || (diplomacy == 2))) {
                scr_dialogue("artifact_daemon");
            }
        }
    }
    if ((inq_hide == 2) && (obj_controller.diplomacy == 4)) {
        with (obj_controller) {
            scr_dialogue("artifact_returned");
        }
    }

    if (artifact_struct.has_tag("MINOR")) {
        obj_controller.disposition[give_to] = clamp(obj_controller.disposition[give_to] + 1, -100, 100);
    } else {
        var daemon_arts = function(faction, is_chaos, is_daemon) {
            switch (faction) {
                case eFACTION.Imperium:
                    if (is_daemon) {
                        var v = 0, ev = 0;
                        add_event({e_id: "imperium_daemon", duration: 1});
                        with (obj_star) {
                            for (var i = 1; i <= planets; i++) {
                                if (p_owner[i] == 2) {
                                    p_heresy[i] += choose(30, 40, 50, 60);
                                }
                            }
                        }
                    }
                    if (is_chaos) {
                        with (obj_star) {
                            for (var i = 1; i <= planets; i++) {
                                if ((p_owner[i] == 2) && (p_heresy[i] > 0)) {
                                    p_heresy[i] += 10;
                                }
                            }
                        }
                    }
                    break;
                case eFACTION.Tau:
                    if (is_daemon) {
                        with (obj_star) {
                            for (var i = 1; i <= planets; i++) {
                                if (p_owner[i] == 8) {
                                    p_heresy[i] += 40;
                                }
                            }
                        }
                    }
                    break;
            }
        };

        var specialmod = 0;
        switch (give_to) {
            case eFACTION.Imperium:
                break;
            case eFACTION.Mechanicus:
                break;
            case eFACTION.Inquisition:
                if (inq_hide == 2) {
                    specialmod -= 1;
                }

                if (is_chaos) {
                    specialmod += 2;
                }

                if (is_daemon) {
                    specialmod += 4;
                }
                break;
            case eFACTION.Ecclesiarchy:
                if (!is_daemon) {
                    if (scr_has_adv("Reverent Guardians")) {
                        specialmod += 2;
                    }
                } else {
                    specialmod -= 2;
                }
                break;
        }

        daemon_arts(give_to, is_chaos, is_daemon);
        var tagmod = artifact_struct.artifact_faction_value(give_to);

        alter_disposition(give_to, 2 + specialmod + tagmod);
    }

    // Need to modify ^^^^ based on if it is chaos or daemonic

    delete_artifact(arti_index);
    instance_destroy();
    exit;
}

function are_giftable_factions() {
    var chick = false;
    //list of all giftable factions enum numbers
    var giftable_factions = [
        eFACTION.Imperium,
        eFACTION.Mechanicus,
        eFACTION.Inquisition,
        eFACTION.Ecclesiarchy,
        eFACTION.Eldar,
        eFACTION.Tau
    ];
    for (var i = 0; i < array_length(giftable_factions); i++) {
        var gift_faction = giftable_factions[i];
        if (known[gift_faction] && !faction_defeated[gift_faction]) {
            chick = true;
        }
    }
    return chick;
}

function setup_gift_popup() {
    if (are_giftable_factions()) {
        var pop = instance_create(0, 0, obj_popup);
        pop.type = 9;
        with (pop) {
            cancel_button = new UnitButtonObject({x1: 700, y1: 370, style: "pixel", label: "Cancel"});

            fac_buttons = [];

            for (var i = 2; i <= 8; i++) {
                if (i == 7) {
                    continue;
                }
                var _y1 = 131;
                if (i > 2) {
                    var _y1 = _last_y;
                }
                var _fac_but = new UnitButtonObject({x1: 660, w: 147, set_width: true, y1: _y1, style: "pixel", label: obj_controller.faction[i], faction: i, tooltip: $"Disposition : {obj_controller.disposition[i]}"});
                var _last_y = _fac_but.y2;
                array_push(fac_buttons, _fac_but);
            }
        }
        return pop;
    }
}

function setup_gift_artifact_popup() {
    setup_gift_popup();
}

function setup_gift_stc_popup() {
    var _pip = setup_gift_popup();
    if (instance_exists(obj_popup)) {
        _pip.subtype = 1;
    }
}

function gift_stc_fragment() {
    var r1, r2, cn;
    r2 = 0;
    cn = obj_controller;
    r1 = floor(random(cn.stc_wargear_un + cn.stc_vehicles_un + cn.stc_ships_un)) + 1;

    if ((r1 < cn.stc_wargear_un) && (cn.stc_wargear_un > 0)) {
        r2 = 1;
    }
    if ((r1 > cn.stc_wargear_un) && (r1 <= cn.stc_wargear_un + cn.stc_vehicles_un) && (cn.stc_vehicles_un > 0)) {
        r2 = 2;
    }
    if ((r1 > cn.stc_wargear_un + cn.stc_vehicles_un) && (r2 <= cn.stc_wargear_un + cn.stc_vehicles_un + cn.stc_ships_un) && (cn.stc_ships_un > 0)) {
        r2 = 3;
    }

    if ((cn.stc_wargear_un > 0) && (cn.stc_vehicles_un + cn.stc_ships_un == 0)) {
        r2 = 1;
    }
    if ((cn.stc_vehicles_un > 0) && (cn.stc_wargear_un + cn.stc_ships_un == 0)) {
        r2 = 2;
    }
    if ((cn.stc_ships_un > 0) && (cn.stc_vehicles_un + cn.stc_wargear_un == 0)) {
        r2 = 3;
    }

    cn.stc_un_total -= 1;
    if (r2 == 1) {
        cn.stc_wargear_un -= 1;
    }
    if (r2 == 2) {
        cn.stc_vehicles_un -= 1;
    }
    if (r2 == 3) {
        cn.stc_ships_un -= 1;
    }

    // Modify disposition here
    if (giveto == eFACTION.Imperium) {
        obj_controller.disposition[giveto] += 3;
    } else if (giveto == eFACTION.Mechanicus) {
        obj_controller.disposition[giveto] += choose(5, 6, 7, 8);
    } else if (giveto == eFACTION.Inquisition) {
        obj_controller.disposition[giveto] += 3;
    } else if (giveto == eFACTION.Ecclesiarchy) {
        obj_controller.disposition[giveto] += 3;
    }

    if (giveto == eFACTION.Eldar) {
        obj_controller.disposition[giveto] += 2;
    }
    if (giveto == eFACTION.Tau) {
        obj_controller.disposition[giveto] += 15;
    } // 137 ; chance for mechanicus to get very pissed
    // End disposition
    obj_controller.cooldown = 7000;
    scr_toggle_diplomacy();
    obj_controller.diplomacy = giveto;
    obj_controller.force_goodbye = -1;
    var the;
    the = "";
    if ((giveto != eFACTION.Ork) && (giveto != eFACTION.Chaos)) {
        the = "the ";
    }

    scr_event_log("", $"STC Fragment gifted to {the}{obj_controller.faction[giveto]}.");

    with (obj_controller) {
        scr_dialogue("stc_thanks");
    }
    instance_destroy();
    exit;
}
