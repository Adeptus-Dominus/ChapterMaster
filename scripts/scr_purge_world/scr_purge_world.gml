function PlayerPurge(action_type, action_score, planet_data) constructor {
    pop_before = 0;
    max_kill = 0;
    pop_after = 0;
    overkill = 0;
    self.planet_data = planet_data;
    self.action_type = action_type;
    self.action_score = action_score;
    population_reduction_percentage = 0;

    heres_after = 0;
    heres_before = 0;

    static calculate_max_kills = function() {
        switch (action_type) {
            case eDROP_TYPE.PURGEBOMBARD:
                max_kill = 15000000 * action_score;
                if (pop_before > 0) {
                    overkill = max(pop_before * 0.1, ((heres_before / 200) * pop_before));
                }
                break;
            case eDROP_TYPE.PURGEFIRE:
                max_kill = 12000 * action_score;
                if (pop_before > 0) {
                    overkill = max(pop_before * 0.1, ((heres_before / 200) * pop_before));
                }
                break;
            case eDROP_TYPE.PURGESELECTIVE:
                max_kill = action_score * 30;
                break;
        }
        kill = min(max_kill, pop_before);

        if (overkill > 0) {
            kill = min(kill, overkill);
        }
    };

    calculate_influence_reduction = function() {
        switch (action_type) {
            case eDROP_TYPE.PURGEBOMBARD:
                if (population_reduction_percentage > 0) {
                    influence_reduction = min((population_reduction_percentage * 2), action_score * 2); // How much hurresy to get rid of
                }
                break;
            case eDROP_TYPE.PURGEFIRE:
                influence_reduction = min((population_reduction_percentage * 2), round(action_score / 25));
                break;
            case eDROP_TYPE.PURGESELECTIVE:
                influence_reduction = round(action_score / 50);
                break;
        }
        influence_reduction = min(influence_reduction, heres_before);
    };

    static calculate_deaths = function() {
        calculate_max_kills();

        pop_after = pop_before - kill;

        population_reduction_percentage = (pop_after / pop_before) * 100; // Relative % of people murderized

        calculate_influence_reduction();

        heres_after = max(heres_before - influence_reduction, 0);
    };

    static population_death_string = function() {
        var _death_string = "\n\nThe planet had a population of ";
        if (!planet_data.large_population) {
            _death_string += $"{scr_display_number(floor(pop_before))} and {scr_display_number(floor(kill))}";
        } else {
            _death_string += $"{pop_before / LARGE_PLANET_MOD} billion and {scr_display_number(kill)}";
        }

        switch (action_type) {
            case eDROP_TYPE.PURGEBOMBARD:
                _death_string += "were purged over the duration of the bombardment.";
                break;
            case eDROP_TYPE.PURGEFIRE:
                _death_string += " over the duration of the cleansing.";
                break;
            case eDROP_TYPE.PURGESELECTIVE:
                _death_string += " over the duration of the search.";
                break;
        }

        _death_string += " were purged";

        switch (heres_target) {
            case "corruption":
                _death_string += $"\n\nHeresy has fallen to {heres_after}%.";
                break;
            case "tau":
                _death_string += $"\n\Tau influence is now effecting {heres_after}% of the population.";
                break;
            case "genestealers":
                _death_string += $"\n\Genestealer influence is now effecting {heres_after}% of the population.";
                break;
        }

        return _death_string;
    };

    static bombard_repercussions = function() {
        var _type = planet_data.planet_type;

        if (pop_after <= 0) {
            if (planet_data.current_owner == eFACTION.IMPERIUM && planet_data.owner_status() != "War") {
                if (_type == "Temperate" || _type == "Hive" || _type == "Desert") {
                    var _disp_hit = -10;
                    if (_type == "Temperate") {
                        _disp_hit = -5;
                    }
                    if (_type == "Desert") {
                        _disp_hit = -3;
                    }
                    scr_audience(eFACTION.IMPERIUM, "bombard_angry", _disp_hit, "", 0, 0);
                }
            }
        }
        if (planet_data.current_owner == eFACTION.MECHANICUS && planet_data.owner_status() != "War") {
            var _disp_hit = 0;
            if (_type == "Forge") {
                _disp_hit = -15;
            }
            if (_type == "Ice") {
                _disp_hit = -7;
            }
            scr_audience(eFACTION.INQUISITION, "bombard_angry", _disp_hit, "", 0, 0);
        }
    };
}

