/// scr_region_functions
/// Background data layer for multi-region planets (Sector Governor roadmap, item B).
///
/// A planet is modelled as a small board of regions: one capital plus a variable number of
/// outlying regions (count depends on planet size/type). Each region has its own owner,
/// population, garrison, defences and buildings, so a single planet can be CONTESTED
/// (different factions holding different regions at once).
///
/// Storage: obj_star.p_regions[planet] = array of Region records. It uses the same p_* naming
/// as every other planet array, so it is serialized/deserialized automatically by obj_star's
/// generic save code with no extra work. Regions restored from a save are plain structs, so all
/// logic lives here and only ever touches Region FIELDS (never methods).
///
/// The legacy per-planet scalars (p_owner, p_population, p_pdf, ...) remain the "rollup" summary
/// so that the large body of existing non-region-aware code keeps working. regions_rollup()
/// recomputes them from the regions. Consumers (invasion, combat, UI) will be migrated to read
/// regions directly in later passes; until then this layer is additive and safe.

#region generation

/// @function region_name_pool
/// @description Static pool of outlying-region display names (capital is named separately).
///              Names are drawn RANDOMLY and without repeats per planet (see region_pick_zone_names),
///              so worlds no longer share the same fixed zone list. Add names freely.
/// @returns {Array<String>}
function region_name_pool() {
    static _pool = [
        "Northern Reaches", "Southern Expanse", "Eastern Marches", "Western Wastes",
        "Coastal Sprawl", "Highland Districts", "Equatorial Belt", "Polar Zone",
        "The Ashlands", "Ferrous Flats", "Sundered Coast", "Ironhold Basin",
        "The Pale Wastes", "Emberfields", "Duststorm Barrens", "The Rustmarch",
        "Cinder Reach", "The Hollow Vale", "Blackspire District", "Saltmarsh Expanse",
        "The Verdant Belt", "Grimhold District", "The Shattered Plains", "Umbral Reaches",
        "Stormwall Coast", "The Glasslands", "Ridgeback Highlands", "The Great Mire",
        "Farrow Steppes", "The Chasm Districts", "Aurelian Flats", "The Wraithmoor",
    ];
    return _pool;
}

/// @function region_pick_zone_names
/// @description Picks _count zone names at random with no repeats within one planet. If more regions
///              than names are ever needed, falls back to numbered "Zone N".
/// @param {Real} _count
/// @returns {Array<String>}
function region_pick_zone_names(_count) {
    var _pool = region_name_pool();
    var _n = array_length(_pool);
    var _avail = array_create(_n);
    array_copy(_avail, 0, _pool, 0, _n);

    var _names = [];
    for (var i = 0; i < _count; i++) {
        if (array_length(_avail) > 0) {
            var _idx = irandom(array_length(_avail) - 1);
            array_push(_names, _avail[_idx]);
            array_delete(_avail, _idx, 1);
        } else {
            array_push(_names, "Zone " + string(i + 1));
        }
    }
    return _names;
}

/// @function region_count_for_planet
/// @description How many regions a planet should have, varying by size/type. Big population
///              worlds get the full capital + 3 spread; smaller worlds get fewer; dead/empty
///              worlds get a single region.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function region_count_for_planet(_star, _planet) {
    var _type = _star.p_type[_planet];
    var _large = _star.p_large[_planet];
    var _max_pop = _star.p_max_population[_planet];

    if ((_type == "Dead") || (_type == "Daemon") || (_type == "Craftworld") || (_max_pop <= 0)) {
        return 1;
    }

    switch (_type) {
        case "Hive":
        case "Forge":
        case "Temperate":
        case "Shrine":
        case "Feudal":
        case "Desert":
            return 4; // capital + 3
        case "Ice":
        case "Agri":
        case "Death":
            return 3; // capital + 2
        case "Lava":
            return 2; // capital + 1
    }

    // Fallback by raw size proxy for any unlisted type.
    if (_large == 1) {
        return 4;
    }
    if (_max_pop >= 1000000) {
        return 3;
    }
    return 2;
}

/// @function region_dominant_force_level
/// @description Highest 0-5 "problem" level across the non-Imperial faction arrays for a planet.
///              Used to seed a region's force_level so ork/tau/nid worlds keep their strength
///              when regionised.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function region_dominant_force_level(_star, _planet) {
    return max(
        _star.p_orks[_planet],
        _star.p_tau[_planet],
        _star.p_tyranids[_planet],
        _star.p_sisters[_planet],
        _star.p_eldar[_planet],
        _star.p_chaos[_planet],
        _star.p_traitors[_planet],
        _star.p_necrons[_planet]
    );
}

/// @function region_distribute_total
/// @description Distributes an integer total across regions using weights: the capital counts as
///              _capital_weight outlying regions (so it is always the largest single region), the
///              rest split evenly. Any rounding remainder is added to the capital so the sum of
///              the field across regions equals _total exactly.
/// @param {Array<Struct.Region>} _regions
/// @param {Real} _total
/// @param {Real} _capital_weight Weight of the capital relative to 1.0 per outlying region (>= 1).
/// @param {String} _field Region field name to write.
/// @returns {Undefined}
function region_distribute_total(_regions, _total, _capital_weight, _field) {
    var _n = array_length(_regions);
    if (_n <= 0) {
        return;
    }
    if (_n == 1) {
        _regions[0][$ _field] = _total;
        return;
    }

    var _total_weight = _capital_weight + (_n - 1);
    var _cap = floor(_total * (_capital_weight / _total_weight));
    var _each = floor(_total * (1 / _total_weight));
    var _assigned = 0;

    for (var i = 0; i < _n; i++) {
        if (_regions[i].is_capital) {
            _regions[i][$ _field] = _cap;
            _assigned += _cap;
        } else {
            _regions[i][$ _field] = _each;
            _assigned += _each;
        }
    }

    var _remainder = _total - _assigned;
    if (_remainder != 0) {
        for (var i = 0; i < _n; i++) {
            if (_regions[i].is_capital) {
                _regions[i][$ _field] += _remainder;
                break;
            }
        }
    }
}

/// @function regions_generate
/// @description (Re)builds the region list for a planet from its current planet-level scalars,
///              distributing population and forces across regions with the capital taking the
///              largest share. Overwrites p_regions[_planet].
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Array<Struct.Region>}
function regions_generate(_star, _planet) {
    var _count = region_count_for_planet(_star, _planet);
    var _owner = _star.p_owner[_planet];
    var _first = _star.p_first[_planet];
    // Random, non-repeating zone names for the outlying regions (one per non-capital region).
    var _zone_names = region_pick_zone_names(max(0, _count - 1));

    var _regions = [];
    for (var i = 0; i < _count; i++) {
        var _is_capital = (i == 0);
        var _region_name = _is_capital ? "Capital" : _zone_names[i - 1];
        var _region = new Region(_region_name, _is_capital, _owner);
        _region.first_owner = _first;
        array_push(_regions, _region);
    }

    // Capital counts double an outlying region, so it is always the largest single region.
    region_distribute_total(_regions, _star.p_population[_planet], 2, "population");
    region_distribute_total(_regions, _star.p_max_population[_planet], 2, "max_population");
    region_distribute_total(_regions, _star.p_pdf[_planet], 2, "pdf");
    region_distribute_total(_regions, _star.p_guardsmen[_planet], 2, "guardsmen");

    var _force_level = region_dominant_force_level(_star, _planet);
    var _fortified = _star.p_fortified[_planet];
    var _defences = _star.p_defenses[_planet];
    for (var i = 0, l = array_length(_regions); i < l; i++) {
        _regions[i].force_level = _force_level;
        _regions[i].fortification = _regions[i].is_capital ? _fortified : max(0, _fortified - 1);
        _regions[i].defences = _regions[i].is_capital ? _defences : 0;
    }

    // Existing planet buildings default to the capital.
    if (is_array(_star.p_upgrades[_planet]) && (array_length(_star.p_upgrades[_planet]) > 0)) {
        _regions[0].upgrades = variable_clone(_star.p_upgrades[_planet]);
    }

    _star.p_regions[_planet] = _regions;
    return _regions;
}

/// @function regions_ensure
/// @description Guarantees p_regions[_planet] exists, generating it from the planet scalars if
///              empty. Safe to call on saves that predate the regions system.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Array<Struct.Region>}
function regions_ensure(_star, _planet) {
    if (!variable_instance_exists(_star, "p_regions")) {
        // Old save loaded before this field existed. Match the planet array size (9).
        _star.p_regions = array_create_advanced(9, []);
    }
    var _existing = _star.p_regions[_planet];
    if (!is_array(_existing) || (array_length(_existing) == 0)) {
        return regions_generate(_star, _planet);
    }
    return _existing;
}

#endregion

#region rollup

/// @function regions_rollup
/// @description Writes the one thing the region overlay legitimately owns planet-ward: who holds
///              the planet (the capital's owner). Quantities (population, pdf, guardsmen,
///              defences, fortification, upgrades) are owned by the PLANET scalars, which many
///              vanilla systems write directly (defence purchases, Governor guard sales,
///              population events). Regions carry display copies, and per-region gains credit the
///              planet scalar at the moment they happen (see the building definitions). The old
///              rollup blanket-overwrote the live scalars from region copies that were seeded once
///              at generation, so building a turret snapped p_defenses back to stale values, and
///              barracks gains never surfaced: the turret/barracks stomp Sellka reported.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function regions_rollup(_star, _planet) {
    var _regions = regions_ensure(_star, _planet);
    if (array_length(_regions) <= 0) {
        return;
    }
    _star.p_owner[_planet] = _regions[0].owner;
}

#endregion

#region queries

/// @function planet_region_count
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function planet_region_count(_star, _planet) {
    return array_length(regions_ensure(_star, _planet));
}

/// @function region_get
/// @description Returns the Region record at an index (or the capital if out of range).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _index
/// @returns {Struct.Region}
function region_get(_star, _planet, _index) {
    var _regions = regions_ensure(_star, _planet);
    if ((_index < 0) || (_index >= array_length(_regions))) {
        return planet_capital_region(_star, _planet);
    }
    return _regions[_index];
}

/// @function planet_capital_region
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Struct.Region}
function planet_capital_region(_star, _planet) {
    var _regions = regions_ensure(_star, _planet);
    for (var i = 0, l = array_length(_regions); i < l; i++) {
        if (_regions[i].is_capital) {
            return _regions[i];
        }
    }
    return _regions[0];
}

/// @function planet_is_contested
/// @description True when the planet's regions are held by more than one faction.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Bool}
function planet_is_contested(_star, _planet) {
    var _regions = regions_ensure(_star, _planet);
    var _n = array_length(_regions);
    if (_n <= 1) {
        return false;
    }
    var _owner = _regions[0].owner;
    for (var i = 1; i < _n; i++) {
        if (_regions[i].owner != _owner) {
            return true;
        }
    }
    return false;
}

/// @function regions_owned_by
/// @description All region records on a planet held by a given faction.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Enum.eFACTION} _faction
/// @returns {Array<Struct.Region>}
function regions_owned_by(_star, _planet, _faction) {
    var _regions = regions_ensure(_star, _planet);
    var _result = [];
    for (var i = 0, l = array_length(_regions); i < l; i++) {
        if (_regions[i].owner == _faction) {
            array_push(_result, _regions[i]);
        }
    }
    return _result;
}

#endregion

#region mutation

/// @function region_set_owner
/// @description Changes a region's owner and rolls the change up to the planet scalars. This is
///              the entry point future invasion/battle code should use when a region changes hands.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _index
/// @param {Enum.eFACTION} _faction
/// @returns {Undefined}
function region_set_owner(_star, _planet, _index, _faction) {
    var _regions = regions_ensure(_star, _planet);
    if ((_index < 0) || (_index >= array_length(_regions))) {
        return;
    }
    _regions[_index].owner = _faction;
    regions_rollup(_star, _planet);
}

#endregion

#region debug

/// @function region_faction_name
/// @description Human-readable name for an eFACTION value (debug/UI readouts).
/// @param {Enum.eFACTION} _faction
/// @returns {String}
function region_faction_name(_faction) {
    static _names = [
        "None",
        "Player",
        "Imperium",
        "Mechanicus",
        "Inquisition",
        "Ecclesiarchy",
        "Eldar",
        "Ork",
        "Tau",
        "Tyranids",
        "Chaos",
        "Heretics",
        "Genestealer",
        "Necrons",
    ];
    if ((_faction >= 0) && (_faction < array_length(_names))) {
        return _names[_faction];
    }
    return string(_faction);
}

/// @function regions_debug_dump
/// @description Multi-line text summary of a planet's regions, for the debug console/log.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {String}
function regions_debug_dump(_star, _planet) {
    var _regions = regions_ensure(_star, _planet);
    var _count = array_length(_regions);
    var _contested = planet_is_contested(_star, _planet) ? " [CONTESTED]" : "";
    var _text = $"{_star.name} planet {_planet}: {_count} region(s){_contested}";
    for (var i = 0; i < _count; i++) {
        var _region = _regions[i];
        var _tag = _region.is_capital ? "*" : "-";
        _text += $"\n{_tag} {_region.name}: {region_faction_name(_region.owner)}, pop {_region.population}, pdf {_region.pdf}, guard {_region.guardsmen}, fort {_region.fortification}, def {_region.defences}";
    }
    return _text;
}

#endregion

#region conquest overlay (Option A)

// Option A model: planet-level scalars (p_owner + the per-faction force arrays) stay authoritative.
// Regions are a DERIVED overlay showing how far a conquest has progressed: as combat grinds an
// enemy's force level down, regions_sync flips outlying regions away from the enemy one at a time,
// with the capital held until the whole planet changes hands. Nothing here writes back to the
// authoritative scalars (that would clobber real combat losses); it only sets region.owner.

/// @function region_faction_is_hostile
/// @description Whether a faction is treated as a hostile occupier for conquest purposes.
///              Imperial-aligned factions (Player, Imperium, Mechanicus, Inquisition, Ecclesiarchy)
///              are not hostile.
/// @param {Enum.eFACTION} _faction
/// @returns {Bool}
function region_faction_is_hostile(_faction) {
    switch (_faction) {
        case eFACTION.PLAYER:
        case eFACTION.IMPERIUM:
        case eFACTION.MECHANICUS:
        case eFACTION.INQUISITION:
        case eFACTION.ECCLESIARCHY:
            return false;
    }
    return _faction > 0;
}

/// @function region_planet_enemy
/// @description Dominant hostile faction on a planet and its 0-6 force level.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Array} [faction, force]; faction is -1 when no hostile force is present.
function region_planet_enemy(_star, _planet) {
    var _factions = [
        eFACTION.ORK,
        eFACTION.TAU,
        eFACTION.TYRANIDS,
        eFACTION.CHAOS,
        eFACTION.HERETICS,
        eFACTION.NECRONS,
        eFACTION.ELDAR,
    ];
    var _forces = [
        _star.p_orks[_planet],
        _star.p_tau[_planet],
        _star.p_tyranids[_planet],
        _star.p_chaos[_planet],
        _star.p_traitors[_planet],
        _star.p_necrons[_planet],
        _star.p_eldar[_planet],
    ];
    var _best_faction = -1;
    var _best_force = 0;
    for (var i = 0, l = array_length(_factions); i < l; i++) {
        if (_forces[i] > _best_force) {
            _best_force = _forces[i];
            _best_faction = _factions[i];
        }
    }
    return [_best_faction, _best_force];
}

/// @function regions_sync
/// @description Recomputes region ownership from the authoritative planet state. The planet owner
///              (the defender) always holds the capital; a contesting force takes a share of the
///              outlying regions scaled by its strength. On an enemy-held world the contester is the
///              player (their grip grows as the enemy force is ground down); on a friendly world the
///              contester is a hostile force establishing a beachhead. Only region.owner is written,
///              so the authoritative scalars are never disturbed.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function regions_sync(_star, _planet) {
    var _regions = regions_ensure(_star, _planet);
    var _n = array_length(_regions);
    if (_n <= 0) {
        return;
    }

    var _owner = _star.p_owner[_planet];

    // EXTINCT-OWNER LIBERATION: a hostile faction that no longer exists on its own
    // world (force level 0 AND, where its population is modelled, headcount 0) does
    // not keep the deed. Without this, ownership set during an invasion (e.g. the
    // Tyranid ascension's set_new_owner) outlived the swarm's destruction, and the
    // regions panel painted every region under an owner with no forces (the
    // Demetrius report). The world reverts to the capital's recorded first owner.
    if (region_faction_is_hostile(_owner) && (obj_controller.turn > 1)) {
        // The turn gate matters: during worldgen the sync runs before hostile
        // starting forces are seeded, and the liberation stripped freshly created
        // enemy worlds at game start ("authority is restored" spam on turn 1,
        // including Vraks). From turn 2 on, an extinct owner is genuinely extinct.
        var _own_force = planet_faction_force_total(_star, _planet, _owner);
        var _own_pop = 0;
        if (variable_instance_exists(_star, "p_race_pop") && (count_to_level_anchors(_owner) != -1)) {
            _own_pop = _star.p_race_pop[_planet][_owner];
        }
        if ((_own_force <= 0) && (_own_pop <= 0)) {
            if ((_owner == eFACTION.HERETICS) || (_owner == eFACTION.CHAOS)) {
                heresy_cleansed_stamp(_star, _planet);
            }
            var _heir = eFACTION.IMPERIUM;
            if ((array_length(_regions) > 0) && variable_struct_exists(_regions[0], "first_owner")) {
                _heir = _regions[0].first_owner;
            }
            _star.p_owner[_planet] = _heir;
            _owner = _heir;
            scr_event_log("green", $"{region_faction_name(_heir)} authority is restored on {_star.name} {scr_roman(_planet)}: the occupiers are no more.", _star.name);
            beacon_teardown_if_cleansed(_star, _planet);
        }
    }

    var _enemy = region_planet_enemy(_star, _planet);
    var _enemy_faction = _enemy[0];
    var _enemy_force = _enemy[1];
    var _owner_hostile = region_faction_is_hostile(_owner);
    var _player_present = _star.p_player[_planet] > 0;

    // Identify the contesting force and how much of the world it currently grips (0-1).
    var _contester = -1;
    var _contest_ratio = 0;
    if (_owner_hostile) {
        // Enemy holds the world; the player contests it while they have forces on the ground, and
        // their grip grows as the enemy's force is worn down (force 6 -> none, force 0 -> all).
        if (_player_present) {
            _contester = eFACTION.PLAYER;
            _contest_ratio = 1 - clamp(_enemy_force / 6, 0, 1);
        }
    } else if ((_enemy_faction >= 0) && (_enemy_force > 0)) {
        // Friendly world contested by a hostile beachhead scaled to its strength.
        _contester = _enemy_faction;
        _contest_ratio = clamp(_enemy_force / 6, 0, 1);
    }

    // No active contest: the whole world is uniform under its owner.
    if (_contester < 0) {
        for (var i = 0; i < _n; i++) {
            _regions[i].owner = _owner;
        }
        return;
    }

    // Defender keeps the capital; the contester takes a scaled share of the outlying regions.
    // The COUNT that falls still derives from the force ratio (Option A, no scalar writeback), but
    // WHICH regions fall is steered: when the player is the contester their focused region falls
    // first (a concentrated assault), and the remaining regions fall weakest-fortification-first so
    // heavily defended regions hold out longer. See regions_contest_order.
    var _outlying = _n - 1;
    var _contest_regions = clamp(round(_contest_ratio * _outlying), 0, _outlying);

    var _focus = (_contester == eFACTION.PLAYER) ? region_focus_get(_star, _planet) : 0;
    var _order = regions_contest_order(_regions, _focus);

    var _falls = array_create(_n, false);
    for (var i = 0; (i < _contest_regions) && (i < array_length(_order)); i++) {
        _falls[_order[i]] = true;
    }

    for (var i = 0; i < _n; i++) {
        if (_regions[i].is_capital) {
            _regions[i].owner = _owner;
        } else {
            var _new_owner = _falls[i] ? _contester : _owner;
            // Consume-on-capture (kept entirely in the overlay so the combat core is untouched):
            // the turn an outlying region is taken by the player, its fortification and defences
            // are ground down. This region fortification is the overlay's own value and is never
            // rolled back into the authoritative p_fortified scalar, so real defence/combat values
            // are undisturbed (Option A).
            if ((_new_owner == eFACTION.PLAYER) && (_regions[i].owner != eFACTION.PLAYER)) {
                _regions[i].fortification = max(0, _regions[i].fortification - 1);
                if (_regions[i].defences > 0) {
                    _regions[i].defences = max(0, _regions[i].defences - 1);
                }
            }
            _regions[i].owner = _new_owner;
        }
    }
}

/// @function regions_contest_order
/// @description Priority order in which a planet's OUTLYING regions fall to a contester. A valid
///              focused region is taken first; the rest follow in ascending fortification order
///              (weakly defended regions fall before strongholds), ties broken by array index.
/// @param {Array<Struct.Region>} _regions
/// @param {Real} _focus Focused region index (0 = no focus / capital).
/// @returns {Array<Real>} Outlying region indices in the order they should fall.
function regions_contest_order(_regions, _focus) {
    var _n = array_length(_regions);
    var _order = [];

    // Focused outlying region first, when the focus points at a real non-capital region.
    var _has_focus = (_focus > 0) && (_focus < _n) && (!_regions[_focus].is_capital);
    if (_has_focus) {
        array_push(_order, _focus);
    }

    // Remaining outlying regions, collected then sorted weakest-fortification-first.
    var _rest = [];
    for (var i = 0; i < _n; i++) {
        if (_regions[i].is_capital) {
            continue;
        }
        if (_has_focus && (i == _focus)) {
            continue;
        }
        array_push(_rest, i);
    }
    // Insertion sort (region lists are tiny) by fortification ascending.
    for (var a = 1; a < array_length(_rest); a++) {
        var _key = _rest[a];
        var _kf = _regions[_key].fortification;
        var b = a - 1;
        while ((b >= 0) && (_regions[_rest[b]].fortification > _kf)) {
            _rest[b + 1] = _rest[b];
            b -= 1;
        }
        _rest[b + 1] = _key;
    }
    for (var i = 0; i < array_length(_rest); i++) {
        array_push(_order, _rest[i]);
    }
    return _order;
}

#endregion

#region conquest focus (player region selection)

// The player can pick which region of a world to prioritise assaulting. The choice is stored per
// planet in obj_star.p_region_focus[planet] (a p_* array so it saves automatically). It steers the
// conquest overlay (regions_contest_order) and picks the region an assault lands on
// (region_assault_target). 0 means "no explicit focus" and behaves as before.

/// @function region_focus_ensure
/// @description Guarantees the per-planet focus store exists and holds a valid index for this
///              planet. Safe on saves that predate the focus field.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real} the (validated) focus index for this planet.
function region_focus_ensure(_star, _planet) {
    if (!variable_instance_exists(_star, "p_region_focus")) {
        _star.p_region_focus = array_create_advanced(9, 0);
    }
    var _count = planet_region_count(_star, _planet);
    var _f = _star.p_region_focus[_planet];
    if (!is_real(_f) || (_f < 0) || (_f >= _count)) {
        _star.p_region_focus[_planet] = 0;
        _f = 0;
    }
    return _f;
}

/// @function region_focus_get
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function region_focus_get(_star, _planet) {
    return region_focus_ensure(_star, _planet);
}

/// @function region_focus_set
/// @description Sets the player's conquest-priority region for a planet (clamped to a valid region).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _index
/// @returns {Undefined}
function region_focus_set(_star, _planet, _index) {
    region_focus_ensure(_star, _planet);
    var _count = planet_region_count(_star, _planet);
    _star.p_region_focus[_planet] = clamp(_index, 0, max(0, _count - 1));
}

/// @function region_assault_target
/// @description Which region an attacker's ground assault should land on. Prefers the attacker's
///              focused region when it is still held by someone else; otherwise the capital (the
///              seat and heaviest defences); otherwise the most fortified remaining hostile
///              outlying region. Returns -1 when nothing on the planet is hostile to the attacker.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Enum.eFACTION} _attacker
/// @returns {Real} region index, or -1.
function region_assault_target(_star, _planet, _attacker) {
    var _regions = regions_ensure(_star, _planet);
    var _n = array_length(_regions);
    if (_n <= 0) {
        return -1;
    }

    var _focus = region_focus_get(_star, _planet);
    if ((_focus > 0) && (_focus < _n) && (_regions[_focus].owner != _attacker)) {
        return _focus;
    }

    // Default target is the capital while it is still hostile.
    if (_regions[0].owner != _attacker) {
        return 0;
    }

    // Capital already taken: hit the most fortified hostile outlying holdout.
    var _best = -1;
    var _best_fort = -1;
    for (var i = 1; i < _n; i++) {
        if ((_regions[i].owner != _attacker) && (_regions[i].fortification > _best_fort)) {
            _best_fort = _regions[i].fortification;
            _best = i;
        }
    }
    return _best;
}

#endregion

#region UI panel

/// @function draw_regions_panel
/// @description Draws the per-region readout for a planet on the system view: each region's owner
///              (colour-coded), fortification, defences and garrison, with a CONTESTED badge and a
///              click-to-focus row so the player can pick which region to prioritise assaulting.
///              Call from a Draw GUI event. Capital rows are not selectable (it is always the seat).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _px Left edge (GUI x).
/// @param {Real} _py Top edge (GUI y).
/// @returns {Undefined}
function draw_regions_panel(_star, _planet, _px, _py) {
    var _regions = regions_ensure(_star, _planet);
    var _n = array_length(_regions);
    if (_n <= 0) {
        return;
    }

    var _w = 300;
    var _head_h = 30;
    var _row_h = 46;
    var _h = _head_h + (_n * _row_h) + 12;

    var _focus = region_focus_get(_star, _planet);
    var _forti_names = ["None", "Sparse", "Light", "Moderate", "Heavy", "Major", "Extreme"];

    // Panel background + border.
    draw_set_alpha(0.85);
    draw_set_color(c_black);
    draw_rectangle(_px, _py, _px + _w, _py + _h, false);
    draw_set_alpha(1);
    draw_set_color(c_dkgray);
    draw_rectangle(_px, _py, _px + _w, _py + _h, true);

    // Header.
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    var _title = "Planetary Regions";
    draw_text(_px + 10, _py + 6, _title);
    if (planet_is_contested(_star, _planet)) {
        draw_set_color(c_orange);
        draw_set_halign(fa_right);
        draw_text(_px + _w - 10, _py + 8, "CONTESTED");
        draw_set_halign(fa_left);
    }
    draw_set_color(c_dkgray);
    draw_line(_px + 6, _py + _head_h, _px + _w - 6, _py + _head_h);

    draw_set_font(fnt_40k_14);

    for (var i = 0; i < _n; i++) {
        var _region = _regions[i];
        var _rx = _px + 8;
        var _ry = _py + _head_h + 4 + (i * _row_h);
        var _row_x2 = _px + _w - 8;
        var _row_y2 = _ry + _row_h - 4;

        // Every region (capital included) is selectable, so you can focus it for construction.
        // The conquest overlay still ignores a capital focus (it only steers outlying regions).
        var _selectable = true;
        var _is_focus = (i == _focus);

        // Focus + hover highlights.
        if (_is_focus) {
            draw_set_alpha(0.25);
            draw_set_color(c_yellow);
            draw_rectangle(_rx - 2, _ry - 2, _row_x2, _row_y2, false);
            draw_set_alpha(1);
        }
        var _hover = _selectable && scr_hit(_rx - 2, _ry - 2, _row_x2, _row_y2);
        if (_hover) {
            draw_set_alpha(0.15);
            draw_set_color(c_white);
            draw_rectangle(_rx - 2, _ry - 2, _row_x2, _row_y2, false);
            draw_set_alpha(1);
        }

        // Owner colour swatch.
        var _col = c_gray;
        if ((_region.owner >= 0) && (_region.owner < array_length(global.star_name_colors))) {
            _col = global.star_name_colors[_region.owner];
        }
        draw_set_color(_col);
        draw_rectangle(_rx, _ry + 2, _rx + 10, _ry + 14, false);
        draw_set_color(c_dkgray);
        draw_rectangle(_rx, _ry + 2, _rx + 10, _ry + 14, true);

        // Region name (capital marked) + owner.
        draw_set_color(c_white);
        var _name = _region.is_capital ? ("* " + _region.name) : _region.name;
        draw_text(_rx + 18, _ry, _name);
        draw_set_color(_col);
        draw_text(_rx + 18, _ry + 16, region_faction_name(_region.owner));

        // Fortification on the right; below it a clickable forces label opens the section's force
        // breakdown (draw_force_panel) — this replaces the old raw garrison number.
        draw_set_halign(fa_right);
        draw_set_color(c_ltgray);
        draw_text(_row_x2 - 2, _ry, "Fort: " + _forti_names[clamp(_region.fortification, 0, 6)]);

        var _f_imperial = (_region.owner == eFACTION.PLAYER) || (_region.owner == eFACTION.IMPERIUM) || (_region.owner == eFACTION.MECHANICUS) || (_region.owner == eFACTION.INQUISITION) || (_region.owner == eFACTION.ECCLESIARCHY);
        var _gar_str = _f_imperial ? "Imperium Forces" : region_faction_name(_region.owner) + " Forces";
        var _gar_x1 = _row_x2 - 2 - string_width(_gar_str);
        var _gar_y1 = _ry + 16;
        var _gar_x2 = _row_x2 - 2;
        var _gar_y2 = _ry + 30;
        draw_set_color(scr_hit(_gar_x1, _gar_y1, _gar_x2, _gar_y2) ? c_yellow : c_ltgray);
        draw_text(_row_x2 - 2, _gar_y1, _gar_str);
        draw_set_halign(fa_left);

        // Clicking the garrison figure opens its breakdown (and focuses the region); clicking
        // elsewhere on the row just focuses it. The garrison check runs first — point_and_click sets a
        // click cooldown on success, so the row check is naturally suppressed the same frame.
        if (_selectable && point_and_click([_gar_x1, _gar_y1, _gar_x2, _gar_y2])) {
            region_focus_set(_star, _planet, i);
            obj_star_select.region_force_open = true;
            obj_star_select.region_force_view = i;
            obj_star_select.region_force_faction = -1;
        } else if (_selectable && point_and_click([_rx - 2, _ry - 2, _row_x2, _row_y2])) {
            region_focus_set(_star, _planet, i);
        }
    }

    // Restore default draw state (font included, so later draws are not left on fnt_40k_14).
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_set_alpha(1);
}

/// @function faction_is_total_war
/// @description Total-war races have NO civilian population — their population IS their fighting force
///              (Orks, Necrons, Tyranids). Civ races (Tau, Eldar, Chaos, Heretics, Sisters, Imperium)
///              carry a large civilian pool and levy a smaller force from it. See §3 of the plan.
/// @param {Real} _faction  eFACTION value
/// @returns {Bool}
function faction_is_total_war(_faction) {
    return (_faction == eFACTION.ORK) || (_faction == eFACTION.NECRONS) || (_faction == eFACTION.TYRANIDS);
}

/// @function faction_levy_rate
/// @description The fraction of a CIV race's civilian population it fields as a standing force (§16b).
///              Total-war races return 1 (their whole population is the force). Civ races levy a small
///              slice: Tau muster Fire caste + auxiliaries, Eldar call up Guardians + Aspects (a dying
///              race mobilises a larger share). Tunable.
/// @param {Real} _faction
/// @returns {Real} 0-1
function faction_levy_rate(_faction) {
    switch (_faction) {
        case eFACTION.TAU:   return 0.010;   // Fire caste + auxiliaries
        case eFACTION.ELDAR: return 0.020;   // Guardians + Aspect shrines (dying race, larger call-up)
        default:             return 1.0;
    }
}

