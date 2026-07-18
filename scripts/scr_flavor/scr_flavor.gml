/// @function add_battle_log_message
/// @param {string} _message - The message text to add to the battle log
/// @param {real} [_message_color=0] - The color enum value (0=default, eMSG_COLOR.*)
/// @returns {bool} Success indicator
function add_battle_log_message(_message, _message_color = eMSG_COLOR.WHITE) {
    if (instance_exists(obj_ncombat)) {
        obj_ncombat.combat_log.push(_message, _message_color);
        obj_ncombat.alarm[3] = 2;
        return true;
    }
    return false;
}

/// @desc Plural form of a weapon name. Names that are already plural (end in "s", e.g.
///       "Twin Linked Bolters") are left as-is so we don't print "Bolterss".
/// @param {string} _name The weapon name.
/// @returns {string}
function weapon_name_plural(_name) {
    return _name + ((string_char_at(_name, string_length(_name)) == "s") ? "" : "s");
}

/// @desc Logs one "held fire" line for weapons that had no live target left to shoot at, e.g.
///       when an earlier volley wiped the enemy before the rest of the squad fired.
/// @param {Array} _weapon_names Raw weapon names (duplicates allowed) that never fired.
function report_held_fire(_weapon_names) {
    // Dedupe and pluralise.
    var _unique = [];
    for (var i = 0; i < array_length(_weapon_names); i++) {
        var _p = weapon_name_plural(_weapon_names[i]);
        if (array_get_index(_unique, _p) == -1) {
            array_push(_unique, _p);
        }
    }

    var _count = array_length(_unique);
    if (_count == 0) {
        return;
    }

    // Build "A, B, and C" (or "A and B", or "A").
    var _list = string_join_oxford_comma(_unique);

    add_battle_log_message($"{_list} held fire lacking live targets.", eMSG_COLOR.WHITE);
}