/// @self Struct.PlanetData
function scr_purge_world(action_type, action_score) {
    var _purge = new PlayerPurge(action_type, action_score, self);

    var _isquest = 0;
    var _thequest = "";
    var _questnum = 0;
    var _popup_text = "";

    _purge.pop_before = population_as_small();

    _purge.heres_before = max(total_corruption(), population_influences[eFACTION.TAU], population_influences[eFACTION.TYRANIDS]); // Starting heresy

    if (action_type != eDROP_TYPE.PURGEASSASSINATE) {
        _purge.calculate_deaths();
    }
    var _heres_target = "corruption";

    if (max(population_influences[eFACTION.TAU], population_influences[eFACTION.TYRANIDS]) > total_corruption()) {
        if (population_influences[eFACTION.TAU] > population_influences[eFACTION.TYRANIDS]) {
            _heres_target = "tau";
        } else {
            _heres_target = "genestealers";
        }
    }

    _purge.heres_target = _heres_target;

    var _no_chaos = (planet_forces[eFACTION.HERETICS] + planet_forces[eFACTION.CHAOS]) == 0;
    if ((action_type == eDROP_TYPE.PURGEFIRE || action_type == eDROP_TYPE.PURGESELECTIVE) && _no_chaos && obj_controller.turn >= obj_controller.chaos_turn) {
        if (has_feature(eP_FEATURES.WARLORD10) && obj_controller.known[10] == 0 && obj_controller.faction_gender[10] == 1) {
            with (obj_drop_select) {
                var pop = instance_create(0, 0, obj_popup);
                pop.image = "chaos_symbol";
                pop.title = "Concealed Heresy";
                pop.text = $"Your astartes set out and begin to cleanse {name()} of possible heresy.  The general populace appears to be devout in their faith, but a disturbing trend appears- the odd citizen cursing your forces, frothing at the mouth, and screaming out heresy most foul.  One week into the cleansing a large hostile force is detected approaching and encircling your forces.";
                exit;
            }
        }
        if (has_feature(eP_FEATURES.WARLORD10) && obj_controller.known[10] >= 2 && obj_controller.faction_gender[10] == 1) {
            with (obj_drop_select) {
                attacking = 10;
                obj_controller.cooldown = 30;
                combating = 1; // Start battle here

                instance_deactivate_all(true);
                instance_activate_object(obj_controller);
                instance_activate_object(obj_ini);
                instance_activate_object(obj_drop_select);

                instance_create(0, 0, obj_ncombat);
                obj_ncombat.battle_object = p_target;
                obj_ncombat.battle_loc = p_target.name;
                obj_ncombat.battle_id = obj_controller.selecting_planet;
                obj_ncombat.dropping = 0;
                obj_ncombat.attacking = 10;
                obj_ncombat.enemy = eFACTION.CHAOS;
                obj_ncombat.formation_set = 1;

                obj_ncombat.leader = 1;
                obj_ncombat.threat = 5;
                obj_ncombat.battle_special = "WL10_later";
                scr_battle_allies();
                setup_battle_formations();
                roster.add_to_battle();
            }
        }
    }

    // TODO - while I don't expect Surface to Orbit weapons retaliating against player's purge bombardment, it might still be worthwhile to consider possible situations

    if (action_type == eDROP_TYPE.PURGEBOMBARD) {
        // Bombardment
        var _ship = string_plural("ship", obj_drop_select.ships_selected);
        _popup_text = choose($"Your cruiser and larger {_ship}", $"The heavens rumble and thunder as your {_ship}");
        _popup_text += choose(" position themselves over the target in close orbit, and unleash", " unload");
        var _adjective = choose("tearing ground", "hammering", "battering", "thundering");
        _popup_text += $" annihilation upon {name()}. Even from space the explosions can be seen, {_adjective} across the planet's surface.";

        _purge.bombard_repercussions();
    }

    if (action_type == eDROP_TYPE.PURGEFIRE) {
        // Burn baby burn
        var i = 0;
        if (has_problem("cleanse")) {
            _isquest = true;
            _thequest = "cleanse";
            _questnum = i;
        }

        if (_isquest) {
            if (_thequest == "cleanse" && action_score >= 20) {
                remove_problem(_thequest);

                alter_disposition(eFACTION.INQUISITION, obj_controller.demanding ? choose(0, 0, 1) : 1);

                _popup_text = "Your marines scour the underhive of {name()}, spraying mutants down with promethium as they go.  It takes several days but a sizeable dent is put in their numbers.";
                scr_event_log("", "Inquisition Mission Completed: The mutants of {name()} have been cleansed by promethium.");
                add_disposition(choose(1, 2, 3));
            }
        } else {
            // TODO add more variation, with planets, features, marine equipment perhaps?
            _popup_text = choose($"Timing their visits right, Your forces scour {name()} burning down whatever the local heretic communities call their homes. Their screams were quickly extinguished by fire, turning whatever it was before, into ash.", $"Your forces scour {name()}, burning homes and towns that reek of heresy. The screams and wails of the damned carry through the air.");

            var nid_influence = population_influences[eFACTION.TYRANIDS];
            if (has_feature(eP_FEATURES.GENE_STEALER_CULT)) {
                var cult = get_features(eP_FEATURES.GENE_STEALER_CULT)[0];
                if (cult.hiding) {}
            } else {
                if (nid_influence > 25) {
                    _popup_text += " Scores of mutant offspring from a genestealer infestation are burnt, while we have damaged their influence over this world, the mutants appear to lack the organisation of a true cult";
                    adjust_influence(eFACTION.TYRANIDS, -10, planet, system);
                } else if (nid_influence > 0) {
                    _popup_text += " There are signs of a genestealer infestation but the cultists are too unorganized to do any real damage to their influence on this world";
                }
            }

            _popup_text += _purge.population_death_string();
        }
    }

    if (action_type == eDROP_TYPE.PURGESELECTIVE) {
        // Blam!
        var i = 0;
        if (has_problem("purge")) {
            _isquest = 1;
            _thequest = "purge";
            _questnum = i;
        }

        if (_isquest == 1) {
            if (_thequest == "purge" && action_score >= 10) {
                remove_problem("purge");

                alter_disposition(eFACTION.INQUISITION, obj_controller.demanding ? choose(0, 0, 1) : 1);

                _popup_text = "Your marines drop fast and hard, blowing through guards and mercenaries with minimal resistance.  Before ten minutes have passed all your targets are executed.";
                scr_event_log("", "Inquisition Mission Completed: The unruly Nobles of {name()} have been purged.");
                add_disposition(choose(1, 2, 3));
            }
        } else if (_isquest == 0) {
            // TODO add more variation, with planets, features, possibly marine equipment
            _popup_text = $"Your marines move across {name()},";
            _popup_text += choose($"searching for high profile targets. Once found, they are dragged outside from their lairs. Their execution would soon follow.", $"rooting out sources of corruption. Heretics are dragged from their lairs and executed in the streets.");

            _popup_text += _purge.population_death_string();
        }
    }

    if (action_type == eDROP_TYPE.PURGEASSASSINATE) {
        assasinate_governor_setup(action_score);
    } else if (action_type != eDROP_TYPE.PURGEASSASSINATE) {
        if (_isquest == 0) {
            // DO EET
            var _txt2 = _popup_text;
            switch (_purge.heres_target) {
                case "corruption":
                    alter_corruption(-_purge.influence_reduction);
                    break;
                case "tau":
                    alter_influence(eFACTION.TAU, -_purge.influence_reduction);
                    break;
                case "genestealers":
                    alter_influence(eFACTION.TYRANIDS, -_purge.influence_reduction);
                    break;
            }

            set_population(population_large_conversion(_purge.pop_after));

            var pip = instance_create(0, 0, obj_popup);
            pip.title = "Purge Results";
            pip.text = _txt2;
        }
        if (_isquest) {
            // DO EET
            var pip = instance_create(0, 0, obj_popup);
            scr_popup("Inquisition Mission Completed", _popup_text, "inquisition");
        }
    }

    if (instance_exists(obj_drop_select)) {
        with (obj_drop_select) {
            if (instance_exists(sh_target)) {
                sh_target.acted = 5;
            }
            instance_destroy();
        }
    }
}
