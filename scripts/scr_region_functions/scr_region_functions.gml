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
/// @description Recomputes the legacy planet-level scalars from the region list so all existing
///              non-region-aware code keeps reading correct values. Call after any region change.
///              Population/pdf/guardsmen sum; fortification/defences take the max; the planet
///              owner is the capital's owner; upgrades are the union across regions.
///              NOTE: the per-faction level arrays (p_orks, p_tau, ...) are intentionally NOT
///              rewritten here to avoid disturbing existing balance; a dedicated faction mapping
///              will be added when invasion/combat are migrated to regions.
/// @param {Id.Instance.obj_star} _star
/// @param {Real} _planet
/// @returns {Undefined}
function regions_rollup(_star, _planet) {
    var _regions = regions_ensure(_star, _planet);
    var _n = array_length(_regions);
    if (_n <= 0) {
        return;
    }

    var _population = 0;
    var _max_population = 0;
    var _pdf = 0;
    var _guardsmen = 0;
    var _fortified = 0;
    var _defences = 0;
    var _capital_owner = _regions[0].owner;
    var _upgrades = [];

    for (var i = 0; i < _n; i++) {
        var _region = _regions[i];
        _population += _region.population;
        _max_population += _region.max_population;
        _pdf += _region.pdf;
        _guardsmen += _region.guardsmen;
        _fortified = max(_fortified, _region.fortification);
        _defences = max(_defences, _region.defences);
        if (_region.is_capital) {
            _capital_owner = _region.owner;
        }
        if (is_array(_region.upgrades)) {
            for (var u = 0, ul = array_length(_region.upgrades); u < ul; u++) {
                if (!array_contains(_upgrades, _region.upgrades[u])) {
                    array_push(_upgrades, _region.upgrades[u]);
                }
            }
        }
    }

    _star.p_population[_planet] = _population;
    _star.p_max_population[_planet] = _max_population;
    _star.p_pdf[_planet] = _pdf;
    _star.p_guardsmen[_planet] = _guardsmen;
    _star.p_fortified[_planet] = _fortified;
    _star.p_defenses[_planet] = _defences;
    _star.p_owner[_planet] = _capital_owner;
    _star.p_upgrades[_planet] = _upgrades;
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

        // Defences / garrison on the right.
        draw_set_halign(fa_right);
        draw_set_color(c_ltgray);
        draw_text(_row_x2 - 2, _ry, "Fort: " + _forti_names[clamp(_region.fortification, 0, 6)]);
        draw_text(_row_x2 - 2, _ry + 16, $"Def: {_region.defences}   Gar: {_region.pdf + _region.guardsmen}");
        draw_set_halign(fa_left);

        // Click an outlying region to set it as the conquest focus.
        if (_selectable && point_and_click([_rx - 2, _ry - 2, _row_x2, _row_y2])) {
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
            apply: function(_star, _planet, _region) { _region.fortification = min(5, _region.fortification + 1); },
            on_turn: undefined,
        },
        {
            id: "turret_battery", name: "Turret Battery", sprite: spr_holo_pad, cost: 1000, max: 5, types: "all",
            desc: "Ground weapon emplacements. +1 defences. Ground down as the region is captured.",
            apply: function(_star, _planet, _region) { _region.defences = min(10, _region.defences + 1); },
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
            on_turn: function(_star, _planet, _region) { obj_controller.requisition += 4; },
        },
        {
            id: "mine", name: "Mine", sprite: spr_def_mine, cost: 1500, max: 1, types: ["Desert", "Ice", "Lava", "Dead", "Death"],
            desc: "Resource extraction. +3 requisition each turn while you hold this region.",
            apply: undefined,
            on_turn: function(_star, _planet, _region) { obj_controller.requisition += 3; },
        },
        {
            id: "industrial_farm", name: "Industrial Farms", sprite: spr_holo_pad, cost: 1200, max: 1, types: ["Agri", "Temperate", "Feudal"],
            desc: "Mechanised agriculture. Grows the region's population toward its maximum each turn.",
            apply: undefined,
            on_turn: function(_star, _planet, _region) {
                _region.population = min(_region.max_population, _region.population + max(1, round(_region.population * 0.01)));
            },
        },
        {
            id: "pdf_barracks", name: "PDF Barracks", sprite: spr_holo_pad, cost: 1000, max: 1, types: "all",
            desc: "Trains local Planetary Defence Force. +200 PDF each turn while you hold this region.",
            apply: undefined,
            on_turn: function(_star, _planet, _region) { _region.pdf += 200; },
        },
        {
            id: "guard_barracks", name: "Guard Barracks", sprite: spr_holo_pad, cost: 1500, max: 1, types: "all",
            desc: "Raises Astra Militarum. +100 Guardsmen each turn while you hold this region.",
            apply: undefined,
            on_turn: function(_star, _planet, _region) { _region.guardsmen += 100; },
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
                            _unit.add_exp(10);
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
    if (obj_controller.requisition < _def.cost) {
        return false;
    }
    obj_controller.requisition -= _def.cost;
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
            // learned mastery is lost, and the gun shoots a hostile enemy fleet in orbit.
            _region.gun_mastered = false;
            with (obj_en_fleet) {
                if ((orbiting == _star) && region_faction_is_hostile(owner)) {
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
function draw_region_build_widget(_cx, _cy, _cell_w, _def) {
    var _cxc = _cx + (_cell_w * 0.5);
    var _afford = obj_controller.requisition >= _def.cost;

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
    draw_text(_cxc, _by + 2, string(_def.cost) + " req");

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
    var _owned = (_region.owner == eFACTION.PLAYER);

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
    draw_text(_px + 10, _py + 6, "Construction - " + _region.name);
    draw_set_color(c_dkgray);
    draw_line(_px + 6, _py + 26, _px + _w - 6, _py + 26);
    draw_set_font(fnt_40k_14);

    if (!_owned) {
        draw_set_color(c_ltgray);
        draw_text_ext(_px + 10, _py + 32, "Control this region to build here.", -1, _w - 20);
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

        if (draw_region_build_widget(_cx, _cy, _cell_w, _def)) {
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