function scr_flavor(id_of_attacking_weapons, target, target_type, number_of_shots, casulties, shots_bounced = false, _defer = false) {
    // Generates flavor based on the damage and casualties from scr_shoot, only for the player
    // shots_bounced: true when armour stopped the shots outright (AP too low) and nothing died,
    // so the log can explain *why* instead of a flat "no casualties".
    // _defer: when true, build the message but DON'T post it; return it so the caller can append a
    // spill-over kill list and post a single consolidated line (see emit_volley_flavour).

    // Clamp away any negative casualty count so it can never render as "-1". Every volley now earns
    // a line: a kill, a wound (injured, no kill), or an armour-bounce. The latter two are consolidated
    // per target by emit_volley_flavour / combat_tally_*.
    if (casulties < 0) {
        casulties = 0;
    }

    var attack_message, kill_message, leader_message, targeh;
    targeh = target_type;
    leader_message = "";
    attack_message = $"";
    kill_message = "";

    // Guard/diagnostic: a non-killing volley against a rank with no living models means we fired at a
    // dead target. Shouldn't happen now that emptied formations are destroyed - log it if it does and
    // bail, so it can never feed the consolidated non-pen / wound feed. (Spill-over kills, if any, are
    // still reported by emit_volley_flavour's undefined-primary path.)
    if (casulties <= 0 && (!instance_exists(target) || target.dudes_num[targeh] <= 0)) {
        LOGGER.warning($"scr_flavor: shot at a dead target (weapon stack {id_of_attacking_weapons}, rank {targeh})");
        exit;
    }

    var weapon_name = wep[id_of_attacking_weapons];

    if (id_of_attacking_weapons == -51) {
        weapon_name = "Heavy Bolter Emplacement";
    }
    if (id_of_attacking_weapons == -52) {
        weapon_name = "Missile Launcher Emplacement";
    }
    if (id_of_attacking_weapons == -53) {
        weapon_name = "Missile Silo";
    }

    // Plural form for "{n} {weapon}s ..." lines (see weapon_name_plural).
    var weapon_plural = weapon_name_plural(weapon_name);

    var weapon_data = gear_weapon_data("weapon", weapon_name, "all");
    if (!is_struct(weapon_data)) {
        weapon_data = new EquipmentStruct({}, "");
        weapon_data.name = weapon_name;
    }

    var target_name = target.dudes[targeh];

    if ((target_name == "Leader") && (obj_ncombat.enemy <= eFACTION.CHAOS)) {
        target_name = obj_controller.faction_leader[obj_ncombat.enemy];
    }

    var character_shot = false, unit_name = "", cm_kill = 0;

    if (id_of_attacking_weapons > 0) {
        if (array_length(wep_solo[id_of_attacking_weapons]) > 0) {
            character_shot = true;
            full_names = wep_solo[id_of_attacking_weapons];
            if (wep_title[id_of_attacking_weapons] != "") {
                if (array_length(full_names) == 1) {
                    unit_name = wep_title[id_of_attacking_weapons] + " " + wep_solo[id_of_attacking_weapons][0];
                } else {
                    unit_name = wep_title[id_of_attacking_weapons];
                }
            }
            if (wep_solo[id_of_attacking_weapons][0] == obj_ini.master_name) {
                cm_kill = 1;
            }
        }
    }

    if ((obj_ncombat.battle_special == "WL10_reveal") || (obj_ncombat.battle_special == "WL10_later")) {
        if ((target_name == "Veteran Chaos Terminator") && (target_name > 0)) {
            obj_ncombat.chaos_angry += casulties * 2;
        }
        if ((target_name == "Veteran Chaos Chosen") && (target_name > 0)) {
            obj_ncombat.chaos_angry += casulties;
        }
        if (target_name == "Greater Daemon of Slaanesh") {
            obj_ncombat.chaos_angry += casulties * 5;
        }
        if (target_name == "Greater Daemon of Tzeentch") {
            obj_ncombat.chaos_angry += casulties * 5;
        }
    }

    if ((target.flank == 1) && (target.flyer == 0)) {
        target_name = "flanking " + target_name;
    }

    // Firing subject for consolidated lines: "<name> <weapon>" for a titled character, "The <weapon>"
    // for a lone shot, or "<n> <weapons>" for a volley (also used when a unit has no title, e.g. Dreadnoughts).
    var firing_subject;
    if (character_shot && unit_name != "") {
        if (number_of_shots > 1) {
            // Grouped titled units (e.g. several Dreadnoughts share one "Dreadnought" title) — show the count.
            firing_subject = $"{number_of_shots} {string(unit_name)} {weapon_plural}";
        } else {
            firing_subject = $"{string(unit_name)} {weapon_name}";
        }
    } else if (number_of_shots == 1) {
        firing_subject = $"The {weapon_name}";
    } else {
        firing_subject = $"{number_of_shots} {weapon_plural}";
    }

    var flavoured = false;

    if (weapon_data.has_tag("bolt")) {
        flavoured = true;
        if (!character_shot) {
            if (obj_ncombat.bolter_drilling == 1) {
                attack_message += "With perfect accuracy ";
            }
            if (number_of_shots < 200) {
                if (target.dudes_num[targeh] == 1) {
                    if (casulties == 0) {
                        attack_message += $"{number_of_shots} {weapon_plural} fire. The {target_name} is hit but survives.";
                    } else {
                        attack_message += $"{number_of_shots} {weapon_plural} fire. The {target_name} is struck down.";
                    }
                } else {
                    if (casulties == 0) {
                        attack_message += $"{number_of_shots} {weapon_plural} fire at {target_name} ranks without causing casualties.";
                    } else {
                        attack_message += $"{number_of_shots} {weapon_plural} strike {target_name} ranks, taking down {casulties}.";
                    }
                }
            } else {
                if (target.dudes_num[targeh] == 1) {
                    if (casulties == 0) {
                        attack_message += $"{number_of_shots} {weapon_plural} fire. Explosions rock the {target_name}'s armour but don't kill it.";
                    } else {
                        attack_message += $"{number_of_shots} {weapon_plural} fire. Explosions take down the {target_name}.";
                    }
                } else {
                    if (casulties == 0) {
                        attack_message += $"{number_of_shots} {weapon_plural} hit {target_name} ranks, but no casualties are confirmed.";
                    } else {
                        attack_message += $"{number_of_shots} {weapon_plural} tear through {target_name} ranks, instantly killing {casulties}.";
                    }
                }
            }
        } else {
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message += $"{string(unit_name)} fires his {weapon_name} at the {target_name} but fails to kill it.";
                } else {
                    attack_message += $"{string(unit_name)} eliminates the {target_name} with his {weapon_name}.";
                }
            } else {
                if (casulties == 0) {
                    attack_message += $"{string(unit_name)} fires his {weapon_name} at {target_name} ranks but fails to kill any.";
                } else {
                    attack_message += $"{string(unit_name)} takes down {casulties} {target_name} with his {weapon_name}.";
                }
            }
        }
    } else if (weapon_name == "Hammer of Wrath" || weapon_name == "Hammer of Wrath(M)") {
        flavoured = true;
        if (!character_shot) {
            if (number_of_shots < 20) {
                attack_message += $"{number_of_shots} Astartes with Jump Packs soar upwards, flames roaring. They plummet back down upon the enemy- ";
            } else if (number_of_shots >= 20 && number_of_shots < 100) {
                attack_message += $"Squads of {number_of_shots} Astartes ascend with roaring Jump Packs. They descend upon the enemy- ";
            } else {
                attack_message += $"A massive wave of {number_of_shots} Astartes rise, their Jump Packs a furious beast. They crash down, smashing their foe- ";
            }
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message += $"but the {target_name} endures the onslaught.";
                } else {
                    attack_message += $"the {target_name} falls to the charge.";
                }
            } else {
                if (casulties == 0) {
                    attack_message += $"{target_name} ranks are hit, but no casualties are confirmed.";
                } else {
                    attack_message += $"{target_name} ranks are hit, killing {casulties} in an instant.";
                }
            }
        } else {
            if (target.dudes_num[targeh] == 1) {
                attack_message += string(unit_name) + $" engages his Jump Pack, soaring and crashing into the {target_name}- ";
                if (casulties == 0) {
                    attack_message += $"but it endures the onslaught.";
                } else {
                    attack_message += $"and it falls to the charge.";
                }
            } else {
                attack_message += string(unit_name) + $" activates his Jump Pack, slamming into {target_name} ranks- ";
                if (casulties == 0) {
                    attack_message += $"but all survive the impact.";
                } else {
                    attack_message += $"and {casulties} are crushed in the impact.";
                }
            }
        }
    } else if (weapon_name == "Speed Force" || weapon_name == "Speed Force(M)") {
        flavoured = true;
        if (!character_shot) {
            if (number_of_shots < 20) {
                attack_message += $"{number_of_shots} Astartes on Bikes speed ahead, their Bikes roaring like beasts of old- ";
            } else if (number_of_shots >= 20 && number_of_shots < 100) {
                attack_message += $"Squads of {number_of_shots} Astartes thunder ahead on their Bikes. They descend upon the enemy- ";
            } else {
                attack_message += $"A massive wave of {number_of_shots} Astartes rolls ahead on top of their mighty Bikes. They crash into enemy lines, smashing their foe- ";
            }
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message += $"but the {target_name} endures the onslaught.";
                } else {
                    attack_message += $"the {target_name} falls to the charge.";
                }
            } else {
                if (casulties == 0) {
                    attack_message += $"{target_name} ranks are hit, but no casualties are confirmed.";
                } else {
                    attack_message += $"{target_name} ranks are hit, killing {casulties} in an instant.";
                }
            }
        } else {
            if (target.dudes_num[targeh] == 1) {
                attack_message += string(unit_name) + $" speeds on his bike, roaring and crashing into the {target_name}- ";
                if (casulties == 0) {
                    attack_message += $"but it endures the onslaught.";
                } else {
                    attack_message += $"and it falls to the charge.";
                }
            } else {
                attack_message += string(unit_name) + $" speeds on his bike, slamming into {target_name} ranks- ";
                if (casulties == 0) {
                    attack_message += $"but all survive the impact.";
                } else {
                    attack_message += $"crushing {casulties} beneath his wheels.";
                }
            }
        }
    } else if (weapon_name == "Speed Force (Ranged)") {
        flavoured = true;
        if (!character_shot) {
            if (number_of_shots < 20) {
                attack_message += $"{number_of_shots} Attack Bikes race across the field, sidecar gunners hosing down the enemy on the move- ";
            } else if (number_of_shots >= 20 && number_of_shots < 100) {
                attack_message += $"A column of {number_of_shots} Attack Bikes sweeps past, heavy weapons hammering away in a thunderous strafing run- ";
            } else {
                attack_message += $"A roaring tide of {number_of_shots} Attack Bikes tears along the line, sidecar guns blazing without pause- ";
            }
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message += $"but the {target_name} weathers the fusillade.";
                } else {
                    attack_message += $"and the {target_name} is gunned down where it stands.";
                }
            } else {
                if (casulties == 0) {
                    attack_message += $"{target_name} ranks are raked with fire, but none fall.";
                } else {
                    attack_message += $"cutting down {casulties} {target_name} in the pass.";
                }
            }
        } else {
            if (target.dudes_num[targeh] == 1) {
                attack_message += string(unit_name) + $" guns his Attack Bike past the {target_name}, sidecar weapon roaring- ";
                if (casulties == 0) {
                    attack_message += $"but it endures the barrage.";
                } else {
                    attack_message += $"and it is torn apart.";
                }
            } else {
                attack_message += string(unit_name) + $" sweeps his Attack Bike along {target_name} ranks, raking them with fire- ";
                if (casulties == 0) {
                    attack_message += $"but all survive the onslaught.";
                } else {
                    attack_message += $"cutting down {casulties} in the pass.";
                }
            }
        }
    } else if (string_contains("RAM", weapon_name)) {
        flavoured = true;
        if (!character_shot) {
            if (number_of_shots < 10) {
                attack_message += $"{number_of_shots} vehicle{((number_of_shots > 1) ? "s" : "")} thunder forward, armoured hulls crashing into the enemy lines- ";
            } else {
                attack_message += $"An armoured column of {number_of_shots} vehicles smashes into the enemy, grinding everything in its path- ";
            }
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message += $"but the {target_name} withstands the impact.";
                } else {
                    attack_message += $"the {target_name} is crushed beneath their treads.";
                }
            } else {
                if (casulties == 0) {
                    attack_message += $"{target_name} ranks scatter before the charge, but no casualties are confirmed.";
                } else {
                    attack_message += $"{target_name} ranks are crushed, killing {casulties} in the onslaught.";
                }
            }
        } else {
            if (target.dudes_num[targeh] == 1) {
                attack_message += $"{unit_name} rams into the {target_name}- ";
                if (casulties == 0) {
                    attack_message += $"but it endures the impact.";
                } else {
                    attack_message += $"and it is shattered.";
                }
            } else {
                attack_message += $"{unit_name} rams into {target_name} ranks- ";
                if (casulties == 0) {
                    attack_message += $"but they all survive the impact.";
                } else {
                    attack_message += $"crushing {casulties} beneath its hull.";
                }
            }
        }
    } else if (weapon_name == "Assault Cannon") {
        flavoured = true;
        if (!character_shot) {
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message += $"{number_of_shots} {weapon_plural} roar, explosions clap across the armour of the {target_name} but it remains standing.";
                } else {
                    attack_message += $"{number_of_shots} {weapon_plural} fire at the {target_name} and rip it apart.";
                }
            } else {
                if (casulties == 0) {
                    attack_message += $"{number_of_shots} {weapon_plural} thunder, {target_name} are rocked but unharmed.";
                } else {
                    attack_message += $"{number_of_shots} {weapon_plural} mow down {casulties} {target_name}.";
                }
            }
        } else {
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message += $"{string(unit_name)} {weapon_name} fires but the {target_name} survives.";
                } else {
                    attack_message += $"{string(unit_name)} obliterates the {target_name} with the {weapon_name}.";
                }
            } else {
                if (casulties == 0) {
                    attack_message += $"{string(unit_name)} {weapon_name} fails to breach {target_name} ranks.";
                } else {
                    attack_message += $"{string(unit_name)} cuts down {casulties} {target_name} with the {weapon_name}.";
                }
            }
        }
    } else if (weapon_name == "Missile Launcher") {
        flavoured = true;
        if (!character_shot) {
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message = $"{number_of_shots} {weapon_plural} fire upon the {target_name} but it remains standing.";
                } else {
                    attack_message = $"{number_of_shots} {weapon_plural} blast the {target_name} to oblivion.";
                }
            } else {
                if (casulties == 0) {
                    attack_message = $"{number_of_shots} {weapon_plural} hit {target_name} ranks but they hold firm.";
                } else {
                    attack_message = $"{number_of_shots} {weapon_plural} pulverize {casulties} {target_name}.";
                }
            }
        } else {
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message = $"{string(unit_name)} {weapon_name} fires upon the {target_name} but it survives.";
                } else {
                    attack_message = $"{string(unit_name)} obliterates {target_name} with the {weapon_name}.";
                }
            } else {
                if (casulties == 0) {
                    attack_message = $"{string(unit_name)} {weapon_name} fails to inflict damage upon {target_name} ranks.";
                } else {
                    attack_message = $"{string(unit_name)} pulverizes {casulties} {target_name} with the {weapon_name}.";
                }
            }
        }
    } else if (weapon_name == "Whirlwind Missiles") {
        flavoured = true;
        if (!character_shot) {
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message = $"{number_of_shots} Whirlwinds fire upon the {target_name} but it remains standing.";
                } else {
                    attack_message = $"{number_of_shots} Whirlwinds blast {target_name} to oblivion.";
                }
            } else {
                if (casulties == 0) {
                    attack_message = $"{number_of_shots} Whirlwinds hit {target_name} ranks but they hold firm.";
                } else {
                    attack_message = $"{number_of_shots} Whirlwinds pulverize {casulties} {target_name}.";
                }
            }
        } else {
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message = $"Whirlwind fires upon the {target_name} but it survives.";
                } else {
                    attack_message = $"Whirlwind obliterates the {target_name}.";
                }
            } else {
                if (casulties == 0) {
                    attack_message = $"Whirlwind fails to inflict damage upon {target_name} ranks.";
                } else {
                    attack_message = $"Whirlwind pulverizes {casulties} {target_name}.";
                }
            }
        }
    } else if ((weapon_name == "fists") || (weapon_name == "Melee") || (weapon_name == "melee")) {
        flavoured = true;
        var ra = choose(1, 2, 3, 4);
        // This needs to be worked out
        if (casulties == 0) {
            attack_message = $"{target_name} engaged in hand-to-hand combat, no casualties.";
        }
        if (casulties > 0) {
            attack_message = $"{target_name} ranks ";
            if (ra == 1) {
                attack_message += "are struck with gun-barrels and fists.";
            }
            if (ra == 2) {
                attack_message += "are savaged by your marines in hand-to-hand combat.";
            }
            if (ra == 3) {
                attack_message += "are smashed by your marines.";
            }
            if (ra == 4) {
                attack_message += "are struck by your marines in melee.";
            }
            attack_message += $" {casulties} killed.";
        }
    } else if (weapon_name == "Force Staff") {
        flavoured = true;
        if (number_of_shots == 1) {
            attack_message = $"{target_name} is blasted by the {weapon_name}.";
        }
        if (number_of_shots > 1) {
            attack_message = $"{number_of_shots} {weapon_name} crackle and swing into the {target_name} ranks, killing {casulties}.";
        }
    } else if (weapon_data.has_tag("plasma")) {
        flavoured = true;
        if ((target.dudes_num[targeh] == 1) && (casulties == 0)) {
            attack_message = $"{number_of_shots} {weapon_name} shoot bolts of energy into a {target_name}, failing to kill it.";
        }
        if ((target.dudes_num[targeh] == 1) && (casulties == 1)) {
            attack_message = $"{number_of_shots} {weapon_name} overwhelm a {target_name} with bolts of energy, killing {casulties}.";
        }
        if ((target.dudes_num[targeh] > 1) && (casulties == 0)) {
            attack_message = $"{number_of_shots} {weapon_name} shoot bolts of energy into the {target_name} ranks, failing to kill any.";
        }
        if ((target.dudes_num[targeh] > 1) && (casulties > 0)) {
            attack_message = $"{number_of_shots} {weapon_name} shoot bolts of energy into the {target_name}, cleansing {casulties}.";
        }
    } else if (weapon_data.has_tag("flame")) {
        flavoured = true;
        if ((target.dudes_num[targeh] == 1) && (casulties == 0)) {
            attack_message = $"{number_of_shots} {weapon_name} bathe the {target_name} in holy promethium, failing to kill it.";
        }
        if ((target.dudes_num[targeh] == 1) && (casulties == 1)) {
            attack_message = $"{number_of_shots} {weapon_name} flash-fry the {target_name} inside its armour, inflicting {casulties}.";
        }
        if ((target.dudes_num[targeh] > 1) && (casulties == 0)) {
            attack_message = $"{number_of_shots} {weapon_name} wash over the {target_name} ranks, failing to kill any.";
        }
        if ((target.dudes_num[targeh] > 1) && (casulties > 0)) {
            attack_message = $"{number_of_shots} {weapon_name} bathe the {target_name} ranks in holy promethium, cleansing {casulties}.";
        }
    } else if (weapon_name == "Webber") {
        flavoured = true;
        if (((target_name == "Termagaunt") || (target_name == "Hormagaunt")) && (casulties > 0)) {
            obj_ncombat.captured_gaunt += casulties;
        }
        if ((target.dudes_num[targeh] == 1) && (casulties == 0)) {
            attack_message = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} but fail to immobilize it.";
        }
        if ((target.dudes_num[targeh] == 1) && (casulties == 1)) {
            attack_message = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} and fully immobilize it.";
        }
        if ((target.dudes_num[targeh] > 1) && (casulties == 0)) {
            attack_message = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} ranks, failing to immobilize any.";
        }
        if ((target.dudes_num[targeh] > 1) && (casulties > 0)) {
            attack_message = $"{number_of_shots} {weapon_name} spray ooze on the {target_name} ranks and immobilize {casulties} of them.";
        }
    } else if (weapon_name == "Close Combat Weapon") {
        flavoured = true;
        if ((number_of_shots == 1) && (casulties == 0)) {
            attack_message = $"{target_name} is struck by " + string(obj_ini.role[100][6]) + " but survives.";
        }
        if ((number_of_shots == 1) && (casulties == 1)) {
            attack_message = $"{target_name} is struck down by " + string(obj_ini.role[100][6]) + ".";
        }
        if ((number_of_shots > 1) && (casulties == 0)) {
            attack_message = $"{number_of_shots} {string(obj_ini.role[100][6])}s wrench and smash at {target_name} but fail to destroy it.";
        }
        if ((number_of_shots > 1) && (casulties > 1)) {
            attack_message = $"{number_of_shots} {string(obj_ini.role[100][6])}s stomp, wrench, and smash {casulties} {target_name} into paste.";
        }
    } else if (weapon_name == "Chainsword") {
        flavoured = true;
        if ((number_of_shots == 1) && (casulties == 0)) {
            attack_message = $"{target_name} is struck by a {weapon_name} but survives.";
        }
        if ((number_of_shots == 1) && (casulties == 1)) {
            attack_message = $"{target_name} is cut down by a {weapon_name}.";
        }
        if ((number_of_shots > 1) && (casulties == 0)) {
            attack_message = $"{number_of_shots} motors rev and hack at the {target_name} ranks, but don't kill any.";
        }
        if ((number_of_shots > 1) && (casulties > 0)) {
            attack_message = $"{number_of_shots} motors rev and hack away at the {target_name} ranks. {casulties} are cut down.";
        }
    } else if (weapon_name == "Sarissa") {
        flavoured = true;
        if ((number_of_shots == 1) && (casulties == 0)) {
            attack_message = $"A {target_name} is struck by a Battle Sister's {weapon_name} but survives.";
        }
        if ((number_of_shots == 1) && (casulties == 1)) {
            attack_message = $"A {target_name} is struck down by a Battle Sister's {weapon_name}.";
        }
        if ((number_of_shots > 1) && (casulties == 0)) {
            attack_message = $"Battle Sisters " + choose("howl out", "roar") + $" and hack at {target_name} ranks with their {weapon_plural}, but they survive.";
        }
        if ((number_of_shots > 1) && (casulties > 0)) {
            attack_message = $"{number_of_shots} Battle Sisters " + choose("howl out", "roar") + $" as they hack away at the {target_name} ranks, killing {casulties} with their {weapon_plural}.";
        }
    } else if (weapon_name == "Eviscerator") {
        flavoured = true;
        if ((number_of_shots == 1) && (casulties == 0)) {
            attack_message = $"A {target_name} is struck by a {weapon_name} but survives.";
        }
        if ((number_of_shots == 1) && (casulties == 1)) {
            attack_message = $"A {target_name} is cut down by a {weapon_name}.";
        }
        if ((number_of_shots > 1) && (casulties == 0)) {
            attack_message = $"{number_of_shots} {weapon_name} rev and howl, hacking at the {target_name} ranks, failing to kill any.";
        }
        if ((number_of_shots > 1) && (casulties > 0)) {
            attack_message = $"{number_of_shots} {weapon_name} rev and howl, hacking at the {target_name} ranks, {casulties} are cut down.";
        }
    } else if (weapon_name == "Dozer Blades") {
        flavoured = true;
        if ((number_of_shots == 1) && (casulties == 0)) {
            attack_message = $"A {target_name} is rammed but survives.";
        }
        if ((number_of_shots == 1) && (casulties == 1)) {
            attack_message = $"A {target_name} is splattered by {weapon_name}.";
        }
        if ((number_of_shots > 1) && (casulties == 0)) {
            attack_message = $"{weapon_name} ploughs {target_name} ranks , inflicting {casulties}.";
        }
        if ((number_of_shots > 1) && (casulties > 0)) {
            attack_message = $"{weapon_name} hits {target_name} ranks , inflicting {casulties}.  " + string(casulties) + " are smashed.";
        }
    } else if (weapon_data.has_tag("power")) {
        flavoured = true;
        if (target.dudes_num[targeh] == 1) {
            if ((number_of_shots == 1) && (casulties == 0)) {
                attack_message = $"A {target_name} is struck by a {weapon_name} but survives.";
            }
            if ((number_of_shots == 1) && (casulties == 1)) {
                attack_message = $"A {target_name} is struck down by a {weapon_name}.";
            }

            if ((number_of_shots > 1) && (casulties == 0)) {
                attack_message = $"A {target_name} is struck by {number_of_shots} {weapon_plural} but survives.";
            }
            if ((number_of_shots > 1) && (casulties == 1)) {
                attack_message = $"A {target_name} is struck down by {number_of_shots} {weapon_plural}.";
            }
        }
        if (target.dudes_num[targeh] > 1) {
            if ((number_of_shots > 1) && (casulties == 0)) {
                attack_message = $"{number_of_shots} {weapon_plural} crackle and spark, striking at the {target_name} ranks, inflicting no damage.";
            }
            if ((number_of_shots > 1) && (casulties > 0)) {
                attack_message = $"{number_of_shots} {weapon_plural} crackle and spark, hewing through the {target_name} ranks, {casulties} are cut down.";
            }
        }
    }

    // A fallback flavour
    if (flavoured == false) {
        flavoured = true;
        if (!character_shot) {
            if (target.dudes_num[targeh] == 1) {
                if (number_of_shots == 1 && casulties == 0) {
                    attack_message = $"A {target_name} is struck by {weapon_name} but survives.";
                } else if (number_of_shots == 1 && casulties == 1) {
                    attack_message = $"A {target_name} is struck down by {weapon_name}.";
                } else if (number_of_shots > 1 && casulties == 0) {
                    attack_message = $"A {target_name} is struck by {number_of_shots} {weapon_plural} but survives.";
                } else if (number_of_shots > 1 && casulties == 1) {
                    attack_message = $"A {target_name} is struck down by {number_of_shots} {weapon_plural}.";
                }
            } else {
                if (number_of_shots == 1 && casulties == 0) {
                    attack_message = $"{weapon_name} strikes at {target_name} but they survive.";
                } else if (number_of_shots == 1 && casulties > 0) {
                    attack_message = $"{weapon_name} strikes at {target_name} and kills {casulties}";
                } else if (number_of_shots > 1 && casulties == 0) {
                    attack_message = $"{number_of_shots} {weapon_plural} strike at the {target_name} ranks, but fail to inflict damage.";
                } else if (number_of_shots > 1 && casulties > 0) {
                    attack_message = $"{number_of_shots} {weapon_plural} strike at the {target_name} ranks, killing {casulties}.";
                }
            }
        } else {
            if (target.dudes_num[targeh] == 1) {
                if (casulties == 0) {
                    attack_message = $"{firing_subject} strikes at a {target_name} but fails to kill it.";
                } else {
                    attack_message = $"{firing_subject} strikes at a {target_name}, killing it.";
                }
            } else {
                if (casulties == 0) {
                    attack_message = $"{firing_subject} strikes at the {target_name} ranks, failing to kill any.";
                } else {
                    attack_message = $"{firing_subject} strikes at the {target_name} ranks and kills {casulties}.";
                }
            }
        }
    }

    // Reason-aware override: armour stopped the shots cold (AP too low). Replaces whatever
    // generic "no casualties" text the branches produced with something that explains why.
    if (shots_bounced && casulties == 0) {
        flavoured = true;
        if (character_shot) {
            attack_message = $"{string(unit_name)} {weapon_name} strikes the {target_name} but fails to penetrate its armour.";
        } else if (number_of_shots == 1) {
            attack_message = $"The {weapon_name} strikes the {target_name} but fails to penetrate its armour.";
        } else if (weapon_data.has_tag("bolt")) {
            attack_message = $"{number_of_shots} {weapon_plural} hammer the {target_name} but spark harmlessly off its armour.";
        } else if (weapon_data.has_tag("flame")) {
            attack_message = $"{number_of_shots} {weapon_plural} wash over the {target_name} but its armour endures the flames.";
        } else if (weapon_data.has_tag("power")) {
            attack_message = $"{number_of_shots} {weapon_plural} strike the {target_name} but glance off its armour.";
        } else {
            attack_message = $"{number_of_shots} {weapon_plural} strike the {target_name} but fail to penetrate its armour.";
        }
    }

    // if (string_length(attack_message+kill_message+p3)<8) then show_message(weapon_name+" is not displaying anything");

    // I don't understand what this was supposed to do either.
    // if (obj_ncombat.dead_enemies != 0){
    // 	for (var i = 1; i < array_length_1d(obj_ncombat.dead_ene); i++) {
    // 		if (obj_ncombat.dead_ene[i] != "") {
    // 			if (obj_ncombat.dead_enemies == 1) {
    // 				kill_message += obj_ncombat.dead_ene[i] + " unit has been eliminated.";
    // 			} else if (obj_ncombat.dead_enemies == 2) {
    // 				if (i == 1) {
    // 					kill_message += obj_ncombat.dead_ene[i] + " and ";
    // 				} else {
    // 					kill_message += obj_ncombat.dead_ene[i] + " units have been eliminated.";
    // 				}
    // 			} else if (obj_ncombat.dead_enemies > 2) {
    // 				if (i == 1) {
    // 					kill_message += obj_ncombat.dead_ene[i] + ", ";
    // 				} else if (i == obj_ncombat.dead_enemies) {
    // 					kill_message += "and " + obj_ncombat.dead_ene[i] + " units have been eliminated.";
    // 				} else {
    // 					kill_message += obj_ncombat.dead_ene[i] + ", ";
    // 				}
    // 			}
    // 		}
    // 		obj_ncombat.dead_ene[i] = "";
    // 	}
    // 	obj_ncombat.dead_enemies = 0;
    // }

    var message_color = eMSG_COLOR.DEFAULT;
    if (obj_ncombat.enemy <= eFACTION.CHAOS) {
        if (target_name == obj_controller.faction_leader[obj_ncombat.enemy]) {
            // Cleaning up the message for the enemy leader
            leader_message = string_replace(leader_message, "a " + target_name, target_name);
            leader_message = string_replace(leader_message, "the " + target_name, target_name);
            leader_message = string_replace(leader_message, target_name + " ranks , inflicting {casulties}", target_name);
            if (enemy == 5) {
                leader_message = string_replace(leader_message, "it", "her");
            }
            if ((enemy == 6) && (obj_controller.faction_gender[6] == 1)) {
                leader_message = string_replace(leader_message, "it", "him");
            }
            if ((enemy == 6) && (obj_controller.faction_gender[6] == 2)) {
                leader_message = string_replace(leader_message, "it", "her");
            }
            if ((enemy != 6) && (enemy != 5)) {
                leader_message = string_replace(leader_message, "it", "him");
            }
            message_color = eMSG_COLOR.YELLOW;
        }
    }

    // When deferred, hand the parts back to the caller instead of posting them, so the spill-over
    // kill list can be appended and the whole volley posted as one line.
    if (!_defer) {
        if (attack_message != "") {
            add_battle_log_message(attack_message, message_color);
        }

        if (leader_message != "") {
            add_battle_log_message(leader_message, message_color);
        }
    }

    return {
        attack: attack_message,
        leader: leader_message,
        color: message_color,
        bounced: (shots_bounced && casulties == 0),
        injured: (!shots_bounced && casulties == 0),
        target: target_name,
        subject: firing_subject,
    };
}

