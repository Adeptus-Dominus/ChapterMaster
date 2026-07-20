/// @function Region
/// @description Plain-data record for a single region of a planet.
///              Regions are stored per planet in obj_star.p_regions[planet] and persist
///              automatically through the generic p_* save/load path (see obj_star Create).
///              IMPORTANT: keep this a DATA record. On load, saved regions come back as plain
///              structs WITHOUT constructor methods, so all region behaviour lives in
///              scr_region_functions and reads/writes these fields directly. Do not rely on
///              instanceof/methods for regions elsewhere.
/// @param {String} _name Region display name.
/// @param {Bool} _is_capital Whether this is the planetary capital region.
/// @param {Enum.eFACTION} _owner Controlling faction of this region.
/// @returns {Struct.Region}
function Region(_name = "Region", _is_capital = false, _owner = eFACTION.IMPERIUM) constructor {
    name = _name;
    is_capital = _is_capital;

    // Ownership. Contested worlds arise when regions of the same planet have different owners.
    owner = _owner;
    first_owner = _owner;

    // Demographics (share of the planet total; see regions_generate / regions_rollup).
    population = 0;
    max_population = 0;

    // Garrison this region can field.
    pdf = 0;
    guardsmen = 0;

    // 0-5 "problem" strength for non-Imperial owners (orks/tau/nids/etc.), mirroring the
    // per-faction planet arrays (p_orks, p_tau, ...).
    force_level = 0;

    // Defensive depth. fortification 0-5 (walls/bunkers), defences = ground turret batteries.
    fortification = 0;
    defences = 0;

    // Buildings/upgrades constructed in this region (array of eP_FEATURES values).
    upgrades = [];

    // Player-constructed region buildings (Sector Governor building tree). Array of string ids
    // from region_building_catalogue (see scr_region_functions). Separate from `upgrades` so it
    // never mixes with the eP_FEATURES machinery. Persists as part of this struct in p_regions.
    buildings = [];

    // Whether the current occupier has worked out how to fire a captured Anti-Orbital Gun here.
    // Only Genestealer Cults ever set this; it is cleared when the region leaves cult hands.
    gun_mastered = false;

    // Construction License (Sector Governor): when true, the player may build the full
    // region building set here even though they do NOT own the region yet, at the normal
    // disposition-discounted price. Bought per region from the population screen (500 req,
    // outlying regions only). A partial game-starter: raise a factory or barracks on a
    // world before you have conquered it. Persists as part of this struct in p_regions.
    build_licensed = false;
}
