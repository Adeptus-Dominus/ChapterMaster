// ---------------------------------------------------------------------------------
// Bombardment tuning. These govern how much of a world a single bombardment kills.
// Casualties are a share of the world's population CAPACITY (its max population), not of
// whoever is left, so a world is depopulated in a handful of bombards down to zero
// rather than a fixed absolute figure that wipes small worlds in one shot or a fraction
// of the survivors that only ever asymptotes. Bombardment never turns a world Dead; the
// world keeps its type at zero population and can regrow once its enemies are cleared.
// All values are macros so balance can be tuned without touching logic.
// ---------------------------------------------------------------------------------

// BASE is the share of world capacity a bombardment kills before the factor multipliers.
// MAX caps a single bombard, so the fastest a world can be emptied is 1 / MAX bombards.
#macro BOMBARD_BASE_FRACTION 0.20
#macro BOMBARD_MAX_FRACTION 0.34

/// @desc World-type multiplier on bombardment population casualties. Dense hive cities
/// burn hardest; spread-out agri and feudal worlds lose fewer people per bombardment.
function bombard_planet_type_pop_mult(_type) {
    switch (_type) {
        case "Hive": return 1.5;
        case "Desert": return 0.8;
        case "Agri": return 0.6;
        case "Feudal": return 0.5;
    }
    return 1.0; // Temperate / civilised and everything else
}

/// @desc Enemy-presence multiplier on bombardment population casualties. A larger, more
/// deeply embedded enemy (strength tier 0 none .. 6 Overwhelming) means the bombardment
/// has to hit more of the world to root it out, so more civilians die alongside it.
function bombard_presence_pop_mult(_tier) {
    var _mults = [0.6, 0.7, 0.85, 1.0, 1.2, 1.4, 1.6];
    return _mults[clamp(_tier, 0, 6)];
}

/// @desc Ratio multiplier: how far the enemy has overrun the world. A large enemy on a
/// lightly populated world drives collateral up; a small enemy on a teeming world keeps
/// it down. Compares the enemy strength tier to a coarse population bucket.
function bombard_ratio_pop_mult(_planet, _tier) {
    var _pop = _planet.population_as_small();
    var _pop_tier = 0;
    if (_pop >= 1000000000) {
        _pop_tier = 5;
    } else if (_pop >= 100000000) {
        _pop_tier = 4;
    } else if (_pop >= 10000000) {
        _pop_tier = 3;
    } else if (_pop >= 1000000) {
        _pop_tier = 2;
    } else if (_pop >= 100000) {
        _pop_tier = 1;
    }
    var _diff = clamp(_tier - _pop_tier, -3, 3);
    return clamp(1 + _diff * 0.15, 0.6, 1.5);
}

/// @desc Share of a world's population CAPACITY killed by one bombardment, from world
/// type, enemy presence, and enemy-to-population ratio, capped at BOMBARD_MAX_FRACTION.
function bombard_pop_kill_fraction(_planet, _enemy_tier) {
    var _frac = BOMBARD_BASE_FRACTION;
    _frac *= bombard_planet_type_pop_mult(_planet.planet_type);
    _frac *= bombard_presence_pop_mult(_enemy_tier);
    _frac *= bombard_ratio_pop_mult(_planet, _enemy_tier);
    return clamp(_frac, 0, BOMBARD_MAX_FRACTION);
}

/// @desc Population killed by one bombardment, in the planet's own population scale. A
/// bombard removes a share of the world's capacity (max population), so repeated bombards
/// grind a world down to zero in a handful of strikes regardless of its size, but never
/// exceed the population actually present. Used by both scr_bomb_world and the dialog
/// preview so the estimate and the real outcome always agree.
function bombard_population_kill(_planet, _enemy_tier) {
    var _capacity = max(_planet.max_population, _planet.population);
    var _kill = _capacity * bombard_pop_kill_fraction(_planet, _enemy_tier);
    return min(_planet.population, _kill);
}

