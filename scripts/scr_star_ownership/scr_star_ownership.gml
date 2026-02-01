/// @mixin obj_star
function scr_star_ownership(argument0) {
    var run = 0;
    var ork_owner, tau_owner, player_owner, imperium_owner, eldar_owner, traitors_owner, forge_owner, tyranids_owner, necrons_owner, nun_owner;
    ork_owner = 0;
    tau_owner = 0;
    player_owner = 0;
    eldar_owner = 0;
    traitors_owner = 0;
    forge_owner = 0;
    imperium_owner = 0;
    tyranids_owner = 0;
    necrons_owner = 0;
    nun_owner = 0;

    repeat (planets) {
        run++;
        p_chaos[run] = clamp(p_chaos[run], 0, 6);
        p_tau[run] = clamp(p_tau[run], 0, 6);
        p_orks[run] = clamp(p_orks[run], 0, 6);
        p_traitors[run] = clamp(p_traitors[run], 0, 6);
        p_tyranids[run] = clamp(p_tyranids[run], 0, 6);

        if (p_owner[run] == eFACTION.PLAYER) {
            if (dispo[run] < 95 && !planet_feature_bool(p_feature[run], eP_FEATURES.MONASTERY)) {
                p_owner[run] = eFACTION.IMPERIUM;
            }
        }
        var _set_to_first = false;
        if (p_owner[run] == 7 && p_orks[run] <= 0) {
            _set_to_first = true;
        }
        if (_set_to_first) {
            var _first = p_first[run];
            if (p_first[run] == eFACTION.ORK) {
                p_owner[run] = 2;
            } else {
                p_owner[run] = p_first[run];
            }
        }
        if (p_type[run] == "Dead" && p_owner[run] != eFACTION.IMPERIUM && p_first[run] != eFACTION.PLAYER && p_first[run] != eFACTION.ECCLESIARCHY) {
            p_owner[run] = eFACTION.IMPERIUM;
        }
        if (p_owner[run] == eFACTION.TAU && p_tau[run] == 0 && p_pdf[run] == 0) {
            p_owner[run] = eFACTION.IMPERIUM;
            p_influence[run][eFACTION.TAU] = round(p_influence[run][eFACTION.TAU] / 2);
        }
        if (p_owner[run] == 10 && p_chaos[run] == 0 && p_traitors[run] == 0 && p_population[run] <= 0) {
            p_owner[run] = p_first[run];
            p_heresy[run] = 0;
            if (p_owner[run] == 10) {
                p_owner[run] = 2;
            }
        }
        if (p_type[run] == "Daemon") {
            p_owner[run] = 10;
        }

        var _nid_chosen = false;
        if (planet_feature_bool(p_feature[run], eP_FEATURES.GENE_STEALER_CULT)) {
            if (p_influence[run][eFACTION.TYRANIDS] > 50) {
                p_owner[run] = eFACTION.TYRANIDS;
                tyranids_owner++;
                _nid_chosen = true;
            }
        } else if (p_tyranids[run] >= 5 && p_population[run] == 0) {
            p_owner[run] = eFACTION.TYRANIDS;
            tyranids_owner++;
            _nid_chosen = true;
        }

        if (p_type[run] != "Dead" && !_nid_chosen) {
            switch (p_owner[run]) {
                case eFACTION.PLAYER:
                    player_owner++;
                    break;
                case eFACTION.IMPERIUM:
                    if (p_type[run] != "Forge") {
                        imperium_owner++;
                    } else {
                        p_owner[run] = eFACTION.MECHANICUS;
                        forge_owner++;
                    }
                    break;
                case eFACTION.MECHANICUS:
                    forge_owner++;
                    break;
                case eFACTION.ECCLESIARCHY:
                    nun_owner++;
                    break;
                case eFACTION.ELDAR:
                    eldar_owner = 999;
                    break;
                case eFACTION.ORK:
                    ork_owner++;
                    break;
                case eFACTION.TAU:
                    tau_owner++;
                    break;
                case eFACTION.CHAOS:
                case eFACTION.HERETICS:
                    traitors_owner++;
                    break;
                case eFACTION.NECRONS:
                    necrons_owner++;
                    break;
            }
        }

        if (argument0 != false) {
            if (array_length(p_feature[run]) != 0) {
                if (planet_feature_bool(p_feature[run], eP_FEATURES.DAEMONIC_INCURSION)) {
                    p_heresy[run] += 2;
                    if (!p_large[run] && p_population[run] > 10000) {
                        p_population[run] = floor(p_population[run] * 0.5);
                    } else if (p_large[run]) {
                        p_population[run] = p_population[run] * 0.7;
                    }
                }
            }
            if (p_tyranids[run] > 4) {
                if (!p_large[run]) {
                    p_population[run] = p_population[run] <= 400000 ? 0 : 1;
                    floor(p_population[run] * 0.1);
                } else {
                    p_population[run] = p_population[run] * 0.1;
                }
            }
            if (array_length(p_feature[run]) != 0) {
                if (p_type[run] != "Dead" && planet_feature_bool(p_feature[run], eP_FEATURES.DAEMONIC_INCURSION) && p_heresy[run] >= 100) {
                    var randoo = choose(1, 2, 3, 4);
                    if (randoo == 4) {
                        p_type[run] = "Daemon";
                        p_fortified[run] = 6;
                        p_traitors[run] = 7;
                        p_owner[run] = 10;
                        delete_features(p_feature[run], eP_FEATURES.DAEMONIC_INCURSION);
                    }
                }
            }
        }
    }

    // if (player_owner>0 && player_owner>=imperium_owner && player_owner>=forge_owner && player_owner>=necrons_owner && player_owner>=ork_owner && player_owner>=tau_owner && player_owner>=traitors_owner){owner  = eFACTION.PLAYER;}

    if (necrons_owner > 0) {
        owner = eFACTION.NECRONS;
    } else if (player_owner > 0 && player_owner >= necrons_owner && player_owner >= ork_owner && player_owner >= tau_owner && player_owner >= traitors_owner) {
        owner = eFACTION.PLAYER;
    } else if (nun_owner > 0 && nun_owner >= forge_owner && nun_owner >= tau_owner && nun_owner >= necrons_owner && nun_owner >= traitors_owner && nun_owner >= ork_owner && nun_owner >= imperium_owner && player_owner == 0) {
        owner = eFACTION.ECCLESIARCHY;
    } else if (tyranids_owner > 0) {
        owner = eFACTION.TYRANIDS;
    } else if (eldar_owner > 0) {
        owner = eFACTION.ELDAR;
    } else if (forge_owner > 0) {
        owner = eFACTION.MECHANICUS;
    } else if (traitors_owner == planets) {
        owner = eFACTION.CHAOS;
    } else if (traitors_owner > imperium_owner && traitors_owner > forge_owner && traitors_owner > necrons_owner && traitors_owner > player_owner && traitors_owner > tau_owner && traitors_owner > ork_owner) {
        owner = eFACTION.CHAOS;
    } else if (tau_owner > imperium_owner && tau_owner > forge_owner && tau_owner > ork_owner && tau_owner > necrons_owner && tau_owner > player_owner && tau_owner > traitors_owner) {
        owner = eFACTION.TAU;
    } else if ((ork_owner > imperium_owner) && (ork_owner > forge_owner) && (ork_owner > player_owner && ork_owner > tau_owner && ork_owner > traitors_owner && ork_owner > necrons_owner)) {
        owner = eFACTION.ORK;
    } else if (imperium_owner > 0 && imperium_owner >= forge_owner && imperium_owner >= tau_owner && imperium_owner >= necrons_owner && imperium_owner >= traitors_owner && imperium_owner >= ork_owner && player_owner == 0) {
        owner = eFACTION.IMPERIUM;
    }
}
