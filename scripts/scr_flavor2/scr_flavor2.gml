/// @self Id.Instance.obj_pnunit|Id.Instance.obj_enunit
// Merge seam: the fork's damage-severity reporting (scr_clean passes severity and
// a vehicle flag; used by the armour-held flavor below) rides on upstream's rebuilt
// log. Parameters restored with safe defaults.
function scr_flavor2(lost_units_count, target_type, hostile_range, hostile_weapon, hostile_shots, hostile_splash, damage_severity = 0, target_is_vehicle = false) {
    // Generates flavor based on the damage and casualties from scr_shoot, only for the opponent

    if (obj_ncombat.wall_destroyed == 1) {
        exit;
    }

    var mes = "";
    var m1 = "";
    var m2 = "";
    var m3 = "";
    var mes_color = eMSG_COLOR.DEFAULT;

    var _hostile_range, _hostile_weapon, _hostile_shots;
    _hostile_range = 0;
    _hostile_weapon = "";
    _hostile_shots = 0;

    if (target_type != "wall") {
        _hostile_range = hostile_range;
        _hostile_weapon = hostile_weapon;
        _hostile_shots = hostile_shots;
    } else if ((target_type == "wall") && instance_exists(obj_nfort)) {
        var hehh;
        hehh = "the fortification";

        _hostile_range = 999;
        _hostile_weapon = obj_nfort.hostile_weapons;
        _hostile_shots = obj_nfort.hostile_shots;
    }

    if (_hostile_weapon == "Fleshborer") {
        _hostile_shots = _hostile_shots * 10;
    }
    if (hostile_splash == 1) {
        _hostile_shots = max(1, round(_hostile_shots / 3));
    }

    // A resolution that attributed no unit at all (damage_data.unit_type left empty:
    // the shot landed on a block whose relevant pool was already gone) produces
    // "X strikes at ." lines. They carry no information; skip them entirely.
    if ((target_type == "") && (lost_units_count == 0)) {
        exit;
    }

    // Target readout: the bare unit name ("strikes at Assault") says nothing about what
    // was hit or how many stand there. Append the block's living strength for that unit
    // type. scr_flavor2 runs in the target block's own scope, so the arrays are directly
    // readable. Only the "wall" comparisons below care about the raw value, and walls
    // are never modified here.
    if ((target_type != "wall") && is_string(target_type) && (target_type != "")) {
        var _target_count = 0;
        if (target_is_vehicle) {
            if (variable_instance_exists(id, "veh_type")) {
                for (var _tc = 0; _tc < array_length(veh_type); _tc++) {
                    if ((veh_type[_tc] == target_type) && (_tc < array_length(veh_dead)) && (veh_dead[_tc] == 0) && (_tc < array_length(veh_hp)) && (veh_hp[_tc] > 0)) {
                        _target_count++;
                    }
                }
            }
            if (_target_count > 0) {
                target_type = $"{target_type} ({_target_count} remaining)";
            }
        } else if (target_type == "Imperial Guardsman") {
            if (variable_instance_exists(id, "men") && (men > 0)) {
                target_type = $"{target_type} ranks ({men} strong)";
            }
        } else if (variable_instance_exists(id, "marine_type")) {
            for (var _tc = 0; _tc < array_length(marine_type); _tc++) {
                if ((marine_type[_tc] == target_type) && (_tc < array_length(marine_dead)) && (marine_dead[_tc] == 0)) {
                    _target_count++;
                }
            }
            if (_target_count > 0) {
                target_type = $"{target_type} ranks ({_target_count} strong)";
            }
        }
    }

    var flavor = 0;

    if (_hostile_weapon == "Daemonette Melee") {
        flavor = 1;
        if (_hostile_shots > 1) {
            m1 = $"{_hostile_shots} Daemonettes rake and claw at {target_type}.  ";
        }
        if (_hostile_shots == 1) {
            m1 = $"A Daemonette rakes and claws at {target_type}.  ";
        }
    }
    if (_hostile_weapon == "Plaguebearer Melee") {
        flavor = 1;
        if (_hostile_shots > 1) {
            m1 = $"{_hostile_shots} Plague Swords slash into {target_type}.  ";
        }
        if (_hostile_shots == 1) {
            m1 = $"A Plaguesword is swung into {target_type}.  ";
        }
    }
    if (_hostile_weapon == "Bloodletter Melee") {
        flavor = 1;
        if (_hostile_shots > 1) {
            m1 = $"{_hostile_shots} Hellblades hiss and slash into {target_type}.  ";
        }
        if (_hostile_shots == 1) {
            m1 = $"A Bloodletter swings a Hellblade into {target_type}.  ";
        }
    }
    if (_hostile_weapon == "Nurgle Vomit") {
        flavor = 1;
        if (_hostile_shots > 1) {
            m1 = $"{_hostile_shots} putrid, corrosive streams of Daemonic vomit spew into {target_type}.  ";
        }
        if (_hostile_shots == 1) {
            m1 = $"A putrid, corrosive stream of Daemonic vomit spews into {target_type}.  ";
        }
    }
    if (_hostile_weapon == "Maulerfiend Claws") {
        flavor = 1;
        if (_hostile_shots > 1) {
            m1 = $"{_hostile_shots} Maulerfiends advance, wrenching and smashing their claws into {target_type}.  ";
        }
        if (_hostile_shots == 1) {
            m1 = $"A Maulerfiend advances, wrenching and smashing its claws into {target_type}.  ";
        }
    }

    if (hostile_range > 1) {
        if (_hostile_weapon == "Big Shoota") {
            m1 = $"{_hostile_shots} {_hostile_weapon}z roar and blast away at {target_type}.  ";
            flavor = 1;
        }
        if (_hostile_weapon == "Dakkagun") {
            m1 = $"{_hostile_shots} {_hostile_weapon}z scream and rattle, blasting into {target_type}.  ";
            flavor = 1;
        }
        if (_hostile_weapon == "Deffgun") {
            m1 = $"{_hostile_shots} {_hostile_weapon}z scream and rattle, blasting into {target_type}.  ";
            flavor = 1;
        }
        if (_hostile_weapon == "Snazzgun") {
            m1 = $"{_hostile_shots} {_hostile_weapon}z scream and rattle, blasting into {target_type}.  ";
            flavor = 1;
        }
        if (_hostile_weapon == "Grot Blasta") {
            m1 = $"The Gretchin fire their shoddy weapons and club at your {target_type}.  ";
            flavor = 1;
        }
        if (_hostile_weapon == "Kannon") {
            flavor = 1;
            if (_hostile_shots > 1) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z belch out large caliber shells at {target_type}.  ";
            }
            if (_hostile_shots == 1) {
                m1 = $"A {_hostile_weapon}z belches out a large caliber shell at {target_type}.  ";
            }
        }
        if (_hostile_weapon == "Shoota") {
            flavor = 1;
            var ranz = choose(1, 2, 3, 4);
            if (ranz == 1) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z fire away at {target_type}.  ";
            }
            if (ranz == 2) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z spit lead at {target_type}.  ";
            }
            if (ranz == 3) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z blast at {target_type}.  ";
            }
            if (ranz == 4) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z roar and fire at {target_type}.  ";
            }
        }
        if (_hostile_weapon == "Burna") {
            m1 = $"{_hostile_shots} {_hostile_weapon}z spray napalm into {target_type}.  ";
            flavor = 1;
        }
        if (_hostile_weapon == "Skorcha") {
            m1 = $"{_hostile_shots} {_hostile_weapon}z spray huge gouts of napalm into {target_type}.  ";
            flavor = 1;
        }
        if (_hostile_weapon == "Rokkit Launcha") {
            flavor = 1;
            var ranz;
            ranz = choose(1, 2, 2, 3, 3);
            if (ranz == 1) {
                m1 = $"{_hostile_shots} rokkitz shoot at {target_type}, the explosions disrupting.  ";
            }
            if (ranz == 2) {
                m1 = $"{_hostile_shots} rokkitz scream upward and then fall upon {target_type}.  ";
            }
            if (ranz == 3) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z roar and fire their payloads at {target_type}.  ";
            }
        }

        if ((_hostile_weapon == "Staff of Light Shooting") && (_hostile_shots == 1)) {
            m1 = $"A Staff of Light crackles with energy and fires upon {target_type}.  ";
            flavor = 1;
        }
        if ((_hostile_weapon == "Staff of Light Shooting") && (_hostile_shots > 1)) {
            m1 = $"{_hostile_shots} Staves of Light crackle with energy and fire upon {target_type}.  ";
            flavor = 1;
        }
        if ((_hostile_weapon == "Gauss Flayer") || (_hostile_weapon == "Gauss Blaster") || (_hostile_weapon == "Gauss Flayer Array")) {
            flavor = 1;
            var ranz;
            ranz = choose(1, 2, 3, 4);
            if (ranz == 1) {
                m1 = $"{_hostile_shots} {_hostile_weapon}s shoot at {target_type}.  ";
            }
            if (ranz == 2) {
                m1 = $"{_hostile_shots} {_hostile_weapon}s crackle and fire at {target_type}.  ";
            }
            if (ranz == 3) {
                m1 = $"{_hostile_shots} {_hostile_weapon}s discharge upon {target_type}.  ";
            }
            if (ranz == 4) {
                m1 = $"{_hostile_shots} {_hostile_weapon}s spew green energy at {target_type}.  ";
            }
        }
        if ((_hostile_weapon == "Gauss Cannon") || (_hostile_weapon == "Overcharged Gauss Cannon") || (_hostile_weapon == "Gauss Flux Arc")) {
            flavor = 1;
            var ranz;
            ranz = choose(1, 2, 3);
            if (ranz == 1) {
                m1 = $"{_hostile_shots} {_hostile_weapon}s charge and then blast at {target_type}.  ";
            }
            if (ranz == 2) {
                m1 = $"{_hostile_shots} {_hostile_weapon}s crackle with a sick amount of energy before firing at {target_type}.  ";
            }
            if (ranz == 3) {
                m1 = $"{_hostile_shots} {_hostile_weapon}s pulse with energy and then discharge upon {target_type}.  ";
            }
        }
        if (_hostile_weapon == "Gauss Particle Cannon") {
            flavor = 1;
            m1 = $"{_hostile_shots} {_hostile_weapon}s shine a sick green, pulsing with energy, and then blast solid beams of energy into {target_type}.  ";
        }
        if (_hostile_weapon == "Particle Whip") {
            flavor = 1;
            if (_hostile_shots == 1) {
                m1 = $"The apex of the Monolith pulses with energy.  An instant layer it fires, the solid beam of energy crashing into {target_type}.  ";
            }
            if (_hostile_shots > 1) {
                m1 = $"The apex of {_hostile_shots} Monoliths pulse with energy.  An instant later they fire, the solid beams of energy crashing into {target_type}.  ";
            }
        }
        if (_hostile_weapon == "Doomsday Cannon") {
            flavor = 1;
            if (_hostile_shots == 1) {
                m1 = $"A Doomsday Arc crackles with energy and then fires at {target_type}.  The resulting blast is blinding in intensity, the ground shaking before its might.  ";
            }
            if (_hostile_shots > 1) {
                m1 = $"{_hostile_shots} Doomsday Arcs crackle with energy and then fire at {target_type}.  The resulting blasts are blinding in intensity, the ground shaking.  ";
            }
        }

        if (_hostile_weapon == "Eldritch Fire") {
            flavor = 1;
            if (_hostile_shots == 1) {
                m1 = $"A Pink Horror spits out a globlet of bright energy.  The bolt smashes into {target_type}.  ";
            }
            if (_hostile_shots > 1) {
                m1 = $"{_hostile_shots} Pink Horrors spit and throw bolts of warp energy into {target_type}.  ";
            }
        }
    }

    if (_hostile_shots > 0) {
        if (_hostile_weapon == "Choppa") {
            m1 = $"{_hostile_shots} {_hostile_weapon}z cleave into {target_type}.  ";
            flavor = 1;
        }
        if (_hostile_weapon == "Power Klaw") {
            m1 = $"{_hostile_shots} {_hostile_weapon}z rip and tear at {target_type}.  ";
            flavor = 1;
        }
        if (_hostile_weapon == "Venom Claws") {
            if (_hostile_shots > 1) {
                m1 = $"{_hostile_shots} {_hostile_weapon} rake at {target_type}.  ";
            }
            flavor = 1;
            if (_hostile_shots == 1) {
                m1 = $"The Spyrer rakes at {target_type} with his {_hostile_weapon}.  ";
            }
            flavor = 1;
        }
        if (_hostile_weapon == "Slugga") {
            flavor = 1;
            var ranz = choose(1, 2, 3, 4);
            if (ranz == 1) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z fire away at {target_type}.  ";
            }
            if (ranz == 2) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z spit lead at {target_type}.  ";
            }
            if (ranz == 3) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z blast at {target_type}.  ";
            }
            if (ranz == 4) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z roar and fire at {target_type}.  ";
            }
        }
        if (_hostile_weapon == "Tankbusta Bomb") {
            flavor = 1;
            var ranz;
            ranz = choose(1, 2, 3);
            if (ranz == 1) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z are attached to {target_type}.  ";
            }
            if (ranz == 2) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z are clamped onto {target_type}.  ";
            }
            if (ranz == 3) {
                m1 = $"{_hostile_shots} {_hostile_weapon}z are flung into {target_type}.  ";
            }
        }
        if ((_hostile_weapon == "Melee1") && (obj_ncombat.enemy == eFACTION.ORK)) {
            flavor = 1;
            var ranz = choose(1, 2, 3);
            if (ranz == 1) {
                m1 = $"{_hostile_shots} Orks club and smash at {target_type}.  ";
            }
            if (ranz == 2) {
                m1 = $"{_hostile_shots} Orks shoot their Slugas and smash gunbarrels into {target_type}.  ";
            }
            if (ranz == 3) {
                m1 = $"{_hostile_shots} Orks claw and punch at {target_type}.  ";
            }
        }

        if (_hostile_weapon == "Staff of Light") {
            flavor = 1;
            if (_hostile_shots == 1) {
                var ranz = choose(1, 2, 3);
                if (ranz == 1) {
                    m1 = $"A {_hostile_weapon} crackles and is swung into {target_type}.  ";
                }
                if (ranz == 2) {
                    m1 = $"A {_hostile_weapon} pulses and smashes through {target_type}.  ";
                }
                if (ranz == 3) {
                    m1 = $"A {_hostile_weapon} crackles and smashes into {target_type}.  ";
                }
            }
            if (_hostile_shots > 1) {
                var ranz = choose(1, 2, 3);
                if (ranz == 1) {
                    m1 = $"{_hostile_shots} Staves of Light strike at {target_type}.  ";
                }
                if (ranz == 2) {
                    m1 = $"{_hostile_shots} Staves of Light smash at {target_type}.  ";
                }
                if (ranz == 3) {
                    m1 = $"{_hostile_shots} Staves of Light swing into {target_type}.  ";
                }
            }
        }
        if (_hostile_weapon == "Warscythe") {
            flavor = 1;
            var ranz = choose(1, 2, 3);
            if (ranz == 1) {
                m1 = $"{_hostile_shots} Warscythes strike at {target_type}.  ";
            }
            if (ranz == 2) {
                m1 = $"{_hostile_shots} Warscythes of Light slice into {target_type}.  ";
            }
            if (ranz == 3) {
                m1 = $"{_hostile_shots} Warscythes of Light hew {target_type}.  ";
            }
        }
        if (_hostile_weapon == "Claws") {
            flavor = 1;
            if (_hostile_shots == 1) {
                var ranz = choose(1, 2, 3);
                if (ranz == 1) {
                    m1 = $"A massive claw slices through {target_type}.  ";
                }
                if (ranz == 2) {
                    m1 = $"A razor-sharp claw slashes into {target_type}.  ";
                }
                if (ranz == 3) {
                    m1 = $"A large necron claw strikes at {target_type}.  ";
                }
            }
            if (_hostile_shots > 1) {
                var ranz = choose(1, 2, 3);
                if (ranz == 1) {
                    m1 = $"{_hostile_shots} massive claws strike and slice at {target_type}.  ";
                }
                if (ranz == 2) {
                    m1 = $"{_hostile_shots} razor-sharp claws assault {target_type}.  ";
                }
                if (ranz == 3) {
                    m1 = $"{_hostile_shots} large necron claws strike at and shred {target_type}.  ";
                }
            }
        }
    }

    if (flavor == 0 && string_contains("RAM", _hostile_weapon)) {
        flavor = 1;
        if (_hostile_shots == 1) {
            m1 = $"A vehicle thunders forward, armoured hulls crashing into {target_type}.  ";
        } else {
            m1 = $"An armoured column of {_hostile_shots} vehicles smashes into {target_type}, grinding everything in its path.  ";
        }
    }

    if (flavor == 0) {
        flavor = true;
        if (_hostile_shots == 1) {
            m1 += $"{_hostile_weapon} strikes at {target_type}.  ";
        } else {
            m1 += $"{_hostile_shots} {_hostile_weapon}s strike at {target_type}.  ";
        }
    }

    if (target_type == "wall") {
        var _wall_destroyed = obj_nfort.hp <= 0 ? true : false;

        if (_wall_destroyed) {
            mes_color = eMSG_COLOR.RED;
            mes = m1 + " Destroying the fortifications.";
            obj_ncombat.dead_jims += 1;
            obj_ncombat.dead_jim[obj_ncombat.dead_jims] = "The fortified wall has been breached!";
            obj_ncombat.wall_destroyed = 1;
            with (obj_nfort) {
                instance_destroy();
            }
        } else {
            mes = m1 + " Fortifications stand strong.";
        }

        obj_ncombat.combat_log.push(mes, mes_color);
        obj_ncombat.alarm[3] = 2;

        exit;
    }

    var marine_length = array_length(marine_type);
    var s, him, special, unit, unit_role, units_lost, plural;
    var lost_roles_count = array_length(lost);
    for (var role_index = 0; role_index < lost_roles_count; role_index++) {
        unit_role = lost[role_index];
        units_lost = lost_num[role_index];
        if (unit_role != "" && units_lost > 0) {
            mes_color = eMSG_COLOR.RED;
            special = is_specialist(unit_role, SPECIALISTS_HEADS) || unit_role == obj_ini.role[100][eROLE.CHAPTERMASTER] || unit_role == "Venerable " + string(obj_ini.role[100][eROLE.DREADNOUGHT]) || unit_role == obj_ini.role[100][eROLE.CAPTAIN] || obj_ncombat.player_max <= 6;

            if (!special) {
                var _plural_name = unit_role;
                if (units_lost > 1) {
                    _plural_name = (unit_role == "Guardsman") ? "Guardsmen" : (unit_role + "s");
                }
                m2 += $"{units_lost} {_plural_name}, ";
            } else {
                him = -1; // Find which unit this is
                for (var marine = 0; marine < marine_length; marine++) {
                    if (marine_type[marine] == unit_role && marine_hp[marine] <= 0) {
                        him = marine;
                        break; // found the unit
                    }
                }

                if (him != -1) {
                    // found a valid unit
                    obj_ncombat.dead_jims += 1;
                    if (marine_type[him] == obj_ini.role[100][5]) {
                        obj_ncombat.dead_jim[obj_ncombat.dead_jims] = $"A {marine_type[him]} has been lost!";
                    } else {
                        obj_ncombat.dead_jim[obj_ncombat.dead_jims] = $"{unit_struct[him].name_role()} has been lost!";
                    }
                }
            }
        }
    }

    lost = [];
    lost_num = [];

    var unce = 0;

    if (string_count(", ", m2) > 1) {
        var lis = string_rpos(", ", m2);
        m2 = string_delete(m2, lis, 3); // This clears the last ', ' and replaces it with the end statement
        if (lost_units_count > 0) {
            m2 += " lost.";
        }

        lis = string_rpos(", ", m2); // Find the new last ', ' and replace it with the and part
        m2 = string_delete(m2, lis, 2);

        if (string_count(",", m2) > 1) {
            m2 = string_insert(", and ", m2, lis);
        }
        if (string_count(",", m2) == 0) {
            m2 = string_insert(" and ", m2, lis);
        }

        unce = 1;
    }

    if ((string_count(", ", m2) == 1) && (unce == 0) && (hostile_weapon != "Web Spinner")) {
        var lis = string_rpos(", ", m2);
        m2 = string_delete(m2, lis, 3);
        if (lost_units_count > 0) {
            m2 += " lost.";
        }
    }
    if ((string_count(", ", m2) == 1) && (unce == 0) && (hostile_weapon == "Web Spinner")) {
        var lis = string_rpos(", ", m2);
        m2 = string_delete(m2, lis, 3);
        if (lost_units_count > 1) {
            m2 += " have been incapacitated.";
        }
        if (lost_units_count == 1) {
            m2 += " has been incapacitated.";
        }
    }

    // No kills but the attack connected: report the damage instead of a bare attack verb, scaled by
    // how close it came to a kill. Severity is 0 for targets that do not track it (e.g. guardsmen),
    // which lands on the lowest tier.
    if ((m2 == "") && (lost_units_count == 0) && (hostile_shots > 0) && (target_type != "wall")) {
        m2 = incoming_damage_flavor(damage_severity, target_is_vehicle);
        // Enemy fire reads in the red family, mirroring the player's green. A shot that
        // bounces with no effect renders grey (neutral, same as armour-holds on both
        // sides); a hit that wounds or pierces without killing renders bright red so
        // incoming damage stands out as a threat rather than borrowing the player's
        // light green. (Colour paradigm: green/light green = you dealing damage,
        // red/bright red = the enemy dealing damage, grey = a save with no effect.)
        mes_color = (damage_severity < 0.10) ? eMSG_COLOR.WHITE : eMSG_COLOR.BRIGHT_RED;
    }

    mes = m1 + m2 + m3;

    if (string_length(mes) > 3) {
        obj_ncombat.combat_log.push(mes, mes_color);
        obj_ncombat.alarm[3] = 2;
    }
}


