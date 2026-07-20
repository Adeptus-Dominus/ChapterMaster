// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function new_ork_fleet(xx, yy) {
    fleet = create_enemy_fleet(xx, yy, eFACTION.ORK); // upstream (eaf1ee3cc): central fleet creation/registration
    fleet.sprite_index = spr_fleet_ork;
    fleet.image_index = 1;
    fleet.capital_number = 1;
    fleet.frigate_number = 1;
    return fleet;
}

/// @function orks_end_turn_growth
/// @description Per-turn Ork upkeep for a system (§16e). The greenskins' GROWTH is now population-driven
///              (the Fungal Bloom, in end_turn_race_population_growth) — this NO LONGER touches the 0-6
///              level. It only ticks each world's Stronghold (build/tier-up/rot) and musters the occasional
///              expansion fleet, via ork_world_tick. Replaces the retired 0-6 grow_ork_forces() tick.
/// @self Asset.GMObject.obj_star
function orks_end_turn_growth() {
    for (var i = 1; i <= planets; i++) {
        ork_world_tick(id, i);
    }
}

/// @function ork_world_tick
/// @description One world's per-turn Ork upkeep: keep its Stronghold (capital building + ORKSTRONGHOLD
///              feature) in step with the Fungal Bloom, and — if it is an established, unthreatened Ork
///              holding — occasionally launch a WAAAGH fleet to spread. The horde's growth is the bloom's
///              job (population), not this.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function ork_world_tick(_star, _planet) {
    ork_sync_stronghold(_star, _planet);

    // Organic expansion: an Ork-held world whose Stronghold is well-built, with no Ork fleet already in
    // orbit, has a small chance to muster one (it wanders off to spread the bloom). Bigger holds and a live
    // WAAAGH launch more often. (Replaces the old grow_ork_forces ship logic; growth stays with the bloom.)
    if (_star.p_owner[_planet] != eFACTION.ORK) { return; }
    if (_star.p_type[_planet] == "Dead") { return; }
    var _pd = _star.get_planet_data(_planet);
    if (!_pd.has_feature(eP_FEATURES.ORKSTRONGHOLD)) { return; }
    var _sh = _pd.get_features(eP_FEATURES.ORKSTRONGHOLD)[0];
    if (_sh.tier < 2) { return; }                                       // only an established hold builds ships
    if (scr_orbiting_fleet(eFACTION.ORK, _star) != noone) { return; }   // already have a fleet here
    var _chance = 2 + floor(_sh.tier) * 2;                              // ~6-12%/turn
    if (obj_controller.known[eFACTION.ORK] > 0) { _chance += 4; }       // a live WAAAGH is more aggressive
    if (irandom(99) < _chance) {
        new_ork_fleet(_star.x, _star.y);
    }
}

function ork_fleet_move() {
    var hides = choose(1, 2, 3);

    repeat (hides) {
        instance_deactivate_object(instance_nearest(x, y, obj_star));
    }

    with (obj_star) {
        if (is_dead_star() || owner == eFACTION.ORK || scr_orbiting_fleet(eFACTION.ORK) != noone) {
            instance_deactivate_object(id);
        }
    }
    var nex = instance_nearest(x, y, obj_star);
    action_x = nex.x;
    action_y = nex.y;
    action = "";
    set_fleet_movement();

    instance_activate_object(obj_star);
    exit;
}