function scr_bomb_world(bombard_target_faction, bombard_ment_power, target_strength) {
    var pop_after = 0, reduced_bombard_score = 0, strength_reduction = 0, txt2 = "", txt3 = "", txt4 = "", max_kill, overkill, roll, kill;

    var score_before = population;

    // TODO - update descriptions below, once we get Surface to Orbit weaponry into the game

    var txt1 = choose("Your cruiser and larger ship", "The heavens rumble and thunder as your ship"); // TODO - add more variation, for different planets, perhaps different ships, CMs positioning, planetary features and other factors
    if (obj_bomb_select.ships_selected > 1) {
        txt1 += "s";
    }
    txt1 += choose(" position themselves over the target in close orbit, and unleash", " unload");
    if (obj_bomb_select.ships_selected == 1) {
        txt1 += "s";
    }
    txt1 += $" annihilation upon {name()}. Even from space the explosions can be seen, {choose("tearing ground", "hammering", "battering", "thundering")} across the planet's surface.";

    kill = bombard_population_kill(self, target_strength);

    var pop_before = population;

    // Minimum kills
    pop_after = max(0, pop_before - kill);
    if ((pop_after <= 0) && (pop_before > 0)) {
        heres_after = 0;
    }

    // Code bits copied from scr_purge_world
    if (population > 0) {
        heres_before = max(corruption + secret_corruption, population_influences[eFACTION.TAU]);
        sci1 = 0;
        sci1 = (pop_after / pop_before) * irandom_range(1, 3); // Make bombard corruption reduction random to encourage other forms of purging // TODO MEDIUM BOMBARD_CORRUPTION // Tweak numbers
        heres_after = heres_before - sci1;
    }

    if (planet_type != "Space Hulk") {
        var bombard_protection = 1;
        switch (bombard_target_faction) {
            // case 1:
            // txt2="##The Space Marine forces are difficult to bombard; ";
            // bombard_protection=3;
            // break;
            case 2:
                txt2 = "##The Imperial forces are suitably fortified; ";
                bombard_protection = 2;
                break; // I'm not sure about IG, maybe they should be left at 2, or, maybe they should be at 1, like the PDF
            case 2.5:
                if (current_owner <= 5) {
                    txt2 = "##The PDF forces are poorly fortified; ";
                    bombard_protection = 1;
                } else if (current_owner > 5) {
                    txt2 = "##The renegade forces are poorly fortified; ";
                    bombard_protection = 1;
                }
                break; // I think PDF and renegades down there should be kind of poorly prepared for this
            case 3:
                txt2 = "##The Mechanicus forces are well fortified; ";
                bombard_protection = 3; // If we get to Admech, I think they should be pretty capable with the hi-tech goodies they have
                break;
            // case 4:
            // txt2="##The Inquisition forces are difficult to bombard; ";
            // bombard_protection=3;
            // break;
            case 5:
                txt2 = "##The Ecclesiarchy forces are concentrated within their Cathedral; ";
                bombard_protection = 1;
                break; // Maybe we should make it 0? Though, Cathedral does have a roof at least
            case 6:
                txt2 = "##The Eldar forces are challenging to pin down; ";
                bombard_protection = 4; // Hi-tech faction
                break;
            case 7:
                txt2 = "##The Ork forces, for brutal savages, are well dug in; "; // TODO spice up descriptions with variable levels of protection
                bombard_protection = 2;
                if (has_feature(eP_FEATURES.ORKSTRONGHOLD)) {
                    var _stronghold = get_features(eP_FEATURES.ORKSTRONGHOLD)[0];
                    var _protection = floor(_stronghold.tier);
                    bombard_protection += _protection;
                    if (_protection) {
                        if (bombard_protection == 3) {
                            txt2 = "The Ork Stronghold on this planet is sizeable and provides the Orks with heavy protection";
                        } else {
                            txt2 = "The Ork Stronghold Provides near absolute protection for the greenskins within the vast shielding is impressivly effective despite it's seemingly primitive designs";
                        }
                    }
                }
                // TODO Make protection variable depending on leaders present
                break;
            case 8:
                txt2 = "##The Tau forces are well fortified; ";
                bombard_protection = 3; // Hi-tech, but not as high as Eldar or Necrons
                break;
            case 9:
                txt2 = "##The Tyranid Swarm is a large target; ";
                bombard_protection = 0; // TODO add considerations when it is a cult, and when it is bioforms out in the open
                break;
            case 10:
                if (planet_type == "Daemon") {
                    bombard_protection = 3; // Kind of irrelevant if the bombardment will be nulled later either way
                    txt2 = "##Reality warps and twists within the planet; ";
                } else {
                    txt2 = "##The Chaos forces are suitably fortified; ";
                    bombard_protection = 2;
                }
                break;
            case 11:
                // Traitor Guard: renegade IG, "competent protection" tier like loyalist IG
                // and standard chaos forces per the bombard_protect_scores comment below.
                txt2 = "##The Traitor forces are suitably fortified; ";
                bombard_protection = 2;
                break;
            // case 12:
            // txt2="##The Daemonic forces are incredibly difficult to bombard; ";
            // bombard_protection=4;
            // break;
            case 13:
                txt2 = "##The Necron forces are incredibly difficult to bombard; ";
                bombard_protection = 4; // They are a hi-tech faction, so bombing them should be difficult
                break;
        }

        reduced_bombard_score = bombard_ment_power / 3;
        strength_reduction = 0;

        var i = reduced_bombard_score;
        roll = 0;
        var bombard_protect_scores = [
            4,
            0.9,
            0.75,
            0.5,
            0.34
        ];
        bombard_protection = clamp(bombard_protection, 0, 4);
        i *= bombard_protect_scores[bombard_protection];
        // 0 No protection, Nids out in the open use this
        //1:  Poor protection, PDF/Renegades and Ecclesiarchy use it,
        // 2: Competent protection - IG, standard chaos forces and Orks
        // 3: Hi-tech, Admech, Tau and Daemons kind of
        // 4: Figured I add a level 4 to this, Ultra hi-tech, Necrons and Eldar

        for (var r = 0; r < 100; r++) {
            if (i < 1) {
                break;
            }
            i--;
            strength_reduction++;
        }
        if ((i < 1) && (i >= 0.5)) {
            i = i * 100;
            roll = irandom(100) == 1;
            if (roll <= i) {
                strength_reduction += 1;
            }
        }

        strength_reduction = round(strength_reduction);
        txt2 += "they suffer";

        if ((bombard_target_faction == 10) && (planet_type == "Daemon")) {
            strength_reduction = 0;
        }

        var rel = 0;
        if ((strength_reduction != 0) && (target_strength != 0)) {
            rel = ((target_strength - strength_reduction) / target_strength) * 100;
        } else if (strength_reduction == 0) {
            txt2 += " no losses from the bombardment.";
        }
        // Okay, I can see this needs tweaks, just, how can I make it that it checks for 3 conditions, instead of just 2?
        // Would this work:
        // if (rel>0 && rel<=20 && (target_strength-strength_reduction)>0){
        //	txt2+=" minor losses from the bombardment, decreasing "+string(strength_reduction)+" stages.";
        // ?
        // Only describe losses when there was a reduction; otherwise the "no losses" line
        // above already covered it and this used to append a second, contradictory
        // "some losses ... decreased by 0" sentence.
        if (strength_reduction > 0) {
            if ((target_strength - strength_reduction) <= 0) {
                txt2 += " total annihilation from the bombardment and are wiped clean from the planet.";
            } else {
                var _losses_text = "";
                if (rel > 0 && rel <= 20) {
                    _losses_text = "minor losses";
                } else if (rel > 20 && rel <= 40) {
                    _losses_text = "moderate losses";
                } else if (rel > 40 && rel <= 60) {
                    _losses_text = "heavy losses";
                } else if (rel > 60 && (target_strength - strength_reduction) > 0) {
                    _losses_text = "devastating losses";
                } else {
                    _losses_text = "some losses";
                }
                txt2 += $" {_losses_text} from the bombardment, having presence decreased by {strength_reduction}.";
            }
        }

        // 135; ?
        if (bombard_target_faction >= 6) {
            obj_controller.penitent_turn = 0;
            obj_controller.penitent_turnly = 0;
        }

        if (strength_reduction > 0) {
            // Faction 2.5 being renegades, interesting
            if ((bombard_target_faction == 2.5) && (current_owner == 8)) {
                var wib = "", wob = 0;

                txt2 = "##The renegade forces are poorly fortified; ";

                wob = bombard_ment_power * 5000000 + choose(floor(random(100000)), floor(random(100000)) * -1);

                if (wob > system.p_pdf[planet]) {
                    wob = system.p_pdf[planet];
                }
                rel = (system.p_pdf[planet] / wob) * 100;
                system.p_pdf[planet] -= wob;

                if ((rel > 0) && (rel <= 20)) {
                    txt2 += " they suffer minor losses from the bombardment, " + string(scr_display_number(wob)) + " purged.";
                }
                if ((rel > 20) && (rel <= 40)) {
                    txt2 += " they suffer moderate losses from the bombardment, " + string(scr_display_number(wob)) + " purged.";
                }
                if ((rel > 40) && (rel <= 60)) {
                    txt2 += " they suffer heavy losses from the bombardment, " + string(scr_display_number(wob)) + " purged.";
                }
                if ((rel > 60) && (system.p_pdf[planet] > 0)) {
                    txt2 += " they suffer devastating losses from the bombardment, " + string(scr_display_number(wob)) + " purged.";
                }
                if ((wob > 0) && (system.p_pdf[planet] == 0)) {
                    txt2 += " they suffer total annihilation from the bombardment and are wiped clean from the planet.";
                }
            }

            switch (bombard_target_faction) {
                // case 1:
                // system.p_marines[planet]-=strength_reduction;
                // break;
                // case 2:
                // system.p_ig[planet]-=strength_reduction;
                // break;
                // case 3:
                // system.p_mechanicus[planet]-=strength_reduction;
                // break;
                // case 4:
                // system.p_inquisition[planet]-=strength_reduction;
                // break;
                case 5:
                    system.p_sisters[planet] -= strength_reduction;
                    break;
                case 6:
                    system.p_eldar[planet] -= strength_reduction;
                    break;
                case 7:
                    system.p_orks[planet] -= strength_reduction;
                    break;
                case 8:
                    system.p_tau[planet] -= strength_reduction;
                    break;
                case 9:
                    system.p_tyranids[planet] -= strength_reduction;
                    break;
                case 10: {
                    // planet_forces[eFACTION.CHAOS] (the strength this bombardment was aimed
                    // and reported against) is p_chaos + p_demons, but this wrote p_traitors,
                    // the eFACTION.HERETICS force. The bombarded Chaos force never shrank (and
                    // p_traitors could go negative) while the report could claim total
                    // annihilation. Reduce p_chaos first, spill any remainder into p_demons.
                    var _chaos_cut = min(system.p_chaos[planet], strength_reduction);
                    system.p_chaos[planet] -= _chaos_cut;
                    var _demon_spill = strength_reduction - _chaos_cut;
                    if (_demon_spill > 0) {
                        system.p_demons[planet] = max(0, system.p_demons[planet] - _demon_spill);
                    }
                    break;
                }
                case 11:
                    system.p_traitors[planet] = max(0, system.p_traitors[planet] - strength_reduction);
                    break;
                // case 12:
                // system.p_demons[planet]-=strength_reduction;
                // break;
                case 13:
                    system.p_necrons[planet] -= strength_reduction;
                    break;
            }
        }

        if (kill > 0) {
            kill = min(system.p_population[planet], kill);
        }

        txt3 = ""; // Life is the Emperor's currency. Spend it well
        if (pop_before > 0 && planet_type != "Daemon") {
            var _displayed_population = system.p_large[planet] == 1 ? $"{pop_before} billion" : scr_display_number(floor(pop_before));
            var _displayed_killed = system.p_large[planet] == 1 ? $"{kill} billion" : scr_display_number(floor(kill));
            if (pop_after == 0) {
                heres_after = 0;
            }
            txt3 += $"##The world had {_displayed_population} Imperium subjects. {_displayed_killed} died over the duration of the bombardment,##Heresy has fallen down to {max(0, heres_after)}%.";
        }

        // DO EET
        if (pop_before > 0) {
            system.p_population[planet] = pop_before - kill;
            system.p_heresy[planet] -= sci1;
            system.p_influence[planet][eFACTION.TAU] -= sci1; // TODO LOW PURGE_INFLUENCE // Make this affect all influences
            if (system.p_heresy[planet] < 0) {
                system.p_heresy[planet] = 0;
            }
            if (system.p_influence[planet][eFACTION.TAU] < 0) {
                system.p_influence[planet][eFACTION.TAU] = 0;
            }
        }

        var pip = instance_create(0, 0, obj_popup);
        pip.title = "Bombard Results";
        pip.text = txt1 + txt2 + txt3;
        //pip.text=txt1+txt2+txt3+" "+string(sci1)+" "+string(heres_before)+" "+string(heres_after); // TODO LOW DEBUG_INFLUENCE // Put in debug code path and make it clearer

        if (pop_after == 0 && pop_before > 0) {
            if ((current_owner == 2) && (obj_controller.faction_status[eFACTION.IMPERIUM] != "War")) {
                if (planet_type == "Temperate" || planet_type == "Hive" || planet_type == "Desert") {
                    var _disp_neg = 0;
                    if (planet_type == "Temperate") {
                        _disp_neg -= 5;
                    } else if (planet_type == "Desert") {
                        _disp_neg -= 3;
                    } else if (planet_type == "Hive") {
                        _disp_neg -= 10;
                    }
                    scr_audience(eFACTION.IMPERIUM, "bombard_angry", _disp_neg,);
                }
            } else if ((current_owner == 3) && (obj_controller.faction_status[eFACTION.MECHANICUS] != "War")) {
                var _disp_neg = 0;
                if (planet_type == "Forge") {
                    _disp_neg -= 15;
                } else if (planet_type == "Ice") {
                    _disp_neg -= 7;
                }
                scr_audience(eFACTION.MECHANICUS, "bombard_angry", _disp_neg,);
            }
            if (planet_feature_bool(system.p_feature[planet], eP_FEATURES.GENE_STEALER_CULT)) {
                delete_features(system.p_feature[planet], eP_FEATURES.GENE_STEALER_CULT);
                adjust_influence(eFACTION.TYRANIDS, -100, planet, system);
                pip.text += " The xeno taint of the tyranids that was infesting the population has been completely eradicated with the planets cleansing";
            } else {
                pip.text += " Any xeno taint that was infesting the population has been completely eradicated with the planets cleansing";
            }
        }
        if ((bombard_target_faction == 8) && (obj_controller.faction_status[eFACTION.TAU] != "War")) {
            scr_audience(eFACTION.TAU, choose("declare_war", "bombard_angry"), -15,);
        }
    }

    if (planet_type == "Space Hulk") {
        var bombard_protection = 1;
        txt1 = "Torpedoes and Bombardment Cannons rain hell upon the space hulk; ";

        reduced_bombard_score = bombard_ment_power / 1.25; // fraction of bombardment score, TODO maybe we should make SHs more vulnerable to bombardment? They are out in space, and can be targeted with other weapons
        strength_reduction = 0;
        txt3 = "";

        var rel = 0;

        if (reduced_bombard_score != 0) {
            rel = ((system.p_fortified[planet] - reduced_bombard_score) / system.p_fortified[planet]) * 100;
        }

        if (strength_reduction == 0) {
            txt2 = "it suffers minimal damage from the bombardment.";
        }
        if ((rel > 0) && (rel <= 20)) {
            txt2 = "it suffers minor damage from the bombardment, its integrity reduced by " + string(100 - rel) + "%";
        }
        if ((rel > 20) && (rel <= 40)) {
            txt2 = "it suffers moderate damage from the bombardment, its integrity reduced by " + string(100 - rel) + "%";
        }
        if ((rel > 40) && (rel <= 60)) {
            txt2 = "it suffers heavy damage from the bombardment, its integrity reduced by " + string(100 - rel) + "%";
        }
        if ((rel > 60) && ((system.p_fortified[planet] - reduced_bombard_score) > 0)) {
            txt2 = "it suffers extensive damage from the bombardment, its integrity reduced by " + string(100 - rel) + "%";
        }
        if ((system.p_fortified[planet] - reduced_bombard_score) <= 0) {
            txt2 = "it crumbles apart from the onslaught. It is no more.";
        } // Potential TODO Consider adding salvage from the bombed wreckage

        // DO EET
        if (reduced_bombard_score > 0) {
            system.p_fortified[planet] -= reduced_bombard_score;
        }

        if (system.p_fortified[planet] <= 0) {
            with (system) {
                instance_destroy();
            }
            instance_activate_object(obj_star_select);
            with (obj_star_select) {
                instance_destroy();
            }
            obj_controller.sel_system_x = 0;
            obj_controller.sel_system_y = 0;
            obj_controller.popup = 0;
            obj_controller.cooldown = 8;
        }

        var pip;
        pip = instance_create(0, 0, obj_popup);
        pip.title = "Bombard Results";
        pip.text = txt1 + txt2 + txt3;
    }

    // Fleet movement lock preserved (bombarding ends the fleet's turn for movement).
    // Every ship the player selected spends its whole support allowance, so each ship
    // bombards at most once per turn. Previously only the first fresh ship was spent
    // regardless of how many were selected, so the remaining selected ships stayed
    // fresh and could be re-selected to bombard the same world again on the next
    // Confirm, letting one fleet fire several times over.
    obj_bomb_select.sh_target.acted = 5;
    with (obj_bomb_select) {
        for (var _bspend = 0; _bspend < array_length(ship_ide); _bspend++) {
            if ((ship_all[_bspend] == 1) && (ship_ide[_bspend] >= 0)) {
                ship_bombard_spend(ship_ide[_bspend]);
            }
        }
    }
    with (obj_bomb_select) {
        instance_destroy();
    }
    // show_message("Pop: "+string(pop_before)+" -> "+string(pop_after)+"#killed: "+string(kill)+"#Heresy: "+string(heres_before)+" -> "+string(heres_after));
}