/// @function planet_race_pop
/// @description Safe read of a planet's per-race population headcount (additive populations layer).
///              Guards old saves that predate p_race_pop (returns 0). Seeded at worldgen for Tau/Ork.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _faction  eFACTION value
/// @returns {Real} headcount (0 if unset)
function planet_race_pop(_star, _planet, _faction) {
    if (!variable_instance_exists(_star, "p_race_pop")) {
        return 0;
    }
    var _rows = _star.p_race_pop;
    if ((_planet < 0) || (_planet >= array_length(_rows))) {
        return 0;
    }
    var _row = _rows[_planet];
    if (!is_array(_row) || (_faction < 0) || (_faction >= array_length(_row))) {
        return 0;
    }
    return _row[_faction];
}

/// @function faction_force_total
/// @description Total field strength a faction musters at a 0-6 level (sum of its ladder roster).
/// @param {Real} _faction  eFACTION value
/// @param {Real} _level    0-6
/// @returns {Real}
function faction_force_total(_faction, _level, _infra_turns = 32) {
    var _comp = faction_ladder_composition(_faction, _level, _infra_turns);
    var _total = 0;
    for (var _i = 0; _i < array_length(_comp); _i++) {
        _total += _comp[_i].count;
    }
    return _total;
}

/// @function faction_planet_level
/// @description The 0-6 strength level a faction currently has on a planet, from the legacy p_<race>
///              scalar it maps to. Drives the ladder-composition display for non-Imperial owners.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _faction  eFACTION value
/// @returns {Real} 0-6 (0 if unmapped / no presence)
function faction_planet_level(_star, _planet, _faction) {
    switch (_faction) {
        case eFACTION.ORK:          return _star.p_orks[_planet];
        case eFACTION.TAU:          return _star.p_tau[_planet];
        case eFACTION.TYRANIDS:     return _star.p_tyranids[_planet];
        case eFACTION.CHAOS:        return _star.p_chaos[_planet];
        case eFACTION.HERETICS:     return _star.p_traitors[_planet];
        case eFACTION.GENESTEALER:  return _star.p_demons[_planet];
        case eFACTION.NECRONS:      return _star.p_necrons[_planet];
        case eFACTION.ELDAR:        return _star.p_eldar[_planet];
        case eFACTION.ECCLESIARCHY: return _star.p_sisters[_planet];
        default:                    return 0;
    }
}

/// @function level_to_count
/// @description The representative headcount a faction's 0-6 strength level maps to (§11a anchors).
///              Orks are locked (pilot); other factions return 0 for now and keep the ladder table.
/// @param {Real} _faction  eFACTION value
/// @param {Real} _level    0-6
/// @returns {Real}
function level_to_count(_faction, _level) {
    var _lv = clamp(floor(_level), 0, 6);
    switch (_faction) {
        case eFACTION.ORK:
            var _ork = [0, 100, 350, 1000, 3600, 7000, 11000];
            return _ork[_lv];
        case eFACTION.NECRONS:
            var _nec = [0, 5000, 20000, 60000, 150000, 400000, 800000];
            return _nec[_lv];
        case eFACTION.HERETICS:
            var _her = [0, 10000, 50000, 200000, 1000000, 5000000, 20000000];
            return _her[_lv];
        case eFACTION.TYRANIDS:
            var _nid = [0, 50000, 200000, 1000000, 5000000, 20000000, 80000000];
            return _nid[_lv];
        default:
            return 0;
    }
}

/// @function count_to_level
/// @description Inverse of level_to_count: the 0-6 strength level a real headcount maps to (the highest
///              anchor it meets or exceeds). Used to keep the legacy p_<race> 0-6 scalar in sync while
///              the real POPULATION headcount is the source of truth (§16b). Orks only (pilot).
/// @param {Real} _faction
/// @param {Real} _count
/// @returns {Real} 0-6
function count_to_level(_faction, _count) {
    var _anchors = -1;
    switch (_faction) {
        case eFACTION.ORK:      _anchors = [0, 100, 350, 1000, 3600, 7000, 11000]; break;
        case eFACTION.NECRONS:  _anchors = [0, 5000, 20000, 60000, 150000, 400000, 800000]; break;
        case eFACTION.HERETICS: _anchors = [0, 10000, 50000, 200000, 1000000, 5000000, 20000000]; break;
        case eFACTION.TYRANIDS: _anchors = [0, 50000, 200000, 1000000, 5000000, 20000000, 80000000]; break;
        default: return 0;
    }
    var _lv = 0;
    for (var i = 6; i >= 1; i--) {
        if (_count >= _anchors[i]) { _lv = i; break; }
    }
    return _lv;
}

/// @function planet_faction_pop
/// @description The AUTHORITATIVE headcount a faction fields on a world — its real population
///              (p_race_pop) where seeded, else a migration fallback derived from the legacy 0-6 level.
///              This is the number force generation should read, NOT the 0-6 level (§16). For Orks this
///              is the Fungal-Bloom population; for civ races their p_race_pop; total-war grows in place.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _faction
/// @returns {Real}
function planet_faction_pop(_star, _planet, _faction) {
    var _pop = planet_race_pop(_star, _planet, _faction);
    if (_pop > 0) { return _pop; }
    return level_to_count(_faction, faction_planet_level(_star, _planet, _faction));
}

/// @function planet_faction_composition
/// @description A faction's roster on a world driven by its POPULATION + infrastructure (§14/§16b) —
///              not a 0-6 level. Orks (pilot) recruit their mob straight from the Fungal-Bloom headcount;
///              other factions still use the level ladder until they migrate to populations too.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _faction
/// @returns {Array<Struct>} [{label, count}, ...]
function planet_faction_composition(_star, _planet, _faction) {
    var _infra = planet_infra_turns(_star, _planet);
    // A SECRET heretic cult fields no visible/fighting force until it rises in open revolt (§16k) — so it
    // never shows a force count and the free-for-all resolver ignores it while it's still underground.
    if (_faction == eFACTION.HERETICS && heretic_is_hidden(_star, _planet)) { return []; }
    // Likewise a still-HIDDEN Genestealer Cult (§16p) fields no visible force while it infiltrates in secret.
    if (_faction == eFACTION.TYRANIDS && genestealer_is_hidden(_star, _planet)) { return []; }
    // Genestealer Cult vs Hive swarm share the TYRANIDS faction but field DIFFERENT rosters (§16p/§16r):
    // while a cult is still infiltrating (has GENE_STEALER_CULT, no beacon) its host scales the CULT shape
    // (the human/hybrid roster — Neophytes/Acolytes/Metamorphs/Jackals + cult leaders, with NO Purestrain
    // "Star Children" and NO Tyranid bioforms); once ascended it scales the full Hive-swarm shape (L6). Both
    // scale to the real p_race_pop headcount, so a mature cult is a proper army, not a fixed ~1000.
    if (_faction == eFACTION.TYRANIDS) {
        var _pdg = _star.get_planet_data(_planet);
        var _cult_phase = _pdg.has_feature(eP_FEATURES.GENE_STEALER_CULT) && !_pdg.has_feature(eP_FEATURES.ASCENSION_BEACON);
        var _tp = planet_race_pop(_star, _planet, eFACTION.TYRANIDS);
        if (_cult_phase) {
            // ALWAYS route a pre-Ascension cult through the filtered cult roster — even at host 0 it returns
            // [], so a just-seeded or freshly-revealed cult can NEVER leak Purestrains/bioforms through the
            // raw ladder at the bottom of this function.
            return genestealer_cult_composition(round(max(_tp, 0) * faction_levy_rate(eFACTION.TYRANIDS)), _infra);
        }
        if (_tp > 0) {
            // Ascended: the swarm host scales the full Hive-fleet shape (L6).
            return faction_pop_composition(eFACTION.TYRANIDS, round(_tp * faction_levy_rate(eFACTION.TYRANIDS)), _infra, 6);
        }
    }
    if (_faction == eFACTION.ORK) {
        var _r = ork_composition(planet_faction_pop(_star, _planet, eFACTION.ORK), _infra, ork_leading_clan(_star, _planet));
        // Looted vehicles — enemy tanks the Orks have captured and daubed red. Only ever present if the
        // Orks have fought a vehicle-equipped foe here (accumulated by the resolver). Mek-built wagons/
        // walkers above are separate; these are stolen "tanks".
        var _loot = planet_ork_loot(_star, _planet);
        if (_loot > 0) { array_push(_r, { label: "Looted Wagon", count: _loot }); }
        return _r;
    }
    // Population-driven force generation for migrated factions (§16b): a total-war race fields its WHOLE
    // population (Necrons — levy rate 1); a civ race fields a LEVY fraction of its civilian pool (Tau,
    // Eldar); Heretics are the corrupted human masses (their whole "population" is the uprising, levy 1).
    // All scale through the shared engine. Un-migrated factions still use the 0-6 level table.
    // Tyranids only become population-driven AFTER the Ascension Beacon lights (a swarm p_race_pop is
    // seeded then); before that, p_race_pop is 0 and they fall through to the level table = the GSC phase.
    if (_faction == eFACTION.NECRONS || _faction == eFACTION.TAU || _faction == eFACTION.ELDAR || _faction == eFACTION.HERETICS || _faction == eFACTION.TYRANIDS) {
        var _pop2 = planet_race_pop(_star, _planet, _faction);
        if (_pop2 > 0) {
            return faction_pop_composition(_faction, round(_pop2 * faction_levy_rate(_faction)), _infra);
        }
    }
    var _comp = faction_ladder_composition(_faction, faction_planet_level(_star, _planet, _faction), _infra);
    // Chaos Space Marines + Daemons render by the world's patron GOD (§16r): Khorne fields Berzerkers +
    // Bloodletters, Tzeentch Rubrics + Pink Horrors, etc. Undivided keeps the generic legion + mixed host.
    if ((_faction == eFACTION.CHAOS) || (_faction == eFACTION.GENESTEALER)) {
        _comp = chaos_god_flavor(_comp, planet_chaos_god(_star, _planet));
    }
    return _comp;
}

/// @function heretic_is_hidden
/// @description True while a world's heretics are a SECRET cult (§16k): it carries a HERETIC_ACTIVITY feature
///              that hasn't risen (revolted == false) and the world isn't already openly Chaos/heretic-held.
///              While hidden the heretics field NO force and take NO part in battles — only the "Heretic
///              Activity" warning tag shows. They surface only on open revolt, or are purged.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Bool}
function heretic_is_hidden(_star, _planet) {
    var _pd = _star.get_planet_data(_planet);
    if (!_pd.has_feature(eP_FEATURES.HERETIC_ACTIVITY)) { return false; }
    var _own = _star.p_owner[_planet];
    if ((_own == eFACTION.HERETICS) || (_own == eFACTION.CHAOS)) { return false; }
    if (_pd.has_feature(eP_FEATURES.DAEMONIC_INCURSION)) { return false; }
    var _f = _pd.get_features(eP_FEATURES.HERETIC_ACTIVITY)[0];
    return !(variable_struct_exists(_f, "revolted") && _f.revolted);
}

/// @function genestealer_is_hidden
/// @description True while a world's Genestealer Cult is still INFILTRATING in secret (§16p): it carries the
///              cult feature with `hiding == true`, hasn't ascended (no beacon), and hasn't taken the world
///              (owner not Tyranids). While hidden it fields no visible force count and the resolver ignores
///              it — its growing host stays concealed until it reveals, ascends, or is purged.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Bool}
function genestealer_is_hidden(_star, _planet) {
    var _pd = _star.get_planet_data(_planet);
    if (!_pd.has_feature(eP_FEATURES.GENE_STEALER_CULT)) { return false; }
    if (_pd.has_feature(eP_FEATURES.ASCENSION_BEACON)) { return false; }   // ascended -> open swarm
    if (_star.p_owner[_planet] == eFACTION.TYRANIDS) { return false; }      // revealed / already took the world
    var _c = _pd.get_features(eP_FEATURES.GENE_STEALER_CULT)[0];
    return (variable_struct_exists(_c, "hiding") && _c.hiding);
}

/// @function heretic_brood_seed
/// @description Starting size of a hidden heretic cult — a scaled minority of the world's populace that has
///              turned (§16k/§16l), so a fresh uprising is a credible threat, not a rounding error.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function heretic_brood_seed(_star, _planet) {
    var _pd = _star.get_planet_data(_planet);
    var _people = _pd.large_population ? (_pd.population * 1000000000) : _pd.population;
    if (_people <= 0) { _people = 10000; }
    return max(2000, round(_people * random_range(0.004, 0.012)));   // ~0.4%–1.2% are secret cultists
}

/// @function heretic_purge
/// @description Root out and exterminate a world's heretic cult (§16k): clears the hidden tag and zeroes the
///              heretic headcount + level. Used when a garrison uncovers a cult too weak to fight back.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function heretic_purge(_star, _planet) {
    var _pd = _star.get_planet_data(_planet);
    if (_pd.has_feature(eP_FEATURES.HERETIC_ACTIVITY)) { _pd.delete_feature(eP_FEATURES.HERETIC_ACTIVITY); }
    if (variable_instance_exists(_star, "p_race_pop")) { _star.p_race_pop[_planet][eFACTION.HERETICS] = 0; }
    _star.p_traitors[_planet] = 0;
    scr_event_log("green", $"A nascent heretic cult on {_pd.name()} was uncovered and purged.", _star.name);
}

/// @function heretic_concealment_tick
/// @description Per-turn lifecycle of a world's SECRET heretic cult (§16k). While heretics fester under a
///              loyal world it ensures a hidden HERETIC_ACTIVITY tag + a seeded brood exist, then each turn
///              either (a) rises in OPEN REVOLT when the cult outnumbers the garrison (strong enough to win),
///              or (b) is PURGED when a garrison uncovers a cult too weak to fight back. Openly Chaos/heretic
///              worlds (or an active daemonic incursion) clear the tag — they're no longer a secret.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function heretic_concealment_tick(_star, _planet) {
    if (!variable_instance_exists(_star, "p_race_pop")) { return; }
    var _pd = _star.get_planet_data(_planet);

    // A deeply corrupted world EXPORTS the taint on its own — it periodically slips out a "trade ship" (a
    // colony fleet in all but name) that carries the corruption to another world. This spreads cults even
    // when the colonisation AI never sends a fleet (§16k), driven purely by the corruption level.
    // Throttled (was 10%/turn at corruption 60+, which read as an endless colonist
    // spam carrying heresy everywhere): higher corruption floor, lower chance, and a
    // sector-wide in-flight cap enforced inside the spawner.
    if (_pd.corruption >= TAINT_EXPORT_MIN_CORRUPTION && irandom(99) < TAINT_EXPORT_CHANCE_PCT) { spawn_taint_trade_ship(_star, _planet); }

    var _own = _star.p_owner[_planet];
    var _open = (_own == eFACTION.HERETICS) || (_own == eFACTION.CHAOS) || _pd.has_feature(eP_FEATURES.DAEMONIC_INCURSION);
    var _pop = _star.p_race_pop[_planet][eFACTION.HERETICS];

    // Openly Chaos/heretic (or a daemonic incursion): not a hidden cult — clear any stale tag and leave the
    // world's OPEN forces alone (they're the garrison, not a concealed cell).
    if (_open) {
        if (_pd.has_feature(eP_FEATURES.HERETIC_ACTIVITY)) { _pd.delete_feature(eP_FEATURES.HERETIC_ACTIVITY); }
        return;
    }

    // AUTOMATIC REMOVAL (§16k, feedback rev): a hidden cult is sustained only while the world stays corrupt.
    // The purges already grind corruption down and, below the host floor (25), the heretic host disperses on
    // its own (host -> 0 in end_turn_race_population_growth). So once corruption has been scrubbed out AND no
    // heretics are left, the concealed cell has nothing to hide behind — the Heretic Activity tag drops off
    // automatically. Zero any stale traitor force too, so the world reads clean (the host block leaves it set).
    if ((_pd.corruption < 25) && (_pop <= 0)) {
        if (_star.p_traitors[_planet] > 0) { _star.p_traitors[_planet] = 0; }
        if (_pd.has_feature(eP_FEATURES.HERETIC_ACTIVITY)) {
            _pd.delete_feature(eP_FEATURES.HERETIC_ACTIVITY);
            scr_event_log("green", $"The corruption on {_pd.name()} has been scoured out and the last of its heretics purged; the world is clean once more.", _star.name);
        }
        return;
    }

    // FORM a hidden cult only where the world is MEANINGFULLY corrupted (>= 25, matching the heretic-host
    // floor in end_turn_race_population_growth) or already has a seeded brood. Worldgen sprinkles 1–10
    // background corruption on every planet; without this floor a cult (and a purge) formed on every world
    // — that was the turn-2 log flood.
    if (!_pd.has_feature(eP_FEATURES.HERETIC_ACTIVITY)) {
        if ((_pd.corruption < 25) && (_pop <= 0)) { return; }
        // Cleanse cooldown: a world that just put down its heretics cannot sprout a
        // new cult for HERETIC_RESEED_COOLDOWN turns, however corrupt it remains.
        if (variable_instance_exists(_star, "p_heresy_cleansed_turn")
        && ((obj_controller.turn - _star.p_heresy_cleansed_turn[_planet]) < HERETIC_RESEED_COOLDOWN)) {
            return;
        }
        _pd.add_feature(eP_FEATURES.HERETIC_ACTIVITY);
    }
    // Seed a credible scaled brood once (§16l).
    if (_pop <= 0) {
        _pop = heretic_brood_seed(_star, _planet);
        _star.p_race_pop[_planet][eFACTION.HERETICS] = _pop;
        _star.p_traitors[_planet] = count_to_level(eFACTION.HERETICS, _pop);
    }

    // Age the cult — a garrison needs TIME to root out an infiltrator. A cult can never be uncovered the
    // same turns it forms (no create-and-purge-in-one-turn spam).
    var _feat = _pd.get_features(eP_FEATURES.HERETIC_ACTIVITY)[0];
    _feat.cult_age = (variable_struct_exists(_feat, "cult_age") ? _feat.cult_age : 0) + 1;

    // Strength check — the cult (headcount) vs the world's Imperial garrison (resolver alliance strength).
    var _gar = br_side_strength(_star, _planet, "IMP");

    if (_pop > _gar * 1.1) {
        // STRONG ENOUGH TO WIN — rise in open revolt (§16k). ~14%/turn once they hold the advantage, so it
        // isn't instantaneous. Now visible and fighting through the resolver.
        if (irandom(6) < 1) {
            _feat.revolted = true;
            _pd.delete_feature(eP_FEATURES.HERETIC_ACTIVITY);   // no longer secret
            _pd.set_new_owner(eFACTION.HERETICS);
            scr_popup("Heretic Uprising", $"The secret cult on {_pd.name()} judges the moment ripe and rises in open revolt!", "chaos_cultist", "");
            scr_event_log("red", $"A hidden heretic cult on {_pd.name()} has risen in open revolt.", _star.name);
        }
    } else if ((_gar > 0) && (_feat.cult_age >= 5)) {
        // DISCOVERED WHILE WEAK — a SLOW, quiet hunt (§16k). Low per-turn chance, a little higher the more
        // the garrison outnumbers the cult, but hard-capped so it's never an instant sweep — a cult under a
        // garrison typically lasts a dozen-plus turns, giving it a real chance to grow toward a revolt.
        var _ratio = _gar / max(1, _pop);
        var _chance = clamp(2 + _ratio, 2, 8);      // 2%–8% per turn, only after ~5 turns of festering
        if (irandom(99) < _chance) { heretic_purge(_star, _planet); }
    }
}

/// @function spawn_taint_trade_ship
/// @description A corrupted world exports its taint via a "TRADE SHIP" — mechanically a colony fleet (reuses
///              the `colonize` cargo + deploy_colonisers), just renamed and NOT drawn from the colonisation
///              AI, so cults spread on their own (§16k). It carries the origin's corruption (and cult flag +
///              influence) but only a token of infected traders, not a colony wave, and heads for the nearest
///              other populated world that isn't already heavily tainted. On arrival deploy_colonisers plants
///              the corruption there; once that world climbs past the corruption floor it grows its own cult.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Bool}
function spawn_taint_trade_ship(_star, _planet) {
    // Sector-wide cap: at most TAINT_EXPORT_MAX_IN_FLIGHT taint ships travelling at
    // once, so the spread reads as insidious trade, not a colonist flood.
    var _in_flight = 0;
    with (obj_en_fleet) {
        if ((trade_goods == "colonize") && is_struct(cargo_data) && variable_struct_exists(cargo_data, "colonize")
            && is_struct(cargo_data.colonize) && variable_struct_exists(cargo_data.colonize, "mission")
            && (cargo_data.colonize.mission == "trade")) {
            _in_flight += 1;
        }
    }
    if (_in_flight >= TAINT_EXPORT_MAX_IN_FLIGHT) { return false; }

    // Pick the nearest OTHER system with a populated, not-yet-heavily-tainted world to infect.
    var _dest = noone, _dp = 0, _bestd = 1000000000;
    var _fx = _star.x, _fy = _star.y;
    with (obj_star) {
        if (id == _star) { continue; }
        for (var i = 1; i <= planets; i++) {
            if ((p_type[i] == "Dead") || (p_type[i] == "")) { continue; }
            if (p_population[i] <= 0) { continue; }
            var _corr = variable_instance_exists(id, "p_heresy") ? p_heresy[i] : 0;
            if (_corr >= 60) { continue; }                 // already rotten — nothing to spread here
            var _d = point_distance(_fx, _fy, x, y);
            if (_d < _bestd) { _bestd = _d; _dest = id; _dp = i; }
            break;                                          // one candidate planet per system is enough
        }
    }
    if (!instance_exists(_dest)) { return false; }

    var _corr0 = variable_instance_exists(_star, "p_heresy") ? _star.p_heresy[_planet] : 0;
    var _cult = false;
    try {
        var _pd = _star.get_planet_data(_planet);
        _cult = _pd.has_feature(eP_FEATURES.HERETIC_ACTIVITY) || _pd.has_feature(eP_FEATURES.GENE_STEALER_CULT);
    } catch (_e) { _cult = false; }

    // Upstream (eaf1ee3cc): fleets are created and registered through the central
    // helper; a raw instance_create left this ship untracked (phantom-fleet class).
    var _f = create_enemy_fleet(_star.x, _star.y, eFACTION.IMPERIUM);
    _f.sprite_index = spr_fleet_civilian;
    _f.image_index = choose(1, 2);
    _f.warp_able = false;
    _f.trade_goods = "colonize";
    _f.cargo_data.colonize = {
        colonists: irandom_range(500, 3000),               // a few infected traders/pilgrims, not a colony
        mission: "trade",
        target_planet: _dp,
        colonist_influence: _star.p_influence[_planet],     // also carries genestealer influence, if any
        corruption: _corr0,
        cult: _cult,
        chaos_god: planet_chaos_god(_star, _planet),        // carries the home world's god (§16r) — spread follows the trade routes
    };
    _f.action_x = _dest.x;
    _f.action_y = _dest.y;
    _f.target = _dest;
    with (_f) { set_fleet_movement(); }
    scr_event_log("purple", $"A trade ship slips out of {_star.name} carrying more than its manifest declares.", _star.name);
    return true;
}

/// @function genestealer_cult_composition
/// @description Pre-Ascension Genestealer Cult roster (§16p): the cult's HUMAN + HYBRID host scaled to its
///              headcount — Neophytes, Acolytes, Metamorphs, cult vehicles and leaders. Purestrain
///              Genestealers (the "Star Children") and the Tyranid bioform swarm are OMITTED; they only appear
///              once the beacon lights and the Hive Fleet lands (the L6 swarm shape). Scales the L3 cult shape
///              minus purestrains, so dropping them just fills the host with more cultists (host preserved).
/// @param {Real} _host   real cult headcount
/// @param {Real} _infra  planet_infra_turns
/// @returns {Array<Struct>}
function genestealer_cult_composition(_host, _infra) {
    if (_host <= 0) { return []; }
    var _shape = faction_ladder_composition(eFACTION.TYRANIDS, 3, _infra);
    var _total = 0;
    for (var i = 0; i < array_length(_shape); i++) {
        if (_shape[i].label == "Purestrain Genestealer") { continue; }
        _total += _shape[i].count;
    }
    if (_total <= 0) { return []; }
    var _scale = _host / _total;
    var _out = [];
    for (var i = 0; i < array_length(_shape); i++) {
        if (_shape[i].label == "Purestrain Genestealer") { continue; }   // Star Children only at Ascension
        var _c = round(_shape[i].count * _scale);
        if (_c > 0) { array_push(_out, { label: _shape[i].label, count: _c }); }
    }
    return _out;
}

// ============================================================================================
//  CHAOS SECTS & THE GREAT GAME (§16r). Chaos is organised into sects devoted to the four gods
//  (Khorne, Tzeentch, Nurgle, Slaanesh) plus Chaos Undivided. UNLIKE the Orks they start ALLIED
//  against the Imperium; only once Chaos grows dominant (~50 % of the sector) do the four GOD
//  sects "regress to the Great Game" and turn on one another (visible rival incursions), while
//  UNDIVIDED keeps up the assault on the Imperium. A self-limiting balancer so Chaos can't just
//  steamroll the map — leaving the Orks/Imperium room to counter.
// ============================================================================================

/// @function chaos_god_count
/// @returns {Real} number of sect gods (0 Khorne, 1 Tzeentch, 2 Nurgle, 3 Slaanesh, 4 Undivided)
function chaos_god_count() { return 5; }

/// @function chaos_god_name
function chaos_god_name(_g) {
    switch (_g) {
        case 0: return "Khorne";
        case 1: return "Tzeentch";
        case 2: return "Nurgle";
        case 3: return "Slaanesh";
        case 4: return "Chaos Undivided";
        default: return "Chaos";
    }
}

/// @function chaos_god_colour
function chaos_god_colour(_g) {
    switch (_g) {
        case 0: return make_colour_rgb(200, 30, 30);    // Khorne — blood red
        case 1: return make_colour_rgb(60, 120, 255);   // Tzeentch — blue
        case 2: return make_colour_rgb(120, 160, 60);   // Nurgle — sickly green
        case 3: return make_colour_rgb(210, 90, 200);   // Slaanesh — pink/purple
        default: return make_colour_rgb(150, 40, 160);  // Undivided — chaos purple
    }
}

/// @function chaos_god_from_patron
/// @description Map a CHAOSWARBAND `patron` string (the previously-dormant field) to a god index.
function chaos_god_from_patron(_p) {
    switch (_p) {
        case "khorne":   return 0;
        case "tzeentch": return 1;
        case "nurgle":   return 2;
        case "slaanesh": return 3;
        default:         return 4;   // "undivided"
    }
}

/// @function chaos_god_rival
/// @description The god that assails another in the Great Game — the canon rivalries: Khorne <-> Slaanesh
///              (rage vs excess), Tzeentch <-> Nurgle (change vs stagnation).
function chaos_god_rival(_g) {
    switch (_g) {
        case 0: return 3;   // Khorne  -> Slaanesh
        case 3: return 0;   // Slaanesh-> Khorne
        case 1: return 2;   // Tzeentch-> Nurgle
        case 2: return 1;   // Nurgle  -> Tzeentch
        default: return irandom(3);
    }
}

/// @function chaos_world_present
/// @description True if a world hosts any CHAOS-alliance force (Chaos Marines, Heretics or Daemons).
function chaos_world_present(_star, _planet) {
    if ((_star.p_chaos[_planet] > 0) || (_star.p_traitors[_planet] > 0) || (_star.p_demons[_planet] > 0)) { return true; }
    // An openly Chaos/Heretic-OWNED world is chaos-present by definition — the 0-6 level scalars can lag the
    // p_race_pop host (a heretic uprising's real force lives in the host), so don't miss the god/sect just
    // because a scalar reads 0 (§16r). This is what let a fully Chaos world show no "Sect Allegiance".
    var _own = _star.p_owner[_planet];
    if ((_own == eFACTION.CHAOS) || (_own == eFACTION.HERETICS)) { return true; }
    if (variable_instance_exists(_star, "p_race_pop") && (_planet < array_length(_star.p_race_pop))) {
        if (_star.p_race_pop[_planet][eFACTION.HERETICS] > 0) { return true; }
    }
    return false;
}

/// @function planet_chaos_god
/// @description The Chaos god a world is devoted to (§16r). Safe read of p_chaos_god; lazily ASSIGNS one the
///              first time a Chaos-tainted world is read — inheriting a CHAOSWARBAND feature's patron if it
///              has one, else rolling a god. Returns -1 if the world has no Chaos presence.
function planet_chaos_god(_star, _planet) {
    if (!variable_instance_exists(_star, "p_chaos_god")) { return -1; }
    if ((_planet < 0) || (_planet >= array_length(_star.p_chaos_god))) { return -1; }
    if (!chaos_world_present(_star, _planet)) { return -1; }
    if (_star.p_chaos_god[_planet] >= 0) { return _star.p_chaos_god[_planet]; }
    var _g = -1;
    var _pd = _star.get_planet_data(_planet);
    if (_pd.has_feature(eP_FEATURES.CHAOSWARBAND)) {
        var _cw = _pd.get_features(eP_FEATURES.CHAOSWARBAND)[0];
        if (variable_struct_exists(_cw, "patron")) { _g = chaos_god_from_patron(_cw.patron); }
    }
    if (_g < 0) { _g = chaos_pick_god_for_new_world(); }
    _star.p_chaos_god[_planet] = _g;
    return _g;
}

/// @function chaos_pick_god_for_new_world
/// @description Pick a god for a newly-tainted Chaos world (§16r). To spread the sects, EACH of the four gods
///              is guaranteed at least one holding before it goes random: while any god has zero worlds, pick
///              from the unrepresented ones; once all four are on the board, it's a flat 25 % each.
/// @returns {Real} god index 0-3
function chaos_pick_god_for_new_world() {
    var _t = chaos_sector_tally();
    var _missing = [];
    for (var i = 0; i < 4; i++) { if (_t.per_god[i] == 0) { array_push(_missing, i); } }
    if (array_length(_missing) > 0) { return _missing[irandom(array_length(_missing) - 1)]; }
    return irandom(3);   // all four gods represented — 25 % each
}

/// @function chaos_assign_god
function chaos_assign_god(_star, _planet, _god) {
    if (!variable_instance_exists(_star, "p_chaos_god")) { return; }
    if ((_planet < 0) || (_planet >= array_length(_star.p_chaos_god))) { return; }
    _star.p_chaos_god[_planet] = _god;
}

/// @function chaos_sector_tally
/// @description Sector census (§16r): total inhabitable worlds, total Chaos-held worlds, worlds per god, and
///              the dominant GOD sect. Returns { total, chaos, chaos_share, per_god:[k,t,n,s,u], dominant }.
function chaos_sector_tally() {
    var _total = 0, _chaos = 0;
    var _per = [0, 0, 0, 0, 0];
    with (obj_star) {
        if (!variable_instance_exists(id, "p_chaos_god")) { continue; }
        for (var _p = 1; _p <= planets; _p++) {
            var _tt = p_type[_p];
            if ((_tt == "") || (_tt == "Dead") || (_tt == "Space Hulk")) { continue; }
            _total += 1;
            // Read the RAW stored god — do NOT call planet_chaos_god here: it lazily assigns via
            // chaos_pick_god_for_new_world, which calls this tally, which would recurse forever (froze on
            // end turn). Only worlds with a Chaos presence AND an already-assigned god count.
            if ((_p < array_length(p_chaos_god)) && chaos_world_present(id, _p)) {
                var _g = p_chaos_god[_p];
                if (_g >= 0) { _chaos += 1; _per[_g] += 1; }
            }
        }
    }
    var _dom = -1, _domv = 0;
    for (var i = 0; i < 5; i++) { if (_per[i] > _domv) { _domv = _per[i]; _dom = i; } }
    return {
        total: _total, chaos: _chaos, per_god: _per, dominant: _dom,
        chaos_share: (_total > 0) ? (_chaos / _total) : 0,
    };
}

