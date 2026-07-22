function new_colony_fleet(doner_star, doner_planet, target, target_planet, mission = "new_colony") {
    var new_colonise_fleet = create_enemy_fleet(doner_star.x, doner_star.y, eFACTION.IMPERIUM);
    new_colonise_fleet.sprite_index = spr_fleet_civilian;
    new_colonise_fleet.image_index = 3;
    new_colonise_fleet.warp_able = false;

    LOGGER.debug($"{doner_star.name}, {doner_planet}, {target.name}, {target_planet}");
    var doner_volume = 0;
    if (doner_star.p_large[doner_planet]) {
        doner_volume = (doner_star.p_population[doner_planet] * 0.01) * power(10, 8);
        doner_star.p_population[doner_planet] *= 0.99;
    } else {
        doner_volume = doner_star.p_population[doner_planet] * 0.1;
        doner_star.p_population[doner_planet] *= 0.90;
    }

    // Colonists carry their homeworld's taint (§16k): a corrupt or cult-infested origin plants that rot at
    // the new colony, so hidden heretic cults spread world-to-world through the colony ships. (Genestealer
    // cults already ride along via colonist_influence / merge_influences below.)
    var _donor_corr = variable_instance_exists(doner_star, "p_heresy") ? doner_star.p_heresy[doner_planet] : 0;
    var _donor_cult = false;
    try {
        var _dpd = doner_star.get_planet_data(doner_planet);
        _donor_cult = _dpd.has_feature(eP_FEATURES.HERETIC_ACTIVITY) || _dpd.has_feature(eP_FEATURES.GENE_STEALER_CULT);
    } catch (_e) { _donor_cult = false; }

    var new_cargo = {
        colonists: doner_volume,
        mission: mission,
        target_planet: target_planet,
        colonist_influence: doner_star.p_influence[doner_planet],
        corruption: _donor_corr,
        cult: _donor_cult,
    };

    new_colonise_fleet.trade_goods = "colonize";
    //TODO flesh out colonisation efforts
    if (doner_star.p_population[target_planet] && doner_star.p_type[doner_planet] == "Hive") {
        new_colonise_fleet.image_index = 3;
    } else {
        new_colonise_fleet.image_index = choose(1, 2);
    }

    new_colonise_fleet.cargo_data.colonize = new_cargo;

    new_colonise_fleet.action_x = target.x;
    new_colonise_fleet.action_y = target.y;
    new_colonise_fleet.target = target;
    with (new_colonise_fleet) {
        set_fleet_movement();
    }
    scr_event_log("green", $"New colony fleet departs from {doner_star.name}. for the {target.name} system", doner_star.name);
}

function fleet_has_cargo(desired_cargo, fleet = noone) {
    if (fleet == noone) {
        return struct_exists(cargo_data, desired_cargo);
    } else {
        var has_cargo = false;
        with (fleet) {
            has_cargo = fleet_has_cargo(desired_cargo);
        }
        return has_cargo;
    }
}

function fleet_add_cargo(new_cargo, data, overwrite = false, fleet = noone) {
    if (fleet == noone) {
        var _add = true;
        if (fleet_has_cargo(new_cargo) && !overwrite) {
            _add = false;
        }

        if (_add) {
            cargo_data[$ new_cargo] = data;
        }
    } else {
        with (fleet) {
            fleet_add_cargo(new_cargo, data, overwrite);
        }
    }
}

//TODO integrate this into PlanetData constructor
function deploy_colonisers(star) {
    var lag = 1;

    var data = cargo_data.colonize;
    if (data.target_planet > 0) {
        var targ_planet = data.target_planet;
        if (!star.p_large[targ_planet]) {
            star.p_population[targ_planet] += data.colonists;
        } else {
            star.p_population[targ_planet] += data.colonists / power(10, 8);
        }
        var start_influ = star.p_influence[targ_planet][eFACTION.TYRANIDS];
        with (star) {
            merge_influences(data.colonist_influence, targ_planet);
        }
        var colony_purpose = data.mission == "new_colony" ? "recolonise" : "bolster population";
        var alert_string = $"Imperial citizens {colony_purpose} {planet_numeral_name(targ_planet, star)} I.";
        var player_vision = star.p_player[targ_planet] > 0 || star.p_owner[targ_planet] == eFACTION.PLAYER;
        if (star.p_influence[targ_planet][eFACTION.TYRANIDS] > start_influ && player_vision) {
            alert_string += " They bring with them traces of a Genestelar Cult";
        }
        // Heretic taint rides the colony ships too (§16k): a cult-bearing origin plants a strong dose of
        // corruption at the new colony (which grows its own hidden cult once past the corruption floor); a
        // heavily-corrupted-but-uninfested origin passes on a lighter dose. Clean worlds spread nothing.
        if (variable_struct_exists(data, "corruption") && variable_instance_exists(star, "p_heresy")) {
            var _carry = (variable_struct_exists(data, "cult") && data.cult) ? round(data.corruption * 0.6)
                       : ((data.corruption >= 25) ? round(data.corruption * 0.3) : 0);
            if (_carry > 0) {
                star.p_heresy[targ_planet] = min(100, star.p_heresy[targ_planet] + _carry);
                if (player_vision) { alert_string += " Dark whispers move among the new arrivals."; }
                // The god spreads along the trade routes (§16r): the arriving cell carries its home world's
                // god, so the cult that grows here later swears to the same god (unless already assigned).
                if (variable_struct_exists(data, "chaos_god") && (data.chaos_god >= 0) && variable_instance_exists(star, "p_chaos_god")) {
                    if (star.p_chaos_god[targ_planet] < 0) { star.p_chaos_god[targ_planet] = data.chaos_god; }
                }
            }
        }
        scr_alert("green", "duhuhuhu", alert_string, star.x, star.y);
    } else {
        for (var r = 1; r <= star.planets; r++) {
            if (data.mission == "new_colony" && star.p_population[r] <= 0) {
                continue;
            }
            //TODO sort out some of the issues of this regarding difference with large and small planet populations
            if ((star.p_type[r] != "") && (star.p_type[r] != "Dead")) {
                if (lag == 1) {
                    star.p_population[r] += data.colonists;
                    star.p_large[r] = 0;
                    guardsmen = 0;
                } else if (lag == 2) {
                    star.p_population[r] += data.colonists;
                    star.p_large[r] = 1;
                    guardsmen = 0;
                }

                scr_alert("green", "duhuhuhu", $"Imperial citizens recolonize {planet_numeral_name(r, star)} I.", star.x, star.y);

                star.dispo[r] = min(obj_ini.imperium_disposition, obj_controller.disposition[2]) + irandom_range(-4, 4);
                if ((star.name == obj_ini.home_name) && (star.p_type[r] == obj_ini.home_type) && (obj_controller.homeworld_rule != 1)) {
                    star.dispo[r] = -5000;
                }
            }
        }
    }
    if (struct_exists(cargo_data, "colonize")) {
        struct_remove(cargo_data, "colonize");
    }
}
