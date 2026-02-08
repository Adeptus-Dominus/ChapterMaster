function unit_apothecary_points_gen(turn_end = false) {
    var _trained_person = IsSpecialist(SPECIALISTS_APOTHECARIES);
    var reasons = {};
    var points = 0;
    if (_trained_person) {
        var points = ((technology / 2) + (wisdom / 2) + intelligence) / 8;
        reasons.points = points;
    }
    return [points, reasons];
}

function unit_forge_point_generation(turn_end = false) {
    var _trained_person = IsSpecialist(SPECIALISTS_TECHS);
    var crafter = has_trait("crafter");
    var reasons = {};
    var points = 0;
    if (_trained_person) {
        var points = technology / 5;
        reasons.trained = points;
    }
    if (job != "none") {
        if (job.type == "forge") {
            if (crafter) {
                points *= 3;
                reasons.at_forge = "x3 (Crafter)";
            } else {
                points *= 2;
                reasons.at_forge = "x2";
            }
            points += 6;
            if (turn_end) {
                add_exp(0.2);
            }
        }
    }
    if (crafter) {
        points += 6;
        reasons.crafter = 6;
    }
    if (role() == "Forge Master") {
        points += 10;
        reasons.master = 10;
    }
    var maintenance = equipment_maintenance_burden();
    points -= maintenance;
    reasons.maintenance = $"-{maintenance}";
    if (has_trait("tinkerer")) {
        reasons.maintenance += "\n    X0.5";
    }
    if (!is_dreadnought()) {
        var _tech_score_mod = 1 / (technology / 30);
        reasons.maintenance += $"\n    tech modifier : X{_tech_score_mod} (lower is better)";
    }
    return [points, reasons];
}

/// @param {string} _research_name
function scr_advance_research(_research_name) {
    array_push(obj_controller.technologies_known, _research_name);
}

function research_end() {
    specialist_point_handler.calculate_research_points(true);
    stc_research[$ stc_research.research_focus] += specialist_point_handler.research_points;
    var research_area_limit;
    if (stc_research.research_focus == "vehicles") {
        research_area_limit = stc_vehicles;
    } else if (stc_research.research_focus == "wargear") {
        research_area_limit = stc_wargear;
    } else if (stc_research.research_focus == "ships") {
        research_area_limit = stc_ships;
    }
    if (stc_research[$ stc_research.research_focus] > 5000 * (research_area_limit + 1)) {
        advance_stc_research(stc_research.research_focus, true);
    }
}

function advance_stc_research(_target, _free = false) {
    with (obj_controller) {
        switch (_target) {
            case "wargear":
                if (!_free) {
                    stc_wargear_un--;
                }
                stc_wargear++;
                if (stc_wargear == 2) {
                    stc_bonus[1] = irandom_range(1, 5);
                }
                if (stc_wargear == 4) {
                    stc_bonus[2] = irandom_range(1, 3);
                }
                stc_research.wargear = 0;
                break;
            case "vehicles":
                if (!_free) {
                    stc_vehicles_un--;
                }
                stc_vehicles++;
                if (stc_vehicles == 2) {
                    stc_bonus[3] = irandom_range(1, 5);
                }
                if (stc_vehicles == 4) {
                    stc_bonus[4] = irandom_range(1, 3);
                }
                stc_research.vehicles = 0;
                break;
            case "ships":
                if (!_free) {
                    stc_ships_un--;
                }
                stc_ships++;
                if (stc_ships == 2) {
                    stc_bonus[5] = irandom_range(1, 5);
                }
                if (stc_ships == 4) {
                    stc_bonus[6] = irandom_range(1, 3);
                }
                stc_research.ships = 0;
                break;
            default:
                global.logger.error($"Unknown target: {_target}");
                break;
        }
    }
}