/// @function chaos_great_game_tick
/// @description The Great Game (§16r), run ONCE per turn at the sector level. While Chaos is a minority its
///              sects stay ALLIED (they war on the Imperium, not each other). Once Chaos holds >= 50 % of the
///              sector, the four GOD sects turn on one another: a rival god launches a visible INCURSION on
///              the dominant god's territory — flipping a world to the rival. Chaos UNDIVIDED never infights;
///              it keeps up the assault on the Imperium. Self-limits runaway Chaos.
function chaos_great_game_tick() {
    var _t = chaos_sector_tally();
    if (_t.chaos_share < 0.5) { return; }   // still allied against the Imperium — the Great Game sleeps

    // The biggest GOD sect (Undivided is exempt — it stays on the Imperium) is ganged up on by its rival.
    var _dom = -1, _domv = 0;
    for (var i = 0; i < 4; i++) { if (_t.per_god[i] > _domv) { _domv = _t.per_god[i]; _dom = i; } }
    if (_dom < 0) { return; }

    // Churn, don't wipe — ~1 incursion every couple of turns.
    if (irandom(2) < 2) { chaos_infight_incursion(_dom, chaos_god_rival(_dom)); }
}

/// @function chaos_infight_incursion
/// @description One act of the Great Game (§16r): a rival god seizes a world from the dominant god. Picks a
///              random world held by _dom, attrits its grip, flips its banner to _rival, and logs it (the
///              visible Chaos civil war).
function chaos_infight_incursion(_dom, _rival) {
    var _worlds = [];
    with (obj_star) {
        if (!variable_instance_exists(id, "p_chaos_god")) { continue; }
        for (var _p = 1; _p <= planets; _p++) {
            if (planet_chaos_god(id, _p) == _dom) { array_push(_worlds, [id, _p]); }
        }
    }
    if (array_length(_worlds) == 0) { return; }
    var _pick = _worlds[irandom(array_length(_worlds) - 1)];
    var _star = _pick[0], _planet = _pick[1];
    _star.p_chaos[_planet] = max(0, _star.p_chaos[_planet] - 1);
    _star.p_traitors[_planet] = max(0, _star.p_traitors[_planet] - 1);
    chaos_assign_god(_star, _planet, _rival);
    var _pd = _star.get_planet_data(_planet);
    scr_event_log("red", $"The Great Game: the champions of {chaos_god_name(_rival)} fall upon the {chaos_god_name(_dom)} world of {_pd.name()} — its warlords turn on each other and it changes allegiance.", _star.name);
}

/// @function chaos_god_cult_marine
/// @description The god-cult Marine a sect fields instead of the generic legionary (§16r). Undivided keeps
///              the plain "Chaos Space Marine".
function chaos_god_cult_marine(_god) {
    switch (_god) {
        case 0: return "Khorne Berzerker";
        case 1: return "Rubric Marine";
        case 2: return "Plague Marine";
        case 3: return "Noise Marine";
        default: return "Chaos Space Marine";
    }
}

/// @function chaos_god_daemon
/// @description The god's signature lesser daemon (§16r). "" for Undivided (keep the mixed daemon host).
function chaos_god_daemon(_god) {
    switch (_god) {
        case 0: return "Bloodletter";
        case 1: return "Pink Horror";
        case 2: return "Plaguebearer";
        case 3: return "Daemonette";
        default: return "";
    }
}

/// @function chaos_god_flavor
/// @description Reshape a Chaos/Daemon roster to a specific god (§16r): the generic "Chaos Space Marine"
///              becomes the god's cult Marine, and the four gods' lesser daemons all become the world's own
///              god's daemon — so a Khorne world fields Berzerkers + Bloodletters, a Tzeentch world Rubrics +
///              Pink Horrors, etc. Undivided (or no god) is left as the generic mix. Merges duplicate labels.
///              Returns a fresh array (never mutates the shared roster table).
/// @param {Array<Struct>} _lines
/// @param {Real} _god
/// @returns {Array<Struct>}
function chaos_god_flavor(_lines, _god) {
    if ((_god < 0) || (_god >= 4)) { return _lines; }   // Undivided / none -> unchanged
    var _marine = chaos_god_cult_marine(_god);
    var _daemon = chaos_god_daemon(_god);
    static _daemon_set = ["Bloodletter", "Pink Horror", "Plaguebearer", "Daemonette"];
    var _merged = {};
    var _order = [];
    for (var i = 0; i < array_length(_lines); i++) {
        var _lab = _lines[i].label;
        if (_lab == "Chaos Space Marine") { _lab = _marine; }
        else if ((_daemon != "") && array_contains(_daemon_set, _lab)) { _lab = _daemon; }
        if (!variable_struct_exists(_merged, _lab)) { _merged[$ _lab] = 0; array_push(_order, _lab); }
        _merged[$ _lab] += _lines[i].count;
    }
    var _out = [];
    for (var i = 0; i < array_length(_order); i++) { array_push(_out, { label: _order[i], count: _merged[$ _order[i]] }); }
    return _out;
}

/// @function chaos_god_icon
/// @description A distinct symbol shape (0-5, drawn by ork_draw_clan_symbol) for each god's map/panel marker.
function chaos_god_icon(_g) {
    switch (_g) {
        case 0: return 0;   // Khorne   — a brutal square
        case 1: return 3;   // Tzeentch — a diamond
        case 2: return 1;   // Nurgle   — a bloated disc
        case 3: return 2;   // Slaanesh — a spearpoint
        default: return 5;  // Undivided— crossed marks
    }
}

/// @function chaos_god_champion
/// @description The title of the sect's leading champion, shown on the allegiances panel (§16r).
function chaos_god_champion(_g) {
    switch (_g) {
        case 0: return "a Khornate Lord";
        case 1: return "a Sorcerer of Tzeentch";
        case 2: return "a Lord of Contagion";
        case 3: return "a Lord of Slaanesh";
        default: return "a Chaos Lord";
    }
}

/// @function chaos_god_style_desc
/// @description The sect's nature/way of war (§16r), for the allegiances panel — the Chaos analogue of the
///              Ork clan style text.
function chaos_god_style_desc(_g) {
    switch (_g) {
        case 0: return "Khorne — the Blood God. His warbands crave only slaughter: massed Berzerkers and Bloodletters hurled headlong into a red melee, with contempt for guns and sorcery alike.";
        case 1: return "Tzeentch — the Changer of Ways. Sorcery and scheming: Rubric Marines and Pink Horrors wreathed in warpflame, plots within plots, victory by manipulation as much as firepower.";
        case 2: return "Nurgle — the Plague Lord. Grandfatherly rot and grim endurance: Plague Marines and Plaguebearers who simply will not die, spreading contagion from behind walls of diseased flesh.";
        case 3: return "Slaanesh — the Dark Prince. Speed and excess: Noise Marines and Daemonettes in a screaming, sensation-drunk charge, sonic weapons and lightning assaults that leave nothing untouched.";
        default: return "Chaos Undivided — devoted to no single god but the ruinous powers entire; the Black Crusade that keeps the Long War against the Imperium burning.";
    }
}

/// @function chaos_sect_allegiance
/// @description The Chaos analogue of the Ork warband-allegiance block (§16r), so a Chaos world can REUSE the
///              same Forces-panel section: one sect entry for the world's god (colour bar + symbol + champion)
///              plus its style text. Same struct shape draw_force_panel expects in `_data.warbands`.
/// @param {Real} _god
/// @returns {Struct}
function chaos_sect_allegiance(_god) {
    return {
        warbands: [{
            name: chaos_god_name(_god),
            boss: chaos_god_champion(_god),
            boss_label: chaos_god_champion(_god),
            share: 1,
            leads: true,
            joined: false,
            colour: chaos_god_colour(_god),
            icon: chaos_god_icon(_god),
        }],
        lead_kultur: 0,
        lead_kultur_name: "",
        style_desc: chaos_god_style_desc(_god),
        allegiance_title: "Sect Allegiance",
        contested: false, dominant: false, count: 1,
    };
}

/// @function faction_pop_composition
/// @description The GENERAL population-driven roster engine (§16b): scales a faction's mature composition
///              SHAPE (its level-6 table, infra-gated so undeveloped worlds field only basics) so the
///              total equals a real population headcount. For total-war races whose population IS their
///              force (Necrons, Tyranids). Orks have their own procedural recipe (ork_composition).
/// @param {Real} _faction
/// @param {Real} _population    real headcount
/// @param {Real} _infra         planet_infra_turns
/// @param {Real} [_shape_level] which ladder tier to use as the SHAPE (default 6 = mature). Genestealer Cults
///                              pass 3 so a growing cult scales the CULT roster (Neophytes/Acolytes/…), NOT
///                              the Hive-swarm bioforms which only appear after Ascension (§16p).
/// @returns {Array<Struct>}
function faction_pop_composition(_faction, _population, _infra, _shape_level = 6) {
    if (_population <= 0) { return []; }
    var _shape = faction_ladder_composition(_faction, _shape_level, _infra);
    var _total = 0;
    for (var i = 0; i < array_length(_shape); i++) { _total += _shape[i].count; }
    if (_total <= 0) { return []; }
    var _scale = _population / _total;
    var _out = [];
    for (var i = 0; i < array_length(_shape); i++) {
        var _c = round(_shape[i].count * _scale);
        if (_c > 0) { array_push(_out, { label: _shape[i].label, count: _c }); }
    }
    return _out;
}

/// @function planet_ork_loot
/// @description Safe read of the looted-vehicle count the Orks hold on a world (guards old saves -> 0).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function planet_ork_loot(_star, _planet) {
    if (!variable_instance_exists(_star, "p_ork_loot")) { return 0; }
    var _a = _star.p_ork_loot;
    if ((_planet < 0) || (_planet >= array_length(_a))) { return 0; }
    return _a[_planet];
}

/// @function planet_faction_force_total
/// @description Total field strength (sum of the population-driven roster) a faction musters on a world.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _faction
/// @returns {Real}
function planet_faction_force_total(_star, _planet, _faction) {
    var _comp = planet_faction_composition(_star, _planet, _faction);
    var _t = 0;
    for (var i = 0; i < array_length(_comp); i++) {
        _t += _comp[i].count;
    }
    return _t;
}

/// @function ork_bloom_seed
/// @description Starting Ork headcount for a fresh Fungal Bloom, scaled to the world it infests (the
///              denser/richer the world, the bigger the green tide it can sustain). Grows over turns
///              toward ork_bloom_cap. Tunable — first-cut values for the pilot (§16b). Population-scale
///              so a WAAAGH is comparable to an Imperial garrison, not a tiny 0-6 anchor.
/// @param {String} _type  world type
/// @returns {Real}
function ork_bloom_seed(_type) {
    // Small — a fresh bloom is just spores taking root. It grows slowly at first and compounds harder
    // the longer it's left (see the accelerating rate in end_turn_race_population_growth): ~tens of
    // thousands early, millions by ~turn 50, world-scale if ignored. The CAP is world-scaled separately.
    switch (_type) {
        case "Hive":      return 40000;
        case "Forge":     return 30000;
        case "Temperate":
        case "Shrine":    return 20000;
        case "Feudal":
        case "Desert":    return 12000;
        case "Ice":
        case "Agri":
        case "Death":     return 6000;
        default:          return 4000;
    }
}

/// @function ork_bloom_cap
/// @description The ceiling a Fungal Bloom grows to on a world (a fully-developed WAAAGH). ~60x the seed
///              so a mature hive infestation (~480M) is comparable to a hive's Imperial garrison. Tunable.
/// @param {String} _type
/// @returns {Real}
function ork_bloom_cap(_type) {
    return ork_bloom_seed(_type) * 60;
}

/// @function necron_awaken_seed
/// @description Starting AWAKENED Necron headcount when a tomb surges to life — the first legions to rise.
///              Small; grows slowly over turns (Necrons awaken gradually, not in a boom). Scaled to the
///              dynasty the world hosts. Necrons are elite and far fewer than an Ork tide. Tunable (§16b).
/// @param {String} _type  world type
/// @returns {Real}
function necron_awaken_seed(_type) {
    switch (_type) {
        case "Hive":
        case "Forge":     return 100000;
        case "Temperate":
        case "Shrine":
        case "Desert":
        case "Feudal":    return 50000;
        default:          return 20000;
    }
}

/// @function tyranid_swarm_seed
/// @description Starting swarm headcount the moment the Ascension Beacon lights and the Hive Fleet's
///              vanguard makes planetfall (§16b). It then reproduces explosively off the world's biomass.
/// @param {String} _type  world type
/// @returns {Real}
function tyranid_swarm_seed(_type) {
    switch (_type) {
        case "Hive":
        case "Forge":     return 200000;
        case "Temperate":
        case "Shrine":
        case "Desert":
        case "Feudal":    return 100000;
        default:          return 30000;
    }
}

/// @function tyranid_biomass_budget
/// @description The world's total CONSUMABLE living matter — its people plus its native ecosystem — that a
///              Hive Fleet strips and converts into swarm (§16b). Seeded into p_biomass at planetfall; the
///              swarm's final size is roughly this × conversion efficiency. Hive/Forge worlds are almost
///              all people (little wild); Agri/Death/Ocean worlds teem with wild biomass that dwarfs a
///              sparse populace. Ecosystem is a multiple of the world's carrying capacity. Tunable.
/// @param {String} _type        world type
/// @param {Real}   _human_head  current populace (raw headcount)
/// @param {Real}   _cap_head    world carrying capacity (raw headcount)
/// @returns {Real}
function tyranid_biomass_budget(_type, _human_head, _cap_head) {
    var _eco;
    switch (_type) {
        case "Hive":
        case "Forge":     _eco = 0.20; break;   // hab-blocks & manufactora — the people ARE the biomass
        case "Desert":
        case "Ice":       _eco = 0.50; break;   // sparse, hostile
        case "Feudal":
        case "Shrine":
        case "Temperate": _eco = 2.0;  break;
        case "Agri":      _eco = 3.0;  break;   // farm worlds — teeming
        case "Ocean":     _eco = 4.0;  break;
        case "Jungle":
        case "Death":     _eco = 5.0;  break;   // rampant, lethal biosphere
        default:          _eco = 1.5;  break;
    }
    return _human_head + round(_cap_head * _eco);
}

/// @function ascend_tyranid_world
/// @description ASCENSION DAY (§16b): the Genestealer Cult lights the psychic Ascension Beacon and the
///              Hive Fleet answers. Tags the world with the beacon feature and seeds the swarm; from then
///              on end_turn_race_population_growth grows it explosively off the biomass. Idempotent.
/// @param {Struct.PlanetData} _pd
/// @returns {Undefined}
function ascend_tyranid_world(_pd) {
    if (_pd.has_feature(eP_FEATURES.ASCENSION_BEACON)) { return; }   // already ascended
    _pd.add_feature(eP_FEATURES.ASCENSION_BEACON);
    // The cult has fulfilled its purpose (§16p) — it lit the beacon; from here the biomass swarm takes over.
    if (_pd.has_feature(eP_FEATURES.GENE_STEALER_CULT)) { _pd.delete_feature(eP_FEATURES.GENE_STEALER_CULT); }
    // Summon the Hive Fleet: a Tyranid fleet warps in at the sector edge and moves to answer the beacon.
    // The swarm does NOT land yet — it makes planetfall only when the fleet arrives (the beacon's eta
    // counts down in end_turn_race_population_growth). The fleet is spawned for presence/flavour; guarded
    // so a spawn hiccup can never block the ascension itself.
    var _star = _pd.system;
    try {
        // Warp in at the MAP EDGE and cross the sector to answer the beacon.
        var _fx = 0, _fy = 0;
        switch (irandom(3)) {
            case 0:  _fx = 0;                   _fy = irandom(room_height); break; // left edge
            case 1:  _fx = room_width;          _fy = irandom(room_height); break; // right edge
            case 2:  _fx = irandom(room_width); _fy = 0;                    break; // top edge
            default: _fx = irandom(room_width); _fy = room_height;          break; // bottom edge
        }
        var _hf = instance_create(_fx, _fy, obj_en_fleet);
        _hf.owner = eFACTION.TYRANIDS;
        _hf.revealed = true;   // a beacon-summoned Hive Fleet is a known arrival — visible across the map
        _hf.capital_number = 2;
        _hf.frigate_number = 4;
        _hf.escort_number = 6;
        _hf.target = _star;
        _hf.target_x = _star.x;
        _hf.target_y = _star.y;
        // Travel is driven by action_x/action_y + set_fleet_movement (which sets action="move" and computes
        // the warp-lane route + ETA). Setting target/action alone does NOT move an obj_en_fleet — the mover
        // in obj_en_fleet/Alarm_1 only reads action_x/action_y, so without this the fleet sits at the edge.
        _hf.action_x = _star.x;
        _hf.action_y = _star.y;
        if (asset_get_index("spr_fleet_tyranid") != -1) { _hf.sprite_index = asset_get_index("spr_fleet_tyranid"); }
        with (_hf) { set_fleet_movement(); }
    } catch (_e) {
        LOGGER.exception("Hive Fleet spawn failed", _e);
    }
}

/// @function force_ascension_day
/// @description DEBUG / test helper: force ASCENSION DAY on a world regardless of the cult's strength or
///              concealment. Ensures a Genestealer Cult exists on the planet (seeds one if needed), drags it
///              out of hiding, hands the world to the Tyranids, seeds the swarm and lights the Ascension
///              Beacon (calls ascend_tyranid_world → summons the Hive Fleet). Used by the "ascension" cheat
///              so the whole beacon → planetfall → biomass-bloom chain can be tested on any selected planet.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function force_ascension_day(_star, _planet) {
    if (!instance_exists(_star)) { return; }
    var _pd = _star.get_planet_data(_planet);
    // Seed a cult if the world has none, so the test works on ANY selected planet.
    if (!_pd.has_feature(eP_FEATURES.GENE_STEALER_CULT)) {
        _pd.add_feature(eP_FEATURES.GENE_STEALER_CULT);
    }
    var _cults = _pd.get_features(eP_FEATURES.GENE_STEALER_CULT);
    if (array_length(_cults) > 0) { _cults[0].hiding = false; }   // drag it into the open
    _pd.set_new_owner(eFACTION.TYRANIDS);
    _pd.edit_forces(eFACTION.TYRANIDS, 1);
    ascend_tyranid_world(_pd);                                     // light the beacon, summon the Hive Fleet
    scr_event_log("red", $"[DEBUG] Ascension Day forced on {_pd.name()} — the beacon is lit.", _star.name);
    scr_popup("Ascension Day", $"The Genestealer Cult on {_pd.name()} lights the Ascension Beacon. The Hive Fleet answers the call.", "Genestealer Cult", "");
}

/// @function tyranid_planet_is_food
/// @description A world is still "food" for the swarm if it isn't a Dead husk and still has living matter to
///              devour — a standing population OR an un-stripped biomass reserve. A world the swarm has
///              already reduced to nothing (pop 0, biomass 0) is spent and no longer worth orbiting (§16n).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Bool}
function tyranid_planet_is_food(_star, _planet) {
    var _t = _star.p_type[_planet];
    if (_t == "Dead" || _t == "") { return false; }
    var _pop = _star.p_population[_planet];
    var _bio = variable_instance_exists(_star, "p_biomass") ? _star.p_biomass[_planet] : 0;
    return (_pop > 0) || (_bio > 0);
}

/// @function tyranid_system_consumed
/// @description True when NO planet in the system is still food — the whole system is a stripped husk (§16n).
/// @param {Id.Instance.obj_star} _star
/// @returns {Bool}
function tyranid_system_consumed(_star) {
    if (!instance_exists(_star)) { return true; }
    for (var i = 1; i <= _star.planets; i++) {
        if (tyranid_planet_is_food(_star, i)) { return false; }
    }
    return true;
}

/// @function tyranid_system_needs_fleet
/// @description True while a food world here is NOT yet infested — the Hive Fleet is still needed to seed it.
///              Once every food world is Tyranid-infested (and the biomass engine will finish them off with
///              or without the fleet), this returns false and the fleet is free to migrate on (§16n). This is
///              the migrate trigger: the swarm advances as soon as it has doomed everything reachable here,
///              leaving the worlds behind it to be stripped over the following turns.
/// @param {Id.Instance.obj_star} _star
/// @returns {Bool}
function tyranid_system_needs_fleet(_star) {
    if (!instance_exists(_star) || !variable_instance_exists(_star, "p_race_pop")) { return false; }
    for (var i = 1; i <= _star.planets; i++) {
        if (!tyranid_planet_is_food(_star, i)) { continue; }
        var _infested = (_star.p_owner[i] == eFACTION.TYRANIDS) && (_star.p_race_pop[i][eFACTION.TYRANIDS] > 0);
        if (!_infested) { return true; }   // an un-infested food world remains — stay and seed it
    }
    return false;
}

/// @function tyranid_fleet_engage
/// @description The Hive Fleet begins DEVOURING the worlds it's in orbit over: for up to _max_worlds food
///              planets it seeds a swarm and marks the world Tyranid-infested, which switches on the biomass
///              engine (end_turn_race_population_growth) so the world is stripped over the coming turns —
///              and keeps being stripped even after the fleet has moved on. Idempotent per world (§16n).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _max_worlds  how many worlds this fleet's bio-ships can engage at once
/// @returns {Undefined}
function tyranid_fleet_engage(_star, _max_worlds) {
    if (!instance_exists(_star) || !variable_instance_exists(_star, "p_race_pop")) { return; }
    var _engaged = 0;
    for (var i = 1; i <= _star.planets; i++) {
        if (_engaged >= _max_worlds) { break; }
        if (!tyranid_planet_is_food(_star, i)) { continue; }
        var _already = (_star.p_owner[i] == eFACTION.TYRANIDS) && (_star.p_race_pop[i][eFACTION.TYRANIDS] > 0);
        if (!_already) {
            if (_star.p_race_pop[i][eFACTION.TYRANIDS] <= 0) {
                _star.p_race_pop[i][eFACTION.TYRANIDS] = tyranid_swarm_seed(_star.p_type[i]);
            }
            var _pd = _star.get_planet_data(i);
            _pd.set_new_owner(eFACTION.TYRANIDS);
            _star.p_tyranids[i] = count_to_level(eFACTION.TYRANIDS, _star.p_race_pop[i][eFACTION.TYRANIDS]);
            scr_event_log("red", $"A Tyranid swarm makes planetfall on {_pd.name()} and begins to consume it.", _star.name);
        }
        _engaged += 1;
    }
}

/// @function tyranid_fleet_migrate
/// @description Send a Hive Fleet on to the NEAREST other system that still has food, using the standard
///              mover (action_x/action_y + set_fleet_movement). Returns false when the whole sector has
///              been devoured and there's nothing left to eat (§16n).
/// @param {Id.Instance.obj_en_fleet} _fleet
/// @returns {Bool}
function tyranid_fleet_migrate(_fleet) {
    if (!instance_exists(_fleet)) { return false; }
    var _best = noone;
    var _bestd = 1000000000;
    var _fx = _fleet.x;
    var _fy = _fleet.y;
    var _from = _fleet.orbiting;
    // Only target systems that still have UN-infested food — never bounce back to a system the swarm has
    // already seeded (its worlds are being stripped in the background and don't need the fleet again).
    with (obj_star) {
        if (id == _from) { continue; }
        if (!tyranid_system_needs_fleet(id)) { continue; }
        var _d = point_distance(_fx, _fy, x, y);
        if (_d < _bestd) { _bestd = _d; _best = id; }
    }
    if (instance_exists(_best)) {
        _fleet.target = _best;
        _fleet.target_x = _best.x;
        _fleet.target_y = _best.y;
        _fleet.action_x = _best.x;
        _fleet.action_y = _best.y;
        with (_fleet) { set_fleet_movement(); }
        return true;
    }
    return false;
}

/// @function ork_world_has_meks
/// @description Ork "infrastructure" gate: an established Stronghold, or captured Forge/Hive industry,
///              gives the Meks their workshops. Without it a WAAAGH fields only the basic mob.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Bool}
function ork_world_has_meks(_star, _planet) {
    if (planet_feature_bool(_star.p_feature[_planet], eP_FEATURES.ORKSTRONGHOLD)) {
        return true;
    }
    var _t = _star.p_type[_planet];
    return (_t == "Forge") || (_t == "Hive");
}

/// @function planet_infra_turns
/// @description Safe read of a planet's infrastructure-development counter (turns the owner has held
///              and built it up). Drives force tier + production ramp. Old saves default to 32 (fully
///              developed). See obj_star Create_0 / scr_star_ownership.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function planet_infra_turns(_star, _planet) {
    if (!variable_instance_exists(_star, "p_infra_turns")) {
        return 32;
    }
    var _arr = _star.p_infra_turns;
    if ((_planet < 0) || (_planet >= array_length(_arr))) {
        return 32;
    }
    return _arr[_planet];
}

// ============================================================================================
//  Ork CLANS (§16e) — a world's WAAAGH is made of several clans; the BIGGEST leads and flavours it.
//  Clan index: 0 Goffs, 1 Bad Moons, 2 Evil Sunz, 3 Deathskulls, 4 Snakebites, 5 Blood Axes.
// ============================================================================================

/// @function ork_clan_count
/// @returns {Real} number of defined clans
function ork_clan_count() { return 6; }

/// @function ork_clan_name
/// @param {Real} _i  clan index
/// @returns {String}
function ork_clan_name(_i) {
    switch (_i) {
        case 0: return "Goffs";
        case 1: return "Bad Moons";
        case 2: return "Evil Sunz";
        case 3: return "Deathskulls";
        case 4: return "Snakebites";
        case 5: return "Blood Axes";
        default: return "Freebooterz";
    }
}

/// @function ork_clan_boss_title
/// @description Flavourful Warboss epithet for a clan (for WAAAGH popups / naming).
/// @param {Real} _i
/// @returns {String}
function ork_clan_boss_title(_i) {
    switch (_i) {
        case 0: return "Goff Warboss";
        case 1: return "Bad Moon Warboss";
        case 2: return "Speed-Freek Warboss";
        case 3: return "Deathskull Warboss";
        case 4: return "Snakebite Warboss";
        case 5: return "Blood Axe Warboss";
        default: return "Warboss";
    }
}

/// @function ork_clan_colour
/// @description Accent colour for a clan, tuned to its 40k kultur, for the at-a-glance map marker (§16f).
///              This is only a SECONDARY accent — the base map colour for Orks stays green.
/// @param {Real} _i  clan kultur index
/// @returns {Real}   a GML colour
function ork_clan_colour(_i) {
    switch (_i) {
        case 0: return c_white;                     // Goffs — black & white checks (white reads on the dark map)
        case 1: return make_colour_rgb(255, 220, 0);   // Bad Moons — yellow
        case 2: return make_colour_rgb(255, 40, 40);   // Evil Sunz — red
        case 3: return make_colour_rgb(60, 140, 255);  // Deathskulls — blue
        case 4: return make_colour_rgb(255, 130, 0);   // Snakebites — orange
        case 5: return make_colour_rgb(160, 110, 60);  // Blood Axes — khaki camo
        default: return c_white;
    }
}

/// @function ork_generate_clan_colour
/// @description A bright, saturated "warpaint" colour unique to a procedurally-generated clan (§16m). Kept
///              off near-black so it reads on the dark map. Stored on the warband and used everywhere its
///              icon is drawn, so every clan has its OWN colour rather than a shared kultur colour.
/// @returns {Real} a GML colour
function ork_generate_clan_colour() {
    var _r = irandom_range(50, 255);
    var _g = irandom_range(50, 255);
    var _b = irandom_range(50, 255);
    if (max(_r, _g, _b) < 170) {                 // guarantee at least one bright channel
        switch (irandom(2)) { case 0: _r = 255; break; case 1: _g = 255; break; default: _b = 255; }
    }
    return make_colour_rgb(_r, _g, _b);
}

/// @function ork_warband_colour
/// @description A warband's OWN generated clan colour (§16m); falls back to the legacy kultur colour for
///              warbands loaded from pre-16m saves that have no colour field.
/// @param {Struct} _wb
/// @returns {Real}
function ork_warband_colour(_wb) {
    if (is_struct(_wb) && variable_struct_exists(_wb, "colour")) { return _wb.colour; }
    return ork_clan_colour((is_struct(_wb) && variable_struct_exists(_wb, "kultur")) ? _wb.kultur : 0);
}

/// @function ork_warband_icon_shape
/// @description A warband's OWN icon shape index (0-5) (§16m); legacy fallback = its kultur.
/// @param {Struct} _wb
/// @returns {Real}
function ork_warband_icon_shape(_wb) {
    if (is_struct(_wb) && variable_struct_exists(_wb, "icon")) { return _wb.icon; }
    return (is_struct(_wb) && variable_struct_exists(_wb, "kultur")) ? _wb.kultur : 0;
}

/// @function ork_clan_draw_icon
/// @description Legacy wrapper: draw a clan symbol from a KULTUR index (its shape + kultur colour). Kept for
///              old call sites; new code draws per-warband via ork_warband_draw_icon (§16m).
/// @param {Real} _clan  kultur index (0-5)
function ork_clan_draw_icon(_clan, _cx, _cy, _r) {
    ork_draw_clan_symbol(_clan, ork_clan_colour(_clan), _cx, _cy, _r);
}

/// @function ork_warband_draw_icon
/// @description Draw a warband's clan symbol in its OWN colour + shape (§16m) — the map marker and the force
///              panel rows both use this, so every unique clan reads distinctly.
/// @param {Struct} _wb
function ork_warband_draw_icon(_wb, _cx, _cy, _r) {
    ork_draw_clan_symbol(ork_warband_icon_shape(_wb), ork_warband_colour(_wb), _cx, _cy, _r);
}