function ork_fleet_arrive_target() {
    instance_activate_object(obj_en_fleet);
    var _ork_fleet = scr_orbiting_fleet(eFACTION.ORK);
    if (_ork_fleet == noone) {
        return;
    }
    var aler = 0;

    var _imperial_ship = scr_orbiting_fleet([eFACTION.IMPERIUM, eFACTION.MECHANICUS]);
    if (_imperial_ship == noone && planets > 0 && !has_orbiting_player_fleet()) {
        var _allow_landing = true, ork_attack_planet = 0, l = 0;
        var _planets = shuffled_planet_array();
        for (var i = 0; i < array_length(_planets); i++) {
            l = _planets[i];
            if ((ork_attack_planet == 0) && (p_tyranids[l] > 0)) {
                ork_attack_planet = l;
                break;
            }
        }
        if (ork_attack_planet > 0) {
            p_tyranids[ork_attack_planet] -= floor(_ork_fleet.capital_number + (_ork_fleet.frigate_number / 2));

            var _pdata = get_planet_data(ork_attack_planet);

            //generate refugee ships to spread tyranids
            if (p_tyranids[ork_attack_planet] <= 0) {
                if (planet_feature_bool(p_feature[ork_attack_planet], eP_FEATURES.GENE_STEALER_CULT)) {
                    _pdata.delete_feature(eP_FEATURES.GENE_STEALER_CULT);
                    adjust_influence(eFACTION.TYRANIDS, -25, ork_attack_planet, self);
                    var nearest_imperial = nearest_star_with_ownership(x, y, eFACTION.IMPERIUM, self.id);
                    if (nearest_imperial != noone) {
                        var targ_planet = scr_get_planet_with_owner(nearest_imperial, eFACTION.IMPERIUM);
                        if (targ_planet == -1) {
                            targ_planet = irandom_range(1, nearest_imperial.planets);
                        }
                        _pdata.send_colony_ship(nearest_imperial.id, targ_planet, "refugee");
                    }
                }
            }
        }

        _allow_landing = !is_dead_star();
        var _fleet_persists = false;
        if (_allow_landing) {
            for (var i = 0; i < planets; i++) {
                var _planet = _planets[i];
                var _contested = (p_guardsmen[_planet] + p_pdf[_planet] + p_player[_planet] + p_traitors[_planet] + p_tau[_planet] > 0);
                var _open = ((p_owner[_planet] != 7) && (p_orks[_planet] <= 0));
                // Skip worlds whose bloom is already at its ceiling — let the fleet carry on and spread.
                var _saturated = variable_instance_exists(id, "p_race_pop")
                    ? (p_race_pop[_planet][eFACTION.ORK] >= ork_bloom_cap(p_type[_planet]))
                    : (p_orks[_planet] >= 6);
                if ((_contested || _open) && (p_type[_planet] != "Dead") && !_saturated) {
                    var _lpdata = get_planet_data(_planet);
                    // The WAAAGH plants (or reinforces) a growing FUNGAL BLOOM — POPULATION-driven, not a 0-6
                    // level. The bloom swells each turn (end_turn_race_population_growth) and the battle
                    // resolver does the conquering; a Warboss brings a whole army down with him.
                    if (!_lpdata.has_feature(eP_FEATURES.FUNGAL_BLOOM)) {
                        _lpdata.add_feature(eP_FEATURES.FUNGAL_BLOOM);
                    }
                    var _boss_landing = fleet_has_cargo("ork_warboss", _ork_fleet);
                    var _drop = ork_bloom_seed(p_type[_planet]) * (_boss_landing ? 8 : 1);
                    if (variable_instance_exists(id, "p_race_pop")) {
                        var _had_orks = (p_race_pop[_planet][eFACTION.ORK] > 0);
                        p_race_pop[_planet][eFACTION.ORK] += _drop;
                        p_orks[_planet] = count_to_level(eFACTION.ORK, p_race_pop[_planet][eFACTION.ORK]);
                        if (_had_orks) {
                            ork_add_landing_warband(id, _planet);   // incoming mob = another clan -> MIXING (§16g)
                        } else {
                            planet_ork_clans(id, _planet);          // fresh world -> a single pure founding clan
                        }
                    } else {
                        p_orks[_planet] = min(6, p_orks[_planet] + 2);   // pre-population save fallback
                    }
                    if (_boss_landing) {
                        array_push(p_feature[_planet], _ork_fleet.cargo_data.ork_warboss);
                        struct_remove(_ork_fleet.cargo_data, "ork_warboss");
                        _fleet_persists = true;
                    }
                    if (!_fleet_persists) {
                        with (_ork_fleet) {
                            instance_destroy();
                        }
                    }
                    aler = 1;
                    break;
                }
            }
        }

        if (aler > 0) {
            if (!_fleet_persists) {
                scr_alert("green", "owner", $"Ork ships have crashed across the {name} system.", x, y);
            } else {
                scr_alert("green", "owner", $"Ork ships Spill their ravenouss hordes accross {name} system and the green skin captains turn their guns towards the surface.", x, y);
            }
        } else {
            var new_wagh_star = distance_removed_star(x, y, choose(2, 3, 4, 5));
            if (instance_exists(new_wagh_star)) {
                with (_ork_fleet) {
                    action_x = new_wagh_star.x;
                    action_y = new_wagh_star.y;
                    action = "";
                    set_fleet_movement();
                }
            }
        }
    } // End _allow_landingng portion of code
}