/// @desc Rough, bracketed preview of a bombardment's effect for the selection dialog,
/// so the player can see roughly what a bombard will do before committing. Mirrors the
/// kill and strength_reduction math in scr_bomb_world above. Returns a struct with two
/// labels, population and enemy, each one of None / Negligible / Low / Medium / High /
/// Massive. It is an estimate: it ignores the sub-1 random reduction roll and the Ork
/// Stronghold / Daemon-world specials.
function bombard_effect_estimate(_planet, _target_faction, _bomb_power, _target_strength) {
    // Population: scr_bomb_world kills a fixed slice (0.15) of the planet's own scale,
    // subtracted straight from population, so it does not scale with ship count. On a
    // small world that fixed slice dwarfs the whole population and wipes it out, which
    // is the surprise this preview exists to warn about.
    var _pop_pct = 0;
    var _pop_before = _planet.population;
    if ((_pop_before > 0) && (_planet.planet_type != "Space Hulk")) {
        var _kill = bombard_population_kill(_planet, _target_strength);
        _pop_pct = (min(_pop_before, _kill) / _pop_before) * 100;
    }

    // Enemy: same reduction math as scr_bomb_world. The reduced score, scaled by the
    // target's bombard protection, is how many strength stages come off.
    var _en_pct = 0;
    if (_target_strength > 0) {
        var _reduced = _bomb_power / 3;
        var _protection = clamp(bombard_protection_estimate(_target_faction), 0, 4);
        var _protect_scores = [4, 0.9, 0.75, 0.5, 0.34];
        var _stages = floor(_reduced * _protect_scores[_protection]);
        _en_pct = (min(_stages, _target_strength) / _target_strength) * 100;
    }

    return {
        population: bombard_effect_bracket(_pop_pct),
        enemy: bombard_effect_bracket(_en_pct),
    };
}