// Merge seam: fork-owned severity flavor (restored complete from the pre-merge
// tree; the first restoration appended a truncated fragment that broke the whole
// script's parse, degrading scr_flavor2 to a zero-argument function).
/// @function incoming_damage_flavor
/// @description Combat-log sentence for an enemy hit that did NOT kill, scaled by how close it came
/// to a kill (_severity = damage over the target's health before the hit, 0..1). Vehicles get
/// armour/hull language, infantry get wound language. Appended after the attack verb, e.g.
/// "24 Big Shootaz roar and blast away at Rhino.  Piercing the armour." Edit the wording freely;
/// only the tier thresholds matter to the rest of the code.
/// @param {real} _severity 0..1
/// @param {bool} _is_vehicle target is a vehicle
/// @returns {string}
function incoming_damage_flavor(_severity, _is_vehicle) {
    if (_is_vehicle) {
        if (_severity < 0.10) return choose("Only peeling the paint.", "Just chipping the paint.", "Pinging off the armour.", "Bouncing off the hull.", "Only scratching the armour.");
        if (_severity < 0.35) return choose("Barely putting a dent in the armour.", "Leaving a few dents in the hull.", "Only scuffing the armour.");
        if (_severity < 0.65) return choose("Piercing the armour.", "Punching through the plating.", "Cracking the armour open.");
        if (_severity < 0.90) return choose("Punching a huge hole in the armour.", "Tearing a gash through the hull.", "Blowing a hole in the plating.");
        return choose("Almost destroying it.", "Leaving it a smoking wreck.", "Nearly tearing it apart.");
    }
    if (_severity < 0.10) return choose("But the armour holds.", "But it is shrugged off.");
    if (_severity < 0.35) return choose("Drawing blood.", "Causing light wounds.", "Leaving a few grazes.");
    if (_severity < 0.65) return choose("Wounding several.", "Bloodying the ranks.", "Leaving wounded behind.");
    if (_severity < 0.90) return choose("Leaving deep wounds.", "Savaging the ranks.", "Leaving many badly wounded.");
    return choose("Leaving the survivors maimed and reeling.", "All but breaking them.", "Leaving them maimed and scattered.");
}
