function scr_turn_first() {
    try {
        // I believe this is ran at the start of the end of the turn.  That would make sense, right?

        var _artifact_ids = struct_get_names(obj_ini.artifact_map);
        for (var i = 0; i < array_length(_artifact_ids); i++) {
            /// @type {Struct.ArtifactStruct}
            var _cur_arti = obj_ini.artifact_map[$ _artifact_ids[i]];
            if (_cur_arti.get_location_name() == "") {
                var _valid_ship_i = get_valid_player_ship();
                if (_valid_ship_i > -1) {
                    _cur_arti.set_location_name(obj_ini.ship[_valid_ship_i]);
                    _cur_arti.set_sid(_valid_ship_i);
                }
            }

            if (_cur_arti.get_identification_timer() > 0) {
                var _identifiable = _cur_arti.is_identifiable();

                if (instance_exists(obj_p_fleet) && (!_identifiable)) {
                    var _arti_fleet = find_ships_fleet(_cur_arti.get_ship_id());
                    if (_arti_fleet != noone) {
                        if (array_length(_arti_fleet.capital_num)) {
                            _identifiable = true;
                            _cur_arti.set_location_name(_arti_fleet.capital[0]);
                            _cur_arti.set_sid(_arti_fleet.capital_num[0]);
                        }
                    }
                }

                if (_identifiable) {
                    _cur_arti.tick_identification();
                }
                if (_cur_arti.get_identification_timer() == 0) {
                    scr_alert("green", "artifact", "Artifact (" + string(_cur_arti.get_type_name()) + ") has been identified.", 0, 0);
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
        ERROR_HANDLER.handle_exception(_exception);
    }
}