//TOSO provide logic for fleets to attack each other
function merge_ork_fleets() {
    var _stars_with_ork_fleets = stars_with_faction_fleets(eFACTION.ORK);

    var _star_names = struct_get_names(_stars_with_ork_fleets);
    for (var i = 0; i < array_length(_star_names); i++) {
        var _fleets = _stars_with_ork_fleets[$ _star_names[i]];
        if (array_length(_fleets) <= 1) {
            continue;
        }
        var _base_fleet = _fleets[0];
        for (var f = 1; f < array_length(_fleets); f++) {
            merge_fleets(_base_fleet, _fleets[f]);
        }
    }
}

/// @function sector_ork_population
/// @description Total greenskin headcount across the entire sector — summed from every world's Ork race
///              population (p_race_pop[ORK]), Fungal Blooms still infesting other factions' worlds INCLUDED.
///              The true measure of the WAAAGH now that Orks are population-driven (§16c); replaces the old
///              count of Ork-owned stars.
/// @returns {Real}
function sector_ork_population() {
    var _total = 0;
    with (obj_star) {
        if (!variable_instance_exists(self, "p_race_pop")) { continue; }
        for (var i = 1; i <= planets; i++) {
            if (i < array_length(p_race_pop)) { _total += p_race_pop[i][eFACTION.ORK]; }
        }
    }
    return _total;
}

/// @function sector_ork_world_count
/// @description How many worlds carry any greenskin presence at all (bloom or holding) — used to spot the
///              "nearly scoured" state for a last-ditch WAAAGH. Population-driven (§16c).
/// @returns {Real}
function sector_ork_world_count() {
    var _n = 0;
    with (obj_star) {
        if (!variable_instance_exists(self, "p_race_pop")) { continue; }
        for (var i = 1; i <= planets; i++) {
            if ((i < array_length(p_race_pop)) && (p_race_pop[i][eFACTION.ORK] > 0)) { _n++; }
        }
    }
    return _n;
}