/// @function ork_draw_clan_symbol
/// @description Draw a small clan SYMBOL — one of 6 distinct shapes (_shape 0-5) in colour _col — centred at
///              (_cx,_cy) with radius ~_r. Restores draw colour/alpha on exit.
/// @param {Real} _shape  shape index (0-5)
/// @param {Real} _col    GML colour
/// @param {Real} _cx
/// @param {Real} _cy
/// @param {Real} _r
/// @returns {Undefined}
function ork_draw_clan_symbol(_shape, _col, _cx, _cy, _r) {
    var _clan = _shape;
    draw_set_alpha(1);
    draw_set_color(_col);
    switch (_clan) {
        case 0: // Goffs — a blunt, brutal SQUARE
            draw_rectangle(_cx - _r, _cy - _r, _cx + _r, _cy + _r, false);
            draw_set_color(c_black);
            draw_rectangle(_cx - _r, _cy - _r, _cx + _r, _cy + _r, true);
            break;
        case 1: // Bad Moons — a MOON (disc)
            draw_circle(_cx, _cy, _r, false);
            draw_set_color(c_black);
            draw_circle(_cx, _cy, _r, true);
            break;
        case 2: // Evil Sunz — a fast ARROW/triangle pointing up
            draw_triangle(_cx, _cy - _r, _cx - _r, _cy + _r, _cx + _r, _cy + _r, false);
            draw_set_color(c_black);
            draw_triangle(_cx, _cy - _r, _cx - _r, _cy + _r, _cx + _r, _cy + _r, true);
            break;
        case 3: // Deathskulls — a DIAMOND
            draw_triangle(_cx, _cy - _r, _cx - _r, _cy, _cx + _r, _cy, false);
            draw_triangle(_cx, _cy + _r, _cx - _r, _cy, _cx + _r, _cy, false);
            draw_set_color(c_black);
            draw_line(_cx, _cy - _r, _cx + _r, _cy);
            draw_line(_cx + _r, _cy, _cx, _cy + _r);
            draw_line(_cx, _cy + _r, _cx - _r, _cy);
            draw_line(_cx - _r, _cy, _cx, _cy - _r);
            break;
        case 4: // Snakebites — a FANG/triangle pointing down
            draw_triangle(_cx, _cy + _r, _cx - _r, _cy - _r, _cx + _r, _cy - _r, false);
            draw_set_color(c_black);
            draw_triangle(_cx, _cy + _r, _cx - _r, _cy - _r, _cx + _r, _cy - _r, true);
            break;
        case 5: // Blood Axes — CROSSED AXES (an X), black underlay for contrast
            var _w = max(2, _r * 0.5);
            draw_set_color(c_black);
            draw_line_width(_cx - _r, _cy - _r, _cx + _r, _cy + _r, _w + 2);
            draw_line_width(_cx + _r, _cy - _r, _cx - _r, _cy + _r, _w + 2);
            draw_set_color(_col);
            draw_line_width(_cx - _r, _cy - _r, _cx + _r, _cy + _r, _w);
            draw_line_width(_cx + _r, _cy - _r, _cx - _r, _cy + _r, _w);
            break;
        default:
            draw_circle(_cx, _cy, _r, false);
            break;
    }
    draw_set_color(c_white);
    draw_set_alpha(1);
}

/// @function system_leading_ork_clan
/// @description The leading Ork clan of a whole star system — taken from the planet with the biggest Ork
///              population (its dominant WAAAGH). Returns the kultur index, or -1 if the system has no Orks.
///              Used for the map accent pip. §16f.
/// @param {Id.Instance.obj_star} _star
/// @returns {Real}
function system_leading_ork_clan(_star) {
    if (!variable_instance_exists(_star, "p_race_pop")) { return -1; }
    var _best_planet = -1, _best_pop = 0;
    for (var _p = 1; _p <= _star.planets; _p++) {
        if (_p >= array_length(_star.p_race_pop)) { break; }
        var _op = _star.p_race_pop[_p][eFACTION.ORK];
        if (_op > _best_pop) { _best_pop = _op; _best_planet = _p; }
    }
    if (_best_planet < 0) { return -1; }
    return ork_leading_clan(_star, _best_planet);
}

/// @function system_leading_ork_warband
/// @description The leading WARBAND of a whole star system (from its biggest-Ork-pop planet), so the map can
///              draw that clan's OWN colour + icon (§16m). Returns the warband struct, or noone if no Orks.
/// @param {Id.Instance.obj_star} _star
/// @returns {Struct|Real}
function system_leading_ork_warband(_star) {
    if (!variable_instance_exists(_star, "p_race_pop")) { return noone; }
    var _best_planet = -1, _best_pop = 0;
    for (var _p = 1; _p <= _star.planets; _p++) {
        if (_p >= array_length(_star.p_race_pop)) { break; }
        var _op = _star.p_race_pop[_p][eFACTION.ORK];
        if (_op > _best_pop) { _best_pop = _op; _best_planet = _p; }
    }
    if (_best_planet < 0) { return noone; }
    var _i = ork_leading_warband_index(_star, _best_planet);
    if (_i < 0) { return noone; }
    var _wb = planet_ork_clans(_star, _best_planet);
    return (_i < array_length(_wb)) ? _wb[_i] : noone;
}

/// @function ork_warband_breakdown
/// @description The warband split of a world's Ork force, for the Forces panel (§16f): each warband's name,
///              clan, boss, and SHARE of the horde (from the hidden allegiance weights), sorted biggest first.
///              Plus a tactical read — CONTESTED (an even split, so a Behead would spark a bloody civil war)
///              vs DOMINANT (one boss far ahead, so a Behead is just a quick scramble) — and the projected
///              civil-war losses. Returns { warbands:[{name,boss,clan,kultur,share,leads}], contested,
///              dominant, projected_losses, count }.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Struct}
function ork_warband_breakdown(_star, _planet) {
    var _wb = planet_ork_clans(_star, _planet);
    var _n = array_length(_wb);
    var _out = { warbands: [], contested: false, dominant: false, projected_losses: 0, count: _n };
    if (_n == 0) { return _out; }

    var _tot = 0;
    for (var i = 0; i < _n; i++) { _tot += _wb[i].weight; }
    if (_tot <= 0) { _tot = 1; }

    // Order indices by weight, biggest first (selection sort — the list is tiny).
    var _idx = array_create(_n);
    for (var i = 0; i < _n; i++) { _idx[i] = i; }
    for (var a = 0; a < _n; a++) {
        for (var b = a + 1; b < _n; b++) {
            if (_wb[_idx[b]].weight > _wb[_idx[a]].weight) { var _t = _idx[a]; _idx[a] = _idx[b]; _idx[b] = _t; }
        }
    }

    var _lead_i = ork_leading_warband_index(_star, _planet);
    var _top_share = 0;
    for (var i = 0; i < _n; i++) {
        var _w = _wb[_idx[i]];
        var _share = _w.weight / _tot;
        if (_share > _top_share) { _top_share = _share; }
        array_push(_out.warbands, {
            name: _w.name,
            boss: ork_wb_boss(_w),
            kultur: _w.kultur,                          // hidden style archetype (drives the roster/style text)
            colour: ork_warband_colour(_w),             // this clan's OWN colour (§16m)
            icon: ork_warband_icon_shape(_w),           // this clan's OWN icon shape (§16m)
            share: _share,
            leads: (_idx[i] == _lead_i),
            joined: (variable_struct_exists(_w, "joined") && _w.joined),
        });
    }

    _out.projected_losses = clamp(0.30 + (1 - _top_share) * 0.40, 0.30, 0.65);   // same as ork_civil_war
    _out.contested = (_n >= 2) && (_top_share < 0.55);
    _out.dominant  = (_n >= 2) && (_top_share >= 0.55);
    _out.lead_kultur = ((_lead_i >= 0) && (_lead_i < _n)) ? _wb[_lead_i].kultur : 0;   // whose style the WAAAGH fights in
    _out.lead_kultur_name = ((_lead_i >= 0) && (_lead_i < _n) && variable_struct_exists(_wb[_lead_i], "kultur_name")) ? _wb[_lead_i].kultur_name : "";
    return _out;
}

/// @function ork_generate_warband_name
/// @description A procedural orky warband name, lightly flavoured by kultur. Two shapes: "Da <adj> <noun>"
///              or "<Bossname>'s <noun>". So a world's WAAAGH reads as named tribes, not just the six clans.
/// @param {Real} _kultur  clan kultur index (0-5) for flavour
/// @returns {String}
function ork_generate_warband_name(_kultur) {
    var _adj  = choose("Green","Red","Killy","Stompy","Choppy","Loud","Big","Bad","Mean","'Ard","Deff","Krumpin'","Smashin'","Burnin'","Dakka","Skull","Boom","Rusty","Spiky","Screamin'","Gutbustin'","Stabby");
    var _noun = choose("Krumpaz","Smashaz","Boyz","Skullz","Fistz","Choppaz","Stompaz","Gitz","Nutz","Klawz","Teef","Bootboyz","Snaggaz","Boomaz","Burnaz","Wreckaz","Basherz","Maniakz","Killaz");
    switch (_kultur) {
        case 0: _adj = choose(_adj, "Black", "Killy", "Choppy");            _noun = choose(_noun, "Skullz", "Krumpaz", "Choppaz"); break;       // Goffs
        case 1: _adj = choose(_adj, "Shiny", "Yellow", "Flash", "Dakka");   _noun = choose(_noun, "Gitz", "Dakkaboyz", "Shootaz"); break;       // Bad Moons
        case 2: _adj = choose(_adj, "Speedy", "Red", "Zoomin'", "Fast");    _noun = choose(_noun, "Speed Freeks", "Racerz", "Zoomerz"); break;  // Evil Sunz
        case 3: _adj = choose(_adj, "Blue", "Lootin'", "Sneaky");           _noun = choose(_noun, "Lootaz", "Grabbaz", "Salvagaz"); break;      // Deathskulls
        case 4: _adj = choose(_adj, "Old", "Feral", "Squiggy");             _noun = choose(_noun, "Snaggaz", "Squigboyz", "Beastboyz"); break;  // Snakebites
        case 5: _adj = choose(_adj, "Kunnin'", "Sneaky", "Kamo");           _noun = choose(_noun, "Kommandoz", "Sneakaz", "Ambushaz"); break;   // Blood Axes
    }
    if (irandom(2) == 0) {
        var _boss = choose("Gorznak","Grukk","Uzgob","Morglum","Snagga","Badtoof","Skarfang","Wazdakka","Gutrip","Zagstruk","Nazgruk","Urtylug","Grimgor","Dregmaw");
        return _boss + "'s " + _noun;
    }
    return "Da " + _adj + " " + _noun;
}

/// @function ork_generate_boss_name
/// @description A procedural Ork Warboss name — a first name, sometimes with a brutal epithet. Every warband
///              has one; duels are fought between the bosses (ork_grow_clans).
/// @returns {String}
function ork_generate_boss_name() {
    var _first = choose("Gorznak","Grukk","Uzgob","Morglum","Snagga","Badtoof","Skarfang","Wazdakka","Gutrip","Zagstruk","Nazgruk","Urtylug","Grimgor","Dregmaw","Gobsmaka","Rukkzag","Skarboss","Urgok","Gutrippa","Morgrub");
    if (irandom(2) == 0) {
        var _ep = choose("da Krumpa","da Green","Skullsplitta","da Big","da Mean","Ironjaw","da Loud","Bonebreaka","da Kunnin'","Facebita","da Stompy","Deffgob","da 'Ard");
        return _first + " " + _ep;
    }
    return _first;
}

/// @function ork_kultur_duel_mult
/// @description How handy a kultur's boss is in a personal scrap (a leadership duel). Goffs are the hardest
///              brawlers; Bad Moons would rather shoot than fist-fight. Feeds the duel odds.
/// @param {Real} _kultur
/// @returns {Real}
function ork_kultur_duel_mult(_kultur) {
    switch (_kultur) {
        case 0: return 1.30;   // Goffs — the hardest brawlers in the galaxy
        case 4: return 1.15;   // Snakebites — tough old gits
        case 5: return 1.12;   // Blood Axes — fight dirty / kunnin'
        case 2: return 1.05;   // Evil Sunz — fast and aggressive
        case 3: return 1.00;   // Deathskulls
        case 1: return 0.95;   // Bad Moons — dakka boyz, less handy up close
        default: return 1.00;
    }
}

/// @function ork_wb_boss
/// @description Safe read of a warband's Warboss name — lazily generates one for warbands from older saves
///              (pre-duel format) that lack the field.
/// @param {Struct} _wb
/// @returns {String}
function ork_wb_boss(_wb) {
    if (!variable_struct_exists(_wb, "boss")) { _wb.boss = ork_generate_boss_name(); }
    return _wb.boss;
}

/// @function ork_clan_name_exists
/// @description True if any Ork clan/warband ANYWHERE in the sector already carries this name — so a freshly
///              founded clan can be regenerated until it's unique (§16m: "no repeats unless spread by force").
/// @param {String} _name
/// @returns {Bool}
function ork_clan_name_exists(_name) {
    var _found = false;
    with (obj_star) {
        if (!variable_instance_exists(id, "p_ork_clan")) { continue; }
        for (var _p = 0; _p < array_length(p_ork_clan); _p++) {
            var _list = p_ork_clan[_p];
            if (!is_array(_list)) { continue; }
            for (var _w = 0; _w < array_length(_list); _w++) {
                if (is_struct(_list[_w]) && variable_struct_exists(_list[_w], "name") && (_list[_w].name == _name)) {
                    _found = true;
                }
            }
        }
    }
    return _found;
}

/// @function ork_new_warband
/// @description Build a WHOLLY UNIQUE clan (§16m): a procedural name checked unique across the sector, its OWN
///              generated warpaint colour + icon shape (so no two clans look alike), a Warboss, a starting
///              weight and a per-warband GROWTH rate. `kultur` is kept only as a HIDDEN fighting-style
///              archetype (comp bias / duel brawn / style text) — it is NO LONGER a canonical named clan and
///              is never shown to the player; passing -1 rolls a random one. Differing growth rates let a
///              small fast clan grow into a CHALLENGER; leadership changes only by DUEL (ork_grow_clans).
/// @param {Real} _kultur  hidden style archetype (0-5), or -1 to roll one
/// @param {Real} _weight
/// @returns {Struct}
function ork_new_warband(_kultur, _weight) {
    if (_kultur < 0) { _kultur = irandom(ork_clan_count() - 1); }
    var _name = ork_generate_warband_name(_kultur);
    repeat (6) { if (!ork_clan_name_exists(_name)) { break; } _name = ork_generate_warband_name(_kultur); }
    return {
        name: _name,
        boss: ork_generate_boss_name(),
        kultur: _kultur,                 // style archetype (roster bias / duel brawn / style body)
        kultur_name: ork_generate_kultur_name(),   // this clan's OWN generated kultur name (§16m)
        colour: ork_generate_clan_colour(),
        icon: irandom(ork_clan_count() - 1),
        weight: _weight,
        growth: 1.0 + random(0.14),      // 1.00 - 1.14 / turn, fixed per warband -> a challenger can outgrow the boss
        leads: false,
        joined: false,                   // has it submitted to the reigning Warlord's WAAAGH? (keeps its clan either way)
    };
}

/// @function planet_ork_clans
/// @description Safe read of a world's WARBAND list (each {name, kultur, weight, growth}). Lazily seeds one
///              the first time it is read on an infested world, and migrates the old 6-float clan-weight
///              format (pre-warband saves) by re-seeding. Returns an array of warband structs (may be empty).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Array<Struct>}
function planet_ork_clans(_star, _planet) {
    if (!variable_instance_exists(_star, "p_ork_clan")) { return []; }
    var _arr = _star.p_ork_clan;
    if ((_planet < 0) || (_planet >= array_length(_arr))) { return []; }
    var _wb = _arr[_planet];
    // Valid warband list = a non-empty array whose first element is a struct. Otherwise seed / migrate.
    var _valid = is_array(_wb) && (array_length(_wb) > 0) && is_struct(_wb[0]);
    if (!_valid) {
        var _pop = variable_instance_exists(_star, "p_race_pop") ? _star.p_race_pop[_planet][eFACTION.ORK] : 0;
        if (_pop > 0) { ork_seed_clans(_star, _planet); _wb = _star.p_ork_clan[_planet]; }
        else { return []; }
    }
    return _wb;
}

/// @function ork_seed_clans
/// @description Found a world's WAAAGH as a SINGLE PURE CLAN — one warband, one kultur (§16g). Ork worlds
///              start UNMIXED; clans only mix later, when WAAAGH fleets from other clans land on a shared
///              world (ork_add_landing_warband) or a mob breaks away (ork_grow_clans). Overwrites the slot.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function ork_seed_clans(_star, _planet) {
    if (!variable_instance_exists(_star, "p_ork_clan")) { return; }
    if ((_planet < 0) || (_planet >= array_length(_star.p_ork_clan))) { return; }
    var _founder = ork_new_warband(irandom(ork_clan_count() - 1), irandom_range(50, 70));   // the founding clan
    _founder.leads = true;                                                                  // its boss leads
    _star.p_ork_clan[_planet] = [ _founder ];                                                // pure — no mixing yet
}

/// @function ork_add_landing_warband
/// @description Mixing (§16g): a WAAAGH fleet lands its mob on a world that ALREADY hosts a WAAAGH — the
///              incoming mob is (preferably) a DIFFERENT clan, so the world's clans begin to MIX, seeding the
///              infighting a Behead can later exploit. A fresh world keeps its pure founding clan (handled by
///              the caller). Capped so the list stays small.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function ork_add_landing_warband(_star, _planet) {
    if (!variable_instance_exists(_star, "p_ork_clan")) { return; }
    var _wb = planet_ork_clans(_star, _planet);   // lazy-seeds a pure founder if the world was empty
    if (array_length(_wb) == 0) { return; }
    if (array_length(_wb) >= 5) { return; }        // already a crowded WAAAGH
    // A different WAAAGH lands its mob — a wholly NEW UNIQUE clan joins the pot (§16m), seeding the infighting
    // a Behead can later exploit. Its hidden style archetype is rolled inside ork_new_warband (-1); clans are
    // unique by name + colour, so styles may freely repeat.
    array_push(_wb, ork_new_warband(-1, irandom_range(20, 40)));
}

/// @function ork_leading_warband_index
/// @description Index of the warband that CURRENTLY LEADS the WAAAGH — the one flagged `leads` (the reigning
///              boss, set by duels), NOT merely the biggest. Self-heals old/seeded data with no flag by
///              crowning the biggest. -1 if there are no warbands.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function ork_leading_warband_index(_star, _planet) {
    var _wb = planet_ork_clans(_star, _planet);
    if (array_length(_wb) == 0) { return -1; }
    for (var i = 0; i < array_length(_wb); i++) {
        if (variable_struct_exists(_wb[i], "leads") && _wb[i].leads) { return i; }
    }
    // No reigning boss recorded (migration / pre-duel data) — the biggest warband takes the WAAAGH.
    var _best = 0, _bestv = -1;
    for (var i = 0; i < array_length(_wb); i++) {
        if (_wb[i].weight > _bestv) { _bestv = _wb[i].weight; _best = i; }
    }
    _wb[_best].leads = true;
    return _best;
}

/// @function ork_leading_warband
/// @description The leading warband struct, or a default Goff warband if the world has none.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Struct}
function ork_leading_warband(_star, _planet) {
    var _wb = planet_ork_clans(_star, _planet);
    var _i = ork_leading_warband_index(_star, _planet);
    if (_i < 0) { return { name: "Da Boyz", kultur: 0, weight: 1, growth: 1 }; }
    return _wb[_i];
}

/// @function ork_leading_clan
/// @description The leading warband's KULTUR (0-5) — used for the roster bias (ork_clan_mult). Default Goffs.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function ork_leading_clan(_star, _planet) {
    return ork_leading_warband(_star, _planet).kultur;
}

/// @function ork_leading_name
/// @description The leading warband's procedural NAME (for display), e.g. "Da Red Speed Freeks".
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {String}
function ork_leading_name(_star, _planet) {
    return ork_leading_warband(_star, _planet).name;
}

/// @function ork_clan_summary
/// @description "Da Red Racers (Evil Sunz), with Gorznak's Lootaz (Deathskulls)" — the leading warband and
///              its kultur, then the minor warbands riding with it.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {String}
function ork_clan_summary(_star, _planet) {
    var _wb = planet_ork_clans(_star, _planet);
    if (array_length(_wb) == 0) { return "Freebooterz"; }
    var _lead = ork_leading_warband_index(_star, _planet);
    var _s = _wb[_lead].name + " under Warboss " + ork_wb_boss(_wb[_lead]);
    var _others = "";
    for (var i = 0; i < array_length(_wb); i++) {
        if (i != _lead) {
            _others += (_others == "" ? "" : ", ") + _wb[i].name;
        }
    }
    return _s + ((_others == "") ? "" : (", with " + _others));
}

/// @function ork_grow_clans
/// @description DYNAMIC clan leadership by DUEL (§16e). Every warband grows by its own fixed rate each turn.
///              Leadership does NOT pass on size alone: when a non-leader warband grows to CONTESTING size
///              (>= 90% of the reigning boss's mob), its Warboss throws down a leadership challenge, settled
///              by a duel between the two bosses — power = mob size x kultur brawn, so the bigger/harder boss
///              is favoured but upsets happen ("might makes right… unless a kunnin' git wins"). The winner
///              takes/holds the WAAAGH and some of the loser's boyz fall in behind him. Announced in the
///              event log. Occasionally a splinter mob muscles in. Called each turn per bloomed world from
///              end_turn_race_population_growth.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function ork_grow_clans(_star, _planet) {
    var _wb = planet_ork_clans(_star, _planet);
    if (array_length(_wb) == 0) { return; }

    // Grow every warband by its own rate.
    var _maxw = 0;
    for (var i = 0; i < array_length(_wb); i++) {
        _wb[i].weight = _wb[i].weight * _wb[i].growth;
        if (_wb[i].weight > _maxw) { _maxw = _wb[i].weight; }
    }
    // A mob occasionally BREAKS AWAY — a new warband forms with its own boss, procedural name and clan
    // (§16g). Capped so the list stays small; announced on a sizeable WAAAGH.
    if ((array_length(_wb) < 5) && (irandom(199) < 2)) {
        var _break = ork_new_warband(irandom(ork_clan_count() - 1), max(4, _maxw * 0.05));
        array_push(_wb, _break);
        var _bpop = variable_instance_exists(_star, "p_race_pop") ? _star.p_race_pop[_planet][eFACTION.ORK] : 0;
        if (_bpop > 250000) {
            var _bpd = _star.get_planet_data(_planet);
            scr_event_log("red", $"A breakaway mob — {_break.name} under Warboss {ork_wb_boss(_break)} — splits off on {_bpd.name()}.", _star.name);
        }
    }
    // Keep the numbers sane over a long game — only RELATIVE sizes matter.
    if (_maxw > 1000000000) {
        for (var i = 0; i < array_length(_wb); i++) { _wb[i].weight = _wb[i].weight / 1000000; }
    }

    // DUEL or JOIN (§16g, lore): a WAAAGH is a COALITION — beaten warbands do NOT vanish or change clan (an
    // ork's loyalty is to his warband, and clans keep their identity even united). Each turn, a boss forced to
    // choose either SUBMITS (bends the knee to the reigning Warlord, if clearly outmatched — < 25% of the boss)
    // or DUELS (if he's grown strong enough — the challenge block below). A submitted warband keeps its clan,
    // name, boss, weight and icon; it just stops contesting until it regrows past ~90% of the boss and rises
    // up again. So a mixed world unifies UNDER one Warlord without any clan being erased.
    var _cj_lead = ork_leading_warband_index(_star, _planet);
    if (_cj_lead >= 0) {
        var _cj_leader = _wb[_cj_lead];
        _cj_leader.joined = false;   // the reigning Warlord is never "sworn" to anyone
        for (var i = 0; i < array_length(_wb); i++) {
            if (i == _cj_lead) { continue; }
            var _wj = _wb[i];
            var _is_joined = variable_struct_exists(_wj, "joined") && _wj.joined;
            if (!_is_joined && (_wj.weight < _cj_leader.weight * 0.25)) {
                _wj.joined = true;    // bends the knee — submits to the WAAAGH, still its own clan
                var _jpop = variable_instance_exists(_star, "p_race_pop") ? _star.p_race_pop[_planet][eFACTION.ORK] : 0;
                if (_jpop > 250000) {
                    var _jpd = _star.get_planet_data(_planet);
                    scr_event_log("red", $"Warboss {ork_wb_boss(_wj)} of {_wj.name} bends the knee and joins the WAAAGH under Warboss {ork_wb_boss(_cj_leader)} on {_jpd.name()}.", _star.name);
                }
            } else if (_is_joined && (_wj.weight >= _cj_leader.weight * 0.9)) {
                _wj.joined = false;   // grown strong again — no longer sworn; it will DUEL for the WAAAGH below
            }
        }
    }

    // Who reigns, and is there a contender big enough to challenge?
    var _lead_i = ork_leading_warband_index(_star, _planet);
    if (_lead_i < 0) { return; }
    var _leader = _wb[_lead_i];
    var _chal_i = -1, _chal_w = -1;
    for (var i = 0; i < array_length(_wb); i++) {
        if (i == _lead_i) { continue; }
        if ((_wb[i].weight >= _leader.weight * 0.9) && (_wb[i].weight > _chal_w)) { _chal_w = _wb[i].weight; _chal_i = i; }
    }
    if (_chal_i < 0) { return; }                       // no one dares — the boss's grip holds

    // Settle the challenge with a DUEL between the two Warbosses (announced on a sizeable WAAAGH).
    var _pop = variable_instance_exists(_star, "p_race_pop") ? _star.p_race_pop[_planet][eFACTION.ORK] : 0;
    ork_resolve_duel(_star, _planet, _lead_i, _chal_i, (_pop > 250000));
}

/// @function ork_resolve_duel
/// @description Resolve a single leadership DUEL between the reigning boss (_lead_i) and a challenger
///              (_chal_i). Win chance ∝ boss power (mob size × kultur brawn) — the bigger/harder boss is
///              favoured, but upsets happen. Duels are fights to the DEATH (canon): the loser normally dies
///              and the victor takes over (deposed boss ~90%, failed challenger ~82% unless the boss is
///              generous). The beaten mob folds into the victor. Optionally announces. Returns a result
///              struct. Used for the natural leadership challenges in ork_grow_clans. (A boss killed by a
///              NON-duel source instead goes through ork_succession_crisis — there is no clear heir.)
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _lead_i    reigning warband index
/// @param {Real} _chal_i    challenger warband index
/// @param {Bool} _announce  log the outcome to the event log
/// @returns {Struct|Undefined}
function ork_resolve_duel(_star, _planet, _lead_i, _chal_i, _announce) {
    var _wb = planet_ork_clans(_star, _planet);
    if ((_lead_i < 0) || (_chal_i < 0) || (_lead_i >= array_length(_wb)) || (_chal_i >= array_length(_wb))) { return undefined; }
    var _leader = _wb[_lead_i];
    var _chal   = _wb[_chal_i];
    var _lp = _leader.weight * ork_kultur_duel_mult(_leader.kultur);
    var _cp = _chal.weight   * ork_kultur_duel_mult(_chal.kultur);
    var _chal_wins = (random(_lp + _cp) < _cp);

    var _victor = _chal_wins ? _chal : _leader;
    var _loser  = _chal_wins ? _leader : _chal;
    var _victor_boss = ork_wb_boss(_victor);
    var _victor_name = _victor.name;
    var _loser_boss  = ork_wb_boss(_loser);
    // Ork leadership duels are fights to the DEATH (lore) — the loser normally dies and the victor takes the
    // WAAAGH. A deposed boss almost always dies (~90%); a failed challenger usually dies too (~82%) unless the
    // reigning boss is feeling generous and krumps him into line instead (~18% — the exception, not the rule).
    var _loser_dies = _chal_wins ? (irandom(99) < 90) : (irandom(99) < 82);

    if (_chal_wins) { _leader.leads = false; _chal.leads = true; _chal.joined = false; }   // the WAAAGH changes hands

    // The beaten mob folds into the victor — nearly all of it if their boss was killed, less if he lived to
    // keep his (now-subordinate) boyz together.
    var _fold = _loser.weight * (_loser_dies ? 0.65 : (_chal_wins ? 0.30 : 0.25));
    _loser.weight  -= _fold;
    _victor.weight += _fold;
    if (_loser_dies) { _loser.boss = ork_generate_boss_name(); }     // a new git rises over the leaderless remnant

    var _pd = _star.get_planet_data(_planet);
    var _where = _pd.name();
    if (_announce) {
        if (_chal_wins && _loser_dies) {
            scr_event_log("red", $"Warboss {_victor_boss} of {_victor_name} has SLAIN Warboss {_loser_boss} in a duel and taken the WAAAGH on {_where}.", _star.name);
        } else if (_chal_wins) {
            scr_event_log("red", $"Warboss {_victor_boss} of {_victor_name} beat Warboss {_loser_boss} and seized the WAAAGH on {_where}; the broken boss slinks off to nurse his wounds.", _star.name);
        } else if (_loser_dies) {
            scr_event_log("red", $"Warboss {_victor_boss} killed the upstart Warboss {_loser_boss} on {_where}.", _star.name);
        } else {
            scr_event_log("red", $"Warboss {_victor_boss} beat the upstart Warboss {_loser_boss} on {_where} and — feeling generous — krumped him into line rather than killing him.", _star.name);
        }
    }
    return { challenger_won: _chal_wins, loser_died: _loser_dies, victor_boss: _victor_boss, victor_name: _victor_name, loser_boss: _loser_boss, where: _where };
}

/// @function ork_civil_war
/// @description A world's WAAAGH tears itself apart (§16f). The Ork population splits along its warbands'
///              hidden allegiances — each warband's share = its weight fraction, the aggregate of every
///              boy's clan tag — and the factions fight. Power = share × kultur brawn; the strongest wins and
///              unites the survivors. The population is GUTTED: the more evenly matched the split, the
///              bloodier (30-65% dead). Leaves the victor leading a bloodied, much-reduced WAAAGH. Returns a
///              result struct, or undefined if there is nothing to fracture.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Struct|Undefined}
function ork_civil_war(_star, _planet) {
    if (!variable_instance_exists(_star, "p_race_pop")) { return undefined; }
    var _wb = planet_ork_clans(_star, _planet);
    if (array_length(_wb) < 2) { return undefined; }
    var _pop = _star.p_race_pop[_planet][eFACTION.ORK];
    if (_pop <= 0) { return undefined; }

    var _tot_w = 0;
    for (var i = 0; i < array_length(_wb); i++) { _tot_w += _wb[i].weight; }
    if (_tot_w <= 0) { return undefined; }

    // Strongest faction (share × kultur brawn) wins; track the biggest raw share for the bloodiness calc.
    var _win_i = 0, _win_p = -1, _top_share = 0;
    for (var i = 0; i < array_length(_wb); i++) {
        var _share = _wb[i].weight / _tot_w;
        if (_share > _top_share) { _top_share = _share; }
        var _pw = _share * ork_kultur_duel_mult(_wb[i].kultur);
        if (_pw > _win_p) { _win_p = _pw; _win_i = i; }
    }

    // Bloodier the more evenly matched the sides are (an even split = a slaughter).
    var _cas = clamp(0.30 + (1 - _top_share) * 0.40, 0.30, 0.65);
    var _new_pop = max(1, round(_pop * (1 - _cas)));
    _star.p_race_pop[_planet][eFACTION.ORK] = _new_pop;
    if (variable_instance_exists(_star, "p_orks")) { _star.p_orks[_planet] = count_to_level(eFACTION.ORK, _new_pop); }

    // The victor unites the survivors; the losing warbands are crushed and THEIR bosses die in the fighting
    // (fights to the death) — a new git leads each battered remnant.
    var _winner = _wb[_win_i];
    for (var i = 0; i < array_length(_wb); i++) {
        _wb[i].leads = (i == _win_i);
        if (i != _win_i) {
            _wb[i].weight = _wb[i].weight * 0.2;
            _wb[i].boss = ork_generate_boss_name();
        }
    }

    var _pd = _star.get_planet_data(_planet);
    return { winner_name: _winner.name, winner_boss: ork_wb_boss(_winner), kultur: _winner.kultur, losses: _cas, where: _pd.name() };
}