/// @desc Formats a list of kills into "the X" / "N X", joined as "A, B, and C".
/// @param {Array} _kills Array of { name, count } structs.
/// @returns {string}
function format_kill_list(_kills) {
    // Merge entries that share a name so multiple ranks of one unit read as a single tally
    // (e.g. "29 Slugga Boy and 223 Slugga Boy" -> "252 Slugga Boy").
    var _merged = [];
    for (var m = 0; m < array_length(_kills); m++) {
        var _hit = false;
        for (var n = 0; n < array_length(_merged); n++) {
            if (_merged[n].name == _kills[m].name) {
                _merged[n].count += _kills[m].count;
                _hit = true;
                break;
            }
        }
        if (!_hit) {
            array_push(_merged, {name: _kills[m].name, count: _kills[m].count});
        }
    }
    _kills = _merged;
    var _n = array_length(_kills);
    if (_n == 0) {
        return "";
    }
    var _parts = [];
    for (var i = 0; i < _n; i++) {
        var _k = _kills[i];
        array_push(_parts, (_k.count == 1) ? ("the " + _k.name) : (string(_k.count) + " " + _k.name));
    }
    var _list = string_join_oxford_comma(_parts);
    return _list;
}

/// @desc Posts a single consolidated volley line: the deferred rich flavour for the first target,
///       plus a trailing list of everything the volley's overflow killed afterwards.
/// @param {Struct} _primary Result returned by scr_flavor(..., _defer=true) for the first target (or undefined).
/// @param {Array} _spill_kills Array of { name, count } for targets killed after the first.
function emit_volley_flavour(_primary, _spill_kills) {
    var _list = format_kill_list(_spill_kills);

    // Non-killing volley (armour-bounce or a wound that dropped no-one, and nothing spilled):
    // consolidate into one chronological line per target instead of one line per weapon.
    if (is_struct(_primary) && (_primary.bounced || _primary.injured) && _list == "") {
        combat_tally_add(_primary.target, _primary.subject, _primary.injured);
        return;
    }

    // A killing volley posts immediately; flush any pending bounce/injure tally first so the log
    // stays in chronological order.
    combat_tally_flush();

    if (!is_struct(_primary)) {
        // No primary line (scr_flavor bailed on a dead target - shouldn't happen now that emptied
        // formations are destroyed). Spill-over only happens after a wipe, so this is just defensive.
        if (_list != "") {
            add_battle_log_message("Overflowing fire cuts down " + _list + ".");
        }
        return;
    }

    var _message = _primary.attack;
    if (_list != "") {
        _message += " In the torrent of fire that reaches beyond those they slaughter: " + _list + ".";
    }

    if (_message != "") {
        add_battle_log_message(_message, _primary.color);
    }
    if (_primary.leader != "") {
        add_battle_log_message(_primary.leader, _primary.color);
    }
}