/// @desc Base bombard protection tier per target faction, matching the switch in
/// scr_bomb_world (Ork Stronghold and Daemon-world bonuses are left out of the estimate).
function bombard_protection_estimate(_faction) {
    switch (_faction) {
        case 2: return 2;
        case 2.5: return 1;
        case 3: return 3;
        case 5: return 1;
        case 6: return 4;
        case 7: return 2;
        case 8: return 3;
        case 9: return 0;
        case 10: return 2;
        case 11: return 2;
        case 13: return 4;
    }
    return 1;
}

/// @desc Map a 0-100 percentage to a coarse severity label for the bombard preview.
function bombard_effect_bracket(_pct) {
    if (_pct <= 0) {
        return "None";
    }
    if (_pct < 5) {
        return "Negligible";
    }
    if (_pct < 20) {
        return "Low";
    }
    if (_pct < 45) {
        return "Medium";
    }
    if (_pct < 80) {
        return "High";
    }
    return "Massive";
}

/// @desc Colour for a bombard severity label so the worst outcomes read at a glance.
function bombard_effect_bracket_color(_label) {
    switch (_label) {
        case "None": return c_gray;
        case "Negligible": return #34bc75;
        case "Low": return #34bc75;
        case "Medium": return c_yellow;
        case "High": return c_orange;
        case "Massive": return c_red;
    }
    return c_white;
}
