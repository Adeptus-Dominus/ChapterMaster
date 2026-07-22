/// Sector war directives. The Discuss button on the Imperium diplomacy screen lets
/// the player review and set the standing strategic order the Sector Commander's
/// forces pursue each turn. State lives on obj_controller as plain fields (the
/// reflective serializer saves them); ensure() backfills saves from before this
/// feature existed.
///
/// Directives:
///   "defend"   (default) Imperium-owned worlds slowly rebuild their PDF.
///   "reclaim"  Every SECTOR_RECLAIM_INTERVAL turns the Guard counterattack the
///              hostile-held world with the weakest grip, reducing its force level.
///   "contain_ork" / "contain_tau" / "contain_eldar" / "contain_chaos"
///              Every SECTOR_DIRECTIVE_STRIKE_INTERVAL turns the Guard strike the
///              contained faction's strongest world; containing the Eldar also
///              pushes the next incursion out every other turn.

function sector_directive_ensure() {
    if (!variable_instance_exists(obj_controller, "sector_directive")) {
        obj_controller.sector_directive = "defend";
    }
    if (!variable_instance_exists(obj_controller, "sector_directive_turn")) {
        obj_controller.sector_directive_turn = -SECTOR_DIRECTIVE_COOLDOWN;
    }
    // Optional planet the player has asked the Guard offensive to prioritise. "" name
    // means "no preference": the strike falls back to the strongest enemy world, as
    // before. Backfilled here so pre-feature saves load clean.
    if (!variable_instance_exists(obj_controller, "sector_directive_target_star")) {
        obj_controller.sector_directive_target_star = "";
    }
    if (!variable_instance_exists(obj_controller, "sector_directive_target_planet")) {
        obj_controller.sector_directive_target_planet = -1;
    }
}

/// Player points the Guard offensive at a specific world (or clears it with ""). The
/// strike still only fires on its own interval and only while a contain directive is
/// active; this just steers WHERE it lands.
/// @function sector_faction_has_presence
/// @description True if the given faction currently holds at least one planet in the sector.
///              Used to decide which threats the Sector Governor will offer to grind down:
///              a faction actively present is a valid containment target even if the Chapter
///              has not formally "discovered" it (the Governor commands the sector and knows
///              what is loose in it), which is why the containment menu gates on this rather
///              than on the player's known[] awareness flag.
/// @param {Real} _faction
/// @returns {Bool}
function sector_faction_has_presence(_faction) {
    var _found = false;
    with (obj_star) {
        for (var p = 1; p <= planets; p++) {
            if (p_owner[p] == _faction) {
                _found = true;
                break;
            }
        }
        if (_found) {
            break;
        }
    }
    return _found;
}

function sector_directive_set_target(_star_name, _planet) {
    sector_directive_ensure();
    obj_controller.sector_directive_target_star = _star_name;
    obj_controller.sector_directive_target_planet = _planet;
}

function sector_directive_get() {
    sector_directive_ensure();
    return obj_controller.sector_directive;
}

function sector_directive_can_change() {
    sector_directive_ensure();
    return (obj_controller.turn - obj_controller.sector_directive_turn) >= SECTOR_DIRECTIVE_COOLDOWN;
}

function sector_directive_label(_d = sector_directive_get()) {
    switch (_d) {
        case "reclaim": return "reclaiming the worlds the Imperium has lost";
        case "contain_ork": return "containing the Ork menace";
        case "contain_tau": return "containing the T'au expansion";
        case "contain_eldar": return "containing the Eldar raids";
        case "contain_chaos": return "containing the forces of Chaos";
    }
    return "holding and garrisoning the sector's core worlds";
}