/// @function ork_succession_crisis
/// @description The reigning WAAAGH boss has been killed by a NON-DUEL source (a strike, bombardment, the
///              fighting) — so there is no duel-victor to inherit (§16f). Leadership goes vacant and the
///              warbands scramble: if one clearly dominates, its boss brutally restores order and takes the
///              WAAAGH (a brief, bloody scramble); if the succession is contested (no boss far above the
///              rest), the WAAAGH tears itself apart in a CIVIL WAR along its allegiance lines. Announces and
///              returns { kind, text }.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {String} _cause  short flavour for the log (e.g. "your strike force", "orbital bombardment")
/// @returns {Struct}
function ork_succession_crisis(_star, _planet, _cause) {
    var _wb = planet_ork_clans(_star, _planet);
    var _pd = _star.get_planet_data(_planet);
    var _where = _pd.name();
    if (array_length(_wb) == 0) { return { kind: "none", text: "" }; }

    // The dead boss's warband (the former leader) loses its boss; leadership is now vacant.
    var _dead_i = ork_leading_warband_index(_star, _planet);
    for (var i = 0; i < array_length(_wb); i++) { _wb[i].leads = false; }
    if (_dead_i >= 0) { _wb[_dead_i].boss = ork_generate_boss_name(); }   // a new git rises in the beheaded warband

    // Only one warband: its new git simply seizes the WAAAGH (a brief scramble, no civil war).
    if (array_length(_wb) < 2) {
        _wb[0].leads = true;
        scr_event_log("red", $"The Warboss on {_where} is dead; {ork_wb_boss(_wb[0])} of {_wb[0].name} beats the rest into line and seizes the WAAAGH.", _star.name);
        return { kind: "scramble", text: "With the Warboss dead and no rival mob to fight over the spoils, " + ork_wb_boss(_wb[0]) + " of " + _wb[0].name + " brutally restores order and takes the WAAAGH." };
    }

    // How contested is the succession? Find the biggest warband and its share.
    var _tot_w = 0;
    for (var i = 0; i < array_length(_wb); i++) { _tot_w += _wb[i].weight; }
    var _top_i = 0, _top_w = -1;
    for (var i = 0; i < array_length(_wb); i++) {
        if (_wb[i].weight > _top_w) { _top_w = _wb[i].weight; _top_i = i; }
    }
    var _top_share = (_tot_w > 0) ? (_top_w / _tot_w) : 1;

    if (_top_share >= 0.55) {
        // Clear successor: the biggest boss krumps the rest into line — a brief, bloody scramble.
        _wb[_top_i].leads = true;
        if (variable_instance_exists(_star, "p_race_pop")) {
            _star.p_race_pop[_planet][eFACTION.ORK] = max(1, round(_star.p_race_pop[_planet][eFACTION.ORK] * 0.9));
            _star.p_orks[_planet] = count_to_level(eFACTION.ORK, _star.p_race_pop[_planet][eFACTION.ORK]);
        }
        var _heir = ork_wb_boss(_wb[_top_i]);
        scr_event_log("red", $"The Warboss on {_where} is dead. After a bloody scramble, Warboss {_heir} of {_wb[_top_i].name} seizes the WAAAGH.", _star.name);
        return { kind: "scramble", text: "The Warboss is dead with no heir. After a brief, bloody scramble, Warboss " + _heir + " of " + _wb[_top_i].name + " krumps the rest into line and takes the WAAAGH on " + _where + "." };
    }

    // No clear heir -> the warbands fall on one another. CIVIL WAR (splits the population along allegiance).
    var _cw = ork_civil_war(_star, _planet);
    if (is_struct(_cw)) {
        var _pct = string(round(_cw.losses * 100));
        scr_event_log("red", $"The Warboss on {_where} is dead with no successor — the WAAAGH erupts into CIVIL WAR. Warboss {_cw.winner_boss} of {_cw.winner_name} claws to the top; the greenskins lose {_pct}% of their number.", _star.name);
        return { kind: "civil_war", text: "The Warboss is dead and no boss stands clearly above the rest — the WAAAGH tears itself apart in civil war on " + _where + "! Warboss " + _cw.winner_boss + " of " + _cw.winner_name + " claws to the top over the corpse-heaps, but the greenskins have lost " + _pct + "% of their strength." };
    }
    // Fallback: crown the biggest.
    _wb[_top_i].leads = true;
    return { kind: "scramble", text: "The Warboss is dead; the biggest boss seizes control amid the chaos on " + _where + "." };
}

/// @function ork_decapitation_strike
/// @description PLAYER decapitation raid (§16f): a strike force goes after the WAAAGH's Warboss. The chance to
///              reach and kill him is high but not certain, and lower on a fortified WAAAGH (Ork Stronghold
///              tier). On a KILL there is no duel-victor to inherit -> ork_succession_crisis (scramble or
///              civil war). On a miss the boss lives and the strike only bloodies the horde a little. Returns
///              { kind, text } for the popup and logs to the event log. Wired to the "Behead" planet action.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Struct}
function ork_decapitation_strike(_star, _planet) {
    var _wb = planet_ork_clans(_star, _planet);
    var _pd = _star.get_planet_data(_planet);
    var _where = _pd.name();
    var _lead_i = ork_leading_warband_index(_star, _planet);
    if ((array_length(_wb) == 0) || (_lead_i < 0)) {
        return { kind: "none", text: "There is no Ork Warboss on " + _where + " to strike at." };
    }
    var _boss = ork_wb_boss(_wb[_lead_i]);

    // High base chance; harder to reach the boss on a fortified WAAAGH (Ork Stronghold tier).
    var _kill_chance = 65;
    if (_pd.has_feature(eP_FEATURES.ORKSTRONGHOLD)) {
        var _sh = _pd.get_features(eP_FEATURES.ORKSTRONGHOLD)[0];
        _kill_chance -= floor(_sh.tier) * 5;
    }
    _kill_chance = clamp(_kill_chance, 30, 80);

    if (irandom(99) < _kill_chance) {
        // Convert the named Warboss into a death-shrine (as if slain in battle), then the clans scramble.
        if (_pd.has_feature(eP_FEATURES.ORKWARBOSS)) {
            var _wf = _pd.get_features(eP_FEATURES.ORKWARBOSS)[0];
            with (_wf) { kill_warboss(); }
        }
        var _sc = ork_succession_crisis(_star, _planet, "your strike force");
        return { kind: "killed", text: "Your strike force cuts its way to Warboss " + _boss + " and puts him down. " + _sc.text };
    }
    // Failed — the boss survives; the strike still bloodies the horde.
    if (variable_instance_exists(_star, "p_race_pop")) {
        _star.p_race_pop[_planet][eFACTION.ORK] = max(1, round(_star.p_race_pop[_planet][eFACTION.ORK] * 0.95));
        _star.p_orks[_planet] = count_to_level(eFACTION.ORK, _star.p_race_pop[_planet][eFACTION.ORK]);
    }
    scr_event_log("red", $"A decapitation strike against Warboss {_boss} on {_where} is beaten back.", _star.name);
    return { kind: "failed", text: "Your strike force fights through the greenskins but cannot reach Warboss " + _boss + " — he lives, and the WAAAGH roars on. The strike bloodied them, but the boss's grip holds." };
}

/// @function ork_maybe_behead
/// @description Roll a chance that a NON-DUEL source kills the reigning WAAAGH boss on a world, and if it
///              lands, fire the succession crisis (§16f). Called from the battle and bombardment paths so
///              combat and orbital fire — not only the player's strike — can behead a WAAAGH and set the clans
///              scrambling. (Duel deaths are NOT routed here — a duel already has a clear winner to inherit.)
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _chance   percent chance (0-100) the boss dies
/// @param {String} _cause  short flavour for the log
/// @returns {Bool} true if the boss was killed
function ork_maybe_behead(_star, _planet, _chance, _cause) {
    if (!variable_instance_exists(_star, "p_ork_clan")) { return false; }
    if (!variable_instance_exists(_star, "p_race_pop")) { return false; }
    if (_star.p_race_pop[_planet][eFACTION.ORK] <= 0) { return false; }
    var _wb = planet_ork_clans(_star, _planet);
    if (array_length(_wb) == 0) { return false; }
    if (irandom(99) < _chance) {
        ork_succession_crisis(_star, _planet, _cause);
        return true;
    }
    return false;
}

/// @function ork_cleanse_bloom
/// @description CLEANSE a world's Fungal Bloom (§16h): a promethium scour that torches the fungal ecosystem —
///              REMOVES the FUNGAL_BLOOM feature so it can no longer regrow — and burns ~80 % of the greenskin
///              horde with it. The fire is aimed at the fungus/greenskins, NOT the world's people — no populace
///              collateral. A big bloom leaves a (non-regrowing) remnant that a second Cleanse-by-Fire or a
///              ground assault finishes. Folded into the "Cleanse by Fire" purge. Returns { kind, text }.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Struct}
function ork_cleanse_bloom(_star, _planet) {
    var _pd = _star.get_planet_data(_planet);
    var _where = _pd.name();
    var _had_bloom = _pd.has_feature(eP_FEATURES.FUNGAL_BLOOM);
    var _pop0 = variable_instance_exists(_star, "p_race_pop") ? _star.p_race_pop[_planet][eFACTION.ORK] : 0;
    if (!_had_bloom && (_pop0 <= 0)) {
        return { kind: "none", text: "There is no Fungal Bloom on " + _where + " to scour." };
    }

    // Torch the spore-bed — the fungal ecosystem burns out and can no longer regrow the horde.
    if (_had_bloom) { _pd.delete_feature(eP_FEATURES.FUNGAL_BLOOM); }

    // Burn most of the greenskin horde with it.
    var _remnant = 0;
    if (variable_instance_exists(_star, "p_race_pop")) {
        _remnant = round(_pop0 * 0.20);
        _star.p_race_pop[_planet][eFACTION.ORK] = _remnant;
        _star.p_orks[_planet] = count_to_level(eFACTION.ORK, _remnant);
    }

    // The fire is aimed at the FUNGUS and the greenskins, not the world's people — no populace collateral.

    // If the horde is essentially gone, the WAAAGH is scoured — clear its warbands (no clans left here).
    if ((_remnant <= 0) && variable_instance_exists(_star, "p_ork_clan") && (_planet < array_length(_star.p_ork_clan))) {
        _star.p_ork_clan[_planet] = [];
    }

    scr_event_log("green", $"Promethium fire scours the Fungal Bloom on {_where}; the spore-fields burn.", _star.name);
    var _txt = "Your fleet rains promethium on the spore-fields of " + _where + ". The Fungal Bloom is burned out";
    if (_remnant > 0) {
        _txt += " and most of the WAAAGH with it — a dwindling remnant of " + string(scr_display_number(_remnant)) + " greenskins is left to mop up (they can no longer regrow).";
    } else {
        _txt += ", and the last of the greenskins scoured from the world.";
    }
    return { kind: "cleansed", text: _txt };
}

/// @function ork_clan_mult
/// @description Per-unit-line multiplier the leading clan applies to the roster — its kultur decides which
///              units the WAAAGH favours. Boyz stay the remainder, so clans that suppress vehicles field a
///              bigger boyz mob automatically. Returns 1 for anything a clan has no opinion on.
/// @param {Real} _clan   leading clan index (-1 = none)
/// @param {String} _key  unit-line key
/// @returns {Real}
function ork_clan_mult(_clan, _key) {
    switch (_clan) {
        case 0: // Goffs — the biggest, most warlike clan: a brutal melee mob, almost no machines
            switch (_key) {
                case "ard": return 1.6; case "nobz": return 1.6;
                case "bike": case "kopta": case "wagon": case "gunz": case "tank":
                case "dread": case "kans": case "bigmek": case "stompa": return 0.4;
            }
            break;
        case 1: // Bad Moons — richest clan, all the dakka: Flash Gitz, big gunz, Meks, Meganobz
            switch (_key) {
                case "gitz": return 3.0; case "gunz": return 2.2; case "bigmek": return 1.8;
                case "tank": return 1.7; case "mega": return 1.5;
                case "bike": case "kopta": return 0.7;
            }
            break;
        case 2: // Evil Sunz — speed freeks: bikes, koptas, trukks, wagons; little heavy stuff
            switch (_key) {
                case "bike": return 2.8; case "kopta": return 2.2;
                case "trukk": return 2.2; case "wagon": return 1.9;
                case "dread": case "kans": case "stompa": case "gunz": return 0.6;
            }
            break;
        case 3: // Deathskulls — looters & scavengers: salvaged walkers and looted armour
            switch (_key) {
                case "dread": return 2.0; case "kans": return 2.0;
                case "tank": return 1.6; case "gunz": return 1.4;
            }
            break;
        case 4: // Snakebites — old ways & beasts: tough boyz, lots of Weirdboyz, shun Mek machines
            switch (_key) {
                case "ard": return 1.6; case "nobz": return 1.3; case "weird": return 2.5;
                case "bike": case "kopta": case "wagon": case "gunz": case "tank":
                case "dread": case "kans": case "bigmek": case "stompa": return 0.35;
            }
            break;
        case 5: // Blood Axes — kunnin' gitz: Kommandos, scouts, looted gear, tactics
            switch (_key) {
                case "komm": return 3.2; case "kopta": return 1.5;
                case "tank": return 1.5; case "trukk": return 1.3;
            }
            break;
    }
    return 1;
}

/// @function ork_clan_style_body
/// @description The fighting-STYLE body text for a kultur archetype (0-5) — no clan-name prefix. Each unique
///              clan (§16m) has its OWN generated kultur name; this templates the style off one of the six
///              archetypes, so a clan reads as e.g. "Da Rusty Lootaz: notorious looters. …".
/// @param {Real} _clan  kultur archetype index (0-5)
/// @returns {String}
function ork_clan_style_body(_clan) {
    switch (_clan) {
        case 0: return "the biggest, most warlike sort. They want nothing but a good scrap up close — massed Boyz, 'Ardboyz and Nobz in a brutal melee, with little time for dakka or machines.";
        case 1: return "flush with teef, and it shows. All the dakka teef can buy — Flash Gitz, Mek Gunz, Big Meks and mega-armour, the biggest guns on the field.";
        case 2: return "speed freeks. Red wunz go fasta — everything on wheels and tracks, hurled forward in a screaming charge: warbikes, koptas, trukks and battlewagons.";
        case 3: return "notorious looters. Superstitious scavengers who daub their gear for luck and field salvaged walkers, Killa Kans and any looted tank or dakka they can nick from the foe.";
        case 4: return "the old ways. Feral, stubborn orks who cling to tradition, shun fancy Mek-work, and count more Weirdboyz among their tougher-than-nails mobs.";
        case 5: return "kunnin' gitz. The sneakiest sort — camo, ambushes, Kommandos, scouts and looted Imperial gear. Other orks reckon they're almost too tactical to be proper orks.";
        default: return "a mixed WAAAGH of no single way of fightin'.";
    }
}

/// @function ork_generate_kultur_name
/// @description A procedural ork clan-KULTUR name (§16m) — each unique clan invents its own kultur instead of
///              the six canonical ones, templated in flavour off an archetype. e.g. "Iron Fangz", "Death
///              Moonz", "Rusty Skullz". Purely a name; the fighting style comes from the archetype body.
/// @returns {String}
function ork_generate_kultur_name() {
    var _a = choose("Iron","Death","Blood","Green","Red","Black","Deff","Gore","Rusty","Mad","Skull","Big","Broke","Bad","Krump","Boar","Moon","Snaggle","Spiky","Burnin'","Screamin'");
    var _b = choose("Moonz","Sunz","Skullz","Axes","Fangz","Tuskz","Klawz","Gitz","Boyz","Krushaz","Snaggas","Gorerz","Wreckaz","Bashaz","Stompaz","Lootaz","Burnaz");
    return _a + " " + _b;
}

/// @function ork_clan_style_desc
/// @description A clan's preferred way of fighting for the Forces panel (§16g/§16m): "<clan kultur>: <style>".
///              Leads with the clan's OWN generated kultur name (falls back to a canonical name for old saves).
/// @param {Real} _clan   kultur archetype index (0-5)
/// @param {String} [_kultur_name]  the clan's generated kultur name
/// @returns {String}
function ork_clan_style_desc(_clan, _kultur_name = "") {
    var _name = (_kultur_name != "") ? _kultur_name : ork_clan_name(_clan);
    return _name + ": " + ork_clan_style_body(_clan);
}

/// @function ork_sync_stronghold
/// @description Keep a world's ORK STRONGHOLD in step with its Fungal Bloom (§16e). The Orks can only BUILD
///              their structures on a world they actually HOLD (owner == ORK) — so while it's owned, a
///              Stronghold rises on the capital region (a built structure) + the ORKSTRONGHOLD feature, and
///              its tier creeps up SLOWLY with occupation (planet_infra_turns, which resets on capture).
///              When the greenskins are gone the Stronghold rots and is removed. Drives Mek-gating,
///              bombardment protection, and display. Called each turn from ork_world_tick.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function ork_sync_stronghold(_star, _planet) {
    var _pd = _star.get_planet_data(_planet);
    var _pop = variable_instance_exists(_star, "p_race_pop") ? _star.p_race_pop[_planet][eFACTION.ORK] : 0;
    var _owns = (_star.p_owner[_planet] == eFACTION.ORK);

    if (_owns && (_pop > 0)) {
        if (!_pd.has_feature(eP_FEATURES.ORKSTRONGHOLD)) { _pd.add_feature(eP_FEATURES.ORKSTRONGHOLD); }
        var _sh = _pd.get_features(eP_FEATURES.ORKSTRONGHOLD)[0];
        // Slow tier-up with how long/developed the Orks have held it (cap ~5). Resets with infra on capture.
        var _target = 1 + clamp(planet_infra_turns(_star, _planet) / 20, 0, 4);
        if (_sh.tier < _target) { _sh.tier = min(_target, _sh.tier + 0.05); }
        // Represent it as a built structure on the capital region so it shows in the region readout.
        var _cap = planet_capital_region(_star, _planet);
        region_buildings_ensure(_cap);
        if (region_building_count(_cap, "ork_stronghold") == 0) { array_push(_cap.buildings, "ork_stronghold"); }
    } else if (_pop <= 0) {
        // Greenskins gone — the fortress is pulled apart from within.
        if (_pd.has_feature(eP_FEATURES.ORKSTRONGHOLD)) {
            var _sh2 = _pd.get_features(eP_FEATURES.ORKSTRONGHOLD)[0];
            _sh2.tier -= 0.05;
            if (_sh2.tier <= 0) {
                _pd.delete_feature(eP_FEATURES.ORKSTRONGHOLD);
                region_building_remove(planet_capital_region(_star, _planet), "ork_stronghold");
            }
        }
    }
}

/// @function region_building_remove
/// @description Remove all copies of a building id from a region's building list.
/// @param {Struct.Region} _region
/// @param {String} _id
/// @returns {Undefined}
function region_building_remove(_region, _id) {
    region_buildings_ensure(_region);
    var _kept = [];
    for (var i = 0, l = array_length(_region.buildings); i < l; i++) {
        if (_region.buildings[i] != _id) { array_push(_kept, _region.buildings[i]); }
    }
    _region.buildings = _kept;
}

/// @function ork_composition
/// @description Ork force RECRUITED from a headcount, gated by infrastructure (§14) and flavoured by the
///              world's leading CLAN (§16e). **Basics** (Boyz shoota+choppa, 'Ardboyz, Gretchin, Nobz,
///              Kommandos, Weirdboy) come straight from the population — Boyz are the bulk (the remainder).
///              **Mek-built tiers** unlock as the world develops (8 turns/tier) AND ramp in over the
///              following turns, so they arrive gradually — no sudden boom. Tier 1 = buggies/mega-armour,
///              2 = walkers/wagons/big gunz, 3 = Stompa. No Warboss (apex, §7).
/// @param {Real} _p            total Ork headcount
/// @param {Real} _infra_turns  turns the world has been developed (planet_infra_turns)
/// @param {Real} _clan         leading clan index that flavours the roster (-1 = no clan bias)
/// @returns {Array<Struct>} [{label, count}, ...]
function ork_composition(_p, _infra_turns, _clan = -1) {
    if (_p <= 0) {
        return [];
    }
    // Structure tier-up: as long as the Orks HOLD the world, the Meks slowly raise their works, unlocking
    // heavier units. Deliberately SLOW — a fresh bloom fields only basics; light Mek comes at ~15 turns,
    // heavy Mek workshops at ~45, and the gargant-works (Stompas) only after ~85 turns of occupation. Each
    // ramps in over its window so there is no sudden boom. (infra_turns = turns the owner has held it.)
    var _r1 = clamp((_infra_turns - 15) / 12, 0, 1);   // light Mek — buggies/koptas
    var _r2 = clamp((_infra_turns - 45) / 18, 0, 1);   // heavy Mek — walkers/wagons/big gunz/elites
    var _r3 = clamp((_infra_turns - 85) / 20, 0, 1);   // gargant-works — the Stompa
    // Mek PRODUCTION multiplier: once the heavy works stand, the longer the Orks are left, the more the
    // Mekworks churn out — a SLOW climb to a nightmare. "God help the player if left alone."
    var _prod = 1 + clamp((_infra_turns - 105) / 35, 0, 15);

    // Basics (tier 0) — recruited straight from the population. Boyz are the bulk (the remainder).
    var _ard   = (_p >= 150)   ? round(_p * 0.10) : 0;
    var _grot  = (_p >= 1500)  ? round(_p * 0.25) : 0;
    var _nobz  = max(1, round(_p / 100));
    var _komm  = (_p >= 1000)  ? round(_p / 500)  : 0;
    var _weird = (_p >= 40000) ? round(_p / 80000) : 0;    // Weirdboyz — RARE psykers, a handful
    // Tier 0 also — Trukks are basic mob transport; the boyz ride to war from the off (no ramp).
    var _trukk = round(_p / 300);
    // Tier 1 — light Mek (fast buggies, koptas — the Meks' first builds).
    var _bike  = round((_p / 1000) * _r1);
    var _kopta = round((_p / 2000) * _r1);
    // Tier 2 — heavy Mek + rare elites (mega-armour, flash gitz), SCALED by Mek production: rare at the
    // initial spawn, terrifying once the workshops are built up over a long occupation.
    var _mega   = round(((_p >= 800)   ? _p / 6000  : 0) * _r2 * _prod);
    var _gitz   = round(((_p >= 800)   ? _p / 1200  : 0) * _r2 * _prod);
    var _dread  = round((_p / 3500) * _r2 * _prod);
    var _kans   = round((_p / 2500) * _r2 * _prod);
    var _wagon  = round((_p / 3500) * _r2 * _prod);
    var _gunz   = round((_p / 3500) * _r2 * _prod);
    var _tank   = round(((_p >= 3000)  ? _p / 1800  : 0) * _r2 * _prod);
    var _bigmek = round(((_p >= 20000) ? _p / 50000 : 0) * _r2 * _prod);   // Big Meks — notable characters
    // Tier 3 — the Stompa: titanic, a handful at first, multiplied by the Mekworks over a long occupation.
    var _stompa = round(((_p >= 300000) ? _p / 700000 : 0) * _r3 * _prod);

    // CLAN flavour (§16e): the leading clan's kultur skews which units the WAAAGH favours. Boyz remain the
    // remainder, so a clan that suppresses vehicles automatically fields a bigger boyz mob.
    if (_clan >= 0) {
        _ard    = round(_ard    * ork_clan_mult(_clan, "ard"));
        _grot   = round(_grot   * ork_clan_mult(_clan, "grot"));
        _nobz   = round(_nobz   * ork_clan_mult(_clan, "nobz"));
        _komm   = round(_komm   * ork_clan_mult(_clan, "komm"));
        _mega   = round(_mega   * ork_clan_mult(_clan, "mega"));
        _gitz   = round(_gitz   * ork_clan_mult(_clan, "gitz"));
        _trukk  = round(_trukk  * ork_clan_mult(_clan, "trukk"));
        _bike   = round(_bike   * ork_clan_mult(_clan, "bike"));
        _kopta  = round(_kopta  * ork_clan_mult(_clan, "kopta"));
        _dread  = round(_dread  * ork_clan_mult(_clan, "dread"));
        _kans   = round(_kans   * ork_clan_mult(_clan, "kans"));
        _wagon  = round(_wagon  * ork_clan_mult(_clan, "wagon"));
        _gunz   = round(_gunz   * ork_clan_mult(_clan, "gunz"));
        _tank   = round(_tank   * ork_clan_mult(_clan, "tank"));
        _bigmek = round(_bigmek * ork_clan_mult(_clan, "bigmek"));
        _stompa = round(_stompa * ork_clan_mult(_clan, "stompa"));
    }

    // Clan SIGNATURE unit — a distinct line the leading clan is famous for (§16g).
    var _squig = (_clan == 4) ? round(_p * 0.15) : 0;   // Snakebites — Squighog Boyz (beast riders on war-squigs)

    var _used = _ard + _grot + _nobz + _komm + _weird + _squig + _mega + _gitz + _trukk + _bike + _kopta + _dread + _kans + _wagon + _gunz + _tank + _bigmek + _stompa;
    var _boyz = max(1, _p - _used); // Boyz = the basic remainder — the fresh mob before the Meks build up.

    var _lines = [{ label: "Boyz", count: _boyz }];
    if (_ard > 0)    array_push(_lines, { label: "'Ardboyz", count: _ard });
    if (_grot > 0)   array_push(_lines, { label: "Gretchin", count: _grot });
    array_push(_lines, { label: "Nobz", count: _nobz });
    if (_komm > 0)   array_push(_lines, { label: "Kommandos", count: _komm });
    if (_weird > 0)  array_push(_lines, { label: "Weirdboy", count: _weird });
    if (_squig > 0)  array_push(_lines, { label: "Squighog Boyz", count: _squig });
    if (_mega > 0)   array_push(_lines, { label: "Meganobz", count: _mega });
    if (_gitz > 0)   array_push(_lines, { label: "Flash Gitz", count: _gitz });
    if (_trukk > 0)  array_push(_lines, { label: "Trukk", count: _trukk });
    if (_bike > 0)   array_push(_lines, { label: "Warbikers", count: _bike });
    if (_kopta > 0)  array_push(_lines, { label: "Deffkopta", count: _kopta });
    if (_dread > 0)  array_push(_lines, { label: "Deff Dread", count: _dread });
    if (_kans > 0)   array_push(_lines, { label: "Killa Kans", count: _kans });
    if (_wagon > 0)  array_push(_lines, { label: "Battlewagon", count: _wagon });
    if (_gunz > 0)   array_push(_lines, { label: "Mek Gunz", count: _gunz });
    if (_tank > 0)   array_push(_lines, { label: "Tankbustas", count: _tank });
    if (_bigmek > 0) array_push(_lines, { label: "Big Mek", count: _bigmek });
    if (_stompa > 0) array_push(_lines, { label: "Stompa", count: _stompa });
    return _lines;
}

/// @function faction_infra_gates
/// @description Per-faction tuning for the time-gated tier ramp (§14). Returns the turn each tier
///              UNLOCKS (t1/t2/t3) and the ramp width w (turns from unlock to full strength). Tuned to
///              lore: Necrons awaken fast, Eldar are slow and deliberate, Chaos legions arrive already
///              armed and daemons manifest with the incursion (near-instant), the rest are steady
///              builders. Every gate finishes by infra=32 so pre-developed worlds field their full
///              roster. See planet_infra_turns / faction_unit_tier.
/// @param {Real} _faction  eFACTION value
/// @returns {Struct} { t1, t2, t3, w }
function faction_infra_gates(_faction) {
    switch (_faction) {
        case eFACTION.NECRONS:      return { t1: 4,  t2: 10, t3: 18, w: 6 }; // awaken from the tomb — fast
        case eFACTION.TYRANIDS:     return { t1: 6,  t2: 14, t3: 22, w: 8 }; // grow biomass; monsters last
        case eFACTION.ELDAR:        return { t1: 10, t2: 18, t3: 24, w: 8 }; // rare, slow, deliberate
        case eFACTION.TAU:          return { t1: 8,  t2: 16, t3: 24, w: 8 }; // Earth caste — steady
        case eFACTION.ECCLESIARCHY: return { t1: 8,  t2: 16, t3: 22, w: 8 }; // convent musters steadily
        case eFACTION.HERETICS:     return { t1: 6,  t2: 14, t3: 20, w: 8 }; // cult swells, loots armour
        case eFACTION.CHAOS:        return { t1: 0,  t2: 4,  t3: 10, w: 6 }; // legion ARRIVES pre-armed
        case eFACTION.GENESTEALER:  return { t1: 0,  t2: 4,  t3: 10, w: 6 }; // daemons manifest w/ incursion
        default:                    return { t1: 8,  t2: 16, t3: 24, w: 8 };
    }
}