/// @desc Buffers a non-killing volley (wound or armour-bounce) against a target. Consecutive volleys
///       on the same target merge; switching target flushes the previous one, keeping the log
///       chronological. _injured true = penetrated but no kill; false = bounced off armour.
function combat_tally_add(_target, _subject, _injured) {
    if (obj_ncombat.ctally_target != _target) {
        combat_tally_flush();
        obj_ncombat.ctally_target = _target;
    }
    if (_injured) {
        array_push(obj_ncombat.ctally_injure, _subject);
    } else {
        array_push(obj_ncombat.ctally_bounce, _subject);
    }
}

/// @desc Posts the buffered wound/bounce lines for the current target (one each), then clears them.
function combat_tally_flush() {
    if (obj_ncombat.ctally_target == undefined) {
        return;
    }
    var _t = obj_ncombat.ctally_target;
    if (array_length(obj_ncombat.ctally_injure) > 0) {
        add_battle_log_message($"Fire from {combat_subject_join(obj_ncombat.ctally_injure)} wounded the {_t} but didn't bring it down.", eMSG_COLOR.WHITE);
    }
    if (array_length(obj_ncombat.ctally_bounce) > 0) {
        add_battle_log_message($"Fire from {combat_subject_join(obj_ncombat.ctally_bounce)} cannot penetrate the {_t}'s armour.", eMSG_COLOR.WHITE);
    }
    obj_ncombat.ctally_target = undefined;
    obj_ncombat.ctally_bounce = [];
    obj_ncombat.ctally_injure = [];
}