/// @function init_ork_waagh
/// @description Muster a sector WAAAGH! keyed to the TOTAL greenskin POPULATION (§16c), not the old count
///              of Ork-owned stars. A swelling Fungal Bloom infesting other factions' worlds can now spark
///              a WAAAGH before the Orks own a single system. Escalating bands: a grand WAAAGH once the tide
///              is sector-threatening, a rising one as it grows, a desperate push when nearly scoured. On
///              fire, a Warboss rises where the greenskins actually are (bloom or holding) and rallies the
///              local horde; if there is nowhere to plant him, a WAAAGH fleet warps in from the sector edge.
/// @param {Bool} override  force the muster (cheat / scripted)
function init_ork_waagh(override = false) {
    if ((obj_controller.known[eFACTION.ORK] != 0) && !override) { return; }   // already active / not dormant

    var _ork_pop = sector_ork_population();
    var _ork_worlds = sector_ork_world_count();
    if ((_ork_pop <= 0) && !override) { return; }        // no greenskins anywhere to rally

    // Escalating trigger keyed to the total greenskin headcount (bloom + holdings), not owned-star count.
    var _fire = false;
    var _msg = "";
    if (_ork_pop >= 100000000) {                         // >= 100M — a sector-wide menace
        _fire = override || (irandom(3) == 3);           // ~25% / turn
        _msg = "The greenskins have gone unchallenged for far too long. A towering Warboss has rallied the ork hordes and halted their infighting. Now unified, the greenskins pose a dire threat to the entire sector!";
    } else if (_ork_pop >= 5000000) {                    // 5M - 100M — a swelling menace
        _fire = override || (irandom(9) == 3);           // ~10% / turn
        _msg = "The greenskins have swelled in activity, their numbers increasing seemingly without relent. A massive Warboss has risen to take control, leading most of the sector's Orks on a massive WAAAGH!";
    } else if ((_ork_worlds > 0) && (_ork_worlds <= 5) && (_ork_pop < 1000000)) {   // nearly scoured
        _fire = override || (irandom(3) == 3);           // ~25% / turn — a desperate reclamation
        _msg = "The orks are nearly defeated, but in a final desperate push, a new Warboss has mustered a fresh WAAAGH! and begun reclaiming their lost worlds.";
    } else {                                             // still building — only a rare early spark
        _fire = override || (irandom(300) == 33);        // ~0.3% / turn
        _msg = "The greenskins have swelled in activity, their numbers increasing seemingly without relent. A massive Warboss has risen to take control, leading most of the sector's Orks on a massive WAAAGH!";
    }
    if (!_fire) { return; }

    scr_popup("WAAAAGH!", _msg, "waaagh", "");
    scr_event_log("red", "Ork WAAAAGH! begins.");
    obj_controller.known[eFACTION.ORK] = 0.5;

    // Ork shipyards churn — but only on worlds the Orks actually HOLD (they need the docks).
    var _ork_stars = scr_get_stars(false, [eFACTION.ORK]);
    for (var p = 0; p < array_length(_ork_stars); p++) {
        with (_ork_stars[p]) {
            for (var i = 1; i <= planets; i++) { ork_ship_production(i); }
        }
    }

    // The Warboss rises where the greenskins ARE — scan the whole sector by population, preferring a world
    // with no Imperial garrison to contest him (bloom worlds qualify).
    var _cands = [];
    var _cands_clear = [];
    with (obj_star) {
        if (!variable_instance_exists(self, "p_race_pop")) { continue; }
        for (var i = 1; i <= planets; i++) {
            if (i >= array_length(p_race_pop)) { continue; }
            if (p_race_pop[i][eFACTION.ORK] > 0) {
                array_push(_cands, [id, i]);
                if ((p_pdf[i] == 0) && (p_guardsmen[i] == 0)) { array_push(_cands_clear, [id, i]); }
            }
        }
    }

    var _pick = noone;
    if (array_length(_cands_clear) > 0)     { _pick = array_random_element(_cands_clear); }
    else if (array_length(_cands) > 0)      { _pick = array_random_element(_cands); }

    if (_pick != noone) {
        var _pstar = _pick[0];
        var _pplan = _pick[1];
        var _pdata = _pstar.get_planet_data(_pplan);
        var _boss = _pdata.add_feature(eP_FEATURES.ORKWARBOSS);
        if (override) { _boss.player_hidden = false; }
        // The Warboss rallies the local horde — boyz boil out of the spore-fields to follow him (a real
        // population surge, not a 0-6 level bump).
        if (variable_instance_exists(_pstar, "p_race_pop")) {
            _pstar.p_race_pop[_pplan][eFACTION.ORK] = round(_pstar.p_race_pop[_pplan][eFACTION.ORK] * 1.5);
            _pstar.p_orks[_pplan] = count_to_level(eFACTION.ORK, _pstar.p_race_pop[_pplan][eFACTION.ORK]);
        }
        var _lead_wb = ork_leading_warband(_pstar, _pplan);
        // Upstream (3f12e177d): a fresh Warboss revives a defeated ork faction.
        // Adapted to the fork's warband system: the faction leader takes the leading
        // warband boss's name so it matches the announcement below.
        with (obj_controller) {
            if (faction_defeated[7] == 1) {
                faction_leader[eFACTION.ORK] = ork_wb_boss(_lead_wb);
                faction_title[7] = "Warboss";
                faction_status[eFACTION.ORK] = "War";
                scr_audience(eFACTION.ORK, "new_warboss", -40, "War", 0, 2);
            }
        }
        scr_popup("WAAAAGH!", "My lord, our Auspex scans indicate that Warboss " + ork_wb_boss(_lead_wb) + " leading " + _lead_wb.name + " is rallying a WAAAGH within the " + string(_pdata.system.name) + " system. We must strike swiftly before he relocates.", "waaagh", "");
        scr_event_log("red", $"Warboss {ork_wb_boss(_lead_wb)} ({_lead_wb.name}) on {_pdata.name()}", _pdata.system.name);
    } else {
        out_of_system_warboss(true);   // greenskins present but nowhere to plant him — warp a WAAAGH fleet in
    }
}