/// Applies a directive chosen in the Discuss dialogue and writes the Sector
/// Commander's reply into diplo_text. Non-default directives cost a little
/// standing: the player is commandeering sector strategy.
function sector_directive_apply_choice(_directive) {
    sector_directive_ensure();
    if (obj_controller.sector_directive == _directive) {
        obj_controller.diplo_text = "That is already my standing order, Chapter Master. It shall continue.";
        return;
    }
    if (!sector_directive_can_change()) {
        obj_controller.diplo_text = "My regiments are already redeploying. I will not turn the sector's armies about on a whim; return when they have marched.";
        return;
    }
    obj_controller.sector_directive = _directive;
    obj_controller.sector_directive_turn = obj_controller.turn;
    if (_directive != "defend") {
        alter_disposition(eFACTION.IMPERIUM, -SECTOR_DIRECTIVE_DISPO_COST);
    }
    switch (_directive) {
        case "defend":
            obj_controller.diplo_text = "Sensible. The core worlds will be garrisoned and held; the Guard dig in.";
            break;
        case "reclaim":
            obj_controller.diplo_text = "Then we take back what was lost. My regiments will land where the enemy's grip is weakest.";
            break;
        case "contain_ork":
            obj_controller.diplo_text = "The greenskins, then. Every Waaagh we break now is a war we do not fight later.";
            break;
        case "contain_tau":
            obj_controller.diplo_text = "The T'au speak of a Greater Good. My regiments will teach them a greater fear.";
            break;
        case "contain_eldar":
            obj_controller.diplo_text = "Hunting shadows is thankless work, but the raids will be answered. So ordered.";
            break;
        case "contain_chaos":
            obj_controller.diplo_text = "The Archenemy. My men will burn the taint wherever it takes root. The Emperor protects.";
            break;
    }
}

/// The contain-directive string that campaigns against a faction, or "" if none does.
function sector_directive_for_faction(_faction) {
    switch (_faction) {
        case eFACTION.ORK:   return "contain_ork";
        case eFACTION.TAU:   return "contain_tau";
        case eFACTION.ELDAR: return "contain_eldar";
        case eFACTION.CHAOS:
        case eFACTION.HERETICS: return "contain_chaos";
    }
    return "";
}

/// True if this world+faction is the Guard offensive's current directed target.
function sector_directive_is_target(_star, _planet, _faction) {
    sector_directive_ensure();
    return (obj_controller.sector_directive_target_star == _star.name)
        && (obj_controller.sector_directive_target_planet == _planet)
        && (sector_directive_get() == sector_directive_for_faction(_faction));
}

/// Force level a faction holds on a planet. Explicit per-array mapping: Chaos and
/// Heretics read whichever of p_chaos / p_traitors is larger, keeping this clear of
/// the 10/11 read/write inversion that bites eFACTION-keyed helpers in combat code.
function sector_directive_force_get(_star, _planet, _faction) {
    with (_star) {
        switch (_faction) {
            case eFACTION.ORK: return p_orks[_planet];
            case eFACTION.TAU: return p_tau[_planet];
            case eFACTION.ELDAR: return p_eldar[_planet];
            case eFACTION.TYRANIDS: return p_tyranids[_planet];
            case eFACTION.NECRONS: return p_necrons[_planet];
            case eFACTION.CHAOS:
            case eFACTION.HERETICS:
                return max(p_chaos[_planet], p_traitors[_planet]);
        }
    }
    return 0;
}

function sector_directive_force_reduce(_star, _planet, _faction) {
    with (_star) {
        switch (_faction) {
            case eFACTION.ORK: p_orks[_planet] = max(0, p_orks[_planet] - 1); faction_pop_clamp_to_level(_star, _planet, eFACTION.ORK); return true;
            case eFACTION.TAU: p_tau[_planet] = max(0, p_tau[_planet] - 1); return true;
            case eFACTION.ELDAR: p_eldar[_planet] = max(0, p_eldar[_planet] - 1); return true;
            case eFACTION.TYRANIDS: p_tyranids[_planet] = max(0, p_tyranids[_planet] - 1); faction_pop_clamp_to_level(_star, _planet, eFACTION.TYRANIDS); return true;
            case eFACTION.NECRONS: p_necrons[_planet] = max(0, p_necrons[_planet] - 1); faction_pop_clamp_to_level(_star, _planet, eFACTION.NECRONS); return true;
            case eFACTION.CHAOS:
            case eFACTION.HERETICS:
                if (p_traitors[_planet] >= p_chaos[_planet]) {
                    p_traitors[_planet] = max(0, p_traitors[_planet] - 1);
                    faction_pop_clamp_to_level(_star, _planet, eFACTION.HERETICS);
                } else {
                    p_chaos[_planet] = max(0, p_chaos[_planet] - 1);
                }
                return true;
        }
    }
    return false;
}