/// @desc Joins firing subjects into "A", "A and B", or "A, B, and C".
function combat_subject_join(_subjects) {
    return string_join_oxford_comma(_subjects);
}

/// @self Asset.GMObject.obj_ncombat
/// @desc Sets `_newline` to the enemy strength readout (live %, boss HP, or "Defeated") and fires the
///       enemy-defeated side-effects. Shared by obj_ncombat's Alarm_3 and Step_0 so the line can't
///       drift between the two copies (that drift is what hid the % for so long).
function combat_emit_enemy_status() {
    var _newline = "";
    var _newline_color = eMSG_COLOR.YELLOW;

    if ((enemy_forces > 0) && (enemy != 30)) {
        _newline = "Enemy Forces at " + string(max(1, round((enemy_forces / enemy_max) * 100))) + "%";
    }
    if ((enemy == 30) && instance_exists(obj_enunit)) {
        _newline = "Enemy has ";
        var yoo = instance_nearest(0, 0, obj_enunit);
        _newline += string(round(yoo.dudes_hp[1])) + "HP remaining";
    }
    if (((enemy_forces <= 0) || (!instance_exists(obj_enunit))) && (defeat_message == 0)) {
        defeat_message = 1;
        _newline = "Enemy Forces Defeated";
        timer_maxspeed = 0;
        timer_speed = 0;
        started = 2;
        instance_activate_object(obj_pnunit);
    }

    combat_log.push(_newline, _newline_color);
}
