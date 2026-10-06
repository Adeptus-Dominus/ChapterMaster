function scr_chaos_alliance_test() {
    var _accept_chance = 0;
    var o = 0;
    var _result = "";
    var _jroll = roll_dice_chapter(1, 100, "high");

    _accept_chance += obj_controller.marines * 0.00375;
    _accept_chance += obj_controller.command * 0.00375;

    if (scr_has_disadv("Warp Tainted")) {
        _accept_chance += 2;
    }
    if (scr_has_disadv("Suspicious")) {
        _accept_chance += 1;
    }
    if (scr_has_adv("Warp Touched")) {
        _accept_chance += 1;
    }

    if (scr_has_adv("Reverent Guardians")) {
        _accept_chance -= 2;
    }
    if (scr_has_disadv("Never Forgive")) {
        _accept_chance -= 2;
    }
    if (scr_has_adv("Enemy: Fallen")) {
        _accept_chance -= 999;
        _result = "fail_fallen";
    }
    if (string_count("|CPF|", obj_controller.useful_info) > 0) {
        _result = "fail_angry";
    }
    if (string_count("CHTRP2|", obj_controller.useful_info) > 0) {
        _result = "fail";
    }

    if ((_accept_chance < 3) && (_result == "")) {
        _result = "fail";
    }
    var _success = false;
    var _trap = false;
    if ((_accept_chance >= 3) && (_result == "")) {
        _success = true;
        _accept_chance = round(_accept_chance * 15);
        _trap = _jroll > _accept_chance;
    }

    if (_success) {
        // Determine star, planet, and p_problem number here
        var _that_title = "";

        var _planet = 0;
        var _star = noone;
        with (obj_star) {
            for (var i = 1; i <= planets; i++){
                if (planet_feature_bool(p_feature[i], eP_FEATURES.WARLORD10) > 0) {
                    _planet = i;
                    _star = id;
                    break;
                }
            }
            if (_star != noone){
                break;
            }
        }
        if (_star == noone){
            diplo_text = "[Error: No WL10 planet feature found.]";
            exit;
        }
        var _p_data = _star.get_planet_data(_planet);
        _that_title = _p_data.name();

        var _meeting_arranged = false;
        _p_data.new_problem("meeting", 36, {is_trap : _trap});
    }
    if (_result == "fail") {
        var rando;
        rando = choose(1, 2);
        if (rando == 1) {
            diplo_text += "I would not assist you in slitting your own throat, it would hardly be worth my effort. Knowing this, why would you expect me to aid you?";
        }
        if (rando == 2) {
            diplo_text += "A mouse does not invite himself to the table of a dragon. You should learn from it and, if you work hard, perhaps one day you will be almost as insignificant.";
        }
    }
    if (_result == "fail_fallen") {
        var rando;
        rando = choose(1, 2);
        if (rando == 1) {
            diplo_text += "You must think that the servants of Chaos have no memory and no eyes. I assure we have both and know that you would be useless as an ally.";
        }
        if (rando == 2) {
            diplo_text += "You may be unclear on how warfare works; You are my foe, however pathetic you might be, and foes do not enter into alliances.";
        }
    }
    if (_result == "fail_angry") {
        var rando;
        rando = choose(1, 2);
        if (rando == 1) {
            diplo_text += "You have slain my servants, blunted the tools with which I carve my will into the universe and now you believe I will embrace you as an ally? I think not.";
        }
        if (rando == 2) {
            diplo_text += "Never forget, never forgive. Whatever else you have done, you have acted against me in the past and I do not forgive such transgressions. Away with you.";
            force_goodbye = 1;
        }
    }
}