function out_of_system_warboss(overide = false) {
    with (obj_controller) {
        // More Testing
        // peace_check=2;

        var did_so = false;

        if ((did_so == false) && (faction_defeated[7] == 1 || known[eFACTION.ORK] == 0 || overide)) {
            known[eFACTION.ORK] = 0;
            var _warboss = new NewPlanetFeature(eP_FEATURES.ORKWARBOSS);
            if (faction_defeated[7] == 1) {
                faction_defeated[7] = -1;
                faction_leader[eFACTION.ORK] = _warboss.name;
                faction_title[7] = "Warboss";
                faction_status[eFACTION.ORK] = "War";
                scr_audience(eFACTION.ORK, "new_warboss", -40, "War", 0, 2);
            } else {
                known[eFACTION.ORK] = 0.5;
            }

            var gold = faction_gender[7];
            if (gold == 0) {
                gold = 1;
            }
            var gnew = 0;
            repeat (20) {
                if (gnew == 0 || gnew == gold) {
                    gnew = choose(1, 2, 3, 4);
                }
            }
            faction_gender[7] = gnew;
            starf = 0;

            var x3 = 0, y3 = 0, fnum = 0;

            var side = choose("left", "right", "up", "down");
            if (side == "left") {
                y3 = floor(random_range(0, room_height)) + 1;
            }
            if (side == "right") {
                y3 = floor(random_range(0, room_height)) + 1;
                x3 = room_width;
            }
            if (side == "up") {
                x3 = floor(random_range(0, room_width)) + 1;
            }
            if (side == "down") {
                x3 = floor(random_range(0, room_width)) + 1;
                y3 = room_height;
            }

            //lots of this can be wrapped into a single with
            with (obj_star) {
                if (owner == eFACTION.ELDAR) {
                    instance_deactivate_object(id);
                    continue;
                }
                if (is_dead_star() || planets == 0) {
                    instance_deactivate_object(id);
                    continue;
                }
            }

            repeat (8) {
                fnum += 1;
                var x4, y4, dire;
                x4 = 0;
                y4 = 0;
                dire = 0;
                if (fnum == 1) {
                    dire = point_direction(x4, y4, room_width / 2, room_height / 2);
                    x4 = x3 + lengthdir_x(60, dire);
                    y4 = y3 + lengthdir_y(60, dire);
                }
                if (fnum > 1) {
                    dire = point_direction(x4, y4, room_width / 2, room_height / 2);
                    x4 = x3 + choose(round(random_range(30, 50)), round(random_range(-30, -50)));
                    y4 = y3 + choose(round(random_range(30, 50)), round(random_range(-30, -50)));
                }

                var _nfleet = new_ork_fleet(x4, y4);
                var tplan = instance_nearest(_nfleet.x, _nfleet.y, obj_star);
                _nfleet.action_x = tplan.x;
                _nfleet.action_y = tplan.y;
                if (fnum == 1) {
                    starf = tplan;
                    _nfleet.cargo_data.ork_warboss = _warboss;
                }
                with (_nfleet) {
                    frigate_number = 10;
                    capital_number = 4;
                    set_fleet_movement();
                }
                instance_deactivate_object(tplan.id);
            }

            instance_activate_object(obj_star);
            instance_activate_object(obj_en_fleet);

            var _ork_leader = obj_controller.faction_leader[eFACTION.ORK];
            var tix = $"Warboss {_ork_leader} leads a WAAAGH! into Sector {obj_ini.sector_name}.";
            scr_alert("red", "lol", string(tix), starf.x, starf.y);
            scr_event_log("red", tix);
            scr_popup("WAAAAGH!", $"A WAAAGH! led by the Warboss {_ork_leader} has arrived in {obj_ini.sector_name}.  With him is a massive Ork fleet.  Numbering in the dozens of battleships, they carry with them countless greenskins.  The forefront of the WAAAGH! is destined for the {starf.name} system.", "waaagh", "");
        }
    }
}