/// @function faction_unit_tier
/// @description The infrastructure TIER a unit type sits in (0 = basic/immediate, 1 = elite/light,
///              2 = heavy/vehicle/monster, 3 = apex/war-engine). Basics are unlisted and default to 0
///              so they always field; higher tiers ramp in per faction_infra_gates as the world
///              develops (§14). Built once as a per-faction label->tier map.
/// @param {Real} _faction  eFACTION value
/// @param {String} _label  unit label as it appears in the ladder table
/// @returns {Real} 0-3
function faction_unit_tier(_faction, _label) {
    static _map = undefined;
    if (_map == undefined) {
        _map = {};
        var _add = function(_m, _fac, _tier, _labels) {
            var _key = string(_fac);
            var _s = variable_struct_exists(_m, _key) ? _m[$ _key] : {};
            for (var _i = 0; _i < array_length(_labels); _i++) {
                _s[$ _labels[_i]] = _tier;
            }
            _m[$ _key] = _s;
        };

        // T'au — battlesuits/skimmers ramp in behind the Fire caste line.
        _add(_map, eFACTION.TAU, 1, ["XV25 Stealthsuit", "XV8 Crisis", "XV8 Commander", "XV88 Broadside", "Sniper Drone", "Devilfish", "Piranha"]);
        _add(_map, eFACTION.TAU, 2, ["XV95 Ghostkeel", "Hammerhead", "Sky Ray", "Razorshark", "Sun Shark"]);
        _add(_map, eFACTION.TAU, 3, ["XV104 Riptide", "KV128 Stormsurge"]);

        // Tyranids — bio-elites, then beasts, then the largest monsters last.
        _add(_map, eFACTION.TYRANIDS, 1, ["Aberrant", "Achilles Ridgerunner", "Goliath Truck", "Goliath Rockgrinder", "Abominant", "Biophagus", "Locus", "Tyranid Warrior", "Hive Guard", "Zoanthrope", "Venomthrope", "Lictor", "Ravener", "Tyrant Guard", "Biovore"]);
        _add(_map, eFACTION.TYRANIDS, 2, ["Carnifex", "Trygon", "Mawloc", "Tervigon", "Exocrine", "Harpy", "Hive Crone", "Screamer-Killer", "Sporocyst", "Hive Tyrant", "Winged Hive Tyrant", "Broodlord", "Neurotyrant"]);
        _add(_map, eFACTION.TYRANIDS, 3, ["Maleceptor", "Haruspex", "Toxicrene", "Tyrannofex"]);

        // Necrons — destroyers/constructs, then arks/flyers, then apex war-engines.
        _add(_map, eFACTION.NECRONS, 1, ["Necron Destroyer", "Skorpekh Destroyer", "Lokhust Destroyer", "Ophydian Destroyer", "Hexmark Destroyer", "Lychguard", "Triarch Praetorian", "Canoptek Spyder", "Tomb Blade", "Canoptek Wraith", "Canoptek Reanimator"]);
        _add(_map, eFACTION.NECRONS, 2, ["Doomsday Ark", "Annihilation Barge", "Ghost Ark", "Triarch Stalker", "Canoptek Doomstalker", "Doom Scythe", "Night Scythe", "Tomb Stalker", "Lokhust Heavy Destroyer"]);
        _add(_map, eFACTION.NECRONS, 3, ["Monolith", "Tesseract Vault"]);

        // Aeldari — Aspect shrines/jetbikes, then Wraith constructs/grav-tanks/flyers, then titanic.
        _add(_map, eFACTION.ELDAR, 1, ["Striking Scorpion", "Howling Banshee", "Fire Dragon", "Warp Spider", "Swooping Hawk", "Dark Reaper", "Windrider", "Shining Spear", "Vyper"]);
        _add(_map, eFACTION.ELDAR, 2, ["War Walker", "Wraithguard", "Wraithblade", "Wraithlord", "Falcon", "Fire Prism", "Night Spinner", "Wave Serpent", "Crimson Hunter", "Hemlock Wraithfighter"]);
        _add(_map, eFACTION.ELDAR, 3, ["Wraithknight", "Phantom Titan"]);

        // Adepta Sororitas — flying/repentia orders, then engines/armour, then Exorcist/Paragon apex.
        _add(_map, eFACTION.ECCLESIARCHY, 1, ["Seraphim", "Zephyrim", "Retributor", "Celestian Sacresant", "Sisters Repentia", "Death Cult Assassin", "Sororitas Rhino"]);
        _add(_map, eFACTION.ECCLESIARCHY, 2, ["Immolator", "Penitent Engine", "Mortifier", "Anchorite", "Castigator"]);
        _add(_map, eFACTION.ECCLESIARCHY, 3, ["Exorcist", "Paragon Warsuit"]);

        // Chaos Space Marines — the legion arrives near fully armed (gates open early).
        _add(_map, eFACTION.CHAOS, 1, ["Possessed", "Chaos Biker", "Raptor", "Warp Talon", "Chaos Rhino", "Helbrute"]);
        _add(_map, eFACTION.CHAOS, 2, ["Defiler", "Forgefiend", "Maulerfiend", "Venomcrawler", "Vindicator", "Chaos Predator", "Chaos Terminator", "Heldrake"]);
        _add(_map, eFACTION.CHAOS, 3, ["Chaos Land Raider", "Daemon Prince"]);

        // Heretics — Blood Pact (elite drilled infantry, top of the tree) + technicals, then looted
        // armour, then the heavy tank and the rare Chaos Aspirant (the few Blood Pact ascending toward
        // the CSM legion — apex, so only well-developed, devout worlds field any).
        _add(_map, eFACTION.HERETICS, 1, ["Blood Pact", "Technical", "Sentinel"]);
        _add(_map, eFACTION.HERETICS, 2, ["Chimera", "Chaos Basilisk"]);
        _add(_map, eFACTION.HERETICS, 3, ["Chaos Leman Russ", "Chaos Aspirant"]);

        // Daemons (p_demons) — manifest with the incursion; greater daemons come last.
        _add(_map, eFACTION.GENESTEALER, 1, ["Flesh Hound", "Seeker", "Screamer", "Flamer", "Fiend", "Daemon Prince"]);
        _add(_map, eFACTION.GENESTEALER, 2, ["Bloodcrusher", "Plague Drone", "Beast of Nurgle", "Soul Grinder", "Skull Cannon", "Burning Chariot", "Seeker Chariot"]);
        _add(_map, eFACTION.GENESTEALER, 3, ["Greater Daemon"]);
    }

    var _fkey = string(_faction);
    if (!variable_struct_exists(_map, _fkey)) {
        return 0;
    }
    var _fs = _map[$ _fkey];
    return variable_struct_exists(_fs, _label) ? _fs[$ _label] : 0;
}

/// @function faction_ladder_composition
/// @description The units a faction fields at a given 0-6 strength level, mirrored (waves summed,
///              per-squad sub-leaders trimmed) from the obj_ncombat/Alarm_0 spawn ladder. Generic
///              units only, no named characters. Static data built once; tracks the combat tiers as
///              of 2026-07-10 (v1 — to be filled out with the current 40K primers per faction).
/// @param {Real} _faction  eFACTION value
/// @param {Real} _level    0-6
/// @returns {Array<Struct>} [{label, count}, ...]  (empty for level 0 / unmapped factions)
function faction_ladder_composition(_faction, _level, _infra_turns = 32) {
    if (_level < 1) {
        return [];
    }

    // Orks (pilot): the mob is RECRUITED from the population — Boyz basic + infrastructure-gated,
    // ramped Mek tiers — computed from the level's headcount, so it scales continuously and develops
    // over time. _infra_turns = how long the world has been built up. Others use the ladder table.
    if (_faction == eFACTION.ORK) {
        return ork_composition(level_to_count(eFACTION.ORK, _level), _infra_turns);
    }

    var _lv = clamp(floor(_level), 1, 6) - 1;

    static _tbl = undefined;
    if (_tbl == undefined) {
        _tbl = array_create(14, undefined);

        // Orks — full current (11th-ed codex) generic roster, no named characters. Boyz now carry
        // Shoota + Choppa (single Boyz datasheet). Heavier units unlock as the WAAAGH grows.
        _tbl[eFACTION.ORK] = [
            [["Boyz", 60], ["Gretchin", 25], ["Nobz", 5], ["Deffkopta", 3], ["Trukk", 2], ["Runtherd", 1]],
            [["Boyz", 150], ["'Ardboyz", 50], ["Gretchin", 60], ["Nobz", 12], ["Meganobz", 5], ["Kommandos", 15], ["Stormboyz", 20], ["Warbikers", 9], ["Deff Dread", 3], ["Killa Kans", 4], ["Trukk", 4], ["Mek", 1]],
            [["Boyz", 300], ["'Ardboyz", 150], ["Beast Snagga Boyz", 100], ["Gretchin", 150], ["Nobz", 20], ["Meganobz", 12], ["Kommandos", 25], ["Tankbustas", 20], ["Burna Boyz", 20], ["Lootas", 30], ["Stormboyz", 30], ["Squighog Boyz", 10], ["Deff Dread", 9], ["Killa Kans", 12], ["Battlewagon", 5], ["Trukk", 8], ["Deffkopta", 6], ["Warbikers", 12], ["Mek Gunz", 6], ["Big Mek", 1], ["Weirdboy", 1], ["Painboy", 1]],
            [["Boyz", 900], ["'Ardboyz", 300], ["Beast Snagga Boyz", 300], ["Gretchin", 800], ["Nobz", 60], ["Meganobz", 30], ["Kommandos", 40], ["Tankbustas", 30], ["Burna Boyz", 40], ["Lootas", 50], ["Flash Gitz", 20], ["Stormboyz", 60], ["Squighog Boyz", 20], ["Deff Dread", 21], ["Killa Kans", 18], ["Morkanaut", 2], ["Battlewagon", 12], ["Trukk", 20], ["Megatrakk Scrapjet", 6], ["Boomdakka Snazzwagon", 6], ["Deffkopta", 12], ["Warbikers", 20], ["Mek Gunz", 12], ["Dakkajet", 3], ["Big Mek", 2], ["Weirdboy", 2], ["Painboy", 2], ["Deffkilla Wartrike", 1]],
            [["Boyz", 1800], ["'Ardboyz", 600], ["Beast Snagga Boyz", 600], ["Gretchin", 2000], ["Nobz", 120], ["Meganobz", 80], ["Kommandos", 60], ["Tankbustas", 100], ["Burna Boyz", 80], ["Lootas", 80], ["Flash Gitz", 50], ["Stormboyz", 120], ["Squighog Boyz", 40], ["Deff Dread", 40], ["Killa Kans", 30], ["Morkanaut", 3], ["Gorkanaut", 3], ["Battlewagon", 18], ["Kill Rig", 6], ["Megatrakk Scrapjet", 10], ["Boomdakka Snazzwagon", 10], ["Deffkopta", 20], ["Warbikers", 30], ["Mek Gunz", 20], ["Dakkajet", 6], ["Burna-Bommer", 3], ["Big Mek", 4], ["Weirdboy", 3], ["Painboy", 3], ["Deffkilla Wartrike", 2], ["Stompa", 1]],
            [["Boyz", 3000], ["'Ardboyz", 1000], ["Beast Snagga Boyz", 1000], ["Gretchin", 4000], ["Nobz", 200], ["Meganobz", 120], ["Kommandos", 100], ["Tankbustas", 150], ["Burna Boyz", 150], ["Lootas", 150], ["Flash Gitz", 100], ["Stormboyz", 200], ["Squighog Boyz", 80], ["Deff Dread", 80], ["Killa Kans", 60], ["Morkanaut", 6], ["Gorkanaut", 6], ["Battlewagon", 36], ["Kill Rig", 12], ["Kill Tank", 4], ["Megatrakk Scrapjet", 20], ["Boomdakka Snazzwagon", 20], ["Deffkopta", 40], ["Warbikers", 60], ["Mek Gunz", 40], ["Dakkajet", 10], ["Burna-Bommer", 6], ["Blitza-Bommer", 6], ["Big Mek", 6], ["Weirdboy", 6], ["Painboy", 6], ["Deffkilla Wartrike", 3], ["Stompa", 2], ["Gargantuan Squiggoth", 1]],
        ];

        // T'au Empire — full current generic roster (Fire caste + Kroot + drones + battlesuits + armour).
        _tbl[eFACTION.TAU] = [
            [["Fire Warrior", 20], ["Kroot Carnivore", 15], ["XV8 Crisis", 1], ["Gun Drone", 4]],
            [["Fire Warrior", 80], ["Kroot Carnivore", 60], ["Pathfinder", 20], ["XV25 Stealthsuit", 6], ["XV8 Crisis", 6], ["XV8 Commander", 1], ["XV88 Broadside", 3], ["Vespid Stingwing", 8], ["Gun Drone", 12], ["Devilfish", 3], ["Hammerhead", 2]],
            [["Fire Warrior", 200], ["Kroot Carnivore", 120], ["Pathfinder", 40], ["XV25 Stealthsuit", 10], ["XV8 Crisis", 18], ["XV8 Commander", 1], ["XV88 Broadside", 6], ["XV95 Ghostkeel", 2], ["Vespid Stingwing", 20], ["Gun Drone", 30], ["Devilfish", 8], ["Hammerhead", 5], ["Piranha", 6], ["Ethereal", 1]],
            [["Fire Warrior", 800], ["Kroot Carnivore", 400], ["Krootox Rider", 20], ["Pathfinder", 60], ["XV25 Stealthsuit", 18], ["XV8 Crisis", 48], ["XV8 Commander", 2], ["XV88 Broadside", 12], ["XV95 Ghostkeel", 4], ["XV104 Riptide", 2], ["Vespid Stingwing", 40], ["Gun Drone", 60], ["Sniper Drone", 20], ["Devilfish", 15], ["Hammerhead", 20], ["Sky Ray", 4], ["Piranha", 10], ["Razorshark", 3], ["Ethereal", 1], ["Cadre Fireblade", 2]],
            [["Fire Warrior", 1600], ["Kroot Carnivore", 800], ["Krootox Rider", 40], ["Pathfinder", 120], ["XV25 Stealthsuit", 24], ["XV8 Crisis", 80], ["XV8 Commander", 2], ["XV88 Broadside", 24], ["XV95 Ghostkeel", 6], ["XV104 Riptide", 4], ["KV128 Stormsurge", 1], ["Vespid Stingwing", 60], ["Gun Drone", 100], ["Sniper Drone", 40], ["Devilfish", 30], ["Hammerhead", 30], ["Sky Ray", 6], ["Piranha", 16], ["Razorshark", 4], ["Sun Shark", 3], ["Ethereal", 2], ["Cadre Fireblade", 3], ["Firesight Marksman", 4]],
            [["Fire Warrior", 2500], ["Kroot Carnivore", 1300], ["Krootox Rider", 60], ["Pathfinder", 200], ["XV25 Stealthsuit", 30], ["XV8 Crisis", 120], ["XV8 Commander", 3], ["XV88 Broadside", 36], ["XV95 Ghostkeel", 9], ["XV104 Riptide", 6], ["KV128 Stormsurge", 2], ["Vespid Stingwing", 90], ["Gun Drone", 160], ["Sniper Drone", 60], ["Devilfish", 50], ["Hammerhead", 40], ["Sky Ray", 8], ["Piranha", 24], ["Razorshark", 6], ["Sun Shark", 6], ["Ethereal", 3], ["Cadre Fireblade", 4], ["Firesight Marksman", 6]],
        ];

        // Tyranids — cult reveal into the swarm (matches the game's escalation): L1-3 Genestealer
        // Cult, L4-6 full Tyranid invasion. Full current generic rosters, no named characters.
        _tbl[eFACTION.TYRANIDS] = [
            [["Neophyte Hybrid", 50], ["Acolyte Hybrid", 25], ["Purestrain Genestealer", 15], ["Atalan Jackal", 10], ["Primus", 1]],
            [["Neophyte Hybrid", 250], ["Acolyte Hybrid", 75], ["Hybrid Metamorph", 40], ["Aberrant", 30], ["Purestrain Genestealer", 40], ["Atalan Jackal", 40], ["Achilles Ridgerunner", 3], ["Goliath Truck", 5], ["Goliath Rockgrinder", 5], ["Magus", 1], ["Primus", 1], ["Kelermorph", 2], ["Sanctus", 1]],
            [["Neophyte Hybrid", 600], ["Acolyte Hybrid", 150], ["Hybrid Metamorph", 60], ["Aberrant", 60], ["Purestrain Genestealer", 100], ["Atalan Jackal", 60], ["Achilles Ridgerunner", 8], ["Goliath Truck", 16], ["Goliath Rockgrinder", 10], ["Magus", 3], ["Primus", 3], ["Abominant", 2], ["Biophagus", 2], ["Kelermorph", 3], ["Sanctus", 2], ["Locus", 3]],
            [["Termagant", 3000], ["Hormagaunt", 2000], ["Gargoyle", 400], ["Genestealer", 200], ["Tyranid Warrior", 130], ["Hive Guard", 20], ["Zoanthrope", 10], ["Venomthrope", 12], ["Lictor", 15], ["Ripper Swarm", 60], ["Ravener", 20], ["Tyrant Guard", 16], ["Hive Tyrant", 1], ["Broodlord", 2], ["Carnifex", 21], ["Biovore", 8], ["Trygon", 3], ["Mawloc", 3], ["Tervigon", 2], ["Exocrine", 3], ["Harpy", 3]],
            [["Termagant", 6600], ["Hormagaunt", 3200], ["Gargoyle", 800], ["Genestealer", 400], ["Tyranid Warrior", 200], ["Hive Guard", 40], ["Zoanthrope", 30], ["Venomthrope", 24], ["Lictor", 20], ["Ripper Swarm", 120], ["Ravener", 40], ["Tyrant Guard", 32], ["Hive Tyrant", 2], ["Winged Hive Tyrant", 1], ["Broodlord", 3], ["Carnifex", 50], ["Screamer-Killer", 6], ["Maleceptor", 2], ["Biovore", 16], ["Trygon", 6], ["Mawloc", 6], ["Tervigon", 4], ["Exocrine", 6], ["Tyrannofex", 4], ["Harpy", 6], ["Hive Crone", 4]],
            [["Termagant", 20000], ["Hormagaunt", 8000], ["Gargoyle", 2000], ["Genestealer", 800], ["Tyranid Warrior", 430], ["Hive Guard", 80], ["Zoanthrope", 60], ["Venomthrope", 40], ["Neurotyrant", 2], ["Lictor", 40], ["Ripper Swarm", 300], ["Ravener", 80], ["Tyrant Guard", 64], ["Hive Tyrant", 4], ["Winged Hive Tyrant", 2], ["Broodlord", 4], ["Carnifex", 85], ["Screamer-Killer", 12], ["Maleceptor", 4], ["Haruspex", 4], ["Biovore", 40], ["Trygon", 12], ["Mawloc", 12], ["Tervigon", 8], ["Exocrine", 12], ["Tyrannofex", 8], ["Toxicrene", 4], ["Harpy", 12], ["Hive Crone", 8], ["Sporocyst", 6]],
        ];

        // Necrons — full current generic roster (no named characters). Elite and few; reanimation
        // means the effective force outlasts the raw count. Heavier constructs wake at higher levels.
        _tbl[eFACTION.NECRONS] = [
            [["Necron Warrior", 10], ["Necron Destroyer", 1]],
            [["Necron Warrior", 40], ["Necron Immortal", 10], ["Necron Destroyer", 1], ["Canoptek Scarab", 20], ["Canoptek Spyder", 3], ["Tomb Blade", 3]],
            [["Necron Warrior", 100], ["Necron Immortal", 20], ["Deathmark", 10], ["Lychguard", 5], ["Necron Destroyer", 3], ["Skorpekh Destroyer", 3], ["Canoptek Scarab", 60], ["Canoptek Wraith", 6], ["Canoptek Spyder", 6], ["Tomb Blade", 6], ["Necron Overlord", 1], ["Cryptek", 1], ["Doomsday Ark", 2], ["Annihilation Barge", 2], ["Monolith", 1]],
            [["Necron Warrior", 250], ["Necron Immortal", 40], ["Deathmark", 20], ["Flayed One", 20], ["Lychguard", 10], ["Triarch Praetorian", 5], ["Necron Destroyer", 6], ["Skorpekh Destroyer", 6], ["Lokhust Destroyer", 6], ["Canoptek Scarab", 120], ["Canoptek Wraith", 12], ["Canoptek Spyder", 6], ["Tomb Blade", 10], ["Triarch Stalker", 2], ["Necron Overlord", 1], ["Cryptek", 2], ["Ghost Ark", 3], ["Doomsday Ark", 2], ["Annihilation Barge", 3], ["Monolith", 1], ["Doom Scythe", 2], ["Tomb Stalker", 1]],
            [["Necron Warrior", 600], ["Necron Immortal", 60], ["Deathmark", 30], ["Flayed One", 30], ["Lychguard", 20], ["Triarch Praetorian", 10], ["Necron Destroyer", 12], ["Skorpekh Destroyer", 12], ["Lokhust Destroyer", 12], ["Ophydian Destroyer", 6], ["Canoptek Scarab", 240], ["Canoptek Wraith", 12], ["Canoptek Spyder", 12], ["Canoptek Doomstalker", 3], ["Tomb Blade", 20], ["Triarch Stalker", 2], ["Necron Overlord", 1], ["Cryptek", 3], ["Royal Warden", 2], ["Ghost Ark", 4], ["Doomsday Ark", 4], ["Annihilation Barge", 4], ["Monolith", 2], ["Doom Scythe", 4], ["Tomb Stalker", 2]],
            [["Necron Warrior", 800], ["Necron Immortal", 80], ["Deathmark", 40], ["Flayed One", 40], ["Lychguard", 40], ["Triarch Praetorian", 20], ["Necron Destroyer", 40], ["Skorpekh Destroyer", 20], ["Lokhust Destroyer", 20], ["Lokhust Heavy Destroyer", 6], ["Ophydian Destroyer", 12], ["Hexmark Destroyer", 3], ["Canoptek Scarab", 320], ["Canoptek Wraith", 24], ["Canoptek Spyder", 16], ["Canoptek Reanimator", 3], ["Canoptek Doomstalker", 6], ["Tomb Blade", 40], ["Triarch Stalker", 3], ["Necron Overlord", 2], ["Cryptek", 4], ["Royal Warden", 3], ["Ghost Ark", 6], ["Doomsday Ark", 6], ["Annihilation Barge", 6], ["Monolith", 2], ["Doom Scythe", 6], ["Night Scythe", 4], ["Tomb Stalker", 3], ["Tesseract Vault", 1]],
        ];

        // Aeldari (Craftworld) — full current generic roster: Guardians, the Aspect shrines, Wraith
        // constructs, jetbikes, grav-tanks and flyers, led by an Avatar. No named characters.
        _tbl[eFACTION.ELDAR] = [
            [["Guardian Defender", 10], ["Ranger", 8], ["Dire Avenger", 8], ["Striking Scorpion", 6], ["Warlock", 1]],
            [["Guardian Defender", 40], ["Dire Avenger", 20], ["Striking Scorpion", 9], ["Howling Banshee", 9], ["Fire Dragon", 7], ["Warp Spider", 7], ["Ranger", 10], ["Windrider", 6], ["Vyper", 2], ["Falcon", 2], ["Autarch", 1], ["Farseer", 1]],
            [["Guardian Defender", 100], ["Dire Avenger", 40], ["Striking Scorpion", 19], ["Howling Banshee", 28], ["Fire Dragon", 18], ["Warp Spider", 18], ["Swooping Hawk", 15], ["Dark Reaper", 10], ["Ranger", 20], ["Windrider", 12], ["Shining Spear", 8], ["Vyper", 12], ["War Walker", 4], ["Wraithguard", 30], ["Falcon", 5], ["Fire Prism", 3], ["Wave Serpent", 6], ["Autarch", 1], ["Farseer", 1], ["Warlock", 5]],
            [["Guardian Defender", 400], ["Storm Guardian", 100], ["Dire Avenger", 280], ["Striking Scorpion", 38], ["Howling Banshee", 36], ["Fire Dragon", 36], ["Warp Spider", 36], ["Swooping Hawk", 30], ["Dark Reaper", 18], ["Ranger", 40], ["Windrider", 20], ["Shining Spear", 40], ["Vyper", 20], ["War Walker", 8], ["Wraithguard", 90], ["Wraithblade", 30], ["Wraithlord", 5], ["Falcon", 12], ["Fire Prism", 3], ["Night Spinner", 3], ["Wave Serpent", 15], ["Crimson Hunter", 3], ["Autarch", 3], ["Farseer", 2], ["Warlock", 40], ["Spiritseer", 4]],
            [["Guardian Defender", 1200], ["Storm Guardian", 300], ["Dire Avenger", 450], ["Striking Scorpion", 72], ["Howling Banshee", 72], ["Fire Dragon", 72], ["Warp Spider", 72], ["Swooping Hawk", 60], ["Dark Reaper", 36], ["Ranger", 80], ["Windrider", 40], ["Shining Spear", 80], ["Vyper", 40], ["War Walker", 16], ["Wraithguard", 180], ["Wraithblade", 60], ["Wraithlord", 10], ["Wraithknight", 2], ["Falcon", 24], ["Fire Prism", 6], ["Night Spinner", 6], ["Wave Serpent", 30], ["Crimson Hunter", 6], ["Hemlock Wraithfighter", 3], ["Autarch", 5], ["Farseer", 3], ["Warlock", 80], ["Spiritseer", 8]],
            [["Guardian Defender", 3000], ["Storm Guardian", 600], ["Dire Avenger", 540], ["Striking Scorpion", 144], ["Howling Banshee", 144], ["Fire Dragon", 144], ["Warp Spider", 144], ["Swooping Hawk", 120], ["Dark Reaper", 72], ["Ranger", 160], ["Windrider", 80], ["Shining Spear", 160], ["Vyper", 80], ["War Walker", 24], ["Wraithguard", 360], ["Wraithblade", 120], ["Wraithlord", 20], ["Wraithknight", 4], ["Falcon", 48], ["Fire Prism", 12], ["Night Spinner", 12], ["Wave Serpent", 60], ["Crimson Hunter", 12], ["Hemlock Wraithfighter", 6], ["Autarch", 8], ["Farseer", 4], ["Warlock", 100], ["Spiritseer", 12], ["Phantom Titan", 2]],
        ];

        // Adepta Sororitas / Ecclesiarchy — full current generic roster: Battle Sisters and their
        // orders, penitents, Ministorum priests and zealot levy, with Sororitas armour. No named chars.
        _tbl[eFACTION.ECCLESIARCHY] = [
            [["Frateris Militia", 60], ["Battle Sister", 30], ["Sisters Novitiate", 15], ["Ministorum Priest", 5], ["Canoness", 1]],
            [["Frateris Militia", 200], ["Battle Sister", 80], ["Sisters Novitiate", 40], ["Seraphim", 20], ["Dominion", 20], ["Arco-flagellant", 20], ["Ministorum Priest", 10], ["Crusader", 10], ["Death Cult Assassin", 6], ["Immolator", 3], ["Sororitas Rhino", 4], ["Canoness", 1], ["Palatine", 1]],
            [["Frateris Militia", 400], ["Battle Sister", 200], ["Sisters Novitiate", 80], ["Seraphim", 50], ["Zephyrim", 30], ["Dominion", 50], ["Retributor", 50], ["Celestian Sacresant", 40], ["Sisters Repentia", 50], ["Arco-flagellant", 30], ["Crusader", 20], ["Death Cult Assassin", 12], ["Ministorum Priest", 60], ["Hospitaller", 4], ["Dialogus", 3], ["Imagifier", 3], ["Immolator", 4], ["Exorcist", 2], ["Sororitas Rhino", 8], ["Penitent Engine", 4], ["Mortifier", 4], ["Canoness", 1], ["Palatine", 1]],
            [["Frateris Militia", 1800], ["Battle Sister", 1000], ["Sisters Novitiate", 200], ["Seraphim", 200], ["Zephyrim", 100], ["Dominion", 200], ["Retributor", 150], ["Celestian Sacresant", 150], ["Sisters Repentia", 100], ["Arco-flagellant", 60], ["Crusader", 40], ["Death Cult Assassin", 20], ["Ministorum Priest", 150], ["Hospitaller", 8], ["Dialogus", 6], ["Imagifier", 6], ["Dogmata", 4], ["Immolator", 15], ["Exorcist", 6], ["Castigator", 6], ["Sororitas Rhino", 20], ["Penitent Engine", 8], ["Mortifier", 8], ["Anchorite", 4], ["Paragon Warsuit", 6], ["Canoness", 2], ["Palatine", 2]],
            [["Frateris Militia", 3600], ["Battle Sister", 2000], ["Sisters Novitiate", 400], ["Seraphim", 300], ["Zephyrim", 200], ["Dominion", 300], ["Retributor", 300], ["Celestian Sacresant", 300], ["Sisters Repentia", 200], ["Arco-flagellant", 120], ["Crusader", 80], ["Death Cult Assassin", 40], ["Ministorum Priest", 300], ["Hospitaller", 12], ["Imagifier", 10], ["Dogmata", 6], ["Immolator", 25], ["Exorcist", 12], ["Castigator", 10], ["Sororitas Rhino", 40], ["Penitent Engine", 15], ["Mortifier", 15], ["Anchorite", 8], ["Paragon Warsuit", 12], ["Canoness", 2], ["Palatine", 3]],
            [["Frateris Militia", 5000], ["Battle Sister", 3000], ["Sisters Novitiate", 600], ["Seraphim", 400], ["Zephyrim", 300], ["Dominion", 400], ["Retributor", 400], ["Celestian Sacresant", 400], ["Sisters Repentia", 500], ["Arco-flagellant", 250], ["Crusader", 150], ["Death Cult Assassin", 60], ["Ministorum Priest", 400], ["Hospitaller", 20], ["Imagifier", 16], ["Dogmata", 10], ["Immolator", 50], ["Exorcist", 20], ["Castigator", 16], ["Sororitas Rhino", 60], ["Penitent Engine", 30], ["Mortifier", 30], ["Anchorite", 16], ["Paragon Warsuit", 20], ["Canoness", 3], ["Palatine", 3]],
        ];

        // Chaos Space Marines — the traitor Astartes legion (p_chaos): Legionaries, cult troops,
        // daemon engines, armour and dark characters. Elite and far fewer than the traitor horde.
        // No named characters. (Split from Heretics/Daemons 2026-07-10.)
        _tbl[eFACTION.CHAOS] = [
            [["Chaos Space Marine", 20], ["Chosen", 5], ["Chaos Lord", 1]],
            [["Chaos Space Marine", 60], ["Chosen", 10], ["Havoc", 10], ["Possessed", 10], ["Chaos Biker", 6], ["Helbrute", 2], ["Chaos Rhino", 4], ["Chaos Lord", 1], ["Sorcerer", 1]],
            [["Chaos Space Marine", 150], ["Chosen", 20], ["Havoc", 20], ["Chaos Terminator", 10], ["Raptor", 15], ["Possessed", 20], ["Chaos Biker", 12], ["Helbrute", 4], ["Defiler", 3], ["Forgefiend", 2], ["Maulerfiend", 2], ["Chaos Predator", 6], ["Chaos Rhino", 12], ["Chaos Lord", 1], ["Sorcerer", 2], ["Dark Apostle", 1], ["Chaos Spawn", 10]],
            [["Chaos Space Marine", 400], ["Chosen", 40], ["Havoc", 40], ["Chaos Terminator", 30], ["Raptor", 30], ["Warp Talon", 15], ["Possessed", 40], ["Chaos Biker", 25], ["Helbrute", 8], ["Defiler", 6], ["Forgefiend", 5], ["Maulerfiend", 5], ["Venomcrawler", 4], ["Vindicator", 8], ["Chaos Predator", 12], ["Chaos Rhino", 30], ["Chaos Land Raider", 4], ["Heldrake", 4], ["Chaos Lord", 2], ["Sorcerer", 3], ["Dark Apostle", 2], ["Warpsmith", 2], ["Master of Executions", 2], ["Chaos Spawn", 20], ["Daemon Prince", 1]],
            [["Chaos Space Marine", 800], ["Chosen", 80], ["Havoc", 80], ["Chaos Terminator", 60], ["Raptor", 60], ["Warp Talon", 30], ["Possessed", 80], ["Chaos Biker", 50], ["Helbrute", 16], ["Defiler", 12], ["Forgefiend", 10], ["Maulerfiend", 10], ["Venomcrawler", 8], ["Vindicator", 16], ["Chaos Predator", 24], ["Chaos Rhino", 60], ["Chaos Land Raider", 8], ["Heldrake", 8], ["Chaos Lord", 3], ["Sorcerer", 4], ["Dark Apostle", 3], ["Warpsmith", 3], ["Master of Executions", 3], ["Chaos Spawn", 40], ["Daemon Prince", 2]],
            [["Chaos Space Marine", 1500], ["Chosen", 150], ["Havoc", 150], ["Chaos Terminator", 120], ["Raptor", 100], ["Warp Talon", 50], ["Possessed", 150], ["Chaos Biker", 80], ["Helbrute", 24], ["Defiler", 20], ["Forgefiend", 16], ["Maulerfiend", 16], ["Venomcrawler", 12], ["Vindicator", 24], ["Chaos Predator", 40], ["Chaos Rhino", 100], ["Chaos Land Raider", 12], ["Heldrake", 12], ["Chaos Lord", 4], ["Sorcerer", 6], ["Dark Apostle", 4], ["Warpsmith", 4], ["Master of Executions", 4], ["Chaos Spawn", 60], ["Daemon Prince", 3]],
        ];

        // Heretics — the traitor MASSES (p_traitors): a world's own humans corrupted into cultists,
        // mutants, and — at the top of the infantry tree — the drilled, devoted Blood Pact, plus looted
        // armour. The Blood Pact is the last human rung before ascension to the Chaos Space Marine legion
        // (p_chaos, separate). Daemons (p_demons) are separate too. No named characters. (Split 2026-07-10.)
        _tbl[eFACTION.HERETICS] = [
            [["Chaos Cultist", 120], ["Accursed Cultist", 25], ["Cultist Firebrand", 1]],
            [["Chaos Cultist", 300], ["Accursed Cultist", 60], ["Blood Pact", 40], ["Technical", 6], ["Cultist Firebrand", 1], ["Dark Commune", 1]],
            [["Chaos Cultist", 500], ["Accursed Cultist", 200], ["Blood Pact", 200], ["Chaos Leman Russ", 6], ["Chaos Basilisk", 3], ["Chimera", 8], ["Sentinel", 6], ["Technical", 9], ["Cultist Firebrand", 2], ["Dark Commune", 1]],
            [["Chaos Cultist", 2000], ["Accursed Cultist", 700], ["Blood Pact", 1000], ["Chaos Leman Russ", 21], ["Chaos Basilisk", 6], ["Chimera", 20], ["Sentinel", 12], ["Technical", 15], ["Cultist Firebrand", 3], ["Dark Commune", 2], ["Chaos Aspirant", 2]],
            [["Chaos Cultist", 4000], ["Accursed Cultist", 1500], ["Blood Pact", 2000], ["Chaos Leman Russ", 40], ["Chaos Basilisk", 9], ["Chimera", 40], ["Sentinel", 20], ["Technical", 20], ["Cultist Firebrand", 4], ["Dark Commune", 3], ["Chaos Aspirant", 5]],
            [["Chaos Cultist", 6000], ["Accursed Cultist", 2500], ["Blood Pact", 3000], ["Chaos Leman Russ", 80], ["Chaos Basilisk", 18], ["Chimera", 60], ["Sentinel", 30], ["Technical", 30], ["Cultist Firebrand", 6], ["Dark Commune", 4], ["Chaos Aspirant", 10]],
        ];

        // Daemons (p_demons) — summoned warp entities across the four Chaos Gods (troops, beasts,
        // chariots, Greater Daemons). No named characters. (Split from the CSM legion 2026-07-10.)
        _tbl[eFACTION.GENESTEALER] = [
            [["Bloodletter", 10], ["Daemonette", 10], ["Plaguebearer", 8], ["Pink Horror", 8], ["Herald", 1]],
            [["Bloodletter", 25], ["Daemonette", 25], ["Plaguebearer", 20], ["Pink Horror", 20], ["Nurgling", 10], ["Flesh Hound", 6], ["Seeker", 6], ["Screamer", 4], ["Herald", 2], ["Daemon Prince", 1]],
            [["Bloodletter", 60], ["Daemonette", 60], ["Plaguebearer", 60], ["Pink Horror", 60], ["Nurgling", 20], ["Flesh Hound", 12], ["Seeker", 12], ["Bloodcrusher", 6], ["Plague Drone", 6], ["Flamer", 8], ["Beast of Nurgle", 4], ["Fiend", 4], ["Greater Daemon", 1], ["Herald", 4], ["Soul Grinder", 2], ["Daemon Prince", 1]],
            [["Bloodletter", 100], ["Daemonette", 100], ["Plaguebearer", 100], ["Pink Horror", 100], ["Nurgling", 40], ["Blue Horror", 40], ["Flesh Hound", 20], ["Seeker", 20], ["Bloodcrusher", 10], ["Plague Drone", 10], ["Flamer", 12], ["Screamer", 12], ["Beast of Nurgle", 6], ["Fiend", 8], ["Furies", 20], ["Greater Daemon", 1], ["Herald", 6], ["Soul Grinder", 2], ["Skull Cannon", 2], ["Burning Chariot", 2], ["Daemon Prince", 1]],
            [["Bloodletter", 250], ["Daemonette", 250], ["Plaguebearer", 250], ["Pink Horror", 250], ["Nurgling", 80], ["Blue Horror", 80], ["Flesh Hound", 40], ["Seeker", 40], ["Bloodcrusher", 20], ["Plague Drone", 20], ["Flamer", 24], ["Screamer", 24], ["Beast of Nurgle", 12], ["Fiend", 16], ["Furies", 40], ["Greater Daemon", 3], ["Herald", 8], ["Soul Grinder", 2], ["Skull Cannon", 3], ["Burning Chariot", 3], ["Daemon Prince", 2]],
            [["Bloodletter", 500], ["Daemonette", 500], ["Plaguebearer", 500], ["Pink Horror", 500], ["Nurgling", 160], ["Blue Horror", 160], ["Flesh Hound", 80], ["Seeker", 80], ["Bloodcrusher", 40], ["Plague Drone", 40], ["Flamer", 48], ["Screamer", 48], ["Beast of Nurgle", 24], ["Fiend", 32], ["Furies", 80], ["Greater Daemon", 5], ["Herald", 12], ["Soul Grinder", 3], ["Skull Cannon", 4], ["Burning Chariot", 4], ["Seeker Chariot", 4], ["Daemon Prince", 3]],
        ];
    }

    var _fac_tbl = ((_faction >= 0) && (_faction < array_length(_tbl))) ? _tbl[_faction] : undefined;
    if (_fac_tbl == undefined) {
        return [];
    }

    // Time-gate the roster (§14): basics (tier 0) field immediately; elite/vehicle/apex rows ramp in
    // as the world develops, tuned per faction. At infra=32 (pre-developed / old saves) every gate is
    // fully open, so the full table shows; a freshly captured world (infra 0) shows only its basics and
    // grows into the rest over turns — no sudden boom.
    var _rows = _fac_tbl[_lv];
    var _g = faction_infra_gates(_faction);
    var _lines = [];
    for (var i = 0; i < array_length(_rows); i++) {
        var _lbl = _rows[i][0];
        var _cnt = _rows[i][1];
        var _tier = faction_unit_tier(_faction, _lbl);
        if (_tier >= 1) {
            var _start = (_tier == 1) ? _g.t1 : ((_tier == 2) ? _g.t2 : _g.t3);
            _cnt = round(_cnt * clamp((_infra_turns - _start) / _g.w, 0, 1));
        }
        if (_cnt > 0) {
            array_push(_lines, { label: _lbl, count: _cnt });
        }
    }
    return _lines;
}

