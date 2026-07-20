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