/// Guard offensive against the contained faction: hit its strongest-held world.
function sector_directive_strike(_faction) {
    var _best_star = noone;
    var _best_planet = -1;
    var _best_force = 0;

    // Player-directed target takes priority: if the world the player pinned still has
    // this faction on it, the Guard offensive lands there instead of auto-picking the
    // strongest world. This is how the player concentrates the background war on the
    // planet they are personally fighting for.
    var _tgt_name = obj_controller.sector_directive_target_star;
    var _tgt_planet = obj_controller.sector_directive_target_planet;
    if ((_tgt_name != "") && (_tgt_planet > 0)) {
        var _tgt_star = find_star_by_name(_tgt_name);
        if (instance_exists(_tgt_star) && (_tgt_planet <= _tgt_star.planets)
        && (sector_directive_force_get(_tgt_star, _tgt_planet, _faction) > 0)) {
            _best_star = _tgt_star;
            _best_planet = _tgt_planet;
        }
    }

    if (_best_planet < 0) {
        with (obj_star) {
            for (var p = 1; p <= planets; p++) {
                var _f = sector_directive_force_get(id, p, _faction);
                if (_f > _best_force) {
                    _best_force = _f;
                    _best_star = id;
                    _best_planet = p;
                }
            }
        }
    }
    if (_best_planet < 0) {
        return false;
    }
    sector_directive_force_reduce(_best_star, _best_planet, _faction);
    scr_event_log("green", $"Sector Guard offensive strikes the {region_faction_name(_faction)} on {_best_star.name} {scr_roman(_best_planet)}.");
    return true;
}

/// Guard counterattack: retake ground on the hostile-held world with the weakest grip.
function sector_directive_reclaim() {
    var _best_star = noone;
    var _best_planet = -1;
    var _best_force = 9999;
    with (obj_star) {
        for (var p = 1; p <= planets; p++) {
            var _owner = p_owner[p];
            if (!region_faction_is_hostile(_owner)) {
                continue;
            }
            var _f = sector_directive_force_get(id, p, _owner);
            if ((_f > 0) && (_f < _best_force)) {
                _best_force = _f;
                _best_star = id;
                _best_planet = p;
            }
        }
    }
    if (_best_planet < 0) {
        return false;
    }
    var _owner = _best_star.p_owner[_best_planet];
    sector_directive_force_reduce(_best_star, _best_planet, _owner);
    scr_event_log("green", $"Imperial Guard counterattack retakes ground from the {region_faction_name(_owner)} on {_best_star.name} {scr_roman(_best_planet)}.");
    return true;
}

/// Runs once per turn from scr_end_turn.
/// True once a non-default directive has stood past its duration and should revert.
function sector_directive_has_lapsed() {
    sector_directive_ensure();
    if (obj_controller.sector_directive == "defend") {
        return false;
    }
    return (obj_controller.turn - obj_controller.sector_directive_turn) >= SECTOR_DIRECTIVE_DURATION;
}