/// @function region_force_breakdown
/// @description Builds the force-composition readout for a region's garrison drill-down menu.
///              v1 has real per-unit data only for the Imperial garrison (PDF / Guardsmen, straight
///              off the region fields); other owners return a "pending" note until the per-faction
///              force recipes land. See docs/POPULATIONS_FORCE_PLAN.md §15 for the full plan.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _region_index
/// @returns {Struct}
function region_force_breakdown(_star, _planet, _region_index) {
    var _region = region_get(_star, _planet, _region_index);
    var _owner = _region.owner;
    var _lines = [];
    var _note = "";

    // A planet has ONE force pool (the 0-6 level / roster), shared across its regions — so a region
    // shows only its SHARE of that pool, not the whole planet army. Otherwise a 7,000-strong garrison
    // would read as 7,000 in every one of its regions (28,000 across four). The capital holds the
    // largest cut; the rest split the remainder. See region_faction_share.
    var _share = region_faction_share(_star, _planet, _region_index, _owner);

    var _imperial = (_owner == eFACTION.PLAYER) || (_owner == eFACTION.IMPERIUM) || (_owner == eFACTION.MECHANICUS) || (_owner == eFACTION.INQUISITION) || (_owner == eFACTION.ECCLESIARCHY);
    if (_imperial) {
        // PDF / Guardsmen are already the region's own fields (per-region), so they are not re-split.
        array_push(_lines, { label: "PDF", count: _region.pdf });
        array_push(_lines, { label: "Guardsmen", count: _region.guardsmen });
        // Imperial sub-factions that field their own troops add them above the PDF/Guard garrison —
        // e.g. an Ecclesiarchy shrine world fields Sisters of Battle. That roster is planet-wide, so it
        // takes this region's share. (Plain Imperium/Mechanicus/Inquisition have no table -> nothing.)
        var _sub = scale_force_lines(planet_faction_composition(_star, _planet, _owner), _share);
        for (var _si = 0; _si < array_length(_sub); _si++) {
            array_push(_lines, _sub[_si]);
        }
        // Future: Veterans / Tempestus / armour / air from region.mil (POPULATIONS_FORCE_PLAN §14).
    } else if (br_side_of_faction(_owner) == "CHAOS") {
        // Fold the WHOLE Chaos alliance (Heretics + Chaos Marines + Daemons), like the planet headline does —
        // a heretic-held world's force lives under HERETICS, not the CHAOS owner faction, so composing only
        // the owner read as empty ("no significant field army") even with thousands of cultists present.
        var _cfacs = [eFACTION.CHAOS, eFACTION.HERETICS, eFACTION.GENESTEALER];
        for (var _cf = 0; _cf < array_length(_cfacs); _cf++) {
            var _cl = scale_force_lines(planet_faction_composition(_star, _planet, _cfacs[_cf]), _share);
            for (var _ci = 0; _ci < array_length(_cl); _ci++) { array_push(_lines, _cl[_ci]); }
        }
        if (array_length(_lines) == 0) {
            _note = "Holding this sector — no significant field army here.";
        }
    } else {
        // Every other faction: this region's share of what the faction fields at its current strength.
        // Orks recruit from their population, tiers unlocking + ramping as the world develops.
        _lines = scale_force_lines(planet_faction_composition(_star, _planet, _owner), _share);
        if (array_length(_lines) == 0) {
            _note = "Holding this sector — no significant field army here.";
        }
    }

    var _result = {
        owner: _owner,
        owner_name: region_faction_name(_owner),
        title: "Forces - " + _region.name,
        population: round(planet_race_pop(_star, _planet, _owner) * _share),
        lines: _lines,
        note: _note,
    };
    // A Chaos-held region flies its world's god banner too — show the sect via the REUSED allegiances panel
    // (§16r), the same way an Ork-held region shows its clan.
    if (br_side_of_faction(_owner) == "CHAOS") {
        var _rgod = planet_chaos_god(_star, _planet);
        if (_rgod >= 0) { _result.warbands = chaos_sect_allegiance(_rgod); }
    }
    return _result;
}

/// @function region_faction_share
/// @description The fraction of a planet's (shared) force pool that sits in one region. The planet's
///              force is split only across the regions that faction actually holds, weighted by how
///              that faction DEPLOYS per lore (faction_deployment_weight). Lets the per-region breakdown
///              sum to the planet total instead of repeating the whole army in every region.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _region_index
/// @param {Real} _faction
/// @returns {Real} 0-1
function region_faction_share(_star, _planet, _region_index, _faction) {
    var _regions = regions_ensure(_star, _planet);
    var _n = array_length(_regions);
    if (_n <= 1) { return 1; }
    var _total_w = 0;
    var _my_w = 0;
    for (var i = 0; i < _n; i++) {
        if (_regions[i].owner != _faction) { continue; }
        var _w = faction_deployment_weight(_faction, _regions[i]);
        _total_w += _w;
        if (i == _region_index) { _my_w = _w; }
    }
    if (_total_w <= 0) { return 1; }        // faction holds no region here -> show whole (fallback)
    return _my_w / _total_w;
}

/// @function faction_deployment_weight
/// @description How heavily a faction garrisons one region, shaping how its planet force spreads across
///              the regions it holds — its deployment DOCTRINE, per lore:
///              - Imperium/PDF: dig in — heaviest at the capital and the best-fortified regions.
///              - Orks: the WAAAGH masses at the Warboss's capital stronghold; big mobs everywhere else.
///              - Tyranids: a swarm floods every region fairly evenly to consume all biomass.
///              - Necrons: legions wake from the tomb-complex — concentrated, sparse at the fringes.
///              - Tau: methodical occupation — even coverage, a modest cadre HQ at the capital.
///              - Eldar: a small mobile host — concentrated at one seat, barely present elsewhere.
///              - Chaos/Heretics/Daemons: warbands and cults rise from the corrupted seat of power.
/// @param {Real} _faction
/// @param {Struct.Region} _region
/// @returns {Real} relative weight (>0)
function faction_deployment_weight(_faction, _region) {
    var _cap = _region.is_capital;
    switch (_faction) {
        case eFACTION.ORK:        return _cap ? 3.0 : 1.2;
        case eFACTION.TYRANIDS:   return _cap ? 1.3 : 1.0;   // even swarm
        case eFACTION.NECRONS:    return _cap ? 4.0 : 0.8;   // tomb-centric
        case eFACTION.TAU:        return _cap ? 1.6 : 1.0;   // even, cadre HQ
        case eFACTION.ELDAR:      return _cap ? 4.0 : 0.6;   // concentrated, mobile
        case eFACTION.CHAOS:
        case eFACTION.HERETICS:
        case eFACTION.GENESTEALER: return _cap ? 2.5 : 1.0;  // rises from the corrupted seat (GENESTEALER = Daemons slot)
        default:                  return (_cap ? 2.0 : 1.0) + _region.fortification * 0.15; // Imperial garrison doctrine
    }
}

/// @function scale_force_lines
/// @description Scale a roster's counts by a fraction (a region's share of the planet force), dropping
///              rows that round to zero (that unit sits in another region). Share >= 1 returns as-is.
/// @param {Array<Struct>} _lines  [{label, count}, ...]
/// @param {Real} _share  0-1
/// @returns {Array<Struct>}
function scale_force_lines(_lines, _share) {
    if (_share >= 1) { return _lines; }
    var _out = [];
    for (var i = 0; i < array_length(_lines); i++) {
        var _c = round(_lines[i].count * _share);
        if (_c > 0) { array_push(_out, { label: _lines[i].label, count: _c }); }
    }
    return _out;
}

/// @function br_arm_total
/// @description Total headcount one faction fields on a world (sum of its population/ladder roster). Used to
///              show each ALLIANCE member as a single summary line in the combined force breakdown.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _faction
/// @returns {Real}
function br_arm_total(_star, _planet, _faction) {
    var _c = planet_faction_composition(_star, _planet, _faction);
    var _t = 0;
    for (var i = 0; i < array_length(_c); i++) { _t += _c[i].count; }
    return _t;
}

/// @function planet_force_breakdown
/// @description Planet-level "combined alliance" force breakdown for the headline drill-down (region_force
///              _faction = -1). Lists every UNIT of the OWNER'S ALLIANCE (same detail as a region's Forces
///              panel), combined planet-wide — Imperial = PDF + Guard + Astartes + Adepta Sororitas /
///              Skitarii / Inquisition units; Chaos = Heretic + Chaos Marine + Daemon units. Same struct
///              shape as region_force_breakdown, so it feeds draw_force_panel (§16q).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Struct}
function planet_force_breakdown(_star, _planet) {
    var _owner = _star.p_owner[_planet];
    var _side = br_side_of_faction(_owner);
    var _lines = [];
    var _facs;

    if (_side == "CHAOS") {
        _facs = [eFACTION.CHAOS, eFACTION.HERETICS, eFACTION.GENESTEALER];
    } else {
        // Imperial: PDF + Guard + Astartes garrison as summary lines, then each Imperial arm's units.
        var _pdf = _star.p_pdf[_planet];
        var _guard = _star.p_guardsmen[_planet];
        if (_pdf > 0)   { array_push(_lines, { label: "PDF", count: _pdf }); }
        if (_guard > 0) { array_push(_lines, { label: "Guardsmen", count: _guard }); }
        var _astartes = 0;
        try {
            var _gar = _star.get_garrison(_planet);
            if (is_struct(_gar) && variable_struct_exists(_gar, "viable_garrison")) { _astartes = _gar.viable_garrison; }
        } catch (_e) { _astartes = 0; }
        if (_astartes > 0) { array_push(_lines, { label: "Space Marines", count: _astartes }); }
        _facs = [eFACTION.ECCLESIARCHY, eFACTION.MECHANICUS, eFACTION.INQUISITION];
    }
    // Fold in each member faction's UNIT roster so the panel breaks the alliance down to individual units,
    // exactly like the per-sector Forces panel does.
    for (var f = 0; f < array_length(_facs); f++) {
        var _c = planet_faction_composition(_star, _planet, _facs[f]);
        for (var i = 0; i < array_length(_c); i++) { array_push(_lines, _c[i]); }
    }

    var _total = 0;
    for (var i = 0; i < array_length(_lines); i++) { _total += _lines[i].count; }
    var _note = (_total <= 0) ? "Holding this world — no significant field army here." : "";
    var _result = {
        owner: _owner,
        owner_name: (_side == "CHAOS") ? "Chaos" : "Imperium",
        title: (_side == "CHAOS") ? "Chaos Forces" : "Imperial Forces",
        population: 0,
        lines: _lines,
        note: _note,
    };
    // A Chaos world flies a god's banner — show it via the REUSED allegiances panel (§16r), exactly the way
    // an Ork WAAAGH shows its clan (colour bar + symbol + style text). Covers heretic, marine AND daemon worlds.
    if (_side == "CHAOS") {
        var _cgod = planet_chaos_god(_star, _planet);
        if (_cgod >= 0) { _result.warbands = chaos_sect_allegiance(_cgod); }
    }
    return _result;
}

/// @function planet_faction_force_breakdown
/// @description Planet-wide roster for one faction, opened from a Planetary Presence entry. Runs the
///              faction's ladder composition at its current planet strength level. Same struct shape
///              as the region/planet breakdowns, so it feeds the shared draw_force_panel.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _faction  eFACTION value
/// @returns {Struct}
function planet_faction_force_breakdown(_star, _planet, _faction) {
    var _lines = planet_faction_composition(_star, _planet, _faction);
    var _note = (array_length(_lines) == 0) ? "Present in low numbers — no significant field army." : "";
    // Orks: name the leading clan (and the minor clans riding with it) so the WAAAGH's kultur is visible,
    // and attach the full warband split for the Forces panel (so the player can judge a Behead).
    var _warbands = undefined;
    if ((_faction == eFACTION.ORK) && (planet_race_pop(_star, _planet, eFACTION.ORK) > 0)) {
        _note = "Led by the " + ork_clan_summary(_star, _planet) + ".";
        _warbands = ork_warband_breakdown(_star, _planet);
    }
    return {
        owner: _faction,
        owner_name: region_faction_name(_faction),
        title: region_faction_name(_faction) + " Forces",
        population: planet_race_pop(_star, _planet, _faction),
        lines: _lines,
        note: _note,
        warbands: _warbands,
    };
}

/// @function draw_force_panel
/// @description Draws a force-composition drill-down panel from a pre-built breakdown struct
///              (region_force_breakdown or planet_force_breakdown). Read-only v1. Draw GUI event.
/// @param {Struct} _data {title, owner, owner_name, lines, note}
/// @param {Real} _px Left edge (GUI x).
/// @param {Real} _py Top edge (GUI y).
/// @returns {Bool} True the frame the close [x] is clicked (caller should dismiss the panel).
function draw_force_panel(_data, _px, _py) {
    var _line_n = array_length(_data.lines);

    var _head_h = 48;
    var _line_h = 18;
    var _col_w = 200;           // one column's content width
    var _max_rows_per_col = 16; // wrap into extra columns past this so long rosters stay on-screen

    // Pack the roster into 1-3 columns.
    var _cols = (_line_n <= _max_rows_per_col) ? 1 : clamp(ceil(_line_n / _max_rows_per_col), 1, 3);
    var _rows_per_col = (_line_n > 0) ? ceil(_line_n / _cols) : 1;

    // Ork warband-split section (§16f): shown on the Ork force panel so the player can judge a Behead.
    var _has_wb = variable_struct_exists(_data, "warbands") && is_struct(_data.warbands) && (array_length(_data.warbands.warbands) > 0);
    var _wb_rows = _has_wb ? array_length(_data.warbands.warbands) : 0;
    var _wb_section_h = _has_wb ? (22 + (_wb_rows * (_line_h * 2)) + 90) : 0;   // +90 = the wrapped clan-style line

    var _w = (_col_w * _cols) + 16;
    if (_has_wb) { _w = max(_w, 380); }
    var _h = _head_h + (max(_rows_per_col, 1) * _line_h) + 12 + _wb_section_h;

    // Keep a wide multi-column roster on-screen: pull it left if it would overrun the right edge.
    var _gui_w = display_get_gui_width();
    if (_px + _w > _gui_w - 8) {
        _px = _gui_w - _w - 8;
    }
    if (_px < 8) {
        _px = 8;
    }

    // Background + border.
    draw_set_alpha(0.9);
    draw_set_color(c_black);
    draw_rectangle(_px, _py, _px + _w, _py + _h, false);
    draw_set_alpha(1);
    draw_set_color(c_dkgray);
    draw_rectangle(_px, _py, _px + _w, _py + _h, true);

    // Header: title, owner (colour-coded), close [x].
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text(_px + 10, _py + 6, _data.title);

    var _col = c_gray;
    if ((_data.owner >= 0) && (_data.owner < array_length(global.star_name_colors))) {
        _col = global.star_name_colors[_data.owner];
    }
    draw_set_font(fnt_40k_14);
    draw_set_color(_col);
    draw_text(_px + 10, _py + 26, _data.owner_name);

    // Population (additive layer): shown when this owner has a seeded race population on the world.
    var _pop = variable_struct_exists(_data, "population") ? _data.population : 0;
    if (_pop > 0) {
        draw_set_color(c_ltgray);
        draw_set_halign(fa_right);
        draw_text(_px + _w - 8, _py + 26, $"Pop: {scr_display_number(_pop)}");
        draw_set_halign(fa_left);
    }

    var _cx1 = _px + _w - 22;
    var _cy1 = _py + 6;
    var _cx2 = _px + _w - 6;
    var _cy2 = _py + 22;
    draw_set_color(scr_hit(_cx1, _cy1, _cx2, _cy2) ? c_yellow : c_ltgray);
    draw_set_halign(fa_center);
    draw_text((_cx1 + _cx2) * 0.5, _cy1, "x");
    draw_set_halign(fa_left);

    draw_set_color(c_dkgray);
    draw_line(_px + 6, _py + _head_h - 6, _px + _w - 6, _py + _head_h - 6);

    // Body: unit lines packed into columns (label left, count right), or the pending note.
    if (_line_n > 0) {
        for (var i = 0; i < _line_n; i++) {
            var _c = i div _rows_per_col;
            var _r = i mod _rows_per_col;
            var _colx = _px + 8 + (_c * _col_w);
            var _ly = _py + _head_h + (_r * _line_h);
            var _line = _data.lines[i];
            draw_set_color(c_ltgray);
            draw_set_halign(fa_left);
            draw_text(_colx + 6, _ly, _line.label);
            draw_set_color(c_white);
            draw_set_halign(fa_right);
            draw_text(_colx + _col_w - 8, _ly, string(_line.count));
        }
        draw_set_halign(fa_left);
    } else {
        draw_set_color(c_ltgray);
        draw_text_ext(_px + 14, _py + _head_h, _data.note, -1, _w - 26);
    }
    // A note ALONGSIDE the unit list (e.g. a Chaos world's god allegiance "Sworn to Khorne" §16r) — drawn
    // below the columns. Skipped for Orks, whose breakdown uses the Warband Allegiances block instead.
    if ((_line_n > 0) && (_data.note != "") && !_has_wb) {
        var _noty = _py + _head_h + (max(_rows_per_col, 1) * _line_h) + 4;
        draw_set_color(c_ltgray);
        draw_set_halign(fa_left);
        draw_text_ext(_px + 14, _noty, _data.note, -1, _w - 26);
    }

    // Warband allegiances (§16f): the Ork force's split between warbands — each warband's share (a clan-
    // tinted bar shows who's biggest at a glance), name, clan and boss — plus a tactical read on a Behead.
    if (_has_wb) {
        var _wbd = _data.warbands;
        var _wy = _py + _head_h + (max(_rows_per_col, 1) * _line_h) + 6;
        draw_set_color(c_dkgray);
        draw_line(_px + 6, _wy, _px + _w - 6, _wy);
        _wy += 4;
        draw_set_font(fnt_40k_14b);
        draw_set_halign(fa_left);
        draw_set_color(c_white);
        draw_text(_px + 10, _wy, variable_struct_exists(_wbd, "allegiance_title") ? _wbd.allegiance_title : "Warband Allegiances");
        _wy += 18;
        draw_set_font(fnt_40k_14);
        var _barx0 = _px + 10;
        var _barx1 = _px + _w - 10;
        var _barw = _barx1 - _barx0;
        for (var i = 0; i < _wb_rows; i++) {
            var _wr = _wbd.warbands[i];
            var _cc = _wr.colour;                          // this clan's OWN colour (§16m)
            // subtle clan-tinted share bar behind the row — the visual "who's biggest" cue.
            draw_set_alpha(0.28);
            draw_set_color(_cc);
            draw_rectangle(_barx0, _wy + 1, _barx0 + (_barw * clamp(_wr.share, 0, 1)), _wy + (_line_h * 2) - 3, false);
            draw_set_alpha(1);
            // this clan's OWN symbol (colour + shape) at the row's left.
            ork_draw_clan_symbol(_wr.icon, _wr.colour, _barx0 + 12, _wy + _line_h - 1, 6);
            // line A: leader star + warband name (indented past the icon), share % (right).
            draw_set_halign(fa_left);
            draw_set_color(_wr.leads ? c_yellow : c_white);
            draw_text(_barx0 + 26, _wy, (_wr.leads ? "* " : "") + _wr.name);
            draw_set_halign(fa_right);
            draw_set_color(c_white);
            draw_text(_barx1 - 4, _wy, string(round(_wr.share * 100)) + "%");
            // line B: clan + boss (dim), plus whether this warband has sworn to the WAAAGH.
            draw_set_halign(fa_left);
            draw_set_color(c_ltgray);
            var _wr_joined = variable_struct_exists(_wr, "joined") && _wr.joined && !_wr.leads;
            var _wr_bosslbl = variable_struct_exists(_wr, "boss_label") ? _wr.boss_label : ("Warboss " + _wr.boss);
            draw_text(_barx0 + 26, _wy + _line_h - 2, _wr_bosslbl + (_wr_joined ? "  (sworn)" : ""));
            _wy += _line_h * 2;
        }
        // The leading clan's preferred way of fighting (lore) — its kultur shapes the roster above.
        _wy += 4;
        draw_set_color(c_ltgray);
        draw_set_halign(fa_left);
        var _style_txt = variable_struct_exists(_wbd, "style_desc") ? _wbd.style_desc : ork_clan_style_desc(_wbd.lead_kultur, variable_struct_exists(_wbd, "lead_kultur_name") ? _wbd.lead_kultur_name : "");
        draw_text_ext(_px + 10, _wy, _style_txt, -1, _w - 20);
    }

    // Restore default draw state.
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_set_alpha(1);

    return point_and_click([_cx1, _cy1, _cx2, _cy2]);
}

#endregion

#region buildings (region construction tree)

// Per-region building tree (Sector Governor roadmap C). Buildings are a DATA-DRIVEN catalogue:
// each entry has an id, display name, holo sprite, requisition cost, a build cap, planet-type
// gating, an optional one-shot `apply` effect (run on build) and an optional per-turn `on_turn`
// effect (run each turn for player-held regions). Built ids are stored in Region.buildings, which
// serialises as part of the region struct in p_regions. The UI reuses the game's existing
// draw_building_builder holo widget (the same one the Monastery uses to build a Forge).
//
// Effects deliberately target the same region fields the conquest overlay already uses
// (fortification / defences / pdf / guardsmen / population), so buildings immediately matter:
// a Bastion hardens a region against capture, a Manufactorum earns requisition, and so on.
//
// NOTE: art is placeholder — only three holo sprites exist (spr_forge_holo, spr_holo_pad,
// spr_def_mine), reused here. Swap the `sprite` field per entry when real art lands. The income /
// growth numbers are first-pass and meant to be tuned.

/// @function region_buildings_ensure
/// @description Guarantees a region has its buildings array (old saves predate the field).
/// @param {Struct.Region} _region
/// @returns {Array}
function region_buildings_ensure(_region) {
    if (!variable_struct_exists(_region, "buildings") || !is_array(_region.buildings)) {
        _region.buildings = [];
    }
    return _region.buildings;
}

/// @function region_gun_mastery_ensure
/// @description Guarantees the region's captured-gun mastery flag exists (old saves predate it).
/// @param {Struct.Region} _region
/// @returns {Bool}
function region_gun_mastery_ensure(_region) {
    if (!variable_struct_exists(_region, "gun_mastered")) {
        _region.gun_mastered = false;
    }
    return _region.gun_mastered;
}

/// @function region_building_catalogue
/// @description The static catalogue of buildable region buildings. Add an entry to add a building.
/// @returns {Array<Struct>}
function region_building_catalogue() {
    static _cat = [
        {
            id: "bastion", name: "Bastion", sprite: spr_holo_pad, cost: 1500, max: 5, types: "all",
            desc: "Reinforced walls and bunkers. +1 fortification (max 5). Fortified regions resist capture and fall last.",
            apply: function(_star, _planet, _region) {
                _region.fortification = min(5, _region.fortification + 1);
                // Feed the planet's real fortification (drives the obj_nfort bunker in a
                // defending battle). Guarded so it never lowers an already-higher value
                // (e.g. a homeworld at 6). The uncapped per-Bastion fortress bonus is
                // separate: planet_bastion_count -> obj_ncombat.bastion_bonus.
                if (_star.p_fortified[_planet] < 5) {
                    _star.p_fortified[_planet] += 1;
                }
            },
            on_turn: undefined,
        },
        {
            id: "turret_battery", name: "Turret Battery", sprite: spr_holo_pad, cost: 1000, max: 5, types: "all",
            desc: "Ground weapon emplacements. +1 defences. Ground down as the region is captured.",
            apply: function(_star, _planet, _region) {
                _region.defences = min(30, _region.defences + 6);
                // Real weapon emplacements (player_defenses in the ground battle). Combat
                // caps the effect near 30, so the stored value is left uncapped.
                _star.p_defenses[_planet] += 6;
            },
            on_turn: undefined,
        },
        {
            id: "anti_orbital_gun", name: "Anti-Orbital Gun", sprite: spr_holo_pad, cost: 8000, max: 1, types: "all",
            desc: "Orbital defence battery. Each turn it fires on fleets hostile to whoever holds THIS region, destroying a ship in orbit. A double-edged sword: if the enemy takes the region the gun turns on your fleet -- though mindless Tyranids can't operate it (only a Genestealer Cult might, and only sometimes). (Handled by regions_orbital_guns_tick.)",
            apply: undefined,
            on_turn: undefined,
        },
        {
            id: "manufactorum", name: "Manufactorum", sprite: spr_forge_holo, cost: 10000, max: 1, types: ["Hive", "Forge", "Desert"],
            desc: "Major industrial complex feeding the Chapter's war production. Adds ~100 forge / industry points each turn while you hold this region.",
            apply: undefined,
            // Forge points produced = 5 x player_forges (scr_specialist_point_handler), so +20 forges ~= +100 points/turn.
            on_turn: function(_star, _planet, _region) { obj_controller.player_forge_data.player_forges += 20; },
        },
        {
            id: "factory", name: "Factory", sprite: spr_forge_holo, cost: 2000, max: 1, types: ["Hive", "Forge", "Temperate"],
            desc: "War materiel factory. +4 requisition each turn while you hold this region.",
            apply: undefined,
            // Requisition is produced via the income system
            // (regions_player_requisition_income -> income_regions in scr_income), NOT
            // added here, so it shows in the Requisition counter breakdown and is paid
            // together with the rest of the turn's income.
            req: 4,
            on_turn: undefined,
        },
        {
            id: "mine", name: "Mine", sprite: spr_def_mine, cost: 1500, max: 1, types: ["Desert", "Ice", "Lava", "Dead", "Death"],
            desc: "Resource extraction. +3 requisition each turn while you hold this region.",
            apply: undefined,
            // Requisition produced via the income system (see Factory note above).
            req: 3,
            on_turn: undefined,
        },
        {
            id: "industrial_farm", name: "Industrial Farms", sprite: spr_holo_pad, cost: 1200, max: 1, types: ["Agri", "Temperate", "Feudal"],
            desc: "Mechanised agriculture. Grows the region's population toward its maximum each turn.",
            apply: undefined,
            on_turn: function(_star, _planet, _region) {
                var _growth = max(1, round(_region.population * 0.01));
                _region.population = min(_region.max_population, _region.population + _growth);
                _star.p_population[_planet] = min(_star.p_max_population[_planet], _star.p_population[_planet] + _growth);
            },
        },
        {
            id: "pdf_barracks", name: "PDF Barracks", sprite: spr_holo_pad, cost: 1000, max: 1, types: "all",
            desc: "Trains local Planetary Defence Force. +200 PDF each turn while you hold this region.",
            apply: undefined,
            on_turn: function(_star, _planet, _region) {
                _region.pdf += 200;
                _star.p_pdf[_planet] += 200; // planet scalar is authoritative; region copy is display
            },
        },
        {
            id: "guard_barracks", name: "Guard Barracks", sprite: spr_holo_pad, cost: 1500, max: 1, types: "all",
            desc: "Raises Astra Militarum. +100 Guardsmen each turn while you hold this region.",
            apply: undefined,
            on_turn: function(_star, _planet, _region) {
                _region.guardsmen += 100;
                _star.p_guardsmen[_planet] += 100; // feeds the Sector Governor's recruitment pool
            },
        },
        {
            id: "training_ground", name: "Training Ground", sprite: spr_holo_pad, cost: 1200, max: 1, types: "all",
            desc: "Drill fields and live-fire ranges. Scouts garrisoned on this planet gain experience passively each turn while you hold the region.",
            apply: undefined,
            on_turn: function(_star, _planet, _region) {
                // Passive training: grant experience to every Scout garrisoned (stationed) on this planet.
                var _gar = _star.get_garrison(_planet);
                if (is_struct(_gar) && is_array(_gar.members)) {
                    var _scout_role = obj_ini.role[100][eROLE.SCOUT];
                    for (var i = 0, l = array_length(_gar.members); i < l; i++) {
                        var _unit = _gar.members[i];
                        if (is_struct(_unit) && (_unit.role() == _scout_role)) {
                            // Drills only take a Scout so far: grounds teach up to
                            // TRAINING_GROUND_XP_CAP, at TRAINING_GROUND_XP_PER_TURN per
                            // ground per turn. Real combat covers the rest of the road
                            // to veterancy. (Was a flat 10/turn uncapped: two grounds
                            // made a full veteran out of a Scout in a few turns.)
                            if (_unit.experience < TRAINING_GROUND_XP_CAP) {
                                _unit.add_exp(min(TRAINING_GROUND_XP_PER_TURN, TRAINING_GROUND_XP_CAP - _unit.experience));
                            }
                        }
                    }
                }
            },
        },
        {
            id: "candidate_station", name: "Candidate Station", sprite: spr_holo_pad, cost: 2000, max: 1, types: "all",
            desc: "Screens aspirants for gene-seed compatibility on-site, raising recruitment success on this world without tying up your apothecaries. (Passive; effect applies while you hold the region.)",
            apply: undefined,
            on_turn: undefined,
        },
        {
            // AI-ONLY: the Orks raise this on a world they hold as their Fungal Bloom matures; it is not
            // player-buildable (ai_only gates it out of the build menu). It mirrors the ORKSTRONGHOLD planet
            // feature so the Ork presence shows as a built structure on the capital region. See
            // ork_sync_stronghold / ork_world_tick.
            id: "ork_stronghold", name: "Ork Stronghold", sprite: spr_holo_pad, cost: 0, max: 1, types: "all",
            ai_only: true,
            desc: "A sprawling greenskin fortress of scrap, spore-towers and Mek workshops. Grows more dangerous the longer the Orks hold the world.",
            apply: undefined,
            on_turn: undefined,
        },
    ];
    return _cat;
}

