function scr_turn_first() {
    try {
        // I believe this is ran at the start of the end of the turn.  That would make sense, right?

        var _unload_i = 0;
        for (var i = 0, l = array_length(obj_ini.artifact); i < l; i++) {
            _unload_i = i;
            if (obj_ini.artifact[_unload_i] == "") {
                continue;
            }
            var _cur_arti = obj_ini.artifact_struct[_unload_i];
            if (_cur_arti.loc() == "") {
                var _valid_ship_i = get_valid_player_ship();
                if (_valid_ship_i > -1) {
                    obj_ini.artifact_loc[_unload_i] = obj_ini.ship[_valid_ship_i];
                    obj_ini.artifact_sid[_unload_i] = 500 + _valid_ship_i;
                }
            }
            if (_cur_arti.identified() > 0) {
                var _identifiable = _cur_arti.is_identifiable();

                if (instance_exists(obj_p_fleet) && (!_identifiable)) {
                    var _arti_fleet = find_ships_fleet(_cur_arti.ship_id());
                    if (_arti_fleet != "none") {
                        if (array_length(_arti_fleet.capital_num)) {
                            _identifiable = true;
                            _cur_arti.set_ship_id(_arti_fleet.capital_num[0]);
                        }
                    }
                }

                if (_identifiable) {
                    obj_ini.artifact_identified[_unload_i] -= 1;
                }
                if (obj_ini.artifact_identified[_unload_i] == 0) {
                    scr_alert("green", "artifact", "Artifact (" + string(obj_ini.artifact[_unload_i]) + ") has been identified.", 0, 0);
                }
            }
        }

        var _peace_check = obj_controller.turn > 100;
        // peace_check=1;// Testing

        if (_peace_check > 0) {
            var _total = 0;

            with (obj_star) {
                if (owner > 5) {
                    var _baddy = 0;
                    var o = 0;
                    repeat (planets) {
                        o++;
                        if (p_orks[o] + p_tyranids[o] + p_chaos[o] + p_traitors[o] + p_necrons[o] >= 3) {
                            _baddy++;
                        }
                    }
                    if (_baddy > 0) {
                        _total++;
                    }
                }
            }

            if (_total <= 3) {
                if ((obj_controller.turn >= 150) && (obj_controller.faction_defeated[eFACTION.CHAOS] == 0) && (obj_controller.known[eFACTION.CHAOS] == 0) && (obj_controller.faction_gender[eFACTION.CHAOS] == 2)) {
                    // if (turn>=100000) and (faction_defeated[10]=0) and (known[eFACTION.CHAOS]=0){faction_gender[10]=2;
                    spawn_chaos_warlord();
                } else {
                    out_of_system_warboss();
                }
            }
        }
    } catch (_exception) {
        handle_exception(_exception);
    }
}