function sector_directive_tick() {
    sector_directive_ensure();
    // Lapse: a war order the Commander was given expires after SECTOR_DIRECTIVE_DURATION
    // turns and reverts to defend, so the player must return to renew it (or set a new
    // one). The directive_turn stamp is left alone: the cooldown already elapsed long ago
    // (duration > cooldown), so the player can immediately re-issue orders on the visit
    // that follows a lapse.
    if (sector_directive_has_lapsed()) {
        obj_controller.sector_directive = "defend";
        scr_event_log("yellow", "The Sector Commander's regiments have completed their campaign and returned to holding the core worlds. He awaits new orders.");
    }
    var _d = obj_controller.sector_directive;
    if (_d == "defend") {
        with (obj_star) {
            for (var p = 1; p <= planets; p++) {
                if (p_owner[p] == eFACTION.IMPERIUM) {
                    p_pdf[p] = min(SECTOR_DEFEND_PDF_CAP, p_pdf[p] + SECTOR_DEFEND_PDF_GROWTH);
                }
            }
        }
        return;
    }
    if (_d == "reclaim") {
        if ((obj_controller.turn % SECTOR_RECLAIM_INTERVAL) == 0) {
            sector_directive_reclaim();
        }
        return;
    }
    var _faction = -1;
    switch (_d) {
        case "contain_ork": _faction = eFACTION.ORK; break;
        case "contain_tau": _faction = eFACTION.TAU; break;
        case "contain_eldar": _faction = eFACTION.ELDAR; break;
        case "contain_chaos": _faction = eFACTION.CHAOS; break;
    }
    if (_faction == -1) {
        return;
    }
    if ((_d == "contain_eldar") && ((obj_controller.turn % 2) == 0) && variable_instance_exists(obj_controller, "eldar_next_incursion")) {
        // Sector patrols make raiding costlier: the next incursion slips a turn
        // every other turn, halving the long-run raid cadence while active.
        obj_controller.eldar_next_incursion += 1;
    }
    if ((obj_controller.turn % SECTOR_DIRECTIVE_STRIKE_INTERVAL) == 0) {
        sector_directive_strike(_faction);
    }
}

/// Maps a world's Guard/PDF headcount to a 1-6 strength tier for the background war roll.
/// Mirrors the coarse banding the PDF defence readout uses, so "a lot of Guard" reads as
/// a high tier without needing the full determine_pdf_defence machinery here.
function sector_background_guard_tier(_star, _planet) {
    // PDF are counted at a fraction of guardsmen: PDF are a defensive militia, not line
    // troops, so a large PDF is worth a modest number of Guard for offensive attrition.
    var _g = 0;
    if (variable_instance_exists(_star, "p_guardsmen")) { _g += _star.p_guardsmen[_planet]; }
    if (variable_instance_exists(_star, "p_pdf")) { _g += _star.p_pdf[_planet] * 0.1; }
    // An Imperial battlefleet in orbit joins the grind: orbital bombardment and Navy landing parties
    // do the work a planetary garrison otherwise would. Without this, a world whose Guard had been
    // wiped out scored tier 0 and could NEVER be ground back, however large the fleet overhead - so
    // a horde that took a world was permanently untouchable by anyone but the player in person.
    var _navy = scr_orbiting_fleet([eFACTION.IMPERIUM, eFACTION.MECHANICUS, eFACTION.INQUISITION, eFACTION.ECCLESIARCHY], _star);
    if (_navy != noone) {
        _g += _navy.capital_number * SECTOR_NAVY_CAPITAL_GUARD;
        _g += _navy.frigate_number * SECTOR_NAVY_FRIGATE_GUARD;
        _g += _navy.escort_number  * SECTOR_NAVY_ESCORT_GUARD;
    }
    if (_g < SECTOR_BACKGROUND_GUARD_MIN) { return 0; }
    // Bands calibrated to real garrison numbers (thousands to hundreds of thousands when
    // reinforced from orbit), NOT the PDF-defence score table. This is what lets a
    // properly reinforced sector actually grind a bloom down over time.
    if (_g >= 500000) { return 6; }
    if (_g >= 150000) { return 5; }
    if (_g >= 50000)  { return 4; }
    if (_g >= 20000)  { return 3; }
    if (_g >= 8000)   { return 2; }
    return 1;
}