/// @function region_building_def
/// @description Catalogue entry for a building id, or undefined.
/// @param {String} _id
/// @returns {Struct|Undefined}
function region_building_def(_id) {
    var _cat = region_building_catalogue();
    for (var i = 0, l = array_length(_cat); i < l; i++) {
        if (_cat[i].id == _id) {
            return _cat[i];
        }
    }
    return undefined;
}

/// @function region_building_count
/// @description How many of a building id a region has built.
/// @param {Struct.Region} _region
/// @param {String} _id
/// @returns {Real}
function region_building_count(_region, _id) {
    region_buildings_ensure(_region);
    var _n = 0;
    for (var i = 0, l = array_length(_region.buildings); i < l; i++) {
        if (_region.buildings[i] == _id) {
            _n++;
        }
    }
    return _n;
}

/// @function planet_bastion_count
/// @description How many Bastion region-buildings a whole world mounts (summed across its regions). Save-safe:
///              reads the serialised region buildings via regions_ensure/region_building_count, so it works on
///              ANY save (old saves with no regions/buildings simply return 0). Drives the DISTINCT, uncapped
///              fortress-reinforcement bonus a Bastion gives in the defending battle (§16h) — separate from the
///              0-5 fortification tier the base-game "improve defences" upgrade fills.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function planet_bastion_count(_star, _planet) {
    var _regions = regions_ensure(_star, _planet);
    var _n = 0;
    for (var i = 0, l = array_length(_regions); i < l; i++) {
        _n += region_building_count(_regions[i], "bastion");
    }
    return _n;
}

/// @function region_building_allowed_type
/// @description Whether a building's planet-type gating allows it on this world.
/// @param {Struct} _def
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Bool}
function region_building_allowed_type(_def, _star, _planet) {
    if (!variable_struct_exists(_def, "types")) {
        return true;
    }
    var _types = _def.types;
    if (is_string(_types)) {
        return (_types == "all");
    }
    if (is_array(_types)) {
        return array_contains(_types, _star.p_type[_planet]);
    }
    return true;
}

/// @function region_building_is_defence
/// @description Defences (walls, turrets, the orbital gun) coexist with a region's one improvement.
/// @param {Struct} _def
/// @returns {Bool}
function region_building_is_defence(_def) {
    switch (_def.id) {
        case "bastion":
        case "turret_battery":
        case "anti_orbital_gun":
            return true;
    }
    return false;
}

/// @function region_building_is_improvement
/// @description A player-benefit improvement (economy / garrison / recruitment). Only one of these
///              may be built per region; defences don't count.
/// @param {Struct} _def
/// @returns {Bool}
function region_building_is_improvement(_def) {
    return !region_building_is_defence(_def);
}

/// @function region_improvement_count
/// @description How many player-benefit improvements a region already has (defences excluded).
/// @param {Struct.Region} _region
/// @returns {Real}
function region_improvement_count(_region) {
    region_buildings_ensure(_region);
    var _count = 0;
    for (var i = 0, l = array_length(_region.buildings); i < l; i++) {
        var _def = region_building_def(_region.buildings[i]);
        if ((_def != undefined) && region_building_is_improvement(_def)) {
            _count++;
        }
    }
    return _count;
}

/// @function region_planet_building_count
/// @description Total number of a given building id across every region of a planet (for per-planet
///              caps such as the one-per-planet Anti-Orbital Gun).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {String} _id
/// @returns {Real}
function region_planet_building_count(_star, _planet, _id) {
    var _regions = regions_ensure(_star, _planet);
    var _total = 0;
    for (var r = 0, rl = array_length(_regions); r < rl; r++) {
        _total += region_building_count(_regions[r], _id);
    }
    return _total;
}

/// @function region_building_can_build
/// @description Whether the player may build this building in this region right now (ignoring cost,
///              which the UI checks). Rules: the player must hold the region and the world type must
///              allow it; the Anti-Orbital Gun is capped at ONE PER PLANET; other buildings obey
///              their per-region cap; and a region may hold only ONE player-benefit improvement
///              (defences don't count toward that and can be built alongside it).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Struct.Region} _region
/// @param {Struct} _def
/// @returns {Bool}
function region_building_can_build(_star, _planet, _region, _def) {
    if (_region.owner != eFACTION.PLAYER) {
        // A CONSTRUCTION LICENSE bought for this region unlocks the FULL building set
        // here without ownership (the partial game-starter): skip the allied-only
        // restriction below. The capital can never be licensed (see
        // region_can_license), so this only ever opens outlying regions.
        if (!region_is_licensed(_region)) {
            // Unlicensed non-owned worlds: allied worlds still accept Chapter-funded
            // DEFENSES and barracks when the world's DISPOSITION toward the Chapter is
            // positive (standing is the permission, influence discounts the price, see
            // region_building_price). Economic improvements require a license or the flip.
            var _allied_owner = array_contains(global.SystemHelps.default_allies, _region.owner);
            var _fundable = region_building_is_defence(_def)
                || (_def.id == "pdf_barracks")
                || (_def.id == "guard_barracks");
            if (!_allied_owner || !_fundable || (_star.dispo[_planet] <= 0)) {
                return false;
            }
        }
    }
    // AI-only structures (e.g. the Ork Stronghold) never appear in the player build menu.
    if (variable_struct_exists(_def, "ai_only") && _def.ai_only) {
        return false;
    }
    if (!region_building_allowed_type(_def, _star, _planet)) {
        return false;
    }

    // Cap: the Anti-Orbital Gun is one per planet; everything else is per region.
    if (_def.id == "anti_orbital_gun") {
        if (region_planet_building_count(_star, _planet, _def.id) >= _def.max) {
            return false;
        }
    } else if (region_building_count(_region, _def.id) >= _def.max) {
        return false;
    }

    // Only one player-benefit improvement per region (defences are exempt).
    if (region_building_is_improvement(_def) && (region_improvement_count(_region) > 0)) {
        return false;
    }

    return true;
}

/// @function region_building_build
/// @description Attempts to build a building in a region: validates, spends requisition, stores the
///              id and runs the one-shot effect. Returns whether it built.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _region_index
/// @param {String} _id
/// @returns {Bool}
function region_building_build(_star, _planet, _region_index, _id) {
    var _def = region_building_def(_id);
    if (_def == undefined) {
        return false;
    }
    var _region = region_get(_star, _planet, _region_index);
    region_buildings_ensure(_region);
    if (!region_building_can_build(_star, _planet, _region, _def)) {
        return false;
    }
    var _price = region_building_price(_star, _planet, _def);
    if (obj_controller.requisition < _price) {
        return false;
    }
    obj_controller.requisition -= _price;
    array_push(_region.buildings, _id);
    if (is_callable(_def.apply)) {
        _def.apply(_star, _planet, _region);
    }
    return true;
}

/// @function regions_buildings_tick
/// @description Runs every building's per-turn effect for regions the player holds on this planet.
///              Called once per planet per turn from scr_star_ownership's real (argument0) pass.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function regions_buildings_tick(_star, _planet) {
    var _regions = regions_ensure(_star, _planet);
    for (var r = 0, rl = array_length(_regions); r < rl; r++) {
        var _region = _regions[r];
        if (_region.owner != eFACTION.PLAYER) {
            continue;
        }
        region_buildings_ensure(_region);
        for (var b = 0, bl = array_length(_region.buildings); b < bl; b++) {
            var _def = region_building_def(_region.buildings[b]);
            if ((_def != undefined) && is_callable(_def.on_turn)) {
                _def.on_turn(_star, _planet, _region);
            }
        }
    }
}

/// @function regions_player_requisition_income
/// @description Total per-turn requisition produced by region buildings the player holds across the
///              whole sector (Factory +4, Mine +3, ... any def with a numeric `req`). Summed into the
///              displayed Requisition income (scr_income -> income_regions) so it appears in the
///              top-left counter breakdown and is paid WITH the rest of the turn's income, instead of
///              being added after the fact directly to the requisition pool.
/// @returns {Real}
function regions_player_requisition_income() {
    var _total = 0;
    with (obj_star) {
        for (var _p = 1; _p <= planets; _p++) {
            var _regions = regions_ensure(id, _p);
            for (var r = 0, rl = array_length(_regions); r < rl; r++) {
                var _region = _regions[r];
                if (_region.owner != eFACTION.PLAYER) {
                    continue;
                }
                region_buildings_ensure(_region);
                for (var b = 0, bl = array_length(_region.buildings); b < bl; b++) {
                    var _def = region_building_def(_region.buildings[b]);
                    if ((_def != undefined) && variable_struct_exists(_def, "req") && is_real(_def.req)) {
                        _total += _def.req;
                    }
                }
            }
        }
    }
    return _total;
}

/// @function region_player_fleet_lose_ship
/// @description Destroys one ship in a player fleet, lightest first, the way space combat does:
///              find a live ship id in the count arrays, mark its hp 0, and drop the alive-count.
///              Scans for a valid live ship id so it never zeroes an empty array slot. Returns
///              whether a ship was destroyed.
/// @param {Id.Instance.obj_p_fleet} _fleet
/// @returns {Bool}
function region_player_fleet_lose_ship(_fleet) {
    var _tiers = [
        ["escort_num", "escort_number"],
        ["frigate_num", "frigate_number"],
        ["capital_num", "capital_number"],
    ];
    for (var t = 0; t < array_length(_tiers); t++) {
        var _arr_name = _tiers[t][0];
        var _count_name = _tiers[t][1];
        var _count = variable_instance_get(_fleet, _count_name);
        if (is_real(_count) && (_count > 0)) {
            var _arr = variable_instance_get(_fleet, _arr_name);
            if (is_array(_arr)) {
                for (var i = 0, l = array_length(_arr); i < l; i++) {
                    var _sid = _arr[i];
                    if (is_real(_sid) && (_sid > 0) && (_sid < array_length(obj_ini.ship_hp)) && (obj_ini.ship_hp[_sid] > 0)) {
                        obj_ini.ship_hp[_sid] = 0;
                        variable_instance_set(_fleet, _count_name, _count - 1);
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

/// @function regions_orbital_guns_tick
/// @description Fires every Anti-Orbital Gun on the planet once per turn. The gun serves WHOEVER
///              holds its region (region-based, not planet-based): a player/Imperial-held gun kills
///              a hostile enemy ship in orbit; a gun on a region the enemy has captured turns on the
///              player's fleet (the double-edged sword). Runs for all owners, so call it separately
///              from the player-only regions_buildings_tick.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function regions_orbital_guns_tick(_star, _planet) {
    var _regions = regions_ensure(_star, _planet);
    for (var r = 0, rl = array_length(_regions); r < rl; r++) {
        var _region = _regions[r];
        region_buildings_ensure(_region);
        if (region_building_count(_region, "anti_orbital_gun") <= 0) {
            continue;
        }

        region_gun_mastery_ensure(_region);

        if (!region_faction_is_hostile(_region.owner)) {
            // Held by the player / an Imperial faction: the world is clear of any cult, so any
            // learned mastery is lost. The gun serves whoever holds it.
            _region.gun_mastered = false;
            var _gun_owner = _region.owner;
            with (obj_en_fleet) {
                if (orbiting == _star) {
                    // A PLAYER-held gun fires from the PLAYER'S perspective: it hits anyone the player
                    // is NOT allied with (and never the player). So once the Chapter is declared
                    // Renegade and the Imperial factions drop from "Allied" to "War", their ships in
                    // orbit become valid targets too, while any faction the player has allied with
                    // (faction_status == "Allied") is spared. An Imperial NPC-held gun still fires on
                    // the Imperium's enemies as before.
                    var _hostile;
                    if (_gun_owner == eFACTION.PLAYER) {
                        _hostile = (owner > eFACTION.PLAYER) && (obj_controller.faction_status[owner] != "Allied");
                    } else {
                        _hostile = region_faction_is_hostile(owner);
                    }
                    if (_hostile) {
                        // obj_en_fleet/Step_0 clamps counts and destroys emptied fleets, so a plain
                        // decrement is safe (the game itself decrements these directly).
                        if (escort_number > 0) {
                            escort_number -= 1;
                        } else if (frigate_number > 0) {
                            frigate_number -= 1;
                        } else if (capital_number > 0) {
                            capital_number -= 1;
                        }
                        break;
                    }
                }
            }
        } else {
            // The enemy holds this region: the captured gun fires on the player's fleet -- but only
            // if the occupier can work human tech.
            var _owner = _region.owner;
            var _is_cult = (_owner == eFACTION.GENESTEALER)
                || ((_owner == eFACTION.TYRANIDS) && planet_feature_bool(_star.p_feature[_planet], eP_FEATURES.GENE_STEALER_CULT));
            var _pure_nid = (_owner == eFACTION.TYRANIDS) && !_is_cult;

            var _can_fire = true;
            if (_pure_nid) {
                // Mindless Tyranids can never operate it.
                _can_fire = false;
                _region.gun_mastered = false;
            } else if (_is_cult) {
                // A Genestealer Cult must first work out how to fire it (a chance each turn). Once it
                // does, it keeps firing every turn UNTIL driven off this region (then the mastery is
                // cleared above, and a future cult has to relearn it).
                if (_region.gun_mastered) {
                    _can_fire = true;
                } else if (irandom(99) < 50) {
                    _region.gun_mastered = true;
                    _can_fire = true;
                } else {
                    _can_fire = false;
                }
            } else {
                // Any other hostile faction (Chaos, Orks, Tau, Necrons, ...) works it normally.
                _region.gun_mastered = false;
            }

            if (_can_fire) {
                with (obj_p_fleet) {
                    if (orbiting == _star) {
                        region_player_fleet_lose_ship(id);
                        break;
                    }
                }
            }
        }
    }
}

/// @function region_candidate_station_bonus
/// @description Extra recruitment screening points a planet's player-held Candidate Stations grant.
///              Read by PlanetData.get_local_apothecary_points so recruitment success rises WITHOUT
///              tying up apothecaries. 15 points per station (tunable).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Real}
function region_candidate_station_bonus(_star, _planet) {
    var _regions = regions_ensure(_star, _planet);
    var _bonus = 0;
    for (var r = 0, rl = array_length(_regions); r < rl; r++) {
        if (_regions[r].owner == eFACTION.PLAYER) {
            _bonus += region_building_count(_regions[r], "candidate_station") * 15;
        }
    }
    return _bonus;
}

/// @function region_buildings_summary
/// @description Short "Bastion x2, Manufactorum" style summary of a region's built buildings.
/// @param {Struct.Region} _region
/// @returns {String}
function region_buildings_summary(_region) {
    region_buildings_ensure(_region);
    if (array_length(_region.buildings) == 0) {
        return "none";
    }
    var _ids = [];
    var _counts = [];
    for (var i = 0, l = array_length(_region.buildings); i < l; i++) {
        var _id = _region.buildings[i];
        var _idx = -1;
        for (var j = 0, jl = array_length(_ids); j < jl; j++) {
            if (_ids[j] == _id) {
                _idx = j;
                break;
            }
        }
        if (_idx < 0) {
            array_push(_ids, _id);
            array_push(_counts, 1);
        } else {
            _counts[_idx]++;
        }
    }
    var _s = "";
    for (var i = 0, l = array_length(_ids); i < l; i++) {
        var _def = region_building_def(_ids[i]);
        var _nm = (_def != undefined) ? _def.name : _ids[i];
        if (i > 0) {
            _s += ", ";
        }
        _s += _nm + ((_counts[i] > 1) ? (" x" + string(_counts[i])) : "");
    }
    return _s;
}

/// @function draw_region_build_widget
/// @description Compact build tile: building name, a small holo icon, and a "<cost> req" button.
///              Deliberately smaller than the shared draw_building_builder so the label stays
///              readable in the construction grid. Returns true when clicked while affordable.
/// @param {Real} _cx Tile left (GUI x).
/// @param {Real} _cy Tile top (GUI y).
/// @param {Real} _cell_w Tile width.
/// @param {Struct} _def Catalogue entry.
/// @returns {Bool}
function draw_region_build_widget(_cx, _cy, _cell_w, _def, _star, _planet) {
    var _cxc = _cx + (_cell_w * 0.5);
    var _afford = obj_controller.requisition >= region_building_price(_star, _planet, _def);

    // Name (wraps to at most two lines).
    draw_set_font(fnt_40k_14);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_text_ext(_cxc, _cy, _def.name, -1, _cell_w - 6);

    // Small centred holo icon.
    var _scale = 0.28;
    var _sw = sprite_get_width(_def.sprite) * _scale;
    draw_sprite_ext(_def.sprite, 0, _cxc - (_sw * 0.5), _cy + 30, _scale, _scale, 0, c_white, 1);

    // "<cost> req" button.
    var _bx1 = _cx + 6;
    var _bx2 = _cx + _cell_w - 6;
    var _by = _cy + 70;
    var _hover = scr_hit(_bx1, _by, _bx2, _by + 18);
    draw_set_alpha(_afford ? (_hover ? 0.55 : 0.32) : 0.12);
    draw_set_color(_afford ? c_green : c_gray);
    draw_rectangle(_bx1, _by, _bx2, _by + 18, false);
    draw_set_alpha(1);
    draw_set_color(c_dkgray);
    draw_rectangle(_bx1, _by, _bx2, _by + 18, true);
    draw_set_color(_afford ? c_white : c_gray);
    draw_set_halign(fa_center);
    draw_text(_cxc, _by + 2, string(region_building_price(_star, _planet, _def)) + " req");

    return (_afford && _hover && mouse_button_clicked());
}

/// @function draw_region_construction_panel
/// @description Construction box drawn under the regions panel. Shows the focused region's built
///              buildings and, if the player holds it, a grid of compact holo build tiles for every
///              building this world can support. Clicking a tile builds it for requisition. Call
///              from a Draw GUI event.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _px
/// @param {Real} _py
/// @returns {Undefined}
function draw_region_construction_panel(_star, _planet, _px, _py) {
    var _focus = region_focus_get(_star, _planet);
    var _region = region_get(_star, _planet, _focus);
    // Licensed regions build exactly like owned ones (the can-build gate already lets
    // the full set through); the panel treats both as buildable.
    var _licensed = (!_region.is_capital) && region_is_licensed(_region);
    var _owned = (_region.owner == eFACTION.PLAYER) || _licensed;

    var _w = 300;
    var _cols = 3;
    var _cell_w = 96;
    var _cell_h = 96;
    var _head_h = 50;

    // Collect the buildings this region can currently build.
    var _options = [];
    if (_owned) {
        var _cat = region_building_catalogue();
        for (var i = 0, l = array_length(_cat); i < l; i++) {
            var _def = _cat[i];
            if (region_building_can_build(_star, _planet, _region, _def)) {
                array_push(_options, _def);
            }
        }
    }

    var _rows = (array_length(_options) > 0) ? ceil(array_length(_options) / _cols) : 0;
    var _h = _owned ? (_head_h + (_rows * _cell_h) + 10) : (_head_h + 18);

    // Background + border.
    draw_set_alpha(0.85);
    draw_set_color(c_black);
    draw_rectangle(_px, _py, _px + _w, _py + _h, false);
    draw_set_alpha(1);
    draw_set_color(c_dkgray);
    draw_rectangle(_px, _py, _px + _w, _py + _h, true);

    // Header.
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    var _hdr = "Construction - " + _region.name;
    if (_licensed && (_region.owner != eFACTION.PLAYER)) {
        _hdr += " [Licensed]";
    }
    draw_text(_px + 10, _py + 6, _hdr);
    draw_set_color(c_dkgray);
    draw_line(_px + 6, _py + 26, _px + _w - 6, _py + 26);
    draw_set_font(fnt_40k_14);

    if (!_owned) {
        draw_set_color(c_ltgray);
        if (region_can_license(_star, _planet, _focus)) {
            draw_text_ext(_px + 10, _py + 32, $"Buy a Construction License ({REGION_BUILD_LICENSE_COST} req, Population screen) to build here before you own it.", -1, _w - 20);
        } else {
            draw_text_ext(_px + 10, _py + 32, "Control this region to build here.", -1, _w - 20);
        }
        draw_set_color(c_black);
        draw_set_font(fnt_40k_14b);
        return;
    }

    // Built summary.
    draw_set_color(c_gray);
    draw_text(_px + 10, _py + 30, "Built: " + region_buildings_summary(_region));

    // Buildable grid of compact holo tiles (small icon so the label stays readable).
    var _grid_y = _py + _head_h;
    for (var i = 0, l = array_length(_options); i < l; i++) {
        var _def = _options[i];
        var _cx = _px + 4 + ((i mod _cols) * _cell_w);
        var _cy = _grid_y + ((i div _cols) * _cell_h);

        if (draw_region_build_widget(_cx, _cy, _cell_w, _def, _star, _planet)) {
            region_building_build(_star, _planet, _focus, _def.id);
        }

        // Tooltip over the tile's name/icon (kept clear of the build button).
        if (scr_hit(_cx, _cy, _cx + _cell_w, _cy + 66)) {
            tooltip_draw(_def.desc, 300);
        }
    }

    // Restore default draw state.
    draw_set_font(fnt_40k_14b);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_set_alpha(1);
}

#endregion



/// @function count_to_level_anchors
/// @description The population anchor table count_to_level uses for a faction, or -1 for factions
///              without a population model. Shared so the war-loss clamp below can invert the mapping.
function count_to_level_anchors(_faction) {
    switch (_faction) {
        case eFACTION.ORK:      return [0, 100, 350, 1000, 3600, 7000, 11000];
        case eFACTION.NECRONS:  return [0, 5000, 20000, 60000, 150000, 400000, 800000];
        case eFACTION.HERETICS: return [0, 10000, 50000, 200000, 1000000, 5000000, 20000000];
        case eFACTION.TYRANIDS: return [0, 50000, 200000, 1000000, 5000000, 20000000, 80000000];
    }
    return -1;
}

/// @function faction_pop_clamp_to_level
/// @description WAR LOSSES MUST KILL PEOPLE, not just the 0-6 scalar. Player-driven kills (bombardment,
///              ground battle victories, sector directive strikes) historically wrote only the legacy
///              level arrays; the population engine then re-derived the level from the untouched
///              p_race_pop next tick and the enemy "respawned" (figherhigher's bombed-clean planets).
///              Call this after any such level write: it clamps the faction's real headcount into the
///              band of the level just written (level 0 = annihilated here). The AI-vs-AI resolver
///              already does its own pop accounting; this covers the player-facing paths.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _faction
/// @returns {Undefined}
function faction_pop_clamp_to_level(_star, _planet, _faction) {
    if (!instance_exists(_star) || !variable_instance_exists(_star, "p_race_pop")) { return; }
    var _anchors = count_to_level_anchors(_faction);
    if (_anchors == -1) { return; }
    var _lvl = 0;
    switch (_faction) {
        case eFACTION.ORK:      _lvl = _star.p_orks[_planet]; break;
        case eFACTION.NECRONS:  _lvl = _star.p_necrons[_planet]; break;
        case eFACTION.TYRANIDS: _lvl = _star.p_tyranids[_planet]; break;
        case eFACTION.HERETICS: _lvl = _star.p_traitors[_planet]; break;
    }
    _lvl = clamp(_lvl, 0, 6);
    if (_lvl <= 0) {
        _star.p_race_pop[_planet][_faction] = 0;
    } else if (_lvl < 6) {
        _star.p_race_pop[_planet][_faction] = min(_star.p_race_pop[_planet][_faction], _anchors[_lvl + 1] - 1);
    }
}

/// @function beacon_teardown_if_cleansed
/// @description The Ascension Beacon falls with the swarm: whenever a path zeroes the world's
///              tyranid presence (liberation, ground reconquest, bombardment), the beacon is
///              dismantled so ascended worlds are fully reclaimable. Without this the feature
///              was indestructible, permanently marking (and re-gating) cleansed worlds.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function beacon_teardown_if_cleansed(_star, _planet) {
    if (!instance_exists(_star)) { return; }
    if (_star.p_tyranids[_planet] > 0) { return; }
    try {
        var _pdb = _star.get_planet_data(_planet);
        if (is_struct(_pdb) && _pdb.has_feature(eP_FEATURES.ASCENSION_BEACON)) {
            _pdb.delete_feature(eP_FEATURES.ASCENSION_BEACON);
            scr_event_log("green", $"The Ascension Beacon on {_star.name} {scr_roman(_planet)} is torn down.", _star.name);
        }
    } catch (_e) {}
}

/// @function region_is_licensed
/// @description Reads a region's Construction License flag, tolerating region structs
///              deserialized from saves made before the field existed (plain-data structs
///              restore without it, and reading a missing key returns undefined, which is
///              not a valid boolean in GML). Missing = not licensed.
/// @param {Struct.Region} _region
/// @returns {Bool}
function region_is_licensed(_region) {
    return is_struct(_region) && variable_struct_exists(_region, "build_licensed") && _region.build_licensed;
}

/// @function region_can_license
/// @description Whether the focused region may have a Construction License bought for it:
///              an OUTLYING region (never the capital) that the player does not already
///              own and has not already licensed. The capital stays locked until conquest.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _index
/// @returns {Bool}
function region_can_license(_star, _planet, _index) {
    var _region = region_get(_star, _planet, _index);
    if (!is_struct(_region)) {
        return false;
    }
    if (_region.is_capital) {
        return false;
    }
    if (_region.owner == eFACTION.PLAYER) {
        return false;
    }
    if (region_is_licensed(_region)) {
        return false;
    }
    return true;
}

/// @function region_grant_license
/// @description Marks the focused region as licensed for construction. Caller charges the
///              requisition (the population-screen PurchaseButton does). Returns true on
///              success, false if the region cannot be licensed.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Real} _index
/// @returns {Bool}
function region_grant_license(_star, _planet, _index) {
    if (!region_can_license(_star, _planet, _index)) {
        return false;
    }
    region_get(_star, _planet, _index).build_licensed = true;
    return true;
}

/// @function region_building_price
/// @description The requisition price of a building here: the world's DISPOSITION toward
///              the Chapter discounts construction (the locals subsidise their
///              protectors), scaling linearly to REGION_BUILD_INFLUENCE_DISCOUNT_MAX at
///              100 disposition. dispo is the stat the game actually tracks for player
///              standing (tithes at >= 100, the world flip); the first version read a
///              p_influence slot nothing ever writes, so no discount ever applied.
///              Player-owned worlds sit at 100 = full discount.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @param {Struct} _def
/// @returns {Real}
function region_building_price(_star, _planet, _def) {
    var _standing = clamp(_star.dispo[_planet], 0, 100);
    var _disc = REGION_BUILD_INFLUENCE_DISCOUNT_MAX * (_standing / 100);
    return max(1, round(_def.cost * (1 - _disc)));
}

/// @function heresy_cleansed_stamp
/// @description Called when a heretic/chaos hold on a world is broken (liberation or ground
///              reconquest at force 0): cuts the world's corruption by
///              HERETIC_CLEANSE_CORRUPTION_CUT (the revolt spent the cult's networks) and
///              stamps a reseed cooldown so the concealment tick cannot sprout a fresh cult
///              immediately into the battle-drained garrison (the every-turn revolt loop).
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function heresy_cleansed_stamp(_star, _planet) {
    if (!instance_exists(_star)) { return; }
    if (!variable_instance_exists(_star, "p_heresy_cleansed_turn")) {
        _star.p_heresy_cleansed_turn = array_create(_star.planets + 1, -9999);
    }
    _star.p_heresy_cleansed_turn[_planet] = obj_controller.turn;
    // corruption on PlanetData is a constructor-time COPY of p_heresy: the cut must
    // hit the backing star array or it evaporates on the next panel rebuild.
    _star.p_heresy[_planet] = max(0, _star.p_heresy[_planet] - HERETIC_CLEANSE_CORRUPTION_CUT);
    try {
        var _pdc = _star.get_planet_data(_planet);
        if (is_struct(_pdc)) {
            _pdc.corruption = _star.p_heresy[_planet];
        }
    } catch (_e) {}
}