/// One planet's background attrition step: the Guard grind a level-modelled enemy the
/// player is NOT the sole answer to. Returns true if the enemy lost ground. The roll
/// favours whichever side has the higher tier, with a swing, so a strong Guard presence
/// reliably erodes a weak enemy and a token garrison rarely dents a horde. The player's
/// own forces are not consulted anywhere here.
function sector_background_war_planet(_star, _planet, _faction) {
    if (count_to_level_anchors(_faction) == -1) { return false; }
    var _enemy_tier = faction_planet_level(_star, _planet, _faction);
    if (_enemy_tier <= 0) { return false; }
    var _guard_tier = sector_background_guard_tier(_star, _planet);
    if (_guard_tier <= 0) { return false; }

    // HoI4-flavoured resolution: strength difference sets the base odds, plus a swing.
    // Positive means the Guard press their advantage this pass. The +15 bias means an
    // even matchup still grinds the enemy down roughly a third of the time (the Guard's
    // industry and numbers slowly tell), while a Guard deficit makes it rare but not
    // impossible. A clear Guard edge grinds reliably.
    var _delta = _guard_tier - _enemy_tier;
    var _roll = _delta * 25 + irandom(100) - 50 + 15;
    if (_roll <= 0) { return false; }

    // The enemy headcount falls toward the next tier down; the clamp re-tiers it. A big
    // Guard edge can knock a whole level, a marginal one shaves the population.
    var _pop = planet_faction_pop(_star, _planet, _faction);
    var _cut = (_delta >= 2) ? 0.5 : 0.2;
    var _new_pop = max(0, round(_pop * (1 - _cut)));
    sector_background_apply_pop(_star, _planet, _faction, _new_pop);
    return true;
}

/// Writes a reduced headcount back to the faction's level, using the same conversion the
/// battle-victory path uses so the two stay consistent (level array is authoritative for
/// combat sizing; the clamp trims p_race_pop into the new band).
function sector_background_apply_pop(_star, _planet, _faction, _new_pop) {
    var _new_lvl = count_to_level(_faction, _new_pop);
    with (_star) {
        switch (_faction) {
            case eFACTION.ORK:      p_orks[_planet] = _new_lvl; break;
            case eFACTION.TAU:      p_tau[_planet] = _new_lvl; break;
            case eFACTION.ELDAR:    p_eldar[_planet] = _new_lvl; break;
            case eFACTION.TYRANIDS: p_tyranids[_planet] = _new_lvl; break;
            case eFACTION.NECRONS:  p_necrons[_planet] = _new_lvl; break;
            case eFACTION.HERETICS: p_traitors[_planet] = _new_lvl; break;
        }
    }
    if (variable_instance_exists(_star, "p_race_pop")) {
        _star.p_race_pop[_planet][_faction] = _new_pop;
    }
    faction_pop_clamp_to_level(_star, _planet, _faction);
}

/// Sector-wide background war pass: runs every SECTOR_BACKGROUND_WAR_INTERVAL turns.
/// For each world, the Guard grind whichever level-modelled enemy is present. Logs a
/// concise notice per world that lost ground so the player sees the tide moving.
function sector_background_war_tick() {
    if ((obj_controller.turn % SECTOR_BACKGROUND_WAR_INTERVAL) != 0) { return; }
    var _factions = [eFACTION.ORK, eFACTION.TAU, eFACTION.ELDAR, eFACTION.TYRANIDS, eFACTION.NECRONS, eFACTION.HERETICS];
    with (obj_star) {
        for (var p = 1; p <= planets; p++) {
            for (var f = 0; f < array_length(_factions); f++) {
                if (sector_background_war_planet(id, p, _factions[f])) {
                    scr_event_log("c_gray", $"Sector Guard grind the {region_faction_name(_factions[f])} on {name} {scr_roman(p)}.", name);
                }
            }
        }
    }
}
